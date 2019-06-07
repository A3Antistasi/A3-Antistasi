private _veh = cursorObject;
if (_veh isKindOf "landVehicle") then {
	_veh spawn {
		sleep 5 + random(15);
		{
            unassignvehicle _x;
            _x action["Eject", _this];
        } forEach (crew _this);
		doGetOut (crew _this);
	};
};
