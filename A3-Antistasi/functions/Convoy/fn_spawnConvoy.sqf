params ["_convoyID", "_posArray", "_markers", "_units", "_convoySide", "_convoyType", "_maxSpeed"];


private ["_pos", "_nextPos", "_target", "_dir", "_startMarker", "_targetMarker", "_road", "_radius", "_possibleRoads"];

_pos = _posArray select 0;
_nextPos = _posArray select 1;
_target = _posArray select 2;

_dir = _pos getDir _nextPos;

_startMarker = _markers select 0;
_targetMarker = _markers select 1;

//Find near road segments
_road = roadAt _pos;
if(isNull _road) then
{
  _radius = 3;
  _possibleRoads = [];
  while {isNull _road && {_radius < 50}} do
  {
    _possibleRoads = _pos nearRoads _radius;
    if(count _possibleRoads > 0) then
    {
      _road = _possibleRoads select 0;
    }
    else
    {
      _radius = _radius + 1;
    };
  };
};

if(!(isNull _road)) then
{
  _pos = (getPos _road);
};

//Conversion back to km/h
_maxSpeed = _maxSpeed * 3.6;

//Spawn a bit above the ground
_pos = _pos vectorAdd [0,0,0.1];

private ["_unitObjects", "_allGroups", "_airVehicles", "_landVehicles"];

_unitObjects = [];
_allGroups = [];
_airVehicles = [];
_landVehicles = [];

//diag_log "Spawning in convoy";
//[_units, "Convoy Units"] call A3A_fnc_logArray;

for "_i" from 0 to ((count _units) - 1) do
{
  _data = _units select _i;
  _lineData = [_data, _convoySide, _pos, _dir] call A3A_fnc_spawnConvoyLine;

  //Pushback the spawned objects
  _unitObjects pushBack (_lineData select 0);

  //Pushback the groups
  _vehicleGroup = (_lineData select 1);
  _allGroups pushBack _vehicleGroup;
  _cargoGroup = (_lineData select 2);
  if(_cargoGroup != grpNull) then
  {
    _allGroups pushBack _cargoGroup;
  };

  //Select vehicle type
  _vehicle = (_lineData select 0) select 0;
  if(_vehicle isKindOf "Air") then
  {
    _airVehicles pushBack _vehicle;
  }
  else
  {
    _landVehicles pushBack _vehicle;
    //Create marker for the crew
    [_markers select 0, _target, _vehicleGroup] call WPCreate;
    _wp0 = (wayPoints _vehicleGroup) select 0;
    _wp0 setWaypointBehaviour "SAFE";
  };

  if(_vehicle != objNull) then
  {
    if(_i == 1 && {_convoyType == "convoy"}) then
    {
      _vehicle setConvoySeparation 80;
    }
    else
    {
      _vehicle setConvoySeparation 30;
    };
  };
  waitUntil {sleep 1; ((_vehicle distance2D _pos) > 10)};
};

_posObject = objNull;
//Let helicopter follow the vehicles and vehicles have a speed limit
if(count _landVehicles > 0) then
{
  _posObject = _landVehicles select 0;
  {
      _x limitSpeed _maxSpeed;
  } forEach _landVehicles;
  {
      [selectRandom _landVehicles, _x, _target, _maxSpeed * 1.1] call A3A_fnc_followVehicle;
  } forEach _airVehicles;
}
else
{
  //No vehicle found, fly direct way
  if(count _airVehicles > 0) then
  {
    _posObject = _airVehicles select 0;
  };
  {
    _wp0 = (group _x) addWaypoint [_target, 50, 0];
    _wp0 setWaypointBehaviour "SAFE";
  } forEach _airVehicles;
};

//Neither land nor air vehicles, choose position of first group
if(isNull _posObject) then
{
  _posObject = _allGroups select 0;
};

_checkPos = [];
waitUntil
{
  sleep 1;
  _checkPos = getPos _posObject;
  (_checkPos distance2D _target < 100) ||
  {!([distanceSPWN * 1.2, 1, _checkPos, teamPlayer] call A3A_fnc_distanceUnits)}
};

if(_checkPos distance2D _target < 100) then
{
  //Spawned convoy arrive
}
else
{
  //Despawn convoy and simulate further
};
