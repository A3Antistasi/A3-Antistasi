params ["_route", "_maxSpeed", "_units", "_sideConvoy", "_convoyType" ["_debugObject", nil]];

/*  params
*   _route : ARRAY; contains the position of the route points
*   _maxSpeed : NUMBER; contains the max speed the convoy can move in m/s
*   _units : ARRAY; contains the units and vehicles, will not be used in here, just passed
*   _sideConvoy : SIDE; contains the side of the convoy
*   _convoyType : STRING; contains one of "ATTACK", "PATROL" or "REINFORCE"
*   _debugObject : OBJECT (optional); object to visualize the convoy travel
*
*   returns
*   nothing
*/

if(isNil "_route") exitWith {diag_log "ConvoyMovement: No route given!"};
if(!(_maxSpeed > 0)) exitWith {diag_log "ConvoyMovement: Max speed is 0 or lower, can't simulate convoy with it!"};

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

      if(_isDebug && {_currentLength < _movementLength}) then {_debugObject setPos _currentPos;};
      //Add Unit/Position detection!
  };

  _currentPos = _nextPoint;
  if(_isDebug) then {_debugObject setPos _currentPos;};
};

diag_log "ConvoyMovement: Convoy arrived at destination!";
