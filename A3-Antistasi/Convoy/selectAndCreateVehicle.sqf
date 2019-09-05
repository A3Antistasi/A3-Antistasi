params ["_vehPool", "_side"];

if(isNil "_side") exitWith
{
  diag_log "SelectAndCreateVehicle: No side given!";
  [objNull, objNull];
};
if(isNil "_vehPool" || {!(_vehPool isEqualType []) || {count _vehPool == 0}}) exitWith
{
  diag_log "SelectAndCreateVehicle: _vehpool is not a correct variable or empty!";
  [objNull, objNull];
};
private ["_selectedVehicle"];
_selectedVehicle = selectRandom _vehPool;

if(!([_selectedVehicle] call A3A_fnc_vehAvailable)) then
{
  _vehPool = _vehPool - [_selectedVehicle];
  _selectedVehicle = if (_side == Occupants) then {selectRandom vehNATOTrucks} else {selectRandom vehCSATTrucks};
  if (count _vehPool == 0) then
  {
    if (_side == Occupants) then
    {
      _vehPool = vehNATOTrucks;
    }
    else
    {
      _vehPool = vehCSATTrucks;
    }
  };
};
_typeGroup = [];
if (!_isEasy) then
{
  if (!(_typeVehEsc in vehTanks)) then
  {
    _typeGroup = [_typeVehEsc,_side] call A3A_fnc_cargoSeats;
  };
}
else
{
  if (not(_typeVehEsc == vehFIAArmedCar)) then
  {
    _typeGroup = selectRandom groupsFIASquad;
    if (_typeVehEsc == vehFIACar) then
    {
      _typeGroup = selectRandom groupsFIAMid;
    };
  };
};

[[_selectedVehicle, _typeGroup], _vehPool];
