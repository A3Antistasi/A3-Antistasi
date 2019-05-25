private ["_trucksX","_camion","_armas","_ammunition","_items","_mochis","_containers","_todo"];

_camion = objNull;

if (count _this > 0) then
	{
	_camion = _this select 0;
	if (_camion isKindOf "StaticWeapon") then {_camion = objNull};
	}
else
	{
	_trucksX = nearestObjects [caja, ["LandVehicle","ReammoBox_F"], 20];
	_trucksX = _trucksX select {not (_x isKindOf "StaticWeapon")};
	_trucksX = _trucksX - [caja,cajaVeh];
	if (count _trucksX < 1) then {_camion = cajaVeh} else {_camion = _trucksX select 0};
	};

if (isNull _camion) exitWith {};

_armas = weaponCargo _camion;
_ammunition = magazineCargo _camion;
_items = itemCargo _camion;
_mochis = backpackCargo _camion;

_todo = _armas + _ammunition + _items + _mochis;

if (count _todo < 1) exitWith
	{
	if (count _this == 0) then {hint "Closest vehicle cargo is empty"};
	if (count _this == 2) then {deleteVehicle _camion};
	};

if (count _this == 2) then {[_camion,caja,true] remoteExec ["A3A_fnc_ammunitionTransfer",2]} else {[_camion,caja] remoteExec ["A3A_fnc_ammunitionTransfer",2]}