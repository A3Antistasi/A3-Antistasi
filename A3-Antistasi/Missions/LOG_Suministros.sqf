if (!isServer and hasInterface) exitWith{};
private ["_marcador","_dificil","_salir","_contacto","_grpContacto","_tsk","_posHQ","_ciudades","_ciudad","_tam","_posicion","_posCasa","_nombreDest","_tiempoLim","_fechaLim","_fechaLimNum","_pos","_camion","_cuenta"];

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
_posicion = getMarkerPos _marcador;

_tiempolim = if (_dificil) then {30} else {60};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;
_taskDescription = format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserved a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3. You may allways sell those supplies here, that money can be welcome. Just sell the truck and job is done",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4];

[[buenos,civilian],"LOG",[_taskDescription,"City Supplies",_marcador],_posicion,false,0,true,"Heal",true] call BIS_fnc_taskCreate;
misiones pushBack ["LOG","CREATED"]; publicVariable "misiones";
_pos = [];

if (!_dificil) then
	{
	_pos = (getMarkerPos respawnBuenos) findEmptyPosition [1,50,"C_Van_01_box_F"];
	}
else
	{
	_dirVeh = 0;
	_road = [getPos _contacto] call findNearestGoodRoad;
	_posroad = getPos _road;
	_roadcon = roadsConnectedto _road; if (count _roadCon == 0) then {diag_log format ["Antistasi Error: Esta carretera no tiene conexión: %1",position _road]};
	if (count _roadCon > 0) then
		{
		_posrel = getPos (_roadcon select 0);
		_dirveh = [_posroad,_posrel] call BIS_fnc_DirTo;
		}
	else
		{
		_dirVeh = getDir _road;
		};
	_pos = [_posroad, 3, _dirveh + 90] call BIS_Fnc_relPos;
	};

//Creating the box
_camion = "Land_PaperBox_01_open_boxes_F" createVehicle _pos;
_camion allowDamage false;
_camion call jn_fnc_logistics_addAction;
_camion addAction ["Delivery infos",
	{
		_text = format ["Deliver this box to %1, unload it to start distributing to people",(_this select 0) getVariable "destino"]; //This need a rework
		_text remoteExecCall ["hint",_this select 2];	//This need a rework
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];
[_camion] call AIVEHinit;
//{_x reveal _camion} forEach (allPlayers - (entities "HeadlessClient_F"));
_camion setVariable ["destino",_nombredest,true];

[_camion,"Supply Box"] spawn inmuneConvoy;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ((_camion distance _posicion < 40) and (isNull attachedTo _camion)) or (isNull _camion)};
_bonus = if (_dificil) then {2} else {1};
if ((dateToNumber date > _fechalimnum) or (isNull _camion)) then
	{
	["LOG",[_taskDescription,"City Supplies",_marcador],_posicion,"FAILED","Heal"] call taskUpdate;
	[5*_bonus,-5*_bonus,_posicion] remoteExec ["citySupportChange",2];
	[-10*_bonus,theBoss] call playerScoreAdd;
	}
else
	{
	_cuenta = 120*_bonus;//120
	[[_posicion,malos,"",false],"patrolCA"] remoteExec ["scheduler",2];
	["TaskFailed", ["", format ["%2 deploying supplies in %1",_nombredest,nameBuenos]]] remoteExec ["BIS_fnc_showNotification",malos];
	{_amigo = _x;
	if (captive _amigo) then
		{
		[_amigo,false] remoteExec ["setCaptive",0,_amigo];
		_amigo setCaptive false;
		};
	{
	if ((side _x == malos) and (_x distance _posicion < distanciaSPWN)) then
		{
		if (_x distance _posicion < 300) then {_x doMove _posicion} else {_x reveal [_amigo,4]};
		};
	if ((side _x == civilian) and (_x distance _posicion < 300) and (vehicle _x == _x)) then {_x doMove position _camion};
	} forEach allUnits;
	} forEach ([300,0,_camion,"GREENFORSpawn"] call distanceUnits);
	while {(_cuenta > 0)/* or (_camion distance _posicion < 40)*/ and (dateToNumber date < _fechalimnum) and !(isNull _camion)} do
		{
		while {(_cuenta > 0) and (_camion distance _posicion < 40) and ({[_x] call canFight} count ([80,0,_camion,"GREENFORSpawn"] call distanceUnits) == count ([80,0,_camion,"GREENFORSpawn"] call distanceUnits)) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0) and (dateToNumber date < _fechalimnum) and (isNull attachedTo _camion)} do
			{
			_formato = format ["%1", _cuenta];
			{if (isPlayer _x) then {[petros,"countdown",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,_camion,"GREENFORSpawn"] call distanceUnits);
			sleep 1;
			_cuenta = _cuenta - 1;
			};
		if (_cuenta > 0) then
			{
			_cuenta = 120*_bonus;//120
			if (((_camion distance _posicion > 40) or (not([80,1,_camion,"GREENFORSpawn"] call distanceUnits)) or ({(side _x == malos) and (_x distance _camion < 50)} count allUnits != 0)) and (alive _camion)) then {{[petros,"hint","Don't get the truck far from the city center, and stay close to it, and clean all BLUFOR presence in the surroundings or count will restart"] remoteExec ["commsMP",_x]} forEach ([100,0,_camion,"GREENFORSpawn"] call distanceUnits)};
			waitUntil {sleep 1; ((_camion distance _posicion < 40) and ([80,1,_camion,"GREENFORSpawn"] call distanceUnits) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0)) or (dateToNumber date > _fechalimnum) or (isNull _camion)};
			};
		if (_cuenta < 1) exitWith {};
		};
		if ((dateToNumber date < _fechalimnum) and !(isNull _camion)) then
			{
			[petros,"hint","Supplies Delivered"] remoteExec ["commsMP",[buenos,civilian]];
			["LOG",[_taskDescription,"City Supplies",_marcador],_posicion,"SUCCEEDED","Heal"] call taskUpdate;
			{if (_x distance _posicion < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
			[5*_bonus,theBoss] call playerScoreAdd;
			if (!isMultiplayer) then {_bonus = _bonus + ((20-skillFIA)*0.1)};
			[-1*(20-skillFIA),15*_bonus,_marcador] remoteExec ["citySupportChange",2];
			[-3,0] remoteExec ["prestige",2];
			}
		else
			{
			["LOG",[_taskDescription,"City Supplies",_marcador],_posicion,"FAILED","Heal"] call taskUpdate;
			[5*_bonus,-5*_bonus,_posicion] remoteExec ["citySupportChange",2];
			[-10*_bonus,theBoss] call playerScoreAdd;
			};
	};

_ecpos = getpos _camion;
deleteVehicle _camion;
_emptybox = "Land_PaperBox_01_open_empty_F" createVehicle _ecpos;

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,"LOG"] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_camion,"GREENFORSpawn"] call distanceUnits)) or (_camion distance (getMarkerPos respawnBuenos) < 60)};

deleteVehicle _emptybox;