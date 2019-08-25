params ["_convoyID", "_units", "_origin", "_destination", "_convoyType", "_sideConvoy"];

/* params
*   _convoyID: NUMBER; the unique convoy ID
*   _units: ARRAY; contains the info about the units, each element has to be [veh, [cargoUnits]]
*   _origin: POS; contains the position of the starting point
*   _destination: POS; contains the position of the end point
*   _convoyType: STRING; contains one of "ATTACK", "PATROL" or "REINFORCE"
*   _sideConvoy: SIDE; contains the side of the convoy
*/

if (isNil "_convoyID") exitWith {diag_log "CreateConvoy: No convoy ID given"};
if (isNil "_units" || {count _units == 0}) exitWith {diag_log format ["CreateConvoy[%1]: No units given for convoy!", _convoyID]};
if (isNil "_origin") exitWith {diag_log format ["CreateConvoy[%1]: No origin given for the convoy!", _convoyID]};
if (isNil "_destination") exitWith {diag_log format ["CreateConvoy[%1]: No destination given for the convoy!", _convoyID]};

_hasAir = false;
_hasLand = false;

_velocity = 999999; //CAUTION this is km/h not m/s!!! So is every speed
{
    _vehicle = _units select 0;
    if (!(_vehicle isKindOf "StaticWeapon")) then
    {
      if(!_hasLand && {_vehicle isKindOf "Land"}) then {_hasLand = true;};
      if(!_hasAir && {_vehicle isKindOf "Air"}) then {_hasAir = true;};
      _vehVelocity = getText (configFile >> CfgVehicles >> typeOf _vehicle >> "maxSpeed");
      if (_vehVelocity < _velocity) then
      {
        _velocity = _vehVelocity;
      };
    };
} forEach _units;

if(_velocity == 999999) then
{
  //Standard velocity for man units (only static in convoy)
  _velocity = 24;
  _hasLand = true;
};

//Convert km/h into m/s
_velocity = (_velocity / 3.6);
_route = nil;
_type = "";

if(_hasAir && {!_hasLand}) then
{
  //Convoy contains only air vehicles, can fly direct way
  _route = [_origin, _origin vectorAdd [0,0,200], _destination vectorAdd [0,0,200] _destination];
  _type = "Air";
}
else
{
  //Convoy is either pure land or combined air and land find way about the streets
  _route = [_origin, _destination] call A3A_fnc_calculateRoute;
  if(_hasAir) then {_type = "Mixed"} else {_type = "Land"};
};

_markerPrefix = if(colorTeamPlayer == colorGUER) then {"n"} else {"b"};
if(_sideConvoy == Occupants) then {_markerPrefix = if(colorInvaders == colorBLUFOR) then {"b"} else {"n"};};
if(_sideConvoy == Invaders) then {_markerPrefix = "n"};

_markerType = "_mech_inf";
if(_type == "Air") then {_markerType = "_armor"};
if(_type == "Mixed") then {_markerType = "_air"};

_convoyMarker = createMarker [format ["convoy%1", _convoyID], _origin];
_convoyMarker setMarkerShapeLocal "ICON";
_convoyMarker setMarkerType format ["%1%2", _markerPrefix, _markerType];
_convoyMarker setMarkerText (format ["%1 Convoy [%2]: Simulated", _type, _convoyID]);
_convoyMarker setMarkerAlpha 0;

convoyMarker = convoyMarker pushBack _convoyMarker;

[_route, _velocity, _units, _sideConvoy, _convoyType] spawn A3A_fnc_convoyMovement;
