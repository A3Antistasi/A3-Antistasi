private ["_veh"];

_veh = _this select 0;

while {alive _veh} do
	{
	sleep 600;
	_veh setVehicleAmmoDef 1;
	_veh setFuel 1;
	};