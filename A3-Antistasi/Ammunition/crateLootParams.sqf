//Author: PoweredByPot
//This script uses the given parameters to create public variables that
//Loot crates use to determing range of item types and quantity for each
//category of items that crates spawn.

//weapons
crateWepTypeMin = "crateWeaponTypeMin" call BIS_fnc_getParamValue; publicVariable "crateWepTypeMin";
crateWepTypeMax = "crateWeaponTypeMax" call BIS_fnc_getParamValue; publicVariable "crateWepTypeMax";
crateWepNumMin = "crateWeaponCountMin" call BIS_fnc_getParamValue; publicVariable "crateWepNumMin";
crateWepNumMax = "crateWeaponCountMax" call BIS_fnc_getParamValue; publicVariable "crateWepNumMax";

//items
crateItemTypeMin = "crateItemTypeMin" call BIS_fnc_getParamValue; publicVariable "crateItemTypeMin";
crateItemTypeMax = "crateItemTypeMax" call BIS_fnc_getParamValue; publicVariable "crateItemTypeMax";
crateItemNumMin = "crateItemCountMin" call BIS_fnc_getParamValue; publicVariable "crateItemNumMin";
crateItemNumMax = "crateItemCountMax" call BIS_fnc_getParamValue; publicVariable "crateItemNumMax";

//ammo
crateAmmoTypeMin = "crateAmmoTypeMin" call BIS_fnc_getParamValue; publicVariable "crateAmmoTypeMin";
crateAmmoTypeMax = "crateAmmoTypeMax" call BIS_fnc_getParamValue; publicVariable "crateAmmoTypeMax";
crateAmmoNumMin = "crateAmmoCountMin" call BIS_fnc_getParamValue; publicVariable "crateAmmoNumMin";
crateAmmoNumMax = "crateAmmoCountMax" call BIS_fnc_getParamValue; publicVariable "crateAmmoNumMax";

//mines
crateMineTypeMin = "crateMineTypeMin" call BIS_fnc_getParamValue; publicVariable "crateMineTypeMin";
crateMineTypeMax = "crateMineTypeMax" call BIS_fnc_getParamValue; publicVariable "crateMineTypeMax";
crateMineNumMin = "crateMineCountMin" call BIS_fnc_getParamValue; publicVariable "crateMineNumMin";
crateMineNumMax = "crateMineCountMax" call BIS_fnc_getParamValue; publicVariable "crateMineNumMax";

//optics
crateOpticTypeMin = "crateOpticTypeMin" call BIS_fnc_getParamValue; publicVariable "crateOpticTypeMin";
crateOpticTypeMax = "crateOpticTypeMax" call BIS_fnc_getParamValue; publicVariable "crateOpticTypeMax";
crateOpticNumMin = "crateOpticCountMin" call BIS_fnc_getParamValue; publicVariable "crateOpticNumMin";
crateOpticNumMax = "crateOpticCountMax" call BIS_fnc_getParamValue; publicVariable "crateOpticNumMax";

//backpacks
crateBackpackTypeMin = "crateBackpackTypeMin" call BIS_fnc_getParamValue; publicVariable "crateBackpackTypeMin";
crateBackpackTypeMax = "crateBackpackTypeMax" call BIS_fnc_getParamValue; publicVariable "crateBackpackTypeMax";
crateBackpackNumMin = "crateBackpackCountMin" call BIS_fnc_getParamValue; publicVariable "crateBackpackNumMin";
crateBackpackNumMax = "crateBackpackCountMax" call BIS_fnc_getParamValue; publicVariable "crateBackpackNumMax";
