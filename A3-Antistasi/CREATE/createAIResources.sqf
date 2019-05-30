if (!isServer and hasInterface) exitWith{};

private ["_markerX","_vehiclesX","_grupos","_soldiers","_civs","_positionX","_pos","_typeGroup","_tipociv","_size","_mrk","_ang","_cuenta","_grupo","_veh","_civ","_frontierX","_flagX","_perro","_garrison","_lado","_cfg","_esFIA","_roads","_dist","_road","_roadscon","_roadcon","_dirveh","_bunker","_tipoVeh","_typeUnit","_unit","_typeGroup","_stance"];

_markerX = _this select 0;

_positionX = getMarkerPos _markerX;

_size = [_markerX] call A3A_fnc_sizeMarker;

_civs = [];
_soldiers = [];
_grupos = [];
_vehiclesX = [];

_frontierX = [_markerX] call A3A_fnc_isFrontline;

_lado = Invaders;

_esFIA = false;
if (lados getVariable [_markerX,sideUnknown] == malos) then
	{
	_lado = malos;
	if ((random 10 <= (tierWar + difficultyCoef)) and !(_frontierX)) then
		{
		_esFIA = true;
		};
	};
_roads = _positionX nearRoads _size;
_dist = 0;
_road = objNull;
{if ((position _x) distance _positionX > _dist) then {_road = _x;_dist = position _x distance _positionX}} forEach _roads;
_roadscon = roadsConnectedto _road;
_roadcon = objNull;
{if ((position _x) distance _positionX > _dist) then {_roadcon = _x}} forEach _roadscon;
_dirveh = [_roadcon, _road] call BIS_fnc_DirTo;

if ((spawner getVariable _markerX != 2) and _frontierX) then
	{
	if (count _roads != 0) then
		{
		if (!_esFIA) then
			{
			_grupo = createGroup _lado;
			_grupos pushBack _grupo;
			_pos = [getPos _road, 7, _dirveh + 270] call BIS_Fnc_relPos;
			_bunker = "Land_BagBunker_01_small_green_F" createVehicle _pos;
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
	while {(spawner getVariable _markerX != 2) and (_cuenta < 4)} do
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
			_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "RANDOM","NOVEH2"] execVM "scripts\UPSMON.sqf";
			_grupos pushBack _grupo;
			{[_x,_markerX] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grupo;
			};
		_cuenta = _cuenta +1;
		};
	};

_tipoVeh = if (_lado == malos) then {NATOFlag} else {CSATFlag};
_flagX = createVehicle [_tipoVeh, _positionX, [],0, "CAN_COLLIDE"];
_flagX allowDamage false;
[_flagX,"take"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],_flagX];
_vehiclesX pushBack _flagX;

if (not(_markerX in destroyedCities)) then
	{
	if ((daytime > 8) and (daytime < 18)) then
		{
		_grupo = createGroup civilian;
		_grupos pushBack _grupo;
		for "_i" from 1 to 4 do
			{
			if (spawner getVariable _markerX != 2) then
				{
				_civ = _grupo createUnit ["C_man_w_worker_F", _positionX, [],0, "NONE"];
				_nul = [_civ] spawn A3A_fnc_CIVinit;
				_civs pushBack _civ;
				_civ setVariable ["markerX",_markerX,true];
				sleep 0.5;
				_civ addEventHandler ["Killed",
					{
					if (({alive _x} count units group (_this select 0)) == 0) then
						{
						_markerX = (_this select 0) getVariable "markerX";
						_nombre = [_markerX] call A3A_fnc_localizar;
						destroyedCities pushBackUnique _markerX;
						publicVariable "destroyedCities";
						["TaskFailed", ["", format ["%1 Destroyed",_nombre]]] remoteExec ["BIS_fnc_showNotification",[buenos,civilian]];
						};
					}];
				};
			};
		//_nul = [_markerX,_civs] spawn destroyCheck;
		_nul = [leader _grupo, _markerX, "SAFE", "SPAWNED","NOFOLLOW", "NOSHARE","DORELAX","NOVEH2"] execVM "scripts\UPSMON.sqf";
		};
	};

_pos = _positionX findEmptyPosition [5,_size,"I_Truck_02_covered_F"];//donde pone 5 antes ponía 10
if (count _pos > 0) then
	{
	_tipoVeh = if (_lado == malos) then
		{
		if (!_esFIA) then {vehNATOTrucks} else {[vehFIATruck]};
		}
	else
		{
		vehCSATTrucks
		};
	_veh = createVehicle [selectRandom _tipoVeh, _pos, [], 0, "NONE"];
	_veh setDir random 360;
	_vehiclesX pushBack _veh;
	_nul = [_veh] call A3A_fnc_AIVEHinit;
	sleep 1;
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

waitUntil {sleep 1; (spawner getVariable _markerX == 2)};

deleteMarker _mrk;
{
if (alive _x) then
	{
	deleteVehicle _x
	};
} forEach _soldiers;
//if (!isNull _periodista) then {deleteVehicle _periodista};
{deleteGroup _x} forEach _grupos;
{deleteVehicle _x} forEach _civs;
{if (!([distanceSPWN-_size,1,_x,buenos] call A3A_fnc_distanceUnits)) then {deleteVehicle _x}} forEach _vehiclesX;
