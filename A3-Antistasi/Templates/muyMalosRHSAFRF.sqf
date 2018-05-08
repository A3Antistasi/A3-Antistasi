CSATGrunt = "rhs_vmf_flora_rifleman";
CSATOfficer = "rhs_vmf_flora_officer";
CSATBodyG = "rhs_vmf_recon_efreitor";
CSATCrew = "rhs_vmf_flora_armoredcrew";
CSATMarksman = "rhs_vmf_flora_marksman";
staticCrewMuyMalos = "rhs_vmf_flora_rifleman_lite";
CSATPilot = "rhs_pilot_tan";

CSATMortar = "rhs_2b14_82mm_vmf";
CSATMG = "rhs_KORD_high_VMF";
staticATmuyMalos = "rhs_Kornet_9M133_2_vmf";

vehCSATLightArmed = ["rhsgref_BRDM2_vdv","rhsgref_BRDM2_HQ_vdv","rhsgref_BRDM2_ATGM_vdv","rhs_tigr_sts_vdv"];
vehCSATLightUnarmed = ["rhs_tigr_vdv","rhs_uaz_vdv"];
vehCSATTrucks = ["rhs_kamaz5350_vdv","rhs_kamaz5350_open_vdv","RHS_Ural_Open_VDV_01","rhs_gaz66_vdv"];
vehCSATAmmoTruck = "rhs_gaz66_ammo_vmf";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
vehCSATAPC = ["rhs_bmp2d_vdv","rhs_bmp1p_vdv"];
vehCSATTank = "rhs_sprut_vdv";
vehCSATAA = "rhs_zsu234_aa";
vehCSATAttack = vehCSATAPC + [vehCSATTank];
vehCSATBoat = "O_T_Boat_Armed_01_hmg_F";
vehCSATRBoat = "O_T_Boat_Transport_01_F";
vehCSATBoats = [vehCSATBoat,vehCSATRBoat,"rhs_btr80a_vdv"];
vehCSATPlane = "RHS_Su25SM_CAS_vvs";
vehCSATPlaneAA = "RHS_T50_vvs_051";
vehCSATPatrolHeli = "rhs_ka60_c";
vehCSATTransportHelis = ["RHS_Mi8mt_vdv","RHS_Mi8mt_vv","RHS_Mi8mt_Cargo_vv",vehCSATPatrolHeli];
vehCSATAttackHelis = ["RHS_Mi24V_vdv","RHS_Mi8MTV3_FAB_vdv"];
vehCSATAir = vehCSATTransportHelis + vehCSATAttackHelis + [vehCSATPlane,vehCSATPlaneAA];
vehCSATUAV = "O_UAV_02_F";
vehCSATUAVSmall = "O_UAV_01_F";
vehCSATMRLS = "rhs_2s3_tv";
vehCSATMRLSMags = "rhs_mag_HE_2a33";
vehCSATNormal = vehCSATLight + vehCSATTrucks + [vehCSATAmmoTruck, "rhs_gaz66_repair_vdv","RHS_Ural_Fuel_VDV_01"];
vehCSATBike = "O_T_Quadbike_01_ghex_F";

