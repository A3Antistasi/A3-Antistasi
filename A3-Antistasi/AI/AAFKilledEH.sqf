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
_lado = side (group _muerto);
if (hayACE) then
	{
	if ((isNull _killer) || (_killer == _muerto)) then
		{
		_killer = _muerto getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};
//if (_killer isEqualType "") then {diag_log format ["Antistasi error in AAFKilledEH, params: %1",_this]};
if (side (group _killer) == buenos) then
	{
	if (isPlayer _killer) then
		{
		[1,_killer] call playerScoreAdd;
		if (captive _killer) then
			{
			if (_killer distance _muerto < distanciaSPWN) then
				{
				[_killer,false] remoteExec ["setCaptive",0,_killer];
				_killer setCaptive false;
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
			if ((_x distance _muerto < 300) and (captive _x)) then {[_x,false] remoteExec ["setCaptive",0,_x]; _x setCaptive false};
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
		[-1,1,getPos _muerto] remoteExec ["citySupportChange",2];
		if (_lado == malos) then
			{
			[0.1,0] remoteExec ["prestige",2];
			}
		else
			{
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
_garrisoned = true;
if (isNil "_marcador") then {_marcador = _muerto getVariable ["origen",""]; _garrisoned = false};
if (_marcador != "") then
	{
	if (lados getVariable [_marcador,sideUnknown] == _lado) then
		{
		[typeOf _muerto,_lado,_marcador,-1] remoteExec ["garrisonUpdate",2];
		if (_garrisoned) then {[_marcador,_lado] remoteExec ["zoneCheck",2]};
		};
	};
[_grupo,_killer] spawn AIreactOnKill;

