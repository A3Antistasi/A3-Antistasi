/*
    Author: [Håkon]
    [Description]
        intermidiary between dialog EH and confim placement
        gathers and formats data used in vehicle placement

    Arguments: <nil>

    Return Value: <nil>

    Scope: Clients
    Environment: Any
    Public: No
    Dependencies:

    Example: [] call HR_GRG_fnc_confirm;

    License: APL-ND
*/
HR_GRG_SelectedVehicles params ["_catIndex", "_vehUID", "_class"];
if (_vehUID isEqualTo -1) exitWith {["STR_HR_GRG_Feedback_confirm_NullSelection"] call HR_GRG_fnc_Hint};

//get mounts state
HR_GRG_Mounts apply {
    private _static = (HR_GRG_Vehicles#4) get (_x#1);
    _x pushBack (_static#4);
    _x
};

[
    _class
    , nil //not used internaly
    , nil //not used internaly
    , HR_GRG_Mounts
    , if (
            HR_GRG_Pylons_Enabled //Pylon editing enabled
            && { HR_GRG_hasAmmoSource } //or ammo source registered
    ) then {HR_GRG_Pylons} else {nil}
    , HR_GRG_previewVehState
    , true
] call HR_GRG_fnc_confirmPlacement;
closeDialog 2;
