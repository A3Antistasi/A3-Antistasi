private _unit = _this select 0;
if !([_unit] call canFight) exitWith {false};
if (fleeing _unit) exitWith {false};
if (vehicle _unit isKindOf "Air") exitWith {false};
if !(_unit inArea (_this select 1)) exitWith {false};
true