CSATFlag = "rhs_Flag_Russia_F";
//cfgCSATInf = (configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry");
gruposCSATSentry = ["rhs_vdv_efreitor","rhs_vdv_rifleman"];///"O_T_InfSentry";///
gruposCSATSniper = ["rhs_vdv_marksman_asval","rhs_vdv_rifleman_asval"];
gruposCSATsmall = [gruposCSATSentry,["rhs_vdv_recon_rifleman_scout_akm","rhs_vdv_recon_rifleman_scout_akm"],gruposCSATSniper];///[gruposCSATSentry,"O_T_reconSentry","O_T_SniperTeam"];///
gruposCSATAA = ["rhs_vdv_flora_junior_sergeant","rhs_vdv_flora_aa","rhs_vdv_flora_aa","rhs_vdv_flora_aa"];
gruposCSATAT = ["rhs_vdv_flora_junior_sergeant","rhs_vdv_flora_at","rhs_vdv_flora_strelok_rpg_assist","rhs_vdv_flora_LAT"];
gruposCSATmid = [["rhs_vdv_flora_efreitor","rhs_vdv_flora_rifleman","rhs_vdv_flora_rifleman","rhs_vdv_flora_medic"],gruposCSATAA,gruposCSATAT];///["O_T_InfTeam","O_T_InfTeam_AA","O_T_InfTeam_AT"];///
CSATSquad = ["rhs_vdv_mflora_sergeant","rhs_vdv_mflora_junior_sergeant","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_machinegunner","rhs_vdv_mflora_at","rhs_vdv_mflora_strelok_rpg_assist","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_medic"];///"O_T_InfSquad";///
CSATSpecOp = ["rhs_vmf_recon_sergeant","rhs_vmf_recon_efreitor","rhs_vmf_recon_arifleman","rhs_vmf_recon_machinegunner_assistant","rhs_vmf_recon_grenadier","rhs_vdv_recon_medic"];///(configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "SpecOps" >> "O_T_ViperTeam");///
gruposCSATSquad = [CSATSquad,["rhs_vdv_mflora_sergeant","rhs_vdv_mflora_junior_sergeant","rhs_vdv_mflora_machinegunner","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_marksman","rhs_vdv_mflora_machinegunner_assistant","rhs_vdv_mflora_LAT","rhs_vdv_mflora_medic"]];//[CSATSquad,"O_T_InfSquad_Weapons"];///

soporteStaticCSATB = "RHS_Kord_Tripod_Bag";
ATStaticCSATB = "RHS_Kornet_Gun_Bag";
MGStaticCSATB = "RHS_Kord_Gun_Bag";
soporteStaticCSATB2 = "RHS_Kornet_Tripod_Bag";
AAStaticCSATB = "O_AA_01_weapon_F";
MortStaticCSATB = "RHS_Podnos_Gun_Bag";
soporteStaticCSATB3 = "RHS_Podnos_Bipod_Bag";

