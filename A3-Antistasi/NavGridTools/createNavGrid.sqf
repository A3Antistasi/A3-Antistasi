#define EXIT_POINTS         0
#define MID_POSITION        1
#define IGNORED_JUNCTIONS   2
#define MID_SEGMENT         3

_showText = true;
_showText = param [0, true];
if(isNil "_showText") then
{
  _showText = true;
};

[_showText] spawn
{
  hint "Starting setup, please stand by!";

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

  hintDone = false; publicVariable "hintDone";


  _worldName = worldName;
  _firstLetter = _worldName select [0,1];
  _remaining = _worldName select [1];
  _firstLetter = toUpper _firstLetter;
  _remaining = toLower _remaining;
  _worldName = format ["%1%2", _firstLetter, _remaining];

  //Needed for UI to function properly, don't know why
  sleep 4;

  if((_this select 0)) then
  {
    "Welcome to Wurzels NavGrid creation script" hintC (parseText format
    ["<t size='1.2' align='center'>The needed scripts should have been prepared already, so if you not had an error, you managed to copy the folder correctly. The next step is to open an empty text file, and save this empty file as navGrid%1.sqf. Keep this file open, while this script is running! As the next step the script will check if the roadMarkers are placed correctly. As a reminder: Each UNCONNECTED ISLAND needs one marker on a junction. Especially for maps with only one island, or no island at all, is still one marker needed. Due to some problems regarding the road data,
not every junction is suitable, the script will tell you, if that case happens.<br/> If you don't want to see this prompt again, execute [false] execVM 'NavGridTools\createNavGrid.sqf' instead of [] execVM ... .If you find a bug, join the Official Antistasi Discord and blame Wurzel0701 for delivering a free, but slightly bugged script. Or maybe just tell me there. <br/><br/> Also keep in mind, that this script takes a while to finish. This depends on hardware, map size and amount of roads, but is huge for most cases. Therefor the maps displays a visual representation of what the script is doing right now and how much is finished by now.</t>", _worldName]);
    hintC_EH = findDisplay 72 displayAddEventHandler ["unload",
      {
        0 = _this spawn
        {
          _this select 0 displayRemoveEventHandler ["unload", hintC_EH];
          hintSilent "";
          hintDone = true;
          publicVariable "hintDone";
        };
      }];
    waitUntil {sleep 1; hintDone};
    hintDone = false; publicVariable "hintDone";
  };


  allMarker = [];

  _abort = false;
  _roadMarker = [];
  _mapMarker = allMapMarkers;
  {
      if((_x find "roadMarker") != -1) then
      {
          _roadMarker pushBack _x;
      };
  } forEach _mapMarker;

  if(count _roadMarker == 0) then
  {
    "No roadMarkers found" hintC parseText "<t size='1.2' align='center'>Every marker which marks a starting junction has to be named with roadMarker in it. No other rules. roadMarker_1 is fine, 1_roadMarker is fine too, xXx_420_69_roadMarker_69_420_xXx totally fine (whatever reason you have to call a marker like this...), whats not ok is road_1_Marker or something like this. Place one a marker or every piece of isolated land. This includes main islands or maps with no islands too. At least one marker has to be present on every maps. The script will abort. Set the marker, then try it again!</t>";
    hintC_EH = findDisplay 72 displayAddEventHandler ["unload",
      {
        0 = _this spawn
        {
          _this select 0 displayRemoveEventHandler ["unload", hintC_EH];
          hintSilent "";
          hintDone = true;
          publicVariable "hintDone";
        };
      }];
    waitUntil {sleep 1; hintDone};
    hintDone = false; publicVariable "hintDone";
    _abort = true;
  };
  if(_abort) exitWith {};
  hint format ["Found %1 marker as start points!", count _roadMarker];

  _openStartSegments = [];
  _notOnAJunction = [];
  {
    _startPos = getMarkerPos _x;

    _possibleStarts = _startPos nearRoads 50;
    _startSegment = objNull;
    {
        _connected = roadsConnectedTo _x;
        if(count _connected > 2) exitWith {_startSegment = _x};
    } forEach _possibleStarts;

    if(isNull _startSegment) then
    {
      _abort = true;
      _notOnAJunction pushBack _x;
      //diag_log "Could not find suitable start segment, segment has to be a junction!";
      //hint "No segment was a junction, try another position!";
    }
    else
    {
      _openStartSegments pushBack [_startSegment, objNull];
    };
  } forEach _roadMarker;

  if(_abort) then
  {
    _markerErrors = "";
    {
        _markerErrors = format ["%1%2<br/>", _markerErrors, _x];
    } forEach _notOnAJunction;
    "Marker not on juntions" hintC (parseText format ["<t size='1.2' align='center'>The following markers are not on a junction<br/>%1This can have two reasons: First one, you didn't put them on a junction. Second one, the script does not detects the junction as such. This can happen. In this case this specific junction will not work as a start. But it does not matters which one you take, so take another one. For both cases, the script will abort now and let you reconfigure the marker.</t>", _markerErrors]);
    hintC_EH = findDisplay 72 displayAddEventHandler ["unload",
      {
        0 = _this spawn
        {
          _this select 0 displayRemoveEventHandler ["unload", hintC_EH];
          hintSilent "";
          hintDone = true;
          publicVariable "hintDone";
        };
      }];
    waitUntil {sleep 1; hintDone};
    hintDone = false; publicVariable "hintDone";
  };
  if(_abort) exitWith {};

  hint "Setup completed, starting script now!";
  sleep 2;
  openMap true;

  _startTime = time;

  _navPoints = [];

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
      hintSilent format ["Open segments: %1\n Inner Loop: %2\n Outer Loop: %3\n", str (count _openStartSegments), _innerLoop, _outerLoop];
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

  hint "Data prepared, setting up finished nav grid";

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
  "Finished navGrid creation!" hintC (parseText format ["<t size='1.2' align='center'>Grid Creation finished, searched %1 start points and found %2 nav points in %3 seconds! <br/><br/>The navData is currently copied to your clipboard. Now switch over to the text file, we opened earlier and hit Ctrl + V to paste the nav data in there. Save the file again and you are good to go. You may want to double check if all islands and streets are connected as they should. If not, readjust the marker and do it again. If so, the navGrid is now ready for use. How to load and use it, is not handled in this folder.</t>", _outerLoop, count _navPoints, _timeDiff]);
};
