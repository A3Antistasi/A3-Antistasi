private ["_pool","_veh","_tipoVeh"];
_pool = false;
if (_this select 0) then {_pool = true};
_veh = cursorTarget;

if (isNull _veh) exitWith {hint "You are not looking at a vehicle"};

if (!alive _veh) exitWith {hint "You cannot add destroyed vehicles to your garage"};

if (_veh distance getMarkerPos respawnBuenos > 50) exitWith {hint "Vehicle must be closer than 50 meters to the flag"};

if ({isPlayer _x} count crew _veh > 0) exitWith {hint "In order to store a vehicle, its crew must disembark."};

_tipoVeh = typeOf _veh;

if (_veh isKindOf "Man") exitWith {hint "Are you kidding?"};

if (not(_veh isKindOf "AllVehicles")) exitWith {hint "The vehicle you are looking cannot be stored in our Garage"};

if (_pool and (count vehInGarage >= (tierWar *3))) exitWith {hint "You cannot garage more vehicles at your current War Level"};

_exit = false;
if (!_pool) then
	{
	_owner = _veh getVariable "duenyo";
	if (!isNil "_owner") then
		{
		if (_owner isEqualType "") then
			{
			if (getPlayerUID player != _owner) then {_exit = true};
			};
		};
	};

if (_exit) exitWith {hint "You are not owner of this vehicle therefore you cannot garage it"};

if (_tipoVeh isKindOf "Air") then
	{
	_aeropuertos = aeropuertos select {(lados getVariable [_x,sideUnknown] == buenos) and (player inArea _x)};
	if (count _aeropuertos == 0) then {_exit = true};
	};

if (_exit) exitWith {hint format ["You cannot garage an air vehicle while you are near an Aiport which belongs to %1",nameBuenos]};

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};

[_veh,true] call vaciar;
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};
if (_veh isKindOf "StaticWeapon") then {deleteVehicle _veh};
if (_pool) then
	{
	vehInGarage = vehInGarage + [_tipoVeh];
	publicVariable "vehInGarage";
	hint format ["Vehicle added to %1 Garage",nameBuenos];
	}
else
	{
	personalGarage = personalGarage + [_tipoVeh];
	hint "Vehicle added to Personal Garage";
	};
