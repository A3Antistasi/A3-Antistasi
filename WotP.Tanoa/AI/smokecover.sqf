private ["_veh","_cargo","_grupo","_modo"];

_veh = _this select 0;

_cargo = assignedCargo _veh;
_grupo = group (driver _veh);

while {sleep 1;({alive _x} count units _grupo > 0) and (canMove _veh) and (alive _veh)} do
	{
	sleep 1;
	_modo = behaviour leader _grupo;
	if (_modo == "COMBAT") then
		{
		waitUntil {(!alive _veh) or (speed _veh < 1)};
		if (alive _veh) then
			{
			_veh fire "SmokeLauncher";
			//[_veh] call puertasLand;
				//sleep 2;
			{[_x] orderGetIn false; [_x] allowGetIn false} forEach _cargo;
			//sleep ({alive _x} count units _grupo);
			//[_veh] call puertasLand;
			waitUntil {sleep 1; ({alive _x} count units _grupo == 0) or (not canMove _veh) or (behaviour leader _grupo != "COMBAT")};
			if (canMove _veh) then {{[_x] orderGetIn true; [_x] allowGetIn true} forEach _cargo};
			};
		};
	};
