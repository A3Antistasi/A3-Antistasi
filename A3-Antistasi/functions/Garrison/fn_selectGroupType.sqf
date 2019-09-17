params ["_vehicle", "_preference"];

/*  Selects a suitable group for the given vehicle and preference
*   Params:
*     _vehicle : STRING : The vehicle typename
*     _preference : STRING : The preferred group
*
*   Returns:
*     _result : STRING : The selected group type
*/

//If preference is empty, return empty
if(_preference == "Empty") exitWith {"Empty"};

//If tank, select AT team
if(_vehicle in vehNATOTank || {_vehicle in vehCSATTank}) exitWith {"AT"};

//If AA-tank, select AA team
if(_vehicle in vehNATOAA ||{_vehicle in vehCSATAA}) exitWith {"AA"};

//If no vehicle return preference
if(_vehicle == "") exitWith {_preference};

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
    diag_log format ["Vehicle %1 cannot transport four or more people, reconsider using another vehicle or make smaller groups possible!", _vehicle];
  };
};

_result;
