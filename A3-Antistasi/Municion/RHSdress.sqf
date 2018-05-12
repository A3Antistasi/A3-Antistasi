_unit = _this select 0;
_tipo = typeOf _unit;
_loadout = "rhsgref_ins_g_militiaman_mosin";
switch _tipo do
	{
	case "I_G_officer_F": {_loadout = "rhsgref_ins_g_squadleader"};
	case "I_G_Soldier_AR_F": {_loadout = "rhsgref_ins_g_machinegunner"};
	case "I_G_Soldier_LAT2_F": {_loadout = "rhsgref_nat_grenadier_rpg"};
	case "I_G_medic_F": {_loadout = "rhsgref_ins_g_medic"};
	case "I_G_engineer_F": {_loadout = "rhsgref_ins_g_engineer"};
	case "I_G_Soldier_GL_F": {_loadout = "rhsgref_nat_pmil_grenadier"};
	};
_unit setUnitLoadout _loadout;
/*
//_tipo = typeOf _unit;
//_emptyUniform = false;
removeVest _unit;
_unit addVest "rhs_6sh46";
_rifleFinal = unlockedRifles call BIS_fnc_selectRandom;
if (_rifleFinal != primaryWeapon _unit) then
	{
	_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines");
	{_unit removeMagazines _x} forEach _magazines;
	_unit removeWeaponGlobal (primaryWeapon _unit);
	[_unit, _rifleFinal, 6, 0] call BIS_fnc_addWeapon;
	};
*/

_unit selectWeapon (primaryWeapon _unit);
