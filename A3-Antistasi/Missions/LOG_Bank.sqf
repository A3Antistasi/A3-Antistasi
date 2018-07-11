//el sitio de la caja es el 21
if (!isServer and hasInterface) exitWith {};
private ["_banco","_marcador","_dificil","_salir","_contacto","_grpContacto","_tsk","_posHQ","_ciudades","_ciudad","_tam","_posicion","_posCasa","_nombreDest","_tiempoLim","_fechaLim","_fechaLimNum","_posBase","_pos","_camion","_cuenta","_mrkfin","_mrk","_soldados"];
_banco = _this select 0;
_marcador = [ciudades,_banco] call BIS_fnc_nearestPosition;

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
	[[buenos,civilian],"LOG",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,false,0,true,"talk",true] call BIS_fnc_taskCreate;
	misiones pushBack ["LOG","CREATED"]; publicVariable "misiones";
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
			[0,"LOG"] spawn borrarTask;
			}
		else
			{
			["LOG",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,"FAILED","talk"] call taskUpdate;
			[1200,"LOG"] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,"LOG"] spawn borrarTask;
	waitUntil {sleep 1; !(["LOG"] call BIS_fnc_taskExists)};
	};

_posicion = getPosASL _banco;

_posbase = getMarkerPos respawnBuenos;

_tiempolim = if (_dificil) then {60} else {120};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_ciudad = [ciudades, _posicion] call BIS_fnc_nearestPosition;
_mrkfin = createMarker [format ["LOG%1", random 100], _posicion];
_nombredest = [_ciudad] call localizar;
_mrkfin setMarkerShape "ICON";
//_mrkfin setMarkerType "hd_destroy";
//_mrkfin setMarkerColor "ColorBlue";
//_mrkfin setMarkerText "Bank";

_pos = (getMarkerPos respawnBuenos) findEmptyPosition [1,50,"C_Van_01_box_F"];

_camion = "C_Van_01_box_F" createVehicle _pos;
{_x reveal _camion} forEach (allPlayers - (entities "HeadlessClient_F"));
[_camion] call AIVEHinit;
_camion setVariable ["destino",_nombredest,true];
_camion addEventHandler ["GetIn",
	{
	if (_this select 1 == "driver") then
		{
		_texto = format ["Bring this truck to %1 Bank and park it in the main entrance",(_this select 0) getVariable "destino"];
		_texto remoteExecCall ["hint",_this select 2];
		};
	}];

[_camion,"Mission Vehicle"] spawn inmuneConvoy;

[[buenos,civilian],"LOG",[format ["We know Gendarmes are guarding a big amount of money in the bank of %1. Take this truck and go there before %2:%3, hold the truck close to tha bank's main entrance for 2 minutes and the money will be transferred to the truck. Bring it back to HQ and the money will be ours.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Bank Robbery",_mrkfin],_posicion,false,0,true,"Interact",true] call BIS_fnc_taskCreate;
misiones pushBack ["LOG","CREATED"]; publicVariable "misiones";
_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], _posicion];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [30,30];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrk setMarkerAlphaLocal 0;

_grupos = [];
_soldados = [];
for "_i" from 1 to 4 do
	{
	_grupo = if (_dificil) then {[_posicion,malos, gruposNATOSentry] call spawnGroup} else {[_posicion,malos, gruposNATOGen] call spawnGroup};
	sleep 1;
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2", "FORTIFY"] execVM "scripts\UPSMON.sqf";
	{[_x,""] call NATOinit; _soldados pushBack _x} forEach units _grupo;
	_grupos pushBack _grupo;
	};

