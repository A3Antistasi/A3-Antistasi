private ["_marcador","_pos","_aeropuertosAAF","_aeropuertos","_base","_posbase","_busy","_radio"];

_marcador = _this select 0;
_pos = _this select 0;
if (typeName _marcador == typeName "") then {_pos = getMarkerPos _marcador};
_aeropuertosAAF = aeropuertos select {lados getVariable [_x,sideUnknown] != buenos};
_aeropuertos = [];
_base = "";
{
_base = _x;
_posbase = getMarkerPos _base;
_busy = if (dateToNumber date > server getVariable _base) then {false} else {true};
if (count _this > 1) then {_radio = true} else {_radio = [_base] call radioCheck};

if ((!_busy) and (spawner getVariable _base == 2)) then
	{
	if (((_pos distance _posbase < 5000) and (_radio)) or (_pos distance _posbase < 2000)) then {_aeropuertos = _aeropuertos + [_base]};
	};
} forEach _aeropuertosAAF;
if (count _aeropuertos > 0) then {_base = [_aeropuertos,_pos] call BIS_fnc_nearestPosition;} else {_base = ""};
_base