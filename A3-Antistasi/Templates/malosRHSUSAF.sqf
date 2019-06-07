NATOGrunt = "rhsusf_usmc_marpat_wd_rifleman_light";
NATOOfficer = "rhsusf_usmc_marpat_wd_officer";
NATOOfficer2 = "rhsgref_cdf_b_reg_general";
NATOBodyG = "rhsusf_socom_marsoc_teamleader";
NATOCrew = "rhsusf_usmc_marpat_wd_crewman";
NATOUnarmed = "B_G_Survivor_F";
NATOMarksman = "rhsusf_usmc_marpat_wd_marksman";
staticCrewMalos = "rhsusf_usmc_marpat_wd_machinegunner_ass";
NATOPilot = "rhsusf_airforce_jetpilot";

NATOMG = "RHS_M2StaticMG_USMC_WD";
NATOMortar = "RHS_M252_USMC_WD";
staticATmalos = "RHS_TOW_TriPod_USMC_WD";
staticAAmalos = "RHS_Stinger_AA_pod_D";

// vehNATOLightArmed = ["rhsusf_m1025_w_s_m2","rhsusf_rg33_m2_usmc_wd"];
vehNATOLightArmed = ["rhsusf_m1043_w_s_m2","rhsusf_m1025_w_s_m2", "rhsusf_CGRCAT1A2_M2_usmc_wd", "rhsusf_M1232_MC_M2_usmc_wd", "rhsusf_M1220_M153_M2_usarmy_wd", "rhsusf_M1220_M2_usarmy_wd", "rhsusf_M1230_M2_usarmy_wd", "rhsusf_M1232_M2_usarmy_wd", "rhsusf_M1237_M2_usarmy_wd"];
//vehNATOLightUnarmed = ["rhsusf_m1025_w_s","rhsusf_m998_w_s_2dr","rhsusf_m998_w_s_2dr_fulltop","rhsusf_m998_w_s_4dr"];
vehNATOLightUnarmed = ["rhsusf_M1230a1_usarmy_wd", "rhsusf_M1232_usarmy_wd", "rhsusf_CGRCAT1A2_usmc_wd", "rhsusf_mrzr4_d", "rhsusf_m1025_w", "rhsusf_m1043_w", "rhsusf_m998_w_2dr_fulltop", "rhsusf_m998_w_2dr_halftop", "rhsusf_m998_w_2dr", "rhsusf_m998_w_4dr_fulltop", "rhsusf_m998_w_4dr_halftop", "rhsusf_m998_w_4dr", "rhsusf_M1220_usarmy_wd"];

vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;

//vehNATOTrucks = ["rhsusf_M1078A1P2_wd_open_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_open_fmtv_usarmy","rhsusf_M1083A1P2_wd_fmtv_usarmy"];
vehNATOTrucks = ["rhsusf_M1078A1P2_WD_fmtv_usarmy", "rhsusf_M1078A1P2_B_WD_fmtv_usarmy", "rhsusf_M1078A1P2_B_M2_WD_fmtv_usarmy", "rhsusf_M1083A1P2_WD_fmtv_usarmy", "rhsusf_M1083A1P2_B_WD_fmtv_usarmy", "rhsusf_M1083A1P2_B_M2_WD_fmtv_usarmy", "rhsusf_M1078A1R_SOV_M2_D_fmtv_socom"];

vehNATOAmmoTruck = "rhsusf_M977A4_AMMO_BKIT_usarmy_wd";
vehNATORepairTruck = "rhsusf_M977A4_REPAIR_BKIT_usarmy_wd";


