if (!isServer and hasInterface) exitWith{};

private ["_marcador","_posicion","_fechalim","_fechalimnum","_nombredest","_camionCreado","_size","_pos","_veh","_grupo","_unit"];

_marcador = _this select 0;
_posicion = _this select 1;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;

[[buenos,civilian],"REP",[format ["NATO is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Tower Rebuild Disrupt",_marcador],_posicion,false,0,true,"Destroy",true] call BIS_fnc_taskCreate;
//_tsk = ["REP",[buenos,civilian],[format ["NATO is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Tower Rebuild Disrupt",_marcador],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
//misiones pushBack _tsk; publicVariable "misiones";
_camionCreado = false;

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (spawner getVariable _marcador != 2)};

if (spawner getVariable _marcador != 2) then
	{
	_camionCreado = true;
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
	_pos = _pos findEmptyPosition [1,60,"B_T_Truck_01_repair_F"];
	_veh = createVehicle [vehNATORepairTruck, _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir (getDir _road);
	_nul = [_veh] call AIVEHinit;
	_grupo = createGroup malos;

	sleep 5;
	_veh allowDamage true;

	for "_i" from 1 to 3 do
		{
		_unit = _grupo createUnit [NATOCrew, _pos, [], 0, "NONE"];
		[_unit,""] call NATOinit;
		sleep 2;
		};

	waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _veh)};

	if (not alive _veh) then
		{
		["REP",[format ["NATO is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Tower Rebuild Disrupt",_marcador],_posicion,"SUCCEEDED","Destroy"] call taskUpdate;
		[2,0] remoteExec ["prestige",2];
		[1200] remoteExec ["timingCA",2];
		{if (_x distance _veh < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,stavros] call playerScoreAdd;
		};
	};
if (dateToNumber date > _fechalimnum) then
	{
	if (lados getVariable [_marcador,sideUnknown] == buenos) then
		{
		["REP",[format ["NATO is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Tower Rebuild Disrupt",_marcador],_posicion,"SUCCEEDED","Destroy"] call taskUpdate;
		[2,0] remoteExec ["prestige",2];
		[1200] remoteExec ["timingCA",2];
		{if (_x distance _veh < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,stavros] call playerScoreAdd;
		}
	else
		{
		["REP",[format ["NATO is rebuilding a radio tower in %1. If we want to keep up the enemy comms breakdown, the work must be stopped. Destroy the repair truck parked nearby or capture the zone. Work will be finished on %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Tower Rebuild Disrupt",_marcador],_posicion,"FAILED","Destroy"] call taskUpdate;
		//[5,0,_posicion] remoteExec ["citySupportChange",2];
		[-600] remoteExec ["timingCA",2];
		[-10,stavros] call playerScoreAdd;
		};
	antenasMuertas = antenasMuertas - [_posicion];
	_antena = nearestBuilding _posicion;
	if (isMultiplayer) then {[_antena,true] remoteExec ["hideObjectGlobal",2]} else {_antena hideObject true};
	_antena = createVehicle ["Land_Communication_F", _posicion, [], 0, "NONE"];
	antenas pushBack _antena;
	{if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,true] spawn apagon}} forEach ciudades;
	_mrkfin = createMarker [format ["Ant%1", count antenas], _posicion];
	_mrkfin setMarkerShape "ICON";
	_mrkfin setMarkerType "loc_Transmitter";
	_mrkfin setMarkerColor "ColorBlack";
	_mrkfin setMarkerText "Radio Tower";
	mrkAntenas pushBack _mrkfin;
	publicVariable "mrkAntenas";
	_antena addEventHandler ["Killed",
		{
		_antena = _this select 0;
		{if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,false] spawn apagon}} forEach ciudades;
		_mrk = [mrkAntenas, _antena] call BIS_fnc_nearestPosition;
		antenas = antenas - [_antena]; antenasmuertas = antenasmuertas + [getPos _antena]; deleteMarker _mrk;
		["TaskSucceeded",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",buenos];
		["TaskFailed",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",malos];
		publicVariable "antenas"; publicVariable "antenasMuertas";
		}
		];
	};

_nul = [0,"REP"] spawn borrarTask;

waitUntil {sleep 1; (spawner getVariable _marcador == 2)};

if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};
	};
