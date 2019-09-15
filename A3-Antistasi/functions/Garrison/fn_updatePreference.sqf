/*
*
*
*
*
*
*
*
*/

//No need to update the preferences
if(tierPreference >= tierWar) exitWith {};

tierPreference = tierWar;
publicVariable "tierPreference";

if(tierPreference in airportUpdateTiers) then
{
  _preference = garrison getVariable ["Airport_preference", []];
  //Update vehicle types
  [_preference] call A3A_fnc_updateVehicles;

  //Add new vehicles
  _index = airportUpdateTiers findIf {_x == tierPreference};
  if(_index % 2 == 0) then
  {
    _preference pushBack ["LAND_LIGHT", -1, "SQUAD"];
    _preference pushBack ["HELI_LIGHT", -1, "GROUP"];
  }
  else
  {
    _preference pushBack ["LAND_AIR", -1, "AA"];
    _preference pushBack ["PLANE_GENERIC", -1, "EMPTY"];
  };
  garrison setVariable ["Airport_preference", _preference, true];
  garrison setVariable ["Airport_statics", (airportStaticsTiers select _index), true];
};

if(tierPreference in outpostUpdateTiers) then
{
  _preference = garrison getVariable ["Outpost_preference", []];
  //Update vehicle types
  [_preference] call A3A_fnc_updateVehicles;

  //Add new vehicles
  _index = outpostUpdateTiers findIf {_x == tierPreference};
  if(_index % 2 == 0) then
  {
    _preference pushBack ["LAND_LIGHT", -1, "SQUAD"];
  }
  else
  {
    _preference pushBack ["HELI_LIGHT", -1, "GROUP"];
  };
  garrison setVariable ["Outpost_preference", _preference, true];
  garrison setVariable ["Outpost_statics", (outpostStaticsTiers select _index), true];
};

if(tierPreference in cityUpdateTiers) then
{
  //Update preferences of cities
  _preference = garrison getVariable ["City_preference", []];
  _preference pushBack ["LAND_LIGHT", -1, "GROUP"];
  garrison setVariable ["City_preference", _preference, true];

  //Update statics percentage
  _index = cityUpdateTiers findIf {_x == tierPreference};
  garrison setVariable ["City_statics", (cityStaticsTiers select _index), true];
};

if(tierPreference in otherUpdateTiers) then
{
  //Update preferences of other sites
  _preference = garrison getVariable ["Other_preference", []];
  _preference pushBack ["EMPTY", 0, "SQUAD"];
  garrison setVariable ["Other_preference", _preference, true];

  //Update statics percentage
  _index = otherUpdateTiers findIf {_x == tierPreference};
  garrison setVariable ["Other_statics", (otherStaticsTiers select _index), true];
};
