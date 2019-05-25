private ["_positionTel","_cercano","_cosa","_grupo","_unitsX","_salir"];
if (!visibleMap) then {openMap true};
positionTel = [];
_cosa = _this select 0;

onMapSingleClick "positionTel = _pos";

hint "Select the zone on which sending the selected troops as garrison";

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_cercano = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if !(_positionTel inArea _cercano) exitWith {hint "You must click near a marked zone"};

if (not(lados getVariable [_cercano,sideUnknown] == buenos)) exitWith {hint format ["That zone does not belong to %1",nameTeamPlayer]};

if ((_cercano in outpostsFIA) and !(isOnRoad getMarkerPos _cercano)) exitWith {hint "You cannot manage garrisons on this kind of zone"};

_cosa = _this select 0;

_grupo = grpNull;
_unitsX = objNull;

if ((_cosa select 0) isEqualType grpNull) then
	{
	_grupo = _cosa select 0;
	_unitsX = units _grupo;
	}
else
	{
	_unitsX = _cosa;
	};

_salir = false;

{
if ((typeOf _x == staticCrewTeamPlayer) or (typeOf _x == SDKUnarmed) or (typeOf _x in arrayCivs) or (!alive _x)) exitWith {_salir = true}
} forEach _unitsX;

if (_salir) exitWith {hint "Static crewman, prisoners, refugees or dead units cannot be added to any garrison"};

if ((groupID _grupo == "MineF") or (groupID _grupo == "Watch") or (isPlayer(leader _grupo))) exitWith {hint "You cannot garrison player led, Watchpost, Roadblocks or Minefield building squads"};


if (isNull _grupo) then
	{
	_grupo = createGroup buenos;
	_unitsX joinSilent _grupo;
	//{arrayids = arrayids + [name _x]} forEach _unitsX;
	hint "Adding units to garrison";
	if !(hayIFA) then {{arrayids pushBackUnique (name _x)} forEach _unitsX};
	}
else
	{
	hint format ["Adding %1 squad to garrison", groupID _grupo];
	theBoss hcRemoveGroup _grupo;
	};
/*
_garrison = [];
_garrison = _garrison + (garrison getVariable [_cercano,[]]);
{_garrison pushBack (typeOf _x)} forEach _unitsX;
garrison setVariable [_cercano,_garrison,true];
[_cercano] call A3A_fnc_mrkUpdate;
*/
[_unitsX,buenos,_cercano,0] remoteExec ["A3A_fnc_garrisonUpdate",2];
_noBorrar = false;

if (spawner getVariable _cercano != 2) then
	{

	{deleteWaypoint _x} forEach waypoints _grupo;
	_wp = _grupo addWaypoint [(getMarkerPos _cercano), 0];
	_wp setWaypointType "MOVE";
	{
	_x setVariable ["markerX",_cercano,true];
	_x addEventHandler ["killed",
		{
		_muerto = _this select 0;
		_markerX = _muerto getVariable "markerX";
		if (!isNil "_markerX") then
			{
			if (lados getVariable [_markerX,sideUnknown] == buenos) then
				{
				/*
				_garrison = [];
				_garrison = _garrison + (garrison getVariable [_markerX,[]]);
				if (_garrison isEqualType []) then
					{
					for "_i" from 0 to (count _garrison -1) do
						{
						if (typeOf _muerto == (_garrison select _i)) exitWith {_garrison deleteAt _i};
						};
					garrison setVariable [_markerX,_garrison,true];
					};
				[_markerX] call A3A_fnc_mrkUpdate;
				*/
				[typeOf _muerto,buenos,_markerX,-1] remoteExec ["A3A_fnc_garrisonUpdate",2];
				_muerto setVariable [_markerX,nil,true];
				};
			};
		}];
	} forEach _unitsX;

	waitUntil {sleep 1; (spawner getVariable _cercano == 2 or !(lados getVariable [_cercano,sideUnknown] == buenos))};
	if (!(lados getVariable [_cercano,sideUnknown] == buenos)) then {_noBorrar = true};
	};

if (!_noBorrar) then
	{
	{
	if (alive _x) then
		{
		deleteVehicle _x
		};
	} forEach _unitsX;
	deleteGroup _grupo;
	}
else
	{
	//añadir el grupo al HC y quitarles variables
	{
	if (alive _x) then
		{
		_x setVariable ["markerX",nil,true];
		_x removeAllEventHandlers "killed";
		_x addEventHandler ["killed", {
			_muerto = _this select 0;
			_killer = _this select 1;
			[_muerto] remoteExec ["A3A_fnc_postmortem",2];
			if ((isPlayer _killer) and (side _killer == buenos)) then
				{
				if (!isMultiPlayer) then
					{
					_nul = [0,20] remoteExec ["A3A_fnc_resourcesFIA",2];
					_killer addRating 1000;
					};
				}
			else
				{
				if (side _killer == malos) then
					{
					_nul = [0.25,0,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
					[-0.25,0] remoteExec ["A3A_fnc_prestige",2];
					}
				else
					{
					if (side _killer == ) then {[0,-0.25] remoteExec ["A3A_fnc_prestige",2]};
					};
				};
			_muerto setVariable ["spawner",nil,true];
			}];
		};
	} forEach _unitsX;
	theBoss hcSetGroup [_grupo];
	hint format ["Group %1 is back to HC control because the zone which was pointed to garrison has been lost",groupID _grupo];
	};

