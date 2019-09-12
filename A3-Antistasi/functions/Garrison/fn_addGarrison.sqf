params ["_marker", "_units"];

/*  Adds units to a garrison, removes them from the reinforcements
*   Params:
*     _marker: STRING: The name of the marker
*     _units: ARRAY: The new units, formated as garrisons are
*
*   Returns:
*     Nothing
*/

if (isNil "_marker") exitWith {diag_log "AddGarrison: No marker given!"};
if (isNil "_units") exitWith {diag_log "AddGarrison: No units given!"};

private [];

_garrison = [_marker] call A3A_fnc_getGarrison;
_reinforcements = [_marker] call A3A_fnc_getNeededReinforcements;
_nonReinfUnits = [["", [], []]];

{
  //Selecting the data
  _vehicle = _x select 0;
  _crew = _x select 1;
  _cargo = _x select 2;
  _isNew = false;

  if(_vehicle != "") then
  {
    _index = _reinforcements findIf {(_x select 0) == _vehicle};
    if(_index == -1) then
    {
      //Vehicle is new, will still be added with crew
      if(_nonReinfUnits select ((count _nonReinfUnits) - 1) select 0 != "") then
      {
        //Current _nonReinfUnits already got a vehicle, add another
        _nonReinfUnits pushBack [_vehicle, _crew, []];
      }
      else
      {
        //Current _nonReinfUnits got no vehicle, add there
        (_nonReinfUnits select ((count _nonReinfUnits) - 1)) set [0, _vehicle];
        ((_nonReinfUnits select ((count _nonReinfUnits) - 1)) select 1) append _crew;
      };
      _isNew = true;
    }
    else
    {
      //Replace vehicle
      (_garrison select _index) set [0, _vehicle];
      (_reinforcements select _index) set [0, ""];
    };
  };
  if(!_isNew) then
  {
    //Add crew to existing vehicles
    {
      _crewUnit = _x;
      _index = _reinforcements findIf {count (_x select 1) > 0};
      if(_index == -1) then
      {
        //Search for vehicle with open crew space
        _index = _nonReinfUnits findIf {(_x select 0) == "" || {(count (_x select 1)) < ([_x select 0, false] call BIS_fnc_crewCount)}};
        if(_index == -1) then
        {
          //None found, open another slot
          _nonReinfUnits pushBack ["", [_crewUnit], []];
        }
        else
        {
          //Found space, adding crew unit
          ((_nonReinfUnits select _index) select 1) pushBack _crewUnit;
        };
      }
      else
      {
        //Replace crew unit
        ((_garrison select _index) select 1) pushBack _crewUnit;
        ((_reinforcements select _index) select 1) deleteAt 0; //Can simple deleted first, all crew units are the same !!! RASISM ALERT !!!
      };
    } forEach _crew;
  };
  if(count _cargo > 0) then
  {
    {
      _cargoUnit = _x;
      if(_cargoUnit == NATOCrew || _cargoUnit == CSATCrew) then
      {
        //Unit is crew member, check crew section
        _index = _reinforcements findIf {count (_x select 1) > 0};
        if(_index == -1) then
        {
          //Search for vehicle with open crew space
          _index = _nonReinfUnits findIf {(_x select 0) == "" || {(count (_x select 1)) < ([_x select 0, false] call BIS_fnc_crewCount)}};
          if(_index == -1) then
          {
            //None found, open another slot
            _nonReinfUnits pushBack ["", [_cargoUnit], []];
          }
          else
          {
            //Found space, adding crew unit
            ((_nonReinfUnits select _index) select 1) pushBack _cargoUnit;
          };
        }
        else
        {
          //Replace crew unit
          ((_garrison select _index) select 1) pushBack _cargoUnit;
          ((_reinforcements select _index) select 1) deleteAt 0; //Can simple deleted first, all crew units are the same !!! RASISM ALERT !!!
        };
      }
      else
      {
        //Unit is combat unit, add as suited
        _index = _reinforcements findIf {count (_x select 2) > 0 && {_cargoUnit in (_x select 2)}};
        if(_index == -1) then
        {
          _index = _nonReinfUnits findIf {(count (_x select 2)) < 8};
          if(_index == -1) then
          {
            //None found, open another slot
            _nonReinfUnits pushBack ["", [_cargoUnit], []];
          }
          else
          {
            //Found space, adding cargo unit
            ((_nonReinfUnits select _index) select 1) pushBack _cargoUnit;
          };
        }
        else
        {
          //Place combat unit
          ((_garrison select _index) select 1) pushBack _cargoUnit;
          (_reinforcements select _index) set [1, ((_reinforcements select _index) select 1) - [_cargo]];
        };
      };
    } forEach _cargo;
  };
} forEach _units;

//TODO sort units to avoid too much data
_garrison append _nonReinfUnits;

garrison setVariable [format ["%1_alive", _marker], _garrison];
garrison setVariable [format ["%1_dead", _marker], _reinforcements];
