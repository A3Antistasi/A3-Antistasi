params ["_pos"];

/*
hint format ["Getting main marker for pos %1" _pos];
sleep 2;
*/

_x = _pos select 0;
_y = _pos select 1;

_x = floor (_x / 1000);
_y = floor (_y / 1000);

_markerName = format ["%1/%2", _x, _y];

_markerName;
