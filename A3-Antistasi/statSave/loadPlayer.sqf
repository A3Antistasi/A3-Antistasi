params [["_playerId", ""], ["_unit", objNull]];

if (hasInterface) then {
	if (count _playerId == 0 || isNull _unit) then {
		_playerId = getPlayerUID player;
		_unit = player;
		[format ["[Antistasi] Telling server to load player %1 into %2", _playerId, _unit]] remoteExec ["diag_log", 2];
	};
};

if (isMultiplayer && !isServer) exitwith {
	[_playerId, _unit] remoteExec ["A3A_fnc_loadPlayer", 2];
};

waitUntil {(!isNil "initVar")};

if ([_playerId] call A3A_fnc_playerHasSave) then {
	diag_log format ["[Antistasi] Server loading player %1 into unit %2", _playerId, _unit];
} else {
	diag_log format ["[Antistasi] No save found for player %1 into unit %2", _playerId, _unit];
};

private _loadoutInfo =	[_playerId, "loadoutPlayer"] call fn_RetrievePlayerStat;

if (!isNil "_loadoutInfo") then {
	_unit setUnitLoadout _loadoutInfo;
};

if (isMultiplayer && side _unit == teamPlayer) then
{
	//player setPos getMarkerPos respawnTeamPlayer;
	if ([_unit] call A3A_fnc_isMember) then
	{
		private _score = ([_playerId, "scorePlayer"] call fn_RetrievePlayerStat);
		_score = if (isNil "_score") then {0} else {_score};
		_unit setVariable ["score",_score,true];

		private _kills = ([_playerId, "killsPlayer"] call fn_RetrievePlayerStat);
        _kills = if (isNil "_kills") then {0} else {_kills};
        _unit setVariable ["kills",_kills,true];

		private _rank = [_playerId, "rankPlayer"] call fn_RetrievePlayerStat;
		_rank = if (isNil "_rank" || {count _rank == 0}) then {"PRIVATE"} else {_rank};
		[_unit, _rank] remoteExec ["A3A_fnc_ranksMP"];
		_unit setVariable ["rankX",_rank,true];
	};

	private _money = ([_playerId, "moneyX"] call fn_RetrievePlayerStat);
	_money = if (isNil "_money" || {typeName _money != typeName 0}) then {100} else {_money};
	_unit setVariable ["moneyX",_money,true];

	//Personal garage has a nil check built in
	[_unit, [_playerId, "personalGarage"] call fn_RetrievePlayerStat] call A3A_fnc_setPersonalGarage;
};
diag_log format ["%1: [Antistasi] | INFO | Personal player stats loaded.",servertime];

[] remoteExec ["A3A_fnc_statistics", _unit];
