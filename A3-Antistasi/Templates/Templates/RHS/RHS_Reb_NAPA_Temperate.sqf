///////////////////////////
//   Rebel Information   //
///////////////////////////

["name", "NAPA"] call _fnc_saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION

["flag", "Flag_FIA_F"] call _fnc_saveToTemplate;
["flagTexture", "a3\data_f\flags\flag_fia_co.paa"] call _fnc_saveToTemplate;
["flagMarkerType", "flag_FIA"] call _fnc_saveToTemplate;

["vehicleBasic", "I_G_Quadbike_01_F"] call _fnc_saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehicleLightUnarmed", "rhsgref_cdf_reg_uaz_open"] call _fnc_saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehicleLightArmed", "rhsgref_nat_uaz_dshkm"] call _fnc_saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehicleTruck", "rhsgref_cdf_zil131"] call _fnc_saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehicleAT", "rhsgref_nat_uaz_spg9"] call _fnc_saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehicleAA", "rhsgref_nat_ural_Zu23"] call _fnc_saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets

["vehicleBoat", "I_C_Boat_Transport_02_F"] call _fnc_saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehicleRepair", "rhsgref_cdf_gaz66_repair"] call _fnc_saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunBoats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets

["vehiclePlane", "RHS_AN2"] call _fnc_saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehicleHeli", ""] call _fnc_saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets

["vehicleCivCar", "C_Offroad_01_F"] call _fnc_saveToTemplate;
["vehicleCivTruck", "RHS_Ural_Open_Civ_03"] call _fnc_saveToTemplate;
["vehicleCivHeli", "RHS_Mi8t_civilian"] call _fnc_saveToTemplate;
["vehicleCivBoat", "C_Rubberboat"] call _fnc_saveToTemplate;

["staticMG", "rhsgref_ins_DSHKM"] call _fnc_saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", "rhsgref_nat_SPG9"] call _fnc_saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", "rhsgref_nat_ZU23"] call _fnc_saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortar", "rhsgref_nat_2b14"] call _fnc_saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets
["staticMortarMagHE", "rhs_mag_3vo18_10"] call _fnc_saveToTemplate;
["staticMortarMagSmoke", "rhs_mag_d832du_10"] call _fnc_saveToTemplate;

["mineAT", "rhs_mag_mine_ptm1"] call _fnc_saveToTemplate;
["mineAPERS", "rhs_mine_ozm72_b_mag"] call _fnc_saveToTemplate;

["breachingExplosivesAPC", [["rhs_ec75_mag", 2], ["rhs_ec75_sand_mag", 2], ["rhs_ec200_mag", 1], ["rhs_ec200_sand_mag", 1], ["rhsusf_m112_mag", 1], ["DemoCharge_Remote_Mag", 1]]] call _fnc_saveToTemplate;
["breachingExplosivesTank", [["rhs_ec75_mag", 4], ["rhs_ec75_sand_mag", 4], ["rhs_ec200_mag", 2], ["rhs_ec200_sand_mag", 2], ["rhs_ec400_mag", 1], ["rhs_ec400_sand_mag", 1],["DemoCharge_Remote_Mag", 2], ["rhsusf_m112_mag", 2], ["rhsusf_m112x4_mag", 1], ["rhs_charge_M2tet_x2_mag", 1], ["SatchelCharge_Remote_Mag", 1]]] call _fnc_saveToTemplate;

///////////////////////////
//  Rebel Starting Gear  //
///////////////////////////

["uniforms", [
    "U_IG_Guerilla1_1",
    "U_IG_Guerilla2_1",
    "U_IG_Guerilla2_2",
    "U_IG_Guerilla2_3",
    "U_IG_Guerilla3_1",
    "U_IG_leader",
    "U_IG_Guerrilla_6_1",
    "U_I_G_resistanceLeader_F",
    "rhsgref_uniform_alpenflage",
    "rhsgref_uniform_flecktarn",
    "rhsgref_uniform_flecktarn_full",
    "rhsgref_uniform_tigerstripe",
    "rhsgref_uniform_woodland",
    "rhsgref_uniform_woodland_olive",
    "rhsgref_uniform_olive",
    "rhsgref_uniform_altis_lizard",
    "rhsgref_uniform_altis_lizard_olive",
    "rhsgref_uniform_dpm",
    "rhsgref_uniform_dpm_olive",
    "rhsgref_uniform_3color_desert",
    "rhsgref_uniform_gorka_1_f",
    "rhsgref_uniform_TLA_1",
    "rhsgref_uniform_TLA_2",
    "rhs_insurgent_uniform_1",
    "rhs_insurgent_uniform_2",
    "rhs_insurgent_uniform_3",
    "rhs_insurgent_uniform_4",
    "rhs_insurgent_uniform_5"
]] call _fnc_saveToTemplate;

