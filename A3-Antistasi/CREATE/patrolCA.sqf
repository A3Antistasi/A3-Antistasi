if (!isServer and hasInterface) exitWith {};

private ["_marcador","_esMarcador","_exit","_radio","_base","_aeropuerto","_posDestino","_soldados","_vehiculos","_grupos","_roads","_posorigen","_tam","_tipoVeh","_vehicle","_veh","_vehCrew","_grupoVeh","_landPos","_tipoGrupo","_grupo","_soldado","_threatEval","_pos","_timeOut","_lado","_cuenta","_esMarcador","_inWaves","_posOrigen","_typeOfAttack","_cercano","_aeropuertos","_sitio","_enemigos","_plane","_amigos","_tipo","_esSDK","_weapons","_nombreDest","_vehPool","_super"];

_marcador = _this select 0;
_aeropuerto = _this select 1;
_typeOfAttack = _this select 2;
_super = if (!isMultiplayer) then {false} else {_this select 3};
_inWaves = false;
_lado = malos;
_posOrigen = [];
if ([_marcador,false] call fogCheck < 0.3) exitWith {diag_log format ["Antistasi PatrolCA: Attack on %1 exit because of heavy fog",_marcador]};
if (_aeropuerto isEqualType "") then
	{
	_inWaves = true;
	if (lados getVariable [_aeropuerto,sideUnknown] == muyMalos) then {_lado = muyMalos};
	_posOrigen = getMarkerPos _aeropuerto;
	}
else
	{
	_lado = _aeropuerto;
	};

//if ((!_inWaves) and (diag_fps < minimoFPS)) exitWith {diag_log format ["Antistasi PatrolCA: CA cancelled because of FPS %1",""]};

_esMarcador = false;
_exit = false;
if (_marcador isEqualType "") then
	{
	_esMarcador = true;
	if (!_inWaves) then {if (_marcador in smallCAmrk) then {_exit = true}};
	}
else
	{
	_cercano = [smallCApos,_marcador] call BIS_fnc_nearestPosition;
	if (_cercano distance _marcador < (distanciaSPWN2)) then
		{
		_exit = true;
		}
	else
		{
		if (count smallCAmrk > 0) then
			{
			_cercano = [smallCAmrk,_marcador] call BIS_fnc_nearestPosition;
			if (getMarkerPos _cercano distance _marcador < (distanciaSPWN2)) then {_exit = true};
			};
		};
	};

if (_exit) exitWith {diag_log format ["Antistasi PatrolCA: CA cancelled because of other CA in vincity of %1",_marcador]};

_posDestino = if (!_esMarcador) then {_marcador} else {getMarkerPos _marcador};

if (!_inWaves) then
	{
	_aeropuertos = aeropuertos select {lados getVariable [_x,sideUnknown] == _lado};
	_aeropuertos = _aeropuertos select 	{(getMarkerPos _x distance _posDestino < distanceForAirAttack) and  !([distanciaSPWN/2,1,getMarkerPos _x,"GREENFORSpawn"] call distanceUnits) and (dateToNumber date > server getVariable _x)};
	if (_esMarcador) then
		{
		_aeropuertos = _aeropuertos select {({_x == _marcador} count (killZones getVariable [_x,[]])) < 3};
		}
	else
		{
		if (_typeOfAttack == "Normal") then
			{
			if (!_super) then
				{
				_puestos = puestos select {lados getVariable [_x,sideUnknown] == _lado};
				_aeropuertos = _aeropuertos + (_puestos select 	{(getMarkerPos _x distance _posDestino < distanceForLandAttack)  and !([distanciaSPWN/2,1,getMarkerPos _x,"GREENFORSpawn"] call distanceUnits) and (dateToNumber date > server getVariable _x)});
				};
			};
		if (!_super) then
			{
			_sitio = [(recursos + fabricas + aeropuertos + puestos + puertos),_marcador] call BIS_fnc_nearestPosition;
			_aeropuertos = _aeropuertos select {({_x == _sitio} count (killZones getVariable [_x,[]])) < 3};
			};
		};
	if (count _aeropuertos == 0) then
		{
		_exit = true;
		}
	else
		{
		_aeropuerto = [_aeropuertos,_posDestino] call BIS_fnc_nearestPosition;
		_posOrigen = getMarkerPos _aeropuerto;
		};
	};

if (_exit) exitWith {diag_log format ["Antistasi PatrolCA: CA cancelled because no available base (distance, not spawned, busy, killzone) to attack %1",_marcador]};

