private ["_vehInGarage","_checkX"];

private _pool = !(_this select 0);

if (_pool and (not([player] call A3A_fnc_isMember))) exitWith {hint "You cannot access the Garage as you are guest in this server"};
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
} forEach (if (_pool) then {vehInGarage} else {personalGarage});

if (count garage_vehiclesAvailable == 0) exitWith {hintC "The Garage is empty or the vehicles you have are not suitable to recover in the place you are.\n\nAir vehicles need to be recovered near Airport flags."};

_nearX = [markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer},player] call BIS_fnc_nearestPosition;
if !(player inArea _nearX) exitWith {hint "You need to be close to one of your garrisons to be able to retrieve a vehicle from your garage"};

garage_vehicleIndex = 0;
_typeX = garage_vehiclesAvailable select garage_vehicleIndex;
garage_previewVeh = _typeX createVehicleLocal [0,0,1000];
garage_previewVeh allowDamage false;
garage_previewVeh enableSimulationGlobal false;
garage_isVehBought = 0;
[format ["<t size='0.7'>%1<br/><br/><t size='0.6'>Garage Keys.<t size='0.5'><br/>Arrow Up-Down to Navigate<br/>Arrow Left-Right to rotate<br/>SPACE to Select<br/>ENTER to Exit",getText (configFile >> "CfgVehicles" >> typeOf garage_previewVeh >> "displayName")],0,0,5,0,0,4] spawn bis_fnc_dynamicText;
hint "Hover your mouse to the desired position. If it's safe and suitable, you will see the vehicle";

//Control flow is weird here. KeyDown tells onEachFrame it can stop running, and which action to do.
//This guarantees us no race conditions between keyDown, onEachFrame and the rest of the code.
#define KEY_SPACE 57
#define KEY_ENTER 28
#define KEY_UP 200
#define KEY_DOWN 208
#define KEY_LEFT 205
#define KEY_RIGHT 203
#define GARAGE_NO_ACTION 0
#define GARAGE_PURCHASE 1
#define GARAGE_EXIT 2
#define GARAGE_RELOAD_VEHICLE 3
#define GARAGE_ROTATE_LEFT 4
#define GARAGE_ROTATE_RIGHT 5

