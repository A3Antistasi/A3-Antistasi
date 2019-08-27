[] spawn
{
  _startPos = getMarkerPos "roadMarker";

  _possibleStarts = _startPos nearRoads 50;
  _startSegment = nil;
  {
      _connected = roadsConnectedTo _x;
      if(count _connected > 2) exitWith {_startSegment = _x};
  } forEach _possibleStarts;

  if(isNil "_startSegment") exitWith
  {
    //diag_log "Could not find suitable start segment, segment has to be a junction!";
    hint "No segment was a junction, try another position!";
  };

  _navSegments = [];
  _openStartSegments = [[_startSegment, nil]];
  private ["_currentSegment", "_lastNavSegment", "_currentIgnored" ,"_connected", "_found"];

  _outerLoop = 0;
  _innerLoop = 0;
  _debugText = "";

  while {count _openStartSegments > 0} do
  {
    _outerLoop = _outerLoop + 1;
    _startSegment = _openStartSegments deleteAt 0;
    _currentIgnored = [_startSegment select 1];
    _lastNavSegment = _startSegment select 1;
    _currentSegment = _startSegment select 0;

    _innerLoop = 0;
    while {!(isNil "_currentSegment")} do
    {
      _innerLoop = _innerLoop + 1;
      _currentIgnored pushBack _currentSegment;

      _connected = roadsConnectedTo _currentSegment;

      _firstFound = count _connected;

      for "_i" from 0 to 7 do
      {
        _relPos = _currentSegment getRelPos [5, 45 * _i];
        _road = roadAt _relPos;
        if(!(isNull _road)) then
        {
          _connected pushBackUnique _road;
        };
        _relPos = _currentSegment getRelPos [7.5, 45 * _i];
        _road = roadAt _relPos;
        if(!(isNull _road)) then
        {
          _connected pushBackUnique _road;
        };
      };

      _secondFound = count _connected;

      _connected = _connected select {!(_x in _currentIgnored) && {_x != _currentSegment && {isNil "_lastNavSegment" || {_x != _lastNavSegment}}}};

      _lastFound = count _connected;

      //hint format ["First %1\nSecond %2\nLast %3\n Roads: %4", _firstFound, _secondFound, _lastFound, str _connected];

      if(count _connected > 1 || count _connected == 0) then
      {
        _debugText = "Way 1";
        if(!(_currentSegment in _navSegments)) then
        {
          _debugText = "Way 3";
          _navSegments pushBack _currentSegment;

          _marker = createMarker [format ["%1road%2", random 100, random 10000], getPos _currentSegment];
          _marker setMarkerShape "ICON";
          _marker setMarkerType "mil_box";
          _marker setMarkerAlpha 1;
          _marker setMarkerText (str (count _connected));

          _connected = _connected select {!(_x in _navSegments)};
          {
              _openStartSegments pushBack [_x, _currentSegment];
              _marker = createMarker [format ["%1road%2", random 100, random 10000], getPos _x];
              _marker setMarkerShape "ICON";
              _marker setMarkerType "mil_dot";
              _marker setMarkerColor "ColorRed";
              _marker setMarkerAlpha 1;
          } forEach _connected;
        };
        _currentSegment = nil;
      }
      else
      {
        if(!(_currentSegment in _navSegments)) then
        {
          _debugText = "Way 2";
          _marker = createMarker [format ["%1road%2", random 100, random 10000], getPos _currentSegment];
          _marker setMarkerShape "ICON";
          _marker setMarkerType "mil_dot";
          _marker setMarkerColor "ColorGreen";
          _marker setMarkerAlpha 1;
          _currentSegment = _connected select 0;
          _marker spawn
          {
            sleep 5;
            deleteMarker _this;
          };
        }
        else
        {
          _currentSegment = nil;
        };
      };
      hint format ["Open segments: %1\n Inner Loop: %2\n Outer Loop: %3\n Way taken: %4", str (count _openStartSegments), _innerLoop, _outerLoop, _debugText];
      //sleep 0.15;
    };
  };
};
