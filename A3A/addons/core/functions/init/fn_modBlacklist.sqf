#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
_bad = false;

if (missionNamespace getVariable ["MCC_isMode",false]) then {_bad = true};
if (isClass (configfile >> "CfgVehicles" >> "ALiVE_require")) then {_bad = true};
if ("asr_ai3_main" in activatedAddons) then {_bad = true};
if (_bad) then
{
	if (isServer) then
	{
		["modUnautorized",false,1,false,false] remoteExec ["BIS_fnc_endMission"];
        Error("Blacklisted mod detected on SP or MP Server. Ending Mission");
	}
	else
	{
		["modUnautorized",false,1,false,false] call BIS_fnc_endMission;
        Error("Blacklisted mod detected on client. Ending Mission");

	};
};
