params ["_type", "_marker"];

/*  Checks for updates and updates the garrison if needed. SHOULD BE CALLED AFTER EVERY DESPAWN
*   Params
*     _type : STRING : The type of the marker
*     _marker : STRING : The marker name
*
*   Returns:
*     Nothing
*/

private ["_preferred", "_side", "_garCount", "_preCount", "_line"];

_preferred = garrison getVariable (format ["%1_preference", _type]);
_garrison = garrison getVariable (format ["%1_garrison", _marker]);
_side = garrison getVariable [_marker, sideUnknown];

if(_side == sideUnknown) exitWith
{
  diag_log "UpdateGarrison: Could not retrieve side!";
};

_garCount = count _garrison;
_preCount = count _preferred;

//Current garrison is bigger (not really possible) or equal preference, exit
if(_garCount >= _preCount) exitWith {};

//Adding new units to garrison
for "_i" from _garCount to (_preCount - 1) do
{
  _line = [_preferred select _i, _side] call A3A_fnc_createGarrisonLine;
  [_marker, _line, -1, true] call A3A_fnc_addRequested;
};
