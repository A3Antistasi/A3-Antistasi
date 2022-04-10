/*
    Generate the rebel gear array for equipping AIs

Parameters:
    No parameters, returns nothing

Environment:
    Server, scheduled or unscheduled
*/

#include "..\..\script_component.hpp"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"     // jna_datalist indices
FIX_LINE_NUMBERS()
if (!isServer) exitWith { Error("Server-only function miscalled") };
Info("Started updating A3A_rebelGear");

// Base weight mappings, MIN->0, MAX->1
#define ITEM_MIN 10
#define ITEM_MAX 50

private _fnc_addItemNoUnlocks = {
    params ["_array", "_class", "_amount"];
    if (_amount < 0) exitWith { _array append [_class, 1] };
    if (_amount <= ITEM_MIN) exitWith {};
    _array pushBack _class;
    _array pushBack linearConversion [ITEM_MIN, ITEM_MAX, _amount, 0, 1, true];
};

private _fnc_addItemUnlocks = {
    params ["_array", "_class", "_amount"];
    if (_amount < 0) exitWith { _array append [_class, 1] };
};

private _fnc_magCount = {
    private _defaultMag = getArray (configFile >> "CfgWeapons" >> _this >> "Magazines") # 0;
    if (isNil "_defaultMag") exitWith { Error_1("Weapon class %1 has no magazines", _this); 0 };
    private _magcount = _magLookup getOrDefault [_defaultMag, 0];
    [_magCount, 1e6] select (_magCount < 0);
};

private _fnc_addItem = [_fnc_addItemUnlocks, _fnc_addItemNoUnlocks] select (minWeaps < 0);

// First make a lookup for magazines
private _magLookup = createHashMapFromArray (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL);

// Work with temporary array so that we're not transferring partials
private _rebelGear = createHashMap;


// Primary weapon filtering
private _rifle = [];
private _smg = [];
private _shotgun = [];
private _sniper = [];
private _mg = [];
private _gl = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    private _bullets = _class call _fnc_magCount;

    call {
        if ("GrenadeLaunchers" in _categories) exitWith { [_gl, _class, _amount min _bullets/150] call _fnc_addItem };       // call before rifles
        if ("Rifles" in _categories) exitWith { [_rifle, _class, _amount/2 min _bullets/150] call _fnc_addItem };
        if ("SniperRifles" in _categories) exitWith { [_sniper, _class, _amount min _bullets/50] call _fnc_addItem };
        if ("MachineGuns" in _categories) exitWith { [_mg, _class, _amount min _bullets/300] call _fnc_addItem };
        if ("SMGs" in _categories) exitWith { [_smg, _class, _amount min _bullets/150] call _fnc_addItem };
        if ("Shotguns" in _categories) exitWith { [_shotgun, _class, _amount min _bullets/50] call _fnc_addItem };
    };
} forEach (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON);

_rebelGear set ["Rifles", _rifle];
_rebelGear set ["SMGs", _smg];
_rebelGear set ["Shotguns", _shotgun];
_rebelGear set ["MachineGuns", _mg];
_rebelGear set ["SniperRifles", _sniper];
_rebelGear set ["GrenadeLaunchers", _gl];

// Secondary weapon filtering
private _rlaunchers = [];
private _mlaunchersAT = [];
private _mlaunchersAA = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    if !("Disposable" in _categories) then {
        private _magcount = _class call _fnc_magCount;
        _amount = _amount min (_magcount/2);
    };

    if ("RocketLaunchers" in _categories) then { [_rlaunchers, _class, _amount] call _fnc_addItem; continue };
    if ("MissileLaunchers" in _categories) then {
        if ("AA" in _categories) exitWith { [_mlaunchersAA, _class, _amount] call _fnc_addItem };
        if ("AT" in _categories) exitWith { [_mlaunchersAT, _class, _amount] call _fnc_addItem };
    };
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON);

_rebelGear set ["RocketLaunchers", _rlaunchers];
_rebelGear set ["MissileLaunchersAT", _mlaunchersAT];
_rebelGear set ["MissileLaunchersAA", _mlaunchersAA];

// Vest filtering
private _avests = ["", [1.5,0.5] select (minWeaps < 0)];     // blank entry to phase in armour use gradually
private _uvests = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    private _array = [_uvests, _avests] select ("ArmoredVests" in _categories);
    [_array, _class, _amount] call _fnc_addItem;
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_VEST);

_rebelGear set ["ArmoredVests", _avests];
_rebelGear set ["CivilianVests", _uvests];

