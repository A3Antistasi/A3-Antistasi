if (!isServer) exitWith {};

if (leader group Petros != Petros) exitWith {};

_tipos = ["AS","CON","DES","LOG","RES","CONVOY"];
/*_tipo = "";

if (!isPlayer stavros) then {_tipos = _tipos - ["AS"]};

{
if ([_x] call BIS_fnc_taskExists) then {_tipos = _tipos - [_x]};
} forEach _tipos;
if (count _tipos == 0) exitWith {};
*/
_tipo = selectRandom (_tipos select {!([_x] call BIS_fnc_taskExists)});
if (isNil "_tipo") exitWith {};
_nul = [_tipo,true] call missionRequest;