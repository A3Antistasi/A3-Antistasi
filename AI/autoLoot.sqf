_unit = _this select 0;
_camion = _this select 1;

if ((!alive _unit) or (isPlayer _unit) or (player != leader group player) or (captive _unit)) exitWith {};
if (lifestate _unit == "INCAPACITATED") exitWith {};
_ayudando = _unit getVariable "ayudando";
if (!(isNil "_ayudando")) exitWith {_unit groupChat "I cannot rearm right now. I'm healing a comrade"};
_rearming = _unit getVariable "rearming";
if (_rearming) exitWith {_unit groupChat "I am currently rearming. Cancelling."; _unit setVariable ["rearming",false]};
if (_unit == gunner _camion) exitWith {_unit groupChat "I cannot rearm right now. I'm manning this gun"};
if (!canMove _camion) exitWith {_unit groupChat "It is useless to load my vehicle, as it needs repairs"};

_objetos = [];
_hayCaja = false;
_arma = "";
_armas = [];
_bigTimeOut = time + 120;
_objetos = nearestObjects [_unit, ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 50];
if (count _objetos == 0) exitWith {_unit groupChat "I see no corpses here to loot"};

_target = objNull;
_distancia = 51;
{
_objeto = _x;
if (_unit distance _objeto < _distancia) then
	{
	if ((count weaponCargo _objeto > 0) and !(_objeto getVariable ["busy",false])) then
		{
		_armas = weaponCargo _objeto;
		for "_i" from 0 to (count _armas - 1) do
			{
			_posible = _armas select _i;
			_basePosible = [_posible] call BIS_fnc_baseWeapon;
			if ((not(_basePosible in unlockedWeapons)) and ((_basePosible in arifles) or (_basePosible in srifles) or (_basePosible in mguns) or (_posible in mlaunchers) or (_posible in rlaunchers))) then
				{
				_target = _objeto;
				_distancia = _unit distance _objeto;
				_arma = _posible;
				};
			};
		};
	};
} forEach _objetos;

if (isNull _target) exitWith {_unit groupChat "There is nothing to loot"};
_target setVariable ["busy",true];
_unit setVariable ["rearming",true];
_unit groupChat "Starting looting";

_Pweapon = primaryWeapon _unit;
_Sweapon = secondaryWeapon _unit;

_unit action ["GetOut",_camion];
[_unit] orderGetin false;
sleep 3;
if (_Pweapon != "") then {_unit action ["DropWeapon",_camion,_Pweapon]; sleep 3};
if (_Sweapon != "") then {_unit action ["DropWeapon",_camion,_Sweapon]};

_continuar = true;

while {_continuar and (alive _unit) and (!(lifestate _unit == "INCAPACITATED")) and (_unit getVariable "rearming") and (alive _camion) and (_bigTimeout > time)} do
	{
	if (isNull _target) exitWith {_continuar = false};
	_target setVariable ["busy",true];
	_unit doMove (getPosATL _target);
	_timeOut = time + 60;
	waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
	if (_unit distance _target < 3) then
		{
		_unit action ["TakeWeapon",_target,_arma];
		sleep 3;
		};
	_target setVariable ["busy",false];
	_tempPrimary = primaryWeapon _unit;
	if (_tempPrimary != "") then
		{
		_magazines = getArray (configFile / "CfgWeapons" / _tempPrimary / "magazines");
		_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
		_hayCaja = false;
		_distancia = 51;
		{
		_muerto = _x;
		if (({_x in _magazines} count (magazines _muerto) > 0) and (_unit distance _muerto < _distancia)) then
			{
			_target = _muerto;
			_hayCaja = true;
			_distancia = _muerto distance _unit;
			};
		} forEach _muertos;
		if ((_hayCaja) and (_unit getVariable "rearming")) then
			{
			_unit stop false;
			_target setVariable ["busy",true];
			_unit doMove (getPosATL _target);
			_timeOut = time + 60;
			waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
			if (_unit distance _target < 3) then
				{
				_unit action ["rearm",_target];
				};
			_target setVariable ["busy",false];
			};
		};

	_unit doMove (getPosATL _camion);
	_timeOut = time + 60;
	waitUntil {sleep 1; (!alive _unit) or (!alive _camion) or (_unit distance _camion < 8) or (_timeOut < time)};
	if ((alive _camion) and (alive _unit)) then
		{
		if (_tempPrimary != "") then
			{
			_unit action ["DropWeapon",_camion,_tempPrimary];
			sleep 3;
			};
		if (secondaryWeapon _unit != "") then
			{
			_unit action ["DropWeapon",_camion,secondaryWeapon _unit];
			sleep 3;
			};
		};
	_target = objNull;
	_distancia = 51;
	{
	_objeto = _x;
	if (_unit distance _objeto < _distancia) then
		{
		if ((count weaponCargo _objeto > 0) and !(_objeto getVariable ["busy",false])) then
			{
			_armas = weaponCargo _objeto;
			for "_i" from 0 to (count _armas - 1) do
				{
				_posible = _armas select _i;
				_basePosible = [_posible] call BIS_fnc_baseWeapon;
				if ((not(_basePosible in unlockedWeapons)) and ((_basePosible in arifles) or (_basePosible in srifles) or (_basePosible in mguns) or (_posible in mlaunchers) or (_posible in rlaunchers))) then
					{
					_target = _objeto;
					_distancia = _unit distance _objeto;
					_arma = _posible;
					};
				};
			};
		};
	} forEach _objetos;
	};
if (!_continuar) then
	{
	_unit groupChat "No more weapons to loot"
	};
if (primaryWeapon _unit == "") then {_unit action ["TakeWeapon",_camion,_Pweapon]; sleep 3};
if ((secondaryWeapon _unit == "") and (_Sweapon != "")) then {_unit action ["TakeWeapon",_camion,_Sweapon]};
_unit doFollow player;
_unit setVariable ["rearming",false];