garage_actionToAttempt = GARAGE_NO_ACTION;
garage_keyDownHandler = (findDisplay 46) displayAddEventHandler ["KeyDown",
	{
	private _handled = false;
	private _leave = false;
	//Buy vehicle
	if (_this select 1 == KEY_SPACE) then
		{
		if (garage_previewVeh distance [0,0,1000] <= 1500) then
			{
			["<t size='0.6'>The current position is not suitable for the vehicle. Try another",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
			}
		else 
			{
			_leave = true;
			_handled = true;
			garage_actionToAttempt = GARAGE_PURCHASE;
			};
		};
	//Exit Garage
	if (_this select 1 == KEY_ENTER) then
		{
		_leave = true;
		_handled = true;
		garage_actionToAttempt = GARAGE_EXIT;
		//deleteVehicle garage_previewVeh;
		};
	//Next vehicle
	if (_this select 1 == KEY_UP) then
		{
		_handled = true;
		if (garage_vehicleIndex + 1 > (count garage_vehiclesAvailable) - 1) then {garage_vehicleIndex = 0} else {garage_vehicleIndex = garage_vehicleIndex + 1};
		garage_actionToAttempt = GARAGE_RELOAD_VEHICLE;
		};
	//Previous vehicle
	if (_this select 1 == KEY_DOWN) then
		{
		_handled = true;
		if (garage_vehicleIndex - 1 < 0) then {garage_vehicleIndex = (count garage_vehiclesAvailable) - 1} else {garage_vehicleIndex = garage_vehicleIndex - 1};
		garage_actionToAttempt = GARAGE_RELOAD_VEHICLE;
		};
	//Rotate left
	if (_this select 1 == KEY_LEFT) then
		{
		_handled = true;
		garage_actionToAttempt = GARAGE_ROTATE_LEFT;
		};
	//Rotate right
	if (_this select 1 == KEY_RIGHT) then
		{
		_handled = true;
		garage_actionToAttempt = GARAGE_ROTATE_RIGHT;
		};
	if (_leave) then
		{
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", garage_keyDownHandler];
		};
	_handled;
	}];
	
garage_lastPreviewPosition = [0,0,0];
onEachFrame
	{
	if (garage_actionToAttempt != GARAGE_NO_ACTION) then 
		{
		switch(garage_actionToAttempt) do 
			{
			case GARAGE_PURCHASE: 
				{
					garage_isVehBought = 2;
					["<t size='0.6'>Vehicle retrieved from Garage",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
				};
			case GARAGE_EXIT: 
				{
					garage_isVehBought = 1;
					["",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
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
	
	if (isNull garage_previewVeh) exitWith {};
	// Get position player is looking at
	_ins = lineIntersectsSurfaces [
		AGLToASL positionCameraToWorld [0,0,0],
		AGLToASL positionCameraToWorld [0,0,1000],
		player,garage_previewVeh
	];
	// Do nothing else if looking at nothing
	if (_ins isEqualTo []) exitWith {};
	_pos = (_ins select 0 select 0);
	// If we're too close to the last position, don't do anything
	if (_pos distance garage_lastPreviewPosition < 0.1) exitWith {};
	garage_lastPreviewPosition = _pos;
	// If vehicle is a boat, make sure it spawns at sea level?
	_shipX = false;
	if (garage_previewVeh isKindOf "Ship") then {_pos set [2,0]; _shipX = true};
	// Do nothing else if we can't find an empty position
	if (count (_pos findEmptyPosition [0, 0, typeOf garage_previewVeh])== 0) exitWith {garage_previewVeh setPosASL [0,0,0]};
	// Do nothing if destination too far
	if (_pos distance2d player > 100)exitWith {garage_previewVeh setPosASL [0,0,0]};
	// Ships only spawn on water, and cars can't spawn on water
	_water = surfaceIsWater _pos;
	if (_shipX and {!_water}) exitWith {garage_previewVeh setPosASL [0,0,0]};
	if (!_shipX and {_water}) exitWith {garage_previewVeh setPosASL [0,0,0]};
	// If all checks pass, set position of preview and orient it to the ground
	garage_previewVeh setPosASL _pos;
	garage_previewVeh setVectorUp (_ins select 0 select 1);
	};
 
waitUntil {(garage_isVehBought > 0) or !(player inArea _nearX)};
onEachFrame {};
garage_lastPreviewPosition = nil;
_pos = getPosASL garage_previewVeh;
_dir = getDir garage_previewVeh;
_typeX = typeOf garage_previewVeh;
deleteVehicle garage_previewVeh;
if !(player inArea _nearX) then {hint "You need to be close to one of your garrisons to be able to retrieve a vehicle from your garage";["",0,0,5,0,0,4] spawn bis_fnc_dynamicText; garage_isVehBought = nil; garage_previewVeh = nil; garage_vehicleIndex = nil};
if ([player,300] call A3A_fnc_enemyNearCheck) then
	{
	hint "You cannot manage the Garage with enemies nearby";
	garage_isVehBought = 0;
	};
if (garage_isVehBought != 2) exitWith {garage_isVehBought = nil; garage_previewVeh = nil; garage_vehicleIndex = nil};
garage_isVehBought = nil;
//if (player distance2D _pos > 100) exitWith {hint "You have to select a closer position from you"};
waitUntil {isNull garage_previewVeh};
garage_previewVeh = nil;
_garageVeh = createVehicle [_typeX, [0,0,1000], [], 0, "NONE"];
_garageVeh setDir _dir;
//Surely this overrides any collision checks createVehicle would have made?
_garageVeh setPosASL _pos;
[_garageVeh] call A3A_fnc_AIVEHinit;
if (_garageVeh isKindOf "Car") then {_garageVeh setPlateNumber format ["%1",name player]};
//if (garage_vehiclesAvailable isEqualTo vehInGarage) then {_pool = true};
_newArr = [];
_found = false;
if (_pool) then
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
garage_vehicleIndex = nil;
if (_garageVeh isKindOf "StaticWeapon") then {staticsToSave pushBack _garageVeh; publicVariable "staticsToSave"};
clearMagazineCargoGlobal _garageVeh;
clearWeaponCargoGlobal _garageVeh;
clearItemCargoGlobal _garageVeh;
clearBackpackCargoGlobal _garageVeh;
_garageVeh allowDamage true;
_garageVeh enableSimulationGlobal true;
