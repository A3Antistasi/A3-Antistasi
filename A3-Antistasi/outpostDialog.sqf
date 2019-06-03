private ["_tipo","_coste","_grupo","_unit","_tam","_roads","_road","_pos","_camion","_texto","_mrk","_hr","_exists","_positionTel","_isRoad","_typeGroup","_resourcesFIA","_hrFIA"];

if (["outpostsFIA"] call BIS_fnc_taskExists) exitWith {hint "We can only deploy / delete one Observation Post or Roadblock at a time."};
if (!([player] call A3A_fnc_hasRadio)) exitWith {if !(hayIFA) then {hint "You need a radio in your inventory to be able to give orders to other squads"} else {hint "You need a Radio Man in your group to be able to give orders to other squads"}};

_tipo = _this select 0;

if (!visibleMap) then {openMap true};
positionTel = [];
if (_tipo != "delete") then {hint "Click on the position you wish to build the Observation Post or Roadblock. \n Remember: to build Roadblocks you must click exactly on a road map section"} else {hint "Click on the Observation Post or Roadblock to delete."};

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;
_pos = [];

if ((_tipo == "delete") and (count outpostsFIA < 1)) exitWith {hint "No Posts or Roadblocks deployed to delete"};
if ((_tipo == "delete") and ({(alive _x) and (!captive _x) and ((side _x == malos) or (side _x == Invaders)) and (_x distance _positionTel < 500)} count allUnits > 0)) exitWith {hint "You cannot delete a Post while enemies are near it"};

_coste = 0;
_hr = 0;

if (_tipo != "delete") then
	{
	_isRoad = isOnRoad _positionTel;

	_typeGroup = groupsSDKSniper;

	if (_isRoad) then
		{
		_typeGroup = groupsSDKAT;
		_coste = _coste + ([vehSDKLightArmed] call A3A_fnc_vehiclePrice) + (server getVariable staticCrewTeamPlayer);
		_hr = _hr + 1;
		};

	//_formatX = (configfile >> "CfgGroups" >> "buenos" >> "Guerilla" >> "Infantry" >> _typeGroup);
	//_unitsX = [_formatX] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _hr = _hr +1} forEach _typeGroup;
	}
else
	{
	_mrk = [outpostsFIA,_positionTel] call BIS_fnc_nearestPosition;
	_pos = getMarkerPos _mrk;
	if (_positionTel distance _pos >10) exitWith {hint "No post nearby"};
	};
//if ((_tipo == "delete") and (_positionTel distance _pos >10)) exitWith {hint "No post nearby"};

_resourcesFIA = server getVariable "resourcesFIA";
_hrFIA = server getVariable "hr";

if (((_resourcesFIA < _coste) or (_hrFIA < _hr)) and (_tipo!= "delete")) exitWith {hint format ["You lack of resources to build this Outpost or Roadblock \n %1 HR and %2 € needed",_hr,_coste]};

if (_tipo != "delete") then
	{
	[-_hr,-_coste] remoteExec ["A3A_fnc_resourcesFIA",2];
	};

 [[_tipo,_positionTel],"A3A_fnc_createOutpostsFIA"] call BIS_fnc_MP
