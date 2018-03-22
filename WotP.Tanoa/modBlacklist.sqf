_mal = false;

if (missionNamespace getVariable ["MCC_isMode",false]) then {_mal = true};
if (isClass (configfile >> "CfgVehicles" >> "ALiVE_require")) then {_mal = true};
if ("asr_ai3_main" in activatedAddons) then {_mal = true};

if (_mal) then
	{
	if (isServer) then
		{
		["modUnautorized",false,1,false,false] remoteExec ["BIS_fnc_endMission"];
		diag_log "Antistasi blacklisted mod detected on SP or MP Server. Ending Mission";
		}
	else
		{
		["modUnautorized",false,1,false,false] call BIS_fnc_endMission;
		diag_log "Antistasi blacklisted mod detected on client. Ending Mission";
		};
	};