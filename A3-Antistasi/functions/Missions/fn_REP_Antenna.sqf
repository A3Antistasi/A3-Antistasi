//Mission: Repair the antenna
if (!isServer and hasInterface) exitWith{};
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private ["_markerX","_antennaDead","_dateLimit","_dateLimitNum","_nameDest","_truckCreated","_size","_pos","_veh","_groupX","_unit"];

_markerX = _this select 0;
_antennaDead = _this select 1;

_timeLimit = 60;
_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_dateLimitNum = dateToNumber _dateLimit;
_dateLimit = numberToDate [date select 0, _dateLimitNum];//converts datenumber back to date array so that time formats correctly
_displayTime = [_dateLimit] call A3A_fnc_dateToTimeString;//Converts the time portion of the date array to a string for clarity in hints

_nameDest = [_markerX] call A3A_fnc_localizar;

private _taskId = "REP" + str A3A_taskCount;
[
	[teamPlayer, civilian],
	_taskId,
	[
		format ["%3 is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2.",_nameDest,_displayTime,FactionGet(occ,"name")],
		"Tower Rebuild Disrupt",
		_markerX
	],
	getPos _antennaDead,
	false, 0, true, "Destroy", true
] call BIS_fnc_taskCreate;
[_taskId, "REP", "CREATED"] remoteExecCall ["A3A_fnc_taskUpdate", 2];
_truckCreated = false;

waitUntil {sleep 1;(dateToNumber date > _dateLimitNum) or (spawner getVariable _markerX != 2)};

if (spawner getVariable _markerX != 2) then
	{
	_truckCreated = true;
	_size = [_markerX] call A3A_fnc_sizeMarker;
	_road = [getPos _antennaDead] call A3A_fnc_findNearestGoodRoad;
	_pos = position _road;
	_pos = _pos findEmptyPosition [1,60,"B_T_Truck_01_repair_F"];
	_veh = createVehicle [FactionGet(occ,"vehiclesRepairTrucks"), _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir (getDir _road);
	_nul = [_veh, Occupants] call A3A_fnc_AIVEHinit;
	_groupX = createGroup Occupants;

	sleep 5;
	_veh allowDamage true;

	for "_i" from 1 to 3 do
		{
		_unit = [_groupX, FactionGet(occ,"unitCrew"), _pos, [], 0, "NONE"] call A3A_fnc_createUnit;
		[_unit,""] call A3A_fnc_NATOinit;
		sleep 2;
		};

	waitUntil {sleep 1;(dateToNumber date > _dateLimitNum) or (not alive _veh)};

	if (not alive _veh) then
		{
		[_taskId, "REP", "SUCCEEDED"] call A3A_fnc_taskSetState;
        [Occupants, 15, 90] remoteExec ["A3A_fnc_addAggression", 2];
        [Invaders, 5, 60] remoteExec ["A3A_fnc_addAggression", 2];
		[1200, Occupants] remoteExec ["A3A_fnc_timingCA",2];
		{if (_x distance _veh < 500) then {[10,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5,theBoss] call A3A_fnc_playerScoreAdd;
		};
	};
if (dateToNumber date > _dateLimitNum) then
	{
	if (sidesX getVariable [_markerX,sideUnknown] == teamPlayer) then
		{
		[_taskId, "REP", "SUCCEEDED"] call A3A_fnc_taskSetState;
        [Occupants, 15, 90] remoteExec ["A3A_fnc_addAggression", 2];
        [Invaders, 5, 60] remoteExec ["A3A_fnc_addAggression", 2];
		[1200, Occupants] remoteExec ["A3A_fnc_timingCA",2];
		{if (_x distance _veh < 500) then {[10,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5,theBoss] call A3A_fnc_playerScoreAdd;
		}
	else
		{
		[_taskId, "REP", "FAILED"] call A3A_fnc_taskSetState;
		//[5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
		[-600, Occupants] remoteExec ["A3A_fnc_timingCA",2];
		[-10,theBoss] call A3A_fnc_playerScoreAdd;
		};
	[_antennaDead] remoteExec ["A3A_fnc_rebuildRadioTower", 2];
	};

[_taskId, "REP", 30] spawn A3A_fnc_taskDelete;

waitUntil {sleep 1; (spawner getVariable _markerX == 2)};

// could make these guys return home, too much work atm
[_groupX] spawn A3A_fnc_groupDespawner;
[_veh] spawn A3A_fnc_vehDespawner;
