if (player != player getVariable ["owner",objNull]) exitWith {hint "You cannot construct anything while controlling AI"};

private _engineerX = objNull;

{if (_x getUnitTrait "engineer") exitWith {_engineerX = _x}} forEach units group player;

if (isNull _engineerX) exitWith {hint "Your squad needs an engineer to be able to construct"};
if ((player != _engineerX) and (isPlayer _engineerX)) exitWith {hint "There is a human player engineer in your squad, ask him to construct whatever you need"};
if ((player != leader player) and (_engineerX != player)) exitWith {hint "Only squad leaders can ask engineers to construct something"};
if !([_engineerX] call A3A_fnc_canFight) exitWith {hint "Your Engineer is dead or incapacitated and cannot construct anything"};
if ((_engineerX getVariable ["helping",false]) or (_engineerX getVariable ["rearming",false]) or (_engineerX getVariable ["constructing",false])) exitWith {hint "Your engineer is currently performing another action"};

private _typeX = _this select 0;
private _dir = getDir player;
private _positionX = position player;
private _costs = 0;
private _timeX = 60;
private _classX = "";
switch _typeX do
	{
	case "ST":
		{
		if (count (nearestTerrainObjects [player, ["House"], 70]) > 3) then
			{
			_classX = selectRandom ["Land_GarbageWashingMachine_F","Land_JunkPile_F","Land_Barricade_01_4m_F"];
			}
		else
			{
			if (count (nearestTerrainObjects [player,["tree"],70]) > 8) then
				{
				_classX = "Land_WoodPile_F";
				}
			else
				{
				_classX = "CraterLong_small";
				};
			};
		};
	case "MT":
		{
		_timeX = 60;
		if (count (nearestTerrainObjects [player, ["House"], 70]) > 3) then
			{
			_classX = "Land_Barricade_01_10m_F";
			}
		else
			{
			if (count (nearestTerrainObjects [player,["tree"],70]) > 8) then
				{
				_classX = "Land_WoodPile_large_F";
				}
			else
				{
				_classX = selectRandom ["Land_BagFence_01_long_green_F","Land_SandbagBarricade_01_half_F"];
				};
			};
		};
	case "RB":
		{
		_timeX = 100;
		if (count (nearestTerrainObjects [player, ["House"], 70]) > 3) then
			{
			_classX = "Land_Tyres_F";
			}
		else
			{
			_classX = "Land_TimberPile_01_F";
			};
		};
	case "SB":
		{
		_timeX = 60;
		_classX = "Land_BagBunker_01_small_green_F";
		_costs = 100;
		};
	case "CB":
		{
		_timeX = 120;
		_classX = "Land_PillboxBunker_01_big_F";
		_costs = 300;
		};
	};

//if ((_typeX == "RB") and !(isOnRoad _positionX)) exitWith {hint "Please select this option on a road segment"};

private _leave = false;
private _textX = "";
if ((_typeX == "SB") or (_typeX == "CB")) then
	{
	if (_typeX == "SB") then {_dir = _dir + 180};
	_resourcesFIA = if (!isMultiPlayer) then {server getVariable "resourcesFIA"} else {player getVariable "moneyX"};
	if (_costs > _resourcesFIA) then
		{
		_leave = true;
		_textX = format ["You do not have enough money for this construction (%1 € needed)",_costs]
		}
	else
		{
		_sites = markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
		nearX = [_sites,_positionX] call BIS_fnc_nearestPosition;
		if (!(_positionX inArea nearX)) then
			{
			_leave = true;
			_textX = "You cannot build a bunker outside a controlled zone";
			nearX = nil;
			};
		};
	};

if (_leave) exitWith {hint format ["%1",_textX]};
hint "Select a place to build the required asset and press SPACE to start the construction.\n\nHit ESC to exit";
garageVeh = _classX createVehicleLocal [0,0,0];
bought = 0;

_displayEH = (findDisplay 46) displayAddEventHandler ["KeyDown",
		{
		_handled = false;
		if (_this select 1 == 1) then
			{
			bought = 1;
			_handled = true;
			}
		else
			{
			if (_this select 1 == 57) then
				{
				if (getPosASL garageVeh isEqualTo [0,0,0]) then
					{
					hint "You have selected a wrong place. Please note:\n\nRoadblocks have to be built in road segments.\n\nBunkers have to be built in garrison zones";
					}
				else
					{
					bought = 2;
					};
				};
			};
		_handled;
		}];

