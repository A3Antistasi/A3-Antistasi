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
		_marcadores = (marcadores - puestosFIA) select {(getMarkerPos _x distance getMarkerPos _marcador < distanciaSPWN) and (lados getVariable [_x,sideUnknown] == buenos)};
		_marcadores = _marcadores - ["Synd_HQ"];
		_frontera = if (count _marcadores > 0) then {true} else {false};
		if ((lados getVariable [_marcador,sideUnknown] == buenos) or (!_frontera)) then
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
			["AS",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,"FAILED"] call taskUpdate;
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

_posicion = getMarkerPos _marcador;
_lado = if (lados getVariable [_marcador,sideUnknown] == malos) then {malos} else {muyMalos};
_tiempolim = if (_dificil) then {60} else {120};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
_nombreBando = if (_lado == malos) then {"NATO"} else {"CSAT"};

[[buenos,civilian],"AS",[format ["We have spotted a %4 SpecOp team patrolling around a %1. Ambush them and we will have one less problem. Do this before %2:%3. Be careful, they are tough boys.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"SpecOps",_marcador],_posicion,false,0,true,"Kill",true] call BIS_fnc_taskCreate;
misiones pushBack ["AS","CREATED"]; publicVariable "misiones";
waitUntil  {sleep 5; (dateToNumber date > _fechalimnum) or (lados getVariable [_marcador,sideUnknown] == buenos)};

if (dateToNumber date > _fechalimnum) then
	{
	["AS",[format ["We have spotted a %4 SpecOp team patrolling around an %1. Ambush them and we will have one less problem. Do this before %2:%3. Be careful, they are tough boys.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"SpecOps",_marcador],_posicion,"FAILED"] call taskUpdate;
	if (_dificil) then
		{
		[10,0,_posicion] remoteExec ["citySupportChange",2];
		[-1200] remoteExec ["timingCA",2];
		[-20,theBoss] call playerScoreAdd;
		}
	else
		{
		[5,0,_posicion] remoteExec ["citySupportChange",2];
		[-600] remoteExec ["timingCA",2];
		[-10,theBoss] call playerScoreAdd;
		};
	}
else
	{
	["AS",[format ["We have spotted a %4 SpecOp team patrolling around an %1. Ambush them and we will have one less problem. Do this before %2:%3. Be careful, they are tough boys.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombreBando],"SpecOps",_marcador],_posicion,"SUCCEEDED"] call taskUpdate;
	if (_dificil) then
		{
		[0,400] remoteExec ["resourcesFIA",2];
		[0,10,_posicion] remoteExec ["citySupportChange",2];
		[1200] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[20,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[20,theBoss] call playerScoreAdd;
		}
	else
		{
		[0,200] remoteExec ["resourcesFIA",2];
		[0,5,_posicion] remoteExec ["citySupportChange",2];
		[600] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[10,theBoss] call playerScoreAdd;
		};
	if (_lado == malos) then {[3,0] remoteExec ["prestige",2]} else {[0,3] remoteExec ["prestige",2]};
	["TaskFailed", ["", format ["SpecOp Team decimated at a %1",_nombredest]]] remoteExec ["BIS_fnc_showNotification",_lado];
	};

_nul = [1200,"AS"] spawn borrarTask;
/*
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _grupo;
deleteGroup _grupo;
waitUntil {sleep 1; !([distanciaSPWN,1,_uav,"GREENFORSpawn"] call distanceUnits)};
{deleteVehicle _x} forEach units _grupoUAV;
deleteVehicle _uav;
deleteGroup _grupoUAV;