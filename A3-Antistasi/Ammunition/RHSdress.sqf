_unit = _this select 0;
_typeX = typeOf _unit;

_loadout = switch true do
{
	case hasIFA: {"LIB_WP_Strzelec";};
	case activeGREF: {"rhsgref_nat_rifleman_akms";}; 
	case activeAFRF: {"rhs_vmf_flora_rifleman";};
	case activeUSAF: {"rhsusf_usmc_marpat_wd_rifleman_light";};
	case hasFFAA: {"ffaa_brilat_granadero";};
	default {"I_G_Soldier_F";};
};

switch _typeX do
{

	case "I_G_officer_F": {_loadout =  SDKSL select 1};
	case "I_G_Soldier_AR_F": {_loadout =  SDKMG select 1};
	case "I_G_Soldier_LAT2_F": {_loadout =  SDKATman select 1};
	case "I_G_medic_F": {_loadout =  SDKMedic select 1};
	case "I_G_engineer_F": {_loadout = SDKEng select 1};
	case "I_G_Soldier_GL_F": {_loadout =  SDKGL select 1};
	/* 
	case "I_G_officer_F": {_loadout = selectRandom SDKSL};
	case "I_G_Soldier_F": {_loadout = selectRandom SDKMil};
	case "I_G_Soldier_TL_F": {_loadout = selectRandom SDKSL};
	case "I_G_Soldier_AR_F": {_loadout = selectRandom SDKMG};
	case "I_G_Soldier_LAT_F": {_loadout = selectRandom SDKATman};
	case "I_G_Soldier_LAT2_F": {_loadout = selectRandom SDKATman};
	case "I_G_Soldier_GL_F": {_loadout = selectRandom SDKGL};
	case "I_G_Soldier_M_F": {_loadout = selectRandom SDKSniper};
	case "I_G_medic_F": {_loadout = selectRandom SDKMedic};
	case "I_G_engineer_F": {_loadout = selectRandom SDKEng};
	case "I_G_Sharpshooter_F": {_loadout = selectRandom SDKSniper};
 	*/
	case "I_Soldier_M_F": {_loadOut = NATOMarksman};
	case "I_Sniper_F": {_loadOut = NATOMarksman};
	case "I_medic_F": {_loadOut = NATOSpecOp select 7};
	case "I_Soldier_SL_F": {_loadout = NATOSpecOp select 0};
	case "I_Spotter_F": {_loadOut = NATOSpecOp select 1};
	case "I_Soldier_LAT_F": {_loadOut = NATOSpecOp select 6};
	case "I_Soldier_exp_F": {_loadOut = NATOSpecOp select 5};

	case "B_recon_TL_F": {_loadout = NATOSpecOp select 0};
	case "B_CTRG_Soldier_TL_tna_F": {_loadout = NATOSpecOp select 0};
	case "B_recon_M_F": {_loadOut = NATOMarksman};
	case "B_CTRG_Soldier_M_tna_F": {_loadOut = NATOMarksman};
	case "B_CTRG_Soldier_Medic_tna_F": {_loadOut = NATOSpecOp select 7};
	case "B_recon_LAT_F": {_loadOut = NATOSpecOp select 6};
	case "B_CTRG_Soldier_LAT_tna_F": {_loadOut = NATOSpecOp select 6};
	case "B_recon_F": {_loadOut = NATOSpecOp select 2};
	case "B_CTRG_Soldier_tna_F": {_loadOut = NATOSpecOp select 2};
	case "B_recon_medic_F": {_loadOut = NATOSpecOp select 7};
	case "B_CTRG_Soldier_JTAC_tna_F": {_loadOut = NATOSpecOp select 1};
	case "B_recon_exp_F": {_loadOut = NATOSpecOp select 5};
	case "B_CTRG_Soldier_Exp_tna_F": {_loadOut = NATOSpecOp select 5};
	case "B_recon_JTAC_F": {_loadOut = NATOSpecOp select 1};
	case "B_Patrol_Soldier_MG_F": {_loadOut = NATOSpecOp select 3};
	case "B_CTRG_Soldier_AR_tna_F": {_loadOut = NATOSpecOp select 3};

	case "O_T_Recon_M_F": {_loadout = CSATMarksman};
	case "O_T_Recon_TL_F": {_loadout = CSATSpecOp select 0};
	case "O_T_Recon_Medic_F": {_loadOut = CSATSpecOp select 7};
	case "O_T_Recon_LAT_F": {_loadout = CSATSpecOp select 6};
	case "O_T_Recon_F": {_loadout = CSATSpecOp select 2};
	case "O_T_Recon_JTAC_F": {_loadOut = CSATSpecOp select 1};
	case "O_T_Recon_Exp_F": {_loadOut = CSATSpecOp select 5};
};
_unit setUnitLoadout _loadout;

_unit selectWeapon (primaryWeapon _unit);
