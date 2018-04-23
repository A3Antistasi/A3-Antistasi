
private ["_posHQ"];
_posHQ = getMarkerPos "respawn_guerrila";

{if ((side _x == buenos) or (side _x == civilian) and (_x distance _posHQ < 150)) then {_x setDamage 0}} forEach allUnits;
{
if ((_x distance _posHQ < 150) and (alive _x)) then
	{
	_x setDamage 0;
	//_x setVehicleAmmoDef 1;
	[_x,1] remoteExec ["setVehicleAmmoDef",_x];
	};
} forEach vehicles;

hint "All nearby units and vehicles have been healed or repaired. Near vehicles have been rearmed at full load."