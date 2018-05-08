private ["_grupo","_killer","_marcador","_super","_enemy"];
_grupo = _this select 0;
_killer = _this select 1;

{
if (fleeing _x) then
	{
	if ([_x] call canFight) then
		{
		_enemy = _x findNearestEnemy _x;
		if (!isNull _enemy) then
			{
			if ((_x distance _enemy < 50) and (vehicle _x == _x)) then
				{
				[_x] spawn surrenderAction;
				}
			else
				{
				if (_x == leader group _x) then
					{
					_super = false;
					_marcador = (leader _grupo) getVariable "marcador";
					if (!isNil "_marcador") then
						{
						if (_marcador in aeropuertos) then {_super = true};
						};
					if (vehicle _killer == _killer) then
						{
						[[getPosASL _enemy,side _x,"Normal",_super],"patrolCA"] remoteExec ["scheduler",2]
						}
					else
						{
						if (vehicle _killer isKindOf "Air") then {[[getPosASL _enemy,side _x,"Air",_super],"patrolCA"] remoteExec ["scheduler",2]} else {if (vehicle _killer isKindOf "Tank") then {[[getPosASL _enemy,side _x,"Tank",_super],"patrolCA"] remoteExec ["scheduler",2]} else {[[getPosASL _enemy,side _x,"Normal",_super],"patrolCA"] remoteExec ["scheduler",2]}};
						};
					};
				if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then {[_x,_enemy] call fuegoSupresor} else {[_x,_x] spawn cubrirConHumo};
				};
			};
		};
	}
else
	{
	//_x allowFleeing (0.5-(_x skill "courage") + (0.2*({(_x getVariable ["surrendered",false]) or (!alive _x)} count (units group _x))));
	if (random 1 < 0.5) then {if (count units _grupo > 0) then {_x allowFleeing (1 -(_x skill "courage") + (({!([_x] call canFight)} count units _grupo)/(count units _grupo)))}};
	};
sleep 1 + (random 1);
} forEach units _grupo;

