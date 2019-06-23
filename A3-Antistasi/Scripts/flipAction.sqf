private _veh = cursorObject;
if (_veh isKindOf "landVehicle") then {
	_veh setVectorUp [0,0,1];
	_veh setPosATL [(getPosATL _veh) select 0, (getPosATL _veh) select 1, 0];
};