_HDEH = player addEventHandler ["HandleDamage",{bought = 1}];
positionXSel = [0,0,0];
if (_typeX == "RB") then
	{
	onEachFrame
	 {
	 if !(isNull garageVeh) then
	  {
	  _ins = lineIntersectsSurfaces [
	    AGLToASL positionCameraToWorld [0,0,0],
	    AGLToASL positionCameraToWorld [0,0,1000],
	    player,garageVeh
	   ];
	   if (_ins isEqualTo []) exitWith {};
	   _pos = (_ins select 0 select 0);
	   if (_pos distance positionXSel < 0.1) exitWith {};
	   positionXSel = _pos;
	   if (count (_pos findEmptyPosition [0, 0, typeOf garageVeh])== 0) exitWith {garageVeh setPosASL [0,0,0]};
	   if (_pos distance2d player > 100)exitWith {garageVeh setPosASL [0,0,0]};
	   if (surfaceIsWater _pos) exitWith {garageVeh setPosASL [0,0,0]};
	   if !(isOnRoad ASLToAGL _pos) exitWith {garageVeh setPosASL [0,0,0]};
	   garageVeh setPosASL _pos;
	   garageVeh setVectorUp (_ins select 0 select 1);
	   garageVeh setDir (getDir player);
	   };
	 };
	}
else
	{
	if ((_typeX == "SB") or (_typeX == "CB")) then
		{
		onEachFrame
		 {
		 if !(isNull garageVeh) then
		  {
		  _ins = lineIntersectsSurfaces [
		    AGLToASL positionCameraToWorld [0,0,0],
		    AGLToASL positionCameraToWorld [0,0,1000],
		    player,garageVeh
		   ];
		   if (_ins isEqualTo []) exitWith {};
		   _pos = (_ins select 0 select 0);
		   if (_pos distance positionXSel < 0.1) exitWith {};
		   positionXSel = _pos;
		   if (count (_pos findEmptyPosition [0, 0, typeOf garageVeh])== 0) exitWith {garageVeh setPosASL [0,0,0]};
		   if (_pos distance2d player > 100)exitWith {garageVeh setPosASL [0,0,0]};
		   if (surfaceIsWater _pos) exitWith {garageVeh setPosASL [0,0,0]};
		   if (isOnRoad ASLToAGL _pos) exitWith {garageVeh setPosASL [0,0,0]};
		   if !(_pos inArea nearX) exitWith {garageVeh setPosASL [0,0,0]};
		   garageVeh setPosASL _pos;
		   garageVeh setVectorUp (_ins select 0 select 1);
		   garageVeh setDir (getDir player);
		   };
		 };
		}
	else
		{
		onEachFrame
		 {
		 if !(isNull garageVeh) then
		  {
		  _ins = lineIntersectsSurfaces [
		    AGLToASL positionCameraToWorld [0,0,0],
		    AGLToASL positionCameraToWorld [0,0,1000],
		    player,garageVeh
		   ];
		   if (_ins isEqualTo []) exitWith {};
		   _pos = (_ins select 0 select 0);
		   if (_pos distance positionXSel < 0.1) exitWith {};
		   positionXSel = _pos;
		   if (count (_pos findEmptyPosition [0, 0, typeOf garageVeh])== 0) exitWith {garageVeh setPosASL [0,0,0]};
		   if (_pos distance2d player > 100)exitWith {garageVeh setPosASL [0,0,0]};
		   if (surfaceIsWater _pos) exitWith {garageVeh setPosASL [0,0,0]};
		   garageVeh setPosASL _pos;
		   garageVeh setVectorUp (_ins select 0 select 1);
		   garageVeh setDir (getDir player);
		   };
		 };
		};
	};

private _timeOut = time + 60;
waitUntil {(bought > 0) or (time > _timeOut)};

