//ejemplo: _result = [distanciaSPWN,0,posHQ,muyMalos] call A3A_fnc_distanceUnits: devuelve un array con todas las que estén a menos de distanciaSPWN
//ejemplo: _result = [distanciaSPWN,1,posHQ,buenos] call A3A_fnc_distanceUnits: devuelve un boolean si hay una que esté a menos de distanciaSPWN
params ["_distancia","_modo","_referencia","_variable"];

_distancia = _this select 0;//la distancia requisito, normalmente distanciaSPWN)
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
		if (_x distance2D _referencia < _distancia) then
			{
			_result pushBack _x;
			};
		};
	} forEach _allUnits;
	}
else
	{
	{if ((side group _x == _variable) and (_x distance2D _referencia < _distancia)) exitWith {_result = true}} count _allUnits;
	};

_result
