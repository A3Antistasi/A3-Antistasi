private ["_mrkOrigin","_mrkDestination","_groupX","_posOrigin","_posDestination","_finalArray","_arr2","_final","_isCentral","_roadsCentral","_useCentral"];

_mrkOrigin = _this select 0;
_posOrigin = if (_mrkOrigin isEqualType "") then {getMarkerPos _mrkOrigin} else {_mrkOrigin};
_mrkDestination = _this select 1;
_posDestination = if (_mrkDestination isEqualType "") then {getMarkerPos _mrkDestination} else {_mrkDestination};
_exit = false;
if (_mrkOrigin isEqualType "") then
	{
	if ((_mrkOrigin != "airport") and (_mrkOrigin != "airport_2")) then {_exit = true};
	}
else
	{
	if !([_mrkOrigin,"airport"] call A3A_fnc_isTheSameIsland) then
		{
		_exit = true
		}
	else
		{
		if (_mrkOrigin distance2D (getMarkerPos "airport") < _mrkOrigin distance2D (getMarkerPos "airport_2")) then {_mrkOrigin = "airport"} else {_mrkOrigin = "airport_2"};
		};
	};
if (_exit) exitWith {};

_groupX = _this select 2;
_finalArray = [];
_arr2 = [];
_final = [roadsMrk,_posDestination] call BIS_fnc_nearestPosition;

_useCentral = true;
_isCentral = false;
if (_final in roadsCentral) then
	{
	_isCentral = true;
	}
else
	{
	if (_final in roadsCE) then
		{
		_arr2 = +roadsCE;
		}
	else
		{
		if (_final in roadsCSE) then
			{
			_arr2 = +roadsCSE;
			}
		else
			{
			if (_final in roadsSE) then
				{
				_arr2 = +roadsSE;
				}
			else
				{
				if (_final in roadsSW) then
					{
					_arr2 = +roadsSW;
					if (_mrkOrigin == "airport") then {_useCentral = false};
					}
				else
					{
					if (_final in roadsCW) then
						{
						_arr2 = +roadsCW;
						}
					else
						{
						if (_final in roadsNW) then
							{
							_arr2 = +roadsNW;
							}
						else
							{
							_arr2 = +roadsNE;
							if (_mrkOrigin == "airport_2") then {_useCentral = false};
							};
						};
					};
				};
			};
		};
	};

_roadsCentral = +roadsCentral;
if (_useCentral and (_mrkOrigin != "airport")) then {reverse _roadsCentral};

if (_isCentral) then
	{
	{
	_finalArray pushBack _x;
	if (_x == _final) exitWith {};
	} forEach _roadsCentral;
	}
else
	{
	if (_useCentral) then
		{
		_inicial = _arr2 select 0;
		_medio = [_roadsCentral,_inicial] call BIS_fnc_nearestPosition;
		{
		_finalArray pushBack _x;
		if (_x == _medio) exitWith {};
		} forEach _roadsCentral;
		{
		_finalArray pushBack _x;
		if (_x == _final) exitWith {};
		} forEach _arr2;
		}
	else
		{
		{
		_finalArray pushBack _x;
		if (_x == _final) exitWith {};
		} forEach _arr2;
		};
	};

if (getMarkerPos _final distance _posOrigin > _posDestination distance _posOrigin) then {_finalArray = _finalArray - [_final]};

for "_i" from 0 to ((count _finalArray) - 1) do
	{
	_groupX addWaypoint [getMarkerPos (_finalArray select _i), _i];
	/*
	_mrkFinal = createMarker [format ["DES%1", random 100], getMarkerPos (_finalArray select _i)];
	_mrkFinal setMarkerShape "ICON";
	_mrkFinal setMarkerType "hd_destroy";
	_mrkFinal setMarkerColor "ColorRed";
	_mrkFinal setMarkerText format ["%1",_i];
	*/
	};
