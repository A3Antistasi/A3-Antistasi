if (!isServer and hasInterface) exitWith {};
private ["_posorigen","_tipogrupo","_nameOrigin","_markTsk","_wp1","_soldados","_landpos","_pad","_vehiculos","_wp0","_wp3","_wp4","_wp2","_grupo","_grupos","_tipoveh","_vehicle","_heli","_heliCrew","_groupHeli","_pilotos","_rnd","_resourcesAAF","_nVeh","_tam","_roads","_Vwp1","_tanques","_road","_veh","_vehCrew","_grupoVeh","_Vwp0","_size","_Hwp0","_grupo1","_uav","_grupouav","_uwp0","_tsk","_vehiculo","_soldado","_piloto","_mrkDestination","_posDestination","_prestigeCSAT","_base","_airportX","_nameDest","_tiempo","_solMax","_nul","_pos","_timeOut"];
_mrkDestination = _this select 0;
_mrkOrigen = _this select 1;
bigAttackInProgress = true;
publicVariable "bigAttackInProgress";
_posDestination = getMarkerPos _mrkDestination;
_posOrigen = getMarkerPos _mrkOrigen;
_grupos = [];
_soldados = [];
_pilotos = [];
_vehiculos = [];
_civiles = [];

_nameDest = [_mrkDestination] call A3A_fnc_localizar;
[[buenos,civilian,malos],"AttackAAF",[format ["%2 is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nameDest,nameInvaders],format ["%1 Punishment",nameInvaders],_mrkDestination],getMarkerPos _mrkDestination,false,0,true,"Defend",true] call BIS_fnc_taskCreate;

_nul = [_mrkOrigen,_mrkDestination,muyMalos] spawn A3A_fnc_artillery;
_lado = if (lados getVariable [_mrkDestination,sideUnknown] == malos) then {malos} else {buenos};
_tiempo = time + 3600;

for "_i" from 1 to 3 do
	{
	_tipoveh = if (_i != 3) then {selectRandom (vehCSATAir select {[_x] call A3A_fnc_vehAvailable})} else {selectRandom (vehCSATTransportHelis select {[_x] call A3A_fnc_vehAvailable})};
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
	_vehicle=[_pos, 0, _tipoveh, muyMalos] call bis_fnc_spawnvehicle;
	_heli = _vehicle select 0;
	_heliCrew = _vehicle select 1;
	{[_x] call A3A_fnc_NATOinit} forEach _heliCrew;
	[_heli] call A3A_fnc_AIVEHinit;
	_groupHeli = _vehicle select 2;
	_pilotos = _pilotos + _heliCrew;
	_grupos pushBack _groupHeli;
	_vehiculos pushBack _heli;
	//_heli lock 3;
	if (not(_tipoveh in vehCSATTransportHelis)) then
		{
		{[_x] call A3A_fnc_NATOinit} forEach _heliCrew;
		_wp1 = _groupHeli addWaypoint [_posDestination, 0];
		_wp1 setWaypointType "SAD";
		//[_heli,"Air Attack"] spawn A3A_fnc_inmuneConvoy;
		}
	else
		{
		{_x setBehaviour "CARELESS";} forEach units _groupHeli;
		_tipoGrupo = [_tipoVeh,muyMalos] call A3A_fnc_cargoSeats;
		_grupo = [_posOrigen, muyMalos, _tipoGrupo] call A3A_fnc_spawnGroup;
		{_x assignAsCargo _heli;_x moveInCargo _heli; _soldados pushBack _x; [_x] call A3A_fnc_NATOinit; _x setVariable ["origen",_mrkOrigen]} forEach units _grupo;
		_grupos pushBack _grupo;
		//[_heli,"CSAT Air Transport"] spawn A3A_fnc_inmuneConvoy;

		if (not(_tipoVeh in vehFastRope)) then
			{

			_landPos = _posDestination getPos [(random 500) + 300, random 360];

			_landPos = [_landPos, 200, 350, 10, 0, 0.20, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
			if !(_landPos isEqualTo [0,0,0]) then
				{
				_landPos set [2, 0];
				_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
				_vehiculos pushBack _pad;
				_wp0 = _groupHeli addWaypoint [_landpos, 0];
				_wp0 setWaypointType "TR UNLOAD";
				_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'"];
				[_groupHeli,0] setWaypointBehaviour "CARELESS";
				_wp3 = _grupo addWaypoint [_landpos, 0];
				_wp3 setWaypointType "GETOUT";
				_wp0 synchronizeWaypoint [_wp3];
				_wp4 = _grupo addWaypoint [_posDestination, 1];
				_wp4 setWaypointType "SAD";
				_wp4 setWaypointStatements ["true","{if (side _x != side this) then {this reveal [_x,4]}} forEach allUnits"];
				_wp2 = _groupHeli addWaypoint [_posorigen, 1];
				_wp2 setWaypointType "MOVE";
				_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
				[_groupHeli,1] setWaypointBehaviour "AWARE";
				}
			else
				{
				[_heli,_grupo,_mrkDestination,_mrkOrigen] spawn A3A_fnc_airdrop;
				};
			}
		else
			{
			{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _groupHeli;
			[_heli,_grupo,_posDestination,_posorigen,_groupHeli] spawn A3A_fnc_fastrope;
			};
		};
	sleep 20;
	};

_datos = server getVariable _mrkDestination;

_numCiv = _datos select 0;
_numCiv = round (_numCiv /10);

if (lados getVariable [_mrkDestination,sideUnknown] == malos) then {[[_posDestination,malos,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};

if (_numCiv < 8) then {_numCiv = 8};

_size = [_mrkDestination] call A3A_fnc_sizeMarker;
//_groupCivil = if (_lado == buenos) then {createGroup buenos} else {createGroup malos};
_groupCivil = createGroup buenos;
_grupos pushBack _groupCivil;
//[muyMalos,[civilian,0]] remoteExec ["setFriend",2];
_tipoUnit = if (_lado == buenos) then {SDKUnarmed} else {NATOUnarmed};
for "_i" from 0 to _numCiv do
	{
	while {true} do
		{
		_pos = _posDestination getPos [random _size,random 360];
		if (!surfaceIsWater _pos) exitWith {};
		};
	_tipoUnit = selectRandom arrayCivs;
	_civ = _groupCivil createUnit [_tipoUnit,_pos, [],0,"NONE"];
	_civ forceAddUniform (selectRandom civUniforms);
	_rnd = random 100;
	if (_rnd < 90) then
		{
		if (_rnd < 25) then {[_civ, "hgun_PDW2000_F", 5, 0] call BIS_fnc_addWeapon;} else {[_civ, "hgun_Pistol_heavy_02_F", 5, 0] call BIS_fnc_addWeapon;};
		};
	_civiles pushBack _civ;
	[_civ] call A3A_fnc_civInit;
	sleep 0.5;
	};

_nul = [leader _groupCivil, _mrkDestination, "AWARE","SPAWNED","NOVEH2"] execVM "scripts\UPSMON.sqf";

_civilMax = {alive _x} count _civiles;
_solMax = count _soldados;

for "_i" from 0 to round random 2 do
	{
	if ([vehCSATPlane] call A3A_fnc_vehAvailable) then
		{
		_nul = [_mrkDestination,muyMalos,"NAPALM"] spawn A3A_fnc_airstrike;
		sleep 30;
		};
	};

waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (({(_x distance _posDestination < _size*2) and (not(vehicle _x isKindOf "Air")) and (alive _x) and (!captive _x)} count _soldados) > 4*({(alive _x) and (_x distance _posDestination < _size*2)} count _civiles)) or (time > _tiempo)};

if ((({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (time > _tiempo)) then
	{
	{_x doMove [0,0,0]} forEach _soldados;
	//["AttackAAF", "SUCCEEDED",true] spawn BIS_fnc_taskSetState;
	["AttackAAF",[format ["%2 is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nameDest,nameInvaders],format ["%1 Punishment",nameInvaders],_mrkDestination],getMarkerPos _mrkDestination,"SUCCEEDED"] call A3A_fnc_taskUpdate;
	if ({(side _x == buenos) and (_x distance _posDestination < _size * 2)} count allUnits >= {(side _x == malos) and (_x distance _posDestination < _size * 2)} count allUnits) then
		{
		if (lados getVariable [_mrkDestination,sideUnknown] == malos) then {[-15,15,_posDestination] remoteExec ["A3A_fnc_citySupportChange",2]} else {[-5,15,_posDestination] remoteExec ["A3A_fnc_citySupportChange",2]};
		[-5,0] remoteExec ["A3A_fnc_prestige",2];
		{[-10,10,_x] remoteExec ["A3A_fnc_citySupportChange",2]} forEach ciudades;
		{if (isPlayer _x) then {[10,_x] call A3A_fnc_playerScoreAdd}} forEach ([500,0,_posDestination,buenos] call A3A_fnc_distanceUnits);
		[10,theBoss] call A3A_fnc_playerScoreAdd;
		}
	else
		{
		if (lados getVariable [_mrkDestination,sideUnknown] == malos) then {[15,-5,_posDestination] remoteExec ["A3A_fnc_citySupportChange",2]} else {[15,-15,_posDestination] remoteExec ["A3A_fnc_citySupportChange",2]};
		{[10,-10,_x] remoteExec ["A3A_fnc_citySupportChange",2]} forEach ciudades;
		};
	}
else
	{
	["AttackAAF",[format ["%2 is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nameDest,nameInvaders],format ["%1 Punishment",nameInvaders],_mrkDestination],getMarkerPos _mrkDestination,"FAILED"] call A3A_fnc_taskUpdate;
	//["AttackAAF", "FAILED",true] spawn BIS_fnc_taskSetState;
	[-20,-20,_posDestination] remoteExec ["A3A_fnc_citySupportChange",2];
	{[-10,-10,_x] remoteExec ["A3A_fnc_citySupportChange",2]} forEach ciudades;
	destroyedCities = destroyedCities + [_mrkDestination];
	publicVariable "destroyedCities";
	for "_i" from 1 to 60 do
		{
		_mina = createMine ["APERSMine",_posDestination,[],_size];
		muyMalos revealMine _mina;
		};
	[_mrkDestination] call A3A_fnc_destroyCity;
	};

sleep 15;
//[muyMalos,[civilian,1]] remoteExec ["setFriend",2];
_nul = [0,"AttackAAF"] spawn A3A_fnc_deleteTask;
[7200] remoteExec ["A3A_fnc_timingCA",2];
{
_veh = _x;
if (!([distanceSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x};
} forEach _vehiculos;
{
_veh = _x;
if (!([distanceSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x; _soldados = _soldados - [_x]};
} forEach _soldados;
{
_veh = _x;
if (!([distanceSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _x; _pilotos = _pilotos - [_x]};
} forEach _pilotos;

bigAttackInProgress = false;
publicVariable "bigAttackInProgress";

if (count _soldados > 0) then
	{
	{
	_veh = _x;
	waitUntil {sleep 1; !([distanceSPWN,1,_veh,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
	deleteVehicle _veh;
	} forEach _soldados;
	};

if (count _pilotos > 0) then
	{
	{
	_veh = _x;
	waitUntil {sleep 1; !([distanceSPWN,1,_x,buenos] call A3A_fnc_distanceUnits) and (({_x distance _veh <= distanceSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
	deleteVehicle _veh;
	} forEach _pilotos;
	};
{deleteGroup _x} forEach _grupos;

waitUntil {sleep 1; (spawner getVariable _mrkDestination == 2)};

{deleteVehicle _x} forEach _civiles;
deleteGroup _groupCivil;