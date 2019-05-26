if (!isServer and hasInterface) exitWith {};

private ["_posOrigin","_typeGroup","_nameOrigin","_markTsk","_wp1","_soldados","_landpos","_pad","_vehiclesX","_wp0","_wp3","_wp4","_wp2","_grupo","_grupos","_tipoveh","_vehicle","_heli","_heliCrew","_groupHeli","_pilotos","_rnd","_resourcesAAF","_nVeh","_tam","_roads","_Vwp1","_road","_veh","_vehCrew","_grupoVeh","_Vwp0","_size","_Hwp0","_grupo1","_uav","_grupouav","_uwp0","_tsk","_vehiculo","_soldado","_piloto","_mrkDestination","_posDestination","_prestigeCSAT","_mrkOrigin","_airportX","_nameDest","_tiempo","_solMax","_nul","_coste","_tipo","_threatEvalAir","_threatEvalLand","_pos","_timeOut","_lado","_waves","_cuenta","_tsk1","_spawnPoint","_vehPool"];

bigAttackInProgress = true;
publicVariable "bigAttackInProgress";
_firstWave = true;
_mrkDestination = _this select 0;
_mrkOrigin = _this select 1;
_waves = _this select 2;
if (_waves <= 0) then {_waves = -1};
_size = [_mrkDestination] call A3A_fnc_sizeMarker;
diag_log format ["Antistasi: Waved attack from %1 to %2. Waves: %3",_mrkOrigin,_mrkDestination,_waves];
_tsk = "";
_tsk1 = "";
_posDestination = getMarkerPos _mrkDestination;
_posOrigin = getMarkerPos _mrkOrigin;

_groups = [];
_soldiersTotal = [];
_pilots = [];
_vehiclesX = [];
_forced = [];

_nameDest = [_mrkDestination] call A3A_fnc_localizar;
_nameOrigin = [_mrkOrigin] call A3A_fnc_localizar;

_lado = lados getVariable [_mrkOrigin,sideUnknown];
_ladosTsk = [buenos,civilian,muyMalos];
_ladosTsk1 = [malos];
_nameENY = nameOccupants;
//_config = cfgNATOInf;
if (_lado == muyMalos) then
	{
	_nameENY = nameInvaders;
	//_config = cfgCSATInf;
	_ladosTsk = [buenos,civilian,malos];
	_ladosTsk1 = [muyMalos];
	};
_isSDK = if (sidesX getVariable [_mrkDestination,sideUnknown] == teamPlayer) then {true} else {false};
_SDKShown = false;
if (_isSDK) then
	{
	_ladosTsk = [buenos,civilian,malos,muyMalos] - [_lado];
	}
else
	{
	if (not(_mrkDestination in _forced)) then {_forced pushBack _mrkDestination};
	};

//forcedSpawn = forcedSpawn + _forced; publicVariable "forcedSpawn";
forcedSpawn pushBack _mrkDestination; publicVariable "forcedSpawn";
diag_log format ["Antistasi: Side attacker: %1. Side defender (false, the other AI side):  %2",_lado,_isSDK];
_nameDest = [_mrkDestination] call A3A_fnc_localizar;

