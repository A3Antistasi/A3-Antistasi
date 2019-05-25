private ["_mrkDestination","_mrkOrigin","_numero","_lado","_typeGroup","_tipoVeh","_indice","_spawnPoint","_pos","_timeOut","_veh","_grupo","_landPos","_Vwp0","_posOrigin","_land","_pos1","_pos2"];

_mrkDestination = _this select 0;
_mrkOrigin = _this select 1;
_numero = _this select 2;
_lado = _this select 3;
diag_log format ["Antistasi. PatrolReinf. Dest:%1, Orig:%2, Size:%3, Side: %4",_mrkDestination,_mrkOrigin,_numero,_lado];
_posDestination = getMarkerPos _mrkDestination;
_posOrigin = getMarkerPos _mrkOrigin;

_land = if (_posOrigin distance _posDestination > distanceForLandAttack) then {false} else {true};
_typeGroup = if (_lado == malos) then {if (_numero == 4) then {selectRandom groupsNATOmid} else {selectRandom groupsNATOSquad}} else {if (_numero == 4) then {selectRandom groupsCSATmid} else {selectRandom groupsCSATSquad}};
_tipoVeh = "";
if (_land) then
	{
	if (_lado == malos) then {_tipoVeh = selectRandom vehNATOTrucks} else {_tipoVeh = selectRandom vehCSATTrucks};
	}
else
	{
	_vehPool = if (_lado == malos) then {vehNATOTransportHelis} else {vehCSATTransportHelis};
	if ((_numero > 4) and (count _vehPool > 1) and !hayIFA) then {_vehPool = _vehPool - [vehNATOPatrolHeli,vehCSATPatrolHeli]};
	//_vehPool = _vehPool select {(_x isKindOf "Helicopter") and (_x in vehFastRope)};
	_tipoVeh = selectRandom _vehPool;
	};

_pos = [];
_veh = objNull;
_grupo = grpNull;

