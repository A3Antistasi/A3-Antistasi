if (!isServer and hasInterface) exitWith{};

private ["_pos","_roadscon","_veh","_roads","_conquered","_dirVeh","_marcador","_posicion","_vehiclesX","_soldados","_tam","_bunker","_grupoE","_unit","_typeGroup","_grupo","_timeLimit","_dateLimit","_dateLimitNum","_base","_perro","_lado","_cfg","_esFIA","_salir","_isControl","_tam","_tipoVeh","_tipoUnit","_markersX","_frontera","_uav","_grupoUAV","_allUnits","_closest","_winner","_timeLimit","_dateLimit","_dateLimitNum","_size","_base","_mina","_loser","_lado"];

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;
_lado = lados getVariable [_marcador,sideUnknown];

if ((_lado == buenos) or (_lado == sideUnknown)) exitWith {};
if ({if ((lados getVariable [_x,sideUnknown] != _lado) and (_posicion inArea _x)) exitWith {1}} count markersX >1) exitWith {};
_vehiclesX = [];
_soldados = [];
_pilotos = [];
_conquered = false;
_group = grpNull;
_isFIA = false;
_leave = false;

_isControl = if (isOnRoad _posicion) then {true} else {false};

if (_isControl) then
	{
	if (gameMode != 4) then
		{
		if (_lado == Occupants) then
			{
			if ((random 10 > (tierWar + difficultyCoef)) and (!([_marcador] call A3A_fnc_isFrontline))) then
				{
				_isFIA = true;
				}
			};
		}
	else
		{
		if (_lado == muyMalos) then
			{
			if ((random 10 > (tierWar + difficultyCoef)) and (!([_marcador] call A3A_fnc_isFrontline))) then
				{
				_isFIA = true;
				}
			};
		};

	_tam = 20;
	while {true} do
		{
		_roads = _posicion nearRoads _tam;
		if (count _roads > 1) exitWith {};
		_tam = _tam + 5;
		};

	_roadscon = roadsConnectedto (_roads select 0);

	_dirveh = [_roads select 0, _roadscon select 0] call BIS_fnc_DirTo;
	if ((isNull (_roads select 0)) or (isNull (_roadscon select 0))) then {diag_log format ["Antistasi Roadblock error report: %1 position is bad",_marcador]};

	if (!_isFIA) then
		{
		_groupE = grpNull;
		if !(hasIFA) then
			{
			_pos = [getPos (_roads select 0), 7, _dirveh + 270] call BIS_Fnc_relPos;
			_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
			_vehiclesX pushBack _bunker;
			_bunker setDir _dirveh;
			_pos = getPosATL _bunker;
			_tipoVeh = if (_lado == malos) then {NATOMG} else {CSATMG};
			_veh = _tipoVeh createVehicle _posicion;
			_vehiclesX pushBack _veh;
			_veh setPosATL _pos;
			_veh setDir _dirVeh;

			_grupoE = createGroup _lado;
			_tipoUnit = if (_lado == malos) then {staticCrewOccupants} else {staticCrewInvaders};
			_unit = _grupoE createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
			_unit moveInGunner _veh;
			_soldados pushBack _unit;
			sleep 1;
			_pos = [getPos (_roads select 0), 7, _dirveh + 90] call BIS_Fnc_relPos;
			_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
			_vehiclesX pushBack _bunker;
			_bunker setDir _dirveh + 180;
			_pos = getPosATL _bunker;
			_pos = [getPos _bunker, 6, getDir _bunker] call BIS_fnc_relPos;
			_typeVehX = if (_lado == Occupants) then {NATOFlag} else {CSATFlag};
			_veh = createVehicle [_typeVehX, _pos, [],0, "CAN_COLLIDE"];
			_vehiclesX pushBack _veh;
			_veh = _tipoVeh createVehicle _posicion;
			_vehiclesX pushBack _veh;
			_veh setPosATL _pos;
			_veh setDir _dirVeh;
			sleep 1;
			_unit = _grupoE createUnit [_tipoUnit, _posicion, [], 0, "NONE"];
			_unit moveInGunner _veh;
			_soldados pushBack _unit;
			sleep 1;
			{_nul = [_x] call A3A_fnc_AIVEHinit} forEach _vehiclesX;
			};
		_typeGroup = if (_lado == malos) then {selectRandom groupsNATOmid} else {selectRandom groupsCSATmid};
		_grupo = if !(hayIFA) then {[_posicion,_lado, _typeGroup,false,true] call A3A_fnc_spawnGroup} else {[_posicion,_lado, _typeGroup] call A3A_fnc_spawnGroup};
		if !(isNull _grupo) then
			{
			if !(hasIFA) then
				{
				{[_x] join _group} forEach units _groupE;
				deleteGroup _groupE;
				};
			if (random 10 < 2.5) then
				{
				_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
				[_perro,_grupo] spawn A3A_fnc_guardDog;
				};
			_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
			{[_x,""] call A3A_fnc_NATOinit; _soldados pushBack _x} forEach units _grupo;
			};
		}
	else
		{
		_typeVehX = if !(hasIFA) then {vehFIAArmedCar} else {vehFIACar};
		_veh = _typeVehX createVehicle getPos (_roads select 0);
		_veh setDir _dirveh + 90;
		_nul = [_veh] call A3A_fnc_AIVEHinit;
		_vehiclesX pushBack _veh;
		sleep 1;
		_typeGroup = selectRandom groupsFIAMid;
		_grupo = if !(hayIFA) then {[_posicion, _lado, _typeGroup,false,true] call A3A_fnc_spawnGroup} else {[_posicion, _lado, _typeGroup] call A3A_fnc_spawnGroup};
		if !(isNull _grupo) then
			{
			_unit = _grupo createUnit [FIARifleman, _posicion, [], 0, "NONE"];
			_unit moveInGunner _veh;
			{_soldados pushBack _x; [_x,""] call A3A_fnc_NATOinit} forEach units _grupo;
			};
		};
	}
