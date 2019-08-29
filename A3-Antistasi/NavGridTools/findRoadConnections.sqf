params ["_currentRoad"];

//Get all connected
_connected = roadsConnectedTo _currentRoad;

_nearRoads = (getPos _currentRoad) nearRoads 10;
{
    if(_x != _currentRoad) then
    {
      _connected pushBackUnique _x;
    };
} forEach _nearRoads;

for "_i" from 0 to 15 do
{
  _relPos = _currentRoad getRelPos [5, 22.5 * _i];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
  _relPos = _currentRoad getRelPos [7.5, (22.5 * _i) + (22.5 / 3)];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
  _relPos = _currentRoad getRelPos [10, (22.5 * _i) + ( 2 * 22.5 / 3)];
  _road = roadAt _relPos;
  if(!(isNull _road) && {_road != _currentRoad}) then
  {
    _connected pushBackUnique _road;
  };
};


_connected;
