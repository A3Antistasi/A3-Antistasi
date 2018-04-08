NATOGrunt = "rhsusf_usmc_marpat_wd_rifleman_light";
NATOOfficer = "rhsusf_usmc_marpat_wd_officer";
NATOOfficer2 = "B_G_officer_F";
NATOBodyG = "rhsusf_socom_marsoc_teamleader";
NATOCrew = "rhsusf_usmc_marpat_wd_crewman";
NATOUnarmed = "B_G_Survivor_F";
NATOMarksman = "rhsusf_usmc_marpat_wd_marksman";
staticCrewMalos = "rhsusf_usmc_marpat_wd_machinegunner_ass";
NATOPilot = "rhsusf_airforce_jetpilot";

NATOMG = "RHS_M2StaticMG_USMC_WD";
NATOMortar = "RHS_M252_USMC_WD";
staticATmalos = "RHS_TOW_TriPod_USMC_WD";

vehNATOLightArmed = ["rhsusf_m1025_w_s_m2","rhsusf_rg33_m2_usmc_wd"];
vehNATOLightUnarmed = ["rhsusf_m1025_w_s","rhsusf_m998_w_s_2dr","rhsusf_m998_w_s_2dr_fulltop","rhsusf_m998_w_s_4dr"];
vehNATOTrucks = ["rhsusf_M1078A1P2_wd_open_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_open_fmtv_usarmy","rhsusf_M1083A1P2_wd_fmtv_usarmy"];
vehNATOAmmoTruck = "rhsusf_M977A4_AMMO_BKIT_usarmy_wd";
vehNATORepairTruck = "rhsusf_M977A4_REPAIR_BKIT_usarmy_wd";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
vehNATOAPC = ["RHS_M2A3_BUSKIII_wd","RHS_M2A3_BUSKI_wd","RHS_M2A3_wd","RHS_M2A3_wd","RHS_M2A2_BUSKI_WD","RHS_M2A2_wd","rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy_MK19"];//"B_T_APC_Tracked_01_CRV_F" has no cargo seats
vehNATOTank = "rhsusf_m1a1fep_wd";
vehNATOAA = "RHS_M6";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
vehNATOBoat = "rhsusf_mkvsoc";
vehNATORBoat = "B_T_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"rhsusf_m113_usarmy_MK19"];
vehNATOPlane = "RHS_A10_AT";
vehNATOPlaneAA = "rhsusf_f22";
vehNATOPatrolHeli = "RHS_MELB_MH6M";
vehNATOTransportHelis = ["RHS_UH60M_d","RHS_CH_47F",vehNATOPatrolHeli,"RHS_C130J"];
vehNATOAttackHelis = ["RHS_MELB_AH6M_L","RHS_AH64D_wd","RHS_UH1Y"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA];
vehNATOUAV = "B_UAV_02_F";//ok
vehNATOUAVSmall = "B_UAV_01_F";
vehNATOMRLS = "rhsusf_m109_usarmy";
vehNATOMRLSMags = "32Rnd_155mm_Mo_shells";
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "rhsusf_M978A4_BKIT_usarmy_wd","rhsusf_m113_usarmy_medical", vehNATORepairTruck];
vehNATOBike = "B_T_Quadbike_01_F";
NATOFlag = "Flag_NATO_F";

//cfgNATOInf = (configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry");///
gruposNATOSentry = ["rhsusf_usmc_marpat_wd_grenadier",NATOGrunt];//"B_T_InfSentry";//
gruposNATOSniper = ["rhsusf_socom_marsoc_sniper","rhsusf_socom_marsoc_spotter"];
gruposNATOsmall = [gruposNATOSentry,gruposNATOSniper]; //[gruposNATOSentry,"B_T_SniperTeam","B_T_ReconSentry"];///
gruposNATOAA = ["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_stinger"];
gruposNATOAT = ["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_javelin"];
gruposNATOmid = [["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_riflemanat"],gruposNATOAA,gruposNATOAT];//["B_T_InfTeam","B_T_InfTeam_AA","B_T_InfTeam_AT"];///
NATOSquad = ["rhsusf_usmc_marpat_wd_squadleader","rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_navy_marpat_wd_medic","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_marksman"];//"B_T_InfSquad";//
NATOSpecOp = ["rhsusf_socom_marsoc_teamleader","rhsusf_socom_marsoc_teamchief","rhsusf_socom_marsoc_elementleader","rhsusf_socom_marsoc_cso","rhsusf_socom_marsoc_cso_breacher","rhsusf_socom_marsoc_cso_mechanic","rhsusf_socom_marsoc_sarc","rhsusf_socom_marsoc_elementleader","rhsusf_socom_marsoc_cso","rhsusf_socom_marsoc_cso_breacher","rhsusf_socom_marsoc_cso_mechanic","rhsusf_socom_marsoc_sarc"];//(configfile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad");
gruposNATOSquad = [NATOSquad]; //[NATOSquad,"B_T_InfSquad_Weapons"];///

