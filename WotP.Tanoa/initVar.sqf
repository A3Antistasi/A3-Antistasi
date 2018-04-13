//Antistasi var settings
//If some setting can be modified it will be commented with a // after it.
//Make changes at your own risk!!
//You do not have enough balls to make any modification and after making a Bug report because something is wrong. You don't wanna be there. Believe me.
//Not commented lines cannot be changed.
//Don't touch them.

antistasiVersion = "v 0.12.1";

servidoresOficiales = ["WotP Official USA"];

debug = false;//debug variable, not useful for everything..

cleantime = 3600;//time to delete dead bodies, vehicles etc..
distanciaSPWN = 1000;//initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
distanciaSPWN1 = 1300;
distanciaSPWN2 = 500;
musicON = if (isMultiplayer) then {false} else {true};
//civPerc = 0.10;//initial % civ spawn rate
civPerc = 35;
posHQ = getMarkerPos "respawn_guerrila";
autoHeal = false;
//allowPlayerRecruit = true;
recruitCooldown = 0;
savingClient = false;
incomeRep = false;
zoneCheckInProgress = false;
distanciaMiss = 2500;
minMags = 20;
minWeaps = 24;
minPacks = 20;
minItems = 20;
minOptics = 12;
maxUnits = 140;
//fpsAv = 0;

buenos = independent;
malos = west;
muyMalos = east;

colorBuenos = "colorGUER";
colorMalos = "colorBLUFOR";
colorMuyMalos = "colorOPFOR";

allMagazines = [];
_cfgmagazines = configFile >> "cfgmagazines";
for "_i" from 0 to (count _cfgMagazines) -1 do
	{
	_magazine = _cfgMagazines select _i;
	if (isClass _magazine) then
		{
		_nombre = configName (_magazine);
		allMagazines pushBack _nombre;
		};
	};

arifles = [];
srifles = [];
mguns = [];
hguns = [];
mlaunchers = [];
rlaunchers = [];
cascos = [];
//vests = [];

hayRHS = false;

//lockedWeapons = ["Rangefinder","Laserdesignator"];

_allPrimaryWeapons = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 1 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allHandGuns = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 2 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allLaunchers = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 4 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allItems = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 131072 } } )
" configClasses ( configFile >> "cfgWeapons" );

primaryMagazines = [];
_yaMetidos = [];
{
_nombre = configName _x;
_nombre = [_nombre] call BIS_fnc_baseWeapon;
if (not(_nombre in _yaMetidos)) then
	{
	_magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
	primaryMagazines pushBack (_magazines select 0);
	_yaMetidos pushBack _nombre;
	_weapon = [_nombre] call BIS_fnc_itemType;
	_weaponType = _weapon select 1;
	switch (_weaponType) do
		{
		case "AssaultRifle": {arifles pushBack _nombre};
		case "MachineGun": {mguns pushBack _nombre};
		case "SniperRifle": {srifles pushBack _nombre};
		case "Handgun": {hguns pushBack _nombre};
		case "MissileLauncher": {mlaunchers pushBack _nombre};
		case "RocketLauncher": {rlaunchers pushBack _nombre};
		case "Headgear": {cascos pushBack _nombre};
		//case "Vest": {vests pushBack _nombre};
		};

	};
} forEach _allPrimaryWeapons + _allHandGuns + _allLaunchers + _allItems;

cascos = cascos select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") > 2};
//vests = vests select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor") > 5};
activeAFRF = false;
activeUSAF = false;
activeGREF = false;
hayFFAA = false;

if ("rhs_weap_akms" in arifles) then {activeAFRF = true; hayRHS = true};
if ("ffaa_armas_hkg36k_normal" in arifles) then {hayFFAA = true};
if ("rhs_weap_m4a1_d" in arifles) then {activeUSAF = true; hayRHS = true};
if ("rhs_weap_m92" in arifles) then {activeGREF = true; hayRHS = true} else {mguns pushBack "LMG_Mk200_BI_F"};

