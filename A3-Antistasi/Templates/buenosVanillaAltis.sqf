if (side petros == west) exitWith {call compile preProcessFileLineNumbers "Templates\buenosVanillaAltisB.sqf"};
SDKMortar = "I_G_Mortar_01_F";
SDKMortarHEMag = "8Rnd_82mm_Mo_shells";
SDKMortarSmokeMag = "8Rnd_82mm_Mo_Smoke_white";
SDKMGStatic = "I_HMG_01_high_F";
staticATBuenos = "I_Static_AT_F";
staticAABuenos = "I_Static_AA_F";

staticCrewBuenos = "I_G_Soldier_unarmed_F";
SDKUnarmed = "I_G_Survivor_F";
SDKSniper = ["I_G_Sharpshooter_F","I_ghillie_ard_F"];
SDKATman = ["I_G_Soldier_LAT2_F","I_Soldier_LAT2_F"];
SDKMedic = ["I_G_medic_F","I_medic_F"];
SDKMG = ["I_G_Soldier_AR_F","I_Soldier_AR_F"];
SDKExp = ["I_G_Soldier_exp_F","I_Soldier_exp_F"];
SDKGL = ["I_G_Soldier_GL_F","I_Soldier_GL_F"];
SDKMil = ["I_G_Soldier_lite_F","I_Soldier_lite_F"];
SDKSL = ["I_G_Soldier_SL_F","I_Soldier_SL_F"];
SDKEng = ["I_G_engineer_F","I_engineer_F"];
sdkTier1 = SDKMil + [staticCrewBuenos] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;

vehSDKBike = "I_G_Quadbike_01_F";
vehSDKLightArmed = "I_G_Offroad_01_armed_F";
vehSDKAT = "I_G_Offroad_01_AT_F";
vehSDKLightUnarmed = "I_G_Offroad_01_F";
vehSDKTruck = "I_G_Van_01_transport_F";
//vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "I_C_Plane_civil_01_F";
vehSDKBoat = "I_G_Boat_Transport_01_F";
vehSDKRepair = "I_G_Offroad_01_repair_F";
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
SDKFlag = "Flag_Altis_F";

gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];

tipoPetros = "I_G_officer_F";

soporteStaticSDKB = "I_HMG_01_support_F";
ATStaticSDKB = "I_AT_01_weapon_F";
MGStaticSDKB = "I_HMG_01_high_weapon_F";
soporteStaticSDKB2 = "I_HMG_01_support_high_F";
AAStaticSDKB = "I_AA_01_weapon_F";
MortStaticSDKB = "I_Mortar_01_weapon_F";
soporteStaticSDKB3 = "I_Mortar_01_support_F";

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

if (hayFFAA) then
	{
	call compile preProcessFileLineNumbers "Templates\malosFFAA.sqf"
	}
else
	{
	FIARifleman = "B_Soldier_lite_F";
	FIAMarksman = "B_soldier_M_F";
	vehFIAArmedCar = "B_LSV_01_armed_F";
	vehFIATruck = "B_Truck_01_transport_F";
	vehFIACar = "B_LSV_01_unarmed_F";
	gruposFIASmall = [["B_Soldier_GL_F",FIARifleman],[FIAMarksman,FIARifleman],["B_Sharpshooter_F","B_soldier_M_F"]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
	gruposFIAMid = [["B_Soldier_TL_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F"],["B_Soldier_TL_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_LAT2_F"],["B_Soldier_TL_F","B_soldier_AR_F","B_soldier_AAA_F","B_soldier_AA_F"]];
	FIASquad = ["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_Soldier_lite_F","B_Soldier_lite_F","B_soldier_M_F","B_soldier_LAT2_F","B_medic_F"];//"IRG_InfSquad";///
	gruposFIASquad = [FIASquad,["B_Soldier_TL_F","B_support_AMG_F","B_Soldier_GL_F","B_Soldier_lite_F","B_support_MG_F","B_soldier_M_F","B_soldier_LAT2_F","B_medic_F"]];
	factionFIA = "";
	};

vehPoliceCar = "B_GEN_OFFROAD_01_gen_F";
policeOfficer = "B_GEN_Commander_F";
policeGrunt = "B_GEN_Soldier_F";
gruposNATOGen = [policeOfficer,policeGrunt];
nameBuenos = if (worldName == "Tanoa") then {"SDK"} else {"FIA"};

factionGEN = "BLU_GEN_F";