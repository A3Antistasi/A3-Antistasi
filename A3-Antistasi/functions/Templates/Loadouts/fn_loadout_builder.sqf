/*
    File: fn_loadout_build.sqf
    Author: Spoffy
    Date: 2020-11-27
    Last Update: 2020-11-27
    Public: No
    
    Description:
        No description added yet.
    
    Parameter(s):
        _template - Template to build [CODE]
		_data - Loadout data to insert [NAMESPACE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_template", "_loadoutDataForTemplate"];

private _finalLoadout = [] call A3A_fnc_loadout_createBase;

/////////////////////////////////////////////////////////////////
//  Core Loadout functions - used to add items to the loadout  //
/////////////////////////////////////////////////////////////////

//Adds a helmet to the loadout, selected at random from the category in loadout data.
private _fnc_setHelmet = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _helmet = selectRandom _data;
	[_finalLoadout, _helmet] call A3A_fnc_loadout_setHelmet;
};

//Adds a vest to the loadout, selected at random from the category in loadout data.
private _fnc_setVest = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _vest = selectRandom _data;
	[_finalLoadout, _vest] call A3A_fnc_loadout_setVest
};

//Adds a uniform to the loadout, selected at random from the category in loadout data.
private _fnc_setUniform = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _uniform = selectRandom _data;
	[_finalLoadout, _uniform] call A3A_fnc_loadout_setUniform
};

//Adds a backpack to the loadout, selected at random from the category in loadout data.
private _fnc_setBackpack = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _backpack = selectRandom _data;
	[_finalLoadout, _backpack] call A3A_fnc_loadout_setBackpack
};

//Adds a primary weapon to the loadout, selected at random from the category in loadout data.
private _fnc_setPrimary = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _weapon = selectRandom _data;
	[_finalLoadout, "PRIMARY", _weapon] call A3A_fnc_loadout_setWeapon;
};

//Adds a launcher to the loadout, selected at random from the category in loadout data.
private _fnc_setLauncher = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _weapon = selectRandom _data;
	[_finalLoadout, "LAUNCHER", _weapon] call A3A_fnc_loadout_setWeapon;
};

//Adds a handgun to the loadout, selected at random from the category in loadout data.
private _fnc_setHandgun = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _weapon = selectRandom _data;
	[_finalLoadout, "HANDGUN", _weapon] call A3A_fnc_loadout_setWeapon;
};

//We resolve the magazine requests later, in case the loadout templates have weapons added after magazines.
private _magazinesToAdd = [];
//Adds magazines to the loadout for the weapon in the specified slot.
private _fnc_addMagazines = {
	params ["_weaponSlot", "_quantity"];
	_magazinesToAdd pushBack [_weaponSlot, _quantity];
};

//We resolve the magazine requests later, in case the loadout templates have weapons added after magazines.
private _additionalMuzzleMagazinesToAdd = [];
//Adds magazines to the loadout for the alternate firemode/muzzles of the weapon in given slot (E.g Underslung grenades)
private _fnc_addAdditionalMuzzleMagazines = {
	params ["_weaponSlot", "_quantity", ["_filter", { true }]];
	_additionalMuzzleMagazinesToAdd pushBack [_weaponSlot, _quantity, _filter];
};

//We resolve these along with the rest of the items later, so we do it all in one call.
//Much more efficient to insert them all at once.
private _itemSets = [];
//Adds all of the items in the array available in the given category of loadout data.
//Items in that set can either be classes "myItem" or an array in unit loadout format ["myItem", 5] (adds 5 myItems)
private _fnc_addItemSet = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	_itemSets pushBack _data;
};

//Adds a random item from the given category of loadout data.
//Item can be a string class "myItem" or an array in unit loadout format ["myItem", 5]
private _fnc_addItem = {
	params ["_key", ["_amount", 1]];
	private _data = _loadoutDataForTemplate getVariable [_key, []];

	if (_data isEqualTo []) exitWith {};

	private _item =	selectRandom _data;
	if (_item isEqualType []) then {
		_item set [1, _amount];
		_itemSets pushBack [_item];
	} else {
		private _items = [];
		for "_i" from 1 to _amount do {
			_items pushBack _item;
		};
		_itemSets pushBack _items;
	};
};

private _equipment = [];
//Adds a map to the unit, select at random from the given category of loadout data.
private _fnc_addMap = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _map = selectRandom _data;
	_equipment pushBack ["MAP", _map];
};

//Adds a watch to the unit, select at random from the given category of loadout data.
private _fnc_addWatch = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _watch = selectRandom _data;
	_equipment pushBack ["WATCH", _watch];
};

//Adds a compass to the unit, select at random from the given category of loadout data.
private _fnc_addCompass = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _compass = selectRandom _data;
	_equipment pushBack ["COMPASS", _compass];
};

//Adds a radio to the unit, select at random from the given category of loadout data.
private _fnc_addRadio = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _radio = selectRandom _data;
	_equipment pushBack ["RADIO", _radio];
};

//Adds a gps to the unit, select at random from the given category of loadout data.
private _fnc_addGPS = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _gps = selectRandom _data;
	_equipment pushBack ["GPS", _gps];
};

//Adds a gps to the unit, select at random from the given category of loadout data.
private _fnc_addBinoculars = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _binoculars = selectRandom _data;
	_equipment pushBack ["BINOCULARS", _binoculars];
};

//Adds a NVGs to the unit, select at random from the given category of loadout data.
private _fnc_addNVGs = {
	params ["_key"];
	private _data = _loadoutDataForTemplate getVariable [_key, []];
	if (_data isEqualTo []) exitWith {};
	private _nvgs = selectRandom _data;
	_equipment pushBack ["NVG", _nvgs];
};

////////////////////////////////////////////////////////
//  Utility functions to help when building loadouts  //
////////////////////////////////////////////////////////

//Picks the first non-empty array.
private _fnc_fallBack = {
	private _firstValidIndex = _this findIf {!(_loadoutDataForTemplate getVariable [_x, []] isEqualTo [])};
	if (_firstValidIndex < 0) exitWith {_this select 0};
	_this select _firstValidIndex
};

/////////////////////////////
//  Building the loadouts  //
/////////////////////////////

//Call the template, which uses the above functions to build the loadout.

call _template;

//Now the loadout has been populated with most gear except items.
//To finish up, we need to add all the items at once (for efficiency reasons), and also equipment.

[_finalLoadout, _equipment] call A3A_fnc_loadout_addEquipment;

//Now we need to add all the items.
//Firstly - we need to resolve all the magazines we need, and add them to an item batch.
private _magazineItems = [];

//Go through all of the requests for magazines, figure out what mag to use, then add it to item list.
{
	_x params ["_weaponSlot", "_quantity"];
	private _weaponIndex = [0,1,2] select (["primary", "launcher", "handgun"] find (toLower _weaponSlot));
	private _weaponData = _finalLoadout select _weaponIndex;
	if !(_weaponData isEqualTo []) then {
		private _weaponClass = _weaponData select 0;
		private _magInfo = [_weaponClass] call A3A_fnc_loadout_defaultWeaponMag;
		if !(_magInfo isEqualTo []) then {
			_magazineItems pushBack [_magInfo select 0, _quantity, _magInfo select 1];
		};
	};
} forEach _magazinesToAdd;

{
	_x params ["_weaponSlot", "_quantity", "_filter"];
	diag_log format ["Adding: %1", _x];
	private _weaponIndex = [0,1,2] select (["primary", "launcher", "handgun"] find (toLower _weaponSlot));
	private _weaponData = _finalLoadout select _weaponIndex;
	if !(_weaponData isEqualTo []) then {
		private _weaponClass = _weaponData select 0;
		private _validMagsPerMuzzle = 
			[_weaponClass] call A3A_fnc_loadout_additionalMuzzleMags 
			apply {_x select {(_x # 0) call _filter}} 
			select {!(_x isEqualTo [])};
		diag_log format ["Valid: %1", _validMagsPerMuzzle];
		if !(_validMagsPerMuzzle isEqualTo []) then {
			//Default to first - hack to make sure most units start with HE.
			private _magInfo = _validMagsPerMuzzle select 0 select 0;
			while {_quantity > 0} do {
				private _specificAmount = ceil (_quantity / 2);
				_quantity = _quantity - _specificAmount;
				_magazineItems pushBack [_magInfo select 0, _specificAmount, _magInfo select 1];
				_magInfo = selectRandom selectRandom _validMagsPerMuzzle;
			};
		};
	};
} forEach _additionalMuzzleMagazinesToAdd;

//Now magazines are resolved, we can add all the items.
//Item batches are added in order, with least important last.
//We know magazines are most important - so add them first.
//Afterwards, we add things in the order defined in the loadout - ie, the order they were added to itemSets
private _itemBatches = [_magazineItems] + _itemSets;

[_finalLoadout, _itemBatches] call A3A_fnc_loadout_addItems;

_finalLoadout