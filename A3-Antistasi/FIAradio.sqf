private ["_chance","_pos","_markerX","_return"];

_chance = tierWar*3;
{_pos = getPos _x;
_markerX = [seaports,_pos] call BIS_fnc_nearestPosition;
if ((lados getVariable [_markerX,sideUnknown] == buenos) and (alive _x)) then {_chance = _chance + 4};
} forEach antennas;
_return = false;
if (debug) then {_chance = 100};

if (random 100 < _chance) then
	{
	if (count _this == 0) then
		{
		if (not revealX) then
			{
			["TaskSucceeded", ["", "Enemy Comms Intercepted"]] remoteExec ["BIS_fnc_showNotification",buenos];
			revealX = true; publicVariable "revealX";
			[] remoteExec ["A3A_fnc_revealToPlayer",buenos];
			};
		}
	else
		{
		_return = true;
		};
	}
else
	{
	if (count _this == 0) then
		{
		if (revealX) then
			{
			["TaskFailed", ["", "Enemy Comms Lost"]] remoteExec ["BIS_fnc_showNotification",buenos];
			revealX = false; publicVariable "revealX";
			};
		};
	};
_return