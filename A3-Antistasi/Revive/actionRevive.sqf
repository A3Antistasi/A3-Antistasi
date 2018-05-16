private ["_curado","_curandero","_healed","_player","_timer","_lado","_accion"];

_curado = _this select 0;
_curandero = _this select 1;
_accion = 0;
_healed = false;
_player = isPlayer _curandero;
if (captive _curandero) then {[_curandero,false] remoteExec ["setCaptive"]};
if !([_curandero] call canFight) exitWith {if (_player) then {hint "You are not able to revive anyone"};_healed};
if ((not("FirstAidKit" in (items _curandero))) and (not("FirstAidKit" in (items _curado)))) exitWith {if (_player) then {hint format ["You or %1 need a First Aid Kit to be able to revive",name _curado]};_healed};
if ((not("FirstAidKit" in (items _curandero))) and !(_curandero canAdd "FirstAidKit")) exitWith {if (_player) then {hint format ["%1 has a First Aid Kit but you do not have enough space in your inventory to use it",name _curado]};_healed};
if ((_curado getVariable ["fatalWound",false]) and ((!(getNumber (configfile >> "CfgVehicles" >> (typeOf _curandero) >> "attendant") == 2)) and !(_curandero getUnitTrait "Medic"))) exitWith {if (_player) then {hint format ["%1 is injured by a fatal wound, only a medic can revive him",name _curado]};_healed};
if !(isNull attachedTo _curado) exitWith {if (_player) then {hint format ["%1 is being carried or transported and you cannot heal him",name _curado]};_healed};
if (_curado getVariable ["llevado",false]) exitWith {if (_player) then {hint format ["%1 is being carried and you cannot help him",name _curado]};_healed};
_curado setVariable ["ayudado",_curandero,true];

if (not("FirstAidKit" in (items _curandero))) then
	{
	_curandero addItem "FirstAidKit";
	_curado removeItem "FirstAidKit";
	};
_timer = if (_curado getVariable ["fatalWound",false]) then {time + 55 + (random 30)} else {time + 25 + (random 30)};
_curandero setVariable ["timeToHeal",_timer];
_curandero playMoveNow selectRandom medicAnims;
_curandero setVariable ["animsDone",false];

if (!_player) then
	{
	{_curandero disableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
	}
else
	{
	_accion = _curandero addAction ["Cancel Revive", {(_this select 1) setVariable ["cancelRevive",true]}];
	};
_curandero addEventHandler ["AnimDone",
	{
	private _curandero = _this select 0;
	if (([_curandero] call canFight) and (time < (_curandero getVariable ["timeToHeal",time])) and !(_curandero getVariable ["cancelRevive",false])) then
		{
		_curandero playMoveNow selectRandom medicAnims;
		}
	else
		{
		_curandero removeEventHandler ["AnimDone",_thisEventHandler];
		_curandero setVariable ["animsDone",true];
		};
	}];
waitUntil {sleep 0.5; ((time > _timer) and (_curandero getVariable ["animsDone",true])) or !([_curandero] call canFight) or (!alive _curado) or (_curandero != vehicle _curandero) or (_curandero getVariable ["cancelRevive",false])};
_curandero setVariable ["animsDone",nil];
_curandero setVariable ["timeToHeal",nil];
if (!_player) then
	{
	{_curandero enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"]
	}
else
	{
	_curandero removeAction _accion;
	};
if (_curandero getVariable ["cancelRevive",false]) exitWith
	{
	hint "Revive cancelled";
	_curandero setVariable ["cancelRevive",nil];
	_healed
	};
if !(alive _curado) exitWith {if (_player) then {hint format ["We lost %1",name _curado]};_healed};
if (!([_curandero] call canFight) or (_curandero != vehicle _curandero) or (_curandero distance _curado > 3)) exitWith {if (_player) then {hint "Revive cancelled"};_healed};
_curandero action ["HealSoldier",_curado];
waitUntil {sleep 0.5; !([_curandero] call canFight) or (!alive _curado) or (_curandero != vehicle _curandero) or ((alive _curado) and (lifeState _curado != "INCAPACITATED"))};
if !(alive _curado) exitWith {if (_player) then {hint format ["We lost %1",name _curado]};_healed};
if (lifeState _curado == "INCAPACITATED") exitWith {if (_player) then {hint "Revive unsuccesful"};_healed};
_lado = _curado getVariable "lado";
if !(isNil "_lado") then
	{
	if ((_lado != side _curandero) and ((_lado == malos) or (_lado == muyMalos))) then {_curado setVariable ["surrendered",true,true]};
	};
_healed = true;
if (_player) then {_curado setVariable ["ayudado",objNull,true]};
_healed