_base = if ((_posOrigen distance _posDestino < distanceForLandAttack) and ([_posDestino,_posOrigen] call isTheSameIsland)) then {_aeropuerto} else {""};

if ((_base != "") and (_esMarcador)) then {if (_marcador in blackListDest) then {_base == ""}};

_enemigos = if (_lado == malos) then {allUnits select {_x distance _posDestino < distanciaSPWN2 and (side _x != _lado) and (side _x != civilian) and (alive _x)}} else {allUnits select {_x distance _posDestino < distanciaSPWN2 and (side _x != _lado) and (alive _x)}};

if ((_base == "") and (!_esMarcador) and (_typeOfAttack != "Air") and (!_super)) then
	{
	_plane = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane};
	if ([_plane] call vehAvailable) then
		{
		_amigos = allUnits select {(_x distance _posDestino < 300) and (alive _x) and (side _x == _lado)};
		if (count _amigos == 0) then
			{
			_tipo = "NAPALM";
			{
			if (vehicle _x isKindOf "Tank") then
				{
				_tipo = "HE"
				}
			else
				{
				if (vehicle _x != _x) then {_tipo = "CLUSTER"};
				};
			if (_tipo == "HE") exitWith {};
			} forEach _enemigos;
			_exit = true;
			if (!_esMarcador) then {smallCApos pushBack _marcador};
			[_posDestino,_lado,_tipo] spawn airStrike;
			if (debug) then {hint format ["Bombardeo de %1 en %2 por los %3",_tipo,_posDestino,_lado]};
			diag_log format ["Antistasi PatrolCA: Airstrike of type %1 sent to %2",_tipo,_marcador];
			if (!_esMarcador) then
				{
				sleep 120;
				smallCApos = smallCApos - [_marcador];
				};
			diag_log format ["Antistasi PatrolCA: CA resolved on airstrike %1",_marcador]
			};
		};
	};

if (_exit) exitWith {};

if (_typeOfAttack == "") then
	{
	_typeOfAttack = "Normal";
	{
	_exit = false;
	if (vehicle _x != _x) then
		{
		_veh = vehicle _x;
		if (_veh isKindOf "Plane") exitWith {_exit = true; _typeOfAttack = "Air"};
		if (_veh isKindOf "Helicopter") then
			{
			_weapons = getArray (configfile >> "CfgVehicles" >> (typeOf _veh) >> "weapons");
			if (_weapons isEqualType []) then
				{
				if (count _weapons > 1) then {_exit = true; _typeOfAttack = "Air"};
				};
			}
		else
			{
			if (_veh isKindOf "Tank") then {_typeOfAttack = "Tank"};
			};
		};
	if (_exit) exitWith {};
	} forEach _enemigos;
	};
if (_base != "") then
	{
	_threatEval = [_posDestino] call landThreatEval;
	if (_threatEval > 15) then
		{
		_base = "";
		}
	};
_esSDK = false;
if (_esMarcador) then
	{
	smallCAmrk pushBackUnique _marcador; publicVariable "smallCAmrk";
	if (lados getVariable [_marcador,sideUnknown] == buenos) then
		{
		_esSDK = true;
		_nombreDest = [_marcador] call localizar;
		if (!_inWaves) then {["IntelAdded", ["", format ["QRF sent to %1",_nombreDest]]] remoteExec ["BIS_fnc_showNotification",_lado]};
		}
	else
		{
		forcedSpawn pushBackUnique _marcador; publicVariable "forcedSpawn";
		};
	}
else
	{
	smallCApos pushBack _marcador;
	};

//if (debug) then {hint format ["Nos contraatacan desde %1 o desde el aeropuerto %2 hacia %3", _base, _aeropuerto,_marcador]; sleep 5};
diag_log format ["Antistasi PatrolCA: CA performed from %1 or %2 to %3",_base,_aeropuerto,_marcador];
//_config = if (_lado == malos) then {cfgNATOInf} else {cfgCSATInf};

_soldados = [];
_vehiculos = [];
_grupos = [];
_roads = [];

