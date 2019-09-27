params ["_pos", "_nextPos", "_units", "_target", "_side", "_type", "_maxSpeed"];

//pos = getMarkerPos "spawn";

//_nextPos = getMarkerPos "dir";

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

_pos = _pos vectorAdd [0,0,0.1];
_dir = _pos getDir _nextPos;

for "_i" from 0 to ((count _units) - 1) do
{
  _data = _units select _i;
  _vehicleType = _data select 0;

  if(_vehicleType != "") then
  {
    
  }
  //_vehicle = [_pos, _dir, _data select 0, _side] call bis_fnc_spawnvehicle;
  _vehicle = createVehicle

  sleep 0.25;
  hint "Spawned!";
  _group = _vehicle select 2;
  _crew = _vehicle select 1;
  _vehicle = _vehicle select 0;
  _vehicle setPos _pos;
  //{[_x] call A3A_fnc_NATOinit} forEach _crew;
  //[_vehicle] call A3A_fnc_AIVEHinit;
  _vehicle engineOn true;
    //Just debug currently
  _group move _target;

  [_group, _data select 1, _vehicle] spawn
  {
    params ["_group", "_units", "_vehicle"];
    {
      sleep 0.25;
      _unit = _group createUnit [_x, _group, [], 0, "CARGO"];
      _unit moveInCargo _vehicle;
      [_unit] spawn
      {
        private _unit = _this select 0;
        sleep 5;
        if(vehicle _unit == _unit) then
        {
          deleteVehicle _unit;
        };
      };
    } forEach _units;
  };
  waitUntil {sleep 0.5; ((_vehicle distance2D _pos) > 8)};
};
