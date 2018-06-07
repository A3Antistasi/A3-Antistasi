private ["_aeropuertos","_reinfPlaces","_aeropuerto","_numero","_numGarr","_numReal","_lado","_posibles","_cuenta","_sitio","_posicion"];
_aeropuertos = aeropuertos select {(lados getVariable [_x,sideUnknown] != buenos) and (spawner getVariable _x == 2)};
if (count _aeropuertos == 0) exitWith {};
_reinfPlaces = [];
{
_aeropuerto = _x;
_numero = 8;
_numGarr = [_aeropuerto] call garrisonSize;
_numReal = count (garrison getVariable _aeropuerto);
_lado = lados getVariable [_aeropuerto,sideUnknown];
if (_numReal + 4 <= _numGarr) then
	{
	if (_numReal + 8 <= _numGarr) then
		{
		if (_lado == malos) then {[selectRandom gruposNATOSquad,_lado,_aeropuerto,0] remoteExec ["garrisonUpdate",2]} else {[selectRandom gruposCSATSquad,_lado,_aeropuerto,0] remoteExec ["garrisonUpdate",2]};
		_numero = 0;
		}
	else
		{
		if (_lado == malos) then {[selectRandom gruposNATOmid,_lado,_aeropuerto,0] remoteExec ["garrisonUpdate",2]} else {[selectRandom gruposCSATmid,_lado,_aeropuerto,0] remoteExec ["garrisonUpdate",2]};
		_numero = 4;
		};
	};
if ((_numero >= 4) and (reinfPatrols <= 4)) then
	{
	_posibles = (puestos + puertos - _reinfPlaces - (killZones getVariable [_aeropuerto,[]])) select {lados getVariable [_x,sideUnknown] == _lado};
	if (_posibles isEqualTo []) then
		{
		_posibles = (recursos + fabricas - _reinfPlaces - (killZones getVariable [_aeropuerto,[]])) select {lados getVariable [_x,sideUnknown] == _lado};
		};
	_posicion = getMarkerPos _aeropuerto;
	_posibles = _posibles select {((getMarkerPos _x distance2D _posicion) < distanceForAirAttack) and !(_x in forcedSpawn)};
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
			[[_sitio,_aeropuerto,_numero,_lado],"patrolReinf"] call scheduler;
			};
		};
	};
if (count _reinfPlaces > 3) exitWith {};
} forEach _aeropuertos;

if ((count _reinfPlaces == 0) and (AAFpatrols <= 3)) then {[] spawn AAFroadPatrol};