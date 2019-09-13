params ["_marker"];

if(isNil "_marker") exitWith {diag_log "CycleSpawn: No marker given!"};

private ["_side", "_garrison", "_unitX", "_allSoldiers", "_allVehicles", "_allGroups", "_groupX", "_vehicleType", "_crewArray", "_cargoArray"];

_side = sidesX getVariable [_marker, sideUnknown];
if(_side == sideUnknown) exitWith {diag_log "CycleSpawn: Marker side resulted in sideUnknown!"};

diag_log "CycleSpawn: Spawning in now!";

_garrison = [_marker] call A3A_fnc_getGarrison;

_allSoldiers = [];
_allVehicles = [];
_allGroups = [];

{
  _vehicleType = _x select 0;
  _crewArray = _x select 1;
  _cargoArray = _x select 2;
  _groupX = createGroup _side;
  _allGroups pushBack _groupX;

  if (_vehicleType != "") then
  {
    //Array got a vehicle, spawn it in
    //TODO add a function that chooses a logical spawn position and direction for a the given vehicle type
    _spawnParameter = [_marker, _vehicleType] call A3A_fnc_findSpawnPosition;
    _vehicle = createVehicle [_vehicleType, _spawnParameter select 0, [], 0 , "NONE"];
    _vehicle setDir (_spawnParameter select 1);
    _allVehicles pushBack _vehicle;
    _groupX addVehicle _vehicle;

    //That would work perfectly with the breach script i did a PR for, without it it would just frustrate player
    //_vehicle lock 3;
  };
  sleep 0.25;
  //_spawnParameter = [_marker, NATOCrew] call A3A_fnc_findSpawnPosition;
  _spawnParameter = [getMarkerPos _marker, objNull];
  {
      _unitX = _groupX createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];
      _allSoldiers pushBack _unitX;
      sleep 0.25;
  } forEach _crewArray;
  sleep 0.25;
  {
    _unitX = _groupX createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];
    _allSoldiers pushBack _unitX;
    sleep 0.25;
  } forEach _cargoArray;
  sleep 0.25;
} forEach _garrison;
