//ejemplo: _result = [distanceSPWN,0,posHQ,Invaders] call A3A_fnc_distanceUnits: devuelve un array con todas las que estén a menos de distanceSPWN
//ejemplo: _result = [distanceSPWN,1,posHQ,buenos] call A3A_fnc_distanceUnits: devuelve un boolean si hay una que esté a menos de distanceSPWN
params ["_distanceX","_modo","_referencia","_variable"];

_distanceX = _this select 0;//la distanceX requisito, normalmente distanceSPWN)
_modo = _this select 1;//lo que devuelve la función, 0 un array, un número mayor un boolean cuando la cuenta llegue a ese número.
_referencia = _this select 2; // posición en formato array u objeto
_variable = _this select 3;//side
private _result = false;
private _allUnits = allUnits select {_x getVariable ["spawner",false]};
if (_modo == 0) then
	{
	_result = [];
	{
	if (side group _x == _variable) then
		{
		if (_x distance2D _referencia < _distanceX) then
			{
			_result pushBack _x;
			};
		};
	} forEach _allUnits;
	}
else
	{
	{if ((side group _x == _variable) and (_x distance2D _referencia < _distanceX)) exitWith {_result = true}} count _allUnits;
	};

_result
