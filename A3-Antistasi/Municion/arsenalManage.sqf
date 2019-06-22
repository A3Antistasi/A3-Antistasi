if (!isServer) exitWith {};
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

/*

(jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_UNIFORM)

    IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC\
*/
["buttonInvToJNA"] call jn_fnc_arsenal;
private _armas = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_HANDGUN) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW) + /*(jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT) + */(jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON)) select {_x select 1 != -1};
//_magazines = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL)) select {_x select 1 == -1};
private _mochis = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_BACKPACK) select {_x select 1 != -1};
private _items = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_VEST) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_GOGGLES) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_MAP) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_GPS) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_RADIO) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_COMPASS) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_WATCH) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMACC) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS)) select {_x select 1 != -1};
private _optics = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC) select {_x select 1 != -1};
private _nv = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_NVGS) select {_x select 1 != -1};

private _updated = "";
private _check = false;
{
    if (_x select 1 >= minWeaps) then {
        private _arma = _x select 0;
        if !(_arma in mlaunchers) then {
            // Unlock all mags, could unlock based on numbers instead?
            private _mags = getArray (configFile / "CfgWeapons" / _arma / "magazines");
            {
                private _magazine = _x;
                if (not(_magazine in unlockedMagazines)) then {
                    unlockedMagazines pushBack _magazine;
                    _updated = format ["%1%2<br/>", _updated, getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
                    private _index = _magazine call jn_fnc_arsenal_itemType;
                    [_index,_magazine,-1] call jn_fnc_arsenal_addItem;
                };
            } forEach _mags;

            unlockedWeapons pushBack _arma;

            if (_arma in arifles) then {
                unlockedRifles pushBack _arma; publicVariable "unlockedRifles";
                if (count (getArray (configfile >> "CfgWeapons" >> _arma >> "muzzles")) == 2) then {
                    unlockedGL pushBack _arma; publicVariable "unlockedGL";
                };
            } else {
                if (_arma in mguns) then {
                    unlockedMG pushBack _arma; publicVariable "unlockedMG";
                } else {
                    if (_arma in srifles) then {
                        unlockedSN pushBack _arma; publicVariable "unlockedSN";
                    } else { 
                        if (_arma in ((rlaunchers + mlaunchers) select {(getNumber (configfile >> "CfgWeapons" >> _x >> "lockAcquire") == 0)})) then {
                            unlockedAT pushBack _arma; publicVariable "unlockedAT";
                        } else {
                            if (_arma in (mlaunchers select {(getNumber (configfile >> "CfgWeapons" >> _x >> "lockAcquire") == 1)})) then {
                                unlockedAA pushBack _arma; publicVariable "unlockedAA";
                            };
                        };
                    };
                };
            };
            _updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _arma >> "displayName")];
            private _index = _arma call jn_fnc_arsenal_itemType;
            [_index,_arma,-1] call jn_fnc_arsenal_addItem;
        };
    };
} forEach _armas;

if (_check) then {
     publicVariable "unlockedWeapons";
     publicVariable "unlockedMagazines";
    _check = false;
};

{
    if (_x select 1 >= minWeaps) then {
        private _mochi = _x select 0;
        private _index = _mochi  call jn_fnc_arsenal_itemType;
        [_index,_mochi,-1] call jn_fnc_arsenal_addItem;
        _updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgVehicles" >> _mochi >> "displayName")];
        unlockedBackpacks pushBack _mochi;
        publicVariable "unlockedBackpacks";
    };
} forEach _mochis;

{
    if (_x select 1 >= minWeaps) then {
        private _item = _x select 0;
        unlockedItems pushBack _item;
        _updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
        _check = true;
        private _index = _item call jn_fnc_arsenal_itemType;
        [_index,_item,-1] call jn_fnc_arsenal_addItem;
    };
} forEach _items;

if (_check) then {
    publicVariable "unlockedItems";
    if (!haveRadio and "ItemRadio" in unlockedItems) then {
        haveRadio = true; publicVariable "haveRadio";
    };
    _check = false;
};

{
    if (_x select 1 >= minWeaps) then {
        private _item = _x select 0;
        unlockedOptics pushBack _item;
        unlockedOptics = [unlockedOptics,[],{getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass")},"DESCEND"] call BIS_fnc_sortBy;
        unlockedItems pushBack _item;
        _updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
        _check = true;
        private _index = _item call jn_fnc_arsenal_itemType;
        [_index,_item,-1] call jn_fnc_arsenal_addItem;
    };
} forEach _optics;

if (_check) then {
     publicVariable "unlockedOptics";
     publicVariable "unlockedItems";
    _check = false;
};

if (!haveNV) then {
    private _cuenta = 0;
    {
        _cuenta = _cuenta + (_x select 1);
    } forEach _nv;

    if (_cuenta >= minWeaps) then {
        unlockedItems = unlockedItems + NVGoggles;
        haveNV = true; publicVariable "haveNV";
        publicVariable "unlockedItems";
        _updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "NVGoggles" >> "displayName")];
        {
            private _index = _x call jn_fnc_arsenal_itemType;
            [_index,_x,-1] call jn_fnc_arsenal_addItem;
        }foreach NVGoggles;
    };
};

_updated