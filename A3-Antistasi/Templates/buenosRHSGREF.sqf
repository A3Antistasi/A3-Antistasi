SDKMortar = "rhsgref_ins_g_2b14";
SDKMortarHEMag = "rhs_mag_3vo18_10";
SDKMortarSmokeMag = "rhs_mag_d832du_10";
SDKMGStatic = "rhsgref_ins_g_DSHKM";
staticATBuenos = "rhsgref_ins_g_d30_at";
staticAABuenos = "rhsgref_ins_g_ZU23";

staticCrewBuenos = "rhsgref_ins_g_militiaman_mosin";
SDKUnarmed = "I_G_Survivor_F";
SDKSniper = ["rhsgref_nat_hunter","rhsgref_nat_pmil_hunter"];
SDKATman = ["rhsgref_nat_grenadier_rpg","rhsgref_nat_pmil_grenadier_rpg"];
SDKMedic = ["rhsgref_ins_g_medic","rhsgref_cdf_ngd_medic"];
SDKMG = ["rhsgref_ins_g_machinegunner","rhsgref_cdf_ngd_machinegunner"];
SDKExp = ["rhsgref_nat_pmil_saboteur","rhsgref_ins_g_saboteur"];
SDKGL = ["rhsgref_nat_pmil_grenadier","rhsgref_ins_g_grenadier"];
SDKMil = ["rhsgref_nat_militiaman_kar98k","rhsgref_nat_rifleman_akms"];
SDKSL = ["rhsgref_nat_pmil_commander","rhsgref_nat_commander"];
SDKEng = ["rhsgref_ins_g_engineer","rhsgref_cdf_ngd_engineer"];
sdkTier1 = SDKMil + [staticCrewBuenos] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;

vehSDKBike = "I_G_Quadbike_01_F";
vehSDKLightArmed = "rhsgref_ins_g_uaz_dshkm_chdkz";
vehSDKAT = "rhsgref_nat_uaz_spg9";
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

tipoPetros = "rhsgref_ins_g_squadleader";

soporteStaticSDKB = "RHS_DShkM_TripodHigh_Bag";
ATStaticSDKB = "I_AT_01_weapon_F";
MGStaticSDKB = "RHS_DShkM_Gun_Bag";
soporteStaticSDKB2 = "I_HMG_01_support_high_F";
AAStaticSDKB = "I_AA_01_weapon_F";
MortStaticSDKB = "RHS_Podnos_Gun_Bag";
soporteStaticSDKB3 = "RHS_Podnos_Bipod_Bag";

civCar = "C_Offroad_01_F";
civTruck = "RHS_Ural_Open_Civ_03";
civHeli = "RHS_Mi8amt_civilian";
civBoat = "C_Boat_Transport_02_F";

arrayCivVeh = arrayCivVeh + ["RHS_Ural_Open_Civ_03","RHS_Ural_Open_Civ_01","RHS_Ural_Open_Civ_02"];

sniperRifle = "rhs_weap_m76_pso";
lamparasSDK = ["rhs_acc_2dpZenit","acc_flashlight"];

ATMineMag = "rhs_mine_tm62m_mag";
APERSMineMag = "rhs_mine_pmn2_mag";

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
	FIARifleman = "rhsgref_hidf_rifleman";
	FIAMarksman = "rhsgref_hidf_marksman";
	vehFIAArmedCar = "rhsgref_hidf_m1025_m2";
	vehFIATruck = "rhsgref_cdf_b_ural_open";
	vehFIACar = "rhsgref_hidf_m998_4dr";

	gruposFIASmall = [["rhsgref_hidf_grenadier","rhsgref_hidf_rifleman"],["rhsgref_hidf_marksman","rhsgref_hidf_rifleman"]];//["IRG_InfSentry","IRG_ReconSentry","IRG_SniperTeam_M"];///
	gruposFIAMid = [["rhsgref_hidf_teamleader","rhsgref_hidf_machinegunner","rhsgref_hidf_machinegunner_assist","rhsgref_hidf_grenadier"],["rhsgref_hidf_teamleader","rhsgref_hidf_rifleman_m72","rhsgref_hidf_rifleman_m72","rhsgref_hidf_grenadier"]];//["IRG_InfAssault","IRG_InfTeam","IRG_InfTeam_AT"];///
	FIASquad = ["rhsgref_hidf_squadleader","rhsgref_hidf_machinegunner","rhsgref_hidf_machinegunner_assist","rhsgref_hidf_rifleman","rhsgref_hidf_rifleman_m72","rhsgref_hidf_rifleman_m72","rhsgref_hidf_grenadier","rhsgref_hidf_medic"];//"IRG_InfSquad";///
	gruposFIASquad = [FIASquad];
	};

vehPoliceCar = "B_GEN_OFFROAD_01_gen_F";
policeOfficer = "B_GEN_Commander_F";
policeGrunt = "B_GEN_Soldier_F";
gruposNATOGen = [policeOfficer,policeGrunt];
nameBuenos = "ChDKZ";

factionGEN = "BLU_GEN_F";
factionFIA = "rhsgref_faction_hidf";