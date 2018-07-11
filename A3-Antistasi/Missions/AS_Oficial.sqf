if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;

_dificil = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contacto = objNull;
_grpContacto = grpNull;
_tsk = "";

if (_dificil) then
	{
	_result = [] call spawnMissionGiver;
	_ciudad = _result select 0;
	if (_ciudad == "") exitWith {_dificil = false};
	_contacto = _result select 1;

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 30;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;
	[[buenos,civilian],"AS",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,false,0,true,"talk",true] call BIS_fnc_taskCreate;
	misiones pushBack ["AS","CREATED"]; publicVariable "misiones";
	//_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
	//misiones pushBack _tsk; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (lados getVariable [_marcador,sideUnknown] == buenos) exitWith
			{
			_salir = true;
			{
			if (isPlayer _x) then {[_contacto,"globalChat","My information is useless now"] remoteExec ["commsMP",_x]}
			} forEach ([50,0,position _contacto,"GREENFORSpawn"] call distanceUnits);
			};
		};
	[_contacto] spawn
		{
		_contacto = _this select 0;
		_grpContacto = group _contacto;
		sleep cleanTime;
		deleteVehicle _contacto;
		deleteGroup _grpContacto;
		};
	if (_salir) exitWith
		{
		if (_contacto getVariable "statusAct") then
			{
			[0,"AS"] spawn borrarTask;
			}
		else
			{
			//["AS", "FAILED",true] spawn BIS_fnc_taskSetState;
			["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,"FAILED"] call taskUpdate;
			[1200,"AS"] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,"AS"] spawn borrarTask;
	waitUntil {sleep 1; !(["AS"] call BIS_fnc_taskExists)};
	};

_lado = if (lados getVariable [_marcador,sideUnknown] == malos) then {malos} else {muyMalos};
_posicion = getMarkerPos _marcador;

_tiempolim = if (_dificil) then {15} else {30};//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
_nombreBando = if (_lado == malos) then {"NATO"} else {"CSAT"};
/*
if (!_dificil) then
	{
	[[buenos,civilian],"AS",[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,false,0,true,"Kill",true] call BIS_fnc_taskCreate
	}
else
	{
	//["AS", "CREATED",true] spawn BIS_fnc_taskSetState;
	["AS",[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"CREATED","Kill"] call taskUpdate;
	};*/
//misiones pushBack _tsk; publicVariable "misiones";
[[buenos,civilian],"AS",[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,false,0,true,"Kill",true] call BIS_fnc_taskCreate;
misiones pushBack ["AS","CREATED"]; publicVariable "misiones";
_grp = createGroup _lado;

_tipo = if (_lado == malos) then {NATOOfficer} else {CSATOfficer};
_oficial = _grp createUnit [_tipo, _posicion, [], 0, "NONE"];
_tipo = if (_lado == malos) then {NATOBodyG} else {CSATBodyG};
_piloto = _grp createUnit [_tipo, _posicion, [], 0, "NONE"];
if (_dificil) then
	{
	for "_i" from 1 to 4 do
		{
		_piloto = _grp createUnit [_tipo, _posicion, [], 0, "NONE"];
		};
	};

_grp selectLeader _oficial;
sleep 1;
_nul = [leader _grp, _marcador, "SAFE", "SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";

{_nul = [_x,""] call NATOinit; _x allowFleeing 0} forEach units _grp;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _oficial)};

if (not alive _oficial) then
	{
	//["AS", "SUCCEEDED",true] spawn BIS_fnc_taskSetState;
	["AS",[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"SUCCEEDED"] call taskUpdate;
	if (_dificil) then
		{
		[0,600] remoteExec ["resourcesFIA",2];
		[2400] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[20,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[10,theBoss] call playerScoreAdd;
		[_marcador,60] call addTimeForIdle;
		}
	else
		{
		[0,300] remoteExec ["resourcesFIA",2];
		[1800] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[5,theBoss] call playerScoreAdd;
		[_marcador,30] call addTimeForIdle;
		};
	["TaskFailed", ["", format ["Officer killed at %1",[_nombreDest, false] call fn_location]]] remoteExec ["BIS_fnc_showNotification",_lado];
	}
else
	{
	//["AS", "FAILED",true] spawn BIS_fnc_taskSetState;
	["AS",[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"FAILED"] call taskUpdate;
	if (_dificil) then
		{
		[-1200] remoteExec ["timingCA",2];
		[-20,theBoss] call playerScoreAdd;
		[_marcador,-60] call addTimeForIdle;
		}
	else
		{
		[-600] remoteExec ["timingCA",2];
		[-10,theBoss] call playerScoreAdd;
		[_marcador,-30] call addTimeForIdle;
		};
	};

{deleteVehicle _x} forEach units _grp;
deleteGroup _grp;

//sleep (600 + random 1200);
//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,"AS"] spawn borrarTask;


