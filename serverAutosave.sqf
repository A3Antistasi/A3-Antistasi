if (!isServer) exitWith {};

while {true} do
	{
	sleep 3600;
	_nul = [] execVM "statSave\saveLoop.sqf";
	_found = false;
	{
	if (_x select 0 == "resourcecheck") then
		{
		if (_x select 2) then {_found = true};
		}
	} forEach diag_activeSQFScripts;
	if (!_found) exitWith
		{
		diag_log "Error in resourcecheck.sqf has been found. Unknown causes. Proceeding to end the mission";
		};
	};
while {true} do
	{
	[petros,"hint","A critical failure has been detected in Antistasi. Please contact Admin Alber and ask for a diagnose + server restart. Apologies."] remoteExec ["commsMP"];
	sleep 10;
	};