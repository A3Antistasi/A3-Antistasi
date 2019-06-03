private ["_airportsX","_reinfPlaces","_airportX","_numero","_numGarr","_numReal","_lado","_potentials","_countX","_sitio","_positionX"];
_airportsX = airportsX select {(lados getVariable [_x,sideUnknown] != teamPlayer) and (spawner getVariable _x == 2)};
if (count _airportsX == 0) exitWith {};
_reinfPlaces = [];
{
_airportX = _x;
_numero = 8;
_numGarr = [_airportX] call A3A_fnc_garrisonSize;
_numReal = count (garrison getVariable _airportX);
_lado = lados getVariable [_airportX,sideUnknown];
if (_numReal + 4 <= _numGarr) then
	{
	if (_numReal + 8 <= _numGarr) then
		{
		if (_lado == malos) then {[selectRandom groupsNATOSquad,_lado,_airportX,0] remoteExec ["A3A_fnc_garrisonUpdate",2]} else {[selectRandom groupsCSATSquad,_lado,_airportX,0] remoteExec ["A3A_fnc_garrisonUpdate",2]};
		_numero = 0;
		}
	else
		{
		if (_lado == malos) then {[selectRandom groupsNATOmid,_lado,_airportX,0] remoteExec ["A3A_fnc_garrisonUpdate",2]} else {[selectRandom groupsCSATmid,_lado,_airportX,0] remoteExec ["A3A_fnc_garrisonUpdate",2]};
		_numero = 4;
		};
	};
if ((_numero >= 4) and (reinfPatrols <= 4)) then
	{
	_potentials = (outposts + seaports - _reinfPlaces - (killZones getVariable [_airportX,[]])) select {lados getVariable [_x,sideUnknown] == _lado};
	if (_potentials isEqualTo []) then
		{
		_potentials = (resourcesX + factories - _reinfPlaces - (killZones getVariable [_airportX,[]])) select {lados getVariable [_x,sideUnknown] == _lado};
		};
	_positionX = getMarkerPos _airportX;
	_potentials = _potentials select {((getMarkerPos _x distance2D _positionX) < distanceForAirAttack) and !(_x in forcedSpawn)};
	if (count _potentials > 0) then
		{
		_countX = 0;
		_sitio = "";
		{
		_numGarr = [_x] call A3A_fnc_garrisonSize;
		_numReal = count (garrison getVariable _x);
		if (_numGarr - _numReal > _countX) then
			{
			_countX = _numGarr - _numReal;
			_sitio = _x;
			};
		} forEach _potentials;
		if (_sitio != "") then
			{
			if ({(getMarkerPos _x distance2d getMarkerPos _sitio < distanceSPWN) and (lados getVariable [_x,sideUnknown] != _lado)} count airportsX == 0) then
				{
				if ({(_x distance2D _positionX < (2*distanceSPWN)) or (_x distance2D (getMarkerPos _sitio) < (2*distanceSPWN))} count allPlayers == 0) then
					{
					_typeGroup = if (_lado == malos) then {if (_numero == 4) then {selectRandom groupsNATOmid} else {selectRandom groupsNATOSquad}} else {if (_numero == 4) then {selectRandom groupsCSATmid} else {selectRandom groupsCSATSquad}};
					[_typeGroup,_lado,_sitio,2] remoteExec ["A3A_fnc_garrisonUpdate",2];
					}
				else
					{
					_reinfPlaces pushBack _sitio;
					[[_sitio,_airportX,_numero,_lado],"A3A_fnc_patrolReinf"] call A3A_fnc_scheduler;
					};
				};
			};
		};
	};
if (count _reinfPlaces > 3) exitWith {};
} forEach _airportsX;

if ((count _reinfPlaces == 0) and (AAFpatrols <= 3)) then {[] spawn A3A_fnc_AAFroadPatrol};