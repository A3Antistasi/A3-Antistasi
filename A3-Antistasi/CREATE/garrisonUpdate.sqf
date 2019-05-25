if (!isServer) exitWith {};
private ["_typeX","_sideX","_markerX","_modeX","_garrison","_subType"];
_typeX = _this select 0;
if (_typeX isEqualType []) then
	{
	if ((_typeX select 0) isEqualType objNull) then
		{
		_subType = [];
		{
		_subType pushBack (typeOf _x);
		} forEach _typeX;
		_typeX = _subType;
		};
	}
else
	{
	if (_typeX isEqualType objNull) then {_typeX = typeOf _typeX};
	};
_sideX = _this select 1;
_markerX = _this select 2;
if !(_markerX isEqualType "") exitWith {diag_log format ["Antistasi error: En garrison update hemos enviado algo que no es markerX. Params: %1",_this]};
_modeX = _this select 3;//-1 to remove 1 unbit (killed EHs etc). 1 add 1 single classname / object. 2 adds a hole array and admits classnames or objects
_exit = false;
//diag_log format ["Antistasi: Error en garrisonUpdate al enviar mal dataX: %1,%2,%3,%4",_typeX,_sideX,_markerX,_modeX];
{if (isNil _x) exitWith {_exit = true}} forEach ["_typeX","_sideX","_markerX","_modeX"];
if (_exit) exitWith {diag_log format ["Antistasi: Error en garrisonUpdate al enviar mal dataX: %1,%2,%3,%4",_typeX,_sideX,_markerX,_modeX]};
waitUntil {!garrisonIsChanging};
{if (isNil _x) exitWith {_exit = true}} forEach ["_typeX","_sideX","_markerX","_modeX"];
if (_exit) exitWith {diag_log format ["Antistasi: Error en garrisonUpdate al enviar mal dataX: %1,%2,%3,%4",_typeX,_sideX,_markerX,_modeX]};
garrisonIsChanging = true;
if ((_sideX == Occupants) and (!(sidesX getVariable [_markerX,sideUnknown] == Occupants))) exitWith {garrisonIsChanging = false};
if ((_sideX == ) and (!(sidesX getVariable [_markerX,sideUnknown] == ))) exitWith {garrisonIsChanging = false};
if ((_sideX == teamPlayer) and (!(sidesX getVariable [_markerX,sideUnknown] == teamPlayer))) exitWith {garrisonIsChanging = false};
_garrison = [];
_garrison = _garrison + (garrison getVariable [_markerX,[]]);
if (_modeX == -1) then
	{
	for "_i" from 0 to (count _garrison -1) do
		{
		if (_typeX == (_garrison select _i)) exitWith {_garrison deleteAt _i};
		};
	}
else
	{
	if (_modeX == 1) then {_garrison pushBack _typeX} else {_garrison append _typeX};
	};
if (isNil "_garrison") exitWith {garrisonIsChanging = false};
garrison setVariable [_markerX,_garrison,true];
if (_sideX == teamPlayer) then {[_markerX] call A3A_fnc_mrkUpdate};
garrisonIsChanging = false;
