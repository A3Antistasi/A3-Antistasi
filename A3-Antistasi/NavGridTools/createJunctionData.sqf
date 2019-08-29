params ["_lastSegment", "_entryPoint"];

_ignoredSegments = [];
if(!(isNil "_lastSegment") && {!(isNull _lastSegment)}) then
{
  _ignoredSegments pushBack _lastSegment;
};

_segmentsToSearch = [_entryPoint];
_exitPoints = [];

while {count _segmentsToSearch > 0} do
{
    _currentRoad = _segmentsToSearch deleteAt 0;
    _connections = [_currentRoad] call findConnection;

    _connections = _connections select {(_x != _entryPoint) && {!(_x in _ignoredSegments)}};
    _connectionCount = count _connections;

    if(_connectionCount == 1) then
    {
      _exitPoints pushBackUnique _currentRoad;
    }
    else
    {
      _ignoredSegments pushBack _currentRoad;
      {
        if(!(_x in _exitPoints)) then
        {
          _segmentsToSearch pushBackUnique _x;
        };
      } forEach _connections;
    };
};

_midOfJunction = [0,0,0];
_exitCount = 0;
if(!(isNil "_lastSegment") && {!(isNull _lastSegment)}) then
{
  _midOfJunction = (getPos _lastSegment);
  _exitCount = 1;
};

{
    _midOfJunction = _midOfJunction vectorAdd (getPos _x);
    _exitCount = _exitCount + 1;
} forEach _exitPoints;


_result = [];
if(_exitCount > 0) then
{
  _midOfJunction = _midOfJunction vectorMultiply (1 / _exitCount);
  _midSegment = objNull;
  _searchRadius = 0;
  while {isNull _midSegment} do
  {
    _searchRadius = _searchRadius + 1;
    _nearRoads = _midOfJunction nearRoads _searchRadius;
    if(count _nearRoads > 0) then
    {
      _midSegment = _nearRoads select 0;
    };
  };
  _result = [_exitPoints, _midOfJunction, _ignoredSegments, _midSegment];
};
_result;
