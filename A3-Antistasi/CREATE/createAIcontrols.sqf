if (!isServer and hasInterface) exitWith{};

private ["_pos","_roadscon","_veh","_roads","_conquered","_dirVeh","_markerX","_positionX","_vehiclesX","_soldiers","_tam","_bunker","_grupoE","_unit","_typeGroup","_grupo","_timeLimit","_dateLimit","_dateLimitNum","_base","_perro","_lado","_cfg","_esFIA","_salir","_isControl","_tam","_typeVehX","_typeUnit","_markersX","_frontierX","_uav","_groupUAV","_allUnits","_closest","_winner","_timeLimit","_dateLimit","_dateLimitNum","_size","_base","_mina","_loser","_lado"];

_markerX = _this select 0;
_positionX = getMarkerPos _markerX;
_lado = lados getVariable [_markerX,sideUnknown];

if ((_lado == buenos) or (_lado == sideUnknown)) exitWith {};
if ({if ((lados getVariable [_x,sideUnknown] != _lado) and (_positionX inArea _x)) exitWith {1}} count markersX >1) exitWith {};
_vehiclesX = [];
_soldiers = [];
_pilotos = [];
_conquered = false;
_grupo = grpNull;
_esFIA = false;
_salir = false;

_isControl = if (isOnRoad _positionX) then {true} else {false};