//allItems = [];
humo = ["SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellBlue","SmokeShellYellow","SmokeShellPurple","SmokeShellOrange"];
titanLaunchers = if (!hayRHS) then {["launch_B_Titan_F","launch_I_Titan_F","launch_O_Titan_ghex_F","launch_O_Titan_F","launch_B_Titan_tna_F"]} else {[]};
antitanqueAAF = if (!hayRHS) then {["launch_I_Titan_F","launch_I_Titan_short_F"]} else {[]};//possible Titan weapons that spawn in  ammoboxes
MantitanqueAAF = if (!hayRHS) then {["Titan_AT", "Titan_AP", "Titan_AA"]} else {[]};//possible Titan rockets that spawn in  ammoboxes
minasAAF = if (!hayRHS) then {["SLAMDirectionalMine_Wire_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag", "ATMine_Range_Mag","APERSTripMine_Wire_Mag","APERSMine_Range_Mag", "APERSBoundingMine_Range_Mag"]} else {["rhsusf_m112_mag","rhsusf_mine_m14_mag","rhs_mine_M19_mag","rhs_mine_tm62m_mag","rhs_mine_pmn2_mag"]};//possible mines that spawn in AAF ammoboxescomment "Exported from Arsenal by Alberto";
itemsAAF = if (!hayRHS) then {["FirstAidKit","Medikit","MineDetector","NVGoggles","ToolKit","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_acp","bipod_03_F_oli","muzzle_snds_338_green","muzzle_snds_93mmg_tan","Rangefinder","Laserdesignator","ItemGPS","acc_pointer_IR","ItemRadio"]} else {["FirstAidKit","Medikit","MineDetector","ToolKit","ItemGPS","acc_pointer_IR","ItemRadio"]};//possible items that spawn in AAF ammoboxes
NVGoggles = ["NVGoggles_OPFOR","NVGoggles_INDEP","O_NVGoggles_hex_F","O_NVGoggles_urb_F","O_NVGoggles_ghex_F","NVGoggles_tna_F"/*,"NVGogglesB_blk_F","NVGogglesB_grn_F"/*,"NVGogglesB_gry_F"*/,"NVGoggles"];
opticasAAF = if (!hayRHS) then {["optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_SOS","optic_MRCO","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","optic_Arco_blk_F","optic_Arco_ghex_F","optic_DMS_ghex_F","optic_Hamr_khk_F","optic_ERCO_blk_F","optic_ERCO_khk_F","optic_ERCO_snd_F","optic_SOS_khk_F","optic_LRPS_tna_F","optic_LRPS_ghex_F","optic_Holosight_blk_F","optic_Holosight_khk_F","optic_Holosight_smg_blk_F"]} else {[]};
//cascos = ["H_HelmetB","H_HelmetB_camo","H_HelmetB_light","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetSpecB_snakeskin","H_HelmetSpecB_sand","H_HelmetIA","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_HelmetCrew_B","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_RacingHelmet_1_F","H_RacingHelmet_2_F","H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_red_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_RacingHelmet_1_orange_F","H_Helmet_Skate","H_HelmetB_TI_tna_F","H_HelmetO_ViperSP_hex_F","H_HelmetO_ViperSP_ghex_F","H_HelmetB_tna_F","H_HelmetB_Enh_tna_F","H_HelmetB_Light_tna_F","H_HelmetSpecO_ghex_F","H_HelmetLeaderO_ghex_F","H_HelmetO_ghex_F","H_HelmetCrew_O_ghex_F","H_HelmetB_paint","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetIA_net","H_HelmetIA_camo"];