else
	{
	_markersX = markersX select {(getMarkerPos _x distance _posicion < distanceSPWN) and (lados getVariable [_x,sideUnknown] == buenos)};
	_markersX = _markersX - ["Synd_HQ"] - outpostsFIA;
	_frontera = if (count _markersX > 0) then {true} else {false};
	if (_frontera) then
		{
		_cfg = CSATSpecOp;
		if (lados getVariable [_marcador,sideUnknown] == malos) then
			{
			_cfg = NATOSpecOp;
			_lado = Occupants;
			};
		_size = [_marcador] call A3A_fnc_sizeMarker;
		if ({if (_x inArea _marcador) exitWith {1}} count allMines == 0) then
			{
			for "_i" from 1 to 60 do
				{
				_mina = createMine ["APERSMine",_posicion,[],_size];
				if (_lado == malos) then {malos revealMine _mina} else {muyMalos revealMine _mina};
				};
			};
		_grupo = [_posicion,_lado, _cfg] call A3A_fnc_spawnGroup;
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","RANDOM","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		if !(hayIFA) then
			{
			sleep 1;
			{_soldados pushBack _x} forEach units _grupo;
			_tipoVeh = if (_lado == malos) then {vehNATOUAVSmall} else {vehCSATUAVSmall};
			_uav = createVehicle [_tipoVeh, _posicion, [], 0, "FLY"];
			createVehicleCrew _uav;
			_vehiclesX pushBack _uav;
			_grupoUAV = group (crew _uav select 1);
			{[_x] joinSilent _grupo; _pilotos pushBack _x} forEach units _grupoUAV;
			deleteGroup _grupoUAV;
			};
		{[_x,""] call A3A_fnc_NATOinit} forEach units _group;
		}
	else
		{
		_leave = true;
		};
	};
