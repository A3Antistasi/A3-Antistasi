private ["_unit","_dist","_return"];
_unit = _this select 0;
_dist = _this select 1;
_return = false;
{if (_x distance _unit < _dist) exitWith {_return = true}} forEach (allUnits select {((side group _x == malos) or (side group _x == muyMalos)) and ([_x] call canFight)});
_return
