//GOM_fnc_GPSTracker.sqf
//by Grumpy Old Man
//V0.9
params ["_car"];

_check = _car getvariable ["GOM_fnc_GPSTracker",true];
_counter = 0;
_markers = [];
_markerTimes = [];

while {alive _car} do {

		_lastmarkerpos = _car getvariable ["GOM_fnc_lastmarker",[0,0,0]];

		if (getposATL _car distancesqr _lastmarkerpos > 5^2) then {
		_markertype = "";

		_text = format ["%1: %2km/h.",[((daytime)),"HH:MM"] call bis_fnc_timetostring,round speed _car];
		_car setvariable ["GOM_fnc_lastmarker",getposATL _car,true];
		_markertype = "hd_arrow";
		_marker = createMarker [str time,getPosATLVisual _car];
		_marker setMarkerShape "ICON";
		_marker setMarkerSize [1,1];
		_marker setMarkerType "hd_arrow";
		_marker setMarkerAlpha 1;
		_marker setMarkerColor "ColorCiv";
		_marker setMarkerDir getdir _car;

		if (_counter isEqualTo 10) then {_counter = 0};
		if !(_counter isequalto 0) then {_text = ""};

		_counter = _counter + 1;
		_marker setmarkertext _text;
		_markers pushback _marker;
		_markerTimes pushback time;

	};

	{

		_index = _markerTimes find _x;

		if (time - _x > 300) then {

			_marker = _markers select _index;
			deleteMarkerLocal _marker;
			_markers deleteAt _index;
			_markerTimes deleteAT _index;

		};


	} foreach _markerTimes;

	_sleep = time + 2;

	waituntil {time > _sleep};

};
true