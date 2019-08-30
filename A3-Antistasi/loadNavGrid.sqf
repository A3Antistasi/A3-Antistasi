[] spawn
{
  _deltaTime = time;

  getMainMarker = compile preprocessFileLineNumbers "getMainMarker.sqf";
  publicVariable "getMainMarker";
  setNavOnMarker = compile preprocessFileLineNumbers "setNavOnMarker.sqf";
  publicVariable "setNavOnMarker";
  findNearestNavPoint = compile preprocessFileLineNumbers "findNearestNavPoint.sqf";
  publicVariable "findNearestNavPoint";
  getNavPos = compile preprocessFileLineNumbers "getNavPos.sqf";
  publicVariable "getNavPos";
  calculateH = compile preprocessFileLineNumbers "calculateH.sqf";
  publicVariable "calculateH";
  getNavConnections = compile preprocessFileLineNumbers "getNavConnections.sqf";
  publicVariable "getNavConnections";

  mainMarker = [];

  _name = worldName;
  _name = toLower _name;
  if(_name == "altis") then {_name = "Altis"};
  if(_name == "tanoa") then {_name = "Tanoa"};
  if(_name == "stratis") then {_name = "Stratis"}; //Debug
  if(_name == "malden") then {_name = "Malden"};
  //TODO add remaining maps

  _path = format ["NavGrids\navGrid%1.sqf", _name];
  if((loadFile _path) isEqualTo "") exitWith
  {
    hint format ["Could not load navGridFile with path %1", _path];
  };

  //Load in the nav grid array
  [] call compile preprocessFileLineNumbers _path;
  //sleep 2;

  _worldSize = worldSize;
  _chunkSize = 1000; //1000 meters per marker
  _offset = _chunkSize / 2;

  _markerNeeded =  floor (_worldSize / _chunkSize) + 1;

  //hint format ["Marker per side %1, all %2", _markerNeeded, (_markerNeeded * _markerNeeded)];

  {
      _navPointData = _x;
      _index = _navPointData select 0;
      _position = _navPointData select 1;

      _mainMarker = [_position] call getMainMarker;
      [_index, _mainMarker] call setNavOnMarker;
  } forEach navGrid;

  for "_i" from 0 to (_markerNeeded - 1) do
  {
    for "_j" from 0 to (_markerNeeded - 1) do
    {
      _markerPos = [_offset + _i * _chunkSize, _offset + _j * _chunkSize];
      _marker = createMarker [format ["%1/%2", _i, _j], _markerPos];
      _marker setMarkerShape "ICON";
      _marker setMarkerType "mil_circle";
      _marker setMarkerColor "ColorBlack";
      _points = missionNamespace getVariable [(format ["%1/%2_data", _i, _j]), []];
      _marker setMarkerText (format ["%1/%2, NavPoints: %3", _i, _j, count _points]);
      _marker setMarkerAlpha 1;

      mainMarker pushBack "_marker";
    };
  };

  _deltaTime = time - _deltaTime;
  hint format ["Nav grid load and prepared in %1 seconds", _deltaTime];
};
