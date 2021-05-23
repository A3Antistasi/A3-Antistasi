//////////////////////////
//  Mission/HQ Objects  //
//////////////////////////

// All fo bellow are optional overrides.
// The following are vanilla item overrides. If defined, the vanilla item is removed. Does not affect load-outs.
["firstAidKits", ["FirstAidKit"]] call _fnc_saveToTemplate;  // Relies on autodetection. However, item is tested for for help and reviving.
["mediKits", ["Medikit"]] call _fnc_saveToTemplate;  // Relies on autodetection. However, item is tested for for help and reviving.
["toolKits", ["ToolKit"]] call _fnc_saveToTemplate;  // Relies on autodetection.
["itemMaps", ["ItemMap"]] call _fnc_saveToTemplate;  // Relies on autodetection.

// This should be replaced by static loot lists.
["addDiveGear",true] call _fnc_saveToTemplate;
["addFlightGear",true] call _fnc_saveToTemplate;