FIARifleman = "ffaa_brilat_granadero";
FIAMarksman = "ffaa_brilat_tirador";
vehFIAArmedCar = "ffaa_et_lince_m2";
vehFIATruck = "ffaa_et_m250_carga_blin";
vehFIACar = "ffaa_et_anibal";

gruposFIASmall = [["ffaa_brilat_jefe_peloton","ffaa_brilat_granadero"],["ffaa_brilat_francotirador_barrett","ffaa_brilat_observador"]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
gruposFIAMid = [["ffaa_brilat_jefe_peloton","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_alcotan"],["ffaa_brilat_jefe_peloton","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_c90"]];//["IRG_InfAssault","IRG_InfTeam","IRG_InfTeam_AT"];///
FIASquad = ["ffaa_brilat_jefe_escuadra","ffaa_brilat_jefe_peloton","ffaa_brilat_mg4","ffaa_brilat_soldado","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_tirador","ffaa_brilat_medico"];//"IRG_InfSquad";///

/*
NATOGrunt = "ffaa_brilat_granadero";
NATOOfficer = "ffaa_brilat_oficial";
NATOOfficer2 = "B_G_officer_F";
NATOBodyG = "ffaa_et_moe_fusilero_mochila";
NATOCrew = "ffaa_brilat_carrista";
NATOUnarmed = "ffaa_ar_marinero";
NATOMarksman = "ffaa_brilat_tirador";
staticCrewMalos = "ffaa_brilat_soldado";
NATOPilot = "ffaa_pilot_harri";

NATOMG = "ffaa_m2_tripode";
NATOMortar = "B_T_Mortar_01_F";
staticATmalos = "ffaa_tow_tripode";

vehNATOLightArmed = ["ffaa_et_rg31_samson","ffaa_et_vamtac_m2","ffaa_et_vamtac_crows","ffaa_et_lince_m2"];
vehNATOLightUnarmed = ["ffaa_et_anibal","ffaa_et_vamtac_trans","ffaa_et_vamtac_trans_blind"];
vehNATOTrucks = ["ffaa_et_m250_carga_blin","ffaa_et_m250_carga_lona_blin","ffaa_et_pegaso_carga","ffaa_et_pegaso_carga_lona"];
vehNATOAmmoTruck = "ffaa_et_m250_municion_blin";
vehNATORepairTruck = "ffaa_et_pegaso_repara_municion";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
vehNATOAPC = ["ffaa_et_toa_m2"];//AL PIZARRO SÓLO LE CABEN 6 UNIDADES DE INFANTERÍA
vehNATOTank = "ffaa_et_leopardo";
vehNATOAA = "ffaa_et_vamtac_mistral";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
vehNATOBoat = "B_T_Boat_Armed_01_minigun_F";
vehNATORBoat = "ffaa_ar_zodiac_hurricane_long";
vehNATOBoats = [vehNATOBoat,vehNATORBoat];
vehNATOPlane = "ffaa_ar_harrier";
vehNATOPlaneAA = "ffaa_ar_harrier";
vehNATOPatrolHeli = "ffaa_famet_cougar";
vehNATOTransportHelis = ["ffaa_famet_cougar","ffaa_famet_ch47_mg","ffaa_nh90_nfh_transport","ffaa_ea_hercules"];
vehNATOAttackHelis = ["ffaa_famet_tigre"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA];
vehNATOUAV = "ffaa_ea_reaper";//ok
vehNATOUAVSmall = "B_UAV_01_F";
vehNATOMRLS = "B_T_MBT_01_arty_F";
vehNATOMRLSMags = "32Rnd_155mm_Mo_shells";
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck,"ffaa_et_toa_mando","ffaa_et_toa_ambulancia","ffaa_et_lince_ambulancia","ffaa_et_m250_recuperacion_blin","ffaa_et_pegaso_combustible",vehNATORepairTruck];
vehNATOBike = "B_T_Quadbike_01_F";
NATOFlag = "ffaa_bandera_espa";

//cfgNATOInf = (configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry");///
gruposNATOSentry = ["ffaa_brilat_jefe_peloton",NATOGrunt];//"B_T_InfSentry";//
gruposNATOSniper = ["ffaa_brilat_francotirador_barrett","ffaa_brilat_observador"];
gruposNATOsmall = [gruposNATOSentry,gruposNATOSniper]; //[gruposNATOSentry,"B_T_SniperTeam","B_T_ReconSentry"];///
gruposNATOAA = ["ffaa_brilat_jefe_peloton","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","B_T_soldier_AA_F"];
gruposNATOAT = ["ffaa_brilat_jefe_peloton","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_alcotan"];
gruposNATOmid = [["ffaa_brilat_jefe_peloton","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_c90"],gruposNATOAA,gruposNATOAT];//["B_T_InfTeam","B_T_InfTeam_AA","B_T_InfTeam_AT"];///
NATOSquad = ["ffaa_brilat_jefe_escuadra","ffaa_brilat_jefe_peloton","ffaa_brilat_mg4","ffaa_brilat_soldado","ffaa_brilat_tirador_ameli","ffaa_brilat_soldado","ffaa_brilat_tirador","ffaa_brilat_medico"];//"B_T_InfSquad";//
NATOSpecOp = ["ffaa_et_moe_lider","ffaa_et_moe_lg","ffaa_et_moe_fusilero_mochila","ffaa_et_moe_mg","ffaa_et_moe_mg","ffaa_et_moe_at_C90","ffaa_et_moe_sabot","ffaa_et_moe_medico"];//(configfile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad");
gruposNATOSquad = [NATOSquad]; //[NATOSquad,"B_T_InfSquad_Weapons"];///

soporteStaticNATOB = "ffaa_Tripod_Bag";
ATStaticNATOB = "ffaa_tow_tripode_Bag";
MGStaticNATOB = "ffaa_m2_tripode_Bag";
soporteStaticNATOB2 = "ffaa_Tripod_Bag";
AAStaticNATOB = "ffaa_mistral_tripode_Bag";
MortStaticNATOB = "B_Mortar_01_weapon_F";
soporteStaticNATOB3 = "B_Mortar_01_support_F";

armasNATO = ["rhs_weap_hk416d10","rhs_weap_m16a4","rhs_weap_XM2010","rhs_weap_m24sws","rhs_weap_m27iar","rhs_weap_m4","rhs_weap_m40a5","rhs_weap_m4a1_carryhandle","rhs_weap_m4a1_blockII","rhs_weap_m4a1","rhs_weap_M590_8RD","rhs_weap_mk18","rhsusf_weap_MP7A2","hgun_Pistol_heavy_01_F","rhs_weap_fgm148","rhs_weap_fim92","rhsusf_weap_glock17g4","rhs_weap_M107","rhs_weap_M136","rhs_weap_M136_hedp","rhs_weap_M136_hp","rhs_weap_m14ebrri","rhs_weap_m72a7","rhsusf_weap_m9","rhs_weap_sr25","lerca_1200_black","lerca_1200_tan","Leupold_Mk4","rhs_weap_m240B","rhs_weap_m249","rhs_weap_smaw","rhs_weap_m39"];//possible weapons that spawn in NATO ammoboxes
humo = humo + ["rhs_mag_an_m8hc","rhs_mag_m18_purple","rhs_mag_m18_red","rhs_mag_m18_green","rhs_mag_m18_yellow"];
NVGoggles = NVGoggles + ["rhsusf_ANPVS_14"/*,"rhsusf_ANPVS_15"];
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
cascos = cascos + ["rhsusf_ach_bare","rhsusf_ach_bare_des","rhsusf_ach_bare_des_ess","rhsusf_ach_bare_des_headset","rhsusf_ach_bare_des_headset_ess","rhsusf_ach_bare_ess","rhsusf_ach_bare_headset","rhsusf_ach_bare_headset_ess","rhsusf_ach_bare_semi","rhsusf_ach_bare_semi_ess","rhsusf_ach_bare_semi_headset","rhsusf_ach_bare_semi_headset_ess","rhsusf_ach_bare_tan","rhsusf_ach_bare_tan_ess","rhsusf_ach_bare_tan_headset","rhsusf_ach_bare_tan_headset_ess","rhsusf_ach_bare_wood","rhsusf_ach_bare_wood_ess","rhsusf_ach_bare_wood_headset","rhsusf_ach_bare_wood_headset_ess","rhsusf_ach_helmet_M81","rhsusf_ach_helmet_ocp","rhsusf_ach_helmet_ESS_ocp","rhsusf_ach_helmet_headset_ocp","rhsusf_ach_helmet_headset_ess_ocp","rhsusf_ach_helmet_camo_ocp","rhsusf_ach_helmet_ocp_norotos","rhsusf_ach_helmet_ucp","rhsusf_ach_helmet_ESS_ucp","rhsusf_ach_helmet_headset_ucp","rhsusf_ach_helmet_headset_ess_ucp","rhsusf_ach_helmet_ucp_norotos","rhsusf_cvc_green_helmet","rhsusf_cvc_green_ess","rhsusf_cvc_helmet","rhsusf_cvc_ess","rhsusf_Bowman","rhsusf_bowman_cap","rhsusf_opscore_aor1","rhsusf_opscore_aor1_pelt","rhsusf_opscore_aor1_pelt_nsw","rhsusf_opscore_aor2","rhsusf_opscore_aor2_pelt","rhsusf_opscore_aor2_pelt_nsw","rhsusf_opscore_bk","rhsusf_opscore_bk_pelt","rhsusf_opscore_coy_cover","rhsusf_opscore_coy_cover_pelt","rhsusf_opscore_fg","rhsusf_opscore_fg_pelt","rhsusf_opscore_fg_pelt_cam","rhsusf_opscore_fg_pelt_nsw","rhsusf_opscore_mc_cover","rhsusf_opscore_mc_cover_pelt","rhsusf_opscore_mc_cover_pelt_nsw","rhsusf_opscore_mc_cover_pelt_cam","rhsusf_opscore_mc","rhsusf_opscore_mc_pelt","rhsusf_opscore_mc_pelt_nsw","rhsusf_opscore_paint","rhsusf_opscore_paint_pelt","rhsusf_opscore_paint_pelt_nsw","rhsusf_opscore_paint_pelt_nsw_cam","rhsusf_opscore_rg_cover","rhsusf_opscore_rg_cover_pelt","rhsusf_opscore_ut","rhsusf_opscore_ut_pelt","rhsusf_opscore_ut_pelt_cam","rhsusf_opscore_ut_pelt_nsw","rhsusf_opscore_ut_pelt_nsw_cam","rhsusf_opscore_mar_fg","rhsusf_opscore_mar_fg_pelt","rhsusf_opscore_mar_ut","rhsusf_opscore_mar_ut_pelt","rhsusf_hgu56p","rhsusf_hgu56p_mask","RHS_jetpilot_usaf","rhsusf_lwh_helmet_M1942","rhsusf_lwh_helmet_marpatd","rhsusf_lwh_helmet_marpatd_ess","rhsusf_lwh_helmet_marpatd_headset","rhsusf_lwh_helmet_marpatwd","rhsusf_lwh_helmet_marpatwd_blk_ess","rhsusf_lwh_helmet_marpatwd_headset_blk","rhsusf_lwh_helmet_marpatwd_headset","rhsusf_lwh_helmet_marpatwd_ess","rhsusf_mich_bare","rhsusf_mich_bare_alt","rhsusf_mich_bare_headset","rhsusf_mich_bare_norotos","rhsusf_mich_bare_norotos_alt","rhsusf_mich_bare_norotos_alt_headset","rhsusf_mich_bare_norotos_arc","rhsusf_mich_bare_norotos_arc_alt","rhsusf_mich_bare_norotos_arc_alt_headset","rhsusf_mich_bare_norotos_arc_headset","rhsusf_mich_bare_norotos_headset","rhsusf_mich_bare_semi","rhsusf_mich_bare_alt_semi","rhsusf_mich_bare_semi_headset","rhsusf_mich_bare_norotos_semi","rhsusf_mich_bare_norotos_alt_semi","rhsusf_mich_bare_norotos_alt_semi_headset","rhsusf_mich_bare_norotos_arc_semi","rhsusf_mich_bare_norotos_arc_alt_semi","rhsusf_mich_bare_norotos_arc_alt_semi_headset","rhsusf_mich_bare_norotos_arc_semi_headset","rhsusf_mich_bare_norotos_semi_headset","rhsusf_mich_bare_tan","rhsusf_mich_bare_alt_tan","rhsusf_mich_bare_tan_headset","rhsusf_mich_bare_norotos_tan","rhsusf_mich_bare_norotos_alt_tan","rhsusf_mich_bare_norotos_alt_tan_headset","rhsusf_mich_bare_norotos_arc_tan","rhsusf_mich_bare_norotos_arc_alt_tan","rhsusf_mich_bare_norotos_arc_alt_tan_headset","rhsusf_mich_bare_norotos_tan_headset","rhsusf_mich_helmet_marpatd","rhsusf_mich_helmet_marpatd_alt","rhsusf_mich_helmet_marpatd_alt_headset","rhsusf_mich_helmet_marpatd_headset","rhsusf_mich_helmet_marpatd_norotos","rhsusf_mich_helmet_marpatd_norotos_arc","rhsusf_mich_helmet_marpatd_norotos_arc_headset","rhsusf_mich_helmet_marpatd_norotos_headset","rhsusf_mich_helmet_marpatwd","rhsusf_mich_helmet_marpatwd_alt","rhsusf_mich_helmet_marpatwd_alt_headset","rhsusf_mich_helmet_marpatwd_headset","rhsusf_mich_helmet_marpatwd_norotos","rhsusf_mich_helmet_marpatwd_norotos_arc","rhsusf_mich_helmet_marpatwd_norotos_arc_headset","rhsusf_mich_helmet_marpatwd_norotos_headset","rhsusf_protech_helmet","rhsusf_protech_helmet_ess","rhsusf_protech_helmet_rhino","rhsusf_protech_helmet_rhino_ess"];
//lockedMochis = lockedMochis + ["rhsusf_assault_eagleaiii_coy","B_rhsusf_B_BACKPACK","rhsusf_assault_eagleaiii_ocp","rhsusf_assault_eagleaiii_ucp","rhsusf_falconii_coy","rhsusf_falconii_mc","rhsusf_falconii","RHS_M2_Gun_Bag","RHS_M2_Tripod_Bag","rhs_M252_Gun_Bag","rhs_M252_Bipod_Bag","RHS_M2_MiniTripod_Bag","RHS_Mk19_Gun_Bag","RHS_Mk19_Tripod_Bag","rhs_Tow_Gun_Bag","rhs_TOW_Tripod_Bag"];
lamparaMalos = "acc_flashlight";

//allItems = allItems + ["rhsusf_iotv_ocp_Grenadier","rhsusf_iotv_ucp_Grenadier","rhsusf_iotv_ocp_Medic","rhsusf_iotv_ucp_Medic","rhsusf_iotv_ocp","rhsusf_iotv_ocp_Repair","rhsusf_iotv_ucp_Repair","rhsusf_iotv_ocp_Rifleman","rhsusf_iotv_ucp_Rifleman","rhsusf_iotv_ocp_SAW","rhsusf_iotv_ucp_SAW","rhsusf_iotv_ocp_Squadleader","rhsusf_iotv_ucp_Squadleader","rhsusf_iotv_ocp_Teamleader","rhsusf_iotv_ucp_Teamleader","rhsusf_iotv_ucp","rhsusf_spc","rhsusf_spc_corpsman","rhsusf_spc_crewman","rhsusf_spc_iar","rhsusf_spc_light","rhsusf_spc_mg","rhsusf_spc_marksman","rhsusf_spc_patchless","rhsusf_spc_patchless_radio","rhsusf_spc_rifleman","rhsusf_spc_squadleader","rhsusf_spc_teamleader","rhsusf_spcs_ocp","rhsusf_spcs_ocp_rifleman","rhsusf_spcs_ucp_rifleman","rhsusf_spcs_ucp"];