if (_base != "") then
	{
	_aeropuerto = "";

	if ((!_inWaves) and (!_super)) then {[_base,20] call addTimeForIdle};
	_indice = aeropuertos find _base;
	_spawnPoint = objNull;
	_pos = [];
	_dir = 0;
	if (_indice > -1) then
		{
		_spawnPoint = spawnPoints select _indice;
		_pos = getMarkerPos _spawnPoint;
		_dir = markerDir _spawnPoint;
		}
	else
		{
		_spawnPoint = [_posOrigen] call findNearestGoodRoad;
		_pos = position _spawnPoint;
		_dir = getDir _spawnPoint;
		};

	_vehPool = if (_lado == malos) then {vehNATOAttack select {[_x] call vehAvailable}} else {vehCSATAttack select {[_x] call vehAvailable}};
	_road = [_posDestino] call findNearestGoodRoad;
	if ((position _road) distance _posDestino > 150) then {_vehPool = _vehPool - vehTanks};
	if (count _vehPool == 0) then {if (_lado == malos) then {_vehPool = vehNATOTrucks} else {_vehPool = vehCSATTrucks}};
	_cuenta = if (!_super) then {if (_esMarcador) then {2} else {1}} else {round (tierWar / 2) + 1};
	_landPosBlacklist = [];
	for "_i" from 1 to _cuenta do
		{
		_tipoVeh = if (_i == 1) then
						{
						if (_typeOfAttack == "Normal") then
							{
							selectRandom _vehPool
							}
						else
							{
							if (_typeOfAttack == "Air") then
								{
								if (_lado == malos) then {if ([vehNATOAA] call vehAvailable) then {vehNATOAA} else {selectRandom _vehPool}} else {if ([vehCSATAA] call vehAvailable) then {vehCSATAA} else {selectRandom _vehPool}};
								}
							else
								{
								if (_lado == malos) then {if ([vehNATOTank] call vehAvailable) then {vehNATOTank} else {selectRandom _vehPool}} else {if ([vehCSATTank] call vehAvailable) then {vehCSATTank} else {selectRandom _vehPool}};
								};
							};
						}
					else
						{
						if (_esMarcador) then {selectRandom (_vehPool - vehTanks)} else {selectRandom _vehPool};
						};
		//_road = _roads select 0;
		_timeOut = 0;
		_pos = _pos findEmptyPosition [0,100,_tipoVeh];
		while {_timeOut < 60} do
			{
			if (count _pos > 0) exitWith {};
			_timeOut = _timeOut + 1;
			_pos = _pos findEmptyPosition [0,100,_tipoVeh];
			sleep 1;
			};
		if (count _pos == 0) then {_pos = if (_indice == -1) then {getMarkerPos _spawnPoint} else {position _spawnPoint}};
		_vehicle=[_pos, _dir,_tipoveh, _lado] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		{[_x] call NATOinit} forEach _vehCrew;
		[_veh] call AIVEHinit;
		_grupoVeh = _vehicle select 2;
		_soldados = _soldados + _vehCrew;
		_grupos pushBack _grupoVeh;
		_vehiculos pushBack _veh;
		_landPos = [_posDestino,_pos,false,_landPosBlacklist] call findSafeRoadToUnload;
		if ((not(_tipoVeh in vehTanks)) and (not(_tipoVeh in vehAA))) then
			{
			_landPosBlacklist pushBack _landPos;
			_tipogrupo = if (_typeOfAttack == "Normal") then
				{
				[_tipoVeh,_lado] call cargoSeats;
				}
			else
				{
				if (_typeOfAttack == "Air") then
					{
					if (_lado == malos) then {gruposNATOAA} else {gruposCSATAA}
					}
				else
					{
					if (_lado == malos) then {gruposNATOAT} else {gruposCSATAT}
					};
				};
			_grupo = [_posorigen,_lado,_tipogrupo] call spawnGroup;
			//{_x assignAsCargo _veh;_x moveInCargo _veh; [_x] call NATOinit;_soldados pushBack _x; _x setVariable ["origen",_base]} forEach units _grupo;
			{
			_x assignAsCargo _veh;
			_x moveInCargo _veh;
			if (vehicle _x == _veh) then
				{
				_soldados pushBack _x;
				[_x] call NATOinit;
				_x setVariable ["origen",_base];
				}
			else
				{
				deleteVehicle _x;
				};
			} forEach units _grupo;
			if (not(_tipoVeh in vehTrucks)) then
				{
				(units _grupo) joinSilent _grupoVeh;
				deleteGroup _grupo;
				//_grupos pushBack _grupo;
				[_base,_landPos,_grupoVeh] call WPCreate;
				_Vwp0 = (wayPoints _grupoVeh) select 0;
				_Vwp0 setWaypointBehaviour "SAFE";
				_Vwp0 = _grupoVeh addWaypoint [_landPos,count (wayPoints _grupoVeh)];
				_Vwp0 setWaypointType "TR UNLOAD";
				//_Vwp0 setWaypointStatements ["true", "[vehicle this] call smokeCoverAuto"];
				_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
				_Vwp1 setWaypointType "SAD";
				_Vwp1 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				_Vwp1 setWaypointBehaviour "COMBAT";
				/*_Vwp2 = _grupo addWaypoint [_landPos, 0];
				_Vwp2 setWaypointType "GETOUT";
				_Vwp0 synchronizeWaypoint [_Vwp2];
				_Vwp3 = _grupo addWaypoint [_posDestino, count (wayPoints _grupo)];
				_Vwp3 setWaypointType "MOVE";*//*
				if (_esMarcador) then
					{
					_grupo setVariable ["mrkAttack",_marcador];
					_Vwp3 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW"",""NOWP3""] execVM ""scripts\UPSMON.sqf"";"];
					};*/
				//_Vwp3 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				//_Vwp3 = _grupo addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
				//_Vwp3 setWaypointType "SAD";
				//[_veh,"APC"] spawn inmuneConvoy;
				_veh allowCrewInImmobile true;
				}
			else
				{
				//{[_x] joinSilent _grupoVeh} forEach units _grupo;
				(units _grupo) joinSilent _grupoVeh;
				deleteGroup _grupo;
				//_veh forceFollowRoad true;

				_grupoVeh selectLeader (units _grupoVeh select 1);
				[_base,_landPos,_grupoVeh] call WPCreate;
				_Vwp0 = (wayPoints _grupoVeh) select 0;
				_Vwp0 setWaypointBehaviour "SAFE";
				/*
				_Vwp0 = (wayPoints _grupoVeh) select ((count wayPoints _grupoVeh) - 1);
				_Vwp0 setWaypointType "GETOUT";
				*/
				_Vwp0 = _grupoVeh addWaypoint [_landPos, count (wayPoints _grupoVeh)];
				_Vwp0 setWaypointType "GETOUT";
				_Vwp1 = _grupoVeh addWaypoint [_posDestino, count (wayPoints _grupoVeh)];
				if (_esMarcador) then
					{
					//_grupoVeh setVariable ["mrkAttack",_marcador];
					//_Vwp1 setWaypointStatements ["true","nul = [this, (group this getVariable ""mrkAttack""), ""SPAWNED"",""NOVEH2"",""NOFOLLOW"",""NOWP3""] execVM ""scripts\UPSMON.sqf"";"];
					if ((count (garrison getVariable _marcador)) < 4) then
						{
						_Vwp1 setWaypointType "MOVE";
						_Vwp1 setWaypointBehaviour "AWARE";
						}
					else
						{
						_Vwp1 setWaypointType "SAD";
						_Vwp1 setWaypointBehaviour "COMBAT";
						};
					}
				else
					{
					_Vwp1 setWaypointType "SAD";
					_Vwp1 setWaypointBehaviour "COMBAT";
					};
				//[_veh,"Inf Truck."] spawn inmuneConvoy;
				};
			}
		else
			{
			[_base,_posDestino,_grupoVeh] call WPCreate;
			_Vwp0 = (wayPoints _grupoVeh) select 0;
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 = _grupoVeh addWaypoint [_posDestino, count (waypoints _grupoVeh)];
			[_veh,"Tank"] spawn inmuneConvoy;
			_Vwp0 setWaypointType "SAD";
			_Vwp0 setWaypointBehaviour "AWARE";
			_veh allowCrewInImmobile true;
			};
		};
	diag_log format ["Antistasi PatrolCA: Land CA performed on %1, Type is %2, Vehicle count: %3, Soldier count: %4",_marcador,_typeOfAttack,count _vehiculos,count _soldados];
	};
