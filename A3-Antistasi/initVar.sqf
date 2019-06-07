//Antistasi var settings
//If some setting can be modified it will be commented with a // after it.
//Make changes at your own risk!!
//You do not have enough balls to make any modification and after making a Bug report because something is wrong. You don't wanna be there. Believe me.
//Not commented lines cannot be changed.
//Don't touch them.

antistasiVersion = "v 1.4.0.2";


debug = false;//debug variable, not useful for everything..

cleantime = 3600;//time to delete dead bodies, vehicles etc..
distanciaSPWN = 1000;//initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
distanciaSPWN1 = 1300;
distanciaSPWN2 = 500;
musicON = if (isMultiplayer) then {false} else {true};
civPerc = 35;
autoHeal = false;
recruitCooldown = 0;
savingClient = false;
incomeRep = false;
//distanciaMiss = 2500;
/*
minMags = 20;

minPacks = 20;
minItems = 20;
minOptics = 12;*/
maxUnits = 140;

buenos = side group petros;
malos = if (buenos == independent) then {west} else {independent};
muyMalos = east;

colorBuenos = if (buenos == independent) then {"colorGUER"} else {"colorBLUFOR"};
colorMalos = if (buenos == independent) then {"colorBLUFOR"} else {"colorGUER"};
colorMuyMalos = "colorOPFOR";

respawnBuenos = if (buenos == independent) then {"respawn_guerrila"} else {"respawn_west"};
respawnMalos = if (buenos == independent) then {"respawn_west"} else {"respawn_guerrila"};
posHQ = getMarkerPos respawnBuenos;

allMagazines = [];
_cfgmagazines = configFile >> "cfgmagazines";