arrayCivVeh =["C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F","C_Truck_02_transport_F","C_Truck_02_covered_F","C_Offroad_02_unarmed_F","I_C_Van_02_transport_F"];//possible civ vehicles. Add any mod classnames you wish here
squadLeaders = [];
if (!activeUSAF) then {call compile preProcessFileLineNumbers "Templates\malosVanilla.sqf"} else {call compile preProcessFileLineNumbers "Templates\malosRHSUSAF.sqf"};
if (!activeAFRF) then {call compile preProcessFileLineNumbers "Templates\muyMalosVanilla.sqf"} else {call compile preProcessFileLineNumbers "Templates\muyMalosRHSAFRF.sqf"};

if (!activeGREF) then {call compile preProcessFileLineNumbers "Templates\buenosVanilla.sqf"} else {call compile preProcessFileLineNumbers "Templates\buenosRHSGREF.sqf"};

if (hayFFAA) then {call compile preProcessFileLineNumbers "Templates\malosFFAA.sqf"};

vehNormal = vehNATONormal + vehCSATNormal + [vehFIATruck,vehSDKTruck,vehSDKLightArmed,vehSDKBike,vehSDKRepair];
vehBoats = [vehNATOBoat,vehCSATBoat,vehSDKBoat];
vehAttack = vehNATOAttack + vehCSATAttack;
vehPlanes = vehNATOAir + vehCSATAir + [vehSDKPlane];
vehAttackHelis = vehCSATAttackHelis + vehNATOAttackHelis;
vehFixedWing = [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA,vehSDKPlane];
vehUAVs = [vehNATOUAV,vehCSATUAV];
vehAmmoTrucks = [vehNATOAmmoTruck,vehCSATAmmoTruck];
vehAPCs = vehNATOAPC + vehCSATAPC;
vehTanks = [vehNATOTank,vehCSATTank];
vehTrucks = vehNATOTrucks + vehCSATTrucks + [vehSDKTruck,vehFIATruck];
vehAA = [vehNATOAA,vehCSATAA];
vehMRLS = [vehCSATMRLS, vehNATOMRLS];
vehTransportAir = vehNATOTransportHelis + vehCSATTransportHelis/* + [vehSDKHeli]*/;
vehFastRope = ["O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_camo_F","RHS_UH60M_d","RHS_Mi8mt_vdv","RHS_Mi8mt_vv","RHS_Mi8mt_Cargo_vv"];
sniperGroups = [gruposNATOSniper,gruposCSATSniper,"IRG_SniperTeam_M"];///[["B_T_sniper_F","B_T_spotter_F"],["B_G_Sharpshooter_F","B_G_Soldier_M_F"],["O_T_sniper_F","O_T_spotter_F"]]
sniperUnits = ["O_T_Soldier_M_F","O_T_Sniper_F","O_T_ghillie_tna_F","O_V_Soldier_M_ghex_F","B_CTRG_Soldier_M_tna_F","B_T_soldier_M_F","B_T_Sniper_F","B_T_ghillie_tna_F"] + SDKSniper + [FIAMarksman,NATOMarksman,CSATMarksman];
if (hayRHS) then {sniperUnits = sniperUnits + ["rhsusf_socom_marsoc_sniper","rhs_vdv_marksman_asval"]};

arrayCivs = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Orestes","C_Nikos","C_Nikos_aged","C_Man_casual_1_F_tanoan","C_Man_casual_2_F_tanoan","C_Man_casual_3_F_tanoan","C_man_sport_1_F_tanoan","C_man_sport_2_F_tanoan","C_man_sport_3_F_tanoan","C_Man_casual_4_F_tanoan","C_Man_casual_5_F_tanoan","C_Man_casual_6_F_tanoan"];//array of possible civs. Only euro types picked (this is Greece). Add any civ classnames you wish here
civBoats = ["C_Boat_Civil_01_F","C_Scooter_Transport_01_F","C_Boat_Transport_02_F","C_Rubberboat"];
lamptypes = ["Lamps_Base_F", "PowerLines_base_F","Land_LampDecor_F","Land_LampHalogen_F","Land_LampHarbour_F","Land_LampShabby_F","Land_NavigLight","Land_runway_edgelight","Land_PowerPoleWooden_L_F"];
arrayids = ["Anthis","Costa","Dimitirou","Elias","Gekas","Kouris","Leventis","Markos","Nikas","Nicolo","Panas","Rosi","Samaras","Thanos","Vega"];
if (isMultiplayer) then {arrayids = arrayids + ["protagonista"]};