if (_aeropuerto != "") then
	{
	if ((!_inWaves) and (!_super)) then {[_aeropuerto,20] call addTimeForIdle};
	_vehPool = [];
	_cuenta = if (!_super) then {if (_esMarcador) then {2} else {1}} else {round (tierWar / 2) + 1};
	_tipoVeh = "";
	_vehPool = if (_lado == malos) then {(vehNATOAir - [vehNATOPlane]) select {[_x] call vehAvailable}} else {(vehCSATAir - [vehCSATPlane]) select {[_x] call vehAvailable}};
	for "_i" from 1 to _cuenta do
		{
		_tipoVeh = if (_i == 1) then
				{
				if (_typeOfAttack == "Normal") then
					{
					selectRandom _vehPool
					}
				else
					{
					if (_lado == malos) then {if ([vehNATOPlaneAA] call vehAvailable) then {vehNATOPlaneAA} else {selectRandom _vehPool}} else {if ([vehCSATPlaneAA] call vehAvailable) then {vehCSATPlaneAA} else {selectRandom _vehPool}};
					};
				}
			else
				{
				if (_esMarcador) then {selectRandom (_vehPool - vehFixedWing)} else {selectRandom _vehPool};
				};

		_pos = _posOrigen;
		_ang = 0;
		_size = [_aeropuerto] call sizeMarker;
		_buildings = nearestObjects [_posOrigen, ["Land_LandMark_F","Land_runway_edgelight"], _size / 2];
		if (count _buildings > 1) then
			{
			_pos1 = getPos (_buildings select 0);
			_pos2 = getPos (_buildings select 1);
			_ang = [_pos1, _pos2] call BIS_fnc_DirTo;
			_pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
			};
		if (count _pos == 0) then {_pos = _posorigen};
		_vehicle=[_pos, _ang + 90,_tipoVeh, _LADO] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		_grupoVeh = _vehicle select 2;
		_soldados append _vehCrew;
		_grupos pushBack _grupoVeh;
		_vehiculos pushBack _veh;
		{[_x] call NATOinit} forEach units _grupoVeh;
		[_veh] call AIVEHinit;
		if (not (_tipoVeh in vehTransportAir)) then
			{
			_Hwp0 = _grupoVeh addWaypoint [_posdestino, 0];
			_Hwp0 setWaypointBehaviour "AWARE";
			_Hwp0 setWaypointType "SAD";
			//[_veh,"Air Attack"] spawn inmuneConvoy;
			}
		else
			{
			_tipogrupo = if (_typeOfAttack == "Normal") then
				{
				[_tipoVeh,_lado] call cargoSeats;
				}
			else
				{
				if (_typeOfAttack == "Air") then
					{
					if (_lado == malos) then {gruposNATOAA} else {gruposCSATAA}
					}
				else
					{
					if (_lado == malos) then {gruposNATOAT} else {gruposCSATAT}
					};
				};
			_grupo = [_posorigen,_lado,_tipogrupo] call spawnGroup;
			//{_x assignAsCargo _veh;_x moveInCargo _veh; [_x] call NATOinit;_soldados pushBack _x;_x setVariable ["origen",_aeropuerto]} forEach units _grupo;
			{
			_x assignAsCargo _veh;
			_x moveInCargo _veh;
			if (vehicle _x == _veh) then
				{
				_soldados pushBack _x;
				[_x] call NATOinit;
				_x setVariable ["origen",_aeropuerto];
				}
			else
				{
				deleteVehicle _x;
				};
			} forEach units _grupo;
			_grupos pushBack _grupo;
			_landpos = [];
			_proceder = true;
			if (_esMarcador) then
				{
				if ((_marcador in aeropuertos)  or !(_veh isKindOf "Helicopter")) then
					{
					_proceder = false;
					[_veh,_grupo,_marcador,_aeropuerto] spawn airdrop;
					}
				else
					{
					if (_esSDK) then
						{
						if (((count(garrison getVariable [_marcador,[]])) < 10) and (_tipoVeh in vehFastRope)) then
							{
							_proceder = false;
							//_grupo setVariable ["mrkAttack",_marcador];
							[_veh,_grupo,_posDestino,_posOrigen,_grupoVeh] spawn fastrope;
							};
						};
					};
				};
			if (_proceder) then
				{
				_landPos = [_posDestino, 200, 350, 10, 0, 0.20, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
				if !(_landPos isEqualTo [0,0,0]) then
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
						[_veh,_grupo,_marcador,_aeropuerto] spawn airdrop;
						};
					};
				};
			};
		sleep 30;
		};
	diag_log format ["Antistasi PatrolCA: Air CA performed on %1, Type is %2, Vehicle count: %3, Soldier count: %4",_marcador,_typeOfAttack,count _vehiculos,count _soldados];
	};

