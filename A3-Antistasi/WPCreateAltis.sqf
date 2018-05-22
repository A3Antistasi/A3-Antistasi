private ["_mrkOrigen","_mrkDestino","_posOrigen","_posDestino","_roadsMrk","_finalArray"];
_mrkOrigen = _this select 0;
_posOrigen = if (_mrkOrigen isEqualType "") then {getMarkerPos _mrkOrigen} else {_mrkOrigen};
_mrkDestino = _this select 1;
_posDestino = if (_mrkDestino isEqualType "") then {getMarkerPos _mrkDestino} else {_mrkDestino};
_distance = _posOrigen distance2d _posDestino;
if (_distance < 1500) exitWith {};
_roadsMrk = roadsMrk + (controles select {isOnRoad (getMarkerPos _x)});
_roadsMrk = _roadsMrk select {((getMarkerPos _x) distance _posDestino < _distance) and ((getMarkerPos _x) distance _posOestino < _distance)};
if (_roadsMrk isEqualTo []) exitWith {};
_roadsMrk = [_roadsMrk,[],{getMarkerPos _x distance2d _posOrigen},"ASCEND"] call BIS_fnc_sortBy;
_grupo = _this select 2;

for "_i" from 0 to (count _roadsMrk) - 1 do
	{
	_grupo addWaypoint [getMarkerPos (_roadsMrk select _i), _i];
	};