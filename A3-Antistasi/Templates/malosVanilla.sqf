if (worldName == "Altis") exitWith {call compile preProcessFileLineNumbers "Templates\malosVanillaAltis.sqf"};

NATOGrunt = "B_T_Soldier_F";
NATOOfficer = "B_T_Officer_F";
NATOOfficer2 = "B_G_officer_F";
NATOBodyG = "B_CTRG_Soldier_tna_F";
NATOCrew = "B_T_Crew_F";
NATOUnarmed = "B_G_Survivor_F";
NATOMarksman = "B_T_Soldier_M_F";
staticCrewMalos = "B_T_support_MG_F";
NATOMG = "B_HMG_01_high_F";
NATOMortar = "B_T_Mortar_01_F";
staticATmalos = "B_T_static_AT_F";
staticAAmalos = "B_static_AA_F";
NATOPilot = "B_T_Pilot_F";
vehNATOLightArmed = ["B_T_LSV_01_armed_F"];
vehNATOLightUnarmed = ["B_T_MRAP_01_F","B_T_LSV_01_unarmed_F"];
vehNATOTrucks = ["B_T_Truck_01_transport_F","B_T_Truck_01_covered_F"];
vehNATOAmmoTruck = "B_T_Truck_01_ammo_F";
vehNATORepairTruck = "B_T_Truck_01_repair_F";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
vehNATOAPC = ["B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_rcws_F"];//"B_T_APC_Tracked_01_CRV_F" has no cargo seats
vehNATOTank = "B_T_MBT_01_cannon_F";
vehNATOAA = "B_T_APC_Tracked_01_AA_F";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
vehNATOBoat = "B_T_Boat_Armed_01_minigun_F";
vehNATORBoat = "B_T_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"B_T_APC_Wheeled_01_cannon_F"];
vehNATOPlane = "B_Plane_CAS_01_F";
vehNATOPlaneAA = "B_Plane_Fighter_01_F";
vehNATOPatrolHeli = "B_Heli_Light_01_F";
vehNATOTransportHelis = ["B_T_VTOL_01_infantry_F","B_Heli_Transport_03_F",vehNATOPatrolHeli,"B_Heli_Transport_01_camo_F"];
vehNATOAttackHelis = ["B_T_VTOL_01_armed_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA];
vehNATOUAV = "B_UAV_02_F";
vehNATOUAVSmall = "B_UAV_01_F";
vehNATOMRLS = "B_T_MBT_01_arty_F";
vehNATOMRLSMags = "32Rnd_155mm_Mo_shells";
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "B_T_Truck_01_fuel_F", "B_T_Truck_01_medical_F", vehNATORepairTruck,"B_T_APC_Tracked_01_CRV_F"];
vehNATOBike = "B_T_Quadbike_01_F";
NATOFlag = "Flag_NATO_F";
NATOAmmobox = "B_supplyCrate_F";
//cfgNATOInf = (configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry");///
gruposNATOSentry = ["B_T_soldier_GL_F",NATOGrunt];//"B_T_InfSentry";//
gruposNATOSniper = ["B_T_sniper_F","B_T_spotter_F"];
gruposNATOsmall = [gruposNATOSentry,gruposNATOSniper,["B_T_recon_M_F","B_T_recon_F"]]; //[gruposNATOSentry,"B_T_SniperTeam","B_T_ReconSentry"];///
gruposNATOAA = ["B_T_soldier_TL_F","B_T_soldier_AA_F","B_T_soldier_AA_F","B_T_soldier_AAA_F"];
gruposNATOAT = ["B_T_soldier_TL_F","B_T_soldier_AT_F","B_T_soldier_AT_F","B_T_soldier_AAT_F"];
gruposNATOmid = [["B_T_soldier_TL_F","B_T_soldier_AR_F","B_T_soldier_GL_F","B_T_soldier_LAT_F"],gruposNATOAA,gruposNATOAT];//["B_T_InfTeam","B_T_InfTeam_AA","B_T_InfTeam_AT"];///
NATOSquad = ["B_T_soldier_SL_F",NATOGrunt,"B_T_soldier_LAT_F",NATOMarksman,"B_T_soldier_TL_F","B_T_soldier_AR_F","B_T_soldier_A_F","B_T_medic_F"];//"B_T_InfSquad";//
NATOSpecOp = ["B_CTRG_Soldier_TL_tna_F","B_CTRG_Soldier_M_tna_F","B_CTRG_Soldier_Medic_tna_F",NATOBodyG,"B_CTRG_Soldier_LAT_tna_F","B_CTRG_Soldier_JTAC_tna_F","B_CTRG_Soldier_Exp_tna_F","B_CTRG_Soldier_AR_tna_F"];
gruposNATOSquad = [NATOSquad,["B_T_soldier_SL_F","B_T_soldier_AR_F","B_T_soldier_GL_F",NATOMarksman,"B_T_soldier_AT_F","B_T_soldier_AAT_F","B_T_soldier_A_F","B_T_medic_F"],["B_T_soldier_SL_F","B_T_soldier_LAT_F","B_T_soldier_TL_F","B_T_soldier_AR_F","B_T_soldier_A_F","B_T_medic_F","B_T_Support_Mort_F","B_support_AMort_F"],["B_T_soldier_SL_F","B_T_soldier_AR_F","B_T_soldier_GL_F",NATOMarksman,"B_T_soldier_AA_F","B_T_soldier_AAA_F","B_T_soldier_A_F","B_T_medic_F"],["B_T_soldier_SL_F","B_T_soldier_AR_F","B_T_soldier_GL_F",NATOMarksman,"B_T_engineer_F","B_T_engineer_F","B_T_soldier_A_F","B_T_medic_F"]]; //[NATOSquad,"B_T_InfSquad_Weapons"];///
factionMachoMalos = "BLU_CTRG_F";
squadLeaders pushBack "B_T_soldier_SL_F";

soporteStaticNATOB = "B_HMG_01_support_grn_F";
ATStaticNATOB = "B_AT_01_weapon_F";
MGStaticNATOB = "B_HMG_01_Weapon_grn_F";
soporteStaticNATOB2 = "B_HMG_01_support_high_F";
AAStaticNATOB = "B_AA_01_weapon_F";
MortStaticNATOB = "B_Mortar_01_Weapon_grn_F";
soporteStaticNATOB3 = "B_Mortar_01_support_grn_F";

armasNATO = ["arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","srifle_EBR_F","srifle_LRR_F","srifle_DMR_03_F","srifle_DMR_02_F","MMG_02_sand_F","arifle_MXM_F","SMG_01_F","arifle_AK12_F","arifle_AK12_GL_F"];//possible weapons that spawn in NATO ammoboxes
municionNATO = ["30Rnd_65x39_Caseless_mag","30Rnd_65x39_caseless_mag_Tracer","100Rnd_65x39_Caseless_mag","100Rnd_65x39_caseless_mag_Tracer","20Rnd_762x51_Mag","7Rnd_408_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_tracer_green","11Rnd_45ACP_Mag","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","1Rnd_Smoke_Grenade_shell","3Rnd_HE_Grenade_shell","HandGrenade","20Rnd_762x51_Mag","10Rnd_338_Mag","130Rnd_338_Mag"];//possible ammo that spawn in NATO ammoboxes
flagNATOmrk = "flag_NATO";

nameMalos = "NATO";
if (isServer) then {"NATO_carrier" setMarkerText "NATO Carrier"};