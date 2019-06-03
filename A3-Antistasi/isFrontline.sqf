private ["_markerX","_isFrontier","_positionX","_mrkENY"];

_markerX = _this select 0;
_isFrontier = false;

_lado = lados getVariable [_markerX,sideUnknown];
_mrkENY = (airportsX + outposts + seaports) select {lados getVariable [_x,sideUnknown] != _lado};

if (count _mrkENY > 0) then
	{
	_positionX = getMarkerPos _markerX;
	{if (_positionX distance (getMarkerPos _x) < distanceSPWN) exitWith {_isFrontier = true}} forEach _mrkENY;
	};
_isFrontier