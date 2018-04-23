private ["_soldados","_vehiculos","_grupos","_base","_posbase","_roads","_tipoCoche","_arrayaeropuertos","_arrayDestinos","_tam","_road","_veh","_vehCrew","_grupoVeh","_grupo","_grupoP","_distancia"];

_soldados = [];
_vehiculos = [];
_grupos = [];
_base = "";
_roads = [];

//_tipos = ["I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Heli_light_03_unarmed_F","I_Boat_Armed_01_minigun_F"];
_tipos = vehNATOLight + [vehNATOPatrolHeli,vehNATOBoat];

_arrayAeropuertos = (puertos + aeropuertos) select {(getMarkerPos _x distance getMarkerPos "respawn_guerrila" < 3000) and ((spawner getVariable _x != 0)) and (lados getVariable [_x,sideUnknown] != buenos)};

if (count _arrayAeropuertos == 0) exitWith {};

_base = selectRandom _arrayAeropuertos;
_tipoCoche = "";
_lado = malos;
_tipoPatrol = "LAND";
if (lados getVariable [_base,sideUnknown] == malos) then
	{
	if (_base in puertos) then
		{
		_tipoCoche = vehNATOBoat;
		_tipoPatrol = "SEA";
		}
	else
		{
		if (random 100 < prestigeNATO) then
			{
			_tipoCoche = selectRandom (vehNATOLight + [vehNATOPatrolHeli]);
			if (_tipoCoche == vehNATOPatrolHeli) then {_tipoPatrol = "AIR"};
			}
		else
			{
			_tipoCoche = selectRandom [vehPoliceCar,vehFIAArmedCar];
			};
		};
	}
else
	{
	_lado = muyMalos;
	if (_base in puertos) then
		{
		_tipoCoche = vehCSATBoat;
		_tipoPatrol = "SEA";
		}
	else
		{
		_tipoCoche = selectRandom (vehCSATLight + [vehCSATPatrolHeli]);
		if (_tipoCoche == vehCSATPatrolHeli) then {_tipoPatrol = "AIR"};
		};
	};

_posbase = getMarkerPos _base;


if (_tipoPatrol == "AIR") then
	{
	_arrayDestinos = marcadores select {lados getVariable [_x,sideUnknown] == _lado};
	_distancia = 200;
	}
else
	{
	if (_tipoPatrol == "SEA") then
		{
		_arraydestinos = seaMarkers select {(getMarkerPos _x) distance _posbase < 2500};
		_distancia = 100;
		}
	else
		{
		_arrayDestinos = marcadores select {lados getVariable [_x,sideUnknown] == _lado};
		_arraydestinos = [_arrayDestinos] call patrolDestinos;
		_distancia = 50;
		};
	};

if (count _arraydestinos < 2) exitWith {};

AAFpatrols = AAFpatrols + 1;

if (_tipoPatrol != "AIR") then
	{
	if (_tipoPatrol == "SEA") then
		{
		_posbase = [_posbase,50,150,10,2,0,0] call BIS_Fnc_findSafePos;
		}
	else
		{
		_indice = aeropuertos find _base;
		_spawnPoint = spawnPoints select _indice;
		_posBase = getMarkerPos _spawnPoint;
		/*
		_tam = 10;
		while {true} do
			{
			_roads = _posbase nearRoads _tam;
			if (count _roads > 0) exitWith {};
			_tam = _tam + 10;
			};
		_road = _roads select 0;
		_posbase = position _road;
		*/
		};
	};

_vehicle=[_posBase, 0,_tipoCoche, _lado] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] call AIVEHinit;
[_veh,"Patrol"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] call NATOinit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_veh];


if (_tipoCoche in vehNATOLightUnarmed) then
	{
	sleep 1;
	_grupo = [_posbase, _lado, gruposNATOSentry] call spawnGroup;
	{_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x; [_x] joinSilent _grupoveh; [_x] call NATOinit} forEach units _grupo;
	deleteGroup _grupo;
	//[_veh] spawn smokeCover;
	};
if (_tipoCoche in vehCSATLightUnarmed) then
	{
	sleep 1;
	_grupo = [_posbase, _lado, gruposCSATSentry] call spawnGroup;
	{_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x; [_x] joinSilent _grupoveh; [_x] call NATOinit} forEach units _grupo;
	deleteGroup _grupo;
	//[_veh] spawn smokeCover;
	};

//if (_tipoPatrol == "LAND") then {_veh forceFollowRoad true};

while {alive _veh} do
	{
	_destino = selectRandom _arraydestinos;
	if (debug) then {player globalChat format ["Patrulla AI generada. Origen: %2 Destino %1", _destino, _base]; sleep 3};
	_posDestino = getMarkerPos _destino;
	if (_tipoPatrol == "LAND") then
		{
		_tam = 20;
		_road = objNull;
		while {isNull _road} do
			{
			_roads = _posDestino nearRoads _tam;
			if (count _roads != 0) then
				{
				{
				if ((surfaceType (position _x)!= "#GdtForest") and (surfaceType (position _x)!= "#GdtRock") and (surfaceType (position _x)!= "#GdtGrassTall")) exitWith {_road = _x};
				} forEach _roads;
				};
			_tam = _tam + 50;
			};
		_posDestino = position _road;
		};
	_Vwp0 = _grupoVeh addWaypoint [_posdestino, 0];
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";
	_Vwp0 setWaypointSpeed "LIMITED";
	_veh setFuel 1;

	waitUntil {sleep 60; (_veh distance _posdestino < _distancia) or ({alive _x} count _soldados == 0) or ({(fleeing _x) or (captive _x)} count _soldados >= {alive _x} count _soldados) or (!canMove _veh)};
	if (({alive _x} count _soldados == 0) or ({fleeing _x} count _soldados == {alive _x} count _soldados) or (!canMove _veh)) exitWith {};
	if (_tipoPatrol == "AIR") then
		{
		_arrayDestinos = marcadores select {lados getVariable [_x,sideUnknown] == _lado};
		}
	else
		{
		if (_tipoPatrol == "SEA") then
			{
			_arraydestinos = seaMarkers select {(getMarkerPos _x) distance position _veh < 2500};
			}
		else
			{
			_arrayDestinos = marcadores select {lados getVariable [_x,sideUnknown] == _lado};
			_arraydestinos = [_arraydestinos] call patrolDestinos;
			};
		};
	};


AAFpatrols = AAFpatrols - 1;

_enemigos = "OPFORSpawn";

if (_lado == malos) then {_enemigos = "BLUFORSpawn"};
{_unit = _x;
waitUntil {sleep 1;!([distanciaSPWN,1,_unit,"GREENFORSpawn"] call distanceUnits) and !([distanciaSPWN,1,_unit,_enemigos] call distanceUnits)};deleteVehicle _unit} forEach _soldados;

{_veh = _x;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and !([distanciaSPWN,1,_veh,_enemigos] call distanceUnits)) then {deleteVehicle _veh}} forEach _vehiculos;
{deleteGroup _x} forEach _grupos;