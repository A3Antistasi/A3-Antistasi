private ["_marcador","_pos","_aeropuertosAAF","_aeropuertos","_aeropuerto","_posaeropuerto","_radio"];

_marcador = _this select 0;
_pos = _this select 0;
if (typeName _marcador == typeName "") then {_pos = getMarkerPos _marcador};
_aeropuertosAAF = aeropuertos select {lados getVariable [_x,sideUnknown] != buenos};
_aeropuertos = [];
_aeropuerto = "";
{
_aeropuerto = _x;
_busy = if (dateToNumber date > server getVariable _aeropuerto) then {false} else {true};;
_posaeropuerto = getMarkerPos _aeropuerto;
if (count _this > 1) then {_radio = true} else {_radio = [_aeropuerto] call radioCheck};
if ((_pos distance _posaeropuerto < 10000) and (_pos distance _posaeropuerto > 2000) and ((spawner getVariable _aeropuerto == 2)) and (!_busy) and (_radio)) then {_aeropuertos = _aeropuertos + [_aeropuerto]}
} forEach _aeropuertosAAF;

if (count _aeropuertos > 0) then {_aeropuerto = [_aeropuertos,_pos] call BIS_fnc_nearestPosition;} else {_aeropuerto = ""};
_aeropuerto