private ["_veh"];

_veh = _this select 0;

sleep 5;

if (isNull _veh) exitWith {};

if (!alive _veh) then
	{
	_veh hideObjectGlobal true;
	deleteVehicle _veh;
	if (debug) then {stavros globalChat format ["Spawned vehicle %1 exploded. Deleting",typeOf _veh]};
	};
