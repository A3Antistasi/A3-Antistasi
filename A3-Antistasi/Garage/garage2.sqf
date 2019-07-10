#include "defineCommon.inc"

if (!(isNil "placingVehicle") && {placingVehicle}) exitWith { hint "Unable to open garage, you are already placing something" };
garageIsOpen = true;

garage_mode = _this select 0;

if (garage_mode == GARAGE_FACTION and (not([player] call A3A_fnc_isMember))) exitWith {hint "You cannot access the Garage as you are guest in this server"};
if (player != player getVariable "owner") exitWith {hint "You cannot access the Garage while you are controlling AI"};
if ([player,300] call A3A_fnc_enemyNearCheck) exitWith {Hint "You cannot manage the Garage with enemies nearby"};

garage_vehiclesAvailable = [];

//Build a list of the vehicles available to us at this location
_hasAir = false;
_airportsX = airportsX select {(sidesX getVariable [_x,sideUnknown] == teamPlayer) and (player inArea _x)};
if (count _airportsX > 0) then {_hasAir = true};
{
	if (_x in vehPlanes) then
		{
		if (_hasAir) then {garage_vehiclesAvailable pushBack _x};
		}
	else
		{
		garage_vehiclesAvailable pushBack _x;
		};
} forEach (if (garage_mode == GARAGE_FACTION) then {vehInGarage} else {personalGarage});

if (count garage_vehiclesAvailable == 0) exitWith {hintC "The Garage is empty or the vehicles you have are not suitable to recover in the place you are.\n\nAir vehicles need to be recovered near Airport flags."};

garage_nearestMarker = [markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer},player] call BIS_fnc_nearestPosition;
if !(player inArea garage_nearestMarker) exitWith {hint "You need to be close to one of your garrisons to be able to retrieve a vehicle from your garage"};

garage_vehicleIndex = 0;
_initialType = garage_vehiclesAvailable select garage_vehicleIndex;

#define KEY_UP 200
#define KEY_DOWN 208

//We define this once and never remove it
//Because removing handlers can cause the IDs other handlers to change, stopping them being removed.
if (isNil "garage_keyDownHandler") then {
	garage_keyDownHandler = (findDisplay 46) displayAddEventHandler ["KeyDown",
	{
		if (!garageIsOpen) exitWith {false;};
		private _handled = false;
		private _leave = false;
		//Next vehicle
		if (_this select 1 == KEY_UP) then
			{
			_handled = true;
			if (garage_vehicleIndex + 1 > (count garage_vehiclesAvailable) - 1) then {garage_vehicleIndex = 0} else {garage_vehicleIndex = garage_vehicleIndex + 1};
			private _type = garage_vehiclesAvailable select garage_vehicleIndex;
			[_type] call A3A_fnc_vehPlacementChangeVehicle;
			};
		//Previous vehicle
		if (_this select 1 == KEY_DOWN) then
			{
			_handled = true;
			if (garage_vehicleIndex - 1 < 0) then {garage_vehicleIndex = (count garage_vehiclesAvailable) - 1} else {garage_vehicleIndex = garage_vehicleIndex - 1};
					private _type = garage_vehiclesAvailable select garage_vehicleIndex;
			[_type] call A3A_fnc_vehPlacementChangeVehicle;
			};
		_handled;
	}];
};
private _extraMessage = "Arrow Up-Down to Switch Vehicles<br/>";

[_initialType, "GARAGE", _extraMessage] call A3A_fnc_vehPlacementBegin;

