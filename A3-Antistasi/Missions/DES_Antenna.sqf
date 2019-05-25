//Mission: Destroy the antenna
if (!isServer and hasInterface) exitWith{};

private ["_antena","_positionX","_timeLimit","_markerX","_nameDest","_mrkfin","_tsk"];

_antena = _this select 0;
_markerX = [markersX,_antena] call BIS_fnc_nearestPosition;

_difficultX = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contactX = objNull;
_groupContact = grpNull;
_tsk = "";
_nameDest = [_markerX] call A3A_fnc_localizar;
_positionX = getPos _antena;

_timeLimit = if (_difficultX) then {30} else {120};
if (hayIFA) then {_timeLimit = _timeLimit * 2};
_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_dateLimitNum = dateToNumber _dateLimit;

_mrkfin = createMarker [format ["DES%1", random 100], _positionX];
_mrkfin setMarkerShape "ICON";

[[buenos,civilian],"DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4,nameOccupants],"Destroy Radio Tower",_mrkfin],_positionX,false,0,true,"Destroy",true] call BIS_fnc_taskCreate;
missionsX pushBack ["DES","CREATED"]; publicVariable "missionsX";
waitUntil {sleep 1;(dateToNumber date > _dateLimitNum) or (not alive _antena) or (not(lados getVariable [_markerX,sideUnknown] == Occupants))};

_bonus = if (_difficultX) then {2} else {1};

if (dateToNumber date > _dateLimitNum) then
	{
	["DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4,nameOccupants],"Destroy Radio Tower",_mrkfin],_positionX,"FAILED","Destroy"] call A3A_fnc_taskUpdate;
	//[5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
	[-10*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
	[-3,0] remoteExec ["A3A_fnc_prestige",2]
	}
else
	{
	sleep 15;
	["DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4,nameOccupants],"Destroy Radio Tower",_mrkfin],_positionX,"SUCCEEDED","Destroy"] call A3A_fnc_taskUpdate;
	//[-5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
	[5,-5] remoteExec ["A3A_fnc_prestige",2];
	[600*_bonus] remoteExec ["A3A_fnc_timingCA",2];
	{if (_x distance _positionX < 500) then {[10*_bonus,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
	[3,0] remoteExec ["A3A_fnc_prestige",2]
	};

deleteMarker _mrkfin;

_nul = [1200,"DES"] spawn A3A_fnc_deleteTask;
