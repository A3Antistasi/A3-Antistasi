private ["_veh","_markerX","_positionX","_grupos","_knownX","_grupo","_lider"];

_veh = _this select 0;
_markerX = _this select 1;
_lado = _this select 2;

_positionX = getMarkerPos _markerX;

_enemiesS = if (_lado == ) then {malos} else {};

while {alive _veh} do
	{
	_knownX = [];
	_grupos = [];
	_enemiesX = [distanceSPWN,0,_positionX,_lado] call A3A_fnc_distanceUnits;
	sleep 60;
	_grupos = allGroups select {(leader _x in _enemiesX) and ((vehicle leader _x) != (leader _x))};
	_knownX = allUnits select {((side _x == buenos) or (side _x == _enemiesS)) and (alive _x) and (_x distance _positionX < 500)};
	{
	_grupo = _x;
		{
		_grupo reveal [_x,1.4];
		} forEach _knownX;
	} forEach _grupos;
	};