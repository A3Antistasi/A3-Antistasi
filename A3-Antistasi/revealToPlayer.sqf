if (isDedicated) exitWith {};
private ["_lider"];
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
				if (((side _lider == ) or (side _lider == Occupants)) and (vehicle _lider != _lider) and (player knowsAbout _lider < 1.5)) then
					{
					player reveal [_lider,4];
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
		_lider = leader _group;
		player reveal [_lider,4];
		};
	};