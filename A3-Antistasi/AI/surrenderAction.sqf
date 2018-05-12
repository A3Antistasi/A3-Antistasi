private ["_unit","_coste","_armas","_municion","_caja","_items"];

_unit = _this select 0;

if (typeOf _unit == "Fin_random_F") exitWith {};

_unit setVariable ["surrendered",true];
//_unit setVariable ["lado",side _unit,true];
if (side _unit == malos) then
	{
	_nul = [-2,0,getPos _unit] remoteExec ["citySupportChange",2];
	}
else
	{
	_nul = [1,0,getPos _unit] remoteExec ["citySupportChange",2];
	};
[_unit,"interrogar"] remoteExec ["flagaction",[buenos,civilian],_unit];
[_unit,"capturar"]remoteExec ["flagaction",[buenos,civilian],_unit];
_armas = [];
_municion = [];
_items = [];
_unit allowDamage false;
[_unit] orderGetin false;
_unit stop true;
_unit disableAI "MOVE";
_unit disableAI "AUTOTARGET";
_unit disableAI "TARGET";
_unit disableAI "ANIM";
//_unit disableAI "FSM";
_unit setSkill 0;
_unit setUnitPos "UP";
_caja = "Box_IND_Wps_F" createVehicle position _unit;
_caja allowDamage false;
clearMagazineCargoGlobal _caja;
clearWeaponCargoGlobal _caja;
clearItemCargoGlobal _caja;
clearBackpackCargoGlobal _caja;
_armas = weapons _unit;
{_caja addWeaponCargoGlobal [[_x] call BIS_fnc_baseWeapon,1]} forEach _armas;
_municion = magazines _unit;
{_caja addMagazineCargoGlobal [_x,1]} forEach _municion;
_items = assignedItems _unit + items _unit + primaryWeaponItems _unit;
{_caja addItemCargoGlobal [_x,1]} forEach _items;
_caja call jn_fnc_logistics_addAction;
removeAllWeapons _unit;
removeAllAssignedItems _unit;
[_unit,true] remoteExec ["setCaptive"];
sleep 1;
if (alive _unit) then
	{
	_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
	};
_unit setSpeaker "NoVoice";
_unit addEventHandler ["HandleDamage",
	{
	_unit = _this select 0;
	_unit enableAI "ANIM";
	if (!simulationEnabled _unit) then {if (isMultiplayer) then {[_unit,true] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation true}};
	}
	];
if (_unit getVariable ["OPFORSpawn",false]) then
	{
	_unit setVariable ["OPFORSpawn",nil,true]
	}
else
	{
	if (_unit getVariable ["BLUFORSpawn",false]) then
		{
		_unit setVariable ["BLUFORSpawn",nil,true]
		};
	};

_marcador = _unit getVariable "marcador";

if (!isNil "_marcador") then
	{
	_lado = _unit getVariable "lado";
	[_marcador,_lado] remoteExec ["zoneCheck",2];
	};

[_unit] spawn postmortem;
[_caja] spawn postmortem;
sleep 10;
_unit allowDamage true;
if (isMultiplayer) then {[_unit,false] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation false};