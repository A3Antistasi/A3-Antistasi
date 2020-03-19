private _filename = "fn_postmortem";
[3,"PostMortem Called",_filename] call A3A_fnc_log;
params ["_victim"];

if !(_victim)exitwith{[3,"Function failed called with null param.",_filename] call A3A_fnc_log;}

/*  Handles the despawn and cleanup of dead units
*   Params:
*       _victim : OBJECT : The dead unit
*
*   Returns:
*       Nothing
*/

private _group = group _victim;
if (isNull _group || isNil "_group" ) then
{

    groupStr = format["Group for victim :: %1, assigned :: %2.",_victim, _group];
    [3,groupStr,_filename] call A3A_fnc_log;

	if (_victim in staticsToSave) then
    {
        staticsToSave = staticsToSave - [_victim];
        publicVariable "staticsToSave";
    };
};

[] spawn {
    sleep cleantime;
    deleteVehicle _victim;
    deleteGroup _group;
}