//_vests = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_blk","V_BandollierB_oli","V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier2_blk","V_PlateCarrierGL_rgr","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrier1_blk","V_PlateCarrierSpec_rgr","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_Chestrig_khk","V_Chestrig_rgr","V_Chestrig_blk","V_Chestrig_oli","V_TacVest_khk","V_TacVest_brn","V_TacVest_oli","V_TacVest_blk","V_TacVest_camo","V_TacVest_blk_POLICE","V_TacVestIR_blk","V_HarnessO_brn","V_HarnessOGL_brn","V_HarnessO_gry","V_HarnessOGL_gry","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_PlateCarrierIAGL_oli","V_RebreatherB","V_RebreatherIR","V_RebreatherIA","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F","V_Press_F","V_TacChestrig_grn_F","V_TacChestrig_oli_F","V_TacChestrig_cbr_F","V_PlateCarrier1_tna_F","V_PlateCarrier2_tna_F","V_PlateCarrierSpec_tna_F","V_PlateCarrierGL_tna_F","V_HarnessO_ghex_F","V_HarnessOGL_ghex_F","V_BandollierB_ghex_F","V_TacVest_gen_F","V_PlateCarrier1_rgr_noflag_F","V_PlateCarrier2_rgr_noflag_F","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrier3_rgr","V_PlateCarrier3_rgr","V_TacVestCamo_khk","G_I_Diving"];
civUniforms = ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_C_Poor_1","U_C_Poor_2","U_C_WorkerCoveralls","U_C_Poor_shorts_1","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_Man_casual_5_F","U_C_Man_casual_4_F","U_C_Man_casual_6_F","U_C_man_sport_3_F","U_C_man_sport_2_F","U_C_man_sport_1_F","U_C_Man_casual_2_F","U_C_Man_casual_1_F","U_C_Man_casual_3_F","U_Marshal"];
banditUniforms = ["U_I_C_Soldier_Bandit_4_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_1_F","U_I_C_Soldier_Bandit_5_F"];
uniformsSDK = banditUniforms + ["U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Camo_F","U_I_C_Soldier_Para_1_F","U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_5_F","U_I_C_Soldier_Para_4_F"];

//All weapons, MOD ones included, will be added to this arrays, but it's useless without integration, as if those weapons don't spawn, players won't be able to collect them, and after, unlock them in the arsenal.

//arifles = arifles - ["LMG_Mk200_BI_F"];

//rhs detection and integration
/*
if ("rhs_weap_akms" in lockedWeapons) then
	{
	hayRHS = true;
	armasAAF = armasAAF + ["rhs_weap_rpg7","rhs_weap_pkm", "rhs_weap_svdp_wd", "rhs_weap_ak74m_gp25","rhs_weap_akms_gp25","hgun_PDW2000_F","hgun_ACPC2_F"];
	municionAAF = municionAAF + ["rhs_100Rnd_762x54mmR","rhs_rpg7_PG7VR_mag","rhs_rpg7_PG7VL_mag","rhs_30Rnd_545x39_AK","rhs_mag_rgd5","rhs_VOG25","rhs_30Rnd_762x39mm","rhs_10Rnd_762x54mmR_7N1","9Rnd_45ACP_Mag","30Rnd_9x21_Mag"];
	opticasAAF = opticasAAF + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	itemsAAF = itemsAAF + ["rhs_acc_dtk1l","rhs_acc_pbs1","rhs_acc_tgpa"] + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	};
//publicVariable "hayRHS";
*/
injuredSounds =
[
	"a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
	"a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
	"a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
];

missionPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

ladridos = ["Music\dog_bark01.wss", "Music\dog_bark02.wss", "Music\dog_bark03.wss", "Music\dog_bark04.wss", "Music\dog_bark05.wss","Music\dog_maul01.wss","Music\dog_yelp01.wss","Music\dog_yelp02.wss","Music\dog_yelp03.wss"];
/*
if !(isnil "XLA_fnc_addVirtualItemCargo") then
	{
	activeXLA = true;
	addVirtualItemCargo = XLA_fnc_addVirtualItemCargo;
	addVirtualMagazineCargo= XLA_fnc_addVirtualMagazineCargo;
	addVirtualWeaponCargo = XLA_fnc_addVirtualWeaponCargo;
	addVirtualBackpackCargo = XLA_fnc_addVirtualBackpackCargo;
	}
else
	{
	activeXLA = false;
	addVirtualItemCargo = BIS_fnc_addVirtualItemCargo;
	addVirtualMagazineCargo= BIS_fnc_addVirtualMagazineCargo;
	addVirtualWeaponCargo = BIS_fnc_addVirtualWeaponCargo;
	addVirtualBackpackCargo = BIS_fnc_addVirtualBackpackCargo;
	};
*/
UPSMON_Bld_remove = ["Bridge_PathLod_base_F","Land_Slum_House03_F","Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F","Land_Bridge_01_F","Land_Bridge_Asphalt_F","Land_Bridge_Concrete_F","Land_Bridge_HighWay_F","Land_Canal_Wall_Stairs_F","warehouse_02_f","cliff_wall_tall_f","cliff_wall_round_f","containerline_02_f","containerline_01_f","warehouse_01_f","quayconcrete_01_20m_f","airstripplatform_01_f","airport_02_terminal_f","cliff_wall_long_f","shop_town_05_f"];

if (!isServer and hasInterface) exitWith {};

AAFpatrols = 0;//0
reinfPatrols = 0;
smallCAmrk = [];
smallCApos = [];
bigAttackInProgress = false;
chopForest = false;
roadsMrk = ["road","road_1","road_2","road_3","road_4","road_5","road_6","road_7","road_8","road_9","road_10","road_11","road_12","road_13","road_14","road_15","road_16"];
roadsCentral = ["road","road_1","road_2","road_3","road_4"];
roadsCE = ["road_5","road_6"];
roadsCSE = ["road_7"];
roadsSE = ["road_8","road_9","road_10","road_11"];
roadsSW = ["road_12"];
roadsCW = ["road_13","road_14"];
roadsNW = ["road_15"];
roadsNE = ["road_16"];
garrisonIsChanging = false;

//Pricing values for soldiers, vehicles
if (!isServer) exitWith {};

{server setVariable [_x,75,true]} forEach sdkTier1;
{server setVariable [_x,100,true]} forEach  sdkTier2;
{server setVariable [_x,150,true]} forEach sdkTier3;
{timer setVariable [_x,0,true]} forEach (vehAttack + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA] + vehCSATAttackHelis + vehAA + vehMRLS);

