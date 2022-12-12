#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params ["_marker"];

/* Unlocks all locked vehicle slots of a marker
*****/

_spawns = spawner getVariable [format ["%1_spawns", _marker], [[],[],[],[]]];
if(_spawns isEqualTo [[],[],[],[]]) exitWith
{
    Error_1("Marker %1 has no spawn places defined!", _marker);
};

DebugArray("Spawn places for "+_marker, _spawns);

for "_i" from 0 to 3 do
{
  _places = _spawns select _i;
  {
    if(_x select 1) then
    {
      _x set [1, false];
    }
  } forEach _places;
};