/*
garage_fnc_attemptBuy = {
	//garage_lastPreviewPosition = nil;
	_pos = getPosASL garage_previewVeh;
	_dir = getDir garage_previewVeh;
	_typeX = typeOf garage_previewVeh;
	deleteVehicle garage_previewVeh;
	
	if !(player inArea garage_nearestMarker) exitWith 
		{
		hint "You need to be close to one of your garrisons to be able to retrieve a vehicle from your garage";
		["",0,0,5,0,0,4] spawn bis_fnc_dynamicText; 
		garage_previewVeh = objNull; 
		};
	if ([player,300] call A3A_fnc_enemyNearCheck) exitWith
		{
		hint "You cannot manage the Garage with enemies nearby";
		garage_previewVeh = objNull; 
		};
	
	//Only show text after we've checked all of the failure conditions above.
	["<t size='0.6'>Vehicle retrieved from Garage",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
		
	waitUntil {isNull garage_previewVeh};
	
	private _garageVeh = createVehicle [_typeX, [0,0,1000], [], 0, "NONE"];
	_garageVeh setDir _dir;
	//Surely this overrides any collision checks createVehicle would have made?
	_garageVeh setPosASL _pos;
	[_garageVeh] call A3A_fnc_AIVEHinit;
	
	if (_garageVeh isKindOf "Car") then {_garageVeh setPlateNumber format ["%1",name player]};
	_newArr = [];
	_found = false;
	if (garage_mode == GARAGE_FACTION) then
		{
		{
			if ((_x != (garage_vehiclesAvailable select garage_vehicleIndex)) or (_found)) then {_newArr pushBack _x} else {_found = true};
		} forEach vehInGarage;
		vehInGarage = _newArr;
		publicVariable "vehInGarage";
		}
	else
		{
		{
			if ((_x != (garage_vehiclesAvailable select garage_vehicleIndex)) or (_found)) then {_newArr pushBack _x} else {_found = true};
		} forEach personalGarage;
		personalGarage = _newArr;
		["personalGarage",_newArr] call fn_SaveStat;
		_garageVeh setVariable ["ownerX",getPlayerUID player,true];
		};
		
	if (_garageVeh isKindOf "StaticWeapon") then {staticsToSave pushBack _garageVeh; publicVariable "staticsToSave"};
	
	clearMagazineCargoGlobal _garageVeh;
	clearWeaponCargoGlobal _garageVeh;
	clearItemCargoGlobal _garageVeh;
	clearBackpackCargoGlobal _garageVeh;
	_garageVeh allowDamage true;
	_garageVeh enableSimulationGlobal true;
	isGarageOpen = false;
};

garage_fnc_exitGarage = {
	params [["_message", ""]];
	if (count _message > 0) then {
		hint _message;
	};
	["",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
	deleteVehicle garage_previewVeh;
	garage_previewVeh = objNull; 
	isGarageOpen = false;
};

#define KEY_UP 200
#define KEY_DOWN 208


	
garage_lastPreviewPosition = [0,0,0];
addMissionEventHandler ["EachFrame",
	{
	private _shouldExitHandler = false;
	if (garage_actionToAttempt != GARAGE_NO_ACTION) then 
		{
		switch(garage_actionToAttempt) do 
			{
			case GARAGE_PURCHASE: 
				{
					[] spawn garage_fnc_attemptBuy;
					_shouldExitHandler = true;
				};
			case GARAGE_EXIT: 
				{
					[] spawn garage_fnc_exitGarage;
					_shouldExitHandler = true;
				};
			case GARAGE_RELOAD_VEHICLE: 
				{
					hideObject garage_previewVeh;
					deleteVehicle garage_previewVeh;
					private _typeX = garage_vehiclesAvailable select garage_vehicleIndex;
					if (isNil "_typeX") exitWith {};
					if (typeName _typeX != typeName "") exitWith {};
					garage_previewVeh = _typeX createVehicleLocal [0,0,1000];
					garage_previewVeh allowDamage false;
					garage_previewVeh enableSimulationGlobal false;
					[format ["<t size='0.7'>%1<br/><br/><t size='0.6'>Garage Keys.<t size='0.5'><br/>Arrow Up-Down to Navigate<br/>Arrow Left-Right to rotate<br/>SPACE to Select<br/>ENTER to Exit",getText (configFile >> "CfgVehicles" >> typeOf garage_previewVeh >> "displayName")],0,0,5,0,0,4] spawn bis_fnc_dynamicText;
				};
			case GARAGE_ROTATE_LEFT: 
				{
					garage_previewVeh setDir (getDir garage_previewVeh + 1);
				};
			case GARAGE_ROTATE_RIGHT: 
				{
					garage_previewVeh setDir (getDir garage_previewVeh - 1);
				};
			};
			garage_actionToAttempt = GARAGE_NO_ACTION;
		};
	
	if (!(player inArea garage_nearestMarker)) then {
		["You need to be close to one of your garrisons to be able to retrieve a vehicle from your garage"] spawn garage_fnc_exitGarage;
		_shouldExitHandler = true;
	};
	
	if (_shouldExitHandler) exitWith {
		removeMissionEventHandler ["EachFrame", _thisEventHandler];
	};
	
	if (isNull garage_previewVeh) exitWith {};
	// Get point on /terrain/ the player is looking at
	_ins = lineIntersectsSurfaces [
		AGLToASL positionCameraToWorld [0,0,0],
		AGLToASL positionCameraToWorld [0,0,1000],
		player,garage_previewVeh,true,1,"NONE","NONE"
	];
	if (count _ins == 0) exitWith {};
	private _pos = ASLtoATL ((_ins select 0) select 0);
	private _placementPos = _pos findEmptyPosition [0, 20, typeOf garage_previewVeh];
	// Do nothing else if we can't find an empty position
	if (count (_placementPos) == 0) exitWith {garage_previewVeh setPosASL [0,0,0]};
	// If we're too close to the last position, don't do anything
	if (_placementPos distance garage_lastPreviewPosition < 0.1) exitWith {};
	garage_lastPreviewPosition = _placementPos;
	// If vehicle is a boat, make sure it spawns at sea level?
	_shipX = false;
	if (garage_previewVeh isKindOf "Ship") then {_placementPos set [2,0]; _shipX = true};
	// Do nothing if destination too far
	if (_placementPos distance2d player > 100)exitWith {garage_previewVeh setPosASL [0,0,0]};
	// Ships only spawn on water, and cars can't spawn on water
	_water = surfaceIsWater _placementPos;
	if (_shipX and {!_water}) exitWith {garage_previewVeh setPosASL [0,0,0]};
	if (!_shipX and {_water}) exitWith {garage_previewVeh setPosASL [0,0,0]};
	// If all checks pass, set position of preview and orient it to the ground
	garage_previewVeh setPosATL _placementPos;
	garage_previewVeh setVectorUp (_chosenIntersection select 1);
	}];
	*/