if !(isMultiplayer) then
	{
	waitUntil {/*(!isNil "serverInitDone") and */(!isNil "initVar")};
	["loadoutPlayer"] call fn_LoadStat;
	diag_log "Antistasi: SP Personal player stats loaded";
	[] spawn A3A_fnc_statistics;
	}
else
	{
	if (!isDedicated) then
		{
		if (side player == teamPlayer) then
			{
			//Wait for the server to be initialised
			waitUntil {!isNil "initVar"};
			["loadoutPlayer"] call fn_LoadStat;
			//player setPos getMarkerPos respawnTeamPlayer;
			if ([player] call A3A_fnc_isMember) then
				{
				["scorePlayer"] call fn_LoadStat;
				["rankPlayer"] call fn_LoadStat;
				};
			["moneyX"] call fn_LoadStat;
			["personalGarage"] call fn_LoadStat;
			diag_log "Antistasi: MP Personal player stats loaded";
			[] spawn A3A_fnc_statistics;
			};
		};
	};