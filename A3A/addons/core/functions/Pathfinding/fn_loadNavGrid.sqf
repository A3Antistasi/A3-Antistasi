/*
Author: Wurzel0701
Maintainer: Jaj22, Bob-Murphy, MeltedPixel
    Loads all data for the navGrid

Arguments:
    <NULL>

Return Value:
    <NULL>

Scope: Server
Environment: Any
Public: Yes
Dependencies:
    <NULL>

Example:
    [] call A3A_fnc_loadNavGrid;
*/
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

if !(isNil "roadDataDone") exitWith
{
    Error("Nav grid already created, cant load it twice!");
};

Info("Started loading nav grid");

private _path = if (isText (missionConfigFile/"A3A"/"Navgrid"/worldName)) then {
    getText (missionConfigFile/"A3A"/"Navgrid"/worldName);
} else {
    getText (configFile/"A3A"/"Navgrid"/worldName);
};

if (!fileExists _path) exitWith { Error_1("Invalid path to navgird: %1", _path); };
private _navGridDB_formatted = preprocessFileLineNumbers _path;
if ("navGrid" in _navGridDB_formatted) then {   // Try to remove assignment code
    private _startIndex = (_navGridDB_formatted find "=") + 1;
    _navGridDB_formatted = _navGridDB_formatted select [_startIndex,count _navGridDB_formatted - _startIndex];

    private _endCount = (_navGridDB_formatted find ";");
    _navGridDB_formatted = _navGridDB_formatted select [0,_endCount];
};

NavGrid = parseSimpleArray _navGridDB_formatted;
if (NavGrid isEqualTo []) exitWith {
    Error_1("Road database for %1 could not be loaded", worldName);
    Error("Nav Grid with the name format navGrid<WorldName> are no longer compatible! DO NOT LOAD THEM!");
};

{
	private _index = _forEachIndex;
	private _position = _x select 0;
	if (count _position < 3) then { _position set [2, 0] };				// expand to ATL with global effect
	private _mainMarkers = [_position] call A3A_fnc_getMainPositions;
	{
		[_index, _x] call A3A_fnc_setNavData;
	} forEach _mainMarkers;
} forEach navGrid;

roadDataDone = true;

Info("Finished loading nav grid");
