#include "..\..\Includes\common.inc"
////////////////////////////////////
//      Backpacks Sorting        ///
////////////////////////////////////
{
	private _itemFaction = getText (configfile >> "CfgVehicles" >> _x >> "faction");
	switch (_itemFaction) do {
		case "Default": {allBackpacksEmpty pushBack _x};
		default {allBackpacksTool pushBack _x};
	};
} forEach allBackpacks;

allBackpacksEmpty deleteAt (allBackpacksEmpty find "B_AssaultPack_Kerry");

{
	switch (true) do {
		case ((getText (configfile >> "CfgVehicles" >> _x >> "assembleInfo" >> "assembleTo")) != ""): {
			if !((getArray (configfile >> "CfgVehicles" >> _x >> "assembleInfo" >> "base")) isEqualTo []) then {
				allBackpacksStatic pushBack _x;
			}
			else {
				allBackpacksDevice pushback _x;
			};
		};
		case ((getText (configfile >> "CfgVehicles" >> _x >> "assembleInfo" >> "assembleTo")) == ""): {
			if ((getText (configfile >> "CfgVehicles" >> _x >> "assembleInfo" >> "base")) == "") then {
				allBackpacksStatic pushBack _x;
			};
		};
	};
} forEach allBackpacksTool;

{
	private _faction = getText (configfile >> "CfgVehicles" >> _x >> "faction");
	private _side = getNumber (configfile >> "CfgFactionClasses" >> _faction >> "side");
	switch (_side) do {
		case 0: {invaderBackpackDevice pushBack _x};
		case 1: {occupantBackpackDevice pushBack _x};
		case 2: {rebelBackpackDevice pushBack _x};
		case 3: {civilianBackpackDevice pushBack _x};
	};
} forEach allBackpacksDevice;

////////////////////////////////////
//   ARMORED VESTS LIST          ///
////////////////////////////////////
//WHY is there no clean list?
//allArmoredVests = allVests select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor") > 5};
allCivilianVests = allVests - allArmoredVests;

allCivilianVests deleteAt (allCivilianVests find "V_RebreatherB");
allCivilianVests deleteAt (allCivilianVests find "V_RebreatherIR");
allCivilianVests deleteAt (allCivilianVests find "V_RebreatherIA");

////////////////////////////////////
//   ARMORED HELMETS LIST        ///
////////////////////////////////////
//WHY is there no clean list?
//allArmoredHeadgear = allHeadgear select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") > 0};
allCivilianHeadgear = allHeadgear - allArmoredHeadgear;

//////////////////
//   Glasses   ///
//////////////////
allCivilianGlasses append allGlasses;

allCivilianGlasses deleteAt (allCivilianGlasses find "None");
allCivilianGlasses deleteAt (allCivilianGlasses find "G_Goggles_VR");
allCivilianGlasses deleteAt (allCivilianGlasses find "G_I_Diving");
allCivilianGlasses deleteAt (allCivilianGlasses find "G_O_Diving");
allCivilianGlasses deleteAt (allCivilianGlasses find "G_B_Diving");
allCivilianGlasses deleteAt (allCivilianGlasses find "LIB_Glasses");

////////////////
//   Radios   //
////////////////
If (A3A_hasTFAR || A3A_hasTFARBeta) then {
private _encryptRebel = if (A3A_hasVN) then { ["tf_west_radio_code", "tf_east_radio_code"] } else { ["tf_guer_radio_code", "tf_independent_radio_code"] };
allRadios = allRadios select {
    private _encrypt = getText (configFile >> "CfgWeapons" >> _x >> "tf_encryptionCode");
    (_encrypt in _encryptRebel);
};

private _encrypthostile = if (A3A_hasVN) then { ["tf_guer_radio_code", "tf_independent_radio_code"] } else { ["tf_west_radio_code", "tf_east_radio_code"] };
private _allHostileRadio = [];
{
    private _encrypt = getText (configFile >> "CfgVehicles" >> _x >> "tf_encryptionCode");
  	if (_encrypt in _encryptRebel) then {allBackpacksRadio pushBack _x};
    if (_encrypt in _encrypthostile) then {_allHostileRadio pushBack _x};
} forEach allBackpacksEmpty;

//Removes Radios from allBackpacksEmpty
allBackpacksEmpty = allBackpacksEmpty - _allHostileRadio - allBackpacksRadio;
};
/////////////////
// UAVTerminal //
/////////////////
private _encryptRebel = if (teamPlayer == west) then { 1 } else { 2 };
allUAVTerminals = allUAVTerminals select {
    private _encrypt = getNumber  (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "side");
    (_encrypt isEqualTo "") or (_encrypt isEqualTo _encryptRebel);
};

//Remove Prop Food
allMagBullet = allMagBullet select { getText (configFile >> "CfgMagazines" >> _x >> "ammo") isNotEqualTo "FakeAmmo"; };

private _removableDefaultItems = [
	[allFirstAidKits,"FirstAidKit","firstAidKits"],
	[allMedikits,"Medikit","mediKits"],
	[allToolkits,"ToolKit","toolKits"],
	[allMaps,"ItemMap","itemMaps"]
];
{
	_x params ["_itemCategoryArray","_vanillaItem","_templateVariable"];
	if (count (A3A_Reb_factionData getVariable [_templateVariable,[]]) != 0) then {
		_itemCategoryArray deleteAt (_itemCategoryArray find _vanillaItem);
	};
} forEach _removableDefaultItems;
