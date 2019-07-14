shouldCleanGroups = true;

while {shouldCleanGroups} do {
	{
		if (side _x == civilian) then {
			_x deleteGroupWhenEmpty true;
		};
	} forEach allGroups;

	sleep 300;
};


