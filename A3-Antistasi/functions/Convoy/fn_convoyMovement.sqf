params ["_convoyID" ,"_route", "_maxSpeed", "_units", "_sideConvoy", "_convoyType", "_isAir", ["_debugObject", nil]];

/*  Simulates the movement of the convoy
*   Params:
*     _convoyID : NUMBER; the unique convoy ID
*     _route : ARRAY; contains the position of the route points
*     _maxSpeed : NUMBER; contains the max speed the convoy can move in m/s
*     _units : ARRAY; contains the units and vehicles, will not be used in here, just passed
*     _sideConvoy : SIDE; contains the side of the convoy
*     _convoyType : STRING; contains one of "ATTACK", "PATROL" or "REINFORCE"
*     _debugObject : OBJECT (optional); object to visualize the convoy travel
*   Returns:
      Nothing
*/

if(isNil "_route") exitWith {diag_log format ["ConvoyMovement[%1]: No route given!", _convoyID]};
if(!(_maxSpeed > 0)) exitWith {diag_log format ["ConvoyMovement[%1]: Max speed is 0 or lower, can't simulate convoy with it!", _convoyID]};

_convoyMarker = format ["convoy%1", _convoyID];
_maxSpeed = _maxSpeed * 0.8; //Only drive with 80% of max speed


_isDebug = !(isNil "_debugObject");

_pointsCount = count _route;
_currentPos = _route select 0;

_isSimulated = true;

if(_isDebug) then {_debugObject setPos _currentPos;};

for "_i" from 1 to (_pointsCount - 1) do
{
  _lastPoint = _route select (_i - 1);
  _nextPoint = _route select (_i);

  _movementVector = (_lastPoint vectorFromTo _nextPoint) vectorMultiply _maxSpeed;
  _movementLength = _lastPoint vectorDistance _nextPoint;
  _currentLength = 0;

  while {_isSimulated && {_currentLength < _movementLength}} do
  {
      sleep 1;
      _currentPos = _currentPos vectorAdd _movementVector;
      _currentLength = _currentLength + _maxSpeed;
      if(_currentLength < _movementLength) then
      {
        _convoyMarker setMarkerPos _currentPos;
      };

      if(_isDebug && {_currentLength < _movementLength}) then {_debugObject setPos _currentPos;};

      /*
      _nearMarker = markersX select {(sidesX getVariable [_x, sideUnknown] != _sideConvoy) && {getMarkerPos _x distance _currentPos < 150}};
      if(count _nearMarker > 0) then
      {
        if((_nearMarker select 0) distance _currentPos < 75 || !((_nearMarker select 0) in controlsX)) then
        {
          //Drove into an enemy position, spawn fight
        }
      };
      */
      //Currently only triggered by teamPlayer units!
      if([distanceSPWN, 1, _currentPos, teamPlayer] call A3A_fnc_distanceUnits) then
      {
        _isSimulated = false;

        hint "Spawning in land convoy";
        // - 2 as it is the last point on a street (or maybe not needs testing)
        [_currentPos, _nextPoint, _units, (_route select (_pointsCount - 1)), _sideConvoy, _convoyType, _maxSpeed] call A3A_fnc_spawnConvoy;

        if(!_isAir) then
        {
          //Not sure if needed
        };
      };
  };

  _currentPos = _nextPoint;
  _convoyMarker setMarkerPos _currentPos;
  if(_isDebug) then {_debugObject setPos _currentPos;};
};

if(!_isSimulated) exitWith {};

diag_log format ["ConvoyMovement[%1]: Convoy arrived at destination!", _convoyID];

[_convoyID, (_route select 0), (_route select (_pointsCount - 1)), _units, _sideConvoy, _convoyType] spawn A3A_fnc_onConvoyArrival;

sleep 10;
deleteMarker _convoyMarker;