//vehNATOAPC = ["RHS_M2A3_BUSKIII_wd","RHS_M2A3_BUSKI_wd","RHS_M2A3_wd","RHS_M2A3_wd","RHS_M2A2_BUSKI_WD","RHS_M2A2_wd","rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy_MK19"];//"B_T_APC_Tracked_01_CRV_F" has no cargo seats
vehNATOAPC = ["rhsusf_m113_usarmy_supply", "rhsusf_m113_usarmy", "rhsusf_m113_usarmy_M2_90", "rhsusf_m113_usarmy_M240", "rhsusf_m113_usarmy_medical", "rhsusf_m113_usarmy_MK19", "rhsusf_m113_usarmy_MK19_90", "rhsusf_m113_usarmy_unarmed", "RHS_M2A2_wd", "RHS_M2A2_BUSKI_WD", "RHS_M2A3_wd", "RHS_M2A3_BUSKI_wd", "RHS_M2A3_BUSKIII_wd", "RHS_M6_wd", "rhsusf_M1117_W"];

vehNATOTank = "rhsusf_m1a1fep_wd";

vehNATOAllTanks = ["rhsusf_m1a1fep_wd", "rhsusf_m1a1aimwd_usarmy", "rhsusf_m1a1aim_tuski_wd", "rhsusf_m1a2sep1wd_usarmy", "rhsusf_m1a2sep1tuskiwd_usarmy", "rhsusf_m1a2sep1tuskiiwd_usarmy", "rhsusf_m1a1fep_wd", "rhsusf_m1a1fep_od", "rhsusf_m1a1hc_wd"];

vehNATOAA = "RHS_M6";

vehNATOAttack = vehNATOAPC + vehNATOAllTanks;

vehNATOBoat = "rhsusf_mkvsoc";
vehNATORBoat = "B_T_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"rhsusf_m113_usarmy_MK19"];
vehNATOPlane = "RHS_A10_AT";
vehNATOPlaneAA = "rhsusf_f22";
vehNATOPatrolHeli = "RHS_MELB_MH6M";
vehNATOTransportHelis = ["RHS_UH60M_d","RHS_CH_47F",vehNATOPatrolHeli,"RHS_C130J"];
vehNATOAttackHelis = ["RHS_MELB_AH6M_L","RHS_AH64D_wd","RHS_UH1Y"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA];
vehNATOUAV = "not_supported";//ok
vehNATOUAVSmall = "not_supported";
vehNATOMRLS = "rhsusf_m109_usarmy";
vehNATOMRLSMags = "rhs_mag_155mm_m795_28";//["Sh_155mm_AMOS","rhs_mag_155mm_m795_28",<NULL-object>,B Alpha 1-1:3 (Alberto)]
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "rhsusf_M978A4_BKIT_usarmy_wd","rhsusf_m113_usarmy_medical", vehNATORepairTruck];
vehNATOBike = "B_T_Quadbike_01_F";
NATOFlag = "Flag_NATO_F";
NATOFlagTexture = "\A3\Data_F\Flags\Flag_nato_CO.paa";
NATOAmmobox = "B_supplyCrate_F";

//cfgNATOInf = (configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry");///
gruposNATOSentry = ["rhsusf_usmc_marpat_wd_grenadier",NATOGrunt];//"B_T_InfSentry";//
gruposNATOSniper = ["rhsusf_socom_marsoc_sniper","rhsusf_socom_marsoc_spotter"];
gruposNATOsmall = [gruposNATOSentry,gruposNATOSniper]; //[gruposNATOSentry,"B_T_SniperTeam","B_T_ReconSentry"];///
gruposNATOAA = ["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_stinger"];
gruposNATOAT = ["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_javelin"];
gruposNATOmid = [["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_riflemanat"],gruposNATOAA,gruposNATOAT];//["B_T_InfTeam","B_T_InfTeam_AA","B_T_InfTeam_AT"];///
NATOSquad = ["rhsusf_usmc_marpat_wd_squadleader","rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_navy_marpat_wd_medic","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_marksman"];//"B_T_InfSquad";//
NATOSpecOp = ["rhsusf_socom_marsoc_teamleader","rhsusf_socom_marsoc_teamchief","rhsusf_socom_marsoc_elementleader","rhsusf_usmc_recon_marpat_wd_machinegunner","rhsusf_socom_marsoc_cso_breacher","rhsusf_socom_marsoc_cso_eod","rhsusf_usmc_recon_marpat_wd_rifleman_at","rhsusf_socom_marsoc_sarc"];//(configfile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad");
factionMachoMalos = "rhs_faction_socom";
gruposNATOSquad = [NATOSquad,["rhsusf_usmc_marpat_d_squadleader","rhsusf_usmc_marpat_d_machinegunner","rhsusf_usmc_marpat_d_riflemanat","rhsusf_usmc_marpat_d_riflemanat","rhsusf_usmc_marpat_d_grenadier","rhsusf_usmc_marpat_d_javelin","rhsusf_usmc_marpat_d_javelin_assistant","rhsusf_navy_sarc_d"],["rhsusf_usmc_marpat_d_squadleader","rhsusf_usmc_marpat_d_machinegunner","rhsusf_usmc_marpat_d_riflemanat","rhsusf_usmc_marpat_d_grenadier","rhsusf_usmc_marpat_d_grenadier","rhsusf_usmc_marpat_d_stinger","rhsusf_usmc_marpat_d_rifleman_light","rhsusf_navy_sarc_d_fast"],["rhsusf_usmc_marpat_wd_squadleader","rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_navy_marpat_wd_medic","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_d_explosives"]]; //[NATOSquad,"B_T_InfSquad_Weapons"];///

