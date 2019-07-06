params ["_date"];

format ["%1:%2",
	(if (date select 3 < 10) then { "0" } else { "" }) + str (date select 3),
	(if (date select 4 < 10) then { "0" } else { "" }) + str (date select 4)];