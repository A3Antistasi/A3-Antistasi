_marcador = _this select 0;
_posMarker = getMarkerPos _marcador;

_arrayCities = (citiesX select {getMarkerPos _x distance _posMarker < 3000}) - [_marcador];
/*
for "_i" from 0 to (count citiesX - 1) do
	{
	if ((getMarkerPos (citiesX select _i)) distance _posMarker < 3000) then {_arrayCities set [count _arrayCities,citiesX select _i]};
	};

_arrayCities = _arrayCities - [_marcador];
*/
_arrayCities