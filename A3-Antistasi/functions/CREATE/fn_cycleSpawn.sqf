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

_lineIndex = 0;

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
    //_spawnParameter = [_marker, _vehicleType] call A3A_fnc_findSpawnPosition;
    _spawnParameter = [getMarkerPos _marker, 0];
    _vehicle = createVehicle [_vehicleType, _spawnParameter select 0, [], 0 , "NONE"];
    _vehicle setDir (_spawnParameter select 1);
    _allVehicles pushBack _vehicle;
    _groupX addVehicle _vehicle;

    //Should work as a local variable needs testing
    _vehicle setVariable ["UnitIndex", (_lineIndex * 10 + 0)];
    _vehicle setVariable ["UnitMarker", _marker];

    //On vehicle death, remove it from garrison
    _vehicle addEventHandler ["Killed",
      {
        _vehicle = _this select 0;
        _id = _vehicle getVariable "UnitIndex";
        _marker = _vehicle getVariable "UnitMarker";
        [_marker, typeOf _vehicle, _id] call A3A_fnc_addRequested;
      }
    ];
    sleep 0.25;

    //That would work perfectly with the breach script i did a PR for, without it it would just frustrate player
    //_vehicle lock 3;
  };

  //_spawnParameter = [_marker, NATOCrew] call A3A_fnc_findSpawnPosition;
  _spawnParameter = [getMarkerPos _marker, objNull];
  {
      _unitX = _groupX createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];
      _allSoldiers pushBack _unitX;

      //Should work as a local variable needs testing
      _unitX setVariable ["UnitIndex", (_lineIndex * 10 + 1)];
      _unitX setVariable ["UnitMarker", _marker];

      //On vehicle death, remove it from garrison
      _unitX addEventHandler ["Killed",
        {
          _unitX = _this select 0;
          _id = _unitX getVariable "UnitIndex";
          _marker = _unitX getVariable "UnitMarker";
          [_marker, typeOf _unitX, _id] call A3A_fnc_addRequested;
        }
      ];

      sleep 0.25;
  } forEach _crewArray;

  {
    _unitX = _groupX createUnit [_x, (_spawnParameter select 0), [], 5, "NONE"];
    _allSoldiers pushBack _unitX;

    //Should work as a local variable needs testing
    _unitX setVariable ["UnitIndex", (_lineIndex * 10 + 1)];
    _unitX setVariable ["UnitMarker", _marker];

    //On vehicle death, remove it from garrison
    _unitX addEventHandler ["Killed",
      {
        _unitX = _this select 0;
        _id = _unitX getVariable "UnitIndex";
        _marker = _unitX getVariable "UnitMarker";
        [_marker, typeOf _unitX, _id] call A3A_fnc_addRequested;
      }
    ];

    sleep 0.25;
  } forEach _cargoArray;

  _lineIndex = _lineIndex + 1;
} forEach _garrison;
