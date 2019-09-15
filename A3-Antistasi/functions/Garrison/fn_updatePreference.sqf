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
};
if(tierPreference in outpostUpdateTiers) then
{

};
if(tierPreference in cityUpdateTiers) then
{
  _preference = garrison getVariable ["City_preference", []];
  _preference pushBack ["LAND_LIGHT", -1, "GROUP"];
  garrison setVariable ["City_preference", _preference, true];
};
if(tierPreference in otherUpdateTiers) then
{

};