if (_esMarcador) then
	{
	_tiempo = time + 3600;
	_size = [_marcador] call sizeMarker;
	if (_lado == malos) then
		{
		waitUntil {sleep 5; (({!([_x] call canFight)} count _soldados) >= 3*({([_x] call canFight)} count _soldados)) or (time > _tiempo) or (lados getVariable [_marcador,sideUnknown] == malos) or (({[_x,_marcador] call canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_marcador] call canConquer)} count allUnits))};
		if  ((({[_x,_marcador] call canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_marcador] call canConquer)} count allUnits)) and (not(lados getVariable [_marcador,sideUnknown] == malos))) then
			{
			["BLUFORSpawn",_marcador] remoteExec ["markerChange",2];
			diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to retake %3 succesful. Retaken.",_aeropuerto,_base,_marcador];
			};
		sleep 10;
		if (!(lados getVariable [_marcador,sideUnknown] == malos)) then
			{
			{_x doMove _posorigen} forEach _soldados;
			if (lados getVariable [_aeropuerto,sideUnknown] == malos) then
				{
				_killZones = killZones getVariable [_aeropuerto,[]];
				_killZones = _killZones + [_marcador,_marcador];
				killZones setVariable [_aeropuerto,_killZones,true];
				};
			diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to retake %3 failed",_aeropuerto,_base,_marcador];
			}
		}
	else
		{
		waitUntil {sleep 5; (({!([_x] call canFight)} count _soldados) >= 3*({([_x] call canFight)} count _soldados))or (time > _tiempo) or (lados getVariable [_marcador,sideUnknown] == muyMalos) or (({[_x,_marcador] call canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_marcador] call canConquer)} count allUnits))};
		if  ((({[_x,_marcador] call canConquer} count _soldados) > 3*({(side _x != _lado) and (side _x != civilian) and ([_x,_marcador] call canConquer)} count allUnits)) and (not(lados getVariable [_marcador,sideUnknown] == muyMalos))) then
			{
			["OPFORSpawn",_marcador] remoteExec ["markerChange",2];
			diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to retake %3 succesful. Retaken.",_aeropuerto,_base,_marcador];
			};
		sleep 10;
		if (!(lados getVariable [_marcador,sideUnknown] == muyMalos)) then
			{
			{_x doMove _posorigen} forEach _soldados;
			if (lados getVariable [_aeropuerto,sideUnknown] == muyMalos) then
				{
				_killZones = killZones getVariable [_aeropuerto,[]];
				_killZones = _killZones + [_marcador,_marcador];
				killZones setVariable [_aeropuerto,_killZones,true];
				};
			diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to retake %3 failed",_aeropuerto,_base,_marcador];
			}
	};

	smallCAmrk = smallCAmrk - [_marcador]; publicVariable "smallCAmrk";
	waitUntil {sleep 1; (spawner getVariable _marcador == 2)};
	}
