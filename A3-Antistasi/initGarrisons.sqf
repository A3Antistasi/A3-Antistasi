//Original Author: Barbolani
//Edited and updated by the Antistasi Community Development Team

diag_log format ["%1: [Antistasi] | INFO | InitGarrisons Started.", servertime];

_fnc_initMarker =
{
	params ["_mrkCSAT", "_target", "_mrkType", "_mrkText", ["_useSideName", false]];
	private ["_pos", "_mrk", "_garrNum", "_garrison", "_groupsRandom"];

	{
		_pos = getMarkerPos _x;
		_mrk = createMarker [format ["Dum%1", _x], _pos];
		//TODO Multilanguage variable insted text
		_mrk setMarkerShape "ICON";

		if (_useSideName) then
		{
			killZones setVariable [_x, [], true];
			server setVariable [_x, 0, true];

			if (_x in _mrkCSAT) then
			{
				_mrkText = format [_mrkText, nameInvaders];
				if(_x in airportsX) then
				{
					_mrkType = flagCSATmrk;
				};
			}
			else
			{
				_mrkText = format [_mrkText, nameOccupants];
				if(_x in airportsX) then
				{
					_mrkType = flagNATOmrk;
				};
			};
		};

		if (_x in _mrkCSAT) then
		{
			_mrk setMarkerColor colorInvaders;
			sidesX setVariable [_x, Invaders, true];
		}
		else
		{
			_mrk setMarkerColor colorOccupants;
			sidesX setVariable [_x, Occupants, true];
		};

		_mrk setMarkerType _mrkType;
		_mrk setMarkerText _mrkText;

		[_x] spawn A3A_fnc_createControls;
	} forEach _target;
};




_fnc_initGarrison =
{
	params ["_markerArray", "_type"];
	private ["_fnc_getVehicleCrew", "_side", "_groupsRandom", "_crewUnit", "_crew", "_vehicle", "_vehiclePool" ,"_garrNum", "_garrison", "_garrisonOld", "_reinf", "_marker"];

	_fnc_getVehicleCrew =
	{
		params ["_vehicleType", "_crewType"];
		private ["_seatCount", "_result"];
		if(_vehicleType == "") exitWith {[]};
		_seatCount = [_vehicleType, false] call BIS_fnc_crewCount;
		_result = [];
		for "_i" from 1 to _seatCount do
		{
			_result pushBack _crewType;
		};
		_result;
	};

	{
	    _marker = _x;
			_garrNum = ([_x] call A3A_fnc_garrisonSize) / 8;
			_side = sidesX getVariable [_marker, sideUnknown];
			while {_side == sideUnknown} do
			{
				diag_log format ["Side unknown for %1, sleeping 1!", _marker];
				sleep 1;
				_side = sidesX getVariable [_marker, sideUnknown];
			};
			if(_side != Occupants) then
			{
				_vehiclePool = [vehCSATLight + [""] + vehCSATAPC, [vehFIAArmedCar, "", vehFIACar]] select ((_marker in outposts) && (gameMode == 4));
				_groupsRandom = [groupsCSATSquad, groupsFIASquad] select ((_marker in outposts) && (gameMode == 4));
				_crewUnit = [CSATCrew, NATOCrew] select ((_marker in outposts) && (gameMode == 4));
			}
			else
			{
				if(_type != "Airport" && {_type != "Outpost"}) then
				{
					_vehiclePool = [vehFIAArmedCar, "", vehFIACar];
					_groupsRandom = groupsFIASquad;
					_crewUnit = NATOCrew;
				}
				else
				{
					_vehiclePool = vehNATOLight + [""] + vehNATOAPC;
	 				_groupsRandom = groupsNATOSquad;
					_crewUnit = NATOCrew;
				};
			};

			_garrison = [];
			_reinf = [];

			//Old system, keeping it intact for the moment
			_garrisonOld = [];
			for "_i" from 1 to _garrNum do
			{
				_garrisonOld append (selectRandom _groupsRandom);
			};
			//

			switch (_type) do
			{
			  case ("Airport"):
				{
					//Full equipted from the start
					for "_i" from 0 to 3 do
					{
						_vehicle = selectRandom _vehiclePool;
						_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
						_garrison pushBack [_vehicle, _crew, selectRandom _groupsRandom];
					};
			  };
				case ("Outpost"):
				{
					//Two units there, one requested
					for "_i" from 0 to 1 do
					{
						_vehicle = selectRandom _vehiclePool;
						_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
						_garrison pushBack [_vehicle, _crew, selectRandom _groupsRandom];
					};
					for "_i" from 0 to 0 do
					{
						_vehicle = selectRandom _vehiclePool;
						_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
						_reinf pushBack [_vehicle, _crew, selectRandom _groupsRandom];
					};
				};
				case ("Seaport"):
				{
				    //One there, one requested
						for "_i" from 0 to 0 do
						{
							_vehicle = selectRandom _vehiclePool;
							_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
							_garrison pushBack [_vehicle, _crew, selectRandom _groupsRandom];
						};
						for "_i" from 0 to 0 do
						{
							_vehicle = selectRandom _vehiclePool;
							_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
							_reinf pushBack [_vehicle, _crew, selectRandom _groupsRandom];
						};
				};
				case ("Resource"):
				{
					//Two there, none requested
					for "_i" from 0 to 1 do
					{
						_vehicle = selectRandom _vehiclePool;
						_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
						_garrison pushBack [_vehicle, _crew, selectRandom _groupsRandom];
					};
				};
				case ("Factory"):
				{
					//Two there, none requested
					for "_i" from 0 to 1 do
					{
						_vehicle = selectRandom _vehiclePool;
						_crew = [_vehicle, _crewUnit] call _fnc_getVehicleCrew;
						_garrison pushBack [_vehicle, _crew, selectRandom _groupsRandom];
					};
				};
			};

			//Old system, keeping it runing for now
			garrison setVariable [_marker, _garrisonOld, true];

			//New system
			//diag_log format ["Setting gar for %1, alive are %2", _marker, str _garrison];
			garrison setVariable [format ["%1_alive", _marker], _garrison, true];
			garrison setVariable [format ["%1_dead", _marker], _reinf, true];

	} forEach _markerArray;
};

