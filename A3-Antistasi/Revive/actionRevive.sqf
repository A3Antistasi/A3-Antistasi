private ["_curado","_medicX","_healed","_player","_timer","_lado","_accion"];

_curado = _this select 0;
_medicX = _this select 1;
_accion = 0;
_healed = false;
_player = isPlayer _medicX;
_inPlayerGroup = if !(_player) then {if ({isPlayer _x} count (units group _medicX) > 0) then {true} else {false}} else {false};
if (captive _medicX) then
	{
	[_medicX,false] remoteExec ["setCaptive",0,_medicX];
	_medicX setCaptive false;
	};
if !(alive _curado) exitWith
	{
	if (_player) then {hint format ["%1 is already dead",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat format ["%1 is already dead",name _curado]};
	_healed
	};
if !([_medicX] call A3A_fnc_canFight) exitWith {if (_player) then {hint "You are not able to revive anyone"};_healed};
if ((not("FirstAidKit" in (items _medicX))) and (not("FirstAidKit" in (items _curado)))) exitWith
	{
	if (_player) then {hint format ["You or %1 need a First Aid Kit to be able to revive",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat "I'm out of FA kits!"};
	_healed
	};
if ((not("FirstAidKit" in (items _medicX))) and !(_medicX canAdd "FirstAidKit")) exitWith
	{
	if (_player) then {hint format ["%1 has a First Aid Kit but you do not have enough space in your inventory to use it",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat "I'm out of FA kits!"};
	_healed
	};
if ((([_curado] call A3A_fnc_fatalWound)) and !([_medicX] call A3A_fnc_isMedic)) exitWith
	{
	if (_player) then {hint format ["%1 is injured by a fatal wound, only a medic can revive him",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat format ["%1 is injured by a fatal wound, only a medic can revive him",name _curado]};
	_healed
	};
if !(isNull attachedTo _curado) exitWith
	{
	if (_player) then {hint format ["%1 is being carried or transported and you cannot heal him",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat format ["%1 is being carried or transported and I cannot heal him",name _curado]};
	_healed
	};
if !(_curado getVariable ["INCAPACITATED",false]) exitWith
	{
	if (_player) then {hint format ["%1 no longer needs your help",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat format ["%1 no longer needs my help",name _curado]};
	_healed
	};
if (surfaceIsWater (position _curado)) exitWith {if (_player) then {hint format ["You cannot heal %1 in the water",name _curado]};_healed};
if (_player) then
	{
	_curado setVariable ["ayudado",_medicX,true];
	};
_medicX setVariable ["helping",true];
if (not("FirstAidKit" in (items _medicX))) then
	{
	_medicX addItem "FirstAidKit";
	_curado removeItem "FirstAidKit";
	};
_timer = if ([_curado] call A3A_fnc_fatalWound) then
			{
			time + 35 + (random 20)
			}
		else
			{
			if ((!isMultiplayer and (isPlayer _curado)) or ([_medicX] call A3A_fnc_isMedic)) then
				{
				time + 10 + (random 5)
				}
			else
				{
				time + 15 + (random 10)
				};
			};


_medicX setVariable ["timeToHeal",_timer];
_medicX playMoveNow selectRandom medicAnims;
_medicX setVariable ["animsDone",false];
_medicX setVariable ["curado",_curado];
_medicX setVariable ["success",false];
_medicX setVariable ["cancelRevive",false];
if (!_player) then
	{
	{_medicX disableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
	}
else
	{
	_accion = _medicX addAction ["Cancel Revive", {(_this select 1) setVariable ["cancelRevive",true]},nil,6,true,true,"","(_this getVariable [""helping"",false]) and (isPlayer _this)"];
	};
_medicX addEventHandler ["AnimDone",
	{
	private _medicX = _this select 0;
	private _curado = _medicX getVariable ["curado",objNull];
	if (([_medicX] call A3A_fnc_canFight) and (time <= (_medicX getVariable ["timeToHeal",time])) and !(_medicX getVariable ["cancelRevive",false]) and (alive _curado) and (_curado getVariable ["INCAPACITATED",false]) and (_medicX == vehicle _medicX)) then
		{
		_medicX playMoveNow selectRandom medicAnims;
		}
	else
		{
		_medicX removeEventHandler ["AnimDone",_thisEventHandler];
		_medicX setVariable ["animsDone",true];
		if (([_medicX] call A3A_fnc_canFight) and !(_medicX getVariable ["cancelRevive",false]) and (_medicX == vehicle _medicX) and (alive _curado)) then
			{
			if (_curado getVariable ["INCAPACITATED",false]) then
				{
				_medicX setVariable ["success",true];
				//_curado setVariable ["INCAPACITATED",false,true];
				//_medicX action ["HealSoldier",_curado];
				if ([_medicX] call A3A_fnc_isMedic) then {_curado setDamage 0.25} else {_curado setDamage 0.5};
				_medicX removeItem "FirstAidKit";
				};
			};
		};
	}];
waitUntil {sleep 0.5; (_medicX getVariable ["animsDone",true])};
_medicX setVariable ["animsDone",nil];
_medicX setVariable ["timeToHeal",nil];
_medicX setVariable ["curado",nil];
_medicX setVariable ["helping",false];
if (!_player) then
	{
	{_medicX enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
	}
else
	{
	_medicX removeAction _accion;
	_curado setVariable ["ayudado",objNull,true];
	_medicX setVariable ["helping",false];
	};
if (_medicX getVariable ["cancelRevive",false]) exitWith
	{
	if (_player) then
		{
		hint "Revive cancelled";
		_medicX setVariable ["cancelRevive",nil];
		};
	_healed
	};
if !(alive _curado) exitWith
	{
	if (_player) then {hint format ["We lost %1",name _curado]};
	if (_inPlayerGroup) then {_medicX groupChat format ["We lost %1",name _curado]};
	_healed
	};
if (!([_medicX] call A3A_fnc_canFight) or (_medicX != vehicle _medicX) or (_medicX distance _curado > 3)) exitWith {if (_player) then {hint "Revive cancelled"};_healed};

if (_medicX getVariable ["success",true]) then
	{
	_lado = side (group _curado);
	if ((_lado != side (group _medicX)) and ((_lado == Occupants) or (_lado == ))) then
		{
		_curado setVariable ["surrendered",true,true];
		sleep 2;
		};
	_curado setVariable ["INCAPACITATED",false,true];
	_healed = true;
	}
else
	{
	if (_player) then {hint "Revive unsuccesful"};
	if (_inPlayerGroup) then {_medicX groupChat "Revive failed"};
	};

_healed