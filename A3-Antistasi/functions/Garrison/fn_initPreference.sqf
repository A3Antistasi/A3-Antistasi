/*  Initiates the prefered garrison types and size
*   Params:
*     Nothing
*
*   Returns:
*     Nothing
*/
private ["_isSinglePlayer", "_preference"];

_isSinglePlayer = !isMultiplayer;

//Setting up airport preferences
_preference =
[
  ["LAND_AIR", -1, "AA"],
  ["LAND_APC", -1, "SQUAD"],
  ["LAND_START", -1, "SQUAD"],
  ["LAND_LIGHT", 0, "EMPTY"],       //Empty light vehicle
  ["HELI_LIGHT", -1, "GROUP"],
  ["HELI_LIGHT", -1, "GROUP"],
  ["HELI_LIGHT", 0, "EMPTY"],       //Empty helicopter
  ["PLANE_GENERIC", -1, "EMPTY"],
  ["PLANE_GENERIC", 0, "EMPTY"]     //Empty plane
];
//If SP delete some units
if(_isSinglePlayer) then
{

};
garrison setVariable ["Airport_preference", _preference];

//Setting up outpost preferences
_preference =
[
  ["LAND_START", -1, "SQUAD"],
  ["LAND_START", -1, "SQUAD"],
  ["LAND_LIGHT", 0, "EMPTY"],       //Empty light vehicle
  ["HELI_LIGHT", -1, "GROUP"],
  ["HELI_LIGHT", 0, "EMPTY"]        //Empty helicopter
];
//If SP delete some units
if(_isSinglePlayer) then
{

};
garrison setVariable ["Outpost_preference", _preference];

//Setting up city preferences
_preference =
[
  //No units in cities at start
];
garrison setVariable ["City_preference", _preference];

//Setting up other preferences
_preference =
[
  ["LAND_START", -1, "SQUAD"],
  ["LAND_START", -1, "SQUAD"],
  ["LAND_LIGHT", 0, "EMPTY"]      //Empty light vehicle
];
//If SP delete some units
if(_isSinglePlayer) then
{

};
garrison setVariable ["Other_preference", _preference];
