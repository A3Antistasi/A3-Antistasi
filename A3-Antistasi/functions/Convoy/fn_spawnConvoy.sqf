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
    [_markers select 0, _target, _vehicleGroup] call A3A_fnc_WPCreate;
    _wp0 = (wayPoints _vehicleGroup) select 0;
    _wp0 setWaypointBehaviour "SAFE";
    _wp0 = _group addWaypoint [_target, count (wayPoints _group)];
    _wp0 setWaypointType "TR UNLOAD";
    _wp0 setWaypointStatements ["true","nul = [group this] spawn A3A_fnc_groupDespawner;"];

    //Create marker for the cargo
    if(_cargoGroup != grpNull) then
    {
      _cargoGroup spawn A3A_fnc_attackDrillAI;
    };
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
  waitUntil {sleep 0.5; ((_vehicle distance2D _pos) > 10)};
};

_convoyPos = [];
//Let helicopter follow the vehicles and vehicles have a speed limit
if(count _landVehicles > 0) then
{
  _convoyPos = getPos (_landVehicles select 0);
  {
      _x limitSpeed _maxSpeed;
  } forEach _landVehicles;
  {
      [selectRandom _landVehicles, _x, _target, _maxSpeed * 1.1] call A3A_fnc_followVehicle;
  } forEach _airVehicles;
}
else
{
  if(count _airVehicles > 0) then
  {
    _convoyPos = getPos (_airVehicles select 0);
  };
  {
    _landPos = if (_vehicle isKindOf "Helicopter") then {[_target, 0, 300, 10, 0, 0.20, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos} else {[]};
    if (!(_landPos isEqualTo [])) then
    {
      _landPos set [2, 0];
      _pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
      _vehicleGroup setVariable ["myPad",_pad];
      _wp0 = _vehicleGroup addWaypoint [_landpos, 0];
      _wp0 setWaypointType "TR UNLOAD";
      _wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';deleteVehicle ((group this) getVariable [""myPad"",objNull])"];
      _wp0 setWaypointBehaviour "CARELESS";
      _wp3 = _cargoGroup addWaypoint [_landpos, 0];
      _wp3 setWaypointType "GETOUT";
      _wp3 setWaypointStatements ["true", "(group this) spawn A3A_fnc_attackDrillAI"];
      _wp0 synchronizeWaypoint [_wp3];
      _wp4 = _cargoGroup addWaypoint [_target, 1];
      _wp4 setWaypointType "MOVE";
      _wp4 setWaypointStatements ["true", "[group this] spawn A3A_fnc_groupDespawner;"];
      _wp2 = _vehicleGroup addWaypoint [getMarkerPos _startMarker, 1];
      _wp2 setWaypointType "MOVE";
      _wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
      [_vehicleGroup,1] setWaypointBehaviour "AWARE";
    }
    else
    {
      if ((typeOf _vehicle) in vehFastRope) then
      {
        [_vehicle, _cargoGroup, _target, getMarkerPos _startMarker, _vehicleGroup, true] spawn A3A_fnc_fastrope;
      }
      else
      {
        [_vehicle, _cargoGroup, _target, _startMarker,true] spawn A3A_fnc_airdrop;
      };
    };
  } forEach _airVehicles;
};

if(_convoyPos isEqualTo []) then
{
  _convoyPos = getPos (_allGroups select 0);
};