soporteStaticNATOB = "rhs_TOW_Tripod_Bag";
ATStaticNATOB = "rhs_Tow_Gun_Bag";
MGStaticNATOB = "RHS_M2_Gun_Bag";
soporteStaticNATOB2 = "RHS_M2_Tripod_Bag";
AAStaticNATOB = "B_AA_01_weapon_F";
MortStaticNATOB = "rhs_M252_Gun_Bag";
soporteStaticNATOB3 = "rhs_M252_Bipod_Bag";

armasNATO = ["rhs_weap_hk416d10","rhs_weap_m16a4","rhs_weap_XM2010","rhs_weap_m24sws","rhs_weap_m27iar","rhs_weap_m4","rhs_weap_m40a5","rhs_weap_m4a1_carryhandle","rhs_weap_m4a1_blockII","rhs_weap_m4a1","rhs_weap_M590_8RD","rhs_weap_mk18","rhsusf_weap_MP7A2","hgun_Pistol_heavy_01_F","rhs_weap_fgm148","rhs_weap_fim92","rhsusf_weap_glock17g4","rhs_weap_M107","rhs_weap_M136","rhs_weap_M136_hedp","rhs_weap_M136_hp","rhs_weap_m14ebrri","rhs_weap_m72a7","rhsusf_weap_m9","rhs_weap_sr25","lerca_1200_black","lerca_1200_tan","Leupold_Mk4","rhs_weap_m240B","rhs_weap_m249","rhs_weap_smaw","rhs_weap_m39"];//possible weapons that spawn in NATO ammoboxes
humo = humo + ["rhs_mag_an_m8hc","rhs_mag_m18_purple","rhs_mag_m18_red","rhs_mag_m18_green","rhs_mag_m18_yellow"];
NVGoggles = NVGoggles + ["rhsusf_ANPVS_14"/*,"rhsusf_ANPVS_15"*/];
itemsAAF = itemsAAF + ["rhsusf_acc_grip2","rhsusf_acc_grip2_tan","rhsusf_acc_anpeq15side_bk","rhsusf_acc_anpeq15_bk_top","rhsusf_acc_anpeq15","rhsusf_acc_anpeq15_light","rhsusf_acc_anpeq15_bk","rhsusf_acc_anpeq15_bk_light","rhsusf_acc_anpeq15A","rhsusf_acc_ARDEC_M240","rhsusf_acc_nt4_black","rhsusf_acc_nt4_tan","rhsusf_acc_SFMB556"];
opticasAAF = opticasAAF + ["rhsusf_acc_anpas13gv1","rhsusf_acc_ACOG2_USMC","rhsusf_acc_ACOG3_USMC","rhsusf_acc_ACOG_USMC","rhsusf_acc_anpvs27","rhsusf_acc_ARDEC_M240","rhsusf_acc_ELCAN","rhsusf_acc_ELCAN_ard","rhsusf_acc_ACOG","rhsusf_acc_ACOG3","rhsusf_acc_ACOG_anpvs27","rhsusf_acc_M2A1","rhsusf_acc_compm4","rhsusf_acc_M8541","rhsusf_acc_premier_low","rhsusf_acc_premier_anpvs27","rhsusf_acc_premier","rhsusf_acc_LEUPOLDMK4","rhsusf_acc_LEUPOLDMK4_2","rhsusf_acc_LEUPOLDMK4_2_d","optic_MRD","rhs_weap_optic_smaw","rhsusf_acc_SpecterDR","rhsusf_acc_SpecterDR_D","rhsusf_acc_SpecterDR_A","rhsusf_acc_ACOG_MDO","rhsusf_acc_ACOG_RMR","rhsusf_acc_eotech_xps3"];
municionNATO = [];
{
_nombre = [_x] call BIS_fnc_baseWeapon;
_magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
municionNATO pushBack (_magazines select 0);
} forEach armasNATO;
flagNATOmrk = "flag_USA";//ok
squadLeaders pushBack "rhsusf_usmc_marpat_wd_squadleader";
//cascos = cascos + ["rhsusf_ach_bare","rhsusf_ach_bare_des","rhsusf_ach_bare_des_ess","rhsusf_ach_bare_des_headset","rhsusf_ach_bare_des_headset_ess","rhsusf_ach_bare_ess","rhsusf_ach_bare_headset","rhsusf_ach_bare_headset_ess","rhsusf_ach_bare_semi","rhsusf_ach_bare_semi_ess","rhsusf_ach_bare_semi_headset","rhsusf_ach_bare_semi_headset_ess","rhsusf_ach_bare_tan","rhsusf_ach_bare_tan_ess","rhsusf_ach_bare_tan_headset","rhsusf_ach_bare_tan_headset_ess","rhsusf_ach_bare_wood","rhsusf_ach_bare_wood_ess","rhsusf_ach_bare_wood_headset","rhsusf_ach_bare_wood_headset_ess","rhsusf_ach_helmet_M81","rhsusf_ach_helmet_ocp","rhsusf_ach_helmet_ESS_ocp","rhsusf_ach_helmet_headset_ocp","rhsusf_ach_helmet_headset_ess_ocp","rhsusf_ach_helmet_camo_ocp","rhsusf_ach_helmet_ocp_norotos","rhsusf_ach_helmet_ucp","rhsusf_ach_helmet_ESS_ucp","rhsusf_ach_helmet_headset_ucp","rhsusf_ach_helmet_headset_ess_ucp","rhsusf_ach_helmet_ucp_norotos","rhsusf_cvc_green_helmet","rhsusf_cvc_green_ess","rhsusf_cvc_helmet","rhsusf_cvc_ess","rhsusf_Bowman","rhsusf_bowman_cap","rhsusf_opscore_aor1","rhsusf_opscore_aor1_pelt","rhsusf_opscore_aor1_pelt_nsw","rhsusf_opscore_aor2","rhsusf_opscore_aor2_pelt","rhsusf_opscore_aor2_pelt_nsw","rhsusf_opscore_bk","rhsusf_opscore_bk_pelt","rhsusf_opscore_coy_cover","rhsusf_opscore_coy_cover_pelt","rhsusf_opscore_fg","rhsusf_opscore_fg_pelt","rhsusf_opscore_fg_pelt_cam","rhsusf_opscore_fg_pelt_nsw","rhsusf_opscore_mc_cover","rhsusf_opscore_mc_cover_pelt","rhsusf_opscore_mc_cover_pelt_nsw","rhsusf_opscore_mc_cover_pelt_cam","rhsusf_opscore_mc","rhsusf_opscore_mc_pelt","rhsusf_opscore_mc_pelt_nsw","rhsusf_opscore_paint","rhsusf_opscore_paint_pelt","rhsusf_opscore_paint_pelt_nsw","rhsusf_opscore_paint_pelt_nsw_cam","rhsusf_opscore_rg_cover","rhsusf_opscore_rg_cover_pelt","rhsusf_opscore_ut","rhsusf_opscore_ut_pelt","rhsusf_opscore_ut_pelt_cam","rhsusf_opscore_ut_pelt_nsw","rhsusf_opscore_ut_pelt_nsw_cam","rhsusf_opscore_mar_fg","rhsusf_opscore_mar_fg_pelt","rhsusf_opscore_mar_ut","rhsusf_opscore_mar_ut_pelt","rhsusf_hgu56p","rhsusf_hgu56p_mask","RHS_jetpilot_usaf","rhsusf_lwh_helmet_M1942","rhsusf_lwh_helmet_marpatd","rhsusf_lwh_helmet_marpatd_ess","rhsusf_lwh_helmet_marpatd_headset","rhsusf_lwh_helmet_marpatwd","rhsusf_lwh_helmet_marpatwd_blk_ess","rhsusf_lwh_helmet_marpatwd_headset_blk","rhsusf_lwh_helmet_marpatwd_headset","rhsusf_lwh_helmet_marpatwd_ess","rhsusf_mich_bare","rhsusf_mich_bare_alt","rhsusf_mich_bare_headset","rhsusf_mich_bare_norotos","rhsusf_mich_bare_norotos_alt","rhsusf_mich_bare_norotos_alt_headset","rhsusf_mich_bare_norotos_arc","rhsusf_mich_bare_norotos_arc_alt","rhsusf_mich_bare_norotos_arc_alt_headset","rhsusf_mich_bare_norotos_arc_headset","rhsusf_mich_bare_norotos_headset","rhsusf_mich_bare_semi","rhsusf_mich_bare_alt_semi","rhsusf_mich_bare_semi_headset","rhsusf_mich_bare_norotos_semi","rhsusf_mich_bare_norotos_alt_semi","rhsusf_mich_bare_norotos_alt_semi_headset","rhsusf_mich_bare_norotos_arc_semi","rhsusf_mich_bare_norotos_arc_alt_semi","rhsusf_mich_bare_norotos_arc_alt_semi_headset","rhsusf_mich_bare_norotos_arc_semi_headset","rhsusf_mich_bare_norotos_semi_headset","rhsusf_mich_bare_tan","rhsusf_mich_bare_alt_tan","rhsusf_mich_bare_tan_headset","rhsusf_mich_bare_norotos_tan","rhsusf_mich_bare_norotos_alt_tan","rhsusf_mich_bare_norotos_alt_tan_headset","rhsusf_mich_bare_norotos_arc_tan","rhsusf_mich_bare_norotos_arc_alt_tan","rhsusf_mich_bare_norotos_arc_alt_tan_headset","rhsusf_mich_bare_norotos_tan_headset","rhsusf_mich_helmet_marpatd","rhsusf_mich_helmet_marpatd_alt","rhsusf_mich_helmet_marpatd_alt_headset","rhsusf_mich_helmet_marpatd_headset","rhsusf_mich_helmet_marpatd_norotos","rhsusf_mich_helmet_marpatd_norotos_arc","rhsusf_mich_helmet_marpatd_norotos_arc_headset","rhsusf_mich_helmet_marpatd_norotos_headset","rhsusf_mich_helmet_marpatwd","rhsusf_mich_helmet_marpatwd_alt","rhsusf_mich_helmet_marpatwd_alt_headset","rhsusf_mich_helmet_marpatwd_headset","rhsusf_mich_helmet_marpatwd_norotos","rhsusf_mich_helmet_marpatwd_norotos_arc","rhsusf_mich_helmet_marpatwd_norotos_arc_headset","rhsusf_mich_helmet_marpatwd_norotos_headset","rhsusf_protech_helmet","rhsusf_protech_helmet_ess","rhsusf_protech_helmet_rhino","rhsusf_protech_helmet_rhino_ess"];
//lockedMochis = lockedMochis + ["rhsusf_assault_eagleaiii_coy","B_rhsusf_B_BACKPACK","rhsusf_assault_eagleaiii_ocp","rhsusf_assault_eagleaiii_ucp","rhsusf_falconii_coy","rhsusf_falconii_mc","rhsusf_falconii","RHS_M2_Gun_Bag","RHS_M2_Tripod_Bag","rhs_M252_Gun_Bag","rhs_M252_Bipod_Bag","RHS_M2_MiniTripod_Bag","RHS_Mk19_Gun_Bag","RHS_Mk19_Tripod_Bag","rhs_Tow_Gun_Bag","rhs_TOW_Tripod_Bag"];
lamparaMalos = "acc_flashlight";

