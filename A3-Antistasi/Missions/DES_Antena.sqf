if (!isServer and hasInterface) exitWith{};

private ["_antena","_posicion","_tiempolim","_marcador","_nombredest","_mrkfin","_tsk"];

_antena = _this select 0;
_marcador = [marcadores,_antena] call BIS_fnc_nearestPosition;

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
			["DES",[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _contacto,"FAILED"] call taskUpdate;
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

_nombredest = [_marcador] call localizar;
_posicion = getPos _antena;

_tiempolim = if (_dificil) then {30} else {120};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_mrkfin = createMarker [format ["DES%1", random 100], _posicion];
_mrkfin setMarkerShape "ICON";

[[buenos,civilian],"DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,nameMalos],"Destroy Radio Tower",_mrkfin],_posicion,false,0,true,"Destroy",true] call BIS_fnc_taskCreate;
misiones pushBack ["DES","CREATED"]; publicVariable "misiones";
waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _antena) or (not(lados getVariable [_marcador,sideUnknown] == malos))};

_bonus = if (_dificil) then {2} else {1};

if (dateToNumber date > _fechalimnum) then
	{
	["DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,nameMalos],"Destroy Radio Tower",_mrkfin],_posicion,"FAILED","Destroy"] call taskUpdate;
	//[5,0,_posicion] remoteExec ["citySupportChange",2];
	[-10*_bonus,theBoss] call playerScoreAdd;
	[-3,0] remoteExec ["prestige",2]
	}
else
	{
	sleep 15;
	["DES",[format ["We need to destroy or take a Radio Tower in %1. This will interrupt %4 Propaganda Nework. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,nameMalos],"Destroy Radio Tower",_mrkfin],_posicion,"SUCCEEDED","Destroy"] call taskUpdate;
	//[-5,0,_posicion] remoteExec ["citySupportChange",2];
	[5,-5] remoteExec ["prestige",2];
	[600*_bonus] remoteExec ["timingCA",2];
	{if (_x distance _posicion < 500) then {[10*_bonus,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5*_bonus,theBoss] call playerScoreAdd;
	[3,0] remoteExec ["prestige",2]
	};

deleteMarker _mrkfin;

_nul = [1200,"DES"] spawn borrarTask;
