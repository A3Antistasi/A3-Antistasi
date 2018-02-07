private ["_tiempo","_tsk"];

_tiempo = _this select 0;
_tsk = _this select 1;

if (_tiempo > 0) then {sleep ((_tiempo/2) + random _tiempo)};

_nul = [_tsk] call BIS_fnc_deleteTask;
misiones = misiones - [_tsk];
publicVariable "misiones";
/*
_nul = [_tsk] call BIS_fnc_deleteTask;
sleep 10;
[[_tsk,true,false],"bis_fnc_deleteTask"] call bis_fnc_mp;