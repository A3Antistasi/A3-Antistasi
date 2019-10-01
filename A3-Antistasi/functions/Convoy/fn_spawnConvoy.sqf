params ["_convoyID", "_units", "_posArray", "_markers", "_convoySide", "_convoyType", "_maxSpeed"];


private ["_pos", "_nextPos", "_target", "_dir", "_startMarker", "_targetMarker", "_convoyMarker", "_road", "_radius", "_possibleRoads"];

_pos = _posArray select 0;
_nextPos = _posArray select 1;
_target = _posArray select 2;

_dir = _pos getDir _nextPos;

_startMarker = _markers select 0;
_targetMarker = _markers select 1;

_convoyMarker = format ["convoy%1", _convoyID];
_convoyMarker setMarkerText (format ["%1 Convoy [%2]: Spawned", _convoyType, _convoyID]);

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

private ["_unitObjects", "_allGroups", "_airVehicles", "_landVehicles", "_data", "_lineData", "_vehicleGroup", "_cargoGroup", "_vehicle", "_wp0", "_posObject", "_checkPos"];

_unitObjects = [];
_allGroups = [];
_airVehicles = [];
_landVehicles = [];

diag_log "Spawning in convoy";
[_units, "Convoy Units"] call A3A_fnc_logArray;

for "_i" from 0 to ((count _units) - 1) do
{
  _data = _units select _i;
  _lineData = [_data, _convoySide, _pos, _dir] call A3A_fnc_spawnConvoyLine;

  //Pushback the spawned objects
  _unitObjects pushBack (_lineData select 0);

  //Pushback the groups
  _vehicleGroup = (_lineData select 1);
  _vehicleGroup setBehaviour "CARELESS";
  _allGroups pushBack _vehicleGroup;
  _cargoGroup = (_lineData select 2);
  if(_cargoGroup != grpNull) then
  {
    _allGroups pushBack _cargoGroup;
    _cargoGroup setBehaviour "CARELESS";
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
    [_markers select 0, _markers select 1, _vehicleGroup] call WPCreate;
    diag_log format ["Waypoint count is %1", count (wayPoints _vehicleGroup)];
    _wp0 = (wayPoints _vehicleGroup) select 0;
    _wp0 setWaypointBehaviour "SAFE";
  };
  //Push vehicles forward
  _vehicle setVelocity ((vectorDir _vehicle) vectorMultiply 20);

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

  _vehicle setVariable ["vehGroup", _vehicleGroup];
  _vehicle setVariable ["cargoGroup", _cargoGroup];

  waitUntil {sleep 1; ((_vehicle distance _pos) > 10)};
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
      [selectRandom _landVehicles, _x, _target, _maxSpeed * 1.5] spawn A3A_fnc_followVehicle;
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
    _wp0 = (group _x) addWaypoint [(_target vectorAdd [0,0,20]), 50, 0];
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
  _convoyMarker setMarkerPos _checkPos;
  (_checkPos distance2D _target < 100) ||
  {!([distanceSPWN * 1.2, 1, _checkPos, teamPlayer] call A3A_fnc_distanceUnits)}
};

deleteMarker _convoyMarker;
if(_checkPos distance2D _target < 100) then
{
  [_convoyID, _unitObjects, _checkPos, _target, _markerArray, _convoyType, _convoySide] call A3A_fnc_onSpawnedArrival;
}
else
{
  [_convoyID, _unitObjects, _checkPos, _target, _markerArray, _convoyType, _convoySide] call A3A_fnc_despawnConvoy;
};
