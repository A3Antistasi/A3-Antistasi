private ["_unit","_enemy","_cobertura"];
_unit = _this select 0;
if (isPlayer _unit) exitWith {};
if (_unit != vehicle _unit) exitWith {};
if ((behaviour _unit == "COMBAT") or (behaviour _unit == "STEALTH")) exitWith {};
if !([_unit] call canFight) exitWith {};
_enemy = if (count _this > 1) then {_this select 1} else {_unit findNearestEnemy _unit};

if (isNull _enemy) exitWith {};
if (_unit distance _enemy < 300) exitWith {};
if (damage _unit >= 0.6) then {[_unit,_unit,_enemy] spawn cubrirConHumo};
_cobertura = [_unit,_enemy] call cobertura;

if (_cobertura isEqualTo []) exitWith {};

_unit stop false;
_unit forceSpeed -1;
{_unit disableAI _x} forEach ["AUTOTARGET","FSM","TARGET","SUPPRESSION","AUTOCOMBAT","WEAPONAIM","COVER"];
_unit setUnitPos "MIDDLE";
_unit setCombatMode "BLUE";
//_unit setBehaviour "CARELESS";
_unit doMove _cobertura;

[_unit,_cobertura] spawn
	{
	private ["_unit","_cobertura","_timeOut"];
	_unit = _this select 0;
	_cobertura = _this select 1;
	_timeOut = time + 15;
	waitUntil {sleep 0.5; (_unit distance _cobertura < 1) or (time > _timeOut)};
	if (_unit distance _cobertura < 1) then
		{
		sleep 1;
		_unit stop true;
		_unit forceSpeed 0;
		_unit setCombatMode "YELLOW";
		//_unit setBehaviour "COMBAT";
		_unit setUnitPos "AUTO";
		_unit doWatch (_unit findNearestEnemy _unit);
		sleep 30;
		};
	{_unit enableAI _x} forEach ["AUTOTARGET","FSM","TARGET","SUPPRESSION","AUTOCOMBAT","WEAPONAIM","COVER"];
	_unit setCombatMode "YELLOW";
	//_unit setBehaviour "COMBAT";
	_unit forceSpeed -1;
	_unit stop false;
	_unit setUnitPos "AUTO";
	};