private ["_crate","_loot","_num","_magazines","_unlocks"];

_unlocks = (unlockedItems + unlockedOptics + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
_crate = _this select 0;

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

_weaponTypes = 1 + floor random 4;
_itemTypes = 1 + floor random 4;
_ammoTypes = 1 + floor random 4;
_mineTypes = 1 + floor random 4;
_opticTypes = 1 + floor random 4;
_backpackTypes = 1 + floor random 4;

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