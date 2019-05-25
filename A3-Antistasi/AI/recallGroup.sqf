private _group = _this;
private _array = if (_group isEqualType grpNull) then {((units _group) - [_group getVariable ["mortarX",objNull]])} else {[_group]};
{
_x forceSpeed -1;
_x setVariable ["maneuvering",false];
if (_x == leader _x) then
	{
	_wp = currentWaypoint group _x;
	_dest = waypointPosition [group _x,_wp];
	_x doMove _dest;
	}
else
	{
	_x doFollow leader _x;
	};
} forEach _array;
(group (_array select 0)) setVariable ["occupiedX",[]];