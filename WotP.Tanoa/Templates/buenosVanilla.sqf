SDKMortar = "I_G_Mortar_01_F";
SDKMortarHEMag = "8Rnd_82mm_Mo_shells";
SDKMortarSmokeMag = "8Rnd_82mm_Mo_Smoke_white";
SDKMGStatic = "I_HMG_01_high_F";
staticATBuenos = "I_Static_AT_F";
staticAABuenos = "I_Static_AA_F";

staticCrewBuenos = "I_G_Soldier_unarmed_F";
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
vehSDKLightArmed = "I_G_Offroad_01_armed_F";
vehSDKLightUnarmed = "I_C_Offroad_02_unarmed_F";
vehSDKTruck = "I_C_Van_01_Transport_F";
//vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "I_C_Plane_civil_01_F";
vehSDKBoat = "I_C_Boat_Transport_01_F";
vehSDKRepair = "B_G_Offroad_01_repair_F";
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
SDKFlag = "Flag_Syndikat_F";

gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];

tipoPetros = "I_C_Soldier_Camo_F";

soporteStaticSDKB = "I_HMG_01_support_F";
ATStaticSDKB = "I_AT_01_weapon_F";
MGStaticSDKB = "I_HMG_01_high_weapon_F";
soporteStaticSDKB2 = "I_HMG_01_support_high_F";
AAStaticSDKB = "I_AA_01_weapon_F";
MortStaticSDKB = "I_Mortar_01_weapon_F";
soporteStaticSDKB3 = "I_Mortar_01_support_F";

civCar = "C_Offroad_02_unarmed_F";
civTruck = "C_Van_01_transport_F";
civHeli = "C_Heli_Light_01_civil_F";
civBoat = "C_Boat_Transport_02_F";

sniperRifle = "srifle_DMR_06_camo_F";
lamparasSDK = ["acc_flashlight"];

ATMineMag = "ATMine_Range_Mag";
APERSMineMag = "APERSMine_Range_Mag";

FIARifleman = "B_G_Soldier_F";
FIAMarksman = "B_G_Sharpshooter_F";
vehFIAArmedCar = "B_G_Offroad_01_armed_F";
vehFIATruck = "B_G_van_01_transport_F";
vehFIACar = "B_G_Offroad_01_F";
cfgFIAInf = (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry");
gruposFIASmall = [["B_G_Soldier_GL_F","B_G_Soldier_F"],["B_G_Soldier_M_F","B_G_Soldier_F"],["B_G_Sharpshooter_F","B_G_Soldier_M_F"]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
gruposFIAMid = [["B_G_Soldier_SL_F","B_G_Sharpshooter_F","B_G_Soldier_AR_F","B_G_Soldier_A_F"],["B_G_Soldier_TL_F","B_G_Soldier_AR_F","B_G_Soldier_GL_F","B_G_Soldier_LAT_F"],["B_G_Soldier_TL_F","B_G_Soldier_LAT_F","B_G_Soldier_LAT_F","B_G_Soldier_LAT_F"]];//["IRG_InfAssault","IRG_InfTeam","IRG_InfTeam_AT"];///
FIASquad = ["B_G_soldier_SL_F","B_G_soldier_F","B_G_soldier_LAT_F","B_G_Soldier_M_F","B_G_soldier_TL_F","B_G_soldier_AR_F","B_G_Soldier_A_F","B_G_medic_F"];//"IRG_InfSquad";///


vehPoliceCar = "B_GEN_OFFROAD_01_gen_F";
policeOfficer = "B_GEN_Commander_F";
policeGrunt = "B_GEN_Soldier_F";
gruposNATOGen = [policeOfficer,policeGrunt];