[_ladosTsk,"AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,false,0,true,"Defend",true] call BIS_fnc_taskCreate;
[_ladosTsk1,"AttackAAF1",[format ["We are attacking %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,false,0,true,"Attack",true] call BIS_fnc_taskCreate;
//_tsk = ["AttackAAF",_ladosTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
//misiones pushbackUnique "AttackAAF"; publicVariable "misiones";
//_tsk1 = ["AttackAAF1",_ladosTsk1,[format ["We are attacking %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"CREATED",10,true,true,"Attack"] call BIS_fnc_setTask;

_timeX = time + 3600;

while {(_waves > 0)} do
	{
	_soldados = [];
	_nVeh = 3 + (round random 1);
	_posOriginLand = [];
	_pos = [];
	_dir = 0;
	_spawnPoint = "";
	if !(_mrkDestination in blackListDest) then
		{
		if (_posOrigin distance _posDestination < distanceForLandAttack) then
			{
			_indexX = airportsX find _mrkOrigin;
			_spawnPoint = spawnPoints select _indexX;
			_pos = getMarkerPos _spawnPoint;
			_posOriginLand = _posOrigin;
			_dir = markerDir _spawnPoint;
			}
		else
			{
			_outposts = outposts select {(sidesX getVariable [_x,sideUnknown] == _lado) and (getMarkerPos _x distance _posDestination < distanceForLandAttack)  and ([_x,false] call A3A_fnc_airportCanAttack)};
			if !(_outposts isEqualTo []) then
				{
				_outpost = selectRandom _outposts;
				_posOriginLand = getMarkerPos _outpost;
				//[_outpost,60] call A3A_fnc_addTimeForIdle;
				_spawnPoint = [_posOriginLand] call A3A_fnc_findNearestGoodRoad;
				_pos = position _spawnPoint;
				_dir = getDir _spawnPoint;
				};
			};
		};
	if !(_pos isEqualTo []) then
		{
		if ([_mrkDestination,true] call A3A_fnc_fogCheck < 0.3) then {_nveh = round (1.5*_nveh)};
		_vehPool = if (_lado == Occupants) then {vehNATOAttack} else {vehCSATAttack};
		_vehPool = _vehPool select {[_x] call A3A_fnc_vehAvailable};
		if (_isSDK) then
			{
			_rnd = random 100;
			if (_lado == Occupants) then
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
		_road = [_posDestination] call A3A_fnc_findNearestGoodRoad;
		if ((position _road) distance _posDestination > 150) then {_vehPool = _vehPool - vehTanks};
		_countX = 1;
		_landPosBlacklist = [];
		_spawnedSquad = false;
		while {(_cuenta <= _nVeh) and (count _soldados <= 80)} do
			{
			if (_vehPool isEqualTo []) then
				{
				if (_lado == Occupants) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks};
				};
			_typeVehX = selectRandom _vehPool;
			if ((_countX == _nVeh) and (_typeVehX in vehTanks)) then
				{
				_typeVehX = if (_lado == Occupants) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
				};
			_proceder = true;
			if ((_tipoVeh in (vehNATOTrucks+vehCSATTrucks)) and _spawnedSquad) then
				{
				_allUnits = {(local _x) and (alive _x)} count allUnits;
				_allUnitsSide = 0;
				_maxUnitsSide = maxUnits;

				if (gameMode <3) then
					{
					_allUnitsSide = {(local _x) and (alive _x) and (side group _x == _lado)} count allUnits;
					_maxUnitsSide = round (maxUnits * 0.7);
					};
				if ((_allUnits + 4 > maxUnits) or (_allUnitsSide + 4 > _maxUnitsSide)) then {_proceder = false};
				};
			if (_proceder) then
				{
				_timeOut = 0;
				_pos = _pos findEmptyPosition [0,100,_typeVehX];
				while {_timeOut < 60} do
					{
					if (count _pos > 0) exitWith {};
					_timeOut = _timeOut + 1;
					_pos = _pos findEmptyPosition [0,100,_typeVehX];
					sleep 1;
					};
				if (count _pos == 0) then {_pos = getMarkerPos _spawnPoint};
				_vehicle=[_pos, _dir,_typeVehX, _lado] call bis_fnc_spawnvehicle;

				_veh = _vehicle select 0;
				_vehCrew = _vehicle select 1;
				{[_x] call A3A_fnc_NATOinit} forEach _vehCrew;
				[_veh] call A3A_fnc_AIVEHinit;
				_grupoVeh = _vehicle select 2;
				_soldados append _vehCrew;
				_soldiersTotal append _vehCrew;
				_grupos pushBack _grupoVeh;
				_vehiclesX pushBack _veh;
				_landPos = [_posDestination,_pos,false,_landPosBlacklist] call A3A_fnc_findSafeRoadToUnload;
				if (not(_typeVehX in vehTanks)) then
					{
					_landPosBlacklist pushBack _landPos;
					_typeGroup = [_typeVehX,_lado] call A3A_fnc_cargoSeats;
					_group = grpNull;
					if !(_spawnedSquad) then {_group = [_posOrigin,_lado, _typeGroup,true,false] call A3A_fnc_spawnGroup; _spawnedSquad = true} else {_group = [_posOrigin,_lado, _typeGroup] call A3A_fnc_spawnGroup};
					{
					_x assignAsCargo _veh;
					_x moveInCargo _veh;
					if (vehicle _x == _veh) then
						{
						_soldados pushBack _x;
						_soldiersTotal pushBack _x;
						[_x] call A3A_fnc_NATOinit;
						_x setVariable ["originX",_mrkOrigin];
						}
					else
						{
						deleteVehicle _x;
						};
					} forEach units _group;
					if (not(_typeVehX in vehTrucks)) then
						{
						{_x disableAI "MINEDETECTION"} forEach (units _grupoVeh);
						(units _grupo) joinSilent _grupoVeh;
						deleteGroup _grupo;
						_grupoVeh spawn A3A_fnc_attackDrillAI;
						[_posOriginLand,_landPos,_grupoVeh] call WPCreate;
						_Vwp0 = (wayPoints _grupoVeh) select 0;
						_Vwp0 setWaypointBehaviour "SAFE";
						_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
						_Vwp0 setWaypointType "TR UNLOAD";
						//_Vwp0 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
						_Vwp0 setWayPointCompletionRadius (10*_cuenta);
						_Vwp1 = _grupoVeh addWaypoint [_posDestination, 1];
						_Vwp1 setWaypointType "SAD";
						_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
						_Vwp1 setWaypointBehaviour "COMBAT";
						_veh allowCrewInImmobile true;
						[_veh,"APC"] spawn A3A_fnc_inmuneConvoy;
						}
					else
						{
						(units _grupo) joinSilent _grupoVeh;
						deleteGroup _grupo;
						_grupoVeh selectLeader (units _grupoVeh select 1);
						_grupoVeh spawn A3A_fnc_attackDrillAI;
						[_posOriginLand,_landPos,_grupoVeh] call WPCreate;
						_Vwp0 = (wayPoints _grupoVeh) select 0;
						_Vwp0 setWaypointBehaviour "SAFE";
						_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
						_Vwp0 setWaypointType "GETOUT";
						//_Vwp0 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
						_Vwp1 = _grupoVeh addWaypoint [_posDestination, count (wayPoints _grupoVeh)];
						_Vwp1 setWaypointType "SAD";
						[_veh,"Inf Truck."] spawn A3A_fnc_inmuneConvoy;
						};
					}
				else
					{
					{_x disableAI "MINEDETECTION"} forEach (units _grupoVeh);
					[_posOriginLand,_posDestination,_grupoVeh] call WPCreate;
					_Vwp0 = (wayPoints _grupoVeh) select 0;
					_Vwp0 setWaypointBehaviour "SAFE";
					_Vwp0 = _grupoVeh addWaypoint [_posDestination, count (wayPoints _grupoVeh)];
					_Vwp0 setWaypointType "MOVE";
					_Vwp0 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
					_Vwp0 = _grupoVeh addWaypoint [_posDestination, count (wayPoints _grupoVeh)];
					_Vwp0 setWaypointType "SAD";
					[_veh,"Tank"] spawn A3A_fnc_inmuneConvoy;
					_veh allowCrewInImmobile true;
					};
				};
				sleep 15;
				_countX = _countX + 1;
				_vehPool = _vehPool select {[_x] call A3A_fnc_vehAvailable};
			};
		}
	else
		{
		_nVeh = 2*_nVeh;
		};

	_isSea = false;
	if !(hasIFA) then
		{
		for "_i" from 0 to 3 do
			{
			_pos = _posDestination getPos [1000,(_i*90)];
			if (surfaceIsWater _pos) exitWith
				{
				if ({sidesX getVariable [_x,sideUnknown] == _lado} count seaports > 1) then
					{
					_isSea = true;
					};
				};
			};
		};

	if ((_isSea) and (_firstWave)) then
		{
		_pos = getMarkerPos ([seaAttackSpawn,_posDestination] call BIS_fnc_nearestPosition);
		if (count _pos > 0) then
			{
			_vehPool = if (_lado == Occupants) then {vehNATOBoats} else {vehCSATBoats};
			_vehPool = _vehPool select {[_x] call A3A_fnc_vehAvailable};
			_countX = 0;
			_spawnedSquad = false;
			while {(_cuenta < 3) and (count _soldados <= 80)} do
				{
				_tipoVeh = if (_vehPool isEqualTo []) then {if (_lado == malos) then {vehNATORBoat} else {vehCSATRBoat}} else {selectRandom _vehPool};
				_proceder = true;
				if ((_tipoVeh == vehNATOBoat) or (_tipoVeh == vehCSATBoat)) then
					{
					_landPos = [_posDestination, 10, 1000, 10, 2, 0.3, 0] call BIS_Fnc_findSafePos;
					}
				else
					{
					_allUnits = {(local _x) and (alive _x)} count allUnits;
					_allUnitsSide = 0;
					_maxUnitsSide = maxUnits;
					if (gameMode <3) then
						{
						_allUnitsSide = {(local _x) and (alive _x) and (side group _x == _lado)} count allUnits;
						_maxUnitsSide = round (maxUnits * 0.7);
						};
					if (((_allUnits + 4 > maxUnits) or (_allUnitsSide + 4 > _maxUnitsSide)) and _spawnedSquad) then
						{
						_proceder = false
						}
					else
						{
						_typeGroup = [_typeVehX,_lado] call A3A_fnc_cargoSeats;
						_landPos = [_posDestination, 10, 1000, 10, 2, 0.3, 1] call BIS_Fnc_findSafePos;
						};
					};
				if ((count _landPos > 0) and _proceder) then
					{
					_vehicle=[_pos, random 360,_typeVehX, _lado] call bis_fnc_spawnvehicle;

					_veh = _vehicle select 0;
					_vehCrew = _vehicle select 1;
					_grupoVeh = _vehicle select 2;
					_pilotos append _vehCrew;
					_grupos pushBack _grupoVeh;
					_vehiclesX pushBack _veh;
					{[_x] call A3A_fnc_NATOinit} forEach units _grupoVeh;
					[_veh] call A3A_fnc_AIVEHinit;
					if ((_typeVehX == vehNATOBoat) or (_typeVehX == vehCSATBoat)) then
						{
						_wp0 = _grupoVeh addWaypoint [_landpos, 0];
						_wp0 setWaypointType "SAD";
						//[_veh,"Boat"] spawn A3A_fnc_inmuneConvoy;
						}
					else
						{
						_group = grpNull;
						if !(_spawnedSquad) then {_group = [_posOrigin,_lado, _typeGroup,true,false] call A3A_fnc_spawnGroup;_spawnedSquad = true} else {_group = [_posOrigin,_lado, _typeGroup,false,true] call A3A_fnc_spawnGroup};
						{
						_x assignAsCargo _veh;
						_x moveInCargo _veh;
						if (vehicle _x == _veh) then
							{
							_soldados pushBack _x;
							_soldiersTotal pushBack _x;
							[_x] call A3A_fnc_NATOinit;
							_x setVariable ["originX",_mrkOrigin];
							}
						else
							{
							deleteVehicle _x;
							};
						} forEach units _group;
						if (_typeVehX in vehAPCs) then
							{
							_grupos pushBack _grupo;
							_Vwp = _grupoVeh addWaypoint [_landPos, 0];
							_Vwp setWaypointBehaviour "SAFE";
							_Vwp setWaypointType "TR UNLOAD";
							_Vwp setWaypointSpeed "FULL";
							_Vwp1 = _grupoVeh addWaypoint [_posDestination, 1];
							_Vwp1 setWaypointType "SAD";
							_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
							_Vwp1 setWaypointBehaviour "COMBAT";
							_Vwp2 = _group addWaypoint [_landPos, 0];
							_Vwp2 setWaypointType "GETOUT";
							_Vwp2 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
							//_group setVariable ["mrkAttack",_mrkDestination];
							_Vwp synchronizeWaypoint [_Vwp2];
							_Vwp3 = _group addWaypoint [_posDestination, 1];
							_Vwp3 setWaypointType "SAD";
							_veh allowCrewInImmobile true;
							//[_veh,"APC"] spawn A3A_fnc_inmuneConvoy;
							}
						else
							{
							(units _grupo) joinSilent _grupoVeh;
							deleteGroup _grupo;
							_grupoVeh selectLeader (units _grupoVeh select 1);
							_Vwp = _grupoVeh addWaypoint [_landPos, 0];
							_Vwp setWaypointBehaviour "SAFE";
							_Vwp setWaypointSpeed "FULL";
							_Vwp setWaypointType "GETOUT";
							_Vwp setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
							_Vwp1 = _grupoVeh addWaypoint [_posDestination, 1];
							_Vwp1 setWaypointType "SAD";
							_Vwp1 setWaypointBehaviour "COMBAT";
							//[_veh,"Boat"] spawn A3A_fnc_inmuneConvoy;
							};
						};
					};
				sleep 15;
				_countX = _countX + 1;
				_vehPool = _vehPool select {[_x] call A3A_fnc_vehAvailable};
				};
			};
		};
	if ([_mrkDestination,true] call A3A_fnc_fogCheck >= 0.3) then
		{
		if ((_posOrigin distance _posDestination < distanceForLandAttack) and !(_mrkDestination in blackListDest)) then {sleep ((_posOrigin distance _posDestination)/30)};
		_posSuelo = [_posOrigin select 0,_posOrigin select 1,0];
		_posOrigin set [2,300];
		_grupoUav = grpNull;
		if !(hayIFA) then
			{
			_typeVehX = if (_lado == Occupants) then {vehNATOUAV} else {vehCSATUAV};

			_uav = createVehicle [_typeVehX, _posOrigin, [], 0, "FLY"];
			_vehiclesX pushBack _uav;
			//[_uav,"UAV"] spawn A3A_fnc_inmuneConvoy;
			[_uav,_mrkDestination,_lado] spawn A3A_fnc_VANTinfo;
			createVehicleCrew _uav;
			_pilotos append (crew _uav);
			_grupouav = group (crew _uav select 0);
			_grupos pushBack _grupouav;
			{[_x] call A3A_fnc_NATOinit} forEach units _grupoUav;
			[_uav] call A3A_fnc_AIVEHinit;
			_uwp0 = _grupouav addWayPoint [_posDestination,0];
			_uwp0 setWaypointBehaviour "AWARE";
			_uwp0 setWaypointType "SAD";
			if (not(_mrkDestination in airportsX)) then {_uav removeMagazines "6Rnd_LG_scalpel"};
			sleep 5;
			}
		else
			{
			_grupoUav = createGroup _lado;
			//_posOrigin set [2,2000];
			_uwp0 = _grupouav addWayPoint [_posDestination,0];
			_uwp0 setWaypointBehaviour "AWARE";
			_uwp0 setWaypointType "SAD";
			};
		_vehPool = if (_lado == Occupants) then
					{
					if (_mrkDestination in airportsX) then {(vehNATOAir - [vehNATOPlaneAA]) select {[_x] call A3A_fnc_vehAvailable}} else {(vehNatoAir - vehFixedWing) select {[_x] call A3A_fnc_vehAvailable}};
					}
				else
					{
					if (_mrkDestination in airportsX) then {(vehCSATAir - [vehCSATPlaneAA]) select {[_x] call A3A_fnc_vehAvailable}} else {(vehCSATAir - vehFixedWing) select {[_x] call A3A_fnc_vehAvailable}};
					};
		if (_isSDK) then
			{
			_rnd = random 100;
			if (_lado == Occupants) then
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
		if ((_waves != 1) and (_firstWave) and (!hasIFA)) then
			{
			if (count (_vehPool - vehTransportAir) != 0) then {_vehPool = _vehPool - vehTransportAir};
			};
		_countX = 1;
		_pos = _posOrigin;
		_ang = 0;
		_size = [_mrkOrigin] call A3A_fnc_sizeMarker;
		_buildings = nearestObjects [_posOrigin, ["Land_LandMark_F","Land_runway_edgelight"], _size / 2];
		if (count _buildings > 1) then
			{
			_pos1 = getPos (_buildings select 0);
			_pos2 = getPos (_buildings select 1);
			_ang = [_pos1, _pos2] call BIS_fnc_DirTo;
			_pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
			};
		_spawnedSquad = false;
		while {(_cuenta <= _nVeh) and (count _soldados <= 80)} do
			{
			_proceder = true;
			if (_cuenta == _nveh) then {if (_lado == malos) then {_vehPool = _vehPool select {_x in vehNATOTransportHelis}} else {_vehPool = _vehPool select {_x in vehCSATTransportHelis}}};
			_tipoVeh = if !(_vehPool isEqualTo []) then {selectRandom _vehPool} else {if (_lado == malos) then {vehNATOPatrolHeli} else {vehCSATPatrolHeli}};
			if ((_tipoVeh in vehTransportAir) and !(_spawnedSquad)) then
				{
				_allUnits = {(local _x) and (alive _x)} count allUnits;
				_allUnitsSide = 0;
				_maxUnitsSide = maxUnits;
				if (gameMode <3) then
					{
					_allUnitsSide = {(local _x) and (alive _x) and (side group _x == _lado)} count allUnits;
					_maxUnitsSide = round (maxUnits * 0.7);
					};
				if ((_allUnits + 4 > maxUnits) or (_allUnitsSide + 4 > _maxUnitsSide)) then
					{
					_proceder = false
					};
				};
			if (_proceder) then
				{
				_vehicle=[_pos, _ang + 90,_typeVehX, _lado] call bis_fnc_spawnvehicle;
				_veh = _vehicle select 0;
				if (hasIFA) then {_veh setVelocityModelSpace [((velocityModelSpace _veh) select 0) + 0,((velocityModelSpace _veh) select 1) + 150,((velocityModelSpace _veh) select 2) + 50]};
				_vehCrew = _vehicle select 1;
				_grupoVeh = _vehicle select 2;
				_pilotos append _vehCrew;
				_vehiclesX pushBack _veh;
				{[_x] call A3A_fnc_NATOinit} forEach units _grupoVeh;
				[_veh] call A3A_fnc_AIVEHinit;
				if (not (_typeVehX in vehTransportAir)) then
					{
					(units _grupoVeh) joinSilent _grupoUav;
					deleteGroup _grupoVeh;
					//[_veh,"Air Attack"] spawn A3A_fnc_inmuneConvoy;
					}
				else
					{
					_grupos pushBack _grupoVeh;
					_typeGroup = [_tipoVeh,_lado] call A3A_fnc_cargoSeats;
					_grupo = grpNull;
					if !(_spawnedSquad) then {_grupo = [_posSuelo,_lado, _typeGroup,true,false] call A3A_fnc_spawnGroup;_spawnedSquad = true} else {_grupo = [_posSuelo,_lado, _typeGroup] call A3A_fnc_spawnGroup};
					_grupos pushBack _grupo;
					{
					_x assignAsCargo _veh;
					_x moveInCargo _veh;
					if (vehicle _x == _veh) then
						{
						_soldados pushBack _x;
						_soldiersTotal pushBack _x;
						[_x] call A3A_fnc_NATOinit;
						_x setVariable ["originX",_mrkOrigin];
						}
					else
						{
						deleteVehicle _x;
						};
					} forEach units _group;
					if (!(_veh isKindOf "Helicopter") or (_mrkDestination in airportsX)) then
						{
						[_veh,_group,_mrkDestination,_mrkOrigin] spawn A3A_fnc_airdrop;
						}
					else
						{
						_landPos = _posDestination getPos [300, random 360];
						_landPos = [_landPos, 0, 550, 10, 0, 0.20, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
						if !(_landPos isEqualTo [0,0,0]) then
							{
							_landPos set [2, 0];
							_pad = createVehicle ["Land_HelipadEmpty_F", _landPos, [], 0, "NONE"];
							_vehiclesX pushBack _pad;
							_wp0 = _grupoVeh addWaypoint [_landpos, 0];
							_wp0 setWaypointType "TR UNLOAD";
							_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';[vehicle this] call A3A_fnc_smokeCoverAuto"];
							_wp0 setWaypointBehaviour "CARELESS";
							_wp3 = _group addWaypoint [_landpos, 0];
							_wp3 setWaypointType "GETOUT";
							_wp3 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
							//_group setVariable ["mrkAttack",_mrkDestination];
							//_wp3 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW"",""NOWP3""] execVM ""scripts\UPSMON.sqf"";"];
							_wp0 synchronizeWaypoint [_wp3];
							_wp4 = _group addWaypoint [_posDestination, 1];
							_wp4 setWaypointType "SAD";
							//_wp4 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
							//_wp4 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW"",""NOWP3""] execVM ""scripts\UPSMON.sqf"";"];
							_wp4 = _group addWaypoint [_posDestination, 1];
							//_wp4 setWaypointType "SAD";
							_wp2 = _grupoVeh addWaypoint [_posOrigin, 1];
							_wp2 setWaypointType "MOVE";
							_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
							[_grupoVeh,1] setWaypointBehaviour "AWARE";
							}
						else
							{
							{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoVeh;
							if ((_tipoVeh in vehFastRope) and ((count(garrison getVariable _mrkDestination)) < 10)) then
								{
								//_grupo setVariable ["mrkAttack",_mrkDestination];
								[_veh,_grupo,_posDestination,_posOrigin,_grupoVeh] spawn A3A_fnc_fastrope;
								}
							else
								{
								[_veh,_group,_mrkDestination,_mrkOrigin] spawn A3A_fnc_airdrop;
								}
							};
						};
					};
				};
			sleep 1;
			_pos = [_pos, 80,_ang] call BIS_fnc_relPos;
			_countX = _countX + 1;
			_vehPool = _vehPool select {[_x] call A3A_fnc_vehAvailable};
			};
		};
	_plane = if (_lado == Occupants) then {vehNATOPlane} else {vehCSATPlane};
	if (_lado == Occupants) then
		{
		if (((not(_mrkDestination in outposts)) and (not(_mrkDestination in seaports)) and (_mrkOrigin != "NATO_carrier")) or hasIFA) then
			{
			[_mrkOrigin,_mrkDestination,_lado] spawn A3A_fnc_artillery;
			diag_log "Antistasi: Arty Spawned";
			if (([_plane] call A3A_fnc_vehAvailable) and (not(_mrkDestination in citiesX)) and _firstWave) then
				{
				sleep 60;
				_rnd = if (_mrkDestination in airportsX) then {round random 4} else {round random 2};
				for "_i" from 0 to _rnd do
					{
					if ([_plane] call A3A_fnc_vehAvailable) then
						{
						diag_log "Antistasi: Airstrike Spawned";
						if (_i == 0) then
							{
							if (_mrkDestination in airportsX) then
								{
								_nul = [_mrkDestination,_lado,"HE"] spawn A3A_fnc_airstrike;
								}
							else
								{
								_nul = [_mrkDestination,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn A3A_fnc_airstrike;
								};
							}
						else
							{
							_nul = [_mrkDestination,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn A3A_fnc_airstrike;
							};
						sleep 30;
						};
					};
				};
			};
		}
	else
		{
		if (((not(_mrkDestination in recursos)) and (not(_mrkDestination in puertos)) and (_mrkOrigin != "CSAT_carrier")) or hayIFA) then
			{
			if !(_posOriginLand isEqualTo []) then {[_posOriginLand,_mrkDestination,_lado] spawn A3A_fnc_artillery} else {[_mrkOrigin,_mrkDestination,_lado] spawn A3A_fnc_artillery};
			diag_log "Antistasi: Arty Spawned";
			if (([_plane] call A3A_fnc_vehAvailable) and (_firstWave)) then
				{
				sleep 60;
				_rnd = if (_mrkDestination in airportsX) then {if ({lados getVariable [_x,sideUnknown] == muyMalos} count airportsX == 1) then {8} else {round random 4}} else {round random 2};
				for "_i" from 0 to _rnd do
					{
					if ([_plane] call A3A_fnc_vehAvailable) then
						{
						diag_log "Antistasi: Airstrike Spawned";
						if (_i == 0) then
							{
							if (_mrkDestination in airportsX) then
								{
								_nul = [_mrkDestination,_lado,"HE"] spawn A3A_fnc_airstrike;
								}
							else
								{
								_nul = [_mrkDestination,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn A3A_fnc_airstrike;
								};
							}
						else
							{
							_nul = [_posDestination,_lado,selectRandom ["HE","CLUSTER","NAPALM"]] spawn A3A_fnc_airstrike;
							};
						sleep 30;
						};
					};
				};
			};
		};

	if (!_SDKShown) then
		{
		if !([true] call A3A_fnc_FIAradio) then {sleep 100};
		_SDKShown = true;
		["TaskSucceeded", ["", "Attack Destination Updated"]] remoteExec ["BIS_fnc_showNotification",teamPlayer];
		["AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"CREATED"] call A3A_fnc_taskUpdate;
		};
	_solMax = round ((count _soldados)*0.6);
	_waves = _waves -1;
	_firstWave = false;
	diag_log format ["Antistasi: Reached end of spawning attack, wave %1. Vehicles: %2. Wave Units: %3. Total units: %4 ",_waves, count _vehiclesX, count _soldados, count _soldiersTotal];
	if (lados getVariable [_mrkDestination,sideUnknown] != buenos) then {_soldados spawn A3A_fnc_remoteBattle};
	if (_lado == malos) then
		{
		waitUntil {sleep 5; (({!([_x] call A3A_fnc_canFight)} count _soldados) >= _solMax) or (time > _tiempo) or (lados getVariable [_mrkDestination,sideUnknown] == malos) or (({[_x,_mrkDestination] call A3A_fnc_canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_mrkDestination] call A3A_fnc_canConquer)} count allUnits))};
		if  ((({[_x,_mrkDestination] call A3A_fnc_canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_mrkDestination] call A3A_fnc_canConquer)} count allUnits)) or (lados getVariable [_mrkDestination,sideUnknown] == malos)) then
			{
			_waves = 0;
			if ((!(sidesX getVariable [_mrkDestination,sideUnknown] == Occupants)) and !(_mrkDestination in citiesX)) then {[Occupants,_mrkDestination] remoteExec ["A3A_fnc_markerChange",2]};
			["AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,"FAILED"] call A3A_fnc_taskUpdate;
			["AttackAAF1",[format ["We are attacking an %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"SUCEEDED"] call A3A_fnc_taskUpdate;
			if (_mrkDestination in citiesX) then
				{
				[0,-100,_mrkDestination] remoteExec ["A3A_fnc_citySupportChange",2];
				["TaskFailed", ["", format ["%1 joined %2",[_mrkDestination, false] call A3A_fnc_fn_location,nameOccupants]]] remoteExec ["BIS_fnc_showNotification",teamPlayer];
				sidesX setVariable [_mrkDestination,Occupants,true];
				_nul = [-5,0] remoteExec ["A3A_fnc_prestige",2];
				_mrkD = format ["Dum%1",_mrkDestination];
				_mrkD setMarkerColor colorOccupants;
				garrison setVariable [_mrkDestination,[],true];
				};
			};
		sleep 10;
		if (!(sidesX getVariable [_mrkDestination,sideUnknown] == Occupants)) then
			{
			_timeX = time + 3600;
			if (sidesX getVariable [_mrkOrigin,sideUnknown] == Occupants) then
				{
				_killZones = killZones getVariable [_mrkOrigin,[]];
				_killZones append [_mrkDestination,_mrkDestination,_mrkDestination];
				killZones setVariable [_mrkOrigin,_killZones,true];
				};

			if !(_posOriginLand isEqualTo []) then
				{
				if ({[_x] call A3A_fnc_vehAvailable} count vehNATOAPC == 0) then {_waves = _waves -1};
				if !([vehNATOTank] call A3A_fnc_vehAvailable) then {_waves = _waves - 1};
				};
			if ({[_x] call A3A_fnc_vehAvailable} count vehNATOAttackHelis == 0) then
				{
				if (_posOriginLand isEqualTo []) then {_waves = _waves -2} else {_waves = _waves -1};
				};
			if !([vehNATOPlane] call A3A_fnc_vehAvailable) then
				{
				if (_posOriginLand isEqualTo []) then {_waves = _waves -2} else {_waves = _waves -1};
				};

			if ((_waves <= 0) or (!(sidesX getVariable [_mrkOrigin,sideUnknown] == Occupants))) then
				{
				{_x doMove _posOrigin} forEach _soldiersTotal;
				if (_waves <= 0) then {[_mrkDestination,_mrkOrigin] call A3A_fnc_minefieldAAF};

				["AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,"SUCCEEDED"] call A3A_fnc_taskUpdate;
				["AttackAAF1",[format ["We are attacking an %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"FAILED"] call A3A_fnc_taskUpdate;
				};
			};
		}
	else
		{
		waitUntil {sleep 5; (({!([_x] call A3A_fnc_canFight)} count _soldados) >= _solMax) or (time > _tiempo) or (lados getVariable [_mrkDestination,sideUnknown] == muyMalos) or (({[_x,_mrkDestination] call A3A_fnc_canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_mrkDestination] call A3A_fnc_canConquer)} count allUnits))};
		//diag_log format ["1:%1,2:%2,3:%3,4:%4",(({!([_x] call A3A_fnc_canFight)} count _soldados) >= _solMax),(time > _tiempo),(lados getVariable [_mrkDestination,sideUnknown] == muyMalos),(({[_x,_mrkDestination] call A3A_fnc_canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_mrkDestination] call A3A_fnc_canConquer)} count allUnits))];
		if  ((({[_x,_mrkDestination] call A3A_fnc_canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_mrkDestination] call A3A_fnc_canConquer)} count allUnits)) or (lados getVariable [_mrkDestination,sideUnknown] == muyMalos))  then
			{
			_waves = 0;
			if (not(lados getVariable [_mrkDestination,sideUnknown] == muyMalos)) then {[muyMalos,_mrkDestination] remoteExec ["A3A_fnc_markerChange",2]};
			["AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,"FAILED"] call A3A_fnc_taskUpdate;
			["AttackAAF1",[format ["We are attacking an %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"SUCCEEDED"] call A3A_fnc_taskUpdate;
			};
		sleep 10;
		if (!(lados getVariable [_mrkDestination,sideUnknown] == muyMalos)) then
			{
			_timeX = time + 3600;
			diag_log format ["Antistasi debug wavedCA: Wave number %1 on wavedCA lost",_waves];
			if (lados getVariable [_mrkOrigin,sideUnknown] == muyMalos) then
				{
				_killZones = killZones getVariable [_mrkOrigin,[]];
				_killZones append [_mrkDestination,_mrkDestination,_mrkDestination];
				killZones setVariable [_mrkOrigin,_killZones,true];
				};

			if !(_posOriginLand isEqualTo []) then
				{
				if ({[_x] call A3A_fnc_vehAvailable} count vehCSATAPC == 0) then {_waves = _waves -1};
				if !([vehCSATTank] call A3A_fnc_vehAvailable) then {_waves = _waves - 1};
				};
			if ({[_x] call A3A_fnc_vehAvailable} count vehCSATAttackHelis == 0) then
				{
				if (_posOriginLand isEqualTo []) then {_waves = _waves -2} else {_waves = _waves -1};
				};
			if !([vehCSATPlane] call A3A_fnc_vehAvailable) then
				{
				if (_posOriginLand isEqualTo []) then {_waves = _waves -2} else {_waves = _waves -1};
				};

			if ((_waves <= 0) or (lados getVariable [_mrkOrigin,sideUnknown] != muyMalos)) then
				{
				{_x doMove _posOrigin} forEach _soldiersTotal;
				if (_waves <= 0) then {[_mrkDestination,_mrkOrigin] call A3A_fnc_minefieldAAF};
				["AttackAAF",[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],format ["%1 Attack",_nameENY],_mrkOrigin],getMarkerPos _mrkOrigin,"SUCCEEDED"] call A3A_fnc_taskUpdate;
				["AttackAAF1",[format ["We are attacking an %2 from the %1. Help the operation if you can",_nameOrigin,_nameDest],format ["%1 Attack",_nameENY],_mrkDestination],getMarkerPos _mrkDestination,"FAILED"] call A3A_fnc_taskUpdate;
				};
			};
		};
	};





//_tsk = ["AttackAAF",_sideTsk,[format ["%2 Is attacking from the %1. Intercept them or we may loose a sector",_nameOrigin,_nameENY],"AAF Attack",_mrkOrigin],getMarkerPos _mrkOrigin,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
if (_isSDK) then
	{
	if (!(sidesX getVariable [_mrkDestination,sideUnknown] == teamPlayer)) then
		{
		[-10,theBoss] call A3A_fnc_playerScoreAdd;
		}
	else
		{
		{if (isPlayer _x) then {[10,_x] call A3A_fnc_playerScoreAdd}} forEach ([500,0,_posDestination,teamPlayer] call A3A_fnc_distanceUnits);
		[5,theBoss] call A3A_fnc_playerScoreAdd;
		};
	};
diag_log "Antistasi: Reached end of winning conditions. Starting despawn";
sleep 30;
_nul = [0,"AttackAAF"] spawn A3A_fnc_deleteTask;
_nul = [0,"AttackAAF1"] spawn A3A_fnc_deleteTask;

[_mrkOrigin,60] call A3A_fnc_addTimeForIdle;
bigAttackInProgress = false; publicVariable "bigAttackInProgress";
//forcedSpawn = forcedSpawn - _forced; publicVariable "forcedSpawn";
forcedSpawn = forcedSpawn - [_mrkDestination]; publicVariable "forcedSpawn";
[3600] remoteExec ["A3A_fnc_timingCA",2];

{
_veh = _x;
if (!([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x; _pilots = _pilots - [_x]};
} forEach _pilots;
{
_veh = _x;
if (!([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x};
} forEach _vehiclesX;
{
_veh = _x;
if (!([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x; _soldiersTotal = _soldiersTotal - [_x]};
} forEach _soldiersTotal;

if (count _pilots > 0) then
	{
	{
	[_x] spawn
		{
		private ["_veh"];
		_veh = _this select 0;
		waitUntil {sleep 1; !([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
		deleteVehicle _veh;
		};
	} forEach _pilots;
	};

if (count _soldiersTotal > 0) then
	{
	{
	[_x] spawn
		{
		private ["_veh"];
		_veh = _this select 0;
		waitUntil {sleep 1; !([distanceSPWN,1,_veh,teamPlayer] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
		deleteVehicle _veh;
		};
	} forEach _soldiersTotal;
	};


{deleteGroup _x} forEach _grupos;
diag_log "Antistasi Waved CA: Despawn completed";
