if (!isServer) exitWith {};

private ["_markerX","_lado","_salir","_enemy1","_enemy2","_winner"];

_markerX = _this select 0;
_lado = _this select 1;
if ((isNil "_markerX") or (isNil "_lado")) exitWith {};
waitUntil {!zoneCheckInProgress};
zoneCheckInProgress = true;
_salir = true;
_enemy1 = "";
_enemy2 = "";

if ((_lado == teamPlayer) and (lados getVariable [_markerX,sideUnknown] == teamPlayer)) then
	{
	_salir = false;
	_enemy1 = ;
	_enemy2 = Occupants;
	}
else
	{
	if ((_lado == Occupants) and (lados getVariable [_markerX,sideUnknown] == Occupants)) then
		{
		_salir = false;
		_enemy1 = ;
		_enemy2 = teamPlayer;
		}
	else
		{
		if ((_lado == ) and (lados getVariable [_markerX,sideUnknown] == )) then
			{
			_salir = false;
			_enemy1 = Occupants;
			_enemy2 = teamPlayer;
			};
		};
	};

if (_salir) exitWith {zoneCheckInProgress = false};
_salir = true;

if ({((_x getVariable ["spawner",false]) and ((side group _x) in [_enemy1,_enemy2])) and ([_x,_markerX] call A3A_fnc_canConquer)} count allUnits > 3*({([_x,_markerX] call A3A_fnc_canConquer) and (_x getVariable ["markerX",""] == _markerX)} count allUnits)) then
	{
	_salir = false;
	};
if (_salir) exitWith {zoneCheckInProgress = false};

_winner = _enemy1;
if ({(_x getVariable ["spawner",false]) and (side group _x == _enemy1) and ([_x,_markerX] call A3A_fnc_canConquer)} count allUnits <= {(_x getVariable ["spawner",false]) and (side group _x == _enemy2) and ([_x,_markerX] call A3A_fnc_canConquer)} count allUnits) then {_winner = _enemy2};

[_winner,_markerX] remoteExec ["A3A_fnc_markerChange",2];

waitUntil {sleep 1; lados getVariable [_markerX,sideUnknown] == _winner};
zoneCheckInProgress = false;
