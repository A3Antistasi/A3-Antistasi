if (!isServer and hasInterface) exitWith{};
private ["_markerX","_vehiclesX","_grupos","_soldiers","_positionX","_pos","_size","_frontierX","_lado","_cfg","_esFIA","_garrison","_antena","_tam","_buildings","_mrk","_cuenta","_typeGroup","_grupo","_typeUnit","_tipoVeh","_veh","_unit","_flagX","_caja","_roads","_mrkMar","_vehicle","_vehCrew","_groupVeh","_dist","_road","_roadCon","_dirVeh","_bunker","_dir","_posF"];
_markerX = _this select 0;

_vehiclesX = [];
_grupos = [];
_soldiers = [];

_positionX = getMarkerPos (_markerX);
_pos = [];


_size = [_markerX] call A3A_fnc_sizeMarker;

_frontierX = [_markerX] call A3A_fnc_isFrontline;
_lado = Invaders;
_esFIA = false;
if (lados getVariable [_markerX,sideUnknown] == malos) then
	{
	_lado = malos;
	if ((random 10 >= (tierWar + difficultyCoef)) and !(_frontierX) and !(_markerX in forcedSpawn)) then
		{
		_esFIA = true;
		};
	};

_antena = objNull;

if (_lado == malos) then
	{
	if (_markerX in puestos) then
		{
		_buildings = nearestObjects [_positionX,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], _size];
		if (count _buildings > 0) then
			{
			_antena = _buildings select 0;
			};
		};
	};

_mrk = createMarkerLocal [format ["%1patrolarea", random 100], _positionX];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [(distanceSPWN/2),(distanceSPWN/2)];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_ang = markerDir _markerX;
_mrk setMarkerDirLocal _ang;
if (!debug) then {_mrk setMarkerAlphaLocal 0};
_garrison = garrison getVariable [_markerX,[]];
_garrison = _garrison call A3A_fnc_garrisonReorg;
_tam = count _garrison;
private _patrol = true;
if (_tam < ([_markerX] call A3A_fnc_garrisonSize)) then
	{
	_patrol = false;
	}
else
	{
	if ({if ((getMarkerPos _x inArea _mrk) and (lados getVariable [_x,sideUnknown] != _lado)) exitWIth {1}} count markersX > 0) then {_patrol = false};
	};
