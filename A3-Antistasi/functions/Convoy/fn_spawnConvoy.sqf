params ["_pos", "_nextPos", "_units", "_target", "_side", "_type", "_maxSpeed"];

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

//Conversion back to km/h
_maxSpeed = _maxSpeed * 3.6;

if(!(isNull _road)) then
{
  _pos = (getPos _road);
};

_pos = _pos vectorAdd [0,0,0.1];
_dir = _pos getDir _nextPos;

_spawnedUnits = [];
_allGroups = [];
_allVehicles = [];
_allSoldiers = [];

for "_i" from 0 to ((count _units) - 1) do
{
  _unitLine = [];
  _group = createGroup _side;
  _data = _units select _i;
  _allGroups pushBack _group;

  _vehicleType = _data select 0;
  _vehicle = objNull;
  if(_vehicleType != "") then
  {
    if(!(_vehicleType isKindOf "Air")) then
    {
      _vehicle = createVehicle [_vehicleType, _pos, [], 0 , "CAN_COLLIDE"];
    }
    else
    {
      _vehicle = createVehicle [_vehicleType, _pos, [], 0 , "FLY"];
    };
    _vehicle setDir _dir;
    if(!(_vehicleType isKindOf "StaticWeapons")) then
    {
      _vehicle engineOn true;
    };
    _groupX addVehicle _vehicle;
    _allVehicles pushBack _vehicle;
    //Currently not, as it locks the vehicle from the pool, which should happen before
    //[_vehicle] call A3A_fnc_AIVEHinit;
  };
  _unitLine set [0, _vehicle];

  _crew = _data select 1;
  _crewObjects = [];
  {
      _unit = _group createUnit [_x, _group, [], 0, "CARGO"];
      if(!isNull _vehicle) then
      {
        _unit moveInAny _vehicle;
      }
      else
      {
        //Units are moving by foot, slow down convoy
        _maxSpeed = 24 * 0.8;
      };
      [_unit] call A3A_fnc_NATOinit;
      _crewObjects pushBack _unit;
      _allSoldiers pushBack _unit;
      sleep 0.1;
  } forEach _crew;
  _unitLine set [1, _crewObjects];
  sleep 0.25;

  _cargo = _data select 2;

  if(count _cargo > 5) then
  {
    //Create new group for cargo units if the are more than five
    _group = createGroup _side;
    _allGroups pushBack _group;
  };

  _cargoObjects = [];
  {
      _unit = _group createUnit [_x, _group, [], 0, "CARGO"];
      if(!isNull _vehicle) then
      {
        _unit moveInAny _vehicle;
      }
      else
      {
        //Units are moving by foot, slow down convoy
        _maxSpeed = 24 * 0.8;
      };
      [_unit] call A3A_fnc_NATOinit;
      _cargoObjects pushBack _unit;
      _allSoldiers pushBack _unit;
      sleep 0.1;
  } forEach _cargo;
  _unitLine set [2, _cargoObjects];
  sleep 0.25;

  waitUntil {sleep 0.5; ((_vehicle distance2D _pos) > 8)};
};
