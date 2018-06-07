_unit = _this select 0;
_jugador = _this select 1;

[_unit,"remove"] remoteExec ["flagaction",[buenos,civilian],_unit];

if (!alive _unit) exitWith {};
_lado = side (group _unit);
_chance = 80;
if (_lado == malos) then
	{
	_jugador globalChat "Go back to your base and tell your comrades we are not enemies. We just want to live in peace";
	}
else
	{
	_jugador globalChat "Why not join us and make profitable business?";
	_chance = 100 - prestigeCSAT;
	};

_chance = _chance + 20;

sleep 5;
if (round random 100 < _chance) then
	{
	if (isMultiplayer) then {[_unit,true] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation true};
	if (_lado == malos) then
		{
		_unit globalChat "Okay, thank you. I owe you my life";
		}
	else
		{
		_unit globalChat "Allah bless you!";
		};
	_unit enableAI "ANIM";
	_unit enableAI "MOVE";
	_unit stop false;
	[_unit,""] remoteExec ["switchMove"];
	_unit doMove (getMarkerPos "respawn_west");
	if (_unit getVariable ["OPFORSpawn",false]) then {_unit setVariable ["OPFORSpawn",nil,true]};
	if (_unit getVariable ["BLUFORSpawn",false]) then {_unit setVariable ["BLUFORSpawn",nil,true]};
	sleep 100;
	if (alive _unit) then
		{
		if (_lado == malos) then
			{
			[-0.5,0] remoteExec ["prestige",2];
			}
		else
			{
			[1,0] remoteExec ["resourcesFIA",2];
			[1,1] remoteExec ["prestige",2];
			};
		};
	}
else
	{
	_unit globalChat "Screw you!";
	};