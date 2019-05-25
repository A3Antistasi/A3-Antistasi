private ["_markerX","_ok","_positionX","_antena","_nearX"];

_markerX = _this select 0;
_positionX = _this select 0;
if (typeName _markerX == typeName "") then {_positionX = getMarkerPos _markerX};
_ok = false;
if (count antennas > 0) then
	{
	for "_i" from 0 to (count antennas) - 1 do
		{
		_antena = antennas select _i;
		if ((alive _antena) and (_positionX distance _antena < 3500)) then
			{
			_nearX = [markersX,_antena] call BIS_fnc_nearestPosition;
			if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) then {_ok = true};
			};
		};
	};
_ok