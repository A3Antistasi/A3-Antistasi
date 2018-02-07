if (!isServer and hasInterface) exitWith {};

private ["_posorigen","_tipogrupo","_nombreorig","_markTsk","_wp1","_soldados","_landpos","_pad","_vehiculos","_wp0","_wp3","_wp4","_wp2","_grupo","_grupos","_tipoveh","_vehicle","_heli","_heliCrew","_grupoheli","_pilotos","_rnd","_resourcesAAF","_nVeh","_tam","_roads","_Vwp1","_road","_veh","_vehCrew","_grupoVeh","_Vwp0","_size","_Hwp0","_grupo1","_uav","_grupouav","_uwp0","_tsk","_vehiculo","_soldado","_piloto","_mrkdestino","_posdestino","_prestigeCSAT","_mrkOrigen","_aeropuerto","_nombredest","_tiempo","_solMax","_nul","_coste","_tipo","_threatEvalAir","_threatEvalLand","_pos","_timeOut","_lado"];

bigAttackInProgress = true;
publicVariable "bigAttackInProgress";

_mrkDestino = _this select 0;
_mrkOrigen = _this select 1;
diag_log format ["Antistasi: Major attack from %1 to %2",_mrkOrigen,_mrkDestino];
if (not(_mrkDestino in mrkSDK)) then {forcedSpawn pushBackUnique _mrkDestino; publicVariable "forcedSpawn"};

_posdestino = getMarkerPos _mrkDestino;
_posOrigen = getMarkerPos _mrkOrigen;

_grupos = [];
_soldados = [];
_pilotos = [];
_vehiculos = [];

_nombredest = [_mrkDestino] call localizar;
_nombreorig = [_mrkOrigen] call localizar;

_lado = malos;
_ladosTsk = [buenos,civilian,muyMalos];
_ladosTsk1 = [malos];
_nombreEny = "NATO";
//_config = cfgNATOInf;
if (_mrkOrigen in mrkCSAT) then
	{
	_lado = muymalos;
	_nombreEny = "CSAT";
	//_config = cfgCSATInf;
	_ladosTsk = [buenos,civilian,malos];
	_ladosTsk1 = [muyMalos];
	};
_esSDK = if (_mrkDestino in mrkSDK) then {true} else {false};
if (_esSDK) then
	{
	_ladosTsk = [buenos,civilian,malos,muyMalos] - [_lado];
	};

diag_log format ["Antistasi: Side attacker: %1. Side defender (false, the other AI side):  %2",_lado,_esSDK];
_nombreDest = [_mrkDestino] call localizar;

