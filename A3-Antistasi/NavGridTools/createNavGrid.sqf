#define EXIT_POINTS         0
#define MID_POSITION        1
#define IGNORED_JUNCTIONS   2
#define MID_SEGMENT         3

[] spawn
{

  findConnection = compile preprocessFileLineNumbers "NavGridTools\findRoadConnections.sqf";
  publicVariable "findConnection";
  createJunction = compile preprocessFileLineNumbers "NavGridTools\createJunctionData.sqf";
  publicVariable "createJunction";
  getRoadName = compile preprocessFileLineNumbers "NavGridTools\getRoadName.sqf";
  publicVariable "getRoadName";
  createNavMarker = compile preprocessFileLineNumbers "NavGridTools\createNavMarker.sqf";
  publicVariable "createNavMarker";
  setNavPoint = compile preprocessFileLineNumbers "NavGridTools\setNavPoint.sqf";
  publicVariable "setNavPoint";
  setNavConnection = compile preprocessFileLineNumbers "NavGridTools\setNavConnection.sqf";
  publicVariable "setNavConnection";
  getRoadType = compile preprocessFileLineNumbers "NavGridTools\getRoadType.sqf";
  publicVariable "getRoadType";
  createNavText = compile preprocessFileLineNumbers "NavGridTools\createNavText.sqf";
  publicVariable "createNavText";

  allMarker = [];

  _startPos = getMarkerPos "roadMarker";

/*
  _startSegment = roadAt _startPos;
  if(true) exitWith {[_startSegment] call getRoadType};
*/
  _possibleStarts = _startPos nearRoads 50;
  _startSegment = objNull;
  {
      _connected = roadsConnectedTo _x;
      if(count _connected > 2) exitWith {_startSegment = _x};
  } forEach _possibleStarts;

  if(isNull _startSegment) exitWith
  {
    //diag_log "Could not find suitable start segment, segment has to be a junction!";
    hint "No segment was a junction, try another position!";
  };



  _startTime = time;

  _navPoints = [];
  _openStartSegments = [[_startSegment, objNull]];
  _junctionSegments = [];
  _junctionIgnored = [];

  _segmentsTillNext = 5;
  _segmentCount = 0;

  private ["_currentSegment", "_lastSegment", "_currentIgnored" ,"_connected", "_roadType"];

  _roadType = 0;
  _outerLoop = 0;
  _innerLoop = 0;
  _debugText = "";

  _exit = false;
  while {count _openStartSegments > 0} do
  {
    _outerLoop = _outerLoop + 1;
    _currentIgnored = [];
    _startData = _openStartSegments deleteAt 0;
    _currentSegment = _startData select 0;
    _connectedNavPoint = _startData select 1;
    _lastSegment = objNull;

    _navMarker = missionNamespace getVariable [format ["%1_m", [_currentSegment] call getRoadName], objNull];
    if(_navMarker isEqualType "") then {deleteMarker _navMarker};

    _innerLoop = 0;
    _segmentCount = 0;
    while {!(isNull _currentSegment)} do
    {
      //Loop counter, only for debug
      _innerLoop = _innerLoop + 1;

      //Counter for nav points
      _segmentCount = _segmentCount + 1;
      _currentIgnored pushBack _currentSegment;

      //Get all connected
      _connected = [_currentSegment] call findConnection;

      //Sorting out my start navSegment and every ignored segment
      _connected = _connected select {!(_x in _currentIgnored) && {!(_x in _junctionIgnored)}};
      _connectedCount = count _connected;

      _debug = "";

      //No further conncetion found, end of road
      if(_connectedCount == 0) then
      {
        _debug = "0 Con";
        //If no lastSegment something has gone wrong with the junction, ignore in this case
        if(!(isNull _lastSegment)) then
        {
          //Sets the navpoint
          _navPointName = [_currentSegment] call getRoadName;
          _roadType = [_currentSegment] call getRoadType;
          [_navPointName, getPos _currentSegment, [], _roadType] call setNavPoint;
          _navPoints pushBack _navPointName;
          [_connectedNavPoint, _navPointName] call setNavConnection;

          //Sets the marker
          _marker = ["mil_triangle", getPos _currentSegment, "ColorBlue"] call createNavMarker;
          _marker setMarkerText "End";
        };
        _currentSegment = objNull;
      };


      //Only one way to go, go further if the next node is not an navSegment
      if(_connectedCount == 1) then
      {
        _debug = "1 Con";
        if(!((_connected select 0) in _junctionSegments)) then
        {
          if(_segmentCount > _segmentsTillNext) then
          {
            _navPointName = [_currentSegment] call getRoadName;
            _roadType = [_currentSegment] call getRoadType;
            [_navPointName, getPos _currentSegment, [], _roadType] call setNavPoint;
            _navPoints pushBack _navPointName;

            [_connectedNavPoint, _navPointName] call setNavConnection;

            _junctionIgnored pushBack _currentSegment;

            _next = (_connected select 0);
            _nameX = [_next] call getRoadName;
            //Sets origin of this segment
            missionNamespace setVariable [format ["%1_c", _nameX], _navPointName];

            //Creates and save the marker
            _marker = ["mil_dot", getPos _next, "ColorRed"] call createNavMarker;
            missionNamespace setVariable [format ["%1_m", _nameX], _marker];

            //Sets the exit as blocked and new start point
            _openStartSegments pushBack [_next, _navPointName];
            _junctionSegments pushBack _next;

            //Add lastSegment to junctionSegments (just to be sure)
            if(!(isNull _lastSegment)) then
            {
              _junctionSegments pushBack _lastSegment;
              missionNamespace setVariable [format ["%1_c",[_lastSegment] call getRoadName], _navPointName];
            };

            _marker = ["mil_box", getPos _currentSegment, "ColorBlack"] call createNavMarker;
            _marker setMarkerText "2";

            _currentSegment = objNull;
          }
          else
          {
            _marker = ["mil_dot", getPos _currentSegment, "ColorGreen"] call createNavMarker;

            _lastSegment = _currentSegment;
            _currentSegment = _connected select 0;
            _marker spawn
            {
              sleep 3;
              deleteMarker _this;
            };
          };
        }
        else
        {
          _next = (_connected select 0);
          _nameNext = [_next] call getRoadName;
          _conNav = missionNamespace getVariable [format ["%1_c", _nameNext], -1];
          [_conNav, _connectedNavPoint] call setNavConnection;
          _currentSegment = objNull;
        };
      };

      //More than one connection, may be a junction or a fake junction
      if(_connectedCount > 1) then
      {
        _debug = ">1 Con";
        //Create junction data
        //There is a problem, comming form a length junction directly into a real junction will have last segment set to objNull, making the exitPoint possible...
        private _result = [_lastSegment, _currentSegment] call createJunction;
        if(_result isEqualTo []) exitWith
        {
          diag_log "Something went wrong, result is empty";
          sleep 2;
        };

        //Get exit points
        _exitPoints = _result select EXIT_POINTS;

        if(count _exitPoints == 1) then
        {
          //Found two ways close by for the same exit, no junction!
          if(!((_exitPoints select 0) in _junctionSegments)) then
          {
            if(_segmentCount > _segmentsTillNext) then
            {
              _navPointName = [_currentSegment] call getRoadName;
              _roadType = [_currentSegment] call getRoadType;
              [_navPointName, getPos _currentSegment, [], _roadType] call setNavPoint;
              _navPoints pushBack _navPointName;

              _junctionIgnored pushBack _currentSegment;

              [_connectedNavPoint, _navPointName] call setNavConnection;

              _next = (_connected select 0);
              _nameX = [_next] call getRoadName;
              //Sets origin of this segment
              missionNamespace setVariable [format ["%1_c", _nameX], _navPointName];

              //Creates and save the marker
              _marker = ["mil_dot", getPos _next, "ColorRed"] call createNavMarker;
              missionNamespace setVariable [format ["%1_m", _nameX], _marker];

              //Sets the exit as blocked and new start point
              _openStartSegments pushBack [_next, _navPointName];
              _junctionSegments pushBack _next;

              //Add lastSegment to junctionSegments (just to be sure)
              if(!(isNull _lastSegment)) then
              {
                _junctionSegments pushBack _lastSegment;
                missionNamespace setVariable [format ["%1_c",[_lastSegment] call getRoadName], _navPointName];
              };

              _marker = ["mil_box", getPos _currentSegment, "ColorBlack"] call createNavMarker;
              _marker setMarkerText "2";

              _currentSegment = objNull;
            }
            else
            {
              _marker = ["mil_dot", getPos _currentSegment, "ColorGreen"] call createNavMarker;

              _lastSegment = _currentSegment;
              _currentSegment = (_exitPoints select 0);
              _currentIgnored = _currentIgnored + (_result select IGNORED_JUNCTIONS);

              _marker spawn
              {
                sleep 3;
                deleteMarker _this;
              };
            };
          }
          else
          {
            _next = (_exitPoints select 0);
            _nameNext = [_next] call getRoadName;
            _conNav = missionNamespace getVariable (format ["%1_c", _nameNext]);
            [_conNav, _connectedNavPoint] call setNavConnection;
            _currentSegment = objNull;
          };
        }
        else
        {
          //Found a real junction!

          //Sets a new navPoint for the grid
          _navPoint = _result select MID_SEGMENT;
          _navPointName = [_navPoint] call getRoadName;
          _midOfJunction = _result select MID_POSITION;
          _roadType = [_navPoint] call getRoadType;
          [_navPointName, _midOfJunction, [], _roadType] call setNavPoint;
          _navPoints pushBack _navPointName;

          //Sets the link between the start and this navpoint
          if(_connectedNavPoint isEqualType "") then
          {
            [_connectedNavPoint, _navPointName] call setNavConnection;
          };

          //Set up connections of junction
          {
            _nameX = [_x] call getRoadName;
            if(!(_nameX in _navPoints)) then
            {
              //Sets origin of this segment
              missionNamespace setVariable [format ["%1_c" ,_nameX], _navPointName];

              //Creates and save the marker
              _marker = ["mil_dot", getPos _x, "ColorRed"] call createNavMarker;
              missionNamespace setVariable [format ["%1_m", _nameX], _marker];

              //Sets the exit as blocked and new start point
              _openStartSegments pushBack [_x, _navPointName];
              _junctionSegments pushBack _x;
            };
          } forEach _exitPoints;

          //Add lastSegment to junctionSegments (just to be sure)
          if(!(isNull _lastSegment)) then
          {
            _junctionSegments pushBack _lastSegment;
            missionNamespace setVariable [format ["%1_c",[_lastSegment] call getRoadName], _navPointName];
          };
          /* Don't mark entry point, its confusing...
          ["mil_dot", getPos _currentSegment, "ColorGreen"] call createNavMarker;
          */

          _marker = ["mil_box", _midOfJunction, "ColorBlack"] call createNavMarker;
          _marker setMarkerText (str ((count _exitPoints) + 1));

          _junctionIgnored = _junctionIgnored + (_result select IGNORED_JUNCTIONS);
          _currentSegment = objNull;
        };
      };
      hintSilent format ["Open segments: %1\n Inner Loop: %2\n Outer Loop: %3\n Debug: %4", str (count _openStartSegments), _innerLoop, _outerLoop, _debug];
      //sleep 0.05;
    };
  };
  hint "Roads finished, writing data array now and deleting marker!";
  {
      deleteMarker _x;
  } forEach allMarker;


  //Road grid finished, creating grid data now
  _dataArray = [];

  _index = 0;
  {
    _navPointName = _x;
    _navPointIndex = missionNamespace getVariable [format ["index_%1", _navPointName], -1];

    if(_navPointIndex == -1) then
    {
      //Navpoint has not yet be given an index, choose smallest available
      _navPointIndex = _index;
      _index = _index + 1;
      missionNamespace setVariable [format ["index_%1", _navPointName], _navPointIndex];
    };

    _data = missionNamespace getVariable [_navPointName, "Not found"];
    if(_data isEqualType []) then
    {
      _connections = _data select 2;
      _conTransform = [];
      {

          _conType = 0;

          //Select type of connection
          _conCount = count _connections;
          _conNav = missionNamespace getVariable _x;
          if(!(_conNav isEqualType [])) then
          {
            hint (str _conNav);
            sleep 10;
          }
          else
          {
            _firstHasMore = _conCount > (count (_conNav select 2));
            if(_firstHasMore) then {_conType = (_conNav select 1)} else {_conType = _data select 1};

            //Set id of connected point
            _conIndex = missionNamespace getVariable [format ["index_%1", _x], -1];
            if(_conIndex == -1) then
            {
              _conIndex = _index;
              _index = _index + 1;
              missionNamespace setVariable [format ["index_%1", _x], _conIndex];
            };

            //Set data
            _conTransform pushBack [_conIndex, _conType];
          };
      } forEach _connections;
      _savedData = [_navPointIndex, _data select 0, _conTransform];

      //Use set to ensure correct position
      _dataArray set [_navPointIndex, _savedData];
    };
  } forEach _navPoints;

  hintSilent "Data prepare, setting up finished nav grid";

  {
      _data = _x;
      _index = _data select 0;
      _position = _data select 1;
      _connections = _data select 2;
      ["mil_box", _position, "ColorBlack"] call createNavMarker;
      {
          _conData = _x;
          _conPartner = _conData select 0;
          _conType = _conData select 1;
          if(_conPartner > _index) then
          {
            _conPartnerData = _dataArray select _conPartner;
            _conPartnerPos = _conPartnerData select 1;
            _color = "ColorBlack";
            switch (_conType) do
            {
                case (1): {_color = "ColorRed";};
                case (2): {_color = "ColorYellow";};
                case (3): {_color = "ColorGreen";};
            };
            _midOfCon = _conPartnerPos vectorAdd _position;
            _midOfCon = _midOfCon vectorMultiply (0.5);
            ["mil_dot", _midOfCon, _color] call createNavMarker;
          };
      } forEach _connections;

  } forEach _dataArray;

  _text = [_dataArray] call createNavText;
  copyToClipboard _text;

  _timeDiff = time - _startTime;
  hintC format ["Grid Creation finished, searched %1 start points and found %2 nav points in %3 seconds", _outerLoop, count _navPoints, _timeDiff];
};
