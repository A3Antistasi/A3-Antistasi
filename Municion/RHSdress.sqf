_unit = _this select 0;

//_tipo = typeOf _unit;
//_emptyUniform = false;
removeVest _unit;
_unit addVest "rhs_6sh46";
_rifleFinal = unlockedRifles call BIS_fnc_selectRandom;
if (_rifleFinal != primaryWeapon _unit) then
	{
	_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
	{_unit removeMagazines _x} forEach _magazines;
	_unit removeWeaponGlobal (primaryWeapon _unit);
	[_unit, _rifleFinal, 6, 0] call BIS_fnc_addWeapon;
	};

/*
if ((_tipo == SDKRifleman) or (_tipo == "B_G_Soldier_GL_F") or (_tipo == "B_G_Soldier_LAT_F") or (_tipo == "B_G_Soldier_lite_F") or (_tipo == "B_G_medic_F") or (_tipo == "B_G_engineer_F") or (_tipo == "B_G_Soldier_exp_F") or (_tipo == "B_G_Soldier_A_F")) then
	{
	if (_tipo == "B_G_Soldier_LAT_F") then
		{
		for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
					{
					_unit removeMagazine "RPG32_F";
					};
				_unit removeMagazine "RPG32_HE_F";
				_unit removeWeaponGlobal "launch_RPG32_F";
				[_unit, "rhs_weap_rpg7", 4, 0] call BIS_fnc_addWeapon;
		};
	if (not(_tipo == "B_G_Soldier_GL_F")) then
		{
		for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do
			{
			_unit removeMagazine "30Rnd_556x45_Stanag";
			};
		_unit removeWeaponGlobal (primaryWeapon _unit);
		[_unit, unlockedRifles call BIS_fnc_selectRandom, 5, 0] call BIS_fnc_addWeapon;
		}
	else
		{
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_762x39mm"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_akms_gp25";
			_emptyUniform = true;
			};
		};
	};

if ((_tipo == SDKSL) or (_tipo == "B_G_Soldier_TL_F") or (_tipo == "B_G_officer_F")) then
	{
	removeAllItemsWithMagazines _unit;
	for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_AK"; _unit addItemToVest "rhs_VOG25";};
	_unit addWeapon "rhs_weap_ak74m_gp25";
	_unit addPrimaryWeaponItem "rhs_acc_1p29";
	_unit addItemToVest "SmokeShell";
	_unit addItemToVest "SmokeShell";
	_emptyUniform = true;
	};

if (_tipo == "B_G_Soldier_AR_F") then
	{
	removeAllItemsWithMagazines _unit;
	_unit removeWeaponGlobal (primaryWeapon _unit);
	_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
	_unit addWeaponGlobal "rhs_weap_pkm";
	_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
	_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
	_emptyUniform = true;
	};

if (_tipo == "B_G_Soldier_M_F") then
	{
	for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do
		{
		_unit removeMagazine "30Rnd_556x45_Stanag";
		};
	_unit removeWeaponGlobal (primaryWeapon _unit);
	[_unit, "rhs_weap_svdp_wd", 8, 0] call BIS_fnc_addWeapon;
	_unit addPrimaryWeaponItem "rhs_acc_pso1m2";
	};

if (_emptyUniform) then
	{
	_unit addItemToUniform "FirstAidKit";
	_unit addMagazine ["HandGrenade", 1];
	_unit addMagazine ["SmokeShell", 1];
	};
*/
_unit selectWeapon (primaryWeapon _unit);
