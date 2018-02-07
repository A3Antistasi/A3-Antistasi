private ["_unit","_muerto","_killer","_skill","_nombre","_tipo"];

_unit = _this select 0;

[_unit] call initRevive;
_unit setVariable ["GREENFORSpawn",true,true];

_unit allowFleeing 0;
_tipo = typeOf _unit;
_skill = if (_tipo in sdkTier1) then {(skillFIA * 0.2)} else {if (_tipo in sdkTier2) then {0.1 + (skillFIA * 0.2)} else {0.1 + (skillFIA * 0.2)}};
if (not((uniform _unit) in uniformsSDK)) then {[_unit] call reDress};

if ((!isMultiplayer) and (leader _unit == stavros)) then {_skill = _skill + 0.1};
_unit setSkill _skill;
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
			/*
			_mag = _magazines select 0;
			for "_i" from 1 to ({_x == _mag} count magazines _unit) do
				{
				_unit removeMagazine _mag;
				};
			*/
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
			};
		if (_tipo in SDKExp) then
			{
			/*_unit setUnitTrait ["engineer",true];*/ _unit setUnitTrait ["explosiveSpecialist",true];
			}
		else
			{
			if ((_tipo in SDKMG) and (activeGREF)) then
				{
				_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
				{_unit removeMagazines _x} forEach _magazines;
				_unit removeWeaponGlobal (primaryWeapon _unit);
				[_unit, "rhs_weap_pkm", 6, 0] call BIS_fnc_addWeapon;
				}
			else
				{
				if (_tipo in SDKMedic) then
					{
					_unit setUnitTrait ["medic",true]
					}
				else
					{
					if (_tipo in SDKATman) then
						{
						_rlauncher = selectRandom ((rlaunchers + mlaunchers) select {_x in unlockedWeapons});
						if (_rlauncher != secondaryWeapon _unit) then
							{
							_magazines = getArray (configFile / "CfgWeapons" / (secondaryWeapon _unit) / "magazines");
							{_unit removeMagazines _x} forEach _magazines;
							_unit removeWeaponGlobal (secondaryWeapon _unit);
							[_unit, _rlauncher, 4, 0] call BIS_fnc_addWeapon;
							};
						};
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
_unit setUnitTrait ["camouflageCoef",0.8];
_unit setUnitTrait ["audibleCoef",0.8];

_unit selectWeapon (primaryWeapon _unit);
/*
_aiming = _skill;
_spotD = _skill;
_spotT = _skill;
_cour = _skill;
_comm = _skill;
_aimingSh = _skill;
_aimingSp = _skill;
_reload = _skill;


//_emptyUniform = false;
_skillSet = 0;
*/
if (not("ItemRadio" in unlockedItems)) then
	{
	if ((_unit != leader _unit) and (_tipo != staticCrewBuenos)) then {_unit unlinkItem "ItemRadio"};
	};
if ({if (_x in humo) exitWith {1}} count unlockedMagazines > 0) then {_unit addMagazines [selectRandom humo,2]};
/*
switch _tipo do
	{
	case "B_G_Soldier_LAT_F":
		{
		if ("launch_I_Titan_short_F" in unlockedWeapons) then
			{
			for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
				{
				_unit removeMagazine "RPG32_F";
				};
			_unit removeMagazine "RPG32_HE_F";
			_unit removeWeaponGlobal "launch_RPG32_F";
			[_unit, "launch_I_Titan_short_F", 4, 0] call BIS_fnc_addWeapon;
			}
		else
			{
			if ("launch_NLAW_F" in unlockedWeapons) then
				{
				for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
					{
					_unit removeMagazine "RPG32_F";
					};
				_unit removeMagazine "RPG32_HE_F";
				_unit removeWeaponGlobal "launch_RPG32_F";
				[_unit, "launch_NLAW_F", 4, 0] call BIS_fnc_addWeapon;
				}
			else
				{
				if (hayRHS) then
					{
					for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
						{
						_unit removeMagazine "RPG32_F";
						};
					_unit removeMagazine "RPG32_HE_F";
					_unit removeWeaponGlobal "launch_RPG32_F";
					[_unit, "rhs_weap_rpg7", 4, 0] call BIS_fnc_addWeapon;
					if (count unlockedOptics > 0) then
						{
						_compatibles = [secondaryWeapon _unit] call BIS_fnc_compatibleItems;
						_posibles = [];
						{
						if (_x in _compatibles) then {_posibles pushBack _x};
						} forEach unlockedOptics;
						_unit addSecondaryWeaponItem (_posibles call BIS_fnc_selectRandom);
						};
					};
				};
			};
		[_unit,true,true,true,false] call randomRifle;
		};
	case SDKRifleman:
		{
		[_unit,true,true,true,true] call randomRifle;
		if (loadAbs _unit < 340) then
			{
			if ((random 20 < _skillFIA) and ("launch_I_Titan_F" in unlockedWeapons)) then
				{
				_unit addbackpack "B_AssaultPack_blk";
				[_unit, "launch_I_Titan_F", 2, 0] call BIS_fnc_addWeapon;
				removeBackpack _unit;
				}
			else
				{
				if ((random 20 < _skillFIA) and ("launch_NLAW_F" in unlockedWeapons)) then
					{
					_unit addbackpack "B_AssaultPack_blk";
					if (hayRHS) then {[_unit, "rhs_weap_rpg7", 2, 0] call BIS_fnc_addWeapon;} else {[_unit, "launch_RPG32_F", 2, 0] call BIS_fnc_addWeapon};
					removeBackPack _unit;
					};
				};
			};
		};
	case "B_G_Soldier_GL_F":
		{
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			[_unit,false,true,true,true] call randomRifle;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_762x39mm"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_akms_gp25";
			}
		else
			{
			[_unit,false,true,true,false] call randomRifle;
			};
		};
	case "B_G_Soldier_lite_F":
		{
		[_unit,true,true,true,true] call randomRifle;
		_skillSet = 1;
		};
	case staticCrewBuenos:
		{
		_skilleSet = 1;
		};
	case SDKSL:
		{
		[_unit,false,true,true,false] call randomRifle;
		_skillSet = 2;
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
			};
		};
	case "B_G_Soldier_TL_F":
		{
		[_unit,false,true,true,false] call randomRifle;
		_skillSet = 3;
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
			};
		};
	case "B_G_Soldier_AR_F":
		{
		if (hayRHS) then
			{
			[_unit,false,true,true,true] call randomRifle;
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addWeaponGlobal "rhs_weap_pkm";
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_emptyUniform = true;
			}
		else
			{
			[_unit,false,true,true,false] call randomRifle;
			};
		_skillSet = 4;
		};
	case "B_G_medic_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_engineer_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_Soldier_exp_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		_unit addmagazine "ATMine_Range_Mag";
		};
	case "B_G_Soldier_A_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_Soldier_M_F":
		{
		if (("srifle_GM6_F" in unlockedWeapons) or (hayRHS)) then
			{
			for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do
				{
				_unit removeMagazine "30Rnd_556x45_Stanag";
				};
			_unit removeWeaponGlobal (primaryWeapon _unit);
			if ("srifle_GM6_F" in unlockedWeapons) then {[_unit, "srifle_GM6_SOS_F", 8, 0] call BIS_fnc_addWeapon} else {[_unit, "rhs_weap_svdp_wd", 8, 0] call BIS_fnc_addWeapon; _unit addPrimaryWeaponItem "rhs_acc_pso1m2";}
			};
		_skillSet = 6;
		};
	case "B_G_Sharpshooter_F":
		{
		_skillSet = 6;
		};
	};

switch _skillSet do
	{
	case 0:
		{
		_aiming = _aiming -0.2;
		_aimingSh = _aimingSh - 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 1:
		{
		_aiming = _aiming -0.1;
		_spotD = _spotD - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp + 0.2;
		_reload = _reload + 0.1;
		};
	case 2:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD + 0.2;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.2;
		};
	case 3:
		{
		_aiming = _aiming + 0.1;
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.1;
		_cour = _cour + 0.1;
		_comm = _comm + 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 4:
		{
		_aiming = _aiming - 0.1;
		_aimingSh = _aimingSh + 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 5:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD - 0.1;
		_spotT = _spotT - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 6:
		{
		_aiming = _aiming + 0.2;
		_spotD = _spotD + 0.4;
		_spotT = _spotT + 0.2;
		_cour = _cour - 0.1;
		_comm = _comm - 0.1;
		_aimingSh = _aimingSh + 0.1;
		_aimingSp = _aimingSp + 0.1;
		_reload = _reload - 0.4;
		};
	};

_unit selectWeapon (primaryWeapon _unit);
*/
if (sunOrMoon < 1) then
	{
	if ("NVGoggles" in unlockedItems) then
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
if (player == leader _unit) then
	{
	_unit setVariable ["owner",player];
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		[_muerto] spawn postmortem;
		_killer = _this select 1;
		arrayids pushBackUnique (name _muerto);
		if (side _killer == malos) then
			{
			_nul = [0.25,0,getPos _muerto] remoteExec ["citySupportChange",2];
			[-0.25,0] remoteExec ["prestige",2];
			}
		else
			{
			if (side _killer == muyMalos) then {[0,-0.25] remoteExec ["prestige",2]};
			};
		_muerto setVariable ["GREENFORSpawn",nil,true];
		}];
	if (typeOf _unit != SDKUnarmed) then
		{
		_idUnit = arrayids call BIS_Fnc_selectRandom;
		arrayids = arrayids - [_idunit];
		_unit setIdentity _idUnit;
		};
	if (captive player) then {[_unit] spawn undercoverAI};

	_unit setVariable ["rearming",false];
	if (not("ItemRadio" in unlockedItems) and (!hayTFAR) and (!hayACRE)) then
		{
		while {alive _unit} do
			{
			sleep 10;
			if (("ItemRadio" in assignedItems _unit) and ([player] call hasRadio)) exitWith {_unit groupChat format ["This is %1, radiocheck OK",name _unit]};
			if (unitReady _unit) then
				{
				if ((alive _unit) and (_unit distance (getMarkerPos "respawn_guerrila") > 50) and (_unit distance leader group _unit > 500) and ((vehicle _unit == _unit) or ((typeOf (vehicle _unit)) in arrayCivVeh))) then
					{
					hint format ["%1 lost communication, he will come back with you if possible", name _unit];
					[_unit] join rezagados;
					if ((vehicle _unit isKindOf "StaticWeapon") or (isNull (driver (vehicle _unit)))) then {unassignVehicle _unit; [_unit] orderGetIn false};
					_unit doMove position player;
					_tiempo = time + 900;
					waitUntil {sleep 1;(!alive _unit) or (_unit distance player < 500) or (time > _tiempo)};
					if ((_unit distance player >= 500) and (alive _unit)) then {_unit setPos (getMarkerPos "respawn_guerrila")};
					[_unit] join group player;
					};
				};
			};
		};
	}
else
	{
	if (_unit == leader _unit) then
		{
		_unit setskill ["courage",_skill + 0.2];
		_unit setskill ["commanding",_skill + 0.2];
		};
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		_killer = _this select 1;
		[_muerto] remoteExec ["postmortem",2];
		if ((isPlayer _killer) and (side _killer == buenos)) then
			{
			if (!isMultiPlayer) then
				{
				_nul = [0,20] remoteExec ["resourcesFIA",2];
				_killer addRating 1000;
				};
			}
		else
			{
			if (side _killer == malos) then
				{
				_nul = [0.25,0,getPos _muerto] remoteExec ["citySupportChange",2];
				[-0.25,0] remoteExec ["prestige",2];
				}
			else
				{
				if (side _killer == muyMalos) then {[0,-0.25] remoteExec ["prestige",2]};
				};
			};
		_muerto setVariable ["GREENFORSpawn",nil,true];
		}];
	};


