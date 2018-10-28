if (!isServer and hasInterface) exitWith {};

private ["_marcador","_destino","_origen","_grupos","_soldados","_vehiculos","_size","_grupo","_camion","_tam","_roads","_road","_pos"];

_marcador = _this select 0;
if (not(_marcador in smallCAmrk)) exitWith {};

_destino = getMarkerPos _marcador;
_origen = getMarkerPos respawnBuenos;

_grupos = [];
_soldados = [];
_vehiculos = [];

_size = [_marcador] call A3A_fnc_sizeMarker;

_divisor = 50;

if (_marcador in aeropuertos) then {_divisor = 100};

_size = round (_size / _divisor);

if (_size == 0) then {_size = 1};

_tiposGrupo = [gruposSDKmid,gruposSDKAT,gruposSDKSquad,gruposSDKSniper];

while {(_size > 0)} do
	{
	_tipoGrupo = selectRandom _tiposGrupo;
	_formato = [];
	{
	if (random 20 <= skillFIA) then {_formato pushBack (_x select 1)} else {_formato pushBack (_x select 0)};
	} forEach _tipoGrupo;
	_grupo = [_origen, buenos, _formato,false,true] call A3A_fnc_spawnGroup;
	if !(isNull _grupo) then
		{
		_grupos pushBack _grupo;
		{[_x] spawn A3A_fnc_FIAinit; _soldados pushBack _x} forEach units _grupo;
		_Vwp1 = _grupo addWaypoint [_destino, 0];
		_Vwp1 setWaypointType "MOVE";
		_Vwp1 setWaypointBehaviour "AWARE";
		sleep 30;
		};
	_size = _size - 1;
	};

waitUntil {sleep 1;((not(_marcador in smallCAmrk)) or (lados getVariable [_marcador,sideUnknown] == malos) or (lados getVariable [_marcador,sideUnknown] == muyMalos))};
/*
{_vehiculo = _x;
waitUntil {sleep 1; {_x distance _vehiculo < distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F")) == 0};
deleteVehicle _vehiculo;
} forEach _vehiculos;*/
{_soldado = _x;
waitUntil {sleep 1; {_x distance _soldado < distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F")) == 0};
deleteVehicle _soldado;
} forEach _soldados;
{deleteGroup _x} forEach _grupos;