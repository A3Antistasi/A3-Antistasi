private ["_marcador","_threat","_posicion","_analyzed","_lado"];

_threat = 0;

//if (("launch_I_Titan_short_F" in unlockedWeapons) or ("launch_NLAW_F" in unlockedWeapons)) then {_threat = 3};

_marcador = _this select 0;
_lado = _this select 1;
if (_marcador isEqualType []) then {_posicion = _marcador} else {_posicion = getMarkerPos _marcador};
_threat = _threat + 2 * ({(isOnRoad getMarkerPos _x) and (getMarkerPos _x distance _posicion < distanceSPWN)} count outpostsFIA);

{
if (getMarkerPos _x distance _posicion < distanceSPWN) then
	{
	_analyzed = _x;
	_garrison = garrison getVariable [_analyzed,[]];
	_threat = _threat + (floor((count _garrison)/8));
	//_size = [_analyzed] call A3A_fnc_sizeMarker;
	_staticsX = staticsToSave select {_x inArea _analyzed};
	if (count _staticsX > 0) then
		{
		_threat = _threat + ({typeOf _x == SDKMortar} count _staticsX) + (2*({typeOf _x == staticATBuenos} count _staticsX))
		};
	};
} forEach (markersX - citiesX - controlsX - outpostsFIA) select {lados getVariable [_x,sideUnknown] != _lado};

_threat