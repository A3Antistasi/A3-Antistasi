private ["_grupo","_modo"];

_grupo = _this select 0;

while {{alive _x} count units _grupo > 0} do
	{
	sleep 3;
	_modo = behaviour leader _grupo;

	if (_modo != "SAFE") then
		{
		{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _grupo;
		}
	else
		{
		{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
		};
	};