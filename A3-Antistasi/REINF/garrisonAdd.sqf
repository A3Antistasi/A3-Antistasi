private ["_hr","_resourcesFIA","_tipo","_coste","_marcador","_garrison","_posicion","_unit","_grupo","_veh","_pos"];

_hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "You lack of HR to make a new recruitment"};

_resourcesFIA = server getVariable "resourcesFIA";

_tipo = _this select 0;

_coste = 0;

if (_tipo isEqualType "") then
	{
	_coste = server getVariable _tipo;
	_coste = _coste + ([SDKMortar] call vehiclePrice);
	}
else
	{
	_tipo = if (random 20 <= skillFIA) then {_tipo select 1} else {_tipo select 0};
	_coste = server getVariable _tipo;
	};

if (_coste > _resourcesFIA) exitWith {hint format ["You do not have enough money for this kind of unit (%1 € needed)",_coste]};

_marcador = posicionGarr;

if ((_tipo == staticCrewBuenos) and (_marcador in puestosFIA)) exitWith {hint "You cannot add mortars to a Roadblock garrison"};

_posicion = getMarkerPos _marcador;

if (surfaceIsWater _posicion) exitWith {hint "This Garrison is still updating, please try again in a few seconds"};

if ([_posicion,500] call enemyNearCheck) exitWith {Hint "You cannot Recruit Garrison Units with enemies near the zone"};
_nul = [-1,-_coste] remoteExec ["resourcesFIA",2];
/*
_garrison = [];
_garrison = _garrison + (garrison getVariable [_marcador,[]]);
_garrison pushBack _tipo;
garrison setVariable [_marcador,_garrison,true];
//[_marcador] call mrkUpdate;*/
_cuenta = count (garrison getVariable _marcador);
[_tipo,buenos,_marcador,1] remoteExec ["garrisonUpdate",2];
waitUntil {(_cuenta < count (garrison getVariable _marcador)) or (lados getVariable [_marcador,sideUnknown] != buenos)};

if (lados getVariable [_marcador,sideUnknown] == buenos) then
	{
	hint format ["Soldier recruited.%1",[_marcador] call garrisonInfo];

	if (spawner getVariable _marcador != 2) then
		{
		//[_marcador] remoteExec ["tempMoveMrk",2];
		_grupos = if (_tipo == staticCrewBuenos) then {[]} else {allGroups select {(leader _x getVariable ["marcador",""] == _marcador) and (count units _x < 8) and (vehicle (leader _x) == leader _x)}};
		_grupo = if (_grupos isEqualTo []) then
			{
			createGroup buenos
			}
		else
			{
			_grupos select 0;
			};
		_unit = _grupo createUnit [_tipo, _posicion, [], 0, "NONE"];
		if (_tipo in SDKSL) then {_grupo selectLeader _unit};
		[_unit,_marcador] call FIAinitBases;
		if (_tipo == staticCrewBuenos) then
			{
			private _veh = SDKMortar createVehicle _posicion;
			_nul=[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			_unit assignAsGunner _veh;
			_unit moveInGunner _veh;
			[_veh] call AIVEHinit;
			};
		if (_grupos isEqualTo []) then
			{
			_nul = [leader _grupo, _marcador, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
			};
		[_unit,_marcador] spawn
			{
			private _unit = _this select 0;
			private _marcador = _this select 1;
			waitUntil {sleep 1; (spawner getVariable _marcador == 2)};
			if (alive _unit) then
				{
				private _grupo = group _unit;
				if (typeOf _unit == staticCrewBuenos) then {deleteVehicle (vehicle _unit)};
				deleteVehicle _unit;
				if (count units _grupo == 0) then {deleteGroup _grupo};
				};
			};
		};
	};