_posicion = _banco buildingPos 1;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (!alive _camion) or (_camion distance _posicion < 7)};
_bonus = if (_dificil) then {2} else {1};
if ((dateToNumber date > _fechalimnum) or (!alive _camion)) then
	{
	["LOG",[format ["We know Gendarmes is guarding a big amount of money in the bank of %1. Take this truck and go there before %2:%3, hold the truck close to tha bank's main entrance for 2 minutes and the money will be transferred to the truck. Bring it back to HQ and the money will be ours.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Bank Robbery",_mrkfin],_posicion,"FAILED","Interact"] call taskUpdate;
	[-1800*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,theBoss] call playerScoreAdd;
	}
else
	{
	_cuenta = 120*_bonus;//120
	[[_posicion,malos,"",true],"patrolCA"] remoteExec ["scheduler",2];
	[10*_bonus,-20*_bonus,_marcador] remoteExec ["citySupportChange",2];
	["TaskFailed", ["", format ["Bank of %1 being assaulted",_nombredest]]] remoteExec ["BIS_fnc_showNotification",malos];
	{_amigo = _x;
	if (_amigo distance _camion < 300) then
		{
		if ((captive _amigo) and (isPlayer _amigo)) then {[_amigo,false] remoteExec ["setCaptive",0,_amigo]; _amigo setCaptive false};
		{if (side _x == malos) then {_x reveal [_amigo,4]};
		} forEach allUnits;
		};
	} forEach ([distanciaSPWN,0,_posicion,"GREENFORSpawn"] call distanceUnits);
	_exit = false;
	while {(_cuenta > 0) or (_camion distance _posicion < 7) and (alive _camion) and (dateToNumber date < _fechalimnum)} do
		{
		while {(_cuenta > 0) and (_camion distance _posicion < 7) and (alive _camion)} do
			{
			_formato = format ["%1", _cuenta];
			{if (isPlayer _x) then {[petros,"countdown",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,_camion,"GREENFORSpawn"] call distanceUnits);
			sleep 1;
			_cuenta = _cuenta - 1;
			};
		if (_cuenta > 0) then
			{
			_cuenta = 120*_bonus;//120
			if (_camion distance _posicion > 6) then {{[petros,"hint","Don't get the truck far from the bank or count will restart"] remoteExec ["commsMP",_x]} forEach ([200,0,_camion,"GREENFORSpawn"] call distanceUnits)};
			waitUntil {sleep 1; (!alive _camion) or (_camion distance _posicion < 7) or (dateToNumber date < _fechalimnum)};
			}
		else
			{
			if (alive _camion) then
				{
				{if (isPlayer _x) then {[petros,"hint","Drive the Truck back to base to finish this mission"] remoteExec ["commsMP",_x]}} forEach ([80,0,_camion,"GREENFORSpawn"] call distanceUnits);
				_exit = true;
				};
			//waitUntil {sleep 1; (!alive _camion) or (_camion distance _posicion > 7) or (dateToNumber date < _fechalimnum)};
			};
		if (_exit) exitWith {};
		};
	};


waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (!alive _camion) or (_camion distance _posbase < 50)};
if ((_camion distance _posbase < 50) and (dateToNumber date < _fechalimnum)) then
	{
	["LOG",[format ["We know Gendarmes is guarding a big amount of money in the bank of %1. Take this truck and go there before %2:%3, hold the truck close to tha bank's main entrance for 2 minutes and the money will be transferred to the truck. Bring it back to HQ and the money will be ours.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Bank Robbery",_mrkfin],_posicion,"SUCCEEDED","Interact"] call taskUpdate;
	[0,5000*_bonus] remoteExec ["resourcesFIA",2];
	[10*_bonus,0] remoteExec ["prestige",2];
	[1800*_bonus] remoteExec ["timingCA",2];
	{if (_x distance _camion < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5*_bonus,theBoss] call playerScoreAdd;
	waitUntil {sleep 1; speed _camion == 0};

	[_camion] call vaciar;
	};
if (!alive _camion) then
	{
	["LOG",[format ["We know Gendarmes is guarding a big amount of money in the bank of %1. Take this truck and go there before %2:%3, hold the truck close to tha bank's main entrance for 2 minutes and the money will be transferred to the truck. Bring it back to HQ and the money will be ours.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Bank Robbery",_mrkfin],_posicion,"FAILED","Interact"] call taskUpdate;
	[1800*_bonus] remoteExec ["timingCA",2];
	[-10*_bonus,theBoss] call playerScoreAdd;
	};


deleteVehicle _camion;

_nul = [1200,"LOG"] spawn borrarTask;

waitUntil {sleep 1; !([distanciaSPWN,1,_posicion,"GREENFORSpawn"] call distanceUnits)};

{_grupo = _x;
{deleteVehicle _x} forEach units _grupo;
deleteGroup _x;
} forEach _grupos;

//sleep (600 + random 1200);
//_nul = [_tsk,true] call BIS_fnc_deleteTask;
deleteMarker _mrk;
deleteMarker _mrkfin;


