params ["_origin", "_destination", "_type", ["_arguments", []]];

/*  params
*   _origin : MARKER; the marker of the starting base
*   _destination : MARKER or POS; the marker or pos of target
*   _type : STRING;  contains one of "ATTACK", "PATROL" or "REINFORCE"
*   _arguments : ARRAY; contains additional arguments for the type
*       - case "ATTACK" [_largeAttack], with
*             - _largeAttack : BOOLEAN; true if large attack, false otherwise
*       - case "PATROL" []
*       - case "REINFORCE" []
*
*   returns
*   nothing
*/

if(isNil "_origin") exitWith {diag_log "CreateSimulated: No origin given!"};
if(isNil "_destination") exitWith {diag_log "CreateSimulated: No destination given!"};
if(isNil "_type") exitWith {diag_log "CreateSimulated: No type given!"};

_sideConvoy = sidesX getVariable [_origin, sideUnknown];
if(_sideConvoy == sideUnknown) exitWith {diag_log "Marker has no side!"};

_originPos = getMarkerPos _origin;
_destinationPos = if(_destination isEqualType "") then {getMarkerPos _destination} else {_destination};
//Does this work like this?

_units = [];
if(_type == "PATROL") then
{

};
if(_type == "REINFORCE") then
{

};
if(_type == "ATTACK") then
{

};

_convoyID = random 10000;
_IDinUse = server getVariable [_convoyID, false];
while {_IDinUse} do
{
  _convoyID = random 10000;
  _IDinUse = server getVariable [_convoyID, false];
};
server setVariable [_convoyID, true, true];

_target = if(_destination isEqualType "") then {name _destination} else {str _destination};
diag_log format ["[%1] Created %2 units for %2 from %3 to %4 with %5 vehicles and %6 units", _convoyID, _type, name _origin, _target, 0 , 0];

[_convoyID, _units, _originPos, _destinationPos, _type, _sideConvoy] spawn A3A_fnc_createConvoy;
