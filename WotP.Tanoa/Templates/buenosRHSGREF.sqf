SDKMortar = "rhsgref_ins_g_2b14";
SDKMortarHEMag = "rhs_mag_3vo18_10";
SDKMortarSmokeMag = "rhs_mag_d832du_10";
SDKMGStatic = "rhsgref_ins_g_DSHKM";
staticATBuenos = "rhsgref_ins_g_d30_at";
staticAABuenos = "rhsgref_ins_g_ZU23";

staticCrewBuenos = "rhsgref_ins_g_militiaman_mosin";
SDKUnarmed = "I_G_Survivor_F";
SDKSniper = ["I_C_Soldier_Bandit_5_F","I_C_Soldier_Para_7_F"];
SDKATman = ["I_C_Soldier_Bandit_2_F","I_C_Soldier_Para_5_F"];
SDKMedic = ["I_C_Soldier_Bandit_1_F","I_C_Soldier_Para_3_F"];
SDKMG = ["I_C_Soldier_Bandit_3_F","I_C_Soldier_Para_4_F"];
SDKExp = ["I_C_Soldier_Bandit_8_F","I_C_Soldier_Para_8_F"];
SDKGL = ["I_C_Soldier_Bandit_6_F","I_C_Soldier_Para_6_F"];
SDKMil = ["I_C_Soldier_Bandit_7_F","I_C_Soldier_Para_1_F"];
SDKSL = ["I_C_Soldier_Bandit_4_F","I_C_Soldier_Para_2_F"];
SDKEng = ["I_G_engineer_F","I_G_engineer_F"];
sdkTier1 = SDKMil + [staticCrewBuenos] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;

vehSDKBike = "I_G_Quadbike_01_F";
vehSDKLightArmed = "rhsgref_ins_g_uaz_dshkm_chdkz";
vehSDKLightUnarmed = "rhsgref_cdf_reg_uaz_open";
vehSDKTruck = "rhsgref_nat_ural_open";
//vehSDKHeli = "rhsgref_ins_g_Mi8amt";
vehSDKPlane = "RHS_AN2";
vehSDKBoat = "I_C_Boat_Transport_01_F";
vehSDKRepair = "rhsgref_ins_g_gaz66_repair";
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
SDKFlag = "Flag_Syndikat_F";

gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];

tipoPetros = "I_C_Soldier_Camo_F";

soporteStaticSDKB = "RHS_DShkM_TripodHigh_Bag";
ATStaticSDKB = "I_AT_01_weapon_F";
MGStaticSDKB = "RHS_DShkM_Gun_Bag";
soporteStaticSDKB2 = "I_HMG_01_support_high_F";
AAStaticSDKB = "I_AA_01_weapon_F";
MortStaticSDKB = "RHS_Podnos_Gun_Bag";
soporteStaticSDKB3 = "RHS_Podnos_Bipod_Bag";

civCar = "C_Offroad_02_unarmed_F";
civTruck = "RHS_Ural_Open_Civ_03";
civHeli = "RHS_Mi8amt_civilian";
civBoat = "C_Boat_Transport_02_F";

arrayCivVeh = arrayCivVeh + ["RHS_Ural_Open_Civ_03","RHS_Ural_Open_Civ_01","RHS_Ural_Open_Civ_02"];

sniperRifle = "rhs_weap_m76_pso";
lamparasSDK = ["rhs_acc_2dpZenit","acc_flashlight"];

ATMineMag = "rhs_mine_tm62m_mag";
APERSMineMag = "rhs_mine_pmn2_mag";


FIARifleman = "rhsgref_cdf_b_ngd_rifleman_lite";
FIAMarksman = "rhsgref_cdf_b_reg_marksman";
vehFIAArmedCar = "rhsgref_cdf_b_reg_uaz_dshkm";
vehFIATruck = "rhsgref_cdf_b_gaz66o";
vehFIACar = "rhsgref_cdf_b_reg_uaz_open";

gruposFIASmall = [["rhsgref_cdf_b_ngd_grenadier","rhsgref_cdf_b_ngd_rifleman_lite"],["rhsgref_cdf_b_reg_marksman","rhsgref_cdf_b_ngd_grenadier"]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
gruposFIAMid = [["rhsgref_cdf_b_ngd_squadleader","rhsgref_cdf_b_ngd_machinegunner","rhsgref_cdf_b_ngd_grenadier_rpg","rhsgref_cdf_b_ngd_grenadier_rpg","rhsgref_cdf_b_ngd_medic"],["rhsgref_cdf_b_ngd_squadleader","rhsgref_cdf_b_ngd_machinegunner","rhsgref_cdf_b_ngd_grenadier","rhsgref_cdf_b_ngd_rifleman","rhsgref_cdf_b_ngd_medic"]];//["IRG_InfAssault","IRG_InfTeam","IRG_InfTeam_AT"];///
FIASquad = ["rhsgref_cdf_b_ngd_squadleader","rhsgref_cdf_b_ngd_machinegunner","rhsgref_cdf_b_ngd_grenadier","rhsgref_cdf_b_ngd_grenadier","rhsgref_cdf_b_ngd_grenadier_rpg","rhsgref_cdf_b_ngd_grenadier_rpg","rhsgref_cdf_b_ngd_machinegunner","rhsgref_cdf_b_ngd_medic"];//"IRG_InfSquad";///


vehPoliceCar = "B_GEN_OFFROAD_01_gen_F";
policeOfficer = "B_GEN_Commander_F";
policeGrunt = "B_GEN_Soldier_F";
gruposNATOGen = [policeOfficer,policeGrunt];