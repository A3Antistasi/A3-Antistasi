/**
   Vehicle collision check
   
   Checks if a vehicle will collide with anything if moved to the target location;
   
   Internally, we get the corners of the vehicle's bounding box, and fire off some collision detection lines between them to see if they hit anything.
   
   Params:
	_vehicle - Vehicle to test
	_position - Position to move to, in AGL format
**/


params ["_vehicle", "_targetPos"];

private _vehiclePosAGL = getPos _vehicle;
private _boundingBox = boundingBoxReal _vehicle; 
private _corners = [ 
	//Bottom - rear - left 
	[_boundingBox # 0 # 0, _boundingBox # 0 # 1, _boundingBox # 0 # 2], 
	//Bottom - front - left 
	[_boundingBox # 0 # 0, _boundingBox # 1 # 1, _boundingBox # 0 # 2], 
	//Bottom - rear - right 
	[_boundingBox # 1 # 0, _boundingBox # 0 # 1, _boundingBox # 0 # 2], 
	//Bottom - front - right 
	[_boundingBox # 1 # 0, _boundingBox # 1 # 1, _boundingBox # 0 # 2], 
	//Top - rear - left 
	[_boundingBox # 0 # 0, _boundingBox # 0 # 1, _boundingBox # 1 # 2], 
	//Top - front - left 
	[_boundingBox # 0 # 0, _boundingBox # 1 # 1, _boundingBox # 1 # 2], 
	//Top - rear - right 
	[_boundingBox # 1 # 0, _boundingBox # 0 # 1, _boundingBox # 1 # 2], 
	//Top - front - right 
	[_boundingBox # 1 # 0, _boundingBox # 1 # 1, _boundingBox # 1 # 2] 
]; 
 
private _lines = [ 
	//Bottom - rear - left to Bottom - rear - right 
	[_corners # 0, _corners # 2], 
	//Bottom - front - left to Bottom - front - right 
	[_corners # 1, _corners # 3], 
	//Bottom - rear - left to Bottom - front - left 
	[_corners # 0, _corners # 1], 
	//Bottom - rear - right to Bottom - front - right 
	[_corners # 2, _corners # 3], 
	//Top - rear - left to Bottom - rear - right 
	[_corners # 4, _corners # 6], 
	//Top - front - left to Bottom - front - right 
	[_corners # 5, _corners # 7], 
	//Top - rear - left to Bottom - front - left 
	[_corners # 4, _corners # 5], 
	//Top - rear - right to Bottom - front - right 
	[_corners # 6, _corners # 7],
	//Diagonal - Bottom - rear - left to Top - front - right
	[_corners # 0, _corners # 7]
]; 
 
private _collision = false; 
private _heightOffset = (_boundingBox # 1 # 2) - (_boundingBox # 0 # 2) / 2; 

if (debugVehicleCollision) then {
	vehicleCollisionCheckCornerLocations = []; 
};

{ 
	//private _startPos = _targetPos vectorAdd (_x # 0) vectorAdd [0, 0, _height]; 
	private _startPosModelSpace = _x select 0;
	private _endPosModelSpace = _x select 1;
	private _startPosVehicleCurrentLocation = _vehicle modelToWorld (_startPosModelSpace);
	private _endPosVehicleCurrentLocation = _vehicle modelToWorld (_endPosModelSpace);

	private _positionDifference = [
		_targetPos # 0 - _vehiclePosAGL # 0,
		_targetPos # 1 - _vehiclePosAGL # 1,
		_targetPos # 2 - _vehiclePosAGL # 2
	];

	private _startPos = [
		_startPosVehicleCurrentLocation # 0 + _positionDifference # 0,
		_startPosVehicleCurrentLocation # 1 + _positionDifference # 1,
		0.1 + _startPosModelSpace # 2 + _heightOffset
	];

	if (debugVehicleCollision) then {
		vehicleCollisionCheckCornerLocations pushBack ( _startPos); 
	};

	private _endPos = [
		_endPosVehicleCurrentLocation # 0 + _positionDifference # 0,
		_endPosVehicleCurrentLocation # 1 + _positionDifference # 1,
		0.1 + _startPosModelSpace # 2 + _heightOffset
	];

	if (debugVehicleCollision) then {
		vehicleCollisionCheckCornerLocations pushBack (_endPos);
	};
	

	private _result = lineIntersectsSurfaces [AGLtoASL _startPos, AGLtoASL _endPos, objNull, objNull, false, 1, "FIRE", "FIRE"]; 
	if (count _result > 0) exitWith { 
		_collision = true;
	}; 
} forEach _lines; 
 
_collision; 