// Helmet filtering
private _aheadgear = ["", [1.5,0.5] select (minWeaps < 0)];     // blank entry to phase in armour use gradually
private _uheadgear = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    private _array = [_uheadgear, _aheadgear] select ("ArmoredHeadgear" in _categories);
    [_array, _class, _amount] call _fnc_addItem;
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR);

_rebelGear set ["ArmoredHeadgear", _aheadgear];
//_rebelGear set ["CosmeticHeadgear", _uheadgear];           // not used, rebels have template-defined basic headgear

// Backpack filtering
private _backpacks = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    if ("BackpacksCargo" in _categories) then { [_backpacks, _class, _amount] call _fnc_addItem };
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_BACKPACK);

_rebelGear set ["BackpacksCargo", _backpacks];

// NVG filtering
private _nvgs = ["", 0.5];          // blank entry for phase-in
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    if !("NVGThermal" in _categories) then { [_nvgs, _class, _amount] call _fnc_addItem };
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_NVGS);

_rebelGear set ["NVGs", _nvgs];

// Unfiltered stuff (just radios atm? could add GPS)
private _radios = [];
{ [_radios, _x#0, _x#1] call _fnc_addItem } forEach (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_RADIO);
_rebelGear set ["Radios", _radios];

// Misc items. Don't really need weighting but whatever
private _minedetectors = [];
private _toolkits = [];
private _medikits = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    call {
        if ("MineDetectors" in _categories) exitWith { [_minedetectors, _class, _amount] call _fnc_addItem };
        if ("Toolkits" in _categories) exitWith { [_toolkits, _class, _amount] call _fnc_addItem };
        if ("Medikits" in _categories) exitWith { [_medikits, _class, _amount] call _fnc_addItem };
    };
} forEach (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC);

_rebelGear set ["MineDetectors", _minedetectors];
_rebelGear set ["Toolkits", _toolkits];
_rebelGear set ["Medikits", _medikits];

// Hand grenades
private _smokes = [];
private _nades = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    call {
        if ("SmokeGrenades" in _categories) exitWith { [_smokes, _class, _amount] call _fnc_addItem };
        if ("Grenades" in _categories) exitWith { [_nades, _class, _amount] call _fnc_addItem };
    };
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW);

_rebelGear set ["SmokeGrenades", _smokes];
_rebelGear set ["Grenades", _nades];

// Explosives. Could add mines but don't want them atm.
private _charges = [];
{
    _x params ["_class", "_amount"];
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    if ("ExplosiveCharges" in _categories) then { [_charges, _class, _amount] call _fnc_addItem };
} forEach (jna_datalist select IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT);

_rebelGear set ["ExplosiveCharges", _charges];

// Optic filtering. No weighting because of weapon compatibilty complexity
private _opticClose = [];
private _opticMid = [];
private _opticLong = [];
{
    _x params ["_class", "_amount"];
    if (_amount > 0 and {minWeaps > 0 or _amount < ITEM_MIN}) then { continue };
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    call {
        if ("OpticsMid" in _categories) exitWith { _opticMid pushBack _class };        // most common first
        if ("OpticsClose" in _categories) exitWith { _opticClose pushBack _class };
        if ("OpticsLong" in _categories) exitWith { _opticLong pushBack _class };
    };
} forEach (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC);

_rebelGear set ["OpticsClose", _opticClose];
_rebelGear set ["OpticsMid", _opticMid];
_rebelGear set ["OpticsLong", _opticLong];
_rebelGear set ["OpticsAll", _opticClose + _opticMid + _opticLong];     // for launchers

// Light attachments, also no weights because of weapon compat
private _lights = [];
{
    _x params ["_class", "_amount"];
    if (_amount > 0 and {minWeaps > 0 or _amount < ITEM_MIN}) then { continue };
    private _categories = _class call A3A_fnc_equipmentClassToCategories;
    if ("LightAttachments" in _categories) then { _lights pushBack _class };
} forEach (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMACC);

_rebelGear set ["LightAttachments", _lights];

// Update everything while unscheduled so that version numbers match
isNil {
    A3A_rebelGearVersion = time;
    _rebelGear set ["Version", A3A_rebelGearVersion];
    A3A_rebelGear = _rebelGear;

    // Clear these two locally
    A3A_rebelOpticsCache = createHashMap;
    A3A_rebelFlashlightsCache = createHashMap;
};
// Only broadcast the version number so that clients & HCs can request as required
publicVariable "A3A_rebelGearVersion";

Info("Finished updating A3A_rebelGear");

/*
// Alternatively just broadcast it
A3A_rebelGear = _rebelGear;
publicVariable "A3A_rebelGear";
*/