server setVariable [civCar,200,true];//200
server setVariable [civTruck,600,true];//600
server setVariable [civHeli,5000,true];//5000
server setVariable [civBoat,200,true];//200
server setVariable [vehSDKBike,50,true];//50
server setVariable [vehSDKLightUnarmed,200,true];//200
server setVariable [vehSDKTruck,300,true];//300
{server setVariable [_x,700,true]} forEach [vehSDKLightArmed,vehSDKAT];
{server setVariable [_x,400,true]} forEach [SDKMGStatic,vehSDKBoat,vehSDKRepair];//400
{server setVariable [_x,800,true]} forEach [SDKMortar,staticATBuenos,staticAABuenos];//800
server setVariable ["hr",8,true];//initial HR value
server setVariable ["resourcesFIA",1000,true];//Initial FIA money pool value
skillFIA = 0;//Initial skill level for FIA soldiers
prestigeNATO = 5;//Initial Prestige NATO
prestigeCSAT = 5;//Initial Prestige CSAT
prestigeOPFOR = 50;//Initial % support for NATO on each city
if (not cadetMode) then {prestigeOPFOR = 75};//if you play on vet, this is the number
prestigeBLUFOR = 0;//Initial % FIA support on each city
cuentaCA = 600;//600
bombRuns = 0;
cityIsSupportChanging = false;
resourcesIsChanging = false;
savingServer = false;
//misiones = [];
revelar = false;
prestigeIsChanging = false;
markersChanging = [];
staticsToSave = [];
napalmCurrent = false;
tierWar = 1;
haveRadio = false;
haveNV = false;
//minimoFPS = if (isDedicated) then {15} else {25};//initial FPS minimum.

//chungos = ["Tactical Coop","[GER] AntiStasi Tanoa by Opas Musterknaben | ACE3 | Taskforce","[REI] Regio Esercito Italiano PvP/TvT - TS:136.243.175.26", "GER|Public Coop|Takticsh|TS 31.172.86.185 for Joining", "[UNA] 24/7 HARDCORE - CooP - LOW PING","Numbian's Coop Server", "Antistasi Tanoa"];
unlockedItems = ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_grn","H_Booniehat_dirty","H_Cap_oli","H_Cap_blk","H_MilCap_rucamo","H_MilCap_gry","H_BandMask_blk","H_Bandanna_khk","H_Bandanna_gry","H_Bandanna_camo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_ShemagOpen_tan","H_Beret_grn","H_Beret_grn_SF","H_Watchcap_camo","H_TurbanO_blk","H_Hat_camo","H_Hat_tan","H_Beret_blk","H_Beret_red","H_Watchcap_khk","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli","G_Bandanna_beast","G_Tactical_Black","G_Aviator","G_Shades_Black","acc_flashlight","I_UavTerminal"] + uniformsSDK + civUniforms;//Initial Arsenal available items



//The following are the initial weapons and mags unlocked and available in the Arsenal, vanilla or RHS

if (!activeGREF) then
    {
    unlockedWeapons = ["hgun_PDW2000_F","hgun_Pistol_01_F","hgun_ACPC2_F","Binocular","arifle_AKM_F","launch_RPG7_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];//"LMG_03_F"
	unlockedRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
	unlockedMagazines = ["9Rnd_45ACP_Mag","30Rnd_9x21_Mag","30Rnd_762x39_Mag_F","MiniGrenade","1Rnd_HE_Grenade_shell","RPG7_F","30Rnd_545x39_Mag_F","30Rnd_9x21_Mag_SMG_02","10Rnd_9x21_Mag","200Rnd_556x45_Box_F","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandSmall_Remote_Mag","IEDUrbanSmall_Remote_Mag"];
	initialRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];
	unlockedItems = unlockedItems + ["V_Chestrig_khk","V_BandollierB_cbr","V_BandollierB_rgr","U_C_HunterBody_grn"];
	unlockedAT = ["launch_RPG7_F"];
    }
