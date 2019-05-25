
if (player != theBoss) exitWith {hint "Only our Commander has access to this function"};
//if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
if (markerAlpha respawnTeamPlayer == 0) exitWith {hint "You cant recruit a new squad while you are moving your HQ"};
if (!([player] call A3A_fnc_hasRadio)) exitWith {if !(hayIFA) then {hint "You need a radio in your inventory to be able to give orders to other squads"} else {hint "You need a Radio Man in your group to be able to give orders to other squads"}};
_checkX = false;
{
	if (((side _x == ) or (side _x == Occupants)) and (_x distance petros < 500) and ([_x] call A3A_fnc_canFight) and !(isPlayer _x)) exitWith {_checkX = true};
} forEach allUnits;

if (_checkX) exitWith {Hint "You cannot Recruit Squads with enemies near your HQ"};

private ["_typeGroup","_esinf","_typeVehX","_coste","_costHR","_exit","_formatX","_pos","_hr","_resourcesFIA","_grupo","_roads","_road","_grupo","_camion","_vehicle","_mortarX","_morty"];


_typeGroup = _this select 0;
_exit = false;
if (_typeGroup isEqualType "") then
	{
	if (_typeGroup == "not_supported") then {_exit = true; hint "The group or vehicle type you request is not supported in your modset"};
	if (hayIFA and ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) and !debug) then {_exit = true; hint "The group or vehicle type you request is not supported in your modset"};
	};

if (activeGREF) then
	{
	if (_typeGroup isEqualType objNull) then
		{
		if (_typeGroup == staticATbuenos) then {hint "AT trucks are disabled in RHS - GREF"; _exit = true};
		};
	};
if (_exit) exitWith {};
garageVeh = objNull;
_esinf = false;
_typeVehX = "";
_coste = 0;
_costHR = 0;
_formatX = [];
_format = "Squd-";

_hr = server getVariable "hr";
_resourcesFIA = server getVariable "resourcesFIA";

private ["_grupo","_roads","_camion","_withBackpck"];
_withBackpck = "";
if (_typeGroup isEqualType []) then
	{
	{
	_typeUnit = if (random 20 <= skillFIA) then {_x select 1} else {_x select 0};
	_formatX pushBack _typeUnit;
	_coste = _coste + (server getVariable _typeUnit); _costHR = _costHR +1
	} forEach _typeGroup;
	if (count _this > 1) then
		{
		_withBackpck = _this select 1;
		if (_withBackpck == "MG") then {_coste = _coste + ([SDKMGStatic] call A3A_fnc_vehiclePrice)};
		if (_withBackpck == "Mortar") then {_coste = _coste + ([SDKMortar] call A3A_fnc_vehiclePrice)};
		};
	_esinf = true;
	}
else
	{
	_coste = _coste + (2*(server getVariable staticCrewTeamPlayer)) + ([_typeGroup] call A3A_fnc_vehiclePrice);
	_costHR = 2;
	//if (_typeGroup == SDKMortar) then {_coste = _coste + ([vehSDKBike] call A3A_fnc_vehiclePrice)} else {_coste = _coste + ([vehSDKTruck] call A3A_fnc_vehiclePrice)};
	if ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) then
		{
		_esInf = true;
		_formatX = [staticCrewTeamPlayer,staticCrewTeamPlayer];
		}
	else
		{
		_coste = _coste + ([vehSDKTruck] call A3A_fnc_vehiclePrice)
		};
	};
if ((_withBackpck != "") and hayIFA) exitWith {hint "Your current modset does not support packing / unpacking static weapons"; garageVeh = nil};

if (_hr < _costHR) then {_exit = true;hint format ["You do not have enough HR for this request (%1 required)",_costHR]};

if (_resourcesFIA < _coste) then {_exit = true;hint format ["You do not have enough money for this request (%1 € required)",_coste]};

if (_exit) exitWith {garageVeh = nil};

_nul = [- _costHR, - _coste] remoteExec ["A3A_fnc_resourcesFIA",2];

_pos = getMarkerPos respawnTeamPlayer;

_road = [_pos] call A3A_fnc_findNearestGoodRoad;
_bypassAI = false;
if (_esinf) then
	{
	_pos = [(getMarkerPos respawnTeamPlayer), 30, random 360] call BIS_Fnc_relPos;
	if (_typeGroup isEqualType []) then
		{
		_grupo = [_pos, buenos, _formatX,true] call A3A_fnc_spawnGroup;
		//if (_typeGroup isEqualTo groupsSDKSquad) then {_format = "Squd-"};
		if (_typeGroup isEqualTo groupsSDKmid) then {_format = "Tm-"};
		if (_typeGroup isEqualTo groupsSDKAT) then {_format = "AT-"};
		if (_typeGroup isEqualTo groupsSDKSniper) then {_format = "Snpr-"};
		if (_typeGroup isEqualTo groupsSDKSentry) then {_format = "Stry-"};
		if (_withBackpck == "MG") then
			{
			((units _grupo) select ((count (units _grupo)) - 2)) addBackpackGlobal supportStaticsSDKB2;
			((units _grupo) select ((count (units _grupo)) - 1)) addBackpackGlobal MGStaticSDKB;
			_format = "SqMG-";
			}
		else
			{
			if (_withBackpck == "Mortar") then
				{
				((units _grupo) select ((count (units _grupo)) - 2)) addBackpackGlobal supportStaticsSDKB3;
				((units _grupo) select ((count (units _grupo)) - 1)) addBackpackGlobal MortStaticSDKB;
				_format = "SqMort-";
				};
			};
		}
	else
		{
		_grupo = [_pos, buenos, _formatX,true] call A3A_fnc_spawnGroup;
		_grupo setVariable ["staticAutoT",false,true];
		if (_typeGroup == SDKMortar) then {_format = "Mort-"};
		if (_typeGroup == SDKMGStatic) then {_format = "MG-"};
		[_grupo,_typeGroup] spawn A3A_fnc_MortyAI;
		_bypassAI = true;
		};
	_format = format ["%1%2",_format,{side (leader _x) == buenos} count allGroups];
	_grupo setGroupId [_format];
	}
