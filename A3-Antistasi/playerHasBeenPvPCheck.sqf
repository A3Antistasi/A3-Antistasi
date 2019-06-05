if !(isServer) exitWith {};
_unit = _this select 0;
if (playerHasBeenPvP isEqualTo []) exitWith {};
_leave = false;
_id = getPlayerUID _unit;
{
if (_id == _x select 0) then
	{
	if (time - 3600 <= _x select 1) then {_leave = true};
	};
} forEach playerHasBeenPvP;
if (_leave) then
	{
	["noPvP",false,1,false,false] remoteExec ["BIS_fnc_endMission",_unit];
	"Antistasi: player kicked because he has been rebel recently" remoteExec ["diag_log",_unit];
	};