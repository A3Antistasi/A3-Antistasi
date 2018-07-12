SDKMortar = "B_G_Mortar_01_F";
SDKMortarHEMag = "8Rnd_82mm_Mo_shells";
SDKMortarSmokeMag = "8Rnd_82mm_Mo_Smoke_white";
SDKMGStatic = "B_HMG_01_high_F";
staticATBuenos = "B_Static_AT_F";
staticAABuenos = "B_Static_AA_F";

staticCrewBuenos = "B_G_Soldier_unarmed_F";
SDKUnarmed = "B_G_Survivor_F";
SDKSniper = ["B_G_Soldier_M_F","B_G_Sharpshooter_F"];
SDKATman = ["B_G_Soldier_LAT2_F","B_G_Soldier_LAT_F"];
SDKMedic = ["B_G_medic_F","B_G_medic_F"];
SDKMG = ["B_G_Soldier_AR_F","B_G_Soldier_AR_F"];
SDKExp = ["B_G_Soldier_exp_F","B_G_Soldier_exp_F"];
SDKGL = ["B_G_Soldier_GL_F","B_G_Soldier_GL_F"];
SDKMil = ["B_G_Soldier_lite_F","B_G_Soldier_lite_F"];
SDKSL = ["B_G_Soldier_SL_F","B_G_Soldier_SL_F"];
SDKEng = ["B_G_engineer_F","B_G_engineer_F"];
sdkTier1 = SDKMil + [staticCrewBuenos] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;

vehSDKBike = "B_G_Quadbike_01_F";
vehSDKLightArmed = "B_G_Offroad_01_armed_F";
vehSDKAT = "B_G_Offroad_01_AT_F";
vehSDKLightUnarmed = "B_G_Offroad_01_F";
vehSDKTruck = "B_G_Van_01_transport_F";
//vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "C_Plane_Civil_01_F";
vehSDKBoat = "B_G_Boat_Transport_01_F";
vehSDKRepair = "B_G_Offroad_01_repair_F";
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
SDKFlag = "Flag_FIA_F";

gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];

tipoPetros = "B_G_officer_F";

soporteStaticSDKB = "B_HMG_01_support_F";
ATStaticSDKB = "B_AT_01_weapon_F";
MGStaticSDKB = "B_HMG_01_high_weapon_F";
soporteStaticSDKB2 = "B_HMG_01_support_high_F";
AAStaticSDKB = "B_AA_01_weapon_F";
MortStaticSDKB = "B_Mortar_01_weapon_F";
soporteStaticSDKB3 = "B_Mortar_01_support_F";

civCar = "C_Offroad_01_F";
civTruck = "C_Van_01_transport_F";
civHeli = "C_Heli_Light_01_civil_F";
civBoat = "C_Boat_Transport_02_F";

sniperRifle = "srifle_DMR_06_camo_F";
lamparasSDK = ["acc_flashlight"];

ATMineMag = "ATMine_Range_Mag";
APERSMineMag = "APERSMine_Range_Mag";

banditUniforms = [];
uniformsSDK = [];
{
_unit = _x select 0;
_uniform = (getUnitLoadout _unit select 3) select 0;
banditUniforms pushBackUnique _uniform;
uniformsSDK pushBackUnique _uniform;
if (count _x > 1) then
	{
	_unit = _x select 1;
	_uniform = (getUnitLoadout _unit select 3) select 0;
	uniformsSDK pushBackUnique _uniform;
	};
} forEach [SDKSniper,SDKATman,SDKMedic,SDKMG,SDKExp,SDKGL,SDKMil,SDKSL,SDKEng,[SDKUnarmed],[staticCrewBuenos]];

FIARifleman = "I_C_Soldier_Para_7_F";
FIAMarksman = "I_C_Soldier_Para_2_F";
vehFIAArmedCar = "I_C_Offroad_02_LMG_F";
vehFIATruck = "I_C_Van_01_transport_F";
vehFIACar = "I_C_Offroad_02_unarmed_F";
gruposFIASmall = [["I_C_Soldier_Para_6_F",FIARifleman],[FIAMarksman,FIARifleman],[FIAMarksman,FIAMarksman]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
gruposFIAMid = [["I_C_Soldier_Para_2_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F"],["I_C_Soldier_Para_2_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_5_F"]];
FIASquad = ["I_C_Soldier_Para_2_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_8_F","I_C_Soldier_Para_3_F"];//"IRG_InfSquad";///
gruposFIASquad = [FIASquad];
factionFIA = "IND_C_F";

vehPoliceCar = vehFIACar;
policeOfficer = FIARifleman;
policeGrunt = FIARifleman;
gruposNATOGen = [policeOfficer,policeGrunt];
nameBuenos = "FIA";

factionGEN = "IND_C_F";