armasCSAT = ["rhs_weap_ak103","rhs_weap_ak104_npz","rhs_weap_ak105_npz","arifle_AK12_F","arifle_AK12_GL_F","rhs_weap_ak74_2","rhs_weap_ak74_gp25","rhs_weap_ak74m_2mag","rhs_weap_ak74m_gp25_1p29","rhs_weap_ak74n_gp25","rhs_weap_akm","rhs_weap_akm_gp25","rhs_weap_asval","rhs_weap_svdp","rhs_weap_svds","rhs_weap_t5000","rhs_weap_vss","rhs_weap_aks74u","rhs_weap_rpg26","rhs_weap_rpg7","hgun_Pistol_heavy_01_F","rhs_weap_igla","rhs_weap_pya","rhs_weap_pkm","rhs_weap_pkp","rhs_weap_makarov_pm","rhs_weap_rpg7_pgo","rhs_weap_rshg2"];
municionCSAT = [];
{
_nombre = [_x] call BIS_fnc_baseWeapon;
_magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
municionCSAT pushBack (_magazines select 0);
} forEach armasCSAT;
humo = humo + ["rhs_mag_nspd","rhs_mag_nspn_yellow","rhs_mag_nspn_red","rhs_mag_nspn_green","rhs_mag_rdg2_white","rhs_mag_rdg2_black"];
NVGoggles = NVGoggles + ["rhs_1PN138"];
opticasAAF = opticasAAF + ["rhs_acc_1p29","rhs_acc_1p63","rhs_acc_rakursPM","rhs_acc_1p78","rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_dh520x56","rhs_acc_ekp1","rhs_acc_pgo7v","rhs_acc_pgo7v2","rhs_acc_pgo7v3","rhs_acc_pkas","rhs_acc_pso1m2","rhs_acc_pso1m21"];
itemsAAF = itemsAAF + ["rhs_acc_2dpZenit","rhs_acc_2dpZenit_ris","rhs_acc_uuk","rhs_acc_dtk1l","rhs_acc_ak5","rhs_acc_dtk","rhs_acc_dtk1983","rhs_acc_dtk1","rhs_acc_dtk1p","rhs_acc_dtk2","rhs_acc_dtk3","rhs_acc_dtk4short","rhs_acc_dtk4screws","rhs_acc_dtk4long","rhs_item_flightrecorder","rhs_acc_pbs1","rhs_acc_pbs4","rhs_acc_perst1ik","rhs_acc_perst1ik_ris","rhs_acc_perst3","rhs_acc_perst3_top","rhs_acc_perst3_2dp_h","rhs_acc_perst3_2dp_light_h","rhs_acc_pgs64","rhs_acc_pgs64_74u","rhs_acc_pgs64_74un","rhs_acc_grip_rk2","rhs_acc_grip_rk6","rhs_acc_tgpa","rhs_acc_tgpv"];
//cascos = cascos + ["rhs_6b26_green","rhs_6b26_ess_green","rhs_6b26_ess_bala_green","rhs_6b26_bala_green","rhs_6b26","rhs_6b26_ess","rhs_6b26_ess_bala","rhs_6b26_bala","rhs_6b27m_green","rhs_6b27m_green_ess","rhs_6b27m_green_ess_bala","rhs_6b27m_green_bala","rhs_6b27m_digi","rhs_6b27m_digi_ess","rhs_6b27m_digi_ess_bala","rhs_6b27m_digi_bala","rhs_6b27m","rhs_6b27m_ess","rhs_6b27m_ess_bala","rhs_6b27m_bala","rhs_6b27m_ml","rhs_6b27m_ML_ess_bala","rhs_6b27m_ml_bala","rhs_6b27m_ml_ess","rhs_6b28_green","rhs_6b28_green_ess","rhs_6b28_green_ess_bala","rhs_6b28_green_bala","rhs_6b28","rhs_6b28_ess","rhs_6b28_ess_bala","rhs_6b28_bala","rhs_6b28_flora","rhs_6b28_flora_ess","rhs_6b28_flora_ess_bala","rhs_6b28_flora_bala","rhs_6b47","rhs_6b47_bala","rhs_6b47_ess","rhs_6b47_ess_bala","rhs_6b7_1m","rhs_6b7_1m_bala1","rhs_6b7_1m_bala2","rhs_6b7_1m_emr","rhs_6b7_1m_bala1_emr","rhs_6b7_1m_bala2_emr","rhs_6b7_1m_emr_ess","rhs_6b7_1m_emr_ess_bala","rhs_6b7_1m_ess","rhs_6b7_1m_ess_bala","rhs_6b7_1m_flora","rhs_6b7_1m_bala1_flora","rhs_6b7_1m_bala2_flora","rhs_6b7_1m_flora_ns3","rhs_6b7_1m_olive","rhs_6b7_1m_bala1_olive","rhs_6b7_1m_bala2_olive","rhs_altyn_novisor","rhs_altyn_novisor_bala","rhs_altyn_novisor_ess","rhs_altyn_novisor_ess_bala","rhs_altyn_visordown","rhs_altyn","rhs_altyn_bala","rhs_ssh68","rhs_tsh4","rhs_tsh4_ess","rhs_tsh4_ess_bala","rhs_tsh4_bala","rhs_zsh7a_mike","rhs_zsh7a_mike_alt","rhs_zsh7a_mike_green","rhs_zsh7a_mike_green_alt","rhs_zsh7a","rhs_zsh7a_alt"];
//lockedMochis = lockedMochis + ["RHS_Podnos_Bipod_Bag","RHS_Podnos_Gun_Bag","RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag","RHS_Kornet_Gun_Bag","RHS_Kornet_Tripod_Bag","RHS_AGS30_Tripod_Bag","RHS_AGS30_Gun_Bag","RHS_DShkM_Gun_Bag","RHS_DShkM_TripodHigh_Bag","RHS_DShkM_TripodLow_Bag","RHS_Kord_Tripod_Bag","RHS_Kord_Gun_Bag","rhs_medic_bag","RHS_NSV_Tripod_Bag","RHS_NSV_Gun_Bag","rhs_sidor","RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"];
lamparaMuyMalos = "rhs_acc_2dpZenit";
flagCSATmrk = "rhs_flag_vmf";
squadLeaders pushBack "rhs_vdv_mflora_sergeant";
//allItems = allItems + ["rhs_6b13_Flora","rhs_6b13_Flora_6sh92","rhs_6b13_Flora_6sh92_headset_mapcase","rhs_6b13_Flora_6sh92_radio","rhs_6b13_Flora_6sh92_vog","rhs_6b13_Flora_crewofficer","rhs_6b13_EMR_6sh92","rhs_6b13_EMR_6sh92_headset_mapcase","rhs_6b13_EMR_6sh92_radio","rhs_6b13_EMR_6sh92_vog","rhs_6b13_EMR","rhs_6b13","rhs_6b13_6sh92","rhs_6b13_6sh92_headset_mapcase","rhs_6b13_6sh92_radio","rhs_6b13_6sh92_vog","rhs_6b13_crewofficer","rhs_6b23","rhs_6b23_6sh116_od","rhs_6b23_6sh116_vog_od","rhs_6b23_6sh92","rhs_6b23_6sh92_headset","rhs_6b23_6sh92_headset_mapcase","rhs_6b23_6sh92_radio","rhs_6b23_6sh92_vog","rhs_6b23_6sh92_vog_headset","rhs_6b23_sniper","rhs_6b23_rifleman","rhs_6b23_engineer","rhs_6b23_medic","rhs_6b23_crewofficer","rhs_6b23_crew","rhs_6b23_vydra_3m","rhs_6b23_digi_6sh92_spetsnaz2","rhs_6b23_digi_6sh92_Vog_Spetsnaz","rhs_6b23_digi","rhs_6b23_6sh116","rhs_6b23_6sh116_vog","rhs_6b23_digi_6sh92","rhs_6b23_digi_6sh92_headset","rhs_6b23_digi_6sh92_headset_spetsnaz","rhs_6b23_digi_6sh92_headset_mapcase","rhs_6b23_digi_6sh92_radio","rhs_6b23_digi_6sh92_Spetsnaz","rhs_6b23_digi_6sh92_vog","rhs_6b23_digi_6sh92_vog_headset","rhs_6b23_digi_6sh92_Vog_Radio_Spetsnaz","rhs_6b23_digi_sniper","rhs_6b23_digi_engineer","rhs_6b23_digi_medic","rhs_6b23_digi_crewofficer","rhs_6b23_digi_crew","rhs_6b23_digi_vydra_3m","rhs_6b23_digi_rifleman","rhs_6b23_6sh116_flora","rhs_6b23_6sh116_vog_flora","rhs_6b23_ML","rhs_6b23_ML_6sh92","rhs_6b23_ML_6sh92_headset","rhs_6b23_ML_6sh92_headset_mapcase","rhs_6b23_ML_6sh92_radio","rhs_6b23_ML_6sh92_vog","rhs_6b23_ML_6sh92_vog_headset","rhs_6b23_ML_sniper","rhs_6b23_ML_rifleman","rhs_6b23_ML_engineer","rhs_6b23_ML_medic","rhs_6b23_ML_crewofficer","rhs_6b23_ML_crew","rhs_6b23_ML_vydra_3m","rhs_6b43","rhs_6sh46","rhs_6sh92","rhs_6sh92_headset","rhs_6sh92_radio","rhs_6sh92_vog","rhs_6sh92_vog_headset","rhs_6sh92_digi","rhs_6sh92_digi_headset","rhs_6sh92_digi_radio","rhs_6sh92_digi_vog","rhs_6sh92_digi_vog_headset","rhs_6sh92_vsr","rhs_6sh92_vsr_headset","rhs_6sh92_vsr_radio","rhs_6sh92_vsr_vog","rhs_6sh92_vsr_vog_headset","rhs_vydra_3m"];