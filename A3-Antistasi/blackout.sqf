private ["_markerX","_damage","_lamps","_onoff","_positionX","_tam","_size"];

_markerX = _this select 0;
_onoff = _this select 1;

_positionX = getMarkerPos _markerX;
_damage = 0;
if (not _onoff) then {_damage = 0.95;};

_tam = markerSize _markerX;
_size = _tam select 0;

for "_i" from 0 to ((count lamptypes) -1) do
    {
    _lamps = _positionX nearObjects [lamptypes select _i,_size];
    {sleep 0.3; _x setDamage _damage} forEach _lamps;
    };
    //123