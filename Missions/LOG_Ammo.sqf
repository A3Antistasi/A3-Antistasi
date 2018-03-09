if (!isServer and hasInterface) exitWith{};

private ["_pos","_camion","_camionCreado","_grupo","_grupo1","_mrk"];

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
	_posCasa = [];
	_casa = objNull;
	while {count _posCasa == 0} do
		{
		_casa = selectRandom _casas;
		_posCasa = [_casa] call BIS_fnc_buildingPositions;
		_casas = _casas - [_casa];
		};
	_grpContacto = createGroup civilian;
	_pos = selectRandom _posCasa;
	_contacto = _grpContacto createUnit [selectRandom arrayCivs, _pos, [], 0, "NONE"];
	_contacto allowDamage false;
	_contacto setPos _pos;
	_contacto setVariable ["statusAct",false,true];
	_contacto forceSpeed 0;
	_contacto setUnitPos "UP";
	[_contacto,"missionGiver"] remoteExec ["flagaction",[buenos,civilian],_contacto];

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 15;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;
	[[buenos,civilian],"LOG",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,false,0,true,"talk",true] call BIS_fnc_taskCreate;
	//_tsk = ["LOG",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
	//misiones pushBack _tsk; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (lados getVariable [_marcador,sideUnknown] == buenos) then
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
			[0,"LOG"] spawn borrarTask;
			}
		else
			{
			["LOG",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"FAILED","talk"] call taskUpdate;
			[1200,"LOG"] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,"LOG"] spawn borrarTask;
	waitUntil {sleep 1; !(["LOG"] call BIS_fnc_taskExists)};
	};

_posicion = getMarkerPos _marcador;
_lado = if (lados getVariable [_marcador,sideUnknown] == malos) then {malos} else {muyMalos};
_tiempolim = if (_dificil) then {30} else {60};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
_tipoVeh = if (_lado == malos) then {vehNATOAmmoTruck} else {vehCSATAmmoTruck};
_size = [_marcador] call sizeMarker;

_roads = [];
_tam = _size;
_road = objNull;
while {isNull _road} do
	{
	_roads = _posicion nearRoads _tam;
	if (count _roads > 0) then
		{
		{
		if ((surfaceType (position _x)!= "#GdtForest") and (surfaceType (position _x)!= "#GdtRock") and (surfaceType (position _x)!= "#GdtGrassTall")) exitWith {_road = _x};
		} forEach _roads;
		};
	_tam = _tam + 50;
	};
//_road = _roads select 0;
_pos = position _road;
_pos = _pos findEmptyPosition [1,60,_tipoVeh];
if (count _pos == 0) then {_pos = position _road};
/*
if (!_dificil) then
	{
	[[buenos,civilian],"LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_pos,false,0,true,"rearm",true] call BIS_fnc_taskCreate;
	}
else
	{
	["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_pos,"CREATED","rearm"] call taskUpdate;
	};*/
//misiones pushBack _tsk; publicVariable "misiones";
[[buenos,civilian],"LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_pos,false,0,true,"rearm",true] call BIS_fnc_taskCreate;
_camionCreado = false;

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or ((spawner getVariable _marcador != 2) and !(lados getVariable [_marcador,sideUnknown] == buenos))};
_bonus = if (_dificil) then {2} else {1};
if ((spawner getVariable _marcador != 2) and !(lados getVariable [_marcador,sideUnknown] == buenos)) then
	{
	//sleep 10;

	_camion = _tipoVeh createVehicle _pos;
	_camion setDir (getDir _road);
	_camionCreado = true;
	if (_lado == malos) then {[_camion] call NATOcrate} else {[_camion] call CSATcrate};

	_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], _pos];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [20,20];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
	if (!debug) then {_mrk setMarkerAlphaLocal 0};
	_tipoGrupo = if (_dificil) then {if (_lado == malos) then {NATOSquad} else {CSATSquad}} else {if (_lado == malos) then {gruposNATOSentry} else {gruposCSATSentry}};
	//_cfg = if (_lado == malos) then {cfgNATOInf} else {cfgCSATInf};
	_grupo = [_pos,_lado, _tipoGrupo] call spawnGroup;
	sleep 1;
	if (random 10 < 33) then
		{
		_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
		[_perro] spawn guardDog;
		};

	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";

	_grupo1 = [_pos,_lado,_tipoGrupo] call spawnGroup;
	sleep 1;
	_nul = [leader _grupo1, _mrk, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";

	{[_x,""] call NATOinit} forEach units _grupo;
	{[_x,""] call NATOinit} forEach units _grupo1;

	waitUntil {sleep 1; (not alive _camion) or (dateToNumber date > _fechalimnum) or ({_x getVariable ["GREENFORSpawn",false]} count crew _camion > 0)};

	if (dateToNumber date > _fechalimnum) then
		{
		["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_posicion,"FAILED","rearm"] call taskUpdate;
		[-1200*_bonus] remoteExec ["timingCA",2];
		[-10*_bonus,stavros] call playerScoreAdd;
		};
	if ((not alive _camion) or ({_x getVariable ["GREENFORSpawn",false]} count crew _camion > 0)) then
		{
		if ({_x getVariable ["GREENFORSpawn",false]} count crew _camion > 0) then
			{
			["TaskFailed", ["", format ["Ammotruck Stolen in an %1",_nombreDest]]] remoteExec ["BIS_fnc_showNotification",_lado];
			};
		[getPosASL _camion,_lado] spawn patrolCA;
		["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_posicion,"SUCCEEDED","rearm"] call taskUpdate;
		[0,300*_bonus] remoteExec ["resourcesFIA",2];
		[1200*_bonus] remoteExec ["timingCA",2];
		{if (_x distance _camion < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5*_bonus,stavros] call playerScoreAdd;
		};
	}
else
	{
	["LOG",[format ["We've spotted an Ammotruck in an %1. Go there and destroy or steal it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Steal or Destroy Ammotruck",_marcador],_posicion,"FAILED","rearm"] call taskUpdate;
	[-1200*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,stavros] call playerScoreAdd;
	};

_nul = [1200,"LOG"] spawn borrarTask;
if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	{deleteVehicle _x} forEach units _grupo1;
	deleteGroup _grupo1;
	deleteMarker _mrk;
	waitUntil {sleep 1; not ([300,1,_camion,"GREENFORSpawn"] call distanceUnits)};
	deleteVehicle _camion;
	};