onEachFrame {};
(findDisplay 46) displayRemoveEventHandler ["KeyDown", _displayEH];
player removeEventHandler ["HandleDamage",_HDEH];
positionXSel = nil;
//_positionX = getPosASL veh;
_positionX = position garageVeh;
_dir = getDir garageVeh;
deleteVehicle garageVeh;
garageVeh = nil;
nearX = nil;
if (bought <= 1) exitWith {hint "Construction cancelled"; bought = nil};
bought = nil;
private _isPlayer = if (player == _engineerX) then {true} else {false};
_timeOut = time + 30;

if (!_isPlayer) then
	{
	_engineerX doMove ASLToAGL _positionX
	}
else
	{
	_timeX = _timeX / 2;
	hint "Walk to the selected position to start building";
	};

waitUntil {sleep 1;(time > _timeOut) or (_engineerX distance _positionX < 3)};

if (time > _timeOut) exitWith {};

if (_costs > 0) then
	{
	if (!isMultiPlayer) then
		{
		_nul = [0, - _costs] remoteExec ["A3A_fnc_resourcesFIA",2];
		}
	else
		{
		[-_costs] call A3A_fnc_resourcesPlayer;
		["moneyX",player getVariable ["moneyX",0]] call fn_SaveStat;
		};
	};

_engineerX setVariable ["constructing",true];

_timeOut = time + _timeX;

if (!_isPlayer) then
	{
	{_engineerX disableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
	};

//_animation = selectRandom ["AinvPknlMstpSnonWnonDnon_medic_1","AinvPknlMstpSnonWnonDnon_medic0","AinvPknlMstpSnonWnonDnon_medic1","AinvPknlMstpSnonWnonDnon_medic2"];
_engineerX playMoveNow selectRandom medicAnims;

_engineerX addEventHandler ["AnimDone",
	{
	private _engineerX = _this select 0;
	if (([_engineerX] call A3A_fnc_canFight) and !(_engineerX getVariable ["helping",false]) and !(_engineerX getVariable ["rearming",false]) and (_engineerX getVariable ["constructing",false])) then
		{
		_engineerX playMoveNow selectRandom medicAnims;
		}
	else
		{
		_engineerX removeEventHandler ["AnimDone",_thisEventHandler];
		};
	}];

waitUntil  {sleep 5; !([_engineerX] call A3A_fnc_canFight) or (_engineerX getVariable ["helping",false]) or (_engineerX getVariable ["rearming",false]) or (_engineerX distance _positionX > 4) or (time > _timeOut)};

_engineerX setVariable ["constructing",false];
if (!_isPlayer) then {{_engineerX enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"]};

if (time <= _timeOut) exitWith {hint "Constructing cancelled"};
if (!_isPlayer) then {_engineerX doFollow (leader _engineerX)};
private _veh = createVehicle [_classX, _positionX, [], 0, "CAN_COLLIDE"];
_veh setDir _dir;

if ((_typeX == "SB") or (_typeX == "CB")) exitWith
	{
	staticsToSave pushBackUnique _veh;
	publicVariable "staticsToSave"
	};


//falta inicializarlo en veh init
if (_typeX == "RB") then
	{
	sleep 30;
	_l1 = "#lightpoint" createVehicle getpos _veh;
	_l1 setLightDayLight true;
	_l1 setLightColor [5, 2.5, 0];
	_l1 setLightBrightness 0.1;
	_l1 setLightAmbient [5, 2.5, 0];
	_l1 lightAttachObject [_veh, [0, 0, 0]];
	_l1 setLightAttenuation [3, 0, 0, 0.6];
	_source01 = "#particlesource" createVehicle getpos _veh;
	_source01 setParticleClass "BigDestructionFire";
	_source02 = "#particlesource" createVehicle getpos _veh;
	_source02 setParticleClass "BigDestructionSmoke";
	[_l1,_source01,_source02,_veh] spawn
		{
		private _veh = _this select 3;
		while {alive _veh} do
			{
			_veh say3D "fire";
			sleep 13;
			};
		{deleteVehicle _x} forEach (_this - [_veh]);
		};
	};

while {alive _veh} do
	{
	if ((not([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits)) and (_veh distance getMarkerPos respawnTeamPlayer > 100)) then
		{
		deleteVehicle _veh
		};
	sleep 60;
	};