_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkOrigen],getMarkerPos _mrkOrigen,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
misiones pushbackUnique "AtaqueAAF"; publicVariable "misiones";
_tsk1 = ["AtaqueAAF1",_ladosTsk1,[format ["We are attacking %2 from the %1. Help the operation if you can",_nombreorig,_nombreDest],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"CREATED",10,true,true,"Attack"] call BIS_fnc_setTask;

_tiempo = time + 3600;

_nVeh = 3 + (round random 1);

if (_posOrigen distance _posDestino < 5000) then
	{
	_indice = aeropuertos find _mrkOrigen;
	_spawnPoint = spawnPoints select _indice;
	_pos = getMarkerPos _spawnPoint;
	/*
	_roads = [];
	_tam = [_mrkOrigen] call sizeMarker;
	while {true} do
		{
		_roads = _posOrigen nearRoads _tam;
		if (count _roads < _nVeh) then {_tam = _tam + 50};
		if (count _roads >= _nVeh) exitWith {};
		};
	*/
	_vehPool = if (_lado == malos) then {vehNATOAttack} else {vehCSATAttack};
	if (_esSDK) then
		{
		_rnd = random 100;
		if (_lado == malos) then
			{
			if (_rnd > prestigeNATO) then
				{
				_vehPool = _vehPool - [vehNATOTank];
				};
			}
		else
			{
			if (_rnd > prestigeCSAT) then
				{
				_vehPool = _vehPool - [vehCSATTank];
				};
			};
		};
	if (count _vehPool == 0) then {if (_lado == malos) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks}};
	_cuenta = 1;
	while {_cuenta <= _nVeh} do
		{
		_tipoVeh = selectRandom _vehPool;
		if (not([_tipoVeh] call vehAvailable)) then
			{
			_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
			_vehPool = _vehPool - [_tipoVeh];
			if (count _vehPool == 0) then {if (_lado == malos) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks}};
			};
		if ((_cuenta == _nVeh) and (_tipoVeh in vehTanks)) then
			{
			_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
			};
		//_road = _roads select (_i -1);
		_timeOut = 0;
		_pos = _pos findEmptyPosition [0,100,_tipoveh];
		while {_timeOut < 60} do
			{
			if (count _pos > 0) exitWith {};
			_timeOut = _timeOut + 1;
			_pos = _pos findEmptyPosition [0,100,_tipoveh];
			sleep 1;
			};
		if (count _pos == 0) then {_pos = getMarkerPos _spawnPoint};
		_vehicle=[_pos, markerDir _spawnPoint,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		{[_x] call NATOinit} forEach _vehCrew;
		[_veh] call AIVEHinit;
		_grupoVeh = _vehicle select 2;
		_soldados = _soldados + _vehCrew;
		_grupos pushBack _grupoVeh;
		_vehiculos pushBack _veh;
		_landPos = [_posDestino,_pos] call findSafeRoadToUnload;
		if (not(_tipoVeh in vehTanks)) then
			{
			_tipogrupo = [_tipoVeh,_lado] call cargoSeats;
			_grupo = [_posorigen,_lado, _tipogrupo,_veh] call spawnGroup;
			{_soldados pushBack _x;[_x] call NATOinit} forEach units _grupo;
			if (not(_tipoVeh in vehTrucks)) then
				{
				_grupo setVariable ["mrkAttack",_mrkDestino];
				_grupos pushBack _grupo;
				if ((_mrkOrigen == "airport") or (_mrkOrigen == "airport_2")) then {[_mrkOrigen,_landPos,_grupoVeh] call WPCreate};
				_Vwp0 = (wayPoints _grupoVeh) select 0;
				_Vwp0 setWaypointBehaviour "SAFE";
				_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
				_Vwp0 setWaypointType "TR UNLOAD";
				_Vwp0 setWayPointCompletionRadius (10*_cuenta);
				//_Vwp0 setWaypointStatements ["true", "[vehicle this] call smokeCoverAuto"];
				_Vwp1 = _grupoVeh addWaypoint [_posdestino, 1];
				_Vwp1 setWaypointType "SAD";
				_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				_Vwp1 setWaypointBehaviour "COMBAT";
				_Vwp2 = _grupo addWaypoint [_landPos, 0];
				_Vwp2 setWaypointType "GETOUT";
				_Vwp0 synchronizeWaypoint [_Vwp2];
				_Vwp2 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW""] execVM ""scripts\UPSMON.sqf"";"];
				/*
				_Vwp3 = _grupo addWaypoint [_posdestino, 1];
				_Vwp3 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				_Vwp3 = _grupo addWaypoint [_posdestino, 1];
				_Vwp3 setWaypointType "SAD";
				*/
				_veh allowCrewInImmobile true;
				[_veh,"APC"] spawn inmuneConvoy;
				}
			else
				{
				{[_x] join _grupoVeh} forEach units _grupo;
				deleteGroup _grupo;
				_grupoVeh setVariable ["mrkAttack",_mrkDestino];
				for "_i" from 1 to 8 do
					{
					_tipoSoldado = if (_lado == malos) then {NATOGrunt} else {CSATGrunt};
					_soldado = _grupoVeh createUnit [_tipoSoldado, _posorigen, [],0, "NONE"];
					_soldado assignAsCargo _veh;
					_soldado moveInCargo _veh;
					_soldados pushBack _soldado;
					[_soldado] call NATOinit;
					};
				_grupoVeh selectLeader (units _grupoVeh select 1);
				if ((_mrkOrigen == "airport") or (_mrkOrigen == "airport_2")) then {[_mrkOrigen,_landPos,_grupoVeh] call WPCreate};
				_Vwp0 = (wayPoints _grupoVeh) select 0;
				_Vwp0 setWaypointBehaviour "SAFE";
				_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
				_Vwp0 setWaypointType "GETOUT";
				_Vwp0 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW""] execVM ""scripts\UPSMON.sqf"";"];
				/*
				_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
				_Vwp1 setWaypointType "MOVE";
				_Vwp1 setWaypointBehaviour "COMBAT";
				_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
				_Vwp1 setWaypointType "SAD";
				*/
				[_veh,"Inf Truck."] spawn inmuneConvoy;
				};
			}
		else
			{
			if ((_mrkOrigen == "airport") or (_mrkOrigen == "airport_2")) then {[_mrkOrigen,_posDestino,_grupoVeh] call WPCreate};
			_Vwp0 = (wayPoints _grupoVeh) select 0;
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
			_Vwp0 setWaypointType "MOVE";
			_Vwp0 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
			_Vwp0 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
			_Vwp0 setWaypointType "SAD";
			[_veh,"Tank"] spawn inmuneConvoy;
			_veh allowCrewInImmobile true;
			};
		sleep 10;
		_cuenta = _cuenta + 1;
		};
	}
