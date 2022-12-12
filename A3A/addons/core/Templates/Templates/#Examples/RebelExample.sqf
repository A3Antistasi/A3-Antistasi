///////////////////////////
//   Rebel Information   //
///////////////////////////

["name", ""] call _fnc_saveToTemplate;

["flag", ""] call _fnc_saveToTemplate;
["flagTexture", ""] call _fnc_saveToTemplate;
["flagMarkerType", ""] call _fnc_saveToTemplate;

["vehicleBasic", ""] call _fnc_saveToTemplate;
["vehicleLightUnarmed", ""] call _fnc_saveToTemplate;
["vehicleLightArmed", ""] call _fnc_saveToTemplate;
["vehicleTruck", ""] call _fnc_saveToTemplate;
["vehicleAT", ""] call _fnc_saveToTemplate;
["vehicleAA", ""] call _fnc_saveToTemplate;

["vehicleBoat", ""] call _fnc_saveToTemplate;
["vehicleRepair", ""] call _fnc_saveToTemplate;

["vehiclePlane", ""] call _fnc_saveToTemplate;
["vehicleHeli", ""] call _fnc_saveToTemplate;

["vehicleCivCar", ""] call _fnc_saveToTemplate;
["vehicleCivTruck", ""] call _fnc_saveToTemplate;
["vehicleCivHeli", ""] call _fnc_saveToTemplate;
["vehicleCivBoat", ""] call _fnc_saveToTemplate;

["staticMG", ""] call _fnc_saveToTemplate;
["staticAT", ""] call _fnc_saveToTemplate;
["staticAA", ""] call _fnc_saveToTemplate;
["staticMortar", ""] call _fnc_saveToTemplate;
["staticMortarMagHE", ""] call _fnc_saveToTemplate;
["staticMortarMagSmoke", ""] call _fnc_saveToTemplate;

["mineAT", ""] call _fnc_saveToTemplate;
["mineAPERS", ""] call _fnc_saveToTemplate;

["breachingExplosivesAPC", []] call _fnc_saveToTemplate;
["breachingExplosivesTank", []] call _fnc_saveToTemplate;

///////////////////////////
//  Rebel Starting Gear  //
///////////////////////////

private _initialRebelEquipment = [];

if (A3A_hasTFAR) then {_initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
if (A3A_hasTFAR && startWithLongRangeRadio) then {_initialRebelEquipment append ["tf_anprc155","tf_anprc155_coyote"]};
if (A3A_hasTFARBeta) then {_initialRebelEquipment append ["TFAR_microdagr","TFAR_anprc154"]};
if (A3A_hasTFARBeta && startWithLongRangeRadio) then {_initialRebelEquipment append ["TFAR_anprc155","TFAR_anprc155_coyote"]};
["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;

private _rebUniforms = [];          //Uniforms given to Normal Rebels

private _dlcUniforms = [];          //Uniforms given if DLCs are enabled, only given to the Arsenal not Rebels

if (allowDLCEnoch) then {_dlcUniforms append [];
};

if (allowDLCExpansion) then {_dlcUniforms append [];
};

["uniforms", _rebUniforms + _dlcUniforms] call _fnc_saveToTemplate;         //These Items get added to the Arsenal

["headgear", []] call _fnc_saveToTemplate;          //Headgear used by Rebell Ai until you have Armored Headgear.

/////////////////////
///  Identities   ///
/////////////////////

//Faces and Voices given to Rebell AI
["faces", []] call _fnc_saveToTemplate;
["voices", []] call _fnc_saveToTemplate;

//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _fnc_createLoadoutData;
_loadoutData set ["maps", ["ItemMap"]];
_loadoutData set ["watches", ["ItemWatch"]];
_loadoutData set ["compasses", ["ItemCompass"]];
_loadoutData set ["binoculars", ["Binocular"]];

_loadoutData set ["uniforms", _rebUniforms];

_loadoutData set ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

////////////////////////
//  Rebel Unit Types  //
///////////////////////.

private _squadLeaderTemplate = {
    ["uniforms"] call _fnc_setUniform;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["binoculars"] call _fnc_addBinoculars;
};

private _riflemanTemplate = {
    ["uniforms"] call _fnc_setUniform;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
};

private _prefix = "militia";
private _unitTypes = [
    ["Petros", _squadLeaderTemplate],
    ["SquadLeader", _squadLeaderTemplate],
    ["Rifleman", _riflemanTemplate],
    ["staticCrew", _riflemanTemplate],
    ["Medic", _riflemanTemplate, [["medic", true]]],
    ["Engineer", _riflemanTemplate, [["engineer", true]]],
    ["ExplosivesExpert", _riflemanTemplate, [["explosiveSpecialist", true]]],
    ["Grenadier", _riflemanTemplate],
    ["LAT", _riflemanTemplate],
    ["AT", _riflemanTemplate],
    ["AA", _riflemanTemplate],
    ["MachineGunner", _riflemanTemplate],
    ["Marksman", _riflemanTemplate],
    ["Sniper", _riflemanTemplate],
    ["Unarmed", _riflemanTemplate]
];

[_prefix, _unitTypes, _loadoutData] call _fnc_generateAndSaveUnitsToTemplate;
