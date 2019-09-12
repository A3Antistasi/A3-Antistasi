params ["_marker", "_vehicleType"];

private ["_pos", "_spawnPos", "_spawnDir", "_result"];

_pos = getMarkerPos _marker;

_spawnPos = [];
_spawnDir = 0;

switch (true) do
{
  case (_vehicleType isKindOf "Plane"):
  {
    //Find a runway or a hangar
  };
  case (_vehicleType isKindOf "Helicopter"):
  {
    //Find a heli pad
  };
  case (_vehicleType isKindOf "StaticWeapon"):
  {
    //Find a position for in a bunker or a open space for a mortar
  };
  case (_vehicleType isKindOf "Man"):
  {
    //Find a building to spawn in
  };
  default
  {
    //Find a good place near a road or something

    //Debug option to get it working
    _spawnPos = _pos;
  };
};

_result = [_spawnPos, _spawnDir];

_result;