else
	{
	_nVeh = 2*_nVeh;
	};

_esMar = false;

for "_i" from 0 to 3 do
	{
	_pos = _posDestino getPos [1000,(_i*90)];
	if (surfaceIsWater _pos) exitWith
		{
		if (_lado == malos) then
			{
			if ({_x in mrkNATO} count puertos > 1) then
				{
				_esMar = true;
				};
			}
		else
			{
			if ({_x in mrkCSAT} count puertos > 1) then
				{
				_esMar = true;
				};
			};
		};
	};

if (_esMar) then
	{
	//_ang = [_landpos,_posDestino] call BIS_fnc_dirTo;
	//_ang = _ang - 180;
	//_pos = _landPos getPos [1200,_ang];
	//_pos = [_landPos, 800, 2000, 10, 2, 0.3, 0] call BIS_Fnc_findSafePos;
	_pos = getMarkerPos ([seaAttackSpawn,_posDestino] call BIS_fnc_nearestPosition);
	if (count _pos > 0) then
		{
		_vehPool = if (_lado == malos) then {vehNATOBoats} else {vehCSATBoats};
		_cuenta = 0;
		while {_cuenta < 3} do
			{
			_tipoVeh = selectRandom _vehPool;
			if (not([_tipoVeh] call vehAvailable)) then
				{
				_tipoVeh = if (_lado == malos) then {vehNATORBoat} else {vehCSATRBoat};
				_vehPool = _vehPool - [_tipoVeh];
				};
			if ((_tipoVeh == vehNATOBoat) or (_tipoVeh == vehCSATBoat)) then
				{
				_landPos = [_posDestino, 10, 1000, 10, 2, 0.3, 0] call BIS_Fnc_findSafePos;
				}
			else
				{
				_tipogrupo = [_tipoVeh,_lado] call cargoSeats;
				_landPos = [_posDestino, 10, 1000, 10, 2, 0.3, 1] call BIS_Fnc_findSafePos;
				if (debug) then
					{
					_mrkfin = createMarker [format ["%1", random 100], _landpos];
					_mrkfin setMarkerShape "ICON";
					_mrkfin setMarkerType "hd_destroy";
					};
				};
			if (count _landPos > 0) then
				{
				_vehicle=[_pos, random 360,_tipoveh, _lado] call bis_fnc_spawnvehicle;
				_veh = _vehicle select 0;
				_vehCrew = _vehicle select 1;
				_grupoVeh = _vehicle select 2;
				_pilotos = _pilotos + _vehCrew;
				_grupos pushBack _grupoVeh;
				_vehiculos pushBack _veh;
				diag_log format ["Antistasi: Sea Attack %1 spawned. Number of vehicles %2",_tipoVeh,count _vehiculos];
				{[_x] call NATOinit} forEach units _grupoVeh;
				[_veh] call AIVEHinit;
				if ((_tipoVeh == vehNATOBoat) or (_tipoVeh == vehCSATBoat)) then
					{
					_wp0 = _grupoVeh addWaypoint [_landpos, 0];
					_wp0 setWaypointType "SAD";
					[_veh,"Boat"] spawn inmuneConvoy;
					}
				else
					{
					_grupo = [_posorigen,_lado, _config >> _tipogrupo] call BIS_Fnc_spawnGroup;
					{_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x;[_x] call NATOinit} forEach units _grupo;
					if (_tipoVeh in vehAPCs) then
						{
						_grupos pushBack _grupo;
						_Vwp = _grupoVeh addWaypoint [_landPos, 0];
						_Vwp setWaypointBehaviour "SAFE";
						_Vwp setWaypointType "MOVE";
						_Vwp setWaypointSpeed "FULL";
						_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
						//_Vwp0 setWaypointBehaviour "SAFE";
						_Vwp0 setWaypointType "TR UNLOAD";
						//_Vwp0 setWaypointSpeed "FULL";
						//_Vwp0 setWayPointCompletionRadius (10*_i);
						//_Vwp0 setWaypointStatements ["true", "[vehicle this] call smokeCoverAuto"];
						_Vwp1 = _grupoVeh addWaypoint [_posdestino, 1];
						_Vwp1 setWaypointType "SAD";
						_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
						_Vwp1 setWaypointBehaviour "COMBAT";
						_Vwp2 = _grupo addWaypoint [_landPos, 0];
						_Vwp2 setWaypointType "GETOUT";
						_Vwp0 synchronizeWaypoint [_Vwp2];
						_Vwp3 = _grupo addWaypoint [_posdestino, 1];
						_Vwp3 setWaypointType "MOVE";
						_Vwp3 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
						_Vwp3 = _grupo addWaypoint [_posdestino, 1];
						_Vwp3 setWaypointType "SAD";
						_veh allowCrewInImmobile true;
						[_veh,"APC"] spawn inmuneConvoy;
						}
					else
						{
						{[_x] join _grupoVeh} forEach units _grupo;
						deleteGroup _grupo;
						_grupoVeh selectLeader (units _grupoVeh select 1);
						_Vwp = _grupoVeh addWaypoint [_landPos, 0];
						_Vwp setWaypointBehaviour "SAFE";
						_Vwp setWaypointType "MOVE";
						_Vwp0 setWaypointSpeed "FULL";
						_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
						//_Vwp0 setWaypointBehaviour "SAFE";
						_Vwp0 setWaypointType "GETOUT";
						//_Vwp0 setWaypointSpeed "FULL";
						_Vwp1 = _grupoVeh addWaypoint [_posDestino, 1];
						_Vwp1 setWaypointType "MOVE";
						_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
						_Vwp1 setWaypointBehaviour "COMBAT";
						_Vwp1 = _grupoVeh addWaypoint [_posDestino, 1];
						_Vwp1 setWaypointType "SAD";
						[_veh,"Boat"] spawn inmuneConvoy;
						};
					};
				};
			sleep 15;
			_cuenta = _cuenta + 1;
			};
		};
	};

