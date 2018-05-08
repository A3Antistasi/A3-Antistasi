private ["_unit","_grupo","_grupos","_isLeader","_dummyGroup","_bleedOut","_suicide","_saveVolume","_ayuda","_ayudado","_texto","_isPlayer","_camTarget","_saveVolumeVoice"];
_unit = _this select 0;
_injurer = _this select 1;
//if (_unit getVariable "inconsciente") exitWith {};
//if (damage _unit < 0.9) exitWith {};
//if (!local _unit) exitWith {};
//_unit setVariable ["inconsciente",true,true];
_bleedOut = if (surfaceIsWater (position _unit)) then {time + 60} else {time + 300};//300
_jugadores = false;

if ({if ((isPlayer _x) and (_x distance _unit < distanciaSPWN2)) exitWith {1}} count allUnits != 0) then
	{
	_jugadores = true;
	[_unit,"heal"] remoteExec ["flagaction",0,_unit];
	[_unit,true] remoteExec ["setCaptive"];
	_lado = _unit getVariable ["lado",sideUnknown];
	_unit setVariable ["lado",_lado,true];
	};

_unit setFatigue 1;
_grupo = group _unit;
[_grupo,_injurer] spawn
	{
	private ["_grupo","_killer"];
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
						if (vehicle _killer == _killer) then
							{
							[[getPosASL _enemy,side _x,"Normal"],"patrolCA"] remoteExec ["scheduler",2];
							}
						else
							{
							if (vehicle _killer isKindOf "Air") then {[[getPosASL _enemy,side _x,"Air"],"patrolCA"] remoteExec ["scheduler",2]} else {if (vehicle _killer isKindOf "Tank") then {[[getPosASL _enemy,side _x,"Tank"],"patrolCA"] remoteExec ["scheduler",2]} else {[[getPosASL _enemy,side _x,"Normal"],"patrolCA"] remoteExec ["scheduler",2]}};
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
		if (random 1 < 0.5) then {_x allowFleeing (0.5 -(_x skill "courage") + (({!([_x] call canFight)} count units _grupo)/(count units _grupo)))};
		};
	} forEach units _grupo;
	};

while {(time < _bleedOut) and (damage _unit > 0.25) and (alive _unit)} do
	{
	if (random 10 < 1) then {playSound3D [(injuredSounds call BIS_fnc_selectRandom),_unit,false, getPosASL _unit, 1, 1, 50];};
	_ayudado = _unit getVariable ["ayudado",objNull];
	if (isNull _ayudado) then {[_unit] call pedirAyuda;};
	sleep 3;
	};

_unit stop false;
if (_jugadores) then
	{
	[_unit,"remove"] remoteExec ["flagaction",0,_unit];
	};

if (_unit getVariable ["fatalWound",false]) then {_unit setVariable ["fatalWound",false,true]};

if (time > _bleedOut) exitWith
	{
	_lado = _unit getVariable ["lado",sideUnknown];

	if (isPlayer _injurer) then
		{
		[1,_injurer] call playerScoreAdd;
		}
	else
		{
		_skill = skill _injurer;
		[_injurer,_skill + 0.05] remoteExec ["setSkill",_injurer];
		};

	if (_lado == malos) then
		{
		[0,0.25,getPos _unit] remoteExec ["citySupportChange",2];
		[0.1,0] remoteExec ["prestige",2];
		}
	else
		{
		[0,1,getPos _unit] remoteExec ["citySupportChange",2];
		[0,0.25] remoteExec ["prestige",2];
		};

	_unit setDamage 1;
	};

if (alive _unit) then
	{
	_unit setUnconscious false;
	_unit playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
	_unit setVariable ["overallDamage",damage _unit];
	if (captive _unit) then
		{
		if !(_unit getVariable ["surrendered",false]) then
			{
			[_unit,false] remoteExec ["setCaptive"];
			_unit disableAI "ANIM";
			sleep 120 + (random 120);
			if ([_unit] call canFight) then {_unit enableAI "ANIM"};
			}
		else
			{
			[_unit] spawn surrenderAction
			};
		}
	else
		{
		_unit disableAI "ANIM";
		sleep 120 + (random 120);
		if ([_unit] call canFight) then {_unit enableAI "ANIM"};
		};
	};
