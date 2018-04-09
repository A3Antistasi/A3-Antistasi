private ["_mrkDestino","_mrkOrigen","_numero","_lado","_tipoGrupo","_tipoVeh","_indice","_spawnPoint","_pos","_timeOut","_veh","_grupo","_landPos","_Vwp0"];

_mrkDestino = _this select 0;
_mrkOrigen = _this select 1;
_numero = _this select 2;
_lado = _this select 3;
diag_log format ["Antistasi. PatrolReinf. Dest:%1, Orig:%2, Size:%3, Side: %4",_mrkDestino,_mrkOrigen,_numero,_lado];
_posDestino = getMarkerPos _mrkDestino;
_tipoGrupo = if (_lado == malos) then {if (_numero == 4) then {selectRandom gruposNATOmid} else {selectRandom gruposNATOSquad}} else {if (_numero == 4) then {selectRandom gruposCSATmid} else {selectRandom gruposCSATSquad}};
_tipoVeh = if (_lado == malos) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
_indice = aeropuertos find _mrkOrigen;
_spawnPoint = spawnPoints select _indice;
_pos = getMarkerPos _spawnPoint;
_timeOut = 0;
_pos = _pos findEmptyPosition [0,100,_tipoVeh];
reinfPatrols = reinfPatrols + 1;
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
_grupo = [_pos,_lado, _tipoGrupo] call spawnGroup;
_grupo addVehicle _veh;
{
if (_x == leader _x) then {_x assignAsDriver _veh;_x moveInDriver _veh} else {_x assignAsCargo _veh;_x moveInCargo _veh};
[_x] call NATOinit
} forEach units _grupo;
[_veh] call AIVEHinit;
[_veh,"Inf Truck."] spawn inmuneConvoy;
//_veh forceFollowRoad true;
//_landPos = [_posDestino,_pos,true] call findSafeRoadToUnload;
if ((_mrkOrigen == "airport") or (_mrkOrigen == "airport_2")) then {[_mrkOrigen,_posDestino,_grupo] call WPCreate};
_Vwp0 = (wayPoints _grupo) select 0;
_Vwp0 setWaypointBehaviour "SAFE";
_Vwp0 = _grupo addWaypoint [_posDestino, count (wayPoints _grupo)];
_Vwp0 setWaypointType "GETOUT";
//_Vwp0 = _grupo addWaypoint [_posDestino, count (wayPoints _grupo)];
//_Vwp0 setWaypointType "MOVE";
_grupo setVariable ["reinfMarker",_mrkDestino];
_grupo setVariable ["origen",_mrkOrigen];
{
_x addEventHandler ["Killed",
	{
	_unit = _this select 0;
	_grupo = group _unit;
	if ({alive _x} count units _grupo == 0) then
		{
		reinfPatrols = reinfPatrols - 1;
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
_Vwp0 setWaypointStatements ["true","nul = [(thisList select {alive _x}),side this,(group this) getVariable ""reinfMarker"",0] spawn garrisonUpdate;[group this] spawn groupDespawner; reinfPatrols = reinfPatrols - 1"];