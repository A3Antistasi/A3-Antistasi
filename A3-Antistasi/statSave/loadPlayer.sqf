params [["_playerId", ""], ["_unit", objNull]];

if (hasInterface) then {
	if (count _playerId == 0 || isNull _unit) then {
		_playerId = getPlayerUID player;
		_unit = player;
		diag_log format ["[Antistasi] Telling server to load player %1 into %2", _playerId, _unit];
		[format ["[Antistasi] Telling server to load player %1 into %2", _playerId, _unit]] remoteExec ["diag_log", 2];
	};
};

if (isMultiplayer && !isServer) exitwith {
	[_playerId, _unit] remoteExec ["A3A_fnc_loadPlayer", 2];
};

diag_log format ["Saving player %1 who is %2", _playerId, _unit];

waitUntil {(!isNil "initVar")};
private _loadoutInfo =	[_playerId, "loadoutPlayer"] call fn_RetrievePlayerStat;

if (isMultiplayer) then
	{
	removeAllItemsWithMagazines _unit;
	{_unit removeWeaponGlobal _x} forEach weapons _unit;
	removeBackpackGlobal _unit;
	removeVest _unit;
	if ((not("ItemGPS" in unlockedItems)) and ("ItemGPS" in (assignedItems _unit))) then {_unit unlinkItem "ItemGPS"};
	if ((!hasTFAR) and (!hasACRE) and ("ItemRadio" in (assignedItems _unit)) and (not("ItemRadio" in unlockedItems))) then {_unit unlinkItem "ItemRadio"};
	//Essentially zeroing their loadout, to prevent them relogging for infinite gear
	[_playerId, "loadoutPlayer", getUnitLoadout _unit] call fn_SavePlayerStat;
	};
	
diag_log "Preparing to set loadout";
	
if (!isNil "_loadoutInfo") then {
	diag_log format ["Setting loadout to %1 for %2", _loadoutInfo, _playerID];
	_unit setUnitLoadout _loadoutInfo;
};

if (isMultiplayer && side _unit == teamPlayer) then
{
	//player setPos getMarkerPos respawnTeamPlayer;
	if ([_unit] call A3A_fnc_isMember) then
	{
		_unit setVariable ["score",([_playerId, "scorePlayer"] call fn_RetrievePlayerStat),true];
		private _rank = [_playerId, "rankPlayer"] call fn_RetrievePlayerStat;
		_unit setRank _rank; 
		_unit setVariable ["rankX",_rank,true];
	};
	_unit setVariable ["moneyX",([_playerId, "moneyX"] call fn_RetrievePlayerStat),true];
	[_unit, [_playerId, "personalGarage"] call fn_RetrievePlayerStat] call A3A_fnc_setPersonalGarage;
};
	
diag_log "Antistasi: Personal player stats loaded";
[] spawn A3A_fnc_statistics;