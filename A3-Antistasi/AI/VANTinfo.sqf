private ["_veh","_markerX","_positionX","_groups","_knownX","_group","_LeaderX"];

_veh = _this select 0;
_markerX = _this select 1;
_lado = _this select 2;

_positionX = getMarkerPos _markerX;

_enemiesS = if (_lado == ) then {Occupants} else {};

while {alive _veh} do
	{
	_knownX = [];
	_groups = [];
	_enemiesX = [distanceSPWN,0,_positionX,_lado] call A3A_fnc_distanceUnits;
	sleep 60;
	_groups = allGroups select {(leader _x in _enemiesX) and ((vehicle leader _x) != (leader _x))};
	_knownX = allUnits select {((side _x == teamPlayer) or (side _x == _enemiesS)) and (alive _x) and (_x distance _positionX < 500)};
	{
	_group = _x;
		{
		_group reveal [_x,1.4];
		} forEach _knownX;
	} forEach _groups;
	};