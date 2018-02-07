if (!isServer) exitWith{};

debugperf = false;

private ["_tiempo","_marcadores","_mrkNATO","_mrkSDK","_marcador","_posicionMRK"];

_tiempo = time;

while {true} do {
//sleep 0.01;
if (time - _tiempo >= 0.5) then {sleep 0.1} else {sleep 0.5 - (time - _tiempo)};
if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 marcadores", time - _tiempo, count marcadores]};
_tiempo = time;

waitUntil {!isNil "stavros"};

_greenfor = [];
_blufor = [];
_opfor = [];

{
if (_x getVariable ["GREENFORSpawn",false]) then
	{
	_greenfor pushBack _x;
	/*
	if (isPlayer _x) then
		{
		if (!isNull (getConnectedUAV _x)) then
			{
			_greenfor pushBack (getConnectedUAV _x);
			};
		};
	*/
	}
else
	{
	if (_x getVariable ["BLUFORSpawn",false]) then
		{
		_blufor pushBack _x;
		}
	else
		{
		if (_x getVariable ["OPFORSpawn",false]) then
			{
			_opfor pushBack _x;
			};
		};
	}
} forEach allUnits;

{
_marcador = _x;

_posicionMRK = getMarkerPos (_marcador);

if (_marcador in mrkNATO) then
	{
	if !(spawner getVariable _marcador) then
		{
		if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance _posicionMRK < distanciaSPWN) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
			{
			spawner setVariable [_marcador,true,true];
			if (_marcador in ciudades) then
				{
				[_marcador] remoteExec ["createAIciudades",HCGarrisons];
				if (not(_marcador in destroyedCities)) then
					{
					if (({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[_marcador] remoteExec ["createCIV",HCciviles]};
					};
				}
			else
				{
				if (_marcador in controles) then {[_marcador] remoteExec ["createAIcontroles",HCGarrisons]} else {
				if (_marcador in aeropuertos) then {[_marcador] remoteExec ["createAIaerop",HCGarrisons]} else {
				if (((_marcador in recursos) or (_marcador in fabricas))) then {[_marcador] remoteExec ["createAIrecursos",HCGarrisons]} else {
				if ((_marcador in puestos) or (_marcador in puertos)) then {[_marcador] remoteExec ["createAIpuestos",HCGarrisons]};};};};
				};
			};
		}
	else
		{
		if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance _posicionMRK < distanciaSPWN) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
			{
			spawner setVariable [_marcador,false,true];
			};
		};
	}
else
	{
	if (_marcador in mrkSDK) then
		{
		if !(spawner getVariable _marcador) then
			{
			if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _greenfor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,true,true];
				if (_marcador in ciudades) then
					{
					//[_marcador] remoteExec ["createAIciudades",HCGarrisons];
					if (not(_marcador in destroyedCities)) then
						{
						if (({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[_marcador] remoteExec ["createCIV",HCciviles]};
						};
					};
				if (_marcador in puestosFIA) then {[_marcador] remoteExec ["createFIApuestos2",HCGarrisons]} else {if (not(_marcador in controles)) then {[_marcador] remoteExec ["createSDKGarrisons",HCGarrisons]}};
				};
			}
		else
			{
			if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _blufor == 0) and ({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _greenfor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,false,true];
				};
			};
		}
	else
		{
		if !(spawner getVariable _marcador) then
			{
			if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _opfor > 0) or ({if ((_x distance _posicionMRK < distanciaSPWN) and (isPlayer _x)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,true,true];
				if (_marcador in controles) then {[_marcador] remoteExec ["createAIcontroles",HCGarrisons]} else {
				if (_marcador in aeropuertos) then {[_marcador] remoteExec ["createAIaerop",HCGarrisons]} else {
				if (((_marcador in recursos) or (_marcador in fabricas))) then {[_marcador] remoteExec ["createAIrecursos",HCGarrisons]} else {
				if ((_marcador in puestos) or (_marcador in puertos)) then {[_marcador] remoteExec ["createAIpuestos",HCGarrisons]};};};};
				};
			}
		else
			{
			if (({if (_x distance _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor == 0) and ({if ((isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)) exitWith {1}} count _opfor == 0) and ({if ((_x distance _posicionMRK < distanciaSPWN) and (isPlayer _x)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,false,true];
				};
			};
		};
	};
} forEach marcadores;

};