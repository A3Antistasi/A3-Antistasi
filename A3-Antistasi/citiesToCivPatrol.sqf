_marcador = _this select 0;
_posMarcador = getMarkerPos _marcador;

_arrayCities = (ciudades select {getMarkerPos _x distance _posMarcador < 3000}) - [_marcador];
/*
for "_i" from 0 to (count ciudades - 1) do
	{
	if ((getMarkerPos (ciudades select _i)) distance _posMarcador < 3000) then {_arrayCities set [count _arrayCities,ciudades select _i]};
	};

_arrayCities = _arrayCities - [_marcador];
*/
_arrayCities