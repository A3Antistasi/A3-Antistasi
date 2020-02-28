params ["_intel"];

/*  Handles the retrieving of medium intel
*   Params:
*       _intel : OBJECT : The object which is holding the intel
*
*   Returns:
*       Nothing
*/

//Take intel from desk
private _side = _intel getVariable "side";
hint "Intel documents taken";
private _intelText = ["Medium", _side] call A3A_fnc_selectIntel;
{
    [5,_x] call A3A_fnc_playerScoreAdd;
    [_intelText] remoteExec ["A3A_fnc_showIntel", _x];
} forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
deleteVehicle _intel;
