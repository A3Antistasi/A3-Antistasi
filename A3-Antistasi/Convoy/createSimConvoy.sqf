params ["_units", "_origin", "_destination"];

if (isNil "_units" || {count _units == 0}) exitWith {diag_log "CreateConvoy: No units given for convoy!"};
if (isNil "_origin") exitWith {diag_log "CreateConvoy: No origin given for the convoy!"};
if (isNil "_destination") exitWith {diag_log "CreateConvoy: No destination given for the convoy!"};

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