["headgear", [
    "H_Booniehat_khk_hs",
    "H_Booniehat_oli",
    "H_Cap_oli_hs",
    "H_Cap_blk",
    "H_Cap_headphones",
    "H_Shemag_olive_hs",
    "H_Bandanna_gry",
    "H_Bandanna_khk_hs",
    "H_Bandanna_sgg",
    "H_Bandanna_camo"
]] call _fnc_saveToTemplate;

private _initialRebelEquipment = [
"rhs_weap_type94_new","rhs_weap_tt33","rhs_weap_Izh18","rhs_weap_kar98k",
"rhs_weap_rpg75",
"rhs_mag_6x8mm_mhp","rhs_mag_762x25_8","rhsgref_1Rnd_00Buck","rhsgref_1Rnd_Slug","rhsgref_5Rnd_792x57_kar98k","rhs_grenade_mkii_mag","rhs_grenade_mki_mag","rhs_mag_rdg2_black","rhs_grenade_m15_mag",
"B_FieldPack_blk","B_FieldPack_cbr","B_FieldPack_green_F","B_FieldPack_khk","B_FieldPack_oli",
"rhsgref_chestrig","rhsgref_chicom","rhs_vydra_3m","rhs_vest_pistol_holster","rhs_vest_commander","rhs_6sh46","rhsgref_alice_webbing",
"rhs_acc_2dpZenit","Binocular"];
if (A3A_hasTFAR) then {_initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
if (A3A_hasTFAR && startWithLongRangeRadio) then {_initialRebelEquipment pushBack "tf_anprc155"};
if (A3A_hasTFARBeta) then {_initialRebelEquipment append ["TFAR_microdagr","TFAR_anprc154"]};
if (A3A_hasTFARBeta && startWithLongRangeRadio) then {_initialRebelEquipment pushBack "TFAR_anprc155"};
["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//     DO NOT GO PAST THIS LINE

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _fnc_createLoadoutData;
_loadoutData set ["rifles", []]; 				//this line determines rifles -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
_loadoutData set ["carbines", []]; 				//this line determines carbines -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
_loadoutData set ["grenadeLaunchers", []]; 		//this line determines grenade launchers -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
_loadoutData set ["SMGs", []]; 					//this line determines SMGs -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
_loadoutData set ["machineGuns", []]; 			//this line determines machine guns -- Example: ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData set ["marksmanRifles", []]; 		//this line determines markman rifles -- Example: ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData set ["sniperRifles", []]; 			//this line determines sniper rifles -- Example: ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F"] -- Array, can contain multiple assets
_loadoutData set ["lightATLaunchers", []]; 		//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData set ["ATLaunchers", []]; 			//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData set ["missileATLaunchers", []]; 	//this line determines missile AT launchers -- Example: ["launch_B_Titan_short_F"] -- Array, can contain multiple assets
_loadoutData set ["AALaunchers", []]; 			//this line determines AA launchers -- Example: ["launch_B_Titan_F"] -- Array, can contain multiple assets
_loadoutData set ["sidearms", []]; 				//this line determines handguns/sidearms -- Example: ["hgun_Pistol_heavy_01_F", "hgun_P07_F"] -- Array, can contain multiple assets

_loadoutData set ["ATMines", []]; 				//this line determines the AT mines which can be carried by units -- Example: ["ATMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData set ["APMines", []]; 				//this line determines the APERS mines which can be carried by units -- Example: ["APERSMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData set ["lightExplosives", []]; 		//this line determines light explosives -- Example: ["DemoCharge_Remote_Mag"] -- Array, can contain multiple assets
_loadoutData set ["heavyExplosives", []]; 		//this line determines heavy explosives -- Example: ["SatchelCharge_Remote_Mag"] -- Array, can contain multiple assets

_loadoutData set ["antiInfantryGrenades", []]; 	//this line determines anti infantry grenades (frag and such) -- Example: ["HandGrenade","MiniGrenade"] -- Array, can contain multiple assets
_loadoutData set ["antiTankGrenades", []]; 		//this line determines anti tank grenades. Leave empty when not available. -- Array, can contain multiple assets
_loadoutData set ["smokeGrenades", []]; 		//this line determines smoke grenades -- Example: ["SmokeShell", "SmokeShellRed"] -- Array, can contain multiple assets


//Basic equipment. Shouldn't need touching most of the time.
//Mods might override this, or certain mods might want items removed (No GPSs in WW2, for example)
_loadoutData set ["maps", ["ItemMap"]];
_loadoutData set ["watches", ["ItemWatch"]];
_loadoutData set ["compasses", ["ItemCompass"]];
_loadoutData set ["radios", []];
_loadoutData set ["gpses", []];
_loadoutData set ["NVGs", []]; //this line determines NVGs -- Array, can contain multiple assets
_loadoutData set ["binoculars", ["Binocular"]];

_loadoutData set ["uniforms", [
    "rhs_insurgent_uniform_1",
    "rhs_insurgent_uniform_2",
    "rhs_insurgent_uniform_3",
    "rhs_insurgent_uniform_4",
    "rhs_insurgent_uniform_5",
    "rhsgref_uniform_dpm",
    "rhsgref_uniform_dpm_olive",
    "rhsgref_uniform_altis_lizard_olive",
    "rhsgref_uniform_flecktarn_full"
]];
_loadoutData set ["vests", []];
_loadoutData set ["backpacks", []];
_loadoutData set ["longRangeRadios", []];
_loadoutData set ["helmets", []];

//Item *set* definitions. These are added in their entirety to unit loadouts. No randomisation is applied.
_loadoutData set ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

//Unit type specific item sets. Add or remove these, depending on the unit types in use.
_loadoutData set ["items_squadleader_extras", []];
_loadoutData set ["items_rifleman_extras", []];
_loadoutData set ["items_medic_extras", []];
_loadoutData set ["items_grenadier_extras", []];
_loadoutData set ["items_explosivesExpert_extras", []];
_loadoutData set ["items_engineer_extras", ["ToolKit", "MineDetector"]];
_loadoutData set ["items_lat_extras", []];
_loadoutData set ["items_at_extras", []];
_loadoutData set ["items_aa_extras", []];
_loadoutData set ["items_machineGunner_extras", []];
_loadoutData set ["items_marksman_extras", []];
_loadoutData set ["items_sniper_extras", []];
_loadoutData set ["items_police_extras", []];
_loadoutData set ["items_crew_extras", []];
_loadoutData set ["items_unarmed_extras", []];

////////////////////////
//  Rebel Unit Types  //
///////////////////////.

private _squadLeaderTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;

	["backpacks"] call _fnc_setBackpack;

	[["grenadeLaunchers", "rifles"] call _fnc_fallback] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;


	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_squadLeader_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["binoculars"] call _fnc_addBinoculars;
	["NVGs"] call _fnc_addNVGs;
};

private _riflemanTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["rifles"] call _fnc_setPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_rifleman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _medicTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["carbines"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_medic"] call _fnc_addItemSet;
	["items_medic_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _grenadierTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["grenadeLaunchers"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;


	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_grenadier_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 4] call _fnc_addItem;
	["antiTankGrenades", 3] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _explosivesExpertTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["rifles"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;


	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_explosivesExpert_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["lightExplosives", 2] call _fnc_addItem;
	if (random 1 > 0.5) then {["heavyExplosives", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["atMines", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["apMines", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _engineerTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["carbines"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_engineer_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	if (random 1 > 0.5) then {["lightExplosives", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _latTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["rifles"] call _fnc_setPrimary;
	["primary", 8] call _fnc_addMagazines;

	[["lightATLaunchers", "ATLaunchers"] call _fnc_fallback] call _fnc_setLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 1] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_lat_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _atTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["rifles"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	[selectRandom ["ATLaunchers", "missileATLaunchers"]] call _fnc_setLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_at_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _aaTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["rifles"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	["AALaunchers"] call _fnc_setLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_aa_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _machineGunnerTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["machineGuns"] call _fnc_setPrimary;
	["primary", 4] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_machineGunner_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _marksmanTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["marksmanRifles"] call _fnc_setPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_marksman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _sniperTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	["sniperRifles"] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_sniper_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _policeTemplate = {
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;
	["backpacks"] call _fnc_setBackpack;

	[selectRandom ["SMGs", "carbines"]] call _fnc_setPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_police_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

private _crewTemplate = {
	["helmets"] call _fnc_setHelmet;
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;

	["SMGs"] call _fnc_setPrimary;
	["primary", 3] call _fnc_addMagazines;

	["sidearms"] call _fnc_setHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_crew_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["NVGs"] call _fnc_addNVGs;
};

private _unarmedTemplate = {
	["vests"] call _fnc_setVest;
	["uniforms"] call _fnc_setUniform;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_unarmed_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

private _prefix = "militia";
private _unitTypes = [
	["Petros", _squadLeaderTemplate],
	["SquadLeader", _squadLeaderTemplate],
	["Rifleman", _riflemanTemplate],
	["staticCrew", _riflemanTemplate],
	["Medic", _medicTemplate, [["medic", true]]],
	["Engineer", _engineerTemplate, [["engineer", true]]],
	["ExplosivesExpert", _explosivesExpertTemplate, [["explosiveSpecialist", true]]],
	["Grenadier", _grenadierTemplate],
	["LAT", _latTemplate],
	["AT", _atTemplate],
	["AA", _aaTemplate],
	["MachineGunner", _machineGunnerTemplate],
	["Marksman", _marksmanTemplate],
	["Sniper", _sniperTemplate],
	["Unarmed", _unarmedTemplate]
];

[_prefix, _unitTypes, _loadoutData] call _fnc_generateAndSaveUnitsToTemplate;
