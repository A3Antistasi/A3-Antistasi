if (!isServer and hasInterface) exitWith{};

private ["_marcador","_posicion","_fechalim","_fechalimnum","_nombredest","_tipoVeh","_texto","_camionCreado","_size","_pos","_veh","_grupo","_unit"];

_marcador = _this select 0;

_dificil = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contacto = objNull;
_grpContacto = grpNull;
_tsk = "";
if (_dificil) then
	{
	_result = [] call spawnMissionGiver;
	_ciudad = _result select 0;
	if (_ciudad == "") exitWith {_dificil = false};
	_contacto = _result select 1;

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 30;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;
	[[buenos,civilian],"DES",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,false,0,true,"talk",true] call BIS_fnc_taskCreate;
	misiones pushBack ["DES","CREATED"]; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (lados getVariable [_marcador,sideUnknown] == buenos) then
			{
			_salir = true;
			{
			if (isPlayer _x) then {[_contacto,"globalChat","My information is useless now"] remoteExec ["commsMP",_x]}
			} forEach ([50,0,position _contacto,"GREENFORSpawn"] call distanceUnits);
			};
		};
	[_contacto] spawn
		{
		_contacto = _this select 0;
		_grpContacto = group _contacto;
		sleep cleanTime;
		deleteVehicle _contacto;
		deleteGroup _grpContacto;
		};
	if (_salir) exitWith
		{
		if (_contacto getVariable "statusAct") then
			{
			[0,"DES"] spawn borrarTask;
			}
		else
			{
			_tsk = ["DES",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,"FAILED","talk"] call taskUpdate;
			[1200,"DES"] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,"DES"] spawn borrarTask;
	waitUntil {sleep 1; !(["DES"] call BIS_fnc_taskExists)};
	};
_posicion = getMarkerPos _marcador;
_lado = if (lados getVariable [_marcador,sideUnknown] == malos) then {malos} else {muyMalos};
_tiempolim = if (_dificil) then {30} else {120};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;

_tipoVeh = if (_lado == malos) then {vehNATOAA} else {vehCSATAA};

[[buenos,civilian],"DES",[format ["We know an enemy armor (%4) is stationed in %1. It is a good chance to destroy or steal it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,false,0,true,"Destroy",true] call BIS_fnc_taskCreate;
_camionCreado = false;
misiones pushBack ["DES","CREATED"]; publicVariable "misiones";

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (spawner getVariable _marcador == 0)};
_bonus = if (_dificil) then {2} else {1};
if (spawner getVariable _marcador == 0) then
	{
	_camionCreado = true;
	_size = [_marcador] call sizeMarker;
	_pos = [];
	if (_size > 40) then {_pos = [_posicion, 10, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos} else {_pos = _posicion findEmptyPosition [10,60,_tipoVeh]};
	_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir random 360;
	[_veh] call AIVEHinit;

	_grupo = createGroup _lado;

	sleep 5;
	_veh allowDamage true;
	_tipo = if (_lado == malos) then {NATOCrew} else {CSATCrew};
	for "_i" from 1 to 3 do
		{
		_unit = _grupo createUnit [_tipo, _pos, [], 0, "NONE"];
		[_unit,""] call NATOinit;
		sleep 2;
		};

	if (_dificil) then
		{
		_grupo addVehicle _veh;
		}
	else
		{
		waitUntil {sleep 1;({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"GREENFORSpawn"] call distanceUnits) > 0) or (dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)};

		if ({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"GREENFORSpawn"] call distanceUnits) > 0) then {_grupo addVehicle _veh;};
		};

	waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)};

	if ((not alive _veh) or ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0)) then
		{
		["DES",[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,"SUCCEEDED","Destroy"] call taskUpdate;
		if ({_x getVariable ["GREENFORSpawn",false]} count crew _veh > 0) then
			{
			["TaskFailed", ["", format ["AA Stolen in %1",_nombreDest]]] remoteExec ["BIS_fnc_showNotification",_lado];
			};
		[0,300*_bonus] remoteExec ["resourcesFIA",2];
		if (_lado == muyMalos) then {[0,3] remoteExec ["prestige",2]; [0,10*_bonus,_posicion] remoteExec ["citySupportChange",2]} else {[3,0] remoteExec ["prestige",2];[0,5*_bonus,_posicion] remoteExec ["citySupportChange",2]};
		[1200*_bonus] remoteExec ["timingCA",2];
		{if (_x distance _veh < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5*_bonus,theBoss] call playerScoreAdd;
		};
	}
else
	{
	["DES",[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,getText (configFile >> "CfgVehicles" >> (_tipoVeh) >> "displayName")],"Steal or Destroy Armor",_marcador],_posicion,"FAILED","Destroy"] call taskUpdate;
	[-5*_bonus,-100*_bonus] remoteExec ["resourcesFIA",2];
	[5*_bonus,0,_posicion] remoteExec ["citySupportChange",2];
	[-600*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,theBoss] call playerScoreAdd;
	};

_nul = [1200,"DES"] spawn borrarTask;

waitUntil {sleep 1; (spawner getVariable _marcador == 2)};

if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};
	};
