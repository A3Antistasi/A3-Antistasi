private ["_hr","_resourcesFIA","_tipo","_costs","_markerX","_garrison","_positionX","_unit","_group","_veh","_pos"];

_hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "You lack of HR to make a new recruitment"};

_resourcesFIA = server getVariable "resourcesFIA";

_tipo = _this select 0;

_costs = 0;

if (_tipo isEqualType "") then
	{
	_costs = server getVariable _tipo;
	_costs = _costs + ([SDKMortar] call A3A_fnc_vehiclePrice);
	}
else
	{
	_tipo = if (random 20 <= skillFIA) then {_tipo select 1} else {_tipo select 0};
	_costs = server getVariable _tipo;
	};

if (_costs > _resourcesFIA) exitWith {hint format ["You do not have enough money for this kind of unit (%1 € needed)",_costs]};

_markerX = positionXGarr;

if ((_tipo == staticCrewTeamPlayer) and (_markerX in outpostsFIA)) exitWith {hint "You cannot add mortars to a Roadblock garrison"};

_positionX = getMarkerPos _markerX;

if (surfaceIsWater _positionX) exitWith {hint "This Garrison is still updating, please try again in a few seconds"};

if ([_positionX,500] call A3A_fnc_enemyNearCheck) exitWith {Hint "You cannot Recruit Garrison Units with enemies near the zone"};
_nul = [-1,-_costs] remoteExec ["A3A_fnc_resourcesFIA",2];
/*
_garrison = [];
_garrison = _garrison + (garrison getVariable [_markerX,[]]);
_garrison pushBack _tipo;
garrison setVariable [_markerX,_garrison,true];
//[_markerX] call A3A_fnc_mrkUpdate;*/
_countX = count (garrison getVariable _markerX);
[_tipo,teamPlayer,_markerX,1] remoteExec ["A3A_fnc_garrisonUpdate",2];
waitUntil {(_countX < count (garrison getVariable _markerX)) or (lados getVariable [_markerX,sideUnknown] != teamPlayer)};

if (lados getVariable [_markerX,sideUnknown] == teamPlayer) then
	{
	hint format ["Soldier recruited.%1",[_markerX] call A3A_fnc_garrisonInfo];

	if (spawner getVariable _markerX != 2) then
		{
		//[_markerX] remoteExec ["tempMoveMrk",2];
		[_markerX,_tipo] remoteExec ["A3A_fnc_createSDKGarrisonsTemp",2];
		};
	};

