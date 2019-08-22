//Repairs a destroyed building.
//Parameter can either be the ruin of a building, or the building itself buried underneath the ruins.

params ["_target"];

private _targetIsRuins = true;
//Radius 3 is fairly arbitrary here. The actual building is only clipped underground, but the X and Y coordinates can still vary a small amount.
private _nearbyBuildings = nearestObjects [getPos _target, ["Building"], 3, true];

//Find the other building.
//This is the ruin if we're targeting the building that was destroyed.
//This is the building if we're targeting the ruin.
if (_target isKindOf "Ruins") then {
	_nearbyBuildings = _nearbyBuildings select {(getPos _x select 2) < ((getPos _target select 2) min 0) && !(_x isKindOf "Ruins")};
} else {
	_nearbyBuildings = _nearbyBuildings select {(getPos _x select 2) > (getPos _target select 2) && (_x isKindOf "Ruins")};
	private _targetIsRuins = false;
};

//Haven't found our matching building. Abort, abort!
if (count _nearbyBuildings < 1) exitWith {false;};

private _buildingToRepair = objNull;
private _ruins = objNull;

if (_targetIsRuins) then {
	_buildingToRepair = _nearbyBuildings select 0;
	_ruins = _target;
} else {
	_buildingToRepair = _target;
	_ruins = _nearbyBuildings select 0;
};

_buildingToRepair setDammage 0;

deleteVehicle _ruins;

private _oldPos = getPos _buildingToRepair;
_buildingToRepair setPos [_oldPos select 0, _oldPos select 1, 0];

true;