else
    {
    unlockedWeapons = ["rhs_weap_akms","rhs_weap_makarov_pmm","Binocular","rhs_weap_rpg7","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_pp2000_folded","rhs_weap_savz61"];
    unlockedRifles = ["rhs_weap_akms","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_savz61"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
    unlockedMagazines = ["rhs_30Rnd_762x39mm","rhs_mag_9x18_12_57N181S","rhs_rpg7_PG7VL_mag","rhsgref_5Rnd_762x54_m38","rhsgref_5Rnd_792x57_kar98k","rhs_mag_rgd5","rhs_mag_9x19mm_7n21_20","rhsgref_20rnd_765x17_vz61"];
    initialRifles = ["rhs_weap_akms","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_savz61"];
    unlockedItems = unlockedItems + ["rhs_acc_2dpZenit","rhs_6sh46"];
    unlockedAT = ["rhs_weap_rpg7"];
    };

unlockedBackpacks = ["B_FieldPack_oli","B_FieldPack_blk","B_FieldPack_ocamo","B_FieldPack_oucamo","B_FieldPack_cbr"]; //Initial Arsenal available backpacks
//lockedMochis = lockedMochis - unlockedBackpacks;
unlockedOptics = [];
unlockedMG = [];
unlockedGL = [];
unlockedSN = [];
unlockedAA = [];
garageIsUsed = false;
vehInGarage = [];
destroyedBuildings = []; publicVariable "destroyedBuildings";
reportedVehs = [];
hayTFAR = false;
hayACE = false;
hayACEhearing = false;
hayACEMedical = false;
//TFAR detection and config.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then
    {
    hayTFAR = true;
    haveRadio = true;
    unlockedItems = unlockedItems + ["tf_microdagr","tf_anprc148jem"];//making this items Arsenal available.["tf_anprc152"]
    tf_no_auto_long_range_radio = true; publicVariable "tf_no_auto_long_range_radio";//set to false and players will start with LR radio, uncomment the last line of so.
	//tf_give_personal_radio_to_regular_soldier = false;
	//tf_buenos_radio_code = "";publicVariable "tf_buenos_radio_code";//to make enemy vehicles usable as LR radio
	//tf_east_radio_code = tf_buenos_radio_code; publicVariable "tf_east_radio_code"; //to make enemy vehicles usable as LR radio
	//tf_guer_radio_code = tf_buenos_radio_code; publicVariable "tf_guer_radio_code";//to make enemy vehicles usable as LR radio
	tf_same_sw_frequencies_for_side = true; publicVariable "tf_same_sw_frequencies_for_side";
	tf_same_lr_frequencies_for_side = true; publicVariable "tf_same_lr_frequencies_for_side";
	unlockedItems pushBack "ItemRadio";
    //unlockedBackpacks pushBack "tf_rt1523g_sage";//uncomment this if you are adding LR radios for players
    };
//ACE detection and ACE item availability in Arsenal
	aceItems = [
		"ACE_EarPlugs",
		"ACE_RangeCard",
		"ACE_Clacker",
		"ACE_M26_Clacker",
		"ACE_DeadManSwitch",
		"ACE_DefusalKit",
		"ACE_MapTools",
		"ACE_Flashlight_MX991",
		"ACE_Sandbag_empty",
		"ACE_wirecutter",
		"ACE_RangeTable_82mm",
		"ACE_EntrenchingTool",
		"ACE_Cellphone",
		"ACE_ConcertinaWireCoil",
		"ACE_CableTie",
		"ACE_SpottingScope",
		"ACE_Tripod",
		"ACE_Chemlight_HiWhite",
		"ACE_Chemlight_HiRed",
		"ACE_Kestrel4500",
		"ACE_ATragMX",
		"ACE_acc_pointer_green",
		"ACE_HandFlare_White",
		"ACE_HandFlare_Red"
	];

	aceBasicMedItems = [
		"ACE_fieldDressing",
		"ACE_bloodIV_500",
		"ACE_bloodIV",
		"ACE_epinephrine",
		"ACE_morphine",
		"ACE_bodyBag"
	];

	aceAdvMedItems = [
		"ACE_elasticBandage",
		"ACE_quikclot",
		"ACE_bloodIV_250",
		"ACE_packingBandage",
		"ACE_personalAidKit",
		"ACE_plasmaIV",
		"ACE_plasmaIV_500",
		"ACE_plasmaIV_250",
		"ACE_salineIV",
		"ACE_salineIV_500",
		"ACE_salineIV_250",
		"ACE_surgicalKit",
		"ACE_tourniquet",
		"ACE_adenosine",
		"ACE_atropine"
	];


if (!isNil "ace_common_fnc_isModLoaded") then {
	unlockedItems = unlockedItems + aceItems;
	unlockedBackpacks pushBackUnique "ACE_TacticalLadder_Pack";
	unlockedWeapons pushBackUnique "ACE_VMH3";
	itemsAAF = itemsAAF + ["ACE_Kestrel4500","ACE_ATragMX"];
	armasNATO = armasNATO + ["ACE_M84"];
	hayACE = true;
	if (isClass (configFile >> "CfgSounds" >> "ACE_EarRinging_Weak")) then {
		hayACEhearing = true;
	};
	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")) then {
		if (ace_medical_level == 1) then {
			hayACEMedical = true;
			unlockedItems = unlockedItems + aceBasicMedItems;
		};
	};

	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")) then {
		if (ace_medical_level == 2) then {
			hayACEMedical = true;
			unlockedItems = unlockedItems + aceBasicMedItems + aceAdvMedItems;
		};
	};
};
hayACRE = false;
if (isClass(configFile >> "cfgPatches" >> "acre_main")) then
	{
	hayACRE = true;
	haveRadio = true;
	unlockedItems = unlockedItems + ["ACRE_PRC343","ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"];
	};

