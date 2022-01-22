#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
private ["_positionTel","_nearX","_thingX","_groupX","_unitsX","_leave"];
if (!visibleMap) then {openMap true};
positionTel = [];
_thingX = _this select 0;

onMapSingleClick "positionTel = _pos";

["Garrison", "Select the zone on which sending the selected troops as garrison."] call A3A_fnc_customHint;

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_nearX = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if !(_positionTel inArea _nearX) exitWith {["Garrison", "You must click near a marked zone."] call A3A_fnc_customHint;};

if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {["Garrison", format ["That zone does not belong to %1.",FactionGet(reb,"name")]] call A3A_fnc_customHint;};

if ((_nearX in outpostsFIA) and !(isOnRoad getMarkerPos _nearX)) exitWith {["Garrison", "You cannot manage garrisons on this kind of zone."] call A3A_fnc_customHint;};

_thingX = _this select 0;

_groupX = grpNull;
_unitsX = objNull;

if ((_thingX select 0) isEqualType grpNull) then
	{
	_groupX = _thingX select 0;
	_unitsX = units _groupX;
	}
else
	{
	_unitsX = _thingX;
	};

_leave = false;

private _alreadyInGarrison = false;
{
	private _garrisondIn = _x getVariable "markerX";
	if !(isNil "_garrisondIn") then {_alreadyInGarrison = true};
} forEach _unitsX;
if _alreadyInGarrison exitWith {["Garrison", "The units selected already are in a garrison."] call A3A_fnc_customHint};

if ((groupID _groupX == "MineF") or (groupID _groupX == "Post") or (isPlayer(leader _groupX))) exitWith {["Garrison", "You cannot garrison player led, Watchpost, Roadblocks or Minefield building squads."] call A3A_fnc_customHint;};

{
	if (isPlayer _x or !alive _x) exitWith {_leave = true};
} forEach _unitsX;
if (_leave) exitWith {["Garrison", "Dead or player-controlled units cannot be added to any garrison."] call A3A_fnc_customHint;};

private _bannedTypes = FactionGet(civ, "unitMan") + FactionGet(civ, "unitPress") + FactionGet(civ, "unitWorker") + FactionGet(reb,"unitCrew"), FactionGet(reb,"unitUnarmed"), FactionGet(reb,"unitPetros");
{
	private _unitType = _x getVariable "unitType";
	if (_unitType in _bannedTypes) exitWith {_leave = true};
} forEach _unitsX;
if (_leave) exitWith {["Garrison", "Static crewmen, prisoners, refugees, Petros or unknown units cannot be added to any garrison."] call A3A_fnc_customHint;};


if (isNull _groupX) then
	{
	_groupX = createGroup teamPlayer;
	_unitsX joinSilent _groupX;
	//{arrayids = arrayids + [name _x]} forEach _unitsX;
	["Garrison", "Adding units to garrison."] call A3A_fnc_customHint;
	if !(A3A_hasIFA) then {{arrayids pushBackUnique (name _x)} forEach _unitsX};
	}
else
	{
	["Garrison", format ["Adding %1 squad to garrison.", groupID _groupX]] call A3A_fnc_customHint;
	theBoss hcRemoveGroup _groupX;
	};

// Send types, because the units may be deleted before the remoteExec hits
private _unitTypes = _unitsX apply { _x getVariable "unitType" };
[_unitTypes,teamPlayer,_nearX,0] remoteExec ["A3A_fnc_garrisonUpdate",2];
_noBorrar = false;

if (spawner getVariable _nearX != 2) then
{
	private _targPos = getMarkerPos _nearX;
	private _wp = _groupX addWaypoint [(getMarkerPos _nearX), 0];
	_wp setWaypointType "MOVE";
	_groupX setCurrentWaypoint _wp;
	{
	_x setVariable ["markerX",_nearX,true];
	_x setVariable ["spawner",nil,true];
	_x addEventHandler ["killed",
		{
		_victim = _this select 0;
		_markerX = _victim getVariable "markerX";
		if (!isNil "_markerX") then
			{
			if (sidesX getVariable [_markerX,sideUnknown] == teamPlayer) then
				{
				[_victim getVariable "unitType",teamPlayer,_markerX,-1] remoteExec ["A3A_fnc_garrisonUpdate",2];
				_victim setVariable [_markerX,nil,true];
				};
			};
		}];
	} forEach _unitsX;

	// trigger actual garrison join when close to target
	[_nearX, _groupX] spawn {
		params ["_marker", "_group"];
		waitUntil {
			sleep 5;
			isNull leader _group or { leader _group distance getMarkerPos _marker < 20 }
		};
		sleep 10;			// give units some time to get onto marker
		if !(isNull leader _group) then { [_marker] remoteExec ["A3A_fnc_updateRebelStatics", 2] };
	};

	waitUntil {sleep 1; (spawner getVariable _nearX == 2 or !(sidesX getVariable [_nearX,sideUnknown] == teamPlayer))};
	if (!(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {_noBorrar = true};
};

if (!_noBorrar) then
	{
	{
	if (alive _x) then
		{
		deleteVehicle _x
		};
	} forEach _unitsX;
	deleteGroup _groupX;
	}
else
	{
	//añadir el groupX al HC y quitarles variables
	{
	if (alive _x) then
		{
		_x setVariable ["markerX",nil,true];
		_x setVariable ["spawner",true,true];
		_x removeAllEventHandlers "killed";
		_x addEventHandler ["killed", {
			_victim = _this select 0;
			_killer = _this select 1;
			[_victim] remoteExec ["A3A_fnc_postmortem",2];
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
					_nul = [0.25,0,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
					[Occupants, -1, 30] remoteExec ["A3A_fnc_addAggression",2];
					}
				else
					{
					if (side _killer == Invaders) then {[Invaders, -1, 30] remoteExec ["A3A_fnc_addAggression",2]};
					};
				};
			_victim setVariable ["spawner",nil,true];
			}];
		};
	} forEach _unitsX;
	theBoss hcSetGroup [_groupX];
	["Garrison", format ["Group %1 is back to HC control because the zone which was pointed to garrison has been lost.",groupID _groupX]] call A3A_fnc_customHint;
	};
