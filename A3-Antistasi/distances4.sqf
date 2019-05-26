if (!isServer) exitWith{};

debugperf = false;

private ["_tiempo","_markersX","_marcador","_positionMRK"];

_timeX = time;

while {true} do {
//sleep 0.01;
if (time - _timeX >= 0.5) then {sleep 0.1} else {sleep 0.5 - (time - _timeX)};
if (debugperf) then {hint format ["timeX transcurrido: %1 para %2 markersX", time - _timeX, count markersX]};
_timeX = time;

waitUntil {!isNil "theBoss"};

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

_positionMRK = getMarkerPos (_marcador);

if (lados getVariable [_marcador,sideUnknown] == malos) then
	{
	if (spawner getVariable _marcador != 0) then
		{
		if (spawner getVariable _marcador == 2) then
			{
			if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,0,true];
				if (_marcador in citiesX) then
					{
					if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createAICities"] call A3A_fnc_scheduler};
					if (not(_marcador in destroyedCities)) then
						{
						if (({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
						};
					}
				else
					{
					if (_marcador in controlsX) then {[[_marcador],"A3A_fnc_createAIcontrols"] call A3A_fnc_scheduler} else {
					if (_marcador in airportsX) then {[[_marcador],"A3A_fnc_createAIAirplane"] call A3A_fnc_scheduler} else {
					if (((_marcador in recursos) or (_marcador in fabricas))) then {[[_marcador],"A3A_fnc_createAIResources"] call A3A_fnc_scheduler} else {
					if ((_marcador in puestos) or (_marcador in puertos)) then {[[_marcador],"A3A_fnc_createAIOutposts"] call A3A_fnc_scheduler};};};};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,0,true];
				if (isMUltiplayer) then
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
					}
				else
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
					};
				}
			else
				{
				if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
					{
					spawner setVariable [_marcador,2,true];
					};
				};
			};
		}
	else
		{
		if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
			{
			spawner setVariable [_marcador,1,true];
			if (isMUltiplayer) then
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
					}
				else
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
					};
			};
		};
	}
else
	{
	if (lados getVariable [_marcador,sideUnknown] == buenos) then
		{
		if (spawner getVariable _marcador != 0) then
			{
			if (spawner getVariable _marcador == 2) then
				{
				if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _greenfor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (_marcador in citiesX) then
						{
						//[_marcador] remoteExec ["A3A_fnc_createAICities",HCGarrisons];
						if (not(_marcador in destroyedCities)) then
							{
							if (({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
							};
						};
					if (_marcador in outpostsFIA) then {[[_marcador],"A3A_fnc_createFIAOutposts2"] call A3A_fnc_scheduler} else {if (not(_marcador in controlsX)) then {[[_marcador],"A3A_fnc_createSDKGarrisons"] call A3A_fnc_scheduler}};
					};
				}
			else
				{
				if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2) or (_marcador in forcedSpawn)) exitWith {1}} count _greenfor > 0)) then
					{
					spawner setVariable [_marcador,0,true];
					if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
						};
					}
				else
					{
					if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _greenfor == 0) and (not(_marcador in forcedSpawn))) then
						{
						spawner setVariable [_marcador,2,true];
						};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _greenfor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,1,true];
				if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
						};
				};
			};
		}
	else
		{
		if (spawner getVariable _marcador != 0) then
			{
			if (spawner getVariable _marcador == 2) then
				{
				if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (_marcador in controlsX) then {[[_marcador],"A3A_fnc_createAIcontrols"] call A3A_fnc_scheduler} else {
					if (_marcador in airportsX) then {[[_marcador],"A3A_fnc_createAIAirplane"] call A3A_fnc_scheduler} else {
					if (((_marcador in recursos) or (_marcador in fabricas))) then {[[_marcador],"A3A_fnc_createAIResources"] call A3A_fnc_scheduler} else {
					if ((_marcador in puestos) or (_marcador in puertos)) then {[[_marcador],"A3A_fnc_createAIOutposts"] call A3A_fnc_scheduler};};};};
					};
				}
			else
				{
				if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
						};
					}
				else
					{
					if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
						{
						spawner setVariable [_marcador,2,true];
						};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,1,true];
				if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
						};
				};
			};
		};
	};
} forEach markersX;

};
