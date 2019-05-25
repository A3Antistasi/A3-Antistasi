//Mission: Conquer the outpost
if (!isServer and hasInterface) exitWith{};

private ["_markerX"];

_markerX = _this select 0;

_difficultX = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contactX = objNull;
_groupContact = grpNull;
_tsk = "";
_positionX = getMarkerPos _markerX;
_timeLimit = if (_difficultX) then {30} else {90};//120
if (hasIFA) then {_timeLimit = _timeLimit * 2};
_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_dateLimitNum = dateToNumber _dateLimit;

_nameDest = [_markerX] call A3A_fnc_localizar;
_texto = "";
_taskName = "";
if (_markerX in resourcesX) then
	{
	_texto = format ["A %1 would be a fine addition to our cause. Go there and capture it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4];
	_taskName = "Resource Acquisition";
	}
else
	{
	_texto = format ["A %1 is disturbing our operations in the area. Go there and capture it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4];
	_taskName = "Take the Outpost";
	};


[[teamPlayer,civilian],"CON",[_texto,_taskName,_markerX],_positionX,false,0,true,"Target",true] call BIS_fnc_taskCreate;
missionsX pushBack ["CON","CREATED"]; publicVariable "missionsX";
waitUntil {sleep 1; (dateToNumber date > _dateLimitNum) or (lados getVariable [_markerX,sideUnknown] == teamPlayer)};

if (dateToNumber date > _dateLimitNum) then
	{
	["CON",[_texto,_taskName,_markerX],_positionX,"FAILED"] call A3A_fnc_taskUpdate;
	if (_difficultX) then
		{
		[10,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
		[-1200] remoteExec ["A3A_fnc_timingCA",2];
		[-20,theBoss] call A3A_fnc_playerScoreAdd;
		}
	else
		{
		[5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
		[-600] remoteExec ["A3A_fnc_timingCA",2];
		[-10,theBoss] call A3A_fnc_playerScoreAdd;
		};
	}
else
	{
	sleep 10;
	["CON",[_texto,_taskName,_markerX],_positionX,"SUCCEEDED"] call A3A_fnc_taskUpdate;
	if (_difficultX) then
		{
		[0,400] remoteExec ["A3A_fnc_resourcesFIA",2];
		[-10,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
		[1200] remoteExec ["A3A_fnc_timingCA",2];
		{if (isPlayer _x) then {[20,_x] call A3A_fnc_playerScoreAdd}} forEach ([500,0,_positionX,teamPlayer] call A3A_fnc_distanceUnits);
		[20,theBoss] call A3A_fnc_playerScoreAdd;
		}
	else
		{
		[0,200] remoteExec ["A3A_fnc_resourcesFIA",2];
		[-5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
		[600] remoteExec ["A3A_fnc_timingCA",2];
		{if (isPlayer _x) then {[10,_x] call A3A_fnc_playerScoreAdd}} forEach ([500,0,_positionX,teamPlayer] call A3A_fnc_distanceUnits);
		[10,theBoss] call A3A_fnc_playerScoreAdd;
		};
	};

_nul = [1200,"CON"] spawn A3A_fnc_deleteTask;
