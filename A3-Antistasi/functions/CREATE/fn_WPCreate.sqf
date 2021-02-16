/*
Maintainer: Wurzel0701
    Creates waypoints for spawned units to safely arrive at targets

Arguments:
    <POS> The start position OR <STRING> The start marker
    <POS> The end position OR <STRING> The end marker
    <GROUP> The group for which the waypoints should be created

Return Value:
    <ARRAY> Simplified path

Scope: Any
Environment: Any
Public: No
Dependencies:
    <NULL>

Example:
    [_path] call A3A_fnc_trimPath;
*/

params
[
    ["_origin", [0,0,0], [[], ""]],
    ["_destination", [0,0,0], [[], ""]],
    ["_group", grpNull, [grpNull]]
];

private _posOrigin = if(_origin isEqualType "") then {getMarkerPos _origin} else {_origin};
private _posDestination = if(_destination isEqualType "") then {getMarkerPos _destination} else {_destination};

private _path = [_posOrigin, _posDestination] call A3A_fnc_findPath;
_path = [_path] call A3A_fnc_trimPath;

private _waypoints = _path apply {_group addWaypoint [_x, 0]};
{_x setWaypointBehaviour "SAFE"} forEach _waypoints;

if (count _waypoints > 0) then
{
    _group setCurrentWaypoint (_waypoints select 0);
};

_waypoints;