else
	{
	_ladoENY = if (_lado == malos) then {"OPFORSpawn"} else {"BLUFORSpawn"};
	if (_typeOfAttack != "Air") then {waitUntil {sleep 1; (!([distanciaSPWN1,1,_posDestino,"GREENFORSpawn"] call distanceUnits) and !([distanciaSPWN1,1,_posDestino,_ladoENY] call distanceUnits)) or (({!([_x] call canFight)} count _soldados) >= 3*({([_x] call canFight)} count _soldados))}} else {waitUntil {sleep 1; (({!([_x] call canFight)} count _soldados) >= 3*({([_x] call canFight)} count _soldados))}};
	if (({!([_x] call canFight)} count _soldados) >= 3*({([_x] call canFight)} count _soldados)) then
		{
		_marcadores = recursos + fabricas + aeropuertos + puestos + puertos select {getMarkerPos _x distance _posDestino < distanciaSPWN};
		_sitio = if (_base != "") then {_base} else {_aeropuerto};
		_killZones = killZones getVariable [_sitio,[]];
		_killZones append _marcadores;
		killZones setVariable [_sitio,_killZones,true];
		diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to %3 failed",_aeropuerto,_base,_marcador];
		};
	diag_log format ["Antistasi Debug patrolCA: Attack from %1 or %2 to %3 despawned",_aeropuerto,_base,_marcador];
	smallCApos = smallCApos - [_marcador];
	};
diag_log format ["Antistasi PatrolCA: CA on %1 finished",_marcador];

if (_marcador in forcedSpawn) then {forcedSpawn = forcedSpawn - [_marcador]; publicVariable "forcedSpawn"};

{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x};
} forEach _vehiculos;
{
_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x; _soldados = _soldados - [_x]};
} forEach _soldados;

if (count _soldados > 0) then
	{
	{
	[_x] spawn
		{
		private ["_veh"];
		_veh = _this select 0;
		waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
		deleteVehicle _veh;
		};
	} forEach _soldados;
	};

{deleteGroup _x} forEach _grupos;
