private ["_crate","_loot","_num","_magazines","_unlocks","_weaponTypesMin","_itemTypesMin","_ammoTypesMin","_mineTypesMin","_opticTypesMin","_backpackTypesMin","_weaponTypesMax","_itemTypesMax","_ammoTypesMax","_mineTypesMax","_opticTypesMax","_backpackTypesMax","_weaponCountMin","_itemCountMin","_ammoCountMin","_mineCountMin","_opticCountMin","_backpackCountMin","_weaponCountMax","_itemCountMax","_ammoCountMax","_mineCountMax","_opticCountMax","_backpackCountMax"];

_unlocks = (unlockedItems + unlockedOptics + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
_crate = _this select 0;

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

_weaponTypesMin = 1;
_itemTypesMin = 1;
_ammoTypesMin = 1;
_mineTypesMin = 1;
_opticTypesMin = 1;
_backpackTypesMin = 1;

_weaponTypesMax = floor random 4;
_itemTypesMax = floor random 4;
_ammoTypesMax = floor random 4;
_mineTypesMax = floor random 4;
_opticTypesMax = floor random 4;
_backpackTypesMax = floor random 4;

_weaponCountMin = 1;
_itemCountMin = 1;
_ammoCountMin = 1;
_mineCountMin = 1;
_opticCountMin = 1;
_backpackCountMin = 1;

_weaponCountMax = 1;
_itemCountMax = 1;
_ammoCountMax = 1;
_mineCountMax = 1;
_opticCountMax = 1;
_backpackCountMax = 1;

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
	_avail = (_guns - _unlocks);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else {
	_num = 1 + (floor random 9);
	if (!(_loot in weaponCargo _crate)) then
		{
		_crate addWeaponWithAttachmentsCargoGlobal [[_loot, "", "", "", [], [], ""], _num];
		};
		};
	};

for "_i" from 0 to _itemTypes do
	{
	_items = itemsAAF;
	_avail = (_items - _unlocks);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else {
	_num = 1 + (floor random 4);
	if (!(_loot in itemCargo _crate)) then
		{
		_crate addItemCargoGlobal [_loot, _num];
		};
		};
	};

for "_i" from 0 to _ammoTypes do
	{
	_ammo = smokeX + chemX + ammunitionNATO;
	_avail = (_ammo - _unlocks);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else {
	if (!(_loot in magazineCargo _crate)) then
		{
		_crate addMagazineCargoGlobal [_loot, 10];
		};
		};
	};

for "_i" from 0 to _mineTypes do
	{
	_mines = minesAAF;
	_avail = (_mines - _unlocks);
	_loot = selectRandom _avail;
	if (isNil "_loot") then {} else {
	_num = 1 + (floor random 4);
	if (!(_loot in itemCargo _crate)) then
		{
			_crate addMagazineCargoGlobal [_loot, _num];
		};
		};
	};

if !(hasIFA) then
	{
	for "_i" from 0 to _opticTypes do
		{
		_optics = opticsAAF;
		_avail = (_optics - _unlocks);
		_loot = selectRandom _avail;
		if (isNil "_loot") then {} else {
		_num = 1 + (floor random 4);
		if (!(_loot in itemCargo _crate)) then
			{
			_crate addItemCargoGlobal [_loot, _num];
			};
			};
		};

	for "_i" from 0 to _backpackTypes do
		{
		_items = backpacksNATO;
		_avail = (_items - _unlocks);
		_loot = selectRandom _avail;
		if (isNil "_loot") then {} else {
		if (!(_loot in itemCargo _crate)) then
			{
			_crate addItemCargoGlobal [_loot, _num];
			};
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