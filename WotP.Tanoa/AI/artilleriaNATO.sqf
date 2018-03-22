if (!isServer) exitWith{};

private ["_marcador","_pos","_equis","_cuenta","_y"];

_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_equis = _pos select 0;
_y = _pos select 1;
_cuenta = 0;

while {({(_x distance _pos < 300) and (side _x == buenos)} count allUnits == 0) and (_cuenta < 50) and (not(_marcador in forcedSpawn))} do
	{
	_cuenta = _cuenta + 1;
	_rndmslp = 5 + (random 5);
	sleep _rndmslp;
	_shell1 = "Sh_82mm_AMOS" createVehicle [_equis + (150 - (random 300)),_y + (150 - (random 300)),200];
	_shell1 setVelocity [0,0,-50];
	};

