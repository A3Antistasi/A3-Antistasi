params ["_destination", "_type", "_side", ["_arguments", []]];

/* params
*   _destination : MARKER or POS; the marker or position the AI should take AI on
*   _type : STRING; (not case sensitive) one of "ATTACK", "PATROL", "REINFORCE", "CONVOY", "AIRSTRIKE" more to add
*   _side : SIDE; the side of the AI forces to send
*   _arguments : ARRAY; any further argument needed for the operation
+        -here should be some manual for each _type
*/

if(!serverInitDone) then
{
  diag_log "CreateAIAction: Waiting for server init to be completed!";
  waitUntil {sleep 1; serverInitDone};
};

if(isNil "_destination") exitWith {diag_log "CreateAIAction: No destination given for AI Action"};
_acceptedTypes = ["attack", "patrol", "reinforce", "convoy", "airstrike"];
if(isNil "_type" || {!((toLower _type) in _acceptedTypes)}) exitWith {diag_log "CreateAIAction: Type is not in the accepted types"};
if(isNil "_side" || {!(_side == Occupants || _side == Invaders)}) exitWith {diag_log "CreateAIAction: Can only create AI for Inv and Occ"};

_convoyID = round (random 100);
_IDinUse = server getVariable [str _convoyID, false];
sleep 0.1;
while {_IDinUse} do
{
  _convoyID = round (random 100);
  _IDinUse = server getVariable [str _convoyID, false];
};
server setVariable [str _convoyID, true, true];

_type = toLower _type;
_isMarker = _destination isEqualType "";
_targetString = if(_isMarker) then {_destination} else {str _destination};
diag_log format ["CreateAIAction[%1]: Started creation of %2 action to %3", _convoyID, _type, _targetString];

_nearestMarker = if(_isMarker) then {_destination} else {[markersX,_destination] call BIS_fnc_nearestPosition};
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

_destinationPos = if(_destination isEqualType "") then {getMarkerPos _destination} else {_destination};
_originPos = [];
_origin = "";
_units = [];
_vehicleCount = 0;
_cargoCount = 0;
if(_type == "patrol") then
{

};
if(_type == "reinforce") then
{
  //Should outpost are able to reinforce to?
  _arguments params [["_small", true]];
  _airport = [_destination, _side] call A3A_fnc_findAirportForAirstrike;
  if(_airport != "") then
  {
    _land = true; //if ((getMarkerPos _airport) distance _destinationPos > distanceForLandAttack) then {false} else {true};
    _typeGroup = if (_side == Occupants) then {if (_small) then {selectRandom groupsNATOmid} else {selectRandom groupsNATOSquad}} else {if (_small) then {selectRandom groupsCSATmid} else {selectRandom groupsCSATSquad}};

    _typeVeh = "";
    if (_land) then
    {
    	if (_side == Occupants) then {_typeVeh = selectRandom vehNATOTrucks} else {_typeVeh = selectRandom vehCSATTrucks};
    }
    else
    {
    	_vehPool = if (_side == Occupants) then {vehNATOTransportHelis} else {vehCSATTransportHelis};
    	if ((_small) and (count _vehPool > 1) and !hasIFA) then {_vehPool = _vehPool - [vehNATOPatrolHeli,vehCSATPatrolHeli]};
    	_typeVeh = selectRandom _vehPool;
    };
    _origin = _airport;
    _originPos = getMarkerPos _airport;
    _units pushBack [_typeVeh, _typeGroup];
    _vehicleCount = 1;
    _cargoCount = (count _typeGroup);
  }
  else
  {
    diag_log format ["CreateAIAction[%1]: Reinforcement aborted as no airport is available!", _convoyID];
    _abort = true;
  };
};
if(_type == "attack") then
{

};
if(_type == "airstrike") then
{
  _airport = [_destination, _side] call A3A_fnc_findAirportForAirstrike;
  if(_airport != "") then
  {
    _friendlies = if (_side == Occupants) then
    {
      allUnits select
      {
        (alive _x) &&
        {((side (group _x) == _side) || (side (group _x) == civilian)) &&
        {_x distance _destinationPos < 200}}
      };
    }
    else
    {
      allUnits select
      {
        (side (group _x) == _side) &&
        {(_x distance _destinationPos < 100) &&
        {[_x] call A3A_fnc_canFight}}
      };
    };
    //NATO accepts 2 casulties, CSAT does not really care
    if((_side == Occupants && {count _friendlies < 3}) || {_side == Invaders && {count _friendlies < 8}}) then
    {
      _plane = if (_side == Occupants) then {vehNATOPlane} else {vehCSATPlane};
    	if ([_plane] call A3A_fnc_vehAvailable) then
    	{
        _bombType = "";
        if(count _arguments != 0) then
        {
          _bombType = _arguments select 0;
        }
        else
        {
          _distanceSpawn2 = distanceSPWN2;
          _enemies = allUnits select
          {
            (alive _x) &&
            {(_x distance _destinationPos < _distanceSpawn2) &&
            {(side (group _x) != _side) and (side (group _x) != civilian)}}
          };
          if(isNil "napalmEnabled") then
          {
            //This seems to be a merge bug
            diag_log "CreateAIAction: napalmEnabled does not contains a value, assuming false!";
            napalmEnabled = false;
          };
          _bombType = if (napalmEnabled) then {"NAPALM"} else {"CLUSTER"};
    			{
    			  if (vehicle _x isKindOf "Tank") then
    				{
    				   _bombType = "HE" //Why should it attack tanks with HE?? TODO find better solution
    				}
    			  else
    				{
    				  if (vehicle _x != _x) then
    					{
    					  if !(vehicle _x isKindOf "StaticWeapon") then {_bombType = "CLUSTER"}; //TODO test if vehicle _x isKindOf Static is not also vehicle _x != _x
    					};
    				};
    			  if (_bombTypeX == "HE") exitWith {};
    			} forEach _enemies;
        };
        if (!_isMarker) then {airstrike pushBack _destinationPos};
        diag_log format ["CreateAIAction[%1]: Selected airstrike of bombType %2 from %3",_convoyID, _bombType, _airport];
        _origin = _airport;
        _originPos = getMarkerPos _airport;
        _units pushBack [_plane, []];
        _vehicleCount = 1;
        _cargoCount = 0;
      }
      else
      {
        diag_log format ["CreateAIAction[%1]: Aborting airstrike as the airplane is currently not available", _convoyID];
        _abort = true;
      };
    }
    else
    {
      diag_log format ["CreateAIAction[%1]: Aborting airstrike, cause there are too many friendly units in the area", _convoyID];
      _abort = true;
    };
  }
  else
  {
    diag_log format ["CreateAIAction[%1]: Aborting airstrike due to no avialable airport", _convoyID];
    _abort = true;
  };

};
if(_type == "convoy") then
{

};

if(_abort) exitWith {};

_target = if(_destination isEqualType "") then {name _destination} else {str _destination};
diag_log format ["CreateAIAction[%1]: Created AI action to %2 from %3 to %4 with %5 vehicles and %6 units", _convoyID, _type, _origin, _targetString, _vehicleCount , _cargoCount];

[_convoyID, _units, _originPos, _destinationPos, _type, _side] spawn A3A_fnc_createConvoy;
