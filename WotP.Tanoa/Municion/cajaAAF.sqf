if (!isServer and hasInterface) exitWith {};

private ["_crate","_cosa","_num","_magazines"];

_crate = _this select 0;


clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

if ((typeOf _crate == "I_supplyCrate_F") or (typeOf _crate == "IG_supplyCrate_F")) then
	{
	for "_i" from 0 to (1+ round random 4) do
		{_cosa = if (random 2 < 1) then {selectRandom (armasNATO + antitanqueAAF)} else {selectRandom (armasCSAT + antitanqueAAF)};
		if (not(_cosa in unlockedWeapons)) then
			{
			_num = 1+ (floor random 4);
			_crate addWeaponCargoGlobal [_cosa, _num];
			_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
			_crate addMagazineCargoGlobal [_magazines select 0, _num * 3];
			};
		};

	for "_i" from 0 to (1 + round random 5) do
		{_cosa = itemsAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedItems)) then
			{
			_num = floor random 5;
			_crate addItemCargoGlobal [_cosa, _num];
			};
		};

	for "_i" from 1 to (floor random 3) do
		{_cosa = minasAAF call BIS_Fnc_selectRandom;
		_num = 1 + (floor random 5);
		_crate addMagazineCargoGlobal [_cosa, _num];
		};
	/*
	for "_i" from 1 to (floor random 2) do
		{
		_cosa = antitanqueAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedWeapons)) then
			{
			_num = 1 + (floor random 2);
			_crate addWeaponCargoGlobal [_cosa, _num];
			_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
			_crate addMagazineCargoGlobal [_magazines select 0, _num * 3];
			//{_crate addMagazineCargoGlobal [_x, 1 + (floor random 3)]} forEach MantitanqueAAF;
			};
		};
	*/
	for "_i" from 1 to (floor random 2) do
		{
		_cosa = opticasAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedOptics)) then
			{
			_crate addItemCargoGlobal [_cosa, 1 + (floor random 2)];
			};
		};
	if (hayTFAR) then {_crate addBackpackCargoGlobal ["tf_rt1523g_big_bwmod",1]};
	};
/*
if (typeOf _crate == "I_Truck_02_ammo_F") then
	{
	for "_i" from 0 to (1+ round random 4) do
		{
		_cosa = armasAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedWeapons)) then
			{
			_crate addWeaponCargoGlobal [_cosa, 5];
			_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
			_crate addMagazineCargoGlobal [_magazines select 0, 15];
			};
		};

	for "_i" from 0 to (1 + round random 5) do
		{_cosa = itemsAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedItems)) then {_crate addItemCargoGlobal [_cosa, 5]};
		};

	for "_i" from 0 to (1 + round random 5) do
		{_cosa = municionAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedMagazines)) then {_crate addMagazineCargoGlobal [_cosa, 20]};
		};

	for "_i" from 1 to (floor random 3) do
		{_cosa = minasAAF call BIS_Fnc_selectRandom;
		_crate addMagazineCargoGlobal [_cosa, 10];
		};

	for "_i" from 1 to (floor random 2) do
		{
		_cosa = antitanqueAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedWeapons)) then
			{
			_crate addWeaponCargoGlobal [_cosa, 2];
			_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
			_crate addMagazineCargoGlobal [_magazines select 0, 3];
			//{_crate addMagazineCargoGlobal [_x, 5]} forEach MantitanqueAAF;
			};
		};

	for "_i" from 1 to (floor random 2) do
		{
		_cosa = opticasAAF call BIS_Fnc_selectRandom;
		if (not(_cosa in unlockedOptics)) then {_crate addItemCargoGlobal [_cosa, 3]};
		};
	};


