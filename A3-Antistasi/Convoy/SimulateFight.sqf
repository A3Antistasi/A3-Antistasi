params ["_marker", "_attackingUnits", "_sideAttacker"];

if(isNil "_marker") exitWith {diag_log "SimulateFight: Can't simulate a fight without a marker!"};
if(isNil "_attackingUnits") exitWith {diag_log "SimulateFight: No attacking units found!"};

_sideDefender = sidesX getVariable [_marker, sideUnknown];

if(_sideDefender == _sideAttacker) exitWith
{
  //This was either a reinforment convoy or a patrol, neither needs a simulated fight
  //TODO add a check whether case and act depending on it
  diag_log "SimulateFight: Attacker and Defender are the same side. No fighting needed!";
};

_attackerTroops = [];
_attackerMan = [];
_attackerCar = [];
_attackerAPC = [];
_attackerTank = [];
_attackerHeli = [];
_attackerJet = [];
_attackerStatics = [];

{
  _vehicleData = _x;
  _vehicle = _vehicleData select 0;
  _cargoUnits = _vehicleData select 1;
  _hasCargo = (count _cargoUnits) > 0;
  switch (true) do
  {
     case (_vehicle isKindOf "Car") : {_attackerCar pushBack [_vehicle, _hasCargo]};
     case (_vehicle isKindOf "APC") : {_attackerAPC pushBack [_vehicle, _hasCargo]};
     case (_vehicle isKindOf "Tank") : {_attackerTank pushBack [_vehicle, false]};
     case (_vehicle isKindOf "Helicopter") : {_attackerHeli pushBack [_vehicle, _hasCargo]};
     case (_vehicle isKindOf "Plane") : {_attackerJet pushBack [_vehicle, false]};
     case (_vehicle isKindOf "StaticWeapon") : {_attackerStatics pushBack [_vehicle, true]};
     default {};
  };
  {
    if(_x isKindOf "Man") then {_attackerMan pushBack [_x, _vehicle]};
  } forEach _cargoUnits;
} forEach _attackingUnits;

//