else
	{
	_pos = position _road findEmptyPosition [1,30,vehSDKTruck];
	_vehicle = if (_typeGroup == staticAABuenos) then
		{
		if (activeGREF) then {[_pos, 0,"rhsgref_ins_g_ural_Zu23", buenos] call bis_fnc_spawnvehicle} else {[_pos, 0,vehSDKTruck, buenos] call bis_fnc_spawnvehicle};
		}
	else
		{
		[_pos, 0,_typeGroup, buenos] call bis_fnc_spawnvehicle
		};
	_camion = _vehicle select 0;
	_grupo = _vehicle select 2;
	//_mortarX attachTo [_camion,[0,-1.5,0.2]];
	//_mortarX setDir (getDir _camion + 180);

	if ((!activeGREF) and (_typeGroup == staticAABuenos)) then
		{
		_pos = _pos findEmptyPosition [1,30,SDKMortar];
		_morty = _grupo createUnit [staticCrewTeamPlayer, _pos, [],0, "NONE"];
		_mortarX = _typeGroup createVehicle _pos;
		_nul = [_mortarX] call A3A_fnc_AIVEHinit;
		_mortarX attachTo [_camion,[0,-1.5,0.2]];
		_mortarX setDir (getDir _camion + 180);
		_morty moveInGunner _mortarX;
		};
	if (_typeGroup == vehSDKAT) then {_grupo setGroupId [format ["M.AT-%1",{side (leader _x) == buenos} count allGroups]]};
	if (_typeGroup == staticAABuenos) then {_grupo setGroupId [format ["M.AA-%1",{side (leader _x) == buenos} count allGroups]]};

	driver _camion action ["engineOn", vehicle driver _camion];
	_nul = [_camion] call A3A_fnc_AIVEHinit;
	_bypassAI = true;
	};

{[_x] call A3A_fnc_FIAinit} forEach units _grupo;
//leader _grupo setBehaviour "SAFE";
theBoss hcSetGroup [_grupo];
petros directSay "SentGenReinforcementsArrived";
hint format ["Group %1 at your command.\n\nGroups are managed from the High Command bar (Default: CTRL+SPACE)\n\nIf the group gets stuck, use the AI Control feature to make them start moving. Mounted Static teams tend to get stuck (solving this is WiP)\n\nTo assign a vehicle for this group, look at some vehicle, and use Vehicle Squad Mngmt option in Y menu", groupID _grupo];

if (!_esinf) exitWith {garageVeh = nil};
if !(_bypassAI) then {_grupo spawn A3A_fnc_attackDrillAI};

if (count _formatX == 2) then
	{
	_typeVehX = vehSDKBike;
	}
else
	{
	if (count _formatX > 4) then
		{
		_typeVehX = vehSDKTruck;
		}
	else
		{
		_typeVehX = vehSDKLightUnarmed;
		};
	};

_coste = [_typeVehX] call A3A_fnc_vehiclePrice;
private ["_display","_childControl"];
if (_coste > server getVariable "resourcesFIA") exitWith {garageVeh = nil};

_nul = createDialog "veh_query";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
	{
	_ChildControl = _display displayCtrl 104;
	_ChildControl  ctrlSetTooltip format ["Buy a vehicle for this squad for %1 €",_coste];
	_ChildControl = _display displayCtrl 105;
	_ChildControl  ctrlSetTooltip "Barefoot Infantry";
	};

waitUntil {(!dialog) or (!isNil "vehQuery")};
garageVeh = nil;
if ((!dialog) and (isNil "vehQuery")) exitWith {};

//if (!vehQuery) exitWith {vehQuery = nil};

vehQuery = nil;
//_resourcesFIA = server getVariable "resourcesFIA";
//if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
_mortarX = _typeVehX createVehicle _pos;
_nul = [_mortarX] call A3A_fnc_AIVEHinit;
_grupo addVehicle _mortarX;
_mortarX setVariable ["owner",_grupo,true];
_nul = [0, - _coste] remoteExec ["A3A_fnc_resourcesFIA",2];
leader _grupo assignAsDriver _mortarX;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
hint "Vehicle Purchased";
petros directSay "SentGenBaseUnlockVehicle";
