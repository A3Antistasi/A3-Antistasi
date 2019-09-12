params ["_marker"];

/*  Calculates the strength of the garrison, based on units active
*   Params:
*     _marker: STRING : The name of the marker on which the garrison should be checked
*
*   Returns:
*     _result: STRING : One of "Good", "Weakend" and "Decimated", determining the strength
*/

private ["_debug", "_garrison", "_neededReinf", "_garrisonCount", "_reinfCount", "_allUnitsCount", "_aliveUnitsCount", "_data", "_result", "_ratio"];
_debug = debug;

if(isNil "_marker") exitWith {diag_log "GetGarrisonStrength: No marker given!";};

_garrison = [_marker] call A3A_fnc_getGarrison;
_neededReinf = [_marker] call A3A_fnc_getNeededReinforcements;

_garrisonCount = count _garrison;
_reinfCount = count _neededReinf;
_allUnitsCount = 0;
_aliveUnitsCount = 0;

if(_debug) then
{
  diag_log "GetGarrisonStrength: Calculating garrison strength now!";
};


for "_i" from 0 to (_garrisonCount - 1) do
{
  _data = _garrison select _i;
  if((_data select 0) != "") then
  {
    _allUnitsCount = _allUnitsCount + 1;
    _aliveUnitsCount = _aliveUnitsCount + 1;
  };
  _allUnitsCount = _allUnitsCount + (count (_data select 1)) + (count (_data select 2));
  _aliveUnitsCount = _aliveUnitsCount + (count (_data select 1)) + (count (_data select 2));
  if(_i < _reinfCount) then
  {
    _data = _neededReinf select _i;
    if((_data select 0) != "") then
    {
      _allUnitsCount = _allUnitsCount + 1;
    };
    _allUnitsCount = _allUnitsCount + (count (_data select 1)) + (count (_data select 2));
  };
};

if(_debug) then
{
  diag_log format ["GetGarrisonStrength: Found %1 units in total, %2 of them are alive", _allUnitsCount, _aliveUnitsCount];
};

_result = "Decimated";
if(_allUnitsCount > 0) then
{
  _ratio = _aliveUnitsCount / _allUnitsCount;
  if(_ratio > 0.9) then {_result = "Good"}
  else
  {
    if(_ratio > 0.4) then {_result = "Weakend"};
  };
};

if(_debug) then
{
  diag_log format ["GetGarrisonStrength: Result is %1", _result];
};

_result;
