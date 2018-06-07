
private ["_posHQ"];
_posHQ = getMarkerPos "respawn_guerrila";

{if ((side _x == buenos) or (side _x == civilian) and (_x distance _posHQ < 50)) then
	{
	if (hayACEMedical) then
		{
		[_x, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
		}
	else
		{
		if (_x getVariable ["INCAPACITATED",false]) then {_x setVariable ["INCAPACITATED",false,true]};
		_x setDamage 0;
		};
	}} forEach allUnits;
{
if ((_x distance _posHQ < 150) and (alive _x) and (isNull(attachedTo _x))) then
	{
	_x setDamage 0;
	if (_x getVariable ["INCAPACITATED",false]) then {_x setVariable ["INCAPACITATED",false,true]};
	[_x,1] remoteExec ["setVehicleAmmoDef",_x];
	};
} forEach vehicles;

hint "All nearby units and vehicles have been healed or repaired. Near vehicles have been rearmed at full load."