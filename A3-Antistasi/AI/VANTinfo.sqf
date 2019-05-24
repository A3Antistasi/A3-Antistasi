private ["_veh","_marcador","_posicion","_grupos","_knownX","_grupo","_lider"];

_veh = _this select 0;
_marcador = _this select 1;
_lado = _this select 2;

_posicion = getMarkerPos _marcador;

_enemiesS = if (_lado == muyMalos) then {malos} else {muyMalos};

while {alive _veh} do
	{
	_knownX = [];
	_grupos = [];
	_enemigos = [distanceSPWN,0,_posicion,_lado] call A3A_fnc_distanceUnits;
	sleep 60;
	_grupos = allGroups select {(leader _x in _enemigos) and ((vehicle leader _x) != (leader _x))};
	_knownX = allUnits select {((side _x == buenos) or (side _x == _enemiesS)) and (alive _x) and (_x distance _posicion < 500)};
	{
	_grupo = _x;
		{
		_grupo reveal [_x,1.4];
		} forEach _knownX;
	} forEach _grupos;
	};