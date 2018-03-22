private ["_pool","_veh","_tipoVeh"];
_pool = false;
if (_this select 0) then {_pool = true};
_veh = cursorTarget;

if (isNull _veh) exitWith {hint "You are not looking at a vehicle"};

if (!alive _veh) exitWith {hint "You cannot add destroyed vehicles to your garage"};

if (_veh distance getMarkerPos "respawn_guerrila" > 50) exitWith {hint "Vehicle must be closer than 50 meters to the flag"};

if ({isPlayer _x} count crew _veh > 0) exitWith {hint "In order to store vehicle, its crew must disembark."};

//if (_veh isKindOf "Air") exitWith {hint "Garage cannot content Air vehicles.\n\nSorry."};
_tipoVeh = typeOf _veh;

//if ((_tipoVeh in vehNATO) or (_tipoVeh in planesNATO)) exitWith {hint "You cannot keep NATO vehicles"};

if (_veh isKindOf "Man") exitWith {hint "Are you kidding?"};

if (not(_veh isKindOf "AllVehicles")) exitWith {hint "The vehicle you are looking cannot be kept in our Garage"};

if (_pool and (count vehInGarage >= (tierWar *3))) exitWith {hint "You cannot garage more vehicles at your current War Level"};

//if (_tipoVeh == "I_Truck_02_ammo_F") exitWith {hint "Ammotrucks cannot be added to avoid exploits.\n\nSorry"};

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

if (_exit) exitWith {hint "You are not owner of this vehicle and you cannot garage it"};

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};

[_veh,true] call vaciar;
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};
if (_veh isKindOf "StaticWeapon") then {deleteVehicle _veh};
if (_pool) then
	{
	vehInGarage = vehInGarage + [_tipoVeh];
	publicVariable "vehInGarage";
	hint "Vehicle added to SDK Garage";
	}
else
	{
	personalGarage = personalGarage + [_tipoVeh];
	hint "Vehicle added to Personal Garage";
	};
