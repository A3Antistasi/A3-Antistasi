params ["_data", "_side", "_pos", "_dir"];

private ["_vehicleGroup", "_cargoGroup", "_vehicleData", "_vehicleObj", "_crewData", "_crewObjs", "_cargoData", "_cargoObjs"];
private ["_allTurrets", "_possibleSeats", "_slowConvoy", "_twoGroups", "_result"];

_vehicleGroup = createGroup _side;
_vehicleObj = objNull;

_possibleSeats = [];
if(_vehicleData != "") then
{
  //Spawns in the vehicle as it should
  if(!(_vehicleData isKindOf "Air")) then
  {
    _vehicleObj = createVehicle [_vehicleData, _pos, [], 0 , "CAN_COLLIDE"];
  }
  else
  {
    _vehicleObj = createVehicle [_vehicleData, _pos, [], 0 , "FLY"];
  };
  _vehicleObj setDir _dir;

  //Activates the engine if the vehicle is not a static weapon
  if(!(_vehicleData isKindOf "StaticWeapons")) then
  {
    _vehicleObj engineOn true;
  };

  //Assigns a vehicle to the group, the makes it a target, even if its empty
  _vehicleGroup addVehicle _vehicleObj;

  //Currently not, as it locks the vehicle from the pool, which should happen before
  //[_vehicleObj, false] call A3A_fnc_AIVEHinit;

  //Select the open slots of the vehicle
  _allTurrets = allTurrets [_vehicleObj, false];
  {
    if(count _x == 1) then
    {
      _possibleSeats pushBack _x;
    };
  } forEach _allTurrets;
};

//Sleep to decrease spawn lag
sleep 0.25;

_slowConvoy = false;
//Spawning in crew
_crewObjs = [];
{
    _unit = _vehicleGroup createUnit [_x, _pos, [], 0, "NONE"];
    if(!isNull _vehicleObj) then
    {
      //If vehicle available, try to fill the driver slot
      if(isNull (driver _vehicleObj)) then
      {
        _unit moveInDriver _vehicleObj;
      }
      else
      {
        //Driver slot full, try to fill commander slot
        if(isNull (commander _vehicleObj)) then {_unit moveInCommander _vehicleObj;};
      };
      //Driver and commander full, select weapon slots
      if(isNull (objectParent _unit)) then
      {
        _seat = _possibleSeats deleteAt 0;
        _unit moveInTurret [_vehicleObj, _seat];
      };
    }
    else
    {
      //Units are moving by foot, slow down convoy
      _slowConvoy = true;
    };
    [_unit] call A3A_fnc_NATOinit;
    _crewObjs pushBack _unit;
    sleep 0.2;
} forEach _crewData;

sleep 0.5;

_twoGroups = false;
//Put cargo into a seperate group if they are cargo of a plane or large
if(_vehicleObj isKindOf "Air" || {count _cargoData >= 6}) then
{
  _cargoGroup = createGroup _side;
  _twoGroups = true;
}
else
{
  _cargoGroup = _vehicleGroup;
  _twoGroups = false;
};

_cargoObjs = [];
//Spawning in cargo
{
    _unit = _cargoGroup createUnit [_x, _pos, [], 0, "NONE"];
    if(!isNull _vehicleObj) then
    {
      _unit assignAsCargo _vehicleObj;
      _unit moveInCargo _vehicleObj;
    }
    else
    {
      //Units are moving by foot, slow down convoy
      _slowConvoy = true;
    };
    [_unit] call A3A_fnc_NATOinit;
    _cargoObjs pushBack _unit;
    sleep 0.2;
} forEach _cargo;

//Prepare result array
_result = [];
_result pushBack [_vehicleObj, _crewObjs, _cargoObjs];
_result pushBack _vehicleGroup;
if(_twoGroups) then
{
  _result pushBack _cargoGroup;
}
else
{
  _result pushBack grpNull;
};
_result pushBack _slowConvoy;

_result;
