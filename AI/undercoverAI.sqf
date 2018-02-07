private ["_unit","_behaviour","_primaryWeapon","_secondaryWeapon","_handGunWeapon","_casco","_hmd","_list","_primaryWeaponItems","_secondaryWeaponItems","_handgunItems"];

_unit = _this select 0;
if (isPlayer _unit) exitWith {};
_lider = _unit getVariable ["owner",leader group _unit];
if (!isPlayer _lider) exitWith {};
if (!captive _lider) exitWith {};
if (captive _unit) exitWith {};
[_unit,true] remoteExec ["setCaptive"];
_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit setUnitPos "UP";
_behaviour = behaviour _unit;
_unit setBehaviour "CARELESS";
_primaryWeapon = (primaryWeapon _unit) call BIS_fnc_baseWeapon;
_primaryWeaponItems = primaryWeaponItems _unit;
_unit removeWeaponGlobal _primaryWeapon;
_secondaryWeapon = secondaryWeapon _unit;
_secondaryWeaponItems = secondaryWeaponItems _unit;
_unit removeWeaponGlobal _secondaryWeapon;
_handGunWeapon = (handGunWeapon _unit) call BIS_fnc_baseWeapon;
_handgunItems = handgunItems _unit;
_unit removeWeaponGlobal _handGunWeapon;
_casco = headgear _unit;
removeHeadGear _unit;
_hmd = hmd _unit;
_unit unlinkItem _hmd;

_unit addEventHandler ["FIRED",
	{
	_unit = _this select 0;
	if (captive _unit) then
		{
		if ({((side _x== muyMalos) or (side _x== malos)) and (_x knowsAbout _unit > 1.4)} count allUnits > 0) then
			{
			[_unit,false] remoteExec ["setCaptive"];
			if (vehicle _unit != _unit) then
				{
				{
				if (captive _x) then {[_x,false] remoteExec ["setCaptive"]};
				} forEach ((assignedCargo (vehicle _unit)) + (crew (vehicle _unit)))
				};
			}
		else
			{
			_ciudad = [ciudades,_unit] call BIS_fnc_nearestPosition;
			_size = [_ciudad] call sizeMarker;
			_datos = server getVariable _ciudad;
			if (random 100 < _datos select 2) then
				{
				if (_unit distance getMarkerPos _ciudad < _size * 1.5) then
					{
					[_unit,false] remoteExec ["setCaptive"];
					};
				};
			};
		}
	}
	];

_aeropuertos = aeropuertos + puestos + (controles select {isOnRoad getMarkerPos _x});
while {(captive _lider) and (captive _unit)} do
	{
	sleep 1;
	if ((vehicle _unit != _unit) and (not((typeOf vehicle _unit) in arrayCivVeh))) exitWith {};
	_base = [_aeropuertos,player] call BIS_fnc_nearestPosition;
	_size = [_base] call sizeMarker;
	if ((_unit distance getMarkerPos _base < _size) and (not(_base in mrkSDK))) exitWith {[_unit,false] remoteExec ["setCaptive"]};
	if ((primaryWeapon _unit != "") or (secondaryWeapon _unit != "") or (handgunWeapon _unit != "")) exitWith {};
	};

_unit removeAllEventHandlers "FIRED";
if (!captive _unit) then {_unit groupChat "Shit, they have spotted me!"} else {[_unit,false] remoteExec ["setCaptive"]};
if (captive player) then {sleep 5};
_unit enableAI "TARGET";
_unit enableAI "AUTOTARGET";
_unit setUnitPos "AUTO";
_unit setBehaviour (behaviour leader _unit);
_sinMochi = false;
if ((backpack _unit == "") and (_secondaryWeapon == "")) then
	{
	_sinMochi = true;
	_unit addbackpack "B_AssaultPack_blk";
	};
{if (_x != "") then {[_unit, _x, 1, 0] call BIS_fnc_addWeapon}} forEach [_primaryWeapon,_secondaryWeapon,_handGunWeapon];
{_unit addPrimaryWeaponItem _x} forEach _primaryWeaponItems;
{_unit addSecondaryWeaponItem _x} forEach _secondaryWeaponItems;
{_unit addHandgunItem _x} forEach _handgunItems;
if (_sinMochi) then {removeBackpack _unit};
_unit addHeadgear _casco;
_unit linkItem _hmd;
//_unit setBehaviour "AWARE";
