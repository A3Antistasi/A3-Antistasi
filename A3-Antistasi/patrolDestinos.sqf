private ["_marcadores","_array","_pos","_marcador"];

_marcadores = _this select 0;

_array = _marcadores - controles;

_posHQ = getMarkerPos respawnBuenos;

for "_i" from 0 to (count _marcadores) - 1 do
	{
	_marcador = _marcadores select _i;
	_pos = getMarkerPos _marcador;
	if (_posHQ distance _pos > 3000) then {_array = _array - [_marcador]};
	};
_array