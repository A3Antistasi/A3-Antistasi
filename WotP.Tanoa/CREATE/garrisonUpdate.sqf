private ["_tipo","_lado","_marcador","_modo","_garrison","_subTipo"];

_tipo = _this select 0;
if (_tipo isEqualType []) then
	{
	if ((_tipo select 0) isEqualType objNull) then
		{
		_subTipo = [];
		{
		_subTipo pushBack (typeOf _x);
		} forEach _tipo;
		_tipo = _subTipo;
		};
	};
_lado = _this select 1;
_marcador = _this select 2;
_modo = _this select 3;
_exit = false;
{if (isNil _x) exitWith {_exit = true}} forEach ["_tipo","_lado","_marcador","_modo"];
if (_exit) exitWith {diag_log format ["Antistasi: Error en garrisonUpdate al enviar mal datos: %1,%2,%3,%4",_tipo,_lado,_marcador,_modo]};
waitUntil {sleep 0.2;!garrisonIsChanging};
garrisonIsChanging = true;
if ((_lado == malos) and (!(lados getVariable [_marcador,sideUnknown] == malos))) exitWith {garrisonIsChanging = false};
if ((_lado == muyMalos) and (!(lados getVariable [_marcador,sideUnknown] == muyMalos))) exitWith {garrisonIsChanging = false};
_garrison = [];
_garrison = _garrison + (garrison getVariable [_marcador,[]]);
if (_modo == -1) then
	{
	for "_i" from 0 to (count _garrison -1) do
		{
		if (_tipo == (_garrison select _i)) exitWith {_garrison deleteAt _i};
		};
	}
else
	{
	if (_modo == 1) then {_garrison pushBack _tipo} else {_garrison append _tipo};
	};
garrison setVariable [_marcador,_garrison,true];
garrisonIsChanging = false;