for "_i" from 0 to (count _cfgMagazines) -1 do {
    _magazine = _cfgMagazines select _i;
    if (isClass _magazine) then {
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

_yaMetidos = [];

{
    _nombre = configName _x;
    _nombre = [_nombre] call BIS_fnc_baseWeapon;
    
    if (not(_nombre in _yaMetidos)) then {
        _magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
        _yaMetidos pushBack _nombre;
        _weapon = [_nombre] call BIS_fnc_itemType;
        _weaponType = _weapon select 1;
        switch (_weaponType) do {
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

//vests = vests select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor") > 5};
activeAFRF = false;
activeUSAF = false;
activeGREF = false;
hayFFAA = false;
hayIFA = false;
myCustomMod = false;

if ("LIB_PTRD" in arifles) then {
    hayIFA = true;
    cascos = [];
    humo = ["LIB_RDG","LIB_NB39"];
} else {
    if ("rhs_weap_akms" in arifles) then {activeAFRF = true; hayRHS = true};
    if ("ffaa_armas_hkg36k_normal" in arifles) then {hayFFAA = true};
    if ("rhs_weap_m4a1_d" in arifles) then {activeUSAF = true; hayRHS = true};
    if ("rhs_weap_m92" in arifles) then {activeGREF = true; hayRHS = true} else {mguns pushBack "LMG_Mk200_BI_F"};
    cascos = cascos select {getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") > 2};
    humo = ["SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellBlue","SmokeShellYellow","SmokeShellPurple","SmokeShellOrange"];
};

titanLaunchers = if ((!hayRHS) and !hayIFA and !myCustomMod) then {
    ["launch_B_Titan_F","launch_I_Titan_F","launch_O_Titan_ghex_F","launch_O_Titan_F","launch_B_Titan_tna_F"]
} else {
    []
};

antitanqueAAF = if ((!hayRHS) and !hayIFA and !myCustomMod) then {
    ["launch_I_Titan_F","launch_I_Titan_short_F"]
} else {
    [];
};//possible Titan weapons that spawn in  ammoboxes
MantitanqueAAF = if ((!hayRHS) and !hayIFA and !myCustomMod) then {
    ["Titan_AT", "Titan_AP", "Titan_AA"]
} else {
    if (hayIFA) then {["LIB_Shg24"]} else {[]};
};//possible Titan rockets that spawn in  ammoboxes

minasAAF = if ((!hayRHS) and !hayIFA and !myCustomMod) then {
    ["SLAMDirectionalMine_Wire_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag", "ATMine_Range_Mag","APERSTripMine_Wire_Mag","APERSMine_Range_Mag", "APERSBoundingMine_Range_Mag"]
} else {
    if (hayRHS) then {
        ["rhsusf_m112_mag","rhsusf_mine_m14_mag","rhs_mine_M19_mag","rhs_mine_tm62m_mag","rhs_mine_pmn2_mag"]
    } else {
        if (hayIFA and !myCustomMod) then {["LIB_PMD6_MINE_mag","LIB_TM44_MINE_mag","LIB_US_TNT_4pound_mag"]} else {[]};
    }
};//possible mines that spawn in AAF ammoboxescomment "Exported from Arsenal by Alberto";

itemsAAF = if ((!hayRHS) and !hayIFA and !myCustomMod) then {
    ["FirstAidKit","Medikit","MineDetector","NVGoggles","ToolKit","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_acp","bipod_03_F_oli","muzzle_snds_338_green","muzzle_snds_93mmg_tan","Rangefinder","Laserdesignator","ItemGPS","acc_pointer_IR","ItemRadio"]
} else {
    if (hayRHS) then {
        ["FirstAidKit","Medikit","MineDetector","ToolKit","ItemGPS","acc_pointer_IR","ItemRadio"]
    } else {
        if (hayIFA and !myCustomMod) then {["FirstAidKit","Medikit","ToolKit","LIB_ToolKit"]} else {["FirstAidKit","Medikit","ToolKit"]};
    }
};

NVGoggles = if (!hayIFA) then {
    ["NVGoggles_OPFOR","NVGoggles_INDEP","O_NVGoggles_hex_F","O_NVGoggles_urb_F","O_NVGoggles_ghex_F","NVGoggles_tna_F","NVGoggles"]
} else {
    []
};

arrayCivVeh = if !(hayIFA) then {
    ["C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F","C_Truck_02_transport_F","C_Truck_02_covered_F","C_Offroad_02_unarmed_F"];
} else {
    ["LIB_DAK_OpelBlitz_Open","LIB_GazM1","LIB_GazM1_dirty","LIB_DAK_Kfz1","LIB_DAK_Kfz1_hood"];
};

municionNATO = [];
armasNATO = [];
municionCSAT = [];
armasCSAT = [];

if (!hayIFA) then {
    if (!activeUSAF) then {
        call compile preProcessFileLineNumbers "Templates\malosVanilla.sqf";
    } else {
        if (buenos == independent) then {
            call compile preProcessFileLineNumbers "Templates\malosRHSUSAF.sqf";
        } else {
            call compile preProcessFileLineNumbers "Templates\buenosRHSUSAF.sqf";
        };
    };
    if (!activeAFRF) then {
        call compile preProcessFileLineNumbers "Templates\muyMalosVanilla.sqf";
    } else {
        call compile preProcessFileLineNumbers "Templates\muyMalosRHSAFRF.sqf";
    };

    if (!activeGREF) then {
        call compile preProcessFileLineNumbers "Templates\buenosVanilla.sqf"
    } else {
        if (buenos == independent) then {call compile preProcessFileLineNumbers "Templates\buenosRHSGREF.sqf"} else {call compile preProcessFileLineNumbers "Templates\malosRHSGREF.sqf"};
    };
} else {
    call compile preProcessFileLineNumbers "Templates\buenosIFA.sqf";
    call compile preProcessFileLineNumbers "Templates\muyMalosIFA.sqf";
    call compile preProcessFileLineNumbers "Templates\malosIFA.sqf";
};

squadLeaders = SDKSL + [(NATOSquad select 0),(NATOSpecOp select 0),(CSATSquad select 0),(CSATSpecOp select 0),(FIASquad select 0)];
medics = SDKMedic + [(FIAsquad select ((count FIAsquad)-1)),(NATOSquad select ((count NATOSquad)-1)),(NATOSpecOp select ((count NATOSpecOp)-1)),(CSATSquad select ((count CSATSquad)-1)),(CSATSpecOp select ((count CSATSpecOp)-1))];
sdkTier1 = SDKMil + [staticCrewBuenos] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldadosSDK = sdkTier1 + sdkTier2 + sdkTier3;
vehFIA = [vehSDKBike,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATBuenos,staticAABuenos,vehSDKRepair];
gruposSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
gruposSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
//["BanditShockTeam","ParaShockTeam"];
gruposSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
gruposSDKSquadEng = [SDKSL,SDKGL,SDKMil,SDKMG,SDKExp,SDKATman,SDKEng,SDKMedic];
gruposSDKSquadSupp = [SDKSL,SDKGL,SDKMil,SDKMG,SDKATman,SDKMedic,[staticCrewBuenos,staticCrewBuenos],[staticCrewBuenos,staticCrewBuenos]];
gruposSDKSniper = [SDKSniper,SDKSniper];
gruposSDKSentry = [SDKGL,SDKMil];
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

_checked = [];

{
    {
        _tipo = _x;
        if !(_tipo in _checked) then {
            _checked pushBack _tipo;
            _loadout = getUnitLoadout _tipo;
            for "_i" from 0 to 2 do {
                _weapon = [((_loadout select _i) select 0)] call BIS_fnc_baseWeapon;
                if !(_weapon in armasCSAT) then {armasCSAT pushBack _weapon};
            };
        };
    } forEach _x;
} forEach gruposCSATmid + [CSATSpecOp] + gruposCSATSquad;

_checked = [];

{
    {
        _tipo = _x;
        if !(_tipo in _checked) then {
            _checked pushBack _tipo;
            _loadout = getUnitLoadout _tipo;
            for "_i" from 0 to 2 do {
                _weapon = [((_loadout select _i) select 0)] call BIS_fnc_baseWeapon;
                if !(_weapon in armasNATO) then {armasNATO pushBack _weapon};
            };
        };
    } forEach _x;
} forEach gruposNATOmid + [NATOSpecOp] + gruposNATOSquad;

{
    _nombre = [_x] call BIS_fnc_baseWeapon;
    _magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
    municionNATO pushBack (_magazines select 0);
} forEach armasNATO;

{
    _nombre = [_x] call BIS_fnc_baseWeapon;
    _magazines = getArray (configFile / "CfgWeapons" / _nombre / "magazines");
    municionCSAT pushBack (_magazines select 0);
} forEach armasCSAT;

//optic, pointer and flashlight automated detection
opticasAAF = [];
flashLights = [];
pointers = [];

{
    {
        _item = _x;
        if !(_item in (opticasAAF + flashLights + pointers)) then {
            if (((_item call BIS_fnc_itemType) select 1) == "AccessorySights") then {
                opticasAAF pushBack _item;
            } else {
                if (isClass (configfile >> "CfgWeapons" >> _item >> "ItemInfo" >> "FlashLight" >> "Attenuation")) then {
                    flashLights pushBack _item;
                } else {
                    if (isClass (configfile >> "CfgWeapons" >> "acc_pointer_IR" >> "ItemInfo" >> "Pointer")) then {
                        pointers pushBack _item;
                    };
                };
            };
        };
    } forEach (_x call BIS_fnc_compatibleItems);
} forEach (armasNATO + armasCSAT);

if (hayRHS) then {
    opticasAAF = opticasAAF select {getText (configfile >> "CfgWeapons" >> _x >> "author") == "Red Hammer Studios"};
    flashlights = flashlights select {getText (configfile >> "CfgWeapons" >> _x >> "author") == "Red Hammer Studios"};
    pointers = pointers select {getText (configfile >> "CfgWeapons" >> _x >> "author") == "Red Hammer Studios"};
};

vehNormal = vehNATONormal + vehCSATNormal + [vehFIATruck,vehSDKTruck,vehSDKLightArmed,vehSDKBike,vehSDKRepair];
vehBoats = [vehNATOBoat,vehCSATBoat,vehSDKBoat];
vehAttack = vehNATOAttack + vehCSATAttack;
vehPlanes = vehNATOAir + vehCSATAir + [vehSDKPlane];
vehAttackHelis = vehCSATAttackHelis + vehNATOAttackHelis;
vehFixedWing = [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA,vehSDKPlane];
vehUAVs = [vehNATOUAV,vehCSATUAV];
vehAmmoTrucks = [vehNATOAmmoTruck,vehCSATAmmoTruck];
vehAPCs = vehNATOAPC + vehCSATAPC;
vehTanks = vehNATOAllTanks + vehCSATAllTanks;
vehTrucks = vehNATOTrucks + vehCSATTrucks + [vehSDKTruck,vehFIATruck];
vehAA = [vehNATOAA,vehCSATAA];
vehMRLS = [vehCSATMRLS, vehNATOMRLS];
vehTransportAir = vehNATOTransportHelis + vehCSATTransportHelis;
vehFastRope = ["O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_camo_F","RHS_UH60M_d","RHS_Mi8mt_vdv","RHS_Mi8mt_vv","RHS_Mi8mt_Cargo_vv"];
vehUnlimited = vehNATONormal + vehCSATNormal + [vehNATORBoat,vehNATOPatrolHeli,vehCSATRBoat,vehCSATPatrolHeli,vehNATOUAV,vehNATOUAVSmall,NATOMG,NATOMortar,vehCSATUAV,vehCSATUAVSmall,CSATMG,CSATMortar];
sniperGroups = [gruposNATOSniper,gruposCSATSniper];
sniperUnits = ["O_T_Soldier_M_F","O_T_Sniper_F","O_T_ghillie_tna_F","O_V_Soldier_M_ghex_F","B_CTRG_Soldier_M_tna_F","B_T_soldier_M_F","B_T_Sniper_F","B_T_ghillie_tna_F"] + SDKSniper + [FIAMarksman,NATOMarksman,CSATMarksman];
if (hayRHS) then {sniperUnits = sniperUnits + ["rhsusf_socom_marsoc_sniper","rhs_vdv_marksman_asval"]};

arrayCivs = if (worldName == "Tanoa") then {
    ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Orestes","C_Nikos","C_Nikos_aged","C_Man_casual_1_F_tanoan","C_Man_casual_2_F_tanoan","C_Man_casual_3_F_tanoan","C_man_sport_1_F_tanoan","C_man_sport_2_F_tanoan","C_man_sport_3_F_tanoan","C_Man_casual_4_F_tanoan","C_Man_casual_5_F_tanoan","C_Man_casual_6_F_tanoan"]
} else {
    if !(hayIFA) then {
        ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Orestes","C_Nikos","C_Nikos_aged"]
    } else {
        ["LIB_CIV_Assistant","LIB_CIV_Assistant_2","LIB_CIV_Citizen_1","LIB_CIV_Citizen_2","LIB_CIV_Citizen_3","LIB_CIV_Citizen_4","LIB_CIV_Citizen_5","LIB_CIV_Citizen_6","LIB_CIV_Citizen_7","LIB_CIV_Citizen_8","LIB_CIV_Priest","LIB_CIV_Doctor","LIB_CIV_Functionary_3","LIB_CIV_Functionary_2","LIB_CIV_Functionary_4","LIB_CIV_Villager_4","LIB_CIV_Villager_1","LIB_CIV_Villager_2","LIB_CIV_Villager_3","LIB_CIV_Woodlander_1","LIB_CIV_Woodlander_3","LIB_CIV_Woodlander_2","LIB_CIV_Woodlander_4","LIB_CIV_SchoolTeacher","LIB_CIV_SchoolTeacher_2","LIB_CIV_Rocker","LIB_CIV_Worker_3","LIB_CIV_Worker_1","LIB_CIV_Worker_4","LIB_CIV_Worker_2"]
    };
};//array of possible civs. Only euro types picked (this is Greece). Add any civ classnames you wish here

civBoats = if !(hayIFA) then {["C_Boat_Civil_01_F","C_Scooter_Transport_01_F","C_Boat_Transport_02_F","C_Rubberboat"]} else {[]};
lamptypes = ["Lamps_Base_F", "PowerLines_base_F","Land_LampDecor_F","Land_LampHalogen_F","Land_LampHarbour_F","Land_LampShabby_F","Land_NavigLight","Land_runway_edgelight","Land_PowerPoleWooden_L_F"];
if !(hayIFA) then {
    arrayids = ["Anthis","Costa","Dimitirou","Elias","Gekas","Kouris","Leventis","Markos","Nikas","Nicolo","Panas","Rosi","Samaras","Thanos","Vega"];
    if (isMultiplayer) then {
        arrayids = arrayids + ["protagonista"];
    };
};

//civUniforms = ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_C_Poor_1","U_C_Poor_2","U_C_WorkerCoveralls","U_C_Poor_shorts_1","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_Man_casual_5_F","U_C_Man_casual_4_F","U_C_Man_casual_6_F","U_C_man_sport_3_F","U_C_man_sport_2_F","U_C_man_sport_1_F","U_C_Man_casual_2_F","U_C_Man_casual_1_F","U_C_Man_casual_3_F","U_Marshal"];
civUniforms = [];
{
    _uniform = (getUnitLoadout _x select 3) select 0;
    civUniforms pushBackUnique _uniform;
} forEach arrayCivs;


//All weapons, MOD ones included, will be added to this arrays, but it's useless without integration, as if those weapons don't spawn, players won't be able to collect them, and after, unlock them in the arsenal.

injuredSounds =
[
    "a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
    "a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
    "a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
];
medicAnims = ["AinvPknlMstpSnonWnonDnon_medic_1","AinvPknlMstpSnonWnonDnon_medic0","AinvPknlMstpSnonWnonDnon_medic1","AinvPknlMstpSnonWnonDnon_medic2"];

missionPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

ladridos = ["Music\dog_bark01.wss", "Music\dog_bark02.wss", "Music\dog_bark03.wss", "Music\dog_bark04.wss", "Music\dog_bark05.wss","Music\dog_maul01.wss","Music\dog_yelp01.wss","Music\dog_yelp02.wss","Music\dog_yelp03.wss"];

UPSMON_Bld_remove = ["Bridge_PathLod_base_F","Land_Slum_House03_F","Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F","Land_Bridge_01_F","Land_Bridge_Asphalt_F","Land_Bridge_Concrete_F","Land_Bridge_HighWay_F","Land_Canal_Wall_Stairs_F","warehouse_02_f","cliff_wall_tall_f","cliff_wall_round_f","containerline_02_f","containerline_01_f","warehouse_01_f","quayconcrete_01_20m_f","airstripplatform_01_f","airport_02_terminal_f","cliff_wall_long_f","shop_town_05_f","Land_ContainerLine_01_F"];
listMilBld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F","Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_HelipadSquare_F"];
listbld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"];

if (!isServer and hasInterface) exitWith {};

AAFpatrols = 0;//0
reinfPatrols = 0;
smallCAmrk = [];
smallCApos = [];
bigAttackInProgress = false;
chopForest = false;
distanceForAirAttack = 20000;
distanceForLandAttack = 10000; //if (hayIFA) then {5000} else {3000};

if (worldName == "Tanoa") then {
    roadsMrk = ["road","road_1","road_2","road_3","road_4","road_5","road_6","road_7","road_8","road_9","road_10","road_11","road_12","road_13","road_14","road_15","road_16"];
    roadsCentral = ["road","road_1","road_2","road_3","road_4"];
    roadsCE = ["road_5","road_6"];
    roadsCSE = ["road_7"];
    roadsSE = ["road_8","road_9","road_10","road_11"];
    roadsSW = ["road_12"];
    roadsCW = ["road_13","road_14"];
    roadsNW = ["road_15"];
    roadsNE = ["road_16"];
    carreteras setVariable ["airport",[[[6988.38,7135.59,10.0673],17.0361,"MG"],[[6873.83,7472,3.19066],262.634,"MG"],[[6902.09,7427.71,13.0559],359.999,"MG"],[[6886.75,7445.52,0.0368803],360,"Mort"],[[6888.47,7440.31,0.0368826],0.000531628,"Mort"],[[6882.14,7445.42,0.0368817],360,"Mort"],[[6886.49,7436.58,0.0368807],360,"Mort"],[[6970.32,7188.49,-0.0339937],359.999,"Tank"],[[6960.98,7188.49,-0.0339937],359.999,"Tank"],[[6950.71,7187.42,-0.033505],359.999,"Tank"]]];

    carreteras setVariable ["airport_1",[[[2175.14,13402.4,-0.01863],138.861,"Tank"],[[2183.31,13409.7,-0.0184679],139.687,"Tank"],[[2211.39,13434.4,0.0164337],141.512,"Tank"],[[2221.62,13440.6,0.016408],142.886,"Tank"],[[2221.31,13195,0.0368757],0.000337857,"Mort"],[[2224.09,13197.6,0.038271],1.30051e-005,"Mort"],[[2218.96,13199.1,0.0382385],0.00923795,"Mort"],[[2071.1,13308.5,14.4943],133.738,"MG"]]];

    carreteras setVariable ["airport_2",[[[11803,13051.6,0.0368805],360,"Mort"],[[11813.5,13049.2,0.0368915],0.000145629,"Mort"],[[11799.5,13043.2,0.0368919],360,"Mort"],[[11723.3,13114.6,18.1545],300.703,"MG"],[[11782.3,13058.1,0.0307827],19.6564,"Tank"],[[11810.6,13040.2,0.0368905],360,"Tank"],[[11832.9,13042.1,0.0283785],16.3683,"Tank"]]];
    carreteras setVariable ["airport_3",[[[11658,3055.02,0.036881],360,"Mort"],[[11662.6,3060.14,0.0368819],0.000294881,"Mort"],[[11664.8,3049.94,0.0368805],360,"Mort"],[[11668.9,3055.64,0.0368805],2.08056e-005,"Mort"],[[11747.8,2982.95,18.1513],249.505,"MG"],[[11784.1,3132.77,0.183631],214.7,"Tank"],[[11720.3,3176.15,0.112019],215.055,"Tank"]]];
    carreteras setVariable ["airport_4",[[[2092.87,3412.98,0.0372648],0.00414928,"Mort"],[[2091.5,3420.69,0.0369596],360,"Mort"],[[2099.93,3422.53,0.0373936],0.00215797,"Mort"],[[2100.13,3416.28,0.0394554],0.0043371,"Mort"],[[2198.24,3471.03,18.0123],0.00187816,"MG"],[[2133.01,3405.88,-0.0156536],315.528,"Tank"],[[2145.82,3416.83,-0.00544548],316.441,"Tank"],[[2163.9,3432.18,-0.0256157],318.777,"Tank"]]];
} else {
    if (worldName == "Altis") then {
        roadsMrk = ["road","road_1","road_2","road_3","road_4","road_5","road_6","road_7","road_8","road_9","road_10","road_11","road_12","road_13","road_14","road_15","road_16","road_17","road_18","road_19","road_20","road_21","road_22","road_23","road_24","road_25","road_26","road_27","road_28","road_29","road_30","road_31","road_32","road_33","road_34","road_35","road_36","road_37","road_38","road_39","road_40","road_41","road_42"];
        {_x setMarkerAlpha 0} forEach roadsMrk;
        carreteras setVariable ["airport",[[[21175.06,7369.336,0],62.362,"Tank"],[[21178.89,7361.573,0.421],62.36,"Tank"],[[20961.332,7295.678,0],0,"Mort"],[[20956.143,7295.142,0],0,"Mort"],[[20961.1,7290.02,0.262632],0,"Mort"]]];
        carreteras setVariable ["airport_1",[[[23044.8,18745.7,0.0810001],88.275,"Tank"],[[23046.8,18756.8,0.0807302],88.275,"Tank"],[[23214.8,18859.5,0],267.943,"Tank"],[[22981.2,18903.9,0],0,"Mort"],[[22980.1,18907.5,0.553066],0,"Mort"]]];
        carreteras setVariable ["airport_2",[[[26803.1,24727.7,0.0629988],359.958,"Mort"],[[26809,24728.2,0.03755],359.986,"Mort"],[[26815.2,24729,0.0384922],359.972,"Mort"],[[26821.3,24729.1,0.0407047],359.965,"Mort"],[[26769.1,24638.7,0.290344],131.324,"Tank"],[[26774.2,24643.9,0.282555],134.931,"Tank"]]];
        carreteras setVariable ["airport_3",[[[14414.9,16327.8,-0.000991821],207.397,"Tank"],[[14471.9,16383.2,0.0378571],359.939,"Mort"],[[14443,16379.2,0.0369205],359.997,"Mort"],[[14449.4,16376.9,0.0369892],359.996,"Mort"],[[14458,16375.9,0.0369167],359.997,"Mort"],[[14447.2,16397.1,3.71081],269.525,"MG"],[[14472.3,16312,12.1993],317.315,"MG"],[[14411,16229,0.000303268],40.6607,"Tank"],[[14404.4,16235,-0.0169964],50.5741,"Tank"],[[14407.2,16331.7,0.0305004],204.588,"Tank"]]];
        carreteras setVariable ["airport_4",[[[11577.4,11953.6,0.241838],122.274,"Tank"],[[11577.8,11964.3,0.258125],124.324,"Tank"],[[11633.3,11762,0.0372791],359.996,"Mort"],[[11637.3,11768.1,0.043232],0.0110098,"Mort"],[[11637.1,11763.1,0.0394402],0.00529677,"Mort"]],true];
        carreteras setVariable ["airport_5",[[[9064.02,21531.3,0.00117016],138.075,"Tank"],[[9095.12,21552.8,0.614614],157.935,"Tank"],[[9030.28,21531.1,0.261349],157.935,"Mort"],[[9033.91,21534.7,0.295588],157.935,"Mort"]]];
    } else {
        roadsMrk = ["road","road_1","road_2","road_3","road_4","road_5","road_6","road_7","road_8","road_9","road_10","road_11","road_12","road_13","road_14","road_15","road_16","road_17","road_18","road_19","road_20","road_21","road_22","road_23","road_24","road_25","road_26","road_27","road_28","road_29","road_30","road_31","road_32","road_33","road_34","road_35","road_36","road_37","road_38"];
        {_x setMarkerAlpha 0} forEach roadsMrk;
        carreteras setVariable ["airport",[[[12191.2,12605.8,9.43077],0,"MG"],[[12194.2,12599.4,13.3954],0,"AA"],[[12141,12609,0.00088501],0,"Mort"],[[12144.3,12615.9,0],0,"Mort"],[[12156.5,12614.3,0],0,"Mort"],[[12170,12595.9,0.000305176],250.234,"AT"],[[12070.4,12656,0.0098114],23.5329,"Tank"],[[12022.5,12670.9,0.0098114],18.9519,"Tank"]]];
        carreteras setVariable ["airport_1",[[[4782.75,10251.4,18],0,"AA"],[[4716.17,10215.3,13.1149],278.308,"AA"],[[4713.94,10209.3,9.12177],188.973,"MG"],[[4787.34,10248.9,4.99982],188.303,"MG"],[[4740.75,10333.2,20.3206],232.414,"MG"],[[4818.39,10200.1,0.00982666],239.625,"Tank"],[[4765.22,10330.8,0],0,"Mort"],[[4758.21,10328.1,0],0,"Mort"],[[4751.45,10324.4,0],0,"Mort"],[[4745.39,10320.6,0],0,"Mort"],[[4739.97,10283.2,0.00567627],291.41,"AT"],[[4814.19,10245.1,0.00567627],211.414,"AT"],[[4841.34,10158.9,0.0102844],240.137,"Tank"],[[4865.7,10116.7,0.00970459],239.499,"Tank"],[[4888.33,10074.2,0.00982666],235.077,"Tank"]]];
        carreteras setVariable ["airport_2",[[[4717.95,2595.24,12.9766],0,"AA"],[[4714.27,2590.97,8.97349],176.197,"MG"],[[4743.55,2567.69,0.0130215],207.155,"Tank"],[[4775.62,2547.37,0.00691605],210.579,"Tank"],[[4719.88,2582.34,0.00566483],261.79,"AT"],[[4826.5,2558.35,0.00150108],0,"Mort"],[[4821.12,2550.32,0.00147152],0,"Mort"],[[4816.59,2543.65,0.00147247],0,"Mort"],[[4812.77,2518.77,0.00566483],150.397,"AT"]]];
    };
};

listMilBld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F","Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_HelipadSquare_F"];
listbld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"];
swoopShutUp = ["V_RebreatherIA","G_Diving"];

difficultyCoef = if !(isMultiplayer) then {
    0
} else {
    // TODO: Fix this, it needs to be done whenever player leave/join
    floor ((({side group _x == buenos} count playableUnits) - ({side group _x != buenos} count playableUnits)) / 5)
};

if (side (group petros) == west) then {
    swoopShutUp pushBack "U_B_Wetsuit"
} else {
    swoopShutUp pushBack "U_I_Wetsuit"
};

//Pricing values for soldiers, vehicles
if (!isServer) exitWith {};

{server setVariable [_x,50,true]} forEach SDKMil;
{server setVariable [_x,75,true]} forEach (sdkTier1 - SDKMil);
{server setVariable [_x,100,true]} forEach  sdkTier2;
{server setVariable [_x,150,true]} forEach sdkTier3;
//{timer setVariable [_x,0,true]} forEach (vehAttack + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA] + vehCSATAttackHelis + vehAA + vehMRLS);
{timer setVariable [_x,3,true]} forEach [staticATmalos,staticAAmalos];
{timer setVariable [_x,6,true]} forEach [staticATmuyMalos,staticAAmuymalos];
{timer setVariable [_x,0,true]} forEach vehNATOAPC;
{timer setVariable [_x,10,true]} forEach vehCSATAPC;
timer setVariable [vehNATOTank,0,true];
timer setVariable [vehCSATTank,10,true];
timer setVariable [vehNATOAA,0,true];
timer setVariable [vehCSATAA,3,true];
timer setVariable [vehNATOBoat,3,true];
timer setVariable [vehCSATBoat,3,true];
timer setVariable [vehNATOPlane,0,true];
timer setVariable [vehCSATPlane,10,true];
timer setVariable [vehNATOPlaneAA,0,true];
timer setVariable [vehCSATPlaneAA,10,true];
{timer setVariable [_x,1,true]} forEach vehNATOTransportHelis - [vehNATOPatrolHeli];
{timer setVariable [_x,10,true]} forEach vehCSATTransportHelis - [vehCSATPatrolHeli];
{timer setVariable [_x,0,true]} forEach vehNATOAttackHelis;
{timer setVariable [_x,10,true]} forEach vehCSATAttackHelis;
timer setVariable [vehNATOMRLS,0,true];
timer setVariable [vehCSATMRLS,5,true];


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
// Initial % FIA support on each city
prestigeBLUFOR = 0;
cuentaCA = 1200 + random(1200);
timeSinceLastAttack = 0;
cuentaCANonBuenos = 1800 + random(1800);
nextTick = 0;
bombRuns = 0;
cityIsSupportChanging = false;
resourcesIsChanging = false;
savingServer = false;
revelar = false;
prestigeIsChanging = false;
markersChanging = [];
staticsToSave = [];
napalmCurrent = false;
tierWar = 1;
haveRadio = false;
haveNV = false;
zoneCheckInProgress = false;
garrisonIsChanging = false;
playerHasBeenPvP = [];
misiones = []; publicVariable "misiones";
movingMarker = false;
if !(hayIFA) then {
    unlockedItems = ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_grn","H_Booniehat_dirty","H_Cap_oli","H_Cap_blk","H_MilCap_rucamo","H_MilCap_gry","H_BandMask_blk","H_Bandanna_khk","H_Bandanna_gry","H_Bandanna_camo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_ShemagOpen_tan","H_Beret_grn","H_Beret_grn_SF","H_Watchcap_camo","H_TurbanO_blk","H_Hat_camo","H_Hat_tan","H_Beret_blk","H_Beret_red","H_Watchcap_khk","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli","G_Bandanna_beast","G_Tactical_Black","G_Aviator","G_Shades_Black","acc_flashlight"] + uniformsSDK + civUniforms;//Initial Arsenal available items
    if (side group petros == independent) then {unlockedItems pushBack "I_UavTerminal"} else {unlockedItems pushBack "B_UavTerminal"};
} else {
    unlockedItems = ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","LIB_ToolKit","H_LIB_CIV_Villager_Cap_1","H_LIB_CIV_Worker_Cap_2","G_LIB_Scarf2_B","G_LIB_Mohawk"] + uniformsSDK + civUniforms;
};


//The following are the initial weapons and mags unlocked and available in the Arsenal, vanilla or RHS

if (!activeGREF) then {
    if !(hayIFA) then {
        unlockedWeapons = ["hgun_PDW2000_F","hgun_Pistol_01_F","hgun_ACPC2_F","Binocular","SMG_05_F","SMG_02_F"];//"LMG_03_F"
        unlockedRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
        unlockedMagazines = ["9Rnd_45ACP_Mag","30Rnd_9x21_Mag","30Rnd_762x39_Mag_F","MiniGrenade","1Rnd_HE_Grenade_shell","30Rnd_545x39_Mag_F","30Rnd_9x21_Mag_SMG_02","10Rnd_9x21_Mag","200Rnd_556x45_Box_F","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandSmall_Remote_Mag","IEDUrbanSmall_Remote_Mag"];
        initialRifles = ["hgun_PDW2000_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","SMG_02_F"];
        //unlockedItems = unlockedItems + ["V_Chestrig_khk","V_BandollierB_cbr","V_BandollierB_rgr","U_C_HunterBody_grn"];
        if !(isMultiplayer) then {
            unlockedWeapons append ["arifle_AKM_F","arifle_AKS_F"];
            unlockedRifles append ["arifle_AKM_F","arifle_AKS_F"];
            initialRifles append ["arifle_AKM_F","arifle_AKS_F"];
            if (worldName == "Tanoa") then {
                unlockedWeapons pushBack "launch_RPG7_F";
                unlockedAT = ["launch_RPG7_F"];
                unlockedMagazines pushBack "RPG7_F";
            } else {
                if (worldName == "Altis") then {
                    unlockedWeapons pushBack "launch_MRAWS_olive_rail_F";
                    unlockedAT = ["launch_MRAWS_olive_rail_F"];
                    unlockedMagazines pushBack "MRAWS_HEAT_F";
                };
            };
        };
        unlockedItems = unlockedItems + ["U_C_HunterBody_grn"];
    } else {
        unlockedWeapons = ["LIB_PTRD","LIB_M2_Flamethrower","LIB_Binocular_GER","LIB_K98","LIB_M1895","LIB_FLARE_PISTOL"];//"LMG_03_F"
        unlockedRifles = ["LIB_K98"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
        unlockedMagazines = ["LIB_1Rnd_145x114","LIB_M2_Flamethrower_Mag","LIB_5Rnd_792x57","LIB_Pwm","LIB_Rg42","LIB_US_TNT_4pound_mag","LIB_7Rnd_762x38","LIB_1Rnd_flare_red","LIB_1Rnd_flare_green","LIB_1Rnd_flare_white","LIB_1Rnd_flare_yellow"];
        initialRifles = ["LIB_K98"];
        unlockedAT = [];
    };
} else {
    unlockedWeapons = ["rhs_weap_akms","rhs_weap_makarov_pmm","Binocular","rhs_weap_rpg7","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_pp2000_folded","rhs_weap_savz61","rhs_weap_m3a1","rhs_weap_m1garand_sa43"];
    unlockedRifles = ["rhs_weap_akms","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_savz61","rhs_weap_m3a1","rhs_weap_m1garand_sa43"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
    unlockedMagazines = ["rhs_30Rnd_762x39mm","rhs_mag_9x18_12_57N181S","rhs_rpg7_PG7VL_mag","rhsgref_5Rnd_762x54_m38","rhsgref_5Rnd_792x57_kar98k","rhs_mag_rgd5","rhs_mag_9x19mm_7n21_20","rhsgref_20rnd_765x17_vz61","rhsgref_30rnd_1143x23_M1911B_SMG","rhsgref_8Rnd_762x63_M2B_M1rifle"];
    initialRifles = ["rhs_weap_akms","rhs_weap_m38_rail","rhs_weap_kar98k","rhs_weap_savz61"];
    unlockedItems = unlockedItems + ["rhs_acc_2dpZenit"];
    unlockedAT = ["rhs_weap_rpg7"];
};

{
    _loadOut = getUnitLoadout (_x select 0);
    _vest = _loadOut select 4;
    if !(_vest isEqualTo []) then {unlockedItems pushBackUnique (_vest select 0)};
} forEach [SDKSniper,SDKATman,SDKMedic,SDKMG,SDKExp,SDKGL,SDKMil,SDKSL,SDKEng,[SDKUnarmed],[staticCrewBuenos]];

unlockedBackpacks = if !(hayIFA) then {["B_FieldPack_oli","B_FieldPack_blk","B_FieldPack_ocamo","B_FieldPack_oucamo","B_FieldPack_cbr"]} else {["B_LIB_US_M2Flamethrower","B_LIB_SOV_RA_MGAmmoBag_Empty"]}; //Initial Arsenal available backpacks
//lockedMochis = lockedMochis - unlockedBackpacks;
unlockedOptics = [];
unlockedMG = [];
unlockedGL = [];
unlockedSN = [];
unlockedAA = [];
garageIsUsed = false;
vehInGarage = [];
destroyedBuildings = []; //publicVariable "destroyedBuildings";
reportedVehs = [];
hayTFAR = false;
hayACRE = false;
hayACE = false;
hayACEhearing = false;
hayACEMedical = false;

//TFAR detection and config.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    hayTFAR = true;
    haveRadio = true;
    unlockedItems = unlockedItems + ["tf_microdagr","tf_anprc148jem"];//making this items Arsenal available.["tf_anprc152"]
    tf_no_auto_long_range_radio = true; publicVariable "tf_no_auto_long_range_radio";//set to false and players will start with LR radio, uncomment the last line of so.
    if (hayIFA) then {
        tf_give_personal_radio_to_regular_soldier = false;
        publicVariable "tf_give_personal_radio_to_regular_soldier";
    } else {
        unlockedItems = unlockedItems + ["tf_microdagr","tf_anprc148jem"];
    };
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
    "ACE_wirecutter",
    "ACE_RangeTable_82mm",
    "ACE_EntrenchingTool",
    "ACE_Cellphone",
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
if (hayIFA) then {aceItems append ["ACE_LIB_LadungPM","ACE_SpareBarrel"]};
publicVariable "aceItems";

aceBasicMedItems = [
    "ACE_fieldDressing",
    "ACE_bloodIV_500",
    "ACE_bloodIV",
    "ACE_epinephrine",
    "ACE_morphine",
    "ACE_bodyBag"
]; publicVariable "aceBasicMedItems";

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
]; publicVariable "aceAdvMedItems";


if (!isNil "ace_common_fnc_isModLoaded") then {
    unlockedItems = unlockedItems + aceItems;
    if !(hayIFA) then {
        unlockedBackpacks pushBackUnique "ACE_TacticalLadder_Pack";
        unlockedWeapons pushBackUnique "ACE_VMH3";
        itemsAAF = itemsAAF + ["ACE_Kestrel4500","ACE_ATragMX"];
        armasNATO = armasNATO + ["ACE_M84"];
    };
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

if (isClass(configFile >> "cfgPatches" >> "acre_main")) then {
    hayACRE = true;
    haveRadio = true;
    unlockedItems = unlockedItems + ["ACRE_PRC343","ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"];
};

//allItems = allItems + itemsAAF + opticasAAF + _vests + cascos + NVGoggles;

if (worldName == "Tanoa") then {
    {server setVariable [_x select 0,_x select 1]} forEach [["Lami01",277],["Lifou01",350],["Lobaka01",64],["LaFoa01",38],["Savaka01",33],["Regina01",303],["Katkoula01",413],["Moddergat01",195],["Losi01",83],["Tanouka01",380],["Tobakoro01",45],["Georgetown01",347],["Kotomo01",160],["Rautake01",113],["Harcourt01",325],["Buawa01",44],["SaintJulien01",353],["Balavu01",189],["Namuvaka01",45],["Vagalala01",174],["Imone01",31],["Leqa01",45],["Blerick01",71],["Yanukka01",189],["OuaOue01",200],["Cerebu01",22],["Laikoro01",29],["Saioko01",46],["Belfort01",240],["Oumere01",333],["Muaceba01",18],["Nicolet01",224],["Lailai01",23],["Doodstil01",101],["Tavu01",178],["Lijnhaven01",610],["Nani01",19],["PetitNicolet01",135],["PortBoise01",28],["SaintPaul01",136],["Nasua01",60],["Savu01",184],["Murarua01",258],["Momea01",159],["LaRochelle01",532],["Koumac01",51],["Taga01",31],["Buabua01",27],["Penelo01",189],["Vatukoula01",15],["Nandai01",130],["Tuvanaka01",303],["Rereki01",43],["Ovau01",226],["IndPort01",420],["Ba01",106]];
    call compile preprocessFileLineNumbers "roadsDB.sqf";
} else {
    if (worldName == "Altis") then {
        call compile preprocessFileLineNumbers "roadsDBAltis.sqf";
        {server setVariable [_x select 0,_x select 1]} forEach [["Therisa",154],["Zaros",371],["Poliakko",136],["Katalaki",95],["Alikampos",115],["Neochori",309],["Stavros",122],["Lakka",173],["AgiosDionysios",84],["Panochori",264],["Topolia",33],["Ekali",9],["Pyrgos",531],["Orino",45],["Neri",242],["Kore",133],["Kavala",660],["Aggelochori",395],["Koroni",32],["Gravia",291],["Anthrakia",143],["Syrta",151],["Negades",120],["Galati",151],["Telos",84],["Charkia",246],["Athira",342],["Dorida",168],["Ifestiona",48],["Chalkeia",214],["AgiosKonstantinos",39],["Abdera",89],["Panagia",91],["Nifi",24],["Rodopoli",212],["Kalithea",36],["Selakano",120],["Frini",69],["AgiosPetros",11],["Feres",92],["AgiaTriada",8],["Paros",396],["Kalochori",189],["Oreokastro",63],["Ioannina",48],["Delfinaki",29],["Sofia",179],["Molos",188]];
    } else {
        if (worldName == "chernarus_summer") then {
            call compile preprocessFileLineNumbers "roadsDBcherna.sqf";
            {server setVariable [_x select 0,_x select 1]} forEach [["vill_NovySobor",129],["city_StarySobor",149],["vill_Guglovo",26],["vill_Vyshnoye",41],["vill_Kabanino",86],["vill_Rogovo",66],["vill_Mogilevka",104],["city_Gorka",115],["vill_Grishino",168],["vill_Shakhovka",55],["vill_Pogorevka",57],["vill_Pulkovo",26],["vill_Nadezhdino",109],["city_Vybor",180],["vill_Polana",118],["vill_Staroye",115],["vill_Dubrovka",86],["vill_Pustoshka",163],["vill_Kozlovka",100],["vill_Pusta",52],["vill_Dolina",83],["vill_Gvozdno",78],["vill_Prigorodki",145],["vill_Drozhino",58],["vill_Sosnovka",54],["vill_Msta",96],["vill_Lopatino",159],["city_Zelenogorsk",280],["vill_Orlovets",65],["city_Berezino",340],["vill_Myshkino",49],["vill_Petrovka",45],["city_Chernogorsk",761],["vill_Bor",46],["vill_Nizhnoye",146],["vill_Balota",147],["vill_Khelm",110],["city_Krasnostav",194],["vill_Komarovo",127],["city_Elektrozavodsk",745],["city_Solnychniy",224],["vill_Kamyshovo",196],["vill_Tulga",35],["vill_Pavlovo",99],["vill_Kamenka",127],["hill_Olsha",20]];
        };
    };
};

if (isDedicated) then {civPerc = 70; publicVariable "civPerc"};

publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";
publicVariable "garageIsUsed";
publicVariable "vehInGarage";
publicVariable "reportedVehs";
publicVariable "hayACE";
publicVariable "hayTFAR";
publicVariable "hayACRE";
publicVariable "hayACEhearing";
publicVariable "hayACEMedical";
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
publicVariable "initialRifles";

if (isMultiplayer) then {[[petros,"hint","Variables Init Completed"],"A3A_fnc_commsMP"] call BIS_fnc_MP;};