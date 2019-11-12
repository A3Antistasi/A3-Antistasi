private _unlocks = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
private _crate = _this select 0;
private _available = objNull;
private _amount = objNull;
//Empty the crate
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
//protecting global max parameters
private _crateWepTypeMax = crateWepTypeMax;
private _crateItemTypeMax = crateItemTypeMax;
private _crateAmmoTypeMax = crateAmmoTypeMax;
private _crateExplosiveTypeMax = crateExplosiveTypeMax;
private _crateAttachmentTypeMax = crateAttachmentTypeMax;
private _crateBackpackTypeMax = crateBackpackTypeMax;
private _crateHelmetTypeMax = crateHelmetTypeMax;
private _crateVestTypeMax = crateVestTypeMax;
private _crateDeviceTypeMax = crateDeviceTypeMax;
//Double max types if the crate is an ammo truck
if (typeOf _crate == vehNATOAmmoTruck) then {
	if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Ammo Truck Detected: Doubling Types",servertime,_backpackTypes]};
	_crateWepTypeMax = _crateWepTypeMax * 2;
	_crateItemTypeMax = _crateItemTypeMax * 2;
	_crateAmmoTypeMax = _crateAmmoTypeMax * 2;
	_crateExplosiveTypeMax = _crateExplosiveTypeMax * 2;
	_crateAttachmentTypeMax = _crateAttachmentTypeMax * 2;
	_crateBackpackTypeMax = _crateBackpackTypeMax * 2;
	_crateHelmetTypeMax = _crateHelmetTypeMax * 2;
	_crateVestTypeMax = _crateVestTypeMax * 2;
	_crateDeviceTypeMax = _crateDeviceTypeMax * 2;
};

private _weaponlootWeighting = [
	allRifles, 3,
	allHandguns, 1.2,
	allMachineGuns, 2,
	allShotguns, 0,
	allSMGs, 2,
	allSniperRifles, 0.9,
	allMissileLaunchers, 0.5,
	allRocketLaunchers, 0.5
];

//This overrides the shotgun setting.
if (hasRHS) then {
	_weaponlootWeighting set [8, 1.8];
};

// Little function to ensure the item isn't already unlocked.
private _fnc_pickRandomFromANotInB = {
	params ["_arrayA", "_arrayB"];
	private _choice = selectRandom _arrayA;
	[3, format ["Function check for: %1", _choice],"fn_NATOCrate"] call A3A_fnc_log;
	private _foundValid = true;
	if (_choice in _arrayB) then {
		_foundValid = false;
		[3, format ["Item already unlocked, rolling again."],"fn_NATOCrate"] call A3A_fnc_log;
		for "_i" from 0 to 9 do {
			_choice = selectRandom _arrayA;
			//We did it!
			if !(_choice in _arrayB) exitWith {
				_foundValid = true;
			};
		}
	};

	if (_foundValid) then {
		_choice;
	};
};

//Weapons Loot
[3, "Generating Weapons", "fn_NATOCrate"] call A3A_fnc_log;
for "_i" from 0 to floor random _crateWepTypeMax do {
	private _selection = selectRandomWeighted _weaponlootWeighting;
	[3, format ["Selected: %1", _selection],"fn_NATOCrate"] call A3A_fnc_log;
	private _loot =	 [_selection, unlockedWeapons] call _fnc_pickRandomFromANotInB;;
	[3, format ["%1 weapons chosen", _i],"fn_NATOCrate"] call A3A_fnc_log;
	[3, format ["Final weapon: %1", _loot],"fn_NATOCrate"] call A3A_fnc_log;

	if (isNil "_loot") then {
		[3, "No Weapons Left in Loot List Or Pick Random Failed","fn_NATOCrate"] call A3A_fnc_log;
	}
	else {
		_amount = floor random crateWepNumMax;
		_crate addWeaponWithAttachmentsCargoGlobal [[ _loot, "", "", "", [], [], ""], _amount];
		for "_i" from 0 to _amount do {
			_magazines = getArray (configFile / "CfgWeapons" / _loot / "magazines");
			[3, format ["Grabbing a %1 for %2", _magazines, _loot],"fn_NATOCrate"] call A3A_fnc_log;
			_magAmount = selectRandom [0,1,2];
			[3, format ["Spawning %1 magazines for %2", _magAmount, _loot],"fn_NATOCrate"] call A3A_fnc_log;
			_crate addMagazineCargoGlobal [selectrandom _magazines, _magAmount];
			[3, format ["Spawning %1 of %2", _amount, _loot],"fn_NATOCrate"] call A3A_fnc_log;
		};
	};
};

//Items Loot
[3, "Generating Items", "fn_NATOCrate"] call A3A_fnc_log;
for "_i" from 0 to floor random _crateItemTypeMax do {
	_available = (lootItem - _unlocks - itemCargo _crate);
	[3, format ["Breakdown: %1, %2, %3", lootItem, _unlocks, itemCargo _crate],"fn_NATOCrate"] call A3A_fnc_log;
	[3, format ["Items available: %1", _available],"fn_NATOCrate"] call A3A_fnc_log;
	_loot = selectRandom _available;
	[3, format ["Item chosen: %1", _loot],"fn_NATOCrate"] call A3A_fnc_log;
	if (isNil "_loot") then {
		[3, "No Items Left in Loot List","fn_NATOCrate"] call A3A_fnc_log;
	}
	else {
		_amount = floor random crateItemNumMax;
		_crate addItemCargoGlobal [_loot,_amount];
		[3, format ["Spawning %2 of %3", _amount,_loot],"fn_NATOCrate"] call A3A_fnc_log;
	};
};
//Ammo Loot
for "_i" from 0 to floor random _crateAmmoTypeMax do {
	_available = (lootMagazine - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Ammo Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateAmmoNumMax;
		_crate addMagazineCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Explosives Loot
for "_i" from 0 to floor random _crateExplosiveTypeMax do {
	_available = (lootExplosive - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Explosives Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateExplosiveNumMax;
		_crate addMagazineCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Attachments Loot
for "_i" from 0 to floor random _crateAttachmentTypeMax do {
	_available = (lootAttachment - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Attachment Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateAttachmentNumMax;
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Backpacks Loot
for "_i" from 0 to floor random _crateBackpackTypeMax do {
	_available = (lootBackpack - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Backpacks Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateBackpackNumMax;
		_crate addBackpackCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Helmets Loot
for "_i" from 0 to floor random _crateHelmetTypeMax do {
	_available = (lootHelmet - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Helmets Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateHelmetNumMax;
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Vests Loot
for "_i" from 0 to floor random _crateVestTypeMax do {
	_available = (lootVest - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Vests Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateVestNumMax;
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
//Device Loot
for "_i" from 0 to floor random _crateDeviceTypeMax do {
	_available = (lootDevice - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Device Bags Left in Loot List",servertime]};
	}
	else {
		_amount = floor random crateDeviceNumMax;
		_crate addBackpackCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
