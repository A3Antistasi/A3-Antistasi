if (!isServer and hasInterface) exitWith{};

private ["_marcador"];

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
	[[buenos,civilian],"CON",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,false,0,true,"talk",true] call BIS_fnc_taskCreate;
	//_tsk = ["CON",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
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
			[0,"CON"] spawn borrarTask;
			}
		else
			{
			["CON",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"FAILED"] call taskUpdate;
			[1200,"CON"] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,"CON"] spawn borrarTask;
	waitUntil {sleep 1; !(["CON"] call BIS_fnc_taskExists)};
	};

_posicion = getMarkerPos _marcador;
_tiempolim = if (_dificil) then {30} else {90};//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
_texto = "";
_taskName = "";
if (_marcador in recursos) then
	{
	_texto = format ["A %1 would be a fine addition to our cause. Go there and capture it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4];
	_taskName = "Resource Acquisition";
	}
else
	{
	_texto = format ["A %1 is disturbing our operations in the area. Go there and capture it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4];
	_taskName = "Take the Outpost";
	};
//if (!_dificil) then {[[buenos,civilian],"CON",[_texto,_taskName,_marcador],_posicion,false,0,true,"Target",true] call BIS_fnc_taskCreate} else {["CON",[_texto,_taskName,_marcador],_posicion,"CREATED","Attack"] call taskUpdate};
//misiones pushBack _tsk; publicVariable "misiones";

[[buenos,civilian],"CON",[_texto,_taskName,_marcador],_posicion,false,0,true,"Target",true] call BIS_fnc_taskCreate;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (lados getVariable [_marcador,sideUnknown] == buenos)};

if (dateToNumber date > _fechalimnum) then
	{
	["CON",[_texto,_taskName,_marcador],_posicion,"FAILED"] call taskUpdate;
	if (_dificil) then
		{
		[10,0,_posicion] remoteExec ["citySupportChange",2];
		[-1200] remoteExec ["timingCA",2];
		[-20,stavros] call playerScoreAdd;
		}
	else
		{
		[5,0,_posicion] remoteExec ["citySupportChange",2];
		[-600] remoteExec ["timingCA",2];
		[-10,stavros] call playerScoreAdd;
		};
	}
else
	{
	sleep 10;
	["CON",[_texto,_taskName,_marcador],_posicion,"SUCCEEDED"] call taskUpdate;
	if (_dificil) then
		{
		[0,400] remoteExec ["resourcesFIA",2];
		[-10,0,_posicion] remoteExec ["citySupportChange",2];
		[1200] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[20,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[20,stavros] call playerScoreAdd;
		}
	else
		{
		[0,200] remoteExec ["resourcesFIA",2];
		[-5,0,_posicion] remoteExec ["citySupportChange",2];
		[600] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[10,stavros] call playerScoreAdd;
		};
	};

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,"CON"] spawn borrarTask;