private ["_group","_lado","_eny1","_eny2"];
_group = _this select 0;
_lado = side _group;
_eny1 = Occupants;
_eny2 = Invaders;
if (_lado == Occupants) then {_eny1 = teamPlayer} else {if (_lado == Invaders) then {_eny2 = teamPlayer}};

{_unit = _x;
if (!([distanceSPWN,1,_unit,_eny1] call A3A_fnc_distanceUnits) and !([distanceSPWN,1,_unit,_eny2] call A3A_fnc_distanceUnits)) then {deleteVehicle _unit}} forEach units _group;

{_unit = _x;
waitUntil {sleep 1;!([distanceSPWN,1,_unit,_eny1] call A3A_fnc_distanceUnits) and !([distanceSPWN,1,_unit,_eny2] call A3A_fnc_distanceUnits)};deleteVehicle _unit} forEach units _group;

deleteGroup _group;