private _mrkNATO = [];
private _mrkCSAT = [];
private _controlsNATO = [];
private _controlsCSAT = [];

if (debug) then
{
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting Control Marks for Worldname: %2  .", servertime, worldName];
};

if (gameMode == 1) then
{
	_controlsNATO = controlsX;
	switch (toLower worldName) do {
		case "tanoa": {
			_mrkCSAT = ["airport_1", "seaport_5", "outpost_10", "control_20"];
			_controlsNATO = _controlsNATO - ["control_20"];
			_controlsCSAT = ["control_20"];
		};
		case "altis": {
			_mrkCSAT = ["airport_2", "seaport_4", "outpost_5", "control_52", "control_33"];
			_controlsNATO = _controlsNATO - ["control_52", "control_33"];
			_controlsCSAT = ["control_52", "control_33"];
		};
		case "chernarus_summer": {
			_mrkCSAT = ["outpost_21"];
		};
	};
	_mrkNATO = markersX - _mrkCSAT - ["Synd_HQ"];

	if (debug) then {
		diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | _mrkCSAT: %2.", servertime, _mrkCSAT];
		diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | _mrkNATO: %2.", servertime, _mrkNATO];
	};
}
else
{
	if (gameMode == 4) then
	{
		_mrkCSAT = markersX - ["Synd_HQ"];
		_controlsCSAT = controlsX;
	}
	else
	{
		_mrkNATO = markersX - ["Synd_HQ"];
		_controlsNATO = controlsX;
	};
};

{sidesX setVariable [_x, Occupants, true]} forEach _controlsNATO;
{sidesX setVariable [_x, Invaders, true]} forEach _controlsCSAT;

if (debug) then {
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting up Airbase stuff.", servertime];
};

[_mrkCSAT, airportsX, flagCSATmrk, "%1 Airbase", true] spawn _fnc_initMarker;
[airportsX, "Airport"] spawn _fnc_initGarrison;


if (debug) then {
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting up Resource stuff.", servertime];
};

[_mrkCSAT, resourcesX, "loc_rock", "Resources"] spawn _fnc_initMarker;
[resourcesX, "Resource"] spawn _fnc_initGarrison;

if (debug) then {
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting up Factory stuff.", servertime];
};

[_mrkCSAT, factories, "u_installation", "Factory"] spawn _fnc_initMarker;
[factories, "Factory"] spawn _fnc_initGarrison;

if (debug) then {
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting up Outpost stuff.", servertime];
};

[_mrkCSAT, outposts, "loc_bunker", "%1 Outpost", true] spawn _fnc_initMarker;
[outposts, "Outpost"] spawn _fnc_initGarrison;

if (debug) then {
	diag_log format ["%1: [Antistasi] | DEBUG | initGarrisons.sqf | Setting up Seaport stuff.", servertime];
};

[_mrkCSAT, seaports, "b_naval", "Sea Port"] spawn _fnc_initMarker;
[seaports, "Seaport"] spawn _fnc_initGarrison;

sidesX setVariable ["NATO_carrier", Occupants, true];
sidesX setVariable ["CSAT_carrier", Invaders, true];

diag_log format ["%1: [Antistasi] | INFO | InitGarrison Completed.", servertime];
