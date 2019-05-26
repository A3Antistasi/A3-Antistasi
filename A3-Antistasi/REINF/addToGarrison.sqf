private ["_positionTel","_cercano","_cosa","_grupo","_unidades","_salir"];
if (!visibleMap) then {openMap true};
positionTel = [];
_cosa = _this select 0;

onMapSingleClick "positionTel = _pos";

hint "Select the zone on which sending the selected troops as garrison";

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_nearX = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if !(_positionTel inArea _nearX) exitWith {hint "You must click near a marked zone"};

if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {hint format ["That zone does not belong to %1",nameTeamPlayer]};

if ((_nearX in outpostsFIA) and !(isOnRoad getMarkerPos _nearX)) exitWith {hint "You cannot manage garrisons on this kind of zone"};

_cosa = _this select 0;

_grupo = grpNull;
_unidades = objNull;

if ((_cosa select 0) isEqualType grpNull) then
	{
	_grupo = _cosa select 0;
	_unidades = units _grupo;
	}
else
	{
	_unidades = _cosa;
	};

_leave = false;

{
if ((typeOf _x == staticCrewTeamPlayer) or (typeOf _x == SDKUnarmed) or (typeOf _x in arrayCivs) or (!alive _x)) exitWith {_salir = true}
} forEach _unidades;

if (_leave) exitWith {hint "Static crewman, prisoners, refugees or dead units cannot be added to any garrison"};

if ((groupID _group == "MineF") or (groupID _group == "Watch") or (isPlayer(leader _group))) exitWith {hint "You cannot garrison player led, Watchpost, Roadblocks or Minefield building squads"};


if (isNull _group) then
	{
	_grupo = createGroup buenos;
	_unidades joinSilent _grupo;
	//{arrayids = arrayids + [name _x]} forEach _unidades;
	hint "Adding units to garrison";
	if !(hayIFA) then {{arrayids pushBackUnique (name _x)} forEach _unidades};
	}
else
	{
	hint format ["Adding %1 squad to garrison", groupID _group];
	theBoss hcRemoveGroup _group;
	};
/*
_garrison = [];
_garrison = _garrison + (garrison getVariable [_cercano,[]]);
{_garrison pushBack (typeOf _x)} forEach _unidades;
garrison setVariable [_cercano,_garrison,true];
[_cercano] call A3A_fnc_mrkUpdate;
*/
[_unidades,buenos,_cercano,0] remoteExec ["A3A_fnc_garrisonUpdate",2];
_noBorrar = false;

if (spawner getVariable _nearX != 2) then
	{

	{deleteWaypoint _x} forEach waypoints _group;
	_wp = _group addWaypoint [(getMarkerPos _nearX), 0];
	_wp setWaypointType "MOVE";
	{
	_x setVariable ["marcador",_cercano,true];
	_x addEventHandler ["killed",
		{
		_muerto = _this select 0;
		_marcador = _muerto getVariable "marcador";
		if (!isNil "_marcador") then
			{
			if (lados getVariable [_marcador,sideUnknown] == buenos) then
				{
				/*
				_garrison = [];
				_garrison = _garrison + (garrison getVariable [_marcador,[]]);
				if (_garrison isEqualType []) then
					{
					for "_i" from 0 to (count _garrison -1) do
						{
						if (typeOf _muerto == (_garrison select _i)) exitWith {_garrison deleteAt _i};
						};
					garrison setVariable [_marcador,_garrison,true];
					};
				[_marcador] call A3A_fnc_mrkUpdate;
				*/
				[typeOf _muerto,buenos,_marcador,-1] remoteExec ["A3A_fnc_garrisonUpdate",2];
				_muerto setVariable [_marcador,nil,true];
				};
			};
		}];
	} forEach _unidades;

	waitUntil {sleep 1; (spawner getVariable _nearX == 2 or !(sidesX getVariable [_nearX,sideUnknown] == teamPlayer))};
	if (!(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) then {_noBorrar = true};
	};

if (!_noBorrar) then
	{
	{
	if (alive _x) then
		{
		deleteVehicle _x
		};
	} forEach _unidades;
	deleteGroup _grupo;
	}
else
	{
	//añadir el group al HC y quitarles variables
	{
	if (alive _x) then
		{
		_x setVariable ["marcador",nil,true];
		_x removeAllEventHandlers "killed";
		_x addEventHandler ["killed", {
			_muerto = _this select 0;
			_killer = _this select 1;
			[_muerto] remoteExec ["A3A_fnc_postmortem",2];
			if ((isPlayer _killer) and (side _killer == teamPlayer)) then
				{
				if (!isMultiPlayer) then
					{
					_nul = [0,20] remoteExec ["A3A_fnc_resourcesFIA",2];
					_killer addRating 1000;
					};
				}
			else
				{
				if (side _killer == Occupants) then
					{
					_nul = [0.25,0,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
					[-0.25,0] remoteExec ["A3A_fnc_prestige",2];
					}
				else
					{
					if (side _killer == muyMalos) then {[0,-0.25] remoteExec ["A3A_fnc_prestige",2]};
					};
				};
			_muerto setVariable ["spawner",nil,true];
			}];
		};
	} forEach _unidades;
	theBoss hcSetGroup [_grupo];
	hint format ["Group %1 is back to HC control because the zone which was pointed to garrison has been lost",groupID _grupo];
	};