if (_posOrigen distance _posDestino < 5000) then {sleep ((_posOrigen distance _posDestino)/30)};

_posorigen set [2,300];
_tipoVeh = if (_lado == malos) then {vehNATOUAV} else {vehCSATUAV};

_uav = createVehicle [_tipoVeh, _posorigen, [], 0, "FLY"];
_vehiculos pushBack _uav;
[_uav,"UAV"] spawn inmuneConvoy;
[_uav,_mrkDestino,_lado] spawn VANTinfo;
createVehicleCrew _uav;
_pilotos = _pilotos + crew _uav;
_grupouav = group (crew _uav select 0);
_grupos pushBack _grupouav;
{[_x] call NATOinit} forEach units _grupoUav;
[_uav] call AIVEHinit;
_uwp0 = _grupouav addWayPoint [_posdestino,0];
_uwp0 setWaypointBehaviour "AWARE";
_uwp0 setWaypointType "SAD";
if (not(_mrkDestino in aeropuertos)) then {_uav removeMagazines "6Rnd_LG_scalpel"};
diag_log format ["Antistasi: UAV %1 spawned. Number of vehicles %2",_tipoVeh,count _vehiculos];
sleep 5;

_vehPool = if (_lado == malos) then {vehNATOAir} else {vehCSATAir};
if (_esSDK) then
	{
	_rnd = random 100;
	if (_lado == malos) then
		{
		if (_rnd > prestigeNATO) then
			{
			_vehPool = _vehPool - [vehNATOPlane];
			};
		}
	else
		{
		if (_rnd > prestigeCSAT) then
			{
			_vehPool = _vehPool - [vehCSATPlane];
			};
		};
	};