if (_leave) exitWith {};
_spawnStatus = 0;
while {(spawner getVariable _marcador != 2) and ({[_x,_marcador] call A3A_fnc_canConquer} count _soldados > 0)} do
	{
	if ((spawner getVariable _marcador == 1) and (_spawnStatus != spawner getVariable _marcador)) then
		{
		_spawnStatus = 1;
		if (isMultiplayer) then
			{
			{if (vehicle _x == _x) then {[_x,false] remoteExec ["enableSimulationGlobal",2]}} forEach _soldados
			}
		else
			{
			{if (vehicle _x == _x) then {_x enableSimulationGlobal false}} forEach _soldados
			};
		}
	else
		{
		if ((spawner getVariable _marcador == 0) and (_spawnStatus != spawner getVariable _marcador)) then
			{
			_spawnStatus = 0;
			if (isMultiplayer) then
				{
				{if (vehicle _x == _x) then {[_x,true] remoteExec ["enableSimulationGlobal",2]}} forEach _soldados
				}
			else
				{
				{if (vehicle _x == _x) then {_x enableSimulationGlobal true}} forEach _soldados
				};
			};
		};
	sleep 3;
	};

waitUntil {sleep 1;((spawner getVariable _marcador == 2))  or ({[_x,_marcador] call A3A_fnc_canConquer} count _soldados == 0)};

_conquered = false;
_winner = malos;
if (spawner getVariable _marcador != 2) then
	{
	_conquered = true;
	_allUnits = allUnits select {(side _x != civilian) and (side _x != _lado) and (alive _x) and (!captive _x)};
	_closest = [_allUnits,_posicion] call BIS_fnc_nearestPosition;
	_winner = side _closest;
	_loser = Occupants;
	if (_isControl) then
		{
		["TaskSucceeded", ["", "Roadblock Destroyed"]] remoteExec ["BIS_fnc_showNotification",_winner];
		["TaskFailed", ["", "Roadblock Lost"]] remoteExec ["BIS_fnc_showNotification",_lado];
		};
	if (lados getVariable [_marcador,sideUnknown] == malos) then
		{
		if (_winner == muyMalos) then
			{
			_nul = [-5,0,_posicion] remoteExec ["A3A_fnc_citySupportChange",2];
			lados setVariable [_marcador,muyMalos,true];
			}
		else
			{
			lados setVariable [_marcador,buenos,true];
			};
		}
	else
		{
		_loser = muyMalos;
		if (_winner == malos) then
			{
			lados setVariable [_marcador,malos,true];
			_nul = [5,0,_posicion] remoteExec ["A3A_fnc_citySupportChange",2];
			}
		else
			{
			lados setVariable [_marcador,buenos,true];
			_nul = [0,5,_posicion] remoteExec ["A3A_fnc_citySupportChange",2];
			};
		};
	if (_winner == buenos) then {[[_posicion,_lado,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
	};

waitUntil {sleep 1;(spawner getVariable _marcador == 2)};

{_veh = _x;
if (not(_veh in staticsToSave)) then
	{
	if ((!([distanceSPWN,1,_x,teamPlayer] call A3A_fnc_distanceUnits))) then {deleteVehicle _x}
	};
} forEach _vehiclesX;
{
if (alive _x) then
	{
	if (_x != vehicle _x) then {deleteVehicle (vehicle _x)};
	deleteVehicle _x
	}
} forEach (_soldados + _pilotos);
deleteGroup _grupo;

if (_conquered) then
	{
	_indice = controlsX find _marcador;
	if (_indice > defaultControlIndex) then
		{
		_timeLimit = 120;//120
		_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
		_dateLimitNum = dateToNumber _dateLimit;
		waitUntil {sleep 60;(dateToNumber date > _dateLimitNum)};
		_base = [(markersX - controlsX),_posicion] call BIS_fnc_nearestPosition;
		if (lados getVariable [_base,sideUnknown] == malos) then
			{
			lados setVariable [_marcador,malos,true];
			}
		else
			{
			if (lados getVariable [_base,sideUnknown] == muyMalos) then
				{
				lados setVariable [_marcador,muyMalos,true];
				};
			};
		}
	else
		{
		/*
		if ((!_isControl) and (_winner == teamPlayer)) then
			{
			_size = [_marcador] call A3A_fnc_sizeMarker;
			for "_i" from 1 to 60 do
				{
				_mina = createMine ["APERSMine",_posicion,[],_size];
				if (_loser == malos) then {malos revealMine _mina} else {muyMalos revealMine _mina};
				};
			};
		*/
		};
	};
