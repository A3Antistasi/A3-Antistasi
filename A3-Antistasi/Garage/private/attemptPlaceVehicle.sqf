#include "..\defineCommon.inc"

//vehPlace_lastPreviewPosition = nil;
_pos = getPosASL vehPlace_previewVeh;
_dir = getDir vehPlace_previewVeh;
_vehicleType = typeOf vehPlace_previewVeh;
deleteVehicle vehPlace_previewVeh;

private _canPlaceArray = [vehPlace_callbackTarget, CALLBACK_CAN_PLACE_VEH , [vehPlace_previewVeh]] call A3A_fnc_vehPlacementCallbacks;
if (isNil "_canPlaceArray") then {
	diag_log format ["[Antistasi] No Can Place Vehicle Callback registered for %1", vehPlace_callbackTarget];
	_canPlaceArray = [true];
};

//EachFrame handler should have exited if we're in here.
//If that ever changes, change below.
if (!(_canPlaceArray select 0))	exitWith {
		hint (_canPlaceArray select 1);
		[] call A3A_fnc_handleVehPlacementCancelled;
};

//Only show text after we've checked all of the failure conditions above.
["<t size='0.6'>Vehicle Placed",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
	
waitUntil {isNull vehPlace_previewVeh};

private _garageVeh = createVehicle [_vehicleType, [0,0,1000], [], 0, "NONE"];
_garageVeh setDir _dir;
//Surely this overrides any collision checks createVehicle would have made?
_garageVeh setPosASL _pos;

clearMagazineCargoGlobal _garageVeh;
clearWeaponCargoGlobal _garageVeh;
clearItemCargoGlobal _garageVeh;
clearBackpackCargoGlobal _garageVeh;

[vehPlace_callbackTarget, CALLBACK_VEH_PLACED_SUCCESSFULLY, [_garageVeh]] call A3A_fnc_vehPlacementCallbacks;

_garageVeh allowDamage true;
_garageVeh enableSimulationGlobal true;

[] call A3A_fnc_vehPlacementCleanup;
