//params ["_marker"];

//Debug, testing on isolated map
_marker = "outpost_1";
_vehicleMarker = ["outpost_1_vehicle", "outpost_1_vehicle_1"];
_heliMarker = ["outpost_1_helipad"];
_hangarMarker = ["outpost_1_hangar"];
_mortarMarker = ["outpost_1_mortar"];

_spacing = 1;

if(count _vehicleMarker == 0) exitWith
{
  diag_log format ["InitSpawnPlaces: Could not find any vehicle places on %1, aborting!", _marker];
};

_markerSize = markerSize _marker;
_markerSize set [0, (_markerSize select 0) / 2];
_markerSize set [1, (_markerSize select 1) / 2];
_distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));

_buildings = nearestObjects [getMarkerPos _marker, ["Helipad_Base_F", "Land_Hangar_F", "Land_TentHangar_V1_F", "Land_Airport_01_hangar_F", "Land_ServiceHangar_01_L_F", "Land_ServiceHangar_01_R_F"], _distance, true];

_hangars = [];
_helipads = [];

{
  if((getPos _x) inArea _marker) then
  {
    if(_x isKindOf "Helipad_Base_F") then
    {
      _helipads pushBack _x;
    }
    else
    {
      _hangars pushBack _x;
    };
  };
} forEach _buildings;

//Find additional helipads and hangars (maybe a unified system would be better??)
{
  _markerSize = markerSize _x;
  _markerSize set [0, (_markerSize select 0) / 2];
  _markerSize set [1, (_markerSize select 1) / 2];
  _distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
  _buildings = nearestObjects [getMarkerPos _x, ["Helipad_Base_F"], _distance, true];
  {
      _helipads pushBackUnique _x;
  } forEach _buildings;
} forEach _heliMarker;

{
  _markerSize = markerSize _x;
  _markerSize set [0, (_markerSize select 0) / 2];
  _markerSize set [1, (_markerSize select 1) / 2];
  _distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
  _buildings = nearestObjects [getMarkerPos _x, ["Land_Hangar_F", "Land_TentHangar_V1_F", "Land_Airport_01_hangar_F", "Land_ServiceHangar_01_L_F", "Land_ServiceHangar_01_R_F"], _distance, true];
  {
      _hangars pushBackUnique _x;
  } forEach _buildings;
} forEach _hangarMarker;
//All additional hangar and helipads found

_vehicleSpawns = [];
_offset = 0;
{
    _markerX = _x;
    _size = getMarkerSize _x;
    _length = (_size select 0) * 2;
    _width = (_size select 1) * 2;
    if(_width < (4 + 2 * _spacing)) then
    {
      diag_log format ["Marker %1 is not wide enough for vehicles, required are %2 meters!", _x , (4 + 2 * _spacing)];
    }
    else
    {
      if(_length < 10) then
      {
          diag_log format ["Marker %1 is not long enough for vehicles, required are 10 meters!", _x];
      }
      else
      {

        _vehicleCount = floor ((_length - _spacing) / (4 + _spacing));
        _realLength = _vehicleCount * 4;
        _realSpace = (_length - _realLength) / (_vehicleCount + 1);

        diag_log format ["Len: %1 Veh: %2 RL: %3 RS: %4", _length, _vehicleCount, _realLength, _realSpace];

        _markerDir = markerDir _markerX;
        for "_i" from 1 to _vehicleCount do
        {
          _dis = (_realSpace + 2 + ((_i - 1) * (4 + _realSpace))) - (_length / 2);
          //_dis = ((_i  * (_length / _vehicleCount)) - (_length / 2));
          diag_log format ["Dis: %1 _i: %2 Len: %3", _dis, _i, _length];
          _pos = [getMarkerPos _markerX, _dis, (_markerDir + 90)] call BIS_fnc_relPos;
          _pos set [2, (_pos select 2) + 0.1];

          // _dMarker = createMarker [str (random 1000), _pos];
          // _dMarker setMarkerShape "RECTANGLE";
          // _dMarker setMarkerSize [2, 5];
          // _dMarker setMarkerDir _markerDir;
          // _dMarker setMarkerPos _pos;
          // _dMarker setMarkerAlpha 1;
          // _dMarker setMarkerColor "ColorWEST";

          _veh = createVehicle ["B_Truck_01_transport_F", _pos, [], 0, "CAN_COLLIDE"];
          _veh allowDamage false;
          _veh setDir _markerDir;
        };
      };
    };
} forEach _vehicleMarker;



//DEBUG placing units
{
    _pos = getPos _x;
    _pos set [2, (_pos select 2) + 0.1];
    _dir = direction _x;
    _veh = createVehicle ["B_Heli_Light_01_F", _pos, [], 0 , "CAN_COLLIDE"];
    _veh setDir _dir;
} forEach _helipads;

{
    _pos = getPos _x;
    _pos set [2, (_pos select 2) + 0.1];
    _dir = direction _x;
    _veh = createVehicle ["B_Plane_CAS_01_F", _pos, [], 0 , "CAN_COLLIDE"];
    _veh setDir _dir;
} forEach _hangars;

{
  _pos = getMarkerPos _x;
  _pos set [2, (_pos select 2) + 0.1];
  _veh = createVehicle ["B_Mortar_01_F", _pos, [], 0 , "CAN_COLLIDE"];
} forEach _mortarMarker;


//hint format ["Found %1 hangar %3\nFound %2 helipads %4", count _hangars, count _helipads, str _hangars, str _helipads];
