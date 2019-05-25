if (!isServer and hasInterface) exitWith {};

private ["_markerX","_positionX","_isRoad","_tam","_road","_veh","_grupo","_unit","_roadcon"];

_markerX = _this select 0;
_positionX = getMarkerPos _markerX;

_isRoad = false;
if (isOnRoad _positionX) then {_isRoad = true};

if (_isRoad) then
	{
	_tam = 1;
	_garrison = garrison getVariable _markerX;
	_veh = objNull;

	if (isNil "_garrison") then
		{//this is for backward compatibility, remove after v12
		_garrison = [staticCrewTeamPlayer];
		{
		if (random 20 <= skillFIA) then {_garrison pushBack (_x select 1)} else {_garrison pushBack (_x select 0)};
		} forEach groupsSDKAT;
		garrison setVariable [_markerX,_garrison,true];
		};
	while {true} do
		{
		_road = _positionX nearRoads _tam;
		if (count _road > 0) exitWith {};
		_tam = _tam + 5;
		};
	if (staticCrewTeamPlayer in _garrison) then
		{
		_roadcon = roadsConnectedto (_road select 0);
		_dirveh = [_road select 0, _roadcon select 0] call BIS_fnc_DirTo;
		_veh = vehSDKLightArmed createVehicle getPos (_road select 0);
		_veh setDir _dirveh + 90;
		_veh lock 3;
		_nul = [_veh] call A3A_fnc_AIVEHinit;
		sleep 1;
		};
	_grupo = [_positionX, buenos, _garrison,true,false] call A3A_fnc_spawnGroup;
	//_unit = _grupo createUnit [staticCrewTeamPlayer, _positionX, [], 0, "NONE"];
	//_unit moveInGunner _veh;
	{[_x,_markerX] spawn A3A_fnc_FIAinitBases; if (typeOf _x == staticCrewTeamPlayer) then {_x moveInGunner _veh}} forEach units _grupo;
	}
else
	{
	_formato = [];
	{
	if (random 20 <= skillFIA) then {_formato pushBack (_x select 1)} else {_formato pushBack (_x select 0)};
	} forEach groupsSDKSniper;
	_grupo = [_positionX, buenos, _formato] call A3A_fnc_spawnGroup;
	_grupo setBehaviour "STEALTH";
	_grupo setCombatMode "GREEN";
	{[_x,_markerX] spawn A3A_fnc_FIAinitBases;} forEach units _grupo;
	};

waitUntil {sleep 1; ((spawner getVariable _markerX == 2)) or ({alive _x} count units _grupo == 0) or (not(_markerX in outpostsFIA))};

if ({alive _x} count units _grupo == 0) then
//if ({alive _x} count units _grupo == 0) then
	{
	outpostsFIA = outpostsFIA - [_markerX]; publicVariable "outpostsFIA";
	markersX = markersX - [_markerX]; publicVariable "markersX";
	lados setVariable [_markerX,nil,true];
	_nul = [5,-5,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
	deleteMarker _markerX;
	if (_isRoad) then
		{
		[["TaskFailed", ["", "Roadblock Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		}
	else
		{
		[["TaskFailed", ["", "Watchpost Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		};
	};

waitUntil {sleep 1; (spawner getVariable _markerX == 2) or (not(_markerX in outpostsFIA))};

if (_isRoad) then {if (!isNull _veh) then {deleteVehicle _veh}};
{deleteVehicle _x} forEach units _grupo;
deleteGroup _grupo;