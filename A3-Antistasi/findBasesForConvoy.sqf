private ["_marcador","_pos","_aeropuertosAAF","_aeropuertos","_base","_posbase","_busy"];

_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_aeropuertosAAF = aeropuertos select {(spawner getVariable _x == 2) and (dateToNumber date > server getVariable _x) and ([_x,_marcador] call isTheSameIsland) and (!(_x in forcedSpawn)) and (lados getVariable [_x,sideUnknown] != buenos)};
if (_marcador in ciudades) then {_aeropuertosAAF = _aeropuertosAAF select {lados getVariable [_x,sideUnknown] == malos}};
_aeropuertos = [];
_base = "";
{
_base = _x;
_posbase = getMarkerPos _base;
if ((_pos distance _posbase < 5000) and (_pos distance _posbase > 500)   and (({_x == _marcador} count (killZones getVariable [_base,[]])) < 3)) then {_aeropuertos pushBack _base}
} forEach _aeropuertosAAF;
if (count _aeropuertos > 0) then {_base = [_aeropuertos,_pos] call BIS_fnc_nearestPosition} else {_base = ""};
_base