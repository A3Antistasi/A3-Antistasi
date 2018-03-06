private ["_toDelete"];

[[petros,"hint","Deleting Garbage. Please wait"],"commsMP"] call BIS_fnc_MP;

{deleteVehicle _x} forEach allDead;
{deleteVehicle _x} forEach (allMissionObjects "WeaponHolder");
{deleteVehicle _x} forEach (allMissionObjects "WeaponHolderSimulated");

[[petros,"hint","Garbage deleted"],"commsMP"] call BIS_fnc_MP;