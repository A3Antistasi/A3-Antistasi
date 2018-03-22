private ["_aeropuertos","_reinfPlaces","_aeropuerto","_numero","_numGarr","_numReal","_lado","_posibles","_cuenta","_sitio","_posicion"];
_aeropuertos = aeropuertos select {!(_x in mrkSDK) and (spawner getVariable _x == 2)};
_reinfPlaces = [];
{
_aeropuerto = _x;
_numero = 8;
_numGarr = [_aeropuerto] call garrisonSize;
_numReal = count (garrison getVariable _aeropuerto);
_lado = if (lados getVariable [_aeropuerto,sideUnknown] == malos) then {malos} else {muyMalos};
if (_numReal + 4 <= _numGarr) then
	{
	if (_numReal + 8 <= _numGarr) then
		{
		if (_lado == malos) then {[selectRandom gruposNATOSquad,_lado,_aeropuerto,0] spawn garrisonUpdate} else {[selectRandom gruposCSATSquad,_lado,_aeropuerto,0] spawn garrisonUpdate};
		_numero = 0;
		}
	else
		{
		if (_lado == malos) then {[selectRandom gruposNATOmid,_lado,_aeropuerto,0] spawn garrisonUpdate} else {[selectRandom gruposCSATmid,_lado,_aeropuerto,0] spawn garrisonUpdate};
		_numero = 4;
		};
	};
if ((_numero >= 4) and (reinfPatrols <= 4)) then
	{
	_posibles = recursos + fabricas + puestos + puertos - mrkSDK - _reinfPlaces - (killZones getVariable _aeropuerto);
	if (_lado == malos) then {_posibles = _posibles arrayIntersect mrkNATO} else {_posibles = _posibles arrayIntersect mrkCSAT};
	_posicion = getMarkerPos _aeropuerto;
	_posibles = _posibles select {((getMarkerPos _x distance2D _posicion) < 5000)};
	if (count _posibles > 0) then
		{
		_cuenta = 0;
		_sitio = "";
		{
		_numGarr = [_x] call garrisonSize;
		_numReal = count (garrison getVariable _x);
		if (_numGarr - _numReal > _cuenta) then
			{
			_cuenta = _numGarr - _numReal;
			_sitio = _x;
			};
		} forEach _posibles;
		if (_sitio != "") then
			{
			_reinfPlaces pushBack _sitio;
			[_sitio,_aeropuerto,_numero,_lado] call patrolReinf;
			};
		};
	};
if (count _reinfPlaces > 3) exitWith {};
} forEach _aeropuertos;

if ((count _reinfPlaces == 0) and (AAFpatrols <= 3)) then {[] spawn AAFroadPatrol};