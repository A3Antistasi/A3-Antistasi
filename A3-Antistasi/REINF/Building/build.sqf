if (!(isNil "placingVehicle") && {placingVehicle}) exitWith { hint "You can't build while placing something." };
if (player != player getVariable ["owner",objNull]) exitWith {hint "You cannot construct anything while controlling AI"};

build_engineerSelected = objNull;

{if (_x getUnitTrait "engineer") exitWith {build_engineerSelected = _x}} forEach units group player;

if (isNull build_engineerSelected) exitWith {hint "Your squad needs an engineer to be able to construct"};
if ((player != build_engineerSelected) and (isPlayer build_engineerSelected)) exitWith {hint "There is a human player engineer in your squad, ask him to construct whatever you need"};
if ((player != leader player) and (build_engineerSelected != player)) exitWith {hint "Only squad leaders can ask engineers to construct something"};
if !([build_engineerSelected] call A3A_fnc_canFight) exitWith {hint "Your Engineer is dead or incapacitated and cannot construct anything"};
if ((build_engineerSelected getVariable ["helping",false]) or (build_engineerSelected getVariable ["rearming",false]) or (build_engineerSelected getVariable ["constructing",false])) exitWith {hint "Your engineer is currently performing another action"};

build_type = _this select 0;
build_time = 60;
build_cost = 0;
private _playerDir = getDir player;
private _playerPosition = position player;
private _classX = "";
switch build_type do
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
		build_time = 60;
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
		build_time = 100;
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
		build_time = 60;
		_classX = "Land_BagBunker_01_small_green_F";
		build_cost = 100;
		};
	case "CB":
		{
		build_time = 120;
		_classX = "Land_PillboxBunker_01_big_F";
		build_cost = 300;
		};
	};

private _leave = false;
private _textX = "";
if ((build_type == "SB") or (build_type == "CB")) then
	{
	if (build_type == "SB") then {_playerDir = _playerDir + 180};
	_resourcesFIA = if (!isMultiPlayer) then {server getVariable "resourcesFIA"} else {player getVariable "moneyX"};
	if (build_cost > _resourcesFIA) then
		{
		_leave = true;
		_textX = format ["You do not have enough money for this construction (%1 € needed)",build_cost]
		}
	else
		{
		_sites = markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
		build_nearestFriendlyMarker = [_sites,_playerPosition] call BIS_fnc_nearestPosition;
		if (!(_playerPosition inArea build_nearestFriendlyMarker)) then
			{
			_leave = true;
			_textX = "You cannot build a bunker outside a controlled zone";
			build_nearestFriendlyMarker = nil;
			};
		};
	};

if (_leave) exitWith {hint format ["%1",_textX]};

//hint "Select a place to build the required asset and press SPACE to start the construction.\n\nHit ESC to exit";
//garageVeh = _classX createVehicleLocal [0,0,0];
//bought = 0;

build_handleDamageHandler = player addEventHandler ["HandleDamage",{[] call A3A_fnc_vehPlacementCancel;}];

//START PLACEMENT HERE
[_classX, "BUILDSTRUCTURE", ""] call A3A_fnc_vehPlacementBegin;