//allItems = allItems + itemsAAF + opticasAAF + _vests + cascos + NVGoggles;

if (worldName == "Tanoa") then
	{
	{server setVariable [_x select 0,_x select 1]} forEach [["Lami01",277],["Lifou01",350],["Lobaka01",64],["LaFoa01",38],["Savaka01",33],["Regina01",303],["Katkoula01",413],["Moddergat01",195],["Losi01",83],["Tanouka01",380],["Tobakoro01",45],["Georgetown01",347],["Kotomo01",160],["Rautake01",113],["Harcourt01",325],["Buawa01",44],["SaintJulien01",353],["Balavu01",189],["Namuvaka01",45],["Vagalala01",174],["Imone01",31],["Leqa01",45],["Blerick01",71],["Yanukka01",189],["OuaOue01",200],["Cerebu01",22],["Laikoro01",29],["Saioko01",46],["Belfort01",240],["Oumere01",333],["Muaceba01",18],["Nicolet01",224],["Lailai01",23],["Doodstil01",101],["Tavu01",178],["Lijnhaven01",610],["Nani01",19],["PetitNicolet01",135],["PortBoise01",28],["SaintPaul01",136],["Nasua01",60],["Savu01",184],["Murarua01",258],["Momea01",159],["LaRochelle01",532],["Koumac01",51],["Taga01",31],["Buabua01",27],["Penelo01",189],["Vatukoula01",15],["Nandai01",130],["Tuvanaka01",303],["Rereki01",43],["Ovau01",226],["IndPort01",420],["Ba01",106]];
	call compile preprocessFileLineNumbers "roadsDB.sqf";
	};

if (isDedicated) then {civPerc = 70; publicVariable "civPerc"};

publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";
publicVariable "miembros";
publicVariable "garageIsUsed";
publicVariable "vehInGarage";
publicVariable "reportedVehs";
publicVariable "hayACE";
publicVariable "hayTFAR";
publicVariable "hayACRE";
publicVariable "hayACEhearing";
publicVariable "hayACEMedical";
//publicVariable "misiones";
publicVariable "revelar";
publicVariable "prestigeNATO";
publicVariable "prestigeCSAT";
publicVariable "skillFIA";
publicVariable "staticsToSave";
publicVariable "bombRuns";
publicVariable "chopForest";
publicVariable "napalmCurrent";
publicVariable "tierWar";
publicVariable "haveRadio";
publicVariable "haveNV";
publicVariable "unlockedMG";
publicVariable "unlockedGL";
publicVariable "unlockedSN";
publicVariable "unlockedAT";
publicVariable "unlockedAA";

if (isMultiplayer) then {[[petros,"hint","Variables Init Completed"],"commsMP"] call BIS_fnc_MP;};