if (_isControl) then
	{
	if (gameMode != 4) then
		{
		if (_lado == Occupants) then
			{
			if ((random 10 > (tierWar + difficultyCoef)) and (!([_markerX] call A3A_fnc_isFrontline))) then
				{
				_esFIA = true;
				}
			};
		}
	else
		{
		if (_lado == ) then
			{
			if ((random 10 > (tierWar + difficultyCoef)) and (!([_markerX] call A3A_fnc_isFrontline))) then
				{
				_esFIA = true;
				}
			};
		};

	_tam = 20;
	while {true} do
		{
		_roads = _positionX nearRoads _tam;
		if (count _roads > 1) exitWith {};
		_tam = _tam + 5;
		};

	_roadscon = roadsConnectedto (_roads select 0);

	_dirveh = [_roads select 0, _roadscon select 0] call BIS_fnc_DirTo;
	if ((isNull (_roads select 0)) or (isNull (_roadscon select 0))) then {diag_log format ["Antistasi Roadblock error report: %1 position is bad",_markerX]};

	if (!_esFIA) then
		{
		_grupoE = grpNull;
		if !(hayIFA) then
			{
			_pos = [getPos (_roads select 0), 7, _dirveh + 270] call BIS_Fnc_relPos;
			_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
			_vehiclesX pushBack _bunker;
			_bunker setDir _dirveh;
			_pos = getPosATL _bunker;
			_typeVehX = if (_lado == Occupants) then {NATOMG} else {CSATMG};
			_veh = _typeVehX createVehicle _positionX;
			_vehiclesX pushBack _veh;
			_veh setPosATL _pos;
			_veh setDir _dirVeh;

			_grupoE = createGroup _lado;
			_typeUnit = if (_lado == Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
			_unit = _grupoE createUnit [_typeUnit, _positionX, [], 0, "NONE"];
			_unit moveInGunner _veh;
			_soldiers pushBack _unit;
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
			_veh = _typeVehX createVehicle _positionX;
			_vehiclesX pushBack _veh;
			_veh setPosATL _pos;
			_veh setDir _dirVeh;
			sleep 1;
			_unit = _grupoE createUnit [_typeUnit, _positionX, [], 0, "NONE"];
			_unit moveInGunner _veh;
			_soldiers pushBack _unit;
			sleep 1;
			{_nul = [_x] call A3A_fnc_AIVEHinit} forEach _vehiclesX;
			};
		_typeGroup = if (_lado == Occupants) then {selectRandom groupsNATOmid} else {selectRandom groupsCSATmid};
		_grupo = if !(hayIFA) then {[_positionX,_lado, _typeGroup,false,true] call A3A_fnc_spawnGroup} else {[_positionX,_lado, _typeGroup] call A3A_fnc_spawnGroup};
		if !(isNull _grupo) then
			{
			if !(hayIFA) then
				{
				{[_x] join _grupo} forEach units _grupoE;
				deleteGroup _grupoE;
				};
			if (random 10 < 2.5) then
				{
				_perro = _grupo createUnit ["Fin_random_F",_positionX,[],0,"FORM"];
				[_perro,_grupo] spawn A3A_fnc_guardDog;
				};
			_nul = [leader _grupo, _markerX, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
			{[_x,""] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grupo;
			};
		}
	else
		{
		_typeVehX = if !(hayIFA) then {vehFIAArmedCar} else {vehFIACar};
		_veh = _typeVehX createVehicle getPos (_roads select 0);
		_veh setDir _dirveh + 90;
		_nul = [_veh] call A3A_fnc_AIVEHinit;
		_vehiclesX pushBack _veh;
		sleep 1;
		_typeGroup = selectRandom groupsFIAMid;
		_grupo = if !(hayIFA) then {[_positionX, _lado, _typeGroup,false,true] call A3A_fnc_spawnGroup} else {[_positionX, _lado, _typeGroup] call A3A_fnc_spawnGroup};
		if !(isNull _grupo) then
			{
			_unit = _grupo createUnit [FIARifleman, _positionX, [], 0, "NONE"];
			_unit moveInGunner _veh;
			{_soldiers pushBack _x; [_x,""] call A3A_fnc_NATOinit} forEach units _grupo;
			};
		};
	}
else
	{
	_markersX = markersX select {(getMarkerPos _x distance _positionX < distanceSPWN) and (lados getVariable [_x,sideUnknown] == buenos)};
	_markersX = _markersX - ["Synd_HQ"] - outpostsFIA;
	_frontierX = if (count _markersX > 0) then {true} else {false};
	if (_frontierX) then
		{
		_cfg = CSATSpecOp;
		if (lados getVariable [_markerX,sideUnknown] == Occupants) then
			{
			_cfg = NATOSpecOp;
			_lado = Occupants;
			};
		_size = [_markerX] call A3A_fnc_sizeMarker;
		if ({if (_x inArea _markerX) exitWith {1}} count allMines == 0) then
			{
			for "_i" from 1 to 60 do
				{
				_mina = createMine ["APERSMine",_positionX,[],_size];
				if (_lado == Occupants) then {Occupants revealMine _mina} else { revealMine _mina};
				};
			};
		_grupo = [_positionX,_lado, _cfg] call A3A_fnc_spawnGroup;
		_nul = [leader _grupo, _markerX, "SAFE","SPAWNED","RANDOM","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		if !(hayIFA) then
			{
			sleep 1;
			{_soldiers pushBack _x} forEach units _grupo;
			_typeVehX = if (_lado == Occupants) then {vehNATOUAVSmall} else {vehCSATUAVSmall};
			_uav = createVehicle [_typeVehX, _positionX, [], 0, "FLY"];
			createVehicleCrew _uav;
			_vehiclesX pushBack _uav;
			_groupUAV = group (crew _uav select 1);
			{[_x] joinSilent _grupo; _pilotos pushBack _x} forEach units _groupUAV;
			deleteGroup _groupUAV;
			};
		{[_x,""] call A3A_fnc_NATOinit} forEach units _grupo;
		}
	else
		{
		_salir = true;
		};
	};
if (_salir) exitWith {};
_spawnStatus = 0;
while {(spawner getVariable _markerX != 2) and ({[_x,_markerX] call A3A_fnc_canConquer} count _soldiers > 0)} do
	{
	if ((spawner getVariable _markerX == 1) and (_spawnStatus != spawner getVariable _markerX)) then
		{
		_spawnStatus = 1;
		if (isMultiplayer) then
			{
			{if (vehicle _x == _x) then {[_x,false] remoteExec ["enableSimulationGlobal",2]}} forEach _soldiers
			}
		else
			{
			{if (vehicle _x == _x) then {_x enableSimulationGlobal false}} forEach _soldiers
			};
		}
	else
		{
		if ((spawner getVariable _markerX == 0) and (_spawnStatus != spawner getVariable _markerX)) then
			{
			_spawnStatus = 0;
			if (isMultiplayer) then
				{
				{if (vehicle _x == _x) then {[_x,true] remoteExec ["enableSimulationGlobal",2]}} forEach _soldiers
				}
			else
				{
				{if (vehicle _x == _x) then {_x enableSimulationGlobal true}} forEach _soldiers
				};
			};
		};
	sleep 3;
	};

waitUntil {sleep 1;((spawner getVariable _markerX == 2))  or ({[_x,_markerX] call A3A_fnc_canConquer} count _soldiers == 0)};

_conquered = false;
_winner = Occupants;
if (spawner getVariable _markerX != 2) then
	{
	_conquered = true;
	_allUnits = allUnits select {(side _x != civilian) and (side _x != _lado) and (alive _x) and (!captive _x)};
	_closest = [_allUnits,_positionX] call BIS_fnc_nearestPosition;
	_winner = side _closest;
	_loser = Occupants;
	if (_isControl) then
		{
		["TaskSucceeded", ["", "Roadblock Destroyed"]] remoteExec ["BIS_fnc_showNotification",_winner];
		["TaskFailed", ["", "Roadblock Lost"]] remoteExec ["BIS_fnc_showNotification",_lado];
		};
	if (lados getVariable [_markerX,sideUnknown] == Occupants) then
		{
		if (_winner == ) then
			{
			_nul = [-5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
			lados setVariable [_markerX,,true];
			}
		else
			{
			lados setVariable [_markerX,buenos,true];
			};
		}
	else
		{
		_loser = ;
		if (_winner == Occupants) then
			{
			lados setVariable [_markerX,Occupants,true];
			_nul = [5,0,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
			}
		else
			{
			lados setVariable [_markerX,buenos,true];
			_nul = [0,5,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
			};
		};
	if (_winner == buenos) then {[[_positionX,_lado,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
	};

waitUntil {sleep 1;(spawner getVariable _markerX == 2)};

{_veh = _x;
if (not(_veh in staticsToSave)) then
	{
	if ((!([distanceSPWN,1,_x,buenos] call A3A_fnc_distanceUnits))) then {deleteVehicle _x}
	};
} forEach _vehiclesX;
{
if (alive _x) then
	{
	if (_x != vehicle _x) then {deleteVehicle (vehicle _x)};
	deleteVehicle _x
	}
} forEach (_soldiers + _pilotos);
deleteGroup _grupo;

if (_conquered) then
	{
	_indice = controlsX find _markerX;
	if (_indice > defaultControlIndex) then
		{
		_timeLimit = 120;//120
		_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
		_dateLimitNum = dateToNumber _dateLimit;
		waitUntil {sleep 60;(dateToNumber date > _dateLimitNum)};
		_base = [(markersX - controlsX),_positionX] call BIS_fnc_nearestPosition;
		if (lados getVariable [_base,sideUnknown] == Occupants) then
			{
			lados setVariable [_markerX,Occupants,true];
			}
		else
			{
			if (lados getVariable [_base,sideUnknown] == ) then
				{
				lados setVariable [_markerX,,true];
				};
			};
		}
	else
		{
		/*
		if ((!_isControl) and (_winner == buenos)) then
			{
			_size = [_markerX] call A3A_fnc_sizeMarker;
			for "_i" from 1 to 60 do
				{
				_mina = createMine ["APERSMine",_positionX,[],_size];
				if (_loser == Occupants) then {Occupants revealMine _mina} else { revealMine _mina};
				};
			};
		*/
		};
	};

