if (!isServer) exitWith {};
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
private ["_armas","_mochis","_items","_magazines","_arma","_magazine","_index","_mochi","_item","_optics","_nv"];

_updated = "";
/*

(jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_UNIFORM)

	IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC\
*/
["buttonInvToJNA"] call jn_fnc_arsenal;
_armas = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_HANDGUN) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON)) select {_x select 1 != -1};
//_magazines = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL)) select {_x select 1 == -1};
_mochis = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_BACKPACK) select {_x select 1 != -1};
_items = ((jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_VEST) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_GOGGLES) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_MAP) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_GPS) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_RADIO) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_COMPASS) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_WATCH) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMACC) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD) + (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS)) select {_x select 1 != -1};
_optics = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC) select {_x select 1 != -1};
_nv = (jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_NVGS) select {_x select 1 != -1};

_check = false;
{
if (_x select 1 >= minWeaps) then
	{
	_arma = _x select 0;
	_magazine = (getArray (configFile / "CfgWeapons" / _arma / "magazines") select 0);
	if (!isNil "_magazine") then
		{
		if (not(_magazine in unlockedMagazines)) then
			{
			unlockedMagazines pushBack _magazine;
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
			_index = _magazine call jn_fnc_arsenal_itemType;
			[_index,_magazine,-1] call jn_fnc_arsenal_addItem;
			};
		};
	unlockedWeapons pushBack _arma;
	//lockedWeapons = lockedWeapons - [_arma];
	if (_arma in arifles) then {unlockedRifles pushBack _arma; publicVariable "unlockedRifles"};
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _arma >> "displayName")];
	_index = _arma call jn_fnc_arsenal_itemType;
	[_index,_arma,-1] call jn_fnc_arsenal_addItem;
	};
} forEach _armas;

if (_check) then
	{
	 publicVariable "unlockedWeapons";
	 publicVariable "unlockedMagazines";
	_check = false;
	};

{
if (_x select 1 >= minPacks) then
	{
	_mochi = _x select 0;
	_index = _mochi  call jn_fnc_arsenal_itemType;
	[_index,_mochi,-1] call jn_fnc_arsenal_addItem;
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgVehicles" >> _lockedMochi >> "displayName")];
	unlockedBackpacks pushBack _mochi;
	publicVariable "unlockedBackpacks";
	};
} forEach _mochis;

{
if (_x select 1 >= minItems) then
	{
	_item = _x select 0;
	unlockedItems pushBack _item;
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
	_check = true;
	_index = _item call jn_fnc_arsenal_itemType;
	[_index,_item,-1] call jn_fnc_arsenal_addItem;
	};
} forEach _items;

if (_check) then
	{
	 publicVariable "unlockedItems";
	_check = false;
	};
{
if (_x select 1 >= minOptics) then
	{
	_item = _x select 0;
	unlockedOptics pushBack _item;
	unlockedItems pushBack _item;
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
	_check = true;
	_index = _item call jn_fnc_arsenal_itemType;
	[_index,_item,-1] call jn_fnc_arsenal_addItem;
	};
} forEach _optics;

if (_check) then
	{
	 publicVariable "unlockedOptics";
	 publicVariable "unlockedItems";
	_check = false;
	};

if (not("NVGoggles" in unlockedItems)) then
	{
	_cuenta = 0;
	{
	_cuenta = _cuenta + (_x select 1);
	} forEach _nv;
	if (_cuenta >= minItems) then
		{
		unlockedItems = unlockedItems + NVGoggles;
		publicVariable "unlockedItems";
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "NVGoggles" >> "displayName")];
		{
		_index = _x call jn_fnc_arsenal_itemType;
		[_index,_x,-1] call jn_fnc_arsenal_addItem;
		}foreach NVGoggles;
		};
	};

_updated