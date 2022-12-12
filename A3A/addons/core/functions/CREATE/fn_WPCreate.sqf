/*
Maintainer: Wurzel0701
    Creates waypoints for spawned units to safely arrive at targets

Arguments:
    <POS> The start position OR <STRING> The start marker
    <POS> The end position OR <STRING> The end marker
    <GROUP> The group for which the waypoints should be created

Return Value:
    <NULL>

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
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

Debug_3("Creating waypoints for group %1 from %2 to %3", _group, _origin, _destination);

private _posOrigin = if(_origin isEqualType "") then {getMarkerPos _origin} else {_origin};
private _posDestination = if(_destination isEqualType "") then {getMarkerPos _destination} else {_destination};

private _path = [_posOrigin, _posDestination] call A3A_fnc_findPath;
_path = [_path] call A3A_fnc_trimPath;

//Get rid of the first part of to avoid driving back
if(count _path > 0) then
{
    _path deleteAt 0;
};

private _waypoints = _path apply {_group addWaypoint [_x, 0]};
{_x setWaypointBehaviour "SAFE"} forEach _waypoints;

if (count _waypoints > 0) then
{
    _group setCurrentWaypoint (_waypoints select 0);
};
