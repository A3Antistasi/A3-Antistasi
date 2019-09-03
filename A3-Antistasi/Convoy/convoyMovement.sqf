params ["_convoyID" ,"_route", "_maxSpeed", "_units", "_sideConvoy", "_convoyType", ["_debugObject", nil]];

/*  params
*   _route : ARRAY; contains the position of the route points
*   _maxSpeed : NUMBER; contains the max speed the convoy can move in m/s
*   _units : ARRAY; contains the units and vehicles, will not be used in here, just passed
*   _sideConvoy : SIDE; contains the side of the convoy
*   _convoyType : STRING; contains one of "ATTACK", "PATROL" or "REINFORCE"
*   _debugObject : OBJECT (optional); object to visualize the convoy travel
*/

if(isNil "_route") exitWith {diag_log format ["ConvoyMovement[%1]: No route given!", _convoyID]};
if(!(_maxSpeed > 0)) exitWith {diag_log format ["ConvoyMovement[%1]: Max speed is 0 or lower, can't simulate convoy with it!", _convoyID]};

_convoyMarker = format ["convoy%1", _convoyID];



_isDebug = !(isNil "_debugObject");

_pointsCount = count _route;
_currentPos = _route select 0;


if(_isDebug) then {_debugObject setPos _currentPos;};

for "_i" from 1 to (_pointsCount - 1) do
{
  _lastPoint = _route select (_i - 1);
  _nextPoint = _route select (_i);

  _movementVector = (_lastPoint vectorFromTo _nextPoint) vectorMultiply _maxSpeed;
  _movementLength = _lastPoint vectorDistance _nextPoint;
  _currentLength = 0;

  while {_currentLength < _movementLength} do
  {
      sleep 1;
      _currentPos = _currentPos vectorAdd _movementVector;
      _currentLength = _currentLength + _maxSpeed;
      if(_currentLength < _movementLength) then
      {
        _convoyMarker setMarkerPos _currentPos;
      };


      if(_isDebug && {_currentLength < _movementLength}) then {_debugObject setPos _currentPos;};
      //Add Unit/Position detection!
  };

  _currentPos = _nextPoint;
  _convoyMarker setMarkerPos _currentPos;
  if(_isDebug) then {_debugObject setPos _currentPos;};
};

diag_log format ["ConvoyMovement[%1]: Convoy arrived at destination!", _convoyID];
diag_log format ["ConvoyMovement[%1]: WIP deleting marker as nothing happens!", _convoyID];

sleep 10;
deleteMarker _convoyMarker;
