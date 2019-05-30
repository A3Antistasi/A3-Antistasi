private ["_markerX","_ok","_positionX","_antena","_cercano"];

_markerX = _this select 0;
_positionX = _this select 0;
if (typeName _markerX == typeName "") then {_positionX = getMarkerPos _markerX};
_ok = false;
if (count antenas > 0) then
	{
	for "_i" from 0 to (count antenas) - 1 do
		{
		_antena = antenas select _i;
		if ((alive _antena) and (_positionX distance _antena < 3500)) then
			{
			_cercano = [markersX,_antena] call BIS_fnc_nearestPosition;
			if (not(lados getVariable [_cercano,sideUnknown] == buenos)) then {_ok = true};
			};
		};
	};
_ok