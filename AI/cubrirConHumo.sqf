private ["_unit","_muzzle","_enemy","_return"];

_unit = _this select 0;
_ayudado = _this select 1;
_return = false;
if (time < _unit getVariable ["smokeUsed",time - 1]) exitWith {_return};

if (vehicle _unit != _unit) exitWith {};

_unit setVariable ["smokeUsed",time + 60];

_muzzle = [_unit] call returnMuzzle;
_enemy = if (count _this > 2) then {_this select 2} else {_unit findNearestEnemy _unit};
if (_muzzle !="") then
	{
	/*
	_enemy = _ayudado findNearestEnemy _unit;
	if (!isNull _enemy) then
		{
		if (([objNull, "VIEW"] checkVisibility [eyePos _ayudado, eyePos _enemy]) > 0) then
			{
			_unit stop true;
			_unit doWatch _enemy;
			_unit lookAt _enemy;
			_unit doTarget _enemy;
			if (_unit != _ayudado) then {sleep 5} else {sleep 1};
			_unit forceWeaponFire [_muzzle,_muzzle];
			_unit stop false;
			_unit doFollow (leader _unit);
			};
		};
	*/
	if (!isNull _enemy) then
		{
		if (true) /*((([objNull, "VIEW"] checkVisibility [eyePos _enemy, eyePos _ayudado]) > 0) or (behaviour _unit == "COMBAT"))*/ then
			{
			_unit stop true;
			_unit doWatch _enemy;
			_unit lookAt _enemy;
			_unit doTarget _enemy;
			if (_unit != _ayudado) then {sleep 5} else {sleep 1};
			_unit forceWeaponFire [_muzzle,_muzzle];
			_unit stop false;
			_unit doFollow (leader _unit);
			_return = true;
			};
		};
	}
else
	{
	if (side _unit != buenos) then
		{
		if (fleeing _unit) then {[_unit,_enemy] call fuegoSupresor};
		};
	};
_return