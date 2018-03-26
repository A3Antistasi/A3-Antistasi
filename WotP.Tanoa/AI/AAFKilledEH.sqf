private ["_muerto","_killer","_coste","_enemy","_grupo"];
_muerto = _this select 0;
_killer = _this select 1;
if (_muerto getVariable ["OPFORSpawn",false]) then
	{
	_muerto setVariable ["OPFORSpawn",nil,true]
	}
else
	{
	if (_muerto getVariable ["BLUFORSpawn",false]) then
		{
		_muerto setVariable ["BLUFORSpawn",nil,true]
		};
	};
[_muerto] spawn postmortem;
_grupo = group _muerto;
_lado = _muerto getVariable ["lado",sideUnknown];
if (hayACE) then
	{
	if ((isNull _killer) || (_killer == _muerto)) then
		{
		_killer = _muerto getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};

if ((side _killer == buenos) or (side _killer == civilian)) then
	{
	if (isPlayer _killer) then
		{
		[1,_killer] call playerScoreAdd;
		if (captive _killer) then
			{
			if (_killer distance _muerto < distanciaSPWN) then
				{
				[_killer,false] remoteExec ["setCaptive"];
				};
			};
		_killer addRating 1000;
		}
	else
		{
		_skill = skill _killer;
		[_killer,_skill + 0.05] remoteExec ["setSkill",_killer];
		};
	if (vehicle _killer isKindOf "StaticMortar") then
		{
		if (isMultiplayer) then
			{
			{
			if ((_x distance _muerto < 300) and (captive _x)) then {[_x,false] remoteExec ["setCaptive"]};
			} forEach playableUnits;
			}
		else
			{
			if ((player distance _muerto < 300) and (captive player)) then {player setCaptive false};
			};
		};
	if (count weapons _muerto < 1) then
		{
		if (_lado == malos) then
			{
			[0,-2,getPos _muerto] remoteExec ["citySupportChange",2];
			[1,0] remoteExec ["prestige",2];
			}
		else
			{
			[0,1] remoteExec ["prestige",2];
			};
		}
	else
		{
		if (_lado == malos) then
			{
			[0,0.25,getPos _muerto] remoteExec ["citySupportChange",2];
			[0.1,0] remoteExec ["prestige",2];
			}
		else
			{
			[0,1,getPos _muerto] remoteExec ["citySupportChange",2];
			[0,0.25] remoteExec ["prestige",2];
			};
		};
	}
else
	{
	if (_lado == malos) then
		{
		[-0.25,0,getPos _muerto] remoteExec ["citySupportChange",2];
		}
	else
		{
		[0.25,0,getPos _muerto] remoteExec ["citySupportChange",2];
		};
	};
_marcador = _muerto getVariable "marcador";
_grrisoned = true;
if (isNil "_marcador") then {_marcador = _muerto getVariable "origen"; _garrisoned = false};
if (!isNil "_marcador") then
	{
	if (_marcador != "") then {[typeOf _muerto,_lado,_marcador,-1] spawn garrisonUpdate};
	if (_garrisoned) then {[_marcador,_lado] spawn zoneCheck};
	};

[_grupo,_killer] spawn
	{
	private ["_grupo","_killer"];
	_grupo = _this select 0;
	_killer = _this select 1;
	{
	if (alive _x) then
		{
		if (fleeing _x) then
			{
			if !(_x getVariable ["surrendered",false]) then
				{
				if (lifeState _x != "INCAPACITATED") then
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
								if (vehicle _killer == _killer) then
									{
									[getPosASL _enemy,side _x,"Normal"] remoteExec ["patrolCA",HCattack]
									}
								else
									{
									if (vehicle _killer isKindOf "Air") then {[getPosASL _enemy,side _x,"Air"] remoteExec ["patrolCA",HCattack]} else {if (vehicle _killer isKindOf "Tank") then {[getPosASL _enemy,side _x,"Tank"] remoteExec ["patrolCA",HCattack]} else {[getPosASL _enemy,side _x,"Normal"] remoteExec ["patrolCA",HCattack]}};
									};
								};
							if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then {[_x,_enemy] call fuegoSupresor} else {[_x,_x] spawn cubrirConHumo};
							};
						};
					};
				};
			}
		else
			{
			//_x allowFleeing (0.5-(_x skill "courage") + (0.2*({(_x getVariable ["surrendered",false]) or (!alive _x)} count (units group _x))));
			if (random 1 < 0.5) then {_x allowFleeing (0.5 -(_x skill "courage") + (({(!alive _x) or (_x getVariable ["surrendered",false]) OR (lifeState _x == "INCAPACITATED")} count units _grupo)/(count units _grupo)))};
			};
		};
	} forEach units _grupo;
	sleep 1 + (random 1);
	};

