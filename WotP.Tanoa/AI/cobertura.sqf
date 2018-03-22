private ["_unit","_enemigo","_small","_big","_objeto","_posAtras","_objetos","_roads","_tipo","_p1","_p2","_ancho","_grueso","_alto","_posEnemigo","_pos"];
_unit = _this select 0;
_enemigo = _this select 1;
_small= [];
_big = [];
_objeto = objNull;

_posAtras = (position _unit) getPos [5,_enemigo getDir _unit];
_objetos = nearestObjects [_posAtras, [], 30];
_roads = _posAtras nearRoads 30;
{
_tipo = typeOf _x;
if !(_tipo in ["#crater","#crateronvehicle","#soundonvehicle","#particlesource","#lightpoint","#slop","#mark","HoneyBee","Mosquito","HouseFly","FxWindPollen1","ButterFly_random","Snake_random_F","Rabbit_F","FxWindGrass2","FxWindLeaf1","FxWindGrass1","FxWindLeaf3","FxWindLeaf2"]) then
	{
	if (!(_x isKindOf "Man") && {!(_x isKindOf "Bird")} && {!(_x isKindOf "BulletCore")} && {!(_x isKindOf "Grenade")} && {!(_x isKindOf "WeaponHolder")} && {(_x distance _enemigo > 5)}) then
		{
		_p1 = (boundingBoxReal _x) select 0;
		_p2 = (boundingBoxReal _x) select 1;
		_ancho = abs ((_p2 select 0) - (_p1 select 0));
		_grueso = abs ((_p2 select 1) - (_p1 select 1));
		_alto = abs ((_p2 select 2) - (_p1 select 2));
		if (_ancho > 2 && _grueso > 0.5 && _alto > 2) then
			{
			if (_tipo isEqualTo "") then
				{
				_small pushback _x
				}
			else
				{
				_big pushback _x;
				};
			}
		};
	};
} foreach ((_objetos) - (_roads));

if ((count _big == 0) and (count _small == 0)) exitWith {[]};

if !(_big isEqualTo []) then {_objeto = [_big,_unit] call BIS_fnc_nearestPosition} else {_objeto = [_small,_unit] call BIS_fnc_nearestPosition};

_posEnemigo = position _enemigo;
_pos = _posEnemigo getPos [(_objeto distance _posEnemigo) + 2, _posEnemigo getDir _objeto];
_pos