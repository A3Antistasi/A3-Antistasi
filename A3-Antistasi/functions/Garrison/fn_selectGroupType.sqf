params ["_vehicle", "_preference", "_side"];

/*  Selects a suitable group for the given vehicle and preference
*   Params:
*     _vehicle : STRING : The vehicle typename
*     _preference : STRING : The preferred group
*     _side : SIDE : The side of the selected group
*
*   Returns:
*     _group : ARRAY of STRINGS : The selected group
*/

//If preference is empty, return empty
if(_preference == "Empty") exitWith {[]};

//If tank, select AT team
if(_vehicle in vehNATOTank) exitWith {groupsNATOAT};
if(_vehicle in vehCSATTank) exitWith {groupsCSATAT};

//If AA-tank, select AA team
if(_vehicle in vehNATOAA) exitWith {groupsNATOAA};
if(_vehicle in vehCSATAA) exitWith {groupsCSATAA};

//If no vehicle return preference
if(_vehicle == "") then
{
  _result = _preference
}
else
{
  //Check vehicle seats
  _result = "";
  _vehicleSeats = [_vehicle, true] call BIS_fnc_crewCount - [_vehicle, false] call BIS_fnc_crewCount;
  if(_vehicleSeats >= 8) then
  {
    _result = _preference;
  }
  else
  {
    if(_vehicleSeats >= 4) then
    {
      _result = "GROUP";
    }
    else
    {
      _result = "EMPTY";
      diag_log format ["SelectGroupType: Vehicle %1 cannot transport four or more people, reconsider using another vehicle or make smaller groups possible!", _vehicle];
    };
  };
};

_group = [];
if(_result != "EMPTY") then
{
  if(_side == Occupants) then
  {
    _group = if(_result == "SQUAD") then {selectRandom groupsNATOSquad} else {selectRandom groupsNATOmid};
  }
  else
  {
    _group = if(_result == "SQUAD") then {selectRandom groupsCSATSquad} else {selectRandom groupsCSATmid};
  };
};

_group;
