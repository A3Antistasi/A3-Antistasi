params ["_road"];

//Sweet but useless, every road is 10 meters width

[0, 180,10,10,5,1,0.5,0.1] params ["_angleOne", "_angleTwo", "_distanceOne", "_distanceTwo", "_largeAngleStep" ,"_smallAngleStep", "_largeDistanceStep", "_smallDistanceStep"];
private ["_turnedAngle", "_positive", "_error", "_currentStep", "_abort", "_counter"];

_checkPosOne = _road getRelPos [_distanceOne, _angleOne];
_checkPosTwo = _road getRelPos [_distanceOne, _angleTwo];

if(roadAt _checkPosOne == _road || {roadAt _checkPosTwo == _road}) then
{
  _angleOne = 90;
  _angleTwo = 270;
  _checkPosOne = _road getRelPos [_distanceOne, _angleOne];
  _checkPosTwo = _road getRelPos [_distanceOne, _angleTwo];
};

["mil_dot", _checkPosOne, "ColorBlue"] call createNavMarker;
["mil_dot", _checkPosTwo, "ColorBlue"] call createNavMarker;

//Close in on distance
//Pos one first
_currentStep = _largeDistanceStep;
_abort = false;
_counter = 0;
while {!_abort && _counter < 20} do
{
  _counter = _counter + 1;
  if(roadAt (_road getRelPos [(_distanceOne - _currentStep), _angleOne]) != _road) then
  {
    _distanceOne = _distanceOne - _currentStep;
    if(_distanceOne < 0) exitWith {_error = true};
    //Draw for debug
    _checkPosOne = _road getRelPos [_distanceOne, _angleOne];
    _arrow = "Sign_Arrow_Blue_F" createVehicle _checkPosOne;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosOne;
  }
  else
  {
    if(_currentStep == _largeDistanceStep) then
    {
      _currentStep = _smallDistanceStep;
    }
    else
    {
      _abort = true;
    };
  };
};

//Pos two next
_currentStep = _largeDistanceStep;
_abort = false;
_counter = 0;
while {!_abort && _counter < 20} do
{
  _counter = _counter + 1;
  if(roadAt (_road getRelPos [(_distanceTwo - _currentStep), _angleTwo]) != _road) then
  {
    _distanceTwo = _distanceTwo - _currentStep;
    if(_distanceTwo < 0) exitWith {_error = true};
    //Draw for debug
    _checkPosTwo = _road getRelPos [_distanceTwo, _angleTwo];
    _arrow = "Sign_Arrow_Blue_F" createVehicle _checkPosTwo;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosTwo;
  }
  else
  {
    if(_currentStep == _largeDistanceStep) then
    {
      _currentStep = _smallDistanceStep;
    }
    else
    {
      _abort = true;
    };
  };
};


if(roadAt (_road getRelPos [_distanceOne, (_angleOne + 2 *_largeAngleStep)]) == _road) then
{
  _smallAngleStep = _smallAngleStep * -1;
  _largeAngleStep = _largeAngleStep * -1;
};
hint format ["L %1 S %2", _largeAngleStep, _smallAngleStep];

_currentStep = _largeAngleStep;
_abort = false;
_turnedAngle = 0;
_counter = 0;
while {!_abort && _counter < 20} do
{
  _counter = _counter + 1;
  if((!(isOnRoad _checkPosOne) || {roadAt _checkPosOne != _road}) && {!(isOnRoad _checkPosTwo) || {roadAt _checkPosTwo != _road}}) then
  {
    _angleOne = _angleOne + _currentStep;
    if(_angleOne < 0) exitWith {_error = true};

    _angleTwo = _angleTwo + _currentStep;
    if(_angleTwo < 0) exitWith {_error = true};

    _turnedAngle = _turnedAngle - _currentStep;

    _checkPosOne = _road getRelPos [_distanceOne, _angleOne];
    _checkPosTwo = _road getRelPos [_distanceTwo, _angleTwo];
    //Draw for debug

    _arrow = "Sign_Arrow_Pink_F" createVehicle _checkPosOne;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosOne;

    _arrow = "Sign_Arrow_Pink_F" createVehicle _checkPosTwo;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosTwo;
  }
  else
  {
    if(_currentStep == _largeAngleStep) then
    {
      _currentStep = _smallAngleStep;
    }
    else
    {
      _abort = true;
    };
  };
};

_turnedAngle = _turnedAngle / 2;
_angleOne = _angleOne + _turnedAngle;
_angleTwo = _angleTwo + _turnedAngle;

_checkPosOne = _road getRelPos [_distanceOne, _angleOne];
_checkPosTwo = _road getRelPos [_distanceTwo, _angleTwo];


//Close in on distance
//Pos one first
_currentStep = _largeDistanceStep;
_abort = false;
while {!_abort} do
{
  if(roadAt (_road getRelPos [(_distanceOne - _currentStep), _angleOne]) != _road) then
  {
    _distanceOne = _distanceOne - _currentStep;
    if(_distanceOne < 0) exitWith {_error = true};
    //Draw for debug
    _checkPosOne = _road getRelPos [_distanceOne, _angleOne];
    _arrow = "Sign_Arrow_Blue_F" createVehicle _checkPosOne;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosOne;
  }
  else
  {
    if(_currentStep == _largeDistanceStep) then
    {
      _currentStep = _smallDistanceStep;
    }
    else
    {
      _abort = true;
    };
  };
};

//Pos two next
_currentStep = _largeDistanceStep;
_abort = false;
while {!_abort} do
{
  if(roadAt (_road getRelPos [(_distanceTwo - _currentStep), _angleTwo]) != _road) then
  {
    _distanceTwo = _distanceTwo - _currentStep;
    if(_distanceTwo < 0) exitWith {_error = true};
    //Draw for debug
    _checkPosTwo = _road getRelPos [_distanceTwo, _angleTwo];
    _arrow = "Sign_Arrow_Blue_F" createVehicle _checkPosTwo;
    _arrow setVectorDir [0, 0, 1];
    _arrow setPos _checkPosTwo;
  }
  else
  {
    if(_currentStep == _largeDistanceStep) then
    {
      _currentStep = _smallDistanceStep;
    }
    else
    {
      _abort = true;
    };
  };
};

_distance = _distanceOne + _distanceTwo;
hint format ["Road width is %1", _distance];