soporteStaticNATOB = "rhs_TOW_Tripod_Bag";
ATStaticNATOB = "rhs_Tow_Gun_Bag";
MGStaticNATOB = "RHS_M2_Gun_Bag";
soporteStaticNATOB2 = "RHS_M2_Tripod_Bag";
AAStaticNATOB = "B_AA_01_weapon_F";
MortStaticNATOB = "rhs_M252_Gun_Bag";
soporteStaticNATOB3 = "rhs_M252_Bipod_Bag";

armasNATO append ["rhs_weap_hk416d10","rhs_weap_m16a4","rhs_weap_XM2010","rhs_weap_m24sws","rhs_weap_m27iar","rhs_weap_m4","rhs_weap_m40a5","rhs_weap_m4a1_carryhandle","rhs_weap_m4a1_blockII","rhs_weap_m4a1","rhs_weap_M590_8RD","rhs_weap_mk18","rhsusf_weap_MP7A2","hgun_Pistol_heavy_01_F","rhs_weap_fgm148","rhs_weap_fim92","rhsusf_weap_glock17g4","rhs_weap_M107","rhs_weap_M136","rhs_weap_M136_hedp","rhs_weap_M136_hp","rhs_weap_m14ebrri","rhs_weap_m72a7","rhsusf_weap_m9","rhs_weap_sr25","lerca_1200_black","lerca_1200_tan","Leupold_Mk4","rhs_weap_m240B","rhs_weap_m249","rhs_weap_smaw","rhs_weap_m39"];//possible weapons that spawn in NATO ammoboxes
humo = humo + ["rhs_mag_an_m8hc","rhs_mag_m18_purple","rhs_mag_m18_red","rhs_mag_m18_green","rhs_mag_m18_yellow"];
NVGoggles = NVGoggles + ["rhsusf_ANPVS_14"/*,"rhsusf_ANPVS_15"*/];
itemsAAF = itemsAAF + ["rhsusf_acc_grip2","rhsusf_acc_grip2_tan","rhsusf_acc_anpeq15side_bk","rhsusf_acc_anpeq15_bk_top","rhsusf_acc_anpeq15","rhsusf_acc_anpeq15_light","rhsusf_acc_anpeq15_bk","rhsusf_acc_anpeq15_bk_light","rhsusf_acc_anpeq15A","rhsusf_acc_ARDEC_M240","rhsusf_acc_nt4_black","rhsusf_acc_nt4_tan","rhsusf_acc_SFMB556"];
flagNATOmrk = "flag_USA";//ok

lamparaMalos = "acc_flashlight";
nameMalos = "USAF";
if (isServer) then {"NATO_carrier" setMarkerText "USMC Carrier"};

rifleTier1NATO = "rhsusf_weap_MP7A2";
rifleTier2NATO = "rhs_weap_hk416d10";