_cuenta = 1;
_pos = _posOrigen;
_ang = 0;
_size = [_mrkOrigen] call sizeMarker;
_buildings = nearestObjects [_posOrigen, ["Land_LandMark_F","Land_runway_edgelight"], _size / 2];
if (count _buildings > 1) then
	{
	_pos1 = getPos (_buildings select 0);
	_pos2 = getPos (_buildings select 1);
	_ang = [_pos1, _pos2] call BIS_fnc_DirTo;
	_pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
	};

while {_cuenta <= _nVeh} do
	{
	_tipoVeh = selectRandom _vehPool;
	if (not([_tipoVeh] call vehAvailable)) then
		{
		_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTransportHelis} else {selectRandom vehCSATTransportHelis};
		_vehPool = _vehPool - [_tipoVeh];
		};
	if ((_cuenta == _nVeh) or (_cuenta == 1)) then
		{
		if ((_tipoVeh in vehAttackHelis) or (_tipoVeh in vehPlanes)) then
			{
			_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTransportHelis} else {selectRandom vehCSATTransportHelis};
			};
		};
	/*
	_timeOut = 0;
	_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
	while {_timeOut < 60} do
		{
		if (count _pos > 0) exitWith {};
		_timeOut = _timeOut + 1;
		_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
		sleep 1;
		};
	if (count _pos == 0) then {_pos = _posorigen};
	*/
	_vehicle=[_pos, _ang + 90,_tipoveh, _lado] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	_vehCrew = _vehicle select 1;
	_grupoVeh = _vehicle select 2;
	_pilotos = _pilotos + _vehCrew;
	_vehiculos pushBack _veh;
	{[_x] call NATOinit} forEach units _grupoVeh;
	[_veh] call AIVEHinit;
	if (not (_tipoVeh in vehTransportAir)) then
		{
		{[_x] joinSilent _grupoUav} forEach units _grupoVeh;
		deleteGroup _grupoVeh;
		[_veh,"Air Attack"] spawn inmuneConvoy;
		}
	else
		{
		_grupos pushBack _grupoVeh;
		_tipogrupo = [_tipoVeh,_lado] call cargoSeats;
		_grupo = [_posorigen,_lado, _tipogrupo] call spawnGroup;
		_grupos pushBack _grupo;
		{_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x;[_x] call NATOinit} forEach units _grupo;
		if (_mrkDestino in aeropuertos) then
			{
			{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _grupo;
			[_veh,_grupo,_mrkDestino,_mrkOrigen] spawn airdrop;
			}
		else
			{
			_proceder = true;
			if (_esSDK) then
				{
				if (((count(garrison getVariable _mrkDestino)) < 10) and (_tipoVeh in vehFastRope)) then
					{
					_proceder = false;
					[_veh,_grupo,_posDestino,_posOrigen,_grupoVeh] spawn fastrope;
					};
				};
			if (_proceder) then
				{
				{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoVeh;
				_pos = _posDestino getPos [(random 500) + 300, random 360];
				_landPos = _pos findEmptyPosition [0,100,_tipoveh];
				if (count _landPos > 0) then
					{
					_isFlatEmpty = !(_landPos isFlatEmpty  [1, -1, 0.1, 15, -1, false, objNull] isEqualTo []);
					if (!_isFlatEmpty) then
						{
						_landPos = [];
						};
					};
				if (count _landPos > 0) then
					{
					_landPos set [2, 0];
					_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
					_vehiculos pushBack _pad;
					_wp0 = _grupoVeh addWaypoint [_landpos, 0];
					_wp0 setWaypointType "TR UNLOAD";
					_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';[vehicle this] call smokeCoverAuto"];
					_wp0 setWaypointBehaviour "CARELESS";
					_wp3 = _grupo addWaypoint [_landpos, 0];
					_wp3 setWaypointType "GETOUT";
					_wp0 synchronizeWaypoint [_wp3];
					_wp4 = _grupo addWaypoint [_posDestino, 1];
					_wp4 setWaypointType "MOVE";
					_wp4 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
					_wp4 = _grupo addWaypoint [_posDestino, 1];
					_wp4 setWaypointType "SAD";
					_wp2 = _grupoVeh addWaypoint [_posOrigen, 1];
					_wp2 setWaypointType "MOVE";
					_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
					[_grupoVeh,1] setWaypointBehaviour "AWARE";
					}
				else
					{
					if (_tipoVeh in vehFastRope) then
						{
						[_veh,_grupo,_pos,_posOrigen,_grupoVeh] spawn fastrope;
						}
					else
						{
						{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _grupo;
						[_veh,_grupo,_mrkDestino,_mrkOrigen] spawn airdrop;
						}
					};
				};
			};
		};
	sleep 1;
	_pos = [_pos, 80,_ang] call BIS_fnc_relPos;
	_cuenta = _cuenta + 1;
	};

_plane = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane};
if (_lado == malos) then
	{
	if ((not(_mrkDestino in puestos)) and (not(_mrkDestino in puertos))) then
		{
		[_mrkOrigen,_mrkDestino] spawn artilleria;
		diag_log "Antistasi: Arty Spawned";
		if (([_plane] call vehAvailable) and (not(_mrkDestino in ciudades))) then
			{
			sleep 60;
			_rnd = if (_mrkDestino in aeropuertos) then {round random 4} else {round random 2};
			for "_i" from 0 to _rnd do
				{
				diag_log "Antistasi: Airstrike Spawned";
				if (_i == 0) then
					{
					if (_mrkDestino in aeropuertos) then
						{
						_nul = [_mrkdestino,_lado,"HE"] spawn airstrike;
						}
					else
						{
						_nul = [_mrkdestino,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn airstrike;
						};
					}
				else
					{
					_nul = [_mrkdestino,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn airstrike;
					};
				sleep 30;
				};
			};
		};
	}
else
	{
	if ((not(_mrkDestino in recursos)) and (not(_mrkDestino in puertos))) then
		{
		[_mrkOrigen,_mrkDestino] spawn artilleria;
		diag_log "Antistasi: Arty Spawned";
		if ([_plane] call vehAvailable) then
			{
			sleep 60;
			_rnd = if (_mrkDestino in aeropuertos) then {if ((_mrkDestino == "airport") and (_mrkOrigen == "airport_1") and ({_x in mrkCSAT} count aeropuertos == 1)) then {8} else {round random 4}} else {round random 2};
			for "_i" from 0 to _rnd do
				{
				diag_log "Antistasi: Airstrike Spawned";
				if (_i == 0) then
					{
					if (_mrkDestino in aeropuertos) then
						{
						_nul = [_mrkdestino,_lado,"HE"] spawn airstrike;
						}
					else
						{
						_nul = [_mrkdestino,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn airstrike;
						};
					}
				else
					{
					_nul = [_posDestino,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn airstrike;
					};
				sleep 30;
				};
			};
		};
	};

if (_esSDK) then
	{
	sleep 60;
	["TaskSucceeded", ["", "Attack Destination Updated"]] remoteExec ["BIS_fnc_showNotification",buenos];
	_tsk = ["AtaqueAAF",buenos,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
	};
_solMax = round ((count _soldados)/3);
_size = [_mrkDestino] call sizeMarker;
diag_log "Antistasi: Reached end of spawning attack";
if (_lado == malos) then
	{
	waitUntil {sleep 5; (({not (captive _x)} count _soldados) <= ({captive _x} count _soldados)) or ({alive _x} count _soldados < _solMax) or (time > _tiempo) or (_mrkDestino in mrkNATO) or (({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits))};
	if  ((({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits)) and (not(_mrkDestino in mrkNATO))) then
		{
		["BLUFORSpawn",_mrkDestino] remoteExec ["markerChange",2];
		_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkOrigen],getMarkerPos _mrkOrigen,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
		_tsk1 = ["AtaqueAAF1",_ladosTsk1,[format ["We are attacking an %2 from the %1. Help the operation if you can",_nombreorig,_nombreDest],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"SUCEEDED",10,true,true,"Attack"] call BIS_fnc_setTask;
		if (_mrkDestino in ciudades) then
			{
			[0,-100,_mrkDestino] remoteExec ["citySupportChange",2];
			["TaskFailed", ["", format ["%1 joined NATO",[_mrkDestino, false] call fn_location]]] remoteExec ["BIS_fnc_showNotification",buenos];
			mrkNATO = mrkNATO + [_mrkDestino];
			mrkSDK = mrkSDK - [_mrkDestino];
			publicVariable "mrkNATO";
			publicVariable "mrkSDK";
			_nul = [-5,0] remoteExec ["prestige",2];
			_mrkD = format ["Dum%1",_mrkDestino];
			_mrkD setMarkerColor colorMalos;
			garrison setVariable [_mrkDestino,[],true];
			};
		};
	sleep 10;
	if (!(_mrkDestino in mrkNATO)) then
		{
		{_x doMove _posorigen} forEach _soldados;
		[_mrkDestino,_mrkOrigen] call minefieldAAF;
		_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkOrigen],getMarkerPos _mrkOrigen,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
		_tsk1 = ["AtaqueAAF1",_ladosTsk1,[format ["We are attacking an %2 from the %1. Help the operation if you can",_nombreorig,_nombreDest],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"FAILED",10,true,true,"Attack"] call BIS_fnc_setTask;
		};
	}
else
	{
	waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < _solMax) or (time > _tiempo) or (_mrkDestino in mrkCSAT) or (({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits))};
	if  ((({(alive _x) and (!captive _x) and (_x distance _posDestino <= _size)} count _soldados) > 3*({(alive _x) and (!captive _x) and (side _x != _lado) and (side _x != civilian) and (_x distance _posDestino <= _size)} count allUnits)) and (not(_mrkDestino in mrkCSAT))) then
		{
		["OPFORSpawn",_mrkDestino] remoteExec ["markerChange",2];
		_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkOrigen],getMarkerPos _mrkOrigen,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
		_tsk1 = ["AtaqueAAF1",_ladosTsk1,[format ["We are attacking an %2 from the %1. Help the operation if you can",_nombreorig,_nombreDest],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"SUCCEEDED",10,true,true,"Attack"] call BIS_fnc_setTask;
		};
	sleep 10;
	if (!(_mrkDestino in mrkCSAT)) then
		{
		{_x doMove _posorigen} forEach _soldados;
		[_mrkDestino,_mrkOrigen] call minefieldAAF;
		_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],format ["%1 Attack",_nombreEny],_mrkOrigen],getMarkerPos _mrkOrigen,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
		_tsk1 = ["AtaqueAAF1",_ladosTsk1,[format ["We are attacking an %2 from the %1. Help the operation if you can",_nombreorig,_nombreDest],format ["%1 Attack",_nombreEny],_mrkDestino],getMarkerPos _mrkDestino,"FAILED",10,true,true,"Attack"] call BIS_fnc_setTask;
		}
	};

//_tsk = ["AtaqueAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig,_nombreEny],"AAF Attack",_mrkOrigen],getMarkerPos _mrkOrigen,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
if (_esSDK) then
	{
	if (!(_mrkDestino in mrkSDK)) then
		{
		[-10,stavros] call playerScoreAdd;
		}
	else
		{
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posdestino,"GREENFORSpawn"] call distanceUnits);
		[5,stavros] call playerScoreAdd;
		};
	};
diag_log "Antistasi: Reached end of winning conditions. Starting despawn";
sleep 30;
_nul = [0,_tsk] spawn borrarTask;
_nul = [0,_tsk1] spawn borrarTask;

[_mrkOrigen,60] call addTimeForIdle;
bigAttackInProgress = false; publicVariable "bigAttackInProgress";
if (_mrkDestino in forcedSpawn) then {forcedSpawn = forcedSpawn - [_mrkDestino]; publicVariable "forcedSpawn"};
[3600] remoteExec ["timingCA",2];

{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)) then {deleteVehicle _x};
} forEach _vehiculos;
{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)) then {deleteVehicle _x; _soldados = _soldados - [_x]};
} forEach _soldados;
{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)) then {deleteVehicle _x; _pilotos = _pilotos - [_x]};
} forEach _pilotos;

if (count _soldados > 0) then
	{
	{
	_veh = _x;
	waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)};
	deleteVehicle _veh;
	} forEach _soldados;
	};

if (count _pilotos > 0) then
	{
	{
	_veh = _x;
	waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - HCArray)) == 0)};
	deleteVehicle _veh;
	} forEach _pilotos;
	};
{deleteGroup _x} forEach _grupos;
diag_log "Antistasi: Despawn completed";
