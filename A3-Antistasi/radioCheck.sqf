private ["_marcador","_ok","_posicion","_antena","_cercano"];

_marcador = _this select 0;
_posicion = _this select 0;
if (typeName _marcador == typeName "") then {_posicion = getMarkerPos _marcador};
_ok = false;
if (count antennas > 0) then
	{
	for "_i" from 0 to (count antennas) - 1 do
		{
		_antena = antenas select _i;
		if ((alive _antena) and (_posicion distance _antena < 3500)) then
			{
			_nearX = [markersX,_antena] call BIS_fnc_nearestPosition;
			if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) then {_ok = true};
			};
		};
	};
_ok
