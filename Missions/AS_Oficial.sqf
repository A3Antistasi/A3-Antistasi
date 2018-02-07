if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;

_dificil = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contacto = objNull;
_grpContacto = grpNull;
_tsk = "";

if (_dificil) then
	{
	_posHQ = getMarkerPos "respawn_guerrila";
	_ciudades = ciudades select {getMarkerPos _x distance _posHQ < distanciaMiss};
	if (count _ciudades == 0) exitWith {_dificil = false};
	_ciudad = selectRandom _ciudades;

	_tam = [_ciudad] call sizeMarker;
	_posicion = getMarkerPos _ciudad;
	_casas = nearestObjects [_posicion, ["house"], _tam];
	_casa = selectRandom _casas;
	_posCasa = [];
	_casa = objNull;
	while {count _posCasa == 0} do
		{
		_casa = selectRandom _casas;
		_posCasa = [_casa] call BIS_fnc_buildingPositions;
		_casas = _casas - [_casa];
		};
	_grpContacto = createGroup civilian;
	_contacto = _grpContacto createUnit [selectRandom arrayCivs, selectRandom _posCasa, [], 0, "NONE"];
	_contacto allowDamage false;
	_contacto setVariable ["statusAct",false,true];
	_contacto forceSpeed 0;
	_contacto setUnitPos "UP";
	[_contacto,"missionGiver"] remoteExec ["flagaction",[buenos,civilian],_contacto];

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 15;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;

	_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
	misiones pushBack _tsk; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (_marcador in mrkSDK) exitWith
			{
			_salir = true;
			{
			if (isPlayer _x) then {[_contacto,"globalChat","My information is useless now"] remoteExec ["commsMP",_x]}
			} forEach ([50,0,position _casa,"GREENFORSpawn"] call distanceUnits);
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
			[0,_tsk] spawn borrarTask;
			}
		else
			{
			_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"FAILED",5,true,true,"talk"] call BIS_fnc_setTask;
			[1200,_tsk] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,_tsk] spawn borrarTask;
	waitUntil {sleep 1; !(_tsk in misiones)};
	};

_lado = if (_marcador in mrkNATO) then {malos} else {muyMalos};
_posicion = getMarkerPos _marcador;

_tiempolim = if (_dificil) then {15} else {30};//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
_nombreBando = if (_lado == malos) then {"NATO"} else {"CSAT"};
_tsk = ["AS",[buenos,civilian],[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
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
	_tsk = ["AS",[buenos,civilian],[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"SUCCEEDED",5,true,true,"Kill"] call BIS_fnc_setTask;
	if (_dificil) then
		{
		[0,600] remoteExec ["resourcesFIA",2];
		[2400] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[20,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[10,stavros] call playerScoreAdd;
		[_marcador,60] call addTimeForIdle;
		}
	else
		{
		[0,300] remoteExec ["resourcesFIA",2];
		[1800] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[5,stavros] call playerScoreAdd;
		[_marcador,30] call addTimeForIdle;
		};
	["TaskFailed", ["", format ["Officer killed at %1",[_nombreDest, false] call fn_location]]] remoteExec ["BIS_fnc_showNotification",_lado];
	}
else
	{
	_tsk = ["AS",[buenos,civilian],[format ["A %4 officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"Kill the Officer",_marcador],_posicion,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	if (_dificil) then
		{
		[-1200] remoteExec ["timingCA",2];
		[-20,stavros] call playerScoreAdd;
		[_marcador,-60] call addTimeForIdle;
		}
	else
		{
		[-600] remoteExec ["timingCA",2];
		[-10,stavros] call playerScoreAdd;
		[_marcador,-30] call addTimeForIdle;
		};
	};

{deleteVehicle _x} forEach units _grp;
deleteGroup _grp;

//sleep (600 + random 1200);
//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,_tsk] spawn borrarTask;