if (_land) then
	{
	_indice = airportsX find _mrkOrigin;
	_spawnPoint = spawnPoints select _indice;
	_pos = getMarkerPos _spawnPoint;
	_timeOut = 0;
	_pos = _pos findEmptyPosition [0,100,_tipoVeh];
	while {_timeOut < 60} do
		{
		if (count _pos > 0) exitWith {};
		_timeOut = _timeOut + 1;
		_pos = _pos findEmptyPosition [0,100,_tipoveh];
		sleep 1;
		};
	if (count _pos == 0) then {_pos = getMarkerPos _spawnPoint};
	_veh = _tipoVeh createVehicle _pos;
	_veh setDir (markerDir _spawnPoint);
	_grupo = [_pos,_lado, _typeGroup] call A3A_fnc_spawnGroup;
	_grupo addVehicle _veh;
	{
	if (_x == leader _x) then {_x assignAsDriver _veh;_x moveInDriver _veh} else {_x assignAsCargo _veh;_x moveInCargo _veh};

	if (vehicle _x == _x) then
		{
		deleteVehicle _x;
		}
	else
		{
		[_x] call A3A_fnc_NATOinit;
		};
	} forEach units _grupo;
	[_veh] call A3A_fnc_AIVEHinit;
	[_veh,"Inf Truck."] spawn A3A_fnc_inmuneConvoy;
	_grupo spawn A3A_fnc_attackDrillAI;
	[_mrkOrigin,_posDestination,_grupo] call WPCreate;
	_Vwp0 = (wayPoints _grupo) select 0;
	_Vwp0 setWaypointBehaviour "SAFE";
	_Vwp0 = _grupo addWaypoint [_posDestination, count (wayPoints _grupo)];
	_Vwp0 setWaypointType "GETOUT";
	_Vwp0 setWaypointStatements ["true","nul = [(thisList select {alive _x}),side this,(group this) getVariable [""reinfMarker"",""""],0] remoteExec [""A3A_fnc_garrisonUpdate"",2];[group this] spawn A3A_fnc_groupDespawner; reinfPatrols = reinfPatrols - 1; publicVariable ""reinfPatrols"";"];
	}
else
	{
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
	if (count _pos == 0) then {_pos = _posOrigin};

	_vehicle=[_pos, _ang + 90,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	_vehCrew = _vehicle select 1;
	_grupoVeh = _vehicle select 2;
	{
	[_x] call A3A_fnc_NATOinit;
	_x addEventHandler ["Killed",{deleteVehicle (group (_this select 0) getVariable ["myPad",objNull])}];
	} forEach units _grupoVeh;
	[_veh] call A3A_fnc_AIVEHinit;

	_grupo = [_posOrigin,_lado,_typeGroup] call A3A_fnc_spawnGroup;
	{
	_x assignAsCargo _veh;
	_x moveInCargo _veh;
	if (vehicle _x == _x) then
		{
		deleteVehicle _x;
		}
	else
		{
		[_x] call A3A_fnc_NATOinit;
		};
	} forEach units _grupo;
	_landPos = if (_tipoVeh isKindOf "Helicopter") then {[_posDestination, 0, 300, 10, 0, 0.20, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos} else {[0,0,0]};
	if !(_landPos isEqualTo [0,0,0]) then
		{
		_landPos set [2, 0];
		_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
		_grupoVeh setVariable ["myPad",_pad];
		_wp0 = _grupoVeh addWaypoint [_landpos, 0];
		_wp0 setWaypointType "TR UNLOAD";
		_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';deleteVehicle ((group this) getVariable [""myPad"",objNull])"];
		_wp0 setWaypointBehaviour "CARELESS";
		_wp3 = _grupo addWaypoint [_landpos, 0];
		_wp3 setWaypointType "GETOUT";
		_wp3 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
		_wp0 synchronizeWaypoint [_wp3];
		_wp4 = _grupo addWaypoint [_posDestination, 1];
		_wp4 setWaypointType "MOVE";
		_wp4 setWaypointStatements ["true","nul = [(thisList select {alive _x}),side this,(group this) getVariable [""reinfMarker"",""""],0] remoteExec [""A3A_fnc_garrisonUpdate"",2];[group this] spawn A3A_fnc_groupDespawner; reinfPatrols = reinfPatrols - 1; publicVariable ""reinfPatrols"";"];
		_wp2 = _grupoVeh addWaypoint [_posOrigin, 1];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
		[_grupoVeh,1] setWaypointBehaviour "AWARE";
		}
	else
		{
		if (_tipoVeh in vehFastRope) then
			{
			[_veh,_grupo,_posDestination,_posOrigin,_grupoVeh,true] spawn A3A_fnc_fastrope;
			}
		else
			{
			[_veh,_grupo,_posDestination,_mrkOrigin,true] spawn A3A_fnc_airdrop;
			};
		};
	};

reinfPatrols = reinfPatrols + 1; publicVariable "reinfPatrols";
_grupo setVariable ["reinfMarker",_mrkDestination];
_grupo setVariable ["origen",_mrkOrigin];
{
_x addEventHandler ["Killed",
	{
	_unit = _this select 0;
	_grupo = group _unit;
	if ({alive _x} count units _grupo == 0) then
		{
		reinfPatrols = reinfPatrols - 1; publicVariable "reinfPatrols";
		_origen = _grupo getVariable "origen";
		_destino = _grupo getVariable "reinfMarker";
		if (((lados getVariable [_origen,sideUnknown] == malos) and (lados getVariable [_destino,sideUnknown] == malos)) or ((lados getVariable [_origen,sideUnknown] == muyMalos) and (lados getVariable [_destino,sideUnknown] == muyMalos))) then
			{
			_killzones = killZones getVariable [_origen,[]];
			_killzones pushBack _destino;
			killZones setVariable [_origen,_killzones,true];
			}
		};
	}];
} forEach units _grupo;
