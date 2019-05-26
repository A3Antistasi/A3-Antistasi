if (isDedicated) exitWith {};
private ["_LeaderX"];
if (count _this == 0) then
	{
	while {revealX} do
		{
		if (player == leader group player) then
			{
			if ([player] call A3A_fnc_hasRadio) then
				{
				{
				_lider = leader _x;
				if (((side _lider == muyMalos) or (side _lider == malos)) and (vehicle _lider != _lider) and (player knowsAbout _lider < 1.5)) then
					{
					player reveal [_LeaderX,4];
					sleep 1;
					};
				} forEach allGroups;
				};
			};
		sleep 10;
		};
	}
else
	{
	private ["_group"];
	if (player == leader group player) then
		{
		_group = _this select 0;
		_LeaderX = leader _group;
		player reveal [_LeaderX,4];
		};
	};