if (_patrol) then
	{
	_cuenta = 0;
	while {(spawner getVariable _markerX !=2) and (_cuenta < 4)} do
		{
		_arrayGrupos = if (_lado == malos) then
			{
			if (!_esFIA) then {gruposNATOsmall} else {gruposFIASmall};
			}
		else
			{
			gruposCSATsmall
			};
		if ([_markerX,false] call A3A_fnc_fogCheck < 0.3) then {_arrayGrupos = _arrayGrupos - sniperGroups};
		_typeGroup = selectRandom _arrayGrupos;

		_grupo = [_positionX,_lado, _typeGroup,false,true] call A3A_fnc_spawnGroup;
		if !(isNull _grupo) then
			{
			sleep 1;
			if ((random 10 < 2.5) and (not(_typeGroup in sniperGroups))) then
				{
				_perro = _grupo createUnit ["Fin_random_F",_positionX,[],0,"FORM"];
				[_perro] spawn A3A_fnc_guardDog;
				sleep 1;
				};
			[leader _grupo, _mrk, "SAFE","SPAWNED", "RANDOM","NOVEH2"] execVM "scripts\UPSMON.sqf";
			_grupos pushBack _grupo;
			{[_x,_markerX] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grupo;
			};
		_cuenta = _cuenta +1;
		};
	};

if ((_frontierX) and (spawner getVariable _markerX!=2) and (_markerX in puestos)) then
	{
	_grupo = createGroup _lado;
	_typeUnit = if (_lado==malos) then {staticCrewOccupants} else {staticCrewInvaders};
	_tipoVeh = if (_lado == malos) then {NATOMortar} else {CSATMortar};
	_pos = [_positionX] call A3A_fnc_mortarPos;
	_veh = _tipoVeh createVehicle _pos;
	_nul=[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
	_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
	[_unit,_markerX] call A3A_fnc_NATOinit;
	_unit moveInGunner _veh;
	_soldiers pushBack _unit;
	_vehiclesX pushBack _veh;
	sleep 1;
	};

_ret = [_markerX,_size,_lado,_frontierX] call A3A_fnc_milBuildings;
_grupos pushBack (_ret select 0);
_vehiclesX append (_ret select 1);
_soldiers append (_ret select 2);

_tipoVeh = if (_lado == malos) then {NATOFlag} else {CSATFlag};
_flagX = createVehicle [_tipoVeh, _positionX, [],0, "CAN_COLLIDE"];
_flagX allowDamage false;
[_flagX,"take"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],_flagX];
_vehiclesX pushBack _flagX;

_caja = objNull;
if (_lado == malos) then
	{
	_caja = NATOAmmoBox createVehicle _positionX;
	_nul = [_caja] call A3A_fnc_NATOcrate;
	}
else
	{
	_caja = CSATAmmoBox createVehicle _positionX;
	_nul = [_caja] call A3A_fnc_CSATcrate;
	};
_vehiclesX pushBack _caja;
_caja call jn_fnc_logistics_addAction;
{_nul = [_x] call A3A_fnc_AIVEHinit;} forEach _vehiclesX;
_roads = _positionX nearRoads _size;

if ((_markerX in puertos) and (spawner getVariable _markerX!=2) and !hayIFA) then
	{
	_tipoVeh = if (_lado == malos) then {vehNATOBoat} else {vehCSATBoat};
	if ([_tipoVeh] call A3A_fnc_vehAvailable) then
		{
		_mrkMar = seaSpawn select {getMarkerPos _x inArea _markerX};
		_pos = (getMarkerPos (_mrkMar select 0)) findEmptyPosition [0,20,_tipoVeh];
		_vehicle=[_pos, 0,_tipoVeh, _lado] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		[_veh] call A3A_fnc_AIVEHinit;
		_vehCrew = _vehicle select 1;
		{[_x,_markerX] call A3A_fnc_NATOinit} forEach _vehCrew;
		_groupVeh = _vehicle select 2;
		_soldiers = _soldiers + _vehCrew;
		_grupos pushBack _groupVeh;
		_vehiclesX pushBack _veh;
		sleep 1;
		};
	{_caja addItemCargoGlobal [_x,2]} forEach swoopShutUp;
	}
else
	{
	if (_frontierX) then
		{
		if (spawner getVariable _markerX!=2) then
			{
			if (count _roads != 0) then
				{
				_dist = 0;
				_road = objNull;
				{if ((position _x) distance _positionX > _dist) then {_road = _x;_dist = position _x distance _positionX}} forEach _roads;
				_roadscon = roadsConnectedto _road;
				_roadcon = objNull;
				{if ((position _x) distance _positionX > _dist) then {_roadcon = _x}} forEach _roadscon;
				_dirveh = [_roadcon, _road] call BIS_fnc_DirTo;
				if (!_esFIA) then
					{
					_grupo = createGroup _lado;
					_grupos pushBack _grupo;
					_pos = [getPos _road, 7, _dirveh + 270] call BIS_Fnc_relPos;
					_bunker = "Land_BagBunker_01_Small_green_F" createVehicle _pos;
					_vehiclesX pushBack _bunker;
					_bunker setDir _dirveh;
					_pos = getPosATL _bunker;
					_tipoVeh = if (_lado==malos) then {staticATOccupants} else {staticATInvaders};
					_veh = _tipoVeh createVehicle _positionX;
					_vehiclesX pushBack _veh;
					_veh setPos _pos;
					_veh setDir _dirVeh + 180;
					_typeUnit = if (_lado==malos) then {staticCrewOccupants} else {staticCrewInvaders};
					_unit = _grupo createUnit [_typeUnit, _positionX, [], 0, "NONE"];
					[_unit,_markerX] call A3A_fnc_NATOinit;
					[_veh] call A3A_fnc_AIVEHinit;
					_unit moveInGunner _veh;
					_soldiers pushBack _unit;
					}
				else
					{
					_typeGroup = selectRandom groupsFIAMid;
					_grupo = [_positionX, _lado, _typeGroup,false,true] call A3A_fnc_spawnGroup;
					if !(isNull _grupo) then
						{
						_veh = vehFIAArmedCar createVehicle getPos _road;
						_veh setDir _dirveh + 90;
						_nul = [_veh] call A3A_fnc_AIVEHinit;
						_vehiclesX pushBack _veh;
						sleep 1;
						_unit = _grupo createUnit [FIARifleman, _positionX, [], 0, "NONE"];
						_unit moveInGunner _veh;
						{_soldiers pushBack _x; [_x,_markerX] call A3A_fnc_NATOinit} forEach units _grupo;
						};
					};
				};
			};
		};
	};

if (count _roads != 0) then
	{
	_pos = _positionX findEmptyPosition [5,_size,"I_Truck_02_covered_F"];//donde pone 5 antes ponía 10
	if (count _pos > 0) then
		{
		_tipoVeh = if (_lado == malos) then {if (!_esFIA) then {vehNATOTrucks} else {[vehFIATruck]}} else {vehCSATTrucks};
		_veh = createVehicle [selectRandom _tipoVeh, _pos, [], 0, "NONE"];
		_veh setDir random 360;
		_vehiclesX pushBack _veh;
		_nul = [_veh] call A3A_fnc_AIVEHinit;
		sleep 1;
		};
	};

_cuenta = 0;

if ((!isNull _antena) and (spawner getVariable _markerX!=2)) then
	{
	if ((typeOf _antena == "Land_TTowerBig_1_F") or (typeOf _antena == "Land_TTowerBig_2_F")) then
		{
		_grupo = createGroup _lado;
		_pos = getPosATL _antena;
		_dir = getDir _antena;
		_posF = _pos getPos [2,_dir];
		_posF set [2,23.1];
		if (typeOf _antena == "Land_TTowerBig_2_F") then
			{
			_posF = _pos getPos [1,_dir];
			_posF set [2,24.3];
			};
		_typeUnit = if (_lado == malos) then {if (!_esFIA) then {NATOMarksman} else {FIAMarksman}} else {CSATMarksman};
		_unit = _grupo createUnit [_typeUnit, _positionX, [], _dir, "NONE"];
		_unit setPosATL _posF;
		_unit forceSpeed 0;
		//_unit disableAI "MOVE";
		//_unit disableAI "AUTOTARGET";
		_unit setUnitPos "UP";
		[_unit,_markerX] call A3A_fnc_NATOinit;
		_soldiers pushBack _unit;
		_grupos pushBack _grupo;
		};
	};

_array = [];
_subArray = [];
_cuenta = 0;
_tam = _tam -1;
while {_cuenta <= _tam} do
	{
	_array pushBack (_garrison select [_cuenta,7]);
	_cuenta = _cuenta + 8;
	};
for "_i" from 0 to (count _array - 1) do
	{
	_grupo = if (_i == 0) then {[_positionX,_lado, (_array select _i),true,false] call A3A_fnc_spawnGroup} else {[_positionX,_lado, (_array select _i),false,true] call A3A_fnc_spawnGroup};
	_grupos pushBack _grupo;
	{[_x,_markerX] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grupo;
	if (_i == 0) then {_nul = [leader _grupo, _markerX, "SAFE", "RANDOMUP","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf"} else {_nul = [leader _grupo, _markerX, "SAFE","SPAWNED", "RANDOM","NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf"};
	};


if (_markerX in puertos) then
	{
	_caja addItemCargo ["V_RebreatherIA",round random 5];
	_caja addItemCargo ["G_I_Diving",round random 5];
	};

waitUntil {sleep 1; (spawner getVariable _markerX == 2)};

deleteMarker _mrk;
//{if ((!alive _x) and (not(_x in destroyedBuildings))) then {destroyedBuildings = destroyedBuildings + [position _x]; publicVariableServer "destroyedBuildings"}} forEach _buildings;
{
if (alive _x) then
	{
	deleteVehicle _x
	};
} forEach _soldiers;
//if (!isNull _periodista) then {deleteVehicle _periodista};
{deleteGroup _x} forEach _grupos;
{
if (!(_x in staticsToSave)) then
	{
	if ((!([distanceSPWN-_size,1,_x,buenos] call A3A_fnc_distanceUnits))) then {deleteVehicle _x}
	};
} forEach _vehiclesX;
