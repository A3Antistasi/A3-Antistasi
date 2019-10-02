params ["_data", "_side", "_pos", "_dir"];

//TESTED

private ["_vehicleGroup", "_cargoGroup", "_vehicleData", "_vehicleObj", "_crewData", "_crewObjs", "_cargoData", "_cargoObjs"];
private ["_allTurrets", "_possibleSeats", "_slowConvoy", "_twoGroups", "_result"];

_vehicleData = _data select 0;
_crewData = _data select 1;
_cargoData = _data select 2;

_vehicleGroup = createGroup _side;
_vehicleObj = objNull;

if(_vehicleType != "") then
{
  //Spawns in the vehicle as it should
  if(!(_vehicleType isKindOf "Air")) then
  {
    _vehicleObj = createVehicle [_vehicleType, _pos, [], 0 , "CAN_COLLIDE"];
  }
  else
  {
    _vehicleObj = createVehicle [_vehicleType, _pos, [], 0 , "FLY"];
  };
  _vehicleObj setDir _dir;

  //Activates the engine if the vehicle is not a static weapon
  if(!(_vehicleType isKindOf "StaticWeapons")) then
  {
    _vehicleObj engineOn true;
  };

  //Assigns a vehicle to the group, the makes it a target, even if its empty
  _vehicleGroup addVehicle _vehicleObj;

  //Init vehicle
  [_vehicleObj] call A3A_fnc_AIVEHinit;

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

private _slowConvoy = false;
//Spawning in crew
private _crewTypes = _data select 1;
private _crewObjs = [];
{
    private _unit = _vehicleGroup createUnit [_x, _pos, [], 0, "NONE"];
	private _isInVehicle = false;
    if(!isNull _vehicleObj) then
    {
	  //We don't need all this logic. moveInAny prioritises in this order anyway.
	  //Unless we need to 'assignAsDriver', etc. Not sure if we do.

    //Are you sure? I had some huge problems with it, but I will give it a try
	  _isInVehicle = _vehicleObj moveInAny _unit;
      /*//If vehicle available, try to fill the driver slot
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
      };*/
    };
	if (!_isInVehicle) then {
	  //Units are moving by foot, slow down convoy
      _slowConvoy = true;
	};
    [_unit] call A3A_fnc_NATOinit;
    _crewObjs pushBack _unit;
    sleep 0.2;
} forEach _crewTypes;

sleep 0.5;

private _cargoTypes = _data select 2;
private _cargoGroup = grpNull;
private _twoGroups = false;
private _cargoObjs = [];

//Put cargo into a seperate group if they are cargo of a plane or large
if(_vehicleObj isKindOf "Air" || {count _cargoTypes >= 6}) then
{
  _cargoGroup = createGroup _side;
  _twoGroups = true;
}
else
{
  _cargoGroup = _vehicleGroup;
  _twoGroups = false;
};

//Spawning in cargo
{
    _unit = _cargoGroup createUnit [_x, _pos, [], 0, "NONE"];
    if (!isNull _vehicleObj) then
    {
      _unit assignAsCargo _vehicleObj;
      _unit moveInCargo _vehicleObj;
    };

	if (vehicle _unit == _unit) then
    {
      //Units are moving by foot, slow down convoy
      _slowConvoy = true;
    };

    [_unit] call A3A_fnc_NATOinit;
    _cargoObjs pushBack _unit;
    sleep 0.2;
} forEach _cargoData;

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

//Return result array
[[_vehicleObj, _crewObjs, _cargoObjs], _vehicleGroup, _cargoGroup, _slowConvoy];