//allItems = allItems + ["rhsusf_iotv_ocp_Grenadier","rhsusf_iotv_ucp_Grenadier","rhsusf_iotv_ocp_Medic","rhsusf_iotv_ucp_Medic","rhsusf_iotv_ocp","rhsusf_iotv_ocp_Repair","rhsusf_iotv_ucp_Repair","rhsusf_iotv_ocp_Rifleman","rhsusf_iotv_ucp_Rifleman","rhsusf_iotv_ocp_SAW","rhsusf_iotv_ucp_SAW","rhsusf_iotv_ocp_Squadleader","rhsusf_iotv_ucp_Squadleader","rhsusf_iotv_ocp_Teamleader","rhsusf_iotv_ucp_Teamleader","rhsusf_iotv_ucp","rhsusf_spc","rhsusf_spc_corpsman","rhsusf_spc_crewman","rhsusf_spc_iar","rhsusf_spc_light","rhsusf_spc_mg","rhsusf_spc_marksman","rhsusf_spc_patchless","rhsusf_spc_patchless_radio","rhsusf_spc_rifleman","rhsusf_spc_squadleader","rhsusf_spc_teamleader","rhsusf_spcs_ocp","rhsusf_spcs_ocp_rifleman","rhsusf_spcs_ucp_rifleman","rhsusf_spcs_ucp"];