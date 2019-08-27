[] spawn
{
  _worldSize = worldSize / 1.41;


  _markerPos = getMarkerPos "roadMarker";

  _nearestRoad = _markerPos nearRoads 500;
  _nearRoad = _nearestRoad select 0;

  _roadPos = getPosWorld _nearRoad;

  _firstMarker = createMarker [format ["%1road%2", random 100, random 10000], _roadPos];
  _firstMarker setMarkerShape "ICON";
  _firstMarker setMarkerType "mil_dot";
  _firstMarker setMarkerAlpha 1;

  _roadsToHandle = roadsConnectedTo _nearRoad;
  {
    _roadsToHandle pushBack _x;
  } forEach ((getPos _nearRoad) nearRoads 50);

  _firstMarker setMarkerText format ["Con %1", count _roadsToHandle];

  _roadsDone = [_nearRoad];

  _counter = 0;

  while {count _roadsToHandle > 0} do
  {
    _nextRoad = _roadsToHandle deleteAt 0;
    while {(count _roadsToHandle > 0) &&  {_nextRoad in _roadsDone}} do
    {
      _nextRoad = _roadsToHandle deleteAt 0;
    };
    if(_nextRoad in _roadsDone && count _roadsToHandle == 0) exitWith {};
    _connectedRoads = roadsConnectedTo _nextRoad;

    _marker = createMarker [format ["%1road%2", random 100, random 10000], getPos _nextRoad];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "mil_dot";
    _marker setMarkerAlpha 1;

    {
      if(!(_x in _roadsDone) && {!(_x in _roadsToHandle)}) then
      {
        _roadsToHandle pushBack _x;
      };
    } forEach _connectedRoads;

    _roadsDone pushBack _nextRoad;

    if(_counter < 15) then
    {
      _counter = _counter + 1;
    }
    else
    {
      _counter = 0;
      sleep 0.01;
    };
  };
};
