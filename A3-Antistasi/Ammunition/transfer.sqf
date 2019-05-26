private ["_camion","_objetos","_todo","_proceder","_caja","_armas","_ammunition","_items","_mochis","_containers","_cuenta","_exists"];

_truckX = vehicle player;
_objectsX = [];
_todo = [];
_proceder = false;

[driver _truckX,"remove"] remoteExec ["A3A_fnc_flagaction",driver _truckX];

_objectsX = nearestObjects [_truckX, ["ReammoBox_F"], 20];

if (count _objectsX == 0) exitWith {};
_caja = _objectsX select 0;

if ((_caja == caja) and (player!=theBoss)) exitWith {hint "Only the Commander can transfer this ammobox content to any truck"; [driver _truckX,"truckX"] remoteExec ["A3A_fnc_flagaction",driver _truckX]};


_armas = weaponCargo _caja;
_ammunition = magazineCargo _caja;
_items = itemCargo _caja;
_backpcks = [];
/*
if (count weaponsItemsCargo _truckX > 0) then
	{
	{
	_armas pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);
	for "_i" from 1 to (count _x) - 1 do
		{
		_cosa = _x select _i;
		if (typeName _cosa == typeName "") then
			{
			if (_cosa != "") then {_items pushBack _cosa};
			}
		else
			{
			if (typeName (_cosa select 0) == typeName []) then {_ammunition pushBack (_cosa select 0)};
			}
		};
	} forEach weaponsItemsCargo _caja;
	};

if (count backpackCargo _caja > 0) then
	{
	{
	_backpcks pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _caja;
	};
_containers = everyContainer _caja;
if (count _containers > 0) then
	{
	for "_i" from 0 to (count _containers - 1) do
		{
		_armas = _armas + weaponCargo ((_containers select _i) select 1);
		_ammunition = _ammunition + magazineCargo ((_containers select _i) select 1);
		_items = _items + itemCargo ((_containers select _i) select 1);
		};
	};
*/
_todo = _armas + _ammunition + _items + _backpcks;
_countX = count _todo;

if (_countX < 1) then
	{
	hint "Closest Ammobox is empty";
	_proceder = true;
	};

if (_countX > 0) then
	{
	if (_caja == caja) then
		{
		if (["DEF_HQ"] call BIS_fnc_taskExists) then {_countX = round (_countX / 10)} else {_countX = round (_countX / 100)};
		}
	else
		{
		_countX = round (_countX / 5);
		};
	if (_countX < 1) then {_countX = 1};
	while {(_truckX == vehicle player) and (speed _truckX == 0) and (_countX > 0)} do
		{
		hint format ["Truck loading. \n\nTime remaining: %1 secs", _countX];
		_countX = _countX -1;
		sleep 1;
		if (_countX == 0) then
			{
			[_caja,_camion] remoteExec ["A3A_fnc_ammunitionTransfer",2];
			_proceder = true;
			};
		if ((_truckX != vehicle player) or (speed _truckX != 0)) then
				{
				hint "Transfer cancelled due to movement of Truck or Player";
				_proceder = true;
				};
		};
	};

if (_proceder) then {[driver _camion,"camion"] remoteExec ["A3A_fnc_flagaction",driver _camion]};
