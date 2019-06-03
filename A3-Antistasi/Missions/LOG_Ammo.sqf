//Mission: Logistics for ammunition
if (!isServer and hasInterface) exitWith{};

private ["_pos","_camion","_truckCreated","_grupo","_grupo1","_mrk"];

_markerX = _this select 0;

_difficultX = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contactX = objNull;
_groupContact = grpNull;
_tsk = "";
_positionX = getMarkerPos _markerX;
_lado = if (lados getVariable [_markerX,sideUnknown] == malos) then {malos} else {Invaders};
_timeLimit = if (_difficultX) then {30} else {60};
if (hayIFA) then {_timeLimit = _timeLimit * 2};
_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_dateLimitNum = dateToNumber _dateLimit;

_nameDest = [_markerX] call A3A_fnc_localizar;
_tipoVeh = if (_lado == malos) then {vehNATOAmmoTruck} else {vehCSATAmmoTruck};
_size = [_markerX] call A3A_fnc_sizeMarker;

_road = [_positionX] call A3A_fnc_findNearestGoodRoad;
_pos = position _road;
_pos = _pos findEmptyPosition [1,60,_tipoVeh];
if (count _pos == 0) then {_pos = position _road};

[[buenos,civilian],"LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],"Steal or Destroy Ammotruck",_markerX],_pos,false,0,true,"rearm",true] call BIS_fnc_taskCreate;
_truckCreated = false;
missionsX pushBack ["LOG","CREATED"]; publicVariable "missionsX";

waitUntil {sleep 1;(dateToNumber date > _dateLimitNum) or ((spawner getVariable _markerX != 2) and !(lados getVariable [_markerX,sideUnknown] == buenos))};
_bonus = if (_difficultX) then {2} else {1};
if ((spawner getVariable _markerX != 2) and !(lados getVariable [_markerX,sideUnknown] == buenos)) then
	{
	//sleep 10;

	_camion = _tipoVeh createVehicle _pos;
	_camion setDir (getDir _road);
	_truckCreated = true;
	if (_lado == malos) then {[_camion] call A3A_fnc_NATOcrate} else {[_camion] call A3A_fnc_CSATcrate};

	_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], _pos];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [20,20];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
	if (!debug) then {_mrk setMarkerAlphaLocal 0};
	_typeGroup = if (_difficultX) then {if (_lado == malos) then {NATOSquad} else {CSATSquad}} else {if (_lado == malos) then {groupsNATOSentry} else {groupsCSATSentry}};
	//_cfg = if (_lado == malos) then {cfgNATOInf} else {cfgCSATInf};
	_grupo = [_pos,_lado, _typeGroup] call A3A_fnc_spawnGroup;
	sleep 1;
	if (random 10 < 33) then
		{
		_perro = _grupo createUnit ["Fin_random_F",_positionX,[],0,"FORM"];
		[_perro] spawn A3A_fnc_guardDog;
		};

	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";

	_grupo1 = [_pos,_lado,_typeGroup] call A3A_fnc_spawnGroup;
	sleep 1;
	_nul = [leader _grupo1, _mrk, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";

	{[_x,""] call A3A_fnc_NATOinit} forEach units _grupo;
	{[_x,""] call A3A_fnc_NATOinit} forEach units _grupo1;

	waitUntil {sleep 1; (not alive _camion) or (dateToNumber date > _dateLimitNum) or ({(_x getVariable ["spawner",false]) and (side group _x == buenos)} count crew _camion > 0)};

	if (dateToNumber date > _dateLimitNum) then
		{
		["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],"Steal or Destroy Ammotruck",_markerX],_positionX,"FAILED","rearm"] call A3A_fnc_taskUpdate;
		[-1200*_bonus] remoteExec ["A3A_fnc_timingCA",2];
		[-10*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
		};
	if ((not alive _camion) or ({(_x getVariable ["spawner",false]) and (side group _x == buenos)} count crew _camion > 0)) then
		{
		if ({(_x getVariable ["spawner",false]) and (side group _x == buenos)} count crew _camion > 0) then
			{
			["TaskFailed", ["", format ["Ammotruck Stolen in an %1",_nameDest]]] remoteExec ["BIS_fnc_showNotification",_lado];
			};
		[getPosASL _camion,_lado,"",false] spawn A3A_fnc_patrolCA;
		["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],"Steal or Destroy Ammotruck",_markerX],_positionX,"SUCCEEDED","rearm"] call A3A_fnc_taskUpdate;
		[0,300*_bonus] remoteExec ["A3A_fnc_resourcesFIA",2];
		[1200*_bonus] remoteExec ["A3A_fnc_timingCA",2];
		{if (_x distance _camion < 500) then {[10*_bonus,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
		};
	}
else
	{
	["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],"Steal or Destroy Ammotruck",_markerX],_positionX,"FAILED","rearm"] call A3A_fnc_taskUpdate;
	[-1200*_bonus] remoteExec ["A3A_fnc_timingCA",2];
	[-10*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
	};

_nul = [1200,"LOG"] spawn A3A_fnc_deleteTask;
if (_truckCreated) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	{deleteVehicle _x} forEach units _grupo1;
	deleteGroup _grupo1;
	deleteMarker _mrk;
	waitUntil {sleep 1; !([300,1,_camion,buenos] call A3A_fnc_distanceUnits)};
	deleteVehicle _camion;
	};
