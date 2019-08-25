params ["_destination", "_type", "_side", ["_arguments", []]];

/* params
*   _destination : MARKER or POS; the marker or position the AI should take AI on
*   _type : STRING; (not case sensitive) one of "ATTACK", "PATROL", "REINFORCE", "CONVOY", "AIRSTRIKE" more to add
*   _side : SIDE; the side of the AI forces to send
*   _arguments : ARRAY; any further argument needed for the operation
+        -here should be some manual for each _type
*/

if(isNil "_destination") exitWith {diag_log "CreateAIAction: No destination given for AI Action"};
_acceptedTypes = ["attack", "patrol", "reinforce", "convoy", "airstrike"];
if(isNil "_side" || {!((toLower _type) in _destination)}) exitWith {diag_log "CreateAIAction: Type is not in the accepted types"};
if(isNil "_side") exitWith {diag_log "CreateAIAction: Can only create AI for Inv and Occ"};

_convoyID = random 10000;
_IDinUse = server getVariable [_convoyID, false];
while {_IDinUse} do
{
  _convoyID = random 10000;
  _IDinUse = server getVariable [_convoyID, false];
};
server setVariable [_convoyID, true, true];

_type = toLower _type;
_isMarker = _destination isEqualType "";
_targetString = if(_isMarker) then {name _destination} else {str _destination};
diag_log format ["CreateAIAction[%1]: Started creation of %2 action to %3", _convoyID, _type, _targetString];

_nearestMarker = if(_isMarker) then {_destination} else {[markersX,_destination] call BIS_fnc_nearestPosition;}
if ([_nearestMarker,false] call A3A_fnc_fogCheck < 0.3) exitWith {diag_log format ["CreateAIAction[%1]: AI Action on %2 cancelled because of heavy fog", _convoyID, _targetString]};

_abort = false;
_attackDistance = distanceSPWN2;
if (_isMarker) then
{
  if(_destination in attackMrk) then {_abort = true};
  _destination = getMarkerPos _destination;
}
else
{
  if(count attackPos != 0) then
  {
    _nearestAttack = [attackPos, _destination] call BIS_fnc_nearestPosition;
    if ((_nearestAttack distance _destination) < _attackDistance) then {_abort = true;};
  }
  else
  {
    if(count attackMrk != 0) then
    {
      _nearestAttack = [attackMrk, _destination] call BIS_fnc_nearestPosition;
      if (getMarkerPos _nearestAttack distance _destination < _attackDistance) then {_abort = true};
    };
  };
};
if(_abort) exitWith {diag_log format ["CreateAIAction[%1]: Aborting creation of AI action because, there is already a action close by!", _convoyID]};

_sideConvoy = sidesX getVariable [_origin, sideUnknown];
if(_sideConvoy == sideUnknown) exitWith {diag_log "Marker has no side!"};

_originPos = getMarkerPos _origin;
_destinationPos = if(_destination isEqualType "") then {getMarkerPos _destination} else {_destination};
//Does this work like this?

_units = [];
if(_type == "patrol") then
{

};
if(_type == "reinforce") then
{

};
if(_type == "attack") then
{

};
if(_type == "airstrike") then
{

};
if(_type == "convoy")



_target = if(_destination isEqualType "") then {name _destination} else {str _destination};
diag_log format ["[%1] Created %2 units for %2 from %3 to %4 with %5 vehicles and %6 units", _convoyID, _type, name _origin, _target, 0 , 0];

[_convoyID, _units, _originPos, _destinationPos, _type, _sideConvoy] spawn A3A_fnc_createConvoy;
