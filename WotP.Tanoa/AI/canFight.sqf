private _unit = _this select 0;

if (isNull _unit) exitWith {false};
if (!alive _unit) exitWith {false};
if (captive _unit) exitWith {false};
if (lifeState _unit == "INCAPACITATED") exitWith {false};
if (_unit getVariable ["surrendered",false]) exitWith {false};
true