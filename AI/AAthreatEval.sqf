private ["_marcador","_threat","_esMarcador","_posicion","_esFIA","_analizado","_size"];

_threat = 0;

//if ("launch_I_Titan_F" in unlockedWeapons) then {_threat = 5};


_marcador = _this select 0;
_esMarcador = true;
if (_marcador isEqualType []) then {_esMarcador = false; _posicion = _marcador} else {_posicion = getMarkerPos _marcador};

_esFIA = true;
if (_esMarcador) then
	{
	if (not (lados getVariable [_marcador,sideUnknown] == buenos)) then
		{
		_esFIA = false;
		{
		_marcadores = if (lados getVariable [_marcador,sideUnknown] == malos) then {controles + puestos + aeropuertos - mrkSDK - mrkNATO} else {controles + puestos + aeropuertos - mrkSDK - mrkCSAT};
		if (getMarkerPos _x distance _posicion < (distanciaSPWN*1.5)) then
			{
			if (_x in aeropuertos) then {_threat = _threat + 3} else {_threat = _threat + 1};
			};
		} forEach _marcadores;
		};
	};

if (_esFIA) then
	{
	{
	if (getMarkerPos _x distance _posicion < distanciaSPWN) then
		{
		_analizado = _x;
		_garrison = garrison getVariable [_analizado,[]];
		_threat = _threat + (floor((count _garrison)/8));
		_size = [_analizado] call sizeMarker;
		_estaticas = staticsToSave select {_x distance (getMarkerPos _analizado) < _size};
		if (count _estaticas > 0) then
			{
			_threat = _threat + ({typeOf _x == SDKMGStatic} count _estaticas) + (5*({typeOf _x == staticAABuenos} count _estaticas));
			};
		};
	} forEach (mrkSDK - ciudades - controles - puestosFIA);
	};

_threat