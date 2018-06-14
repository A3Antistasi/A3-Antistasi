private ["_marcador","_posicion","_size","_buildings"];

_marcador = _this select 0;

_posicion = getMarkerPos _marcador;
_size = [_marcador] call sizeMarker;

_buildings = _posicion nearobjects ["house",_size];

{
if (random 100 < 70) then
	{
	for "_i" from 1 to 7 do
		{
		_x sethit [format ["dam%1",_i],1];
		_x sethit [format ["dam %1",_i],1];
		};
	}
} forEach _buildings;

[_marcador,false] spawn apagon;