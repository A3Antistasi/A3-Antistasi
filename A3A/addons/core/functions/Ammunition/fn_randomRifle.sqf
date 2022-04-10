/*
    Equip unit with random weapon of preferred type using A3A_rebelGear
    Adds magazines by mass. Uses default magazine of selected weapon

Parameters:
    0. <OBJECT> Rebel unit to equip with primary weapon.
    1. <STRING> Preferred weapon type ("Rifles", "MachineGuns" etc).
    2. <NUMBER> Optional, total mass of carried magazines to add.

Returns:
    Nothing

Environment:
    Scheduled, any machine
*/

#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_unit", "_weaponType", ["_totalMagWeight", 50]];

call A3A_fnc_fetchRebelGear;        // Send current version of rebelGear from server if we're out of date

private _pool = A3A_rebelGear get _weaponType;
if (_pool isEqualTo []) then {
    _pool = A3A_rebelGear get "Rifles";
    if (_pool isEqualTo []) then {
        _pool = A3A_rebelGear get "SMGs";
        if (_pool isEqualTo []) then {
            _pool = (A3A_rebelGear get "Shotguns") + (A3A_rebelGear get "SniperRifles");
        };
    };
};
private _weapon = selectRandomWeighted _pool;

// Probably shouldn't ever be executed
if !(primaryWeapon _unit isEqualTo "") then {
    if (_weapon == primaryWeapon _unit) exitWith {};
    private _magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
    {_unit removeMagazines _x} forEach _magazines;			// Broken, doesn't remove mags globally. Pain to fix.
    _unit removeWeapon (primaryWeapon _unit);
};

private _categories = _weapon call A3A_fnc_equipmentClassToCategories;

if ("GrenadeLaunchers" in _categories && {"Rifles" in _categories} ) then {
    // lookup real underbarrel GL magazine, because not everything is 40mm
    private _config = configFile >> "CfgWeapons" >> _weapon;
    private _glmuzzle = getArray (_config >> "muzzles") select 1;		// guaranteed by category?
    private _glmag = getArray (_config >> _glmuzzle >> "magazines") select 0;
    _unit addMagazines [_glmag, 5];
};

private _magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
private _magweight = 5 max getNumber (configFile >> "CfgMagazines" >> _magazine >> "mass");

_unit addWeapon _weapon;
_unit addPrimaryWeaponItem _magazine;
_unit addMagazines [_magazine, round (random 0.5 + _totalMagWeight / _magWeight)];


private _compatOptics = A3A_rebelOpticsCache get _weapon;
if (isNil "_compatOptics") then {
    private _compatItems = [_weapon] call BIS_fnc_compatibleItems;		// cached, should be fast
    _compatOptics = _compatItems arrayIntersect call {
        if (_weaponType in ["Rifles", "MachineGuns"]) exitWith { A3A_rebelGear get "OpticsMid" };
        if (_weaponType == "SniperRifles") exitWith { A3A_rebelGear get "OpticsLong" };
        A3A_rebelGear get "OpticsClose";
    };
    if (_compatOptics isEqualTo []) then {
        _compatOptics = _compatItems arrayIntersect call {
            if (_weaponType in ["Rifles", "MachineGuns"]) exitWith { A3A_rebelGear get "OpticsClose" };
            A3A_rebelGear get "OpticsMid";
        };
    };
    A3A_rebelOpticsCache set [_weapon, _compatOptics];
};
if (_compatOptics isNotEqualTo []) then { _unit addPrimaryWeaponItem (selectRandom _compatOptics) };
