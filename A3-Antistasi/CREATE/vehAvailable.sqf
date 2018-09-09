private ["_tipo","_cant"];
_tipo = _this select 0;
if (_tipo == "") exitWith {false};
_cant = timer getVariable _tipo;
if (isNil "_cant") exitWith {true};
if (_cant <= 0) exitWith {false};
if ({typeOf _x == _tipo} count vehicles >= (floor _cant)) exitWith {false};
true