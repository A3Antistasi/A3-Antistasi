private ["_loot","_guns","_ammo","_items","_avail","_num","_optics","_packs","_mines","_unlocks"];

private _unlocks = (unlockedItems + unlockedOptics + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
private _crate = _this select 0;

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

private _weaponTypes = crateWepTypeMin + floor (random crateWepTypeMax);
private _itemTypes = crateItemTypeMin + floor (random crateItemTypeMax);
private _ammoTypes = crateAmmoTypeMin + floor (random crateAmmoTypeMax);
private _mineTypes = crateMineTypeMin + floor (random crateMineTypeMax);
private _opticTypes = crateOpticTypeMin + floor (random crateOpticTypeMax);
private _backpackTypes = crateBackpackTypeMin + floor (random crateBackpackTypeMax);

if (typeOf _crate == vehNATOAmmoTruck) then
	{
	_weaponTypes=_weaponTypes*2;
	_itemTypes=_itemTypes*2;
	_ammoTypes=_ammoTypes*2;
	_mineTypes=_mineTypes*2;
	_opticTypes=_opticTypes*2;
	_backpackTypes=_backpackTypes*2;
	};

for "_i" from 0 to _weaponTypes do
	{
	_guns = (weaponsNato + antitankAAF);
	_avail = (_guns - _unlocks - itemCargo _crate);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else
		{
		_num = crateWepNumMin + floor random crateWepNumMax;
		_crate addWeaponWithAttachmentsCargoGlobal [[_loot, "", "", "", [], [], ""],_num];
		};
	};

for "_i" from 0 to _itemTypes do
	{
	_items = itemsAAF;
	_avail = (_items - _unlocks - itemCargo _crate);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else
		{
		_num = crateItemNumMin + floor random crateItemNumMax;
		_crate addItemCargoGlobal [_loot,_num];
		};
	};

for "_i" from 0 to _ammoTypes do
	{
	_ammo = smokeX + chemX + ammunitionNATO;
	_avail = (_ammo - _unlocks - itemCargo _crate);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else
		{
		_num = crateAmmoNumMin + floor random crateAmmoNumMax;
		_crate addMagazineCargoGlobal [_loot,_num];
		};
	};

for "_i" from 0 to _mineTypes do
	{
	_mines = minesAAF;
	_avail = (_mines - _unlocks - itemCargo _crate);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else
		{
		_num = crateMineNumMin + floor random crateMineNumMax;
		_crate addMagazineCargoGlobal [_loot,_num];
		};
	};

if !(hasIFA) then
	{
	for "_i" from 0 to _opticTypes do
		{
		_optics = opticsAAF;
		_avail = (_optics - _unlocks - itemCargo _crate);
		_loot = selectRandom _avail;
		if (isNil "_loot") then {} else
			{
			_num = crateOpticsNumMin + floor random crateOpticsNumMax;
			_crate addItemCargoGlobal [_loot,_num];
			};
		};

	for "_i" from 0 to _backpackTypes do
		{
		_packs = backpacksNATO;
		_avail = (_packs - _unlocks - itemCargo _crate);
		_loot = selectRandom _avail;
		if (isNil "_loot") then {} else
			{
			_num = crateBackpackNumMin + floor random crateBackpackNumMax;
			_crate addItemCargoGlobal [_loot,_num];
			};
		};
	if (round random 100 < 25) then
		{
		_crate addBackpackCargoGlobal ["B_Static_Designator_01_weapon_F",1];
		}
	else
		{
		if (round random 100 < 25) then
			{
			if (side group petros == independent) then
				{
				if !("O_Static_Designator_02_weapon_F" in _unlocks) then
				{_crate addBackpackCargoGlobal ["I_UAV_01_backpack_F",1]};
				if !("O_Static_Designator_02_weapon_F" in _unlocks) then
				{_crate addItemCargoGlobal ["I_UavTerminal",1]};
				}
			else
				{
				if !("O_Static_Designator_02_weapon_F" in _unlocks) then
				{_crate addBackpackCargoGlobal ["B_UAV_01_backpack_F",1]};
				if !("O_Static_Designator_02_weapon_F" in _unlocks) then
				{_crate addItemCargoGlobal ["B_UavTerminal",1]};
				};
			};
		};
	if (hasACE) then
		{
			if !("ACE_HuntIR_M203" in _unlocks) then
		{_crate addMagazineCargoGlobal ["ACE_HuntIR_M203", 3]};
			if !("ACE_HuntIR_monitor" in _unlocks) then
		{_crate addItemCargoGlobal ["ACE_HuntIR_monitor", 1]};
		};
	};