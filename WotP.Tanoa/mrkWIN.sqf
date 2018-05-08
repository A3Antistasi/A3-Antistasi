private ["_bandera","_pos","_marcador","_posicion","_size","_powerpl","_arevelar"];

_bandera = _this select 0;
_jugador = objNull;
if (count _this > 1) then {_jugador = _this select 1};

if ((player != _jugador) and (!isServer)) exitWith {};

_pos = getPos _bandera;
_marcador = [marcadores,_pos] call BIS_fnc_nearestPosition;
if (lados getVariable [_marcador,sideUnknown] == buenos) exitWith {};
_posicion = getMarkerPos _marcador;
_size = [_marcador] call sizeMarker;

if ((!isNull _jugador) and (captive _jugador)) exitWith {hint "You cannot Capture the Flag while in Undercover Mode"};
if ((_marcador in aeropuertos) and (tierWar < 3)) exitWith {hint "You cannot take Airports until you reach War Level 3"};
if (!isNull _jugador) then
	{
	if (_size > 300) then {_size = 300};
	_arevelar = [];
	{
	if (((side _x == malos) or (side _x == muyMalos)) and ([_x,_marcador] call canConquer)) then {_arevelar pushBack _x};
	} forEach allUnits;
	if (player == _jugador) then
		{
		_jugador playMove "MountSide";
		sleep 8;
		_jugador playMove "";
		{player reveal _x} forEach _arevelar;
		//[_marcador] call intelFound;
		};
	};

if (!isServer) exitWith {};

{
if (isPlayer _x) then
	{
	[5,_x] remoteExec ["playerScoreAdd",_x];
	[_marcador] remoteExec ["intelFound",_x];
	if (captive _x) then {[_x,false] remoteExec ["setCaptive"]};
	}
} forEach ([_size,0,_posicion,"GREENFORSpawn"] call distanceUnits);

_lado = if (lados getVariable [_marcador,sideUnknown] == malos) then {malos} else {muyMalos};
["GREENFORSpawn",_marcador] call markerChange;
[[_marcador,_lado],"patrolCA"] remoteExec ["scheduler",2];
