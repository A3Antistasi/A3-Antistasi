// Dont' run if a Boss exists.
private _filename = "fn_assignBossIfNone";
private _BossAssigned = false;
	if (isnil "theBoss" || {isNull theBoss}) then {
		_BossAssigned = false;
		[3, format ["No Boss found, Checking for next available boss."],_filename] call A3A_fnc_log;
	}
	else { _BossAssigned = True; };
if _bossAssigned exitwith {[3, format ["Player %1 is the boss", theBoss],_filename] call A3A_fnc_log;};

_selectable = objNull;

[3, format ["Checking % members for next Boss.", count membersX],_filename] call A3A_fnc_log;
// Are there any members online.
if ((count playableUnits > 0) && (membershipEnabled)) then
{
	private _BossRank = 0;
	{
		if ((_x getVariable ["eligible",true]) && ({(side (group _x) == teamPlayer)}) && ([_x] call A3A_fnc_isMember)) then
		{
			[3, format ["Player %1 is eligible", name _x],_filename] call A3A_fnc_log;
			[3, format ["Current Boss Rank: %1.", _BossRank],_filename] call A3A_fnc_log;
			_dataX = [_x] call A3A_fnc_numericRank;
			_playerRank = _dataX select 0;
			[3, format ["Players rank is: %1", _playerRank],_filename] call A3A_fnc_log;
			if (_playerRank > _BossRank) then
			{
				_selectable = _x;
				_BossRank = _playerRank;
				[3, format ["Player rank is higher than older."],_filename] call A3A_fnc_log;
			};
		}
		else {
			[3, format ["Player is not eligible: %1", _x],_filename] call A3A_fnc_log;
		};
	} forEach playableUnits;
	if (!isNull _selectable) then
	{
		[3, format ["Player chosen for Boss: %1", name _selectable],_filename] call A3A_fnc_log;
		_textX = format ["%1 is no longer leader of the our Forces.\n\n %2 is our new leader. Greet him!", name theBoss, name _selectable];
		[_selectable] call A3A_fnc_theBossInit;
		sleep 5;
		[[petros,"hint",_textX],"A3A_fnc_commsMP"] call BIS_fnc_MP;
	}
	else
	{
		[1, format ["Couldn't select a new boss: %1", _selectable],_filename] call A3A_fnc_log;
	};
}
else
{
	[1, format ["There are no eligible players online to become the Boss at this time."],_filename] call A3A_fnc_log;
}
