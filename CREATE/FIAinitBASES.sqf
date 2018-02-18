private ["_unit","_skill"];

_unit = _this select 0;
_marcador = "";
if (count _this > 1) then
	{
	_marcador = _this select 1;
	_unit setVariable ["marcador",_marcador,true];
	if ((spawner getVariable _marcador != 0) and (vehicle _unit != _unit)) then
		{
		if (!isMultiplayer) then
			{
			_unit enableSimulation false
			}
		else
			{
			[_unit,false] remoteExec ["enableSimulationGlobal",2]
			}
		};
	};
[_unit] call initRevive;

_unit allowFleeing 0;
_tipo = typeOf _unit;
_skill = if (_tipo in sdkTier1) then {0.1 + (skillFIA * 0.2)} else {if (_tipo in sdkTier2) then {0.2 + (skillFIA * 0.2)} else {0.3 + (skillFIA * 0.2)}};
if ((_marcador == "Synd_HQ") and (isMultiplayer)) then {_skill = 1};
_unit setSkill (_skill + 0.1);
if (not((uniform _unit) in uniformsSDK)) then {[_unit] call reDress};
if (_tipo in SDKSniper) then
	{
	removeAllWeapons _unit;
	[_unit, sniperRifle, 8, 0] call BIS_fnc_addWeapon;
	_unit addPrimaryWeaponItem "optic_KHS_old";
	}
else
	{
	if (_unit skill "aimingAccuracy" > 0.35) then {_unit setSkill ["aimingAccuracy",0.35]};
	if (_tipo in SDKMil) then
		{
		_rifleFinal = unlockedRifles call BIS_fnc_selectRandom;
		if (_rifleFinal != primaryWeapon _unit) then
			{
			_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
			{_unit removeMagazines _x} forEach _magazines;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit, _rifleFinal, 6, 0] call BIS_fnc_addWeapon;
			if (loadAbs _unit < 340) then
				{
				if ((random 20 < skillFIA) and ({_x in titanLaunchers} count unlockedWeapons > 0)) then
					{
					_unit addbackpack "B_AssaultPack_blk";
					[_unit, "launch_I_Titan_F", 2, 0] call BIS_fnc_addWeapon;
					removeBackpack _unit;
					};
				};
			};
		}
	else
		{
		if ((activeGREF) and (!(_tipo in SDKMG))) then
			{
			_rifleFinal = unlockedRifles call BIS_fnc_selectRandom;
			if (_rifleFinal != primaryWeapon _unit) then
				{
				_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
				{_unit removeMagazines _x} forEach _magazines;
				_unit removeWeaponGlobal (primaryWeapon _unit);
				[_unit, _rifleFinal, 6, 0] call BIS_fnc_addWeapon;
				};
			};
		if (_tipo in SDKMedic) then
			{
			_unit setUnitTrait ["medic",true]
			}
		else
			{
			if (_tipo in SDKATman) then
				{
				_rlauncher = selectRandom ((rlaunchers + mlaunchers) select {(_x in unlockedWeapons) and (getNumber (configfile >> "CfgWeapons" >> _x >> "lockAcquire") == 0)});
				if (_rlauncher != secondaryWeapon _unit) then
					{
					_magazines = getArray (configFile / "CfgWeapons" / (secondaryWeapon _unit) / "magazines");
					{_unit removeMagazines _x} forEach _magazines;
					_unit removeWeaponGlobal (secondaryWeapon _unit);
					[_unit, _rlauncher, 4, 0] call BIS_fnc_addWeapon;
					};
				}
			else
				{
				if ((_tipo in SDKMG) and (activeGREF)) then
					{
					_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
					{_unit removeMagazines _x} forEach _magazines;
					_unit removeWeaponGlobal (primaryWeapon _unit);
					[_unit, "rhs_weap_pkm", 6, 0] call BIS_fnc_addWeapon;
					};
				};
			};
		};
	if (count unlockedOptics > 0) then
		{
		_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
		_posibles = unlockedOptics select {_x in _compatibles};
		_unit addPrimaryWeaponItem (selectRandom _posibles);
		};
	};

_unit selectWeapon (primaryWeapon _unit);
/*
_aiming = _skill + 0.1;
_spotD = _skill + 0.1;
_spotT = _skill + 0.1;
_cour = _skill + 0.1;
_comm = _skill + 0.1;
_aimingSh = _skill + 0.1;
_aimingSp = _skill + 0.1;
_reload = _skill + 0.1;


//_emptyUniform = false;
_skillSet = 0;
*/
if (!haveRadio) then {_unit unlinkItem "ItemRadio"};

if (sunOrMoon < 1) then
	{
	if (haveNV) then
		{
		_unit linkItem "NVGoggles";
		if ("acc_pointer_IR" in unlockedItems) then
			{
			_unit addPrimaryWeaponItem "acc_pointer_IR";
	        _unit assignItem "acc_pointer_IR";
	        _unit enableIRLasers true;
			};
		}
	else
		{
		_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
		_array = lamparasSDK arrayIntersect _compatibles;
		if (count _array > 0) then
			{
			_compatible = _array select 0;
			_unit addPrimaryWeaponItem _compatible;
		    _unit assignItem _compatible;
		    _unit enableGunLights _compatible;
			};
	    };
	};
if ({if (_x in humo) exitWith {1}} count unlockedMagazines > 0) then {_unit addMagazines [selectRandom humo,2]};
if (_unit == leader _unit) then
	{
	_unit setskill ["courage",_skill + 0.2];
	_unit setskill ["commanding",_skill + 0.2];
	};
/*
if ((_tipo != "B_G_Soldier_M_F") and (_tipo != "B_G_Sharpshooter_F")) then {if (_aiming > 0.35) then {_aiming = 0.35}};
_unit setskill ["aimingAccuracy",_aiming];
_unit setskill ["spotDistance",_spotD];
_unit setskill ["spotTime",_spotT];
_unit setskill ["courage",_cour];
_unit setskill ["commanding",_comm];
_unit setskill ["aimingShake",_aimingSh];
_unit setskill ["aimingSpeed",_aimingSp];
_unit setskill ["reloadSpeed",_reload];
*/
_EHkilledIdx = _unit addEventHandler ["killed", {
	_muerto = _this select 0;
	_killer = _this select 1;
	[_muerto] remoteExec ["postmortem",2];
	if (isPlayer _killer) then
		{
		if (!isMultiPlayer) then
			{
			_nul = [0,20] remoteExec ["resourcesFIA",2];
			_killer addRating 1000;
			};
		};
	if (side _killer == malos) then
		{
		[0,-0.25,getPos _muerto] remoteExec ["citySupportChange",2];
		[-0.25,0] remoteExec ["prestige",2];
		}
	else
		{
		if (side _killer == muyMalos) then {[0,-0.25] remoteExec ["prestige",2]};
		};
	_marcador = _muerto getVariable "marcador";
	if (!isNil "_marcador") then
		{
		if (_marcador in mrkSDK) then
			{
			_garrison = [];
			_garrison = _garrison + (garrison getVariable [_marcador,[]]);
			if (_garrison isEqualType []) then
				{
				for "_i" from 0 to (count _garrison -1) do
					{
					if (typeOf _muerto == (_garrison select _i)) exitWith {_garrison deleteAt _i};
					};
				garrison setVariable [_marcador,_garrison,true];
				};
			[_marcador] call mrkUpdate;
			_muerto setVariable [_marcador,nil,true];
			};
		};
	}];

