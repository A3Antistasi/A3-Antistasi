if (!(isNil "placingVehicle") && {placingVehicle}) exitWith { hint "You can't build while placing something." };
if (player != player getVariable ["owner",objNull]) exitWith {hint "You cannot construct anything while controlling AI"};

build_engineerSelected = objNull;

private _engineers = (units group player) select {_x getUnitTrait "engineer"};
private _playerIsEngineer = false;
private _otherPlayerEngineers = [];
private _aiEngineers = [];

private _abortMessage = "";

{
	if (_x getUnitTrait "engineer" || _x == theBoss) then {
		if (isPlayer _x) then {
			if (player == _x) then {
				_playerIsEngineer = true;
			} else {
				_otherPlayerEngineers pushBack _x;
			};
		} else {
			//AI Engineer
			_aiEngineers pushBack _x;
		};
	};
} forEach units group player;

private _engineerIsBusy = {
	private _engineer = param [0, objNull];
	((_engineer getVariable ["helping",false])
	or (_engineer getVariable ["rearming",false])
	or (_engineer getVariable ["constructing",false]));
};

//Check if the player can build
if (_playerIsEngineer) then {
	if ([player] call A3A_fnc_canFight && !([player] call _engineerIsBusy)) then {
		build_engineerSelected = player;
	} else {
		_abortMessage = _abortMessage + "You are an engineer, but not in a state to build: you may be unconscious or undercover.\n";
	};
} else {
	_abortMessage =	_abortMessage + "You are not an engineer.\n";
};

//Check if an engineer can build.
if (isNull build_engineerSelected && count _otherPlayerEngineers > 0) then {
	build_engineerSelected = _otherPlayerEngineers select 0;
	_abortMessage = _abortMessage + "There is a human engineer in your squad. Ask them to build.\n";
};

if (isNull build_engineerSelected) then {
	if (count _aiEngineers > 0 && player != leader player) exitWith {
		_abortMessage =	_abortMessage + "Only squad leaders can order AI to build";
	};

	{
		if ([_x] call A3A_fnc_canFight && !([_x] call _engineerIsBusy)) exitWith {
			build_engineerSelected = _x;
			_abortMessage = _abortMessage + format ["Ordering %1 to build", _x];
		};
	} forEach _aiEngineers;

	if (isNull build_engineerSelected) exitWith {
		_abortMessage =	_abortMessage + "You have no available engineers in your squad. They may be unconscious or busy.";
	};
};

if (isNull build_engineerSelected ||
   ((player != build_engineerSelected) and (isPlayer build_engineerSelected))) exitWith
{
	hint _abortMessage;
};

private _playerDir = getDir player;
private _playerPosition = position player;
private _leave = false;
private _textX = "";
private _classX = _this select 0;
build_time = _this select 1;
build_cost = _this select 2;
build_type = _this select 3;
/*
sandbag_array = ["Land_BagFence_Corner_F","Land_BagFence_End_F","Land_BagFence_Long_F","Land_BagFence_Round_F","Land_BagFence_Short_F"];
if (_this select 1 == KEY_UP) then
            //forward idk wtf im trying to do here
            //if UP, increment array. How know when object is chosen? How do array sytnax? For loop? wtf
			{
			sandbag_array[i];
			i = i + 1;
			_classX = i;
			};
		//backward
		//if DOWN, decrement array
		if (_this select 1 == KEY_DOWN) then
			{
			if (garage_vehicleIndex - 1 < 0) then {garage_vehicleIndex = (count garage_vehiclesAvailable) - 1} else {garage_vehicleIndex = garage_vehicleIndex - 1};
					private _type = garage_vehiclesAvailable select garage_vehicleIndex;
			[_type] call A3A_fnc_vehPlacementChangeVehicle;
			};
*/
if (_classX == "Land_BagBunker_01_small_green_F") then {_playerDir = _playerDir + 180};
//_resourcesFIA = if (!isMultiPlayer) then {server getVariable "resourcesFIA"} else {player getVariable "moneyX"};
_resourcesFIA = server getVariable "resourcesFIA";
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

if (_leave) exitWith {hint format ["%1",_textX]};

//hint "Select a place to build the required asset and press SPACE to start the construction.\n\nHit ESC to exit";
//garageVeh = _classX createVehicleLocal [0,0,0];
//bought = 0;

build_handleDamageHandler = player addEventHandler ["HandleDamage",{[] call A3A_fnc_vehPlacementCancel;}];

//START PLACEMENT HERE
[_classX, "BUILDSTRUCTURE", ""] call A3A_fnc_vehPlacementBegin;
