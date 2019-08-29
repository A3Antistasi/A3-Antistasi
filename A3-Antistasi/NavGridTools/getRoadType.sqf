params ["_road"];

//This does not work currently always return 2
/*
private ["_surfaces", "_relPos"];
_surfaces = [];
_surfaces pushBack (surfaceType (getPos _road));

for "_i" from 1 to 7 do
{
  for "_j" from 0 to 7 do
  {
    _relPos = _road getRelPos [_i, 45 * _j];
    if(isOnRoad _relPos) then
    {
      _surfaces pushBackUnique (surfaceType _relPos);
    };
  };
};

_hasDirt = false;
_hasConcrete = false;
_hasTarmac = false;

{
   _string =  _x select [1, count _x];
   _string = toLower _string;
   //if((_string find "dirt") != -1) then {_hasDirt = true};
   if((_string find "concrete") != -1) then {_hasConcrete = true};
   if((_string find "tarmac") != -1) then {_hasTarmac = true;};
} forEach _surfaces;

_roadType = 2;
if(!_hasDirt && _hasConcrete) then {_roadType = 1};
if(_hasTarmac) then {_roadType = 3};

hint str _surfaces;
*/
_roadType = 2;

_roadType;
