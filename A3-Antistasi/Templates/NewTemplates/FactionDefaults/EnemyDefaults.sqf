//////////////////////////
//  Mission/HQ Objects  //
//////////////////////////

// All fo bellow are optional overrides
["firstAidKits", ["FirstAidKit"]] call _fnc_saveToTemplate;  // Relies on autodetection. However, item is tested for for help and reviving.
["mediKits", ["Medikit"]] call _fnc_saveToTemplate;  // Relies on autodetection. However, item is tested for for help and reviving.

["placeIntel_desk", ["Land_CampingTable_F",0]] call _fnc_saveToTemplate;  // [classname,azimuth].
["placeIntel_itemMedium", ["Land_Document_01_F",-155,false]] call _fnc_saveToTemplate;  // [classname,azimuth,isComputer].
["placeIntel_itemLarge", ["Land_Laptop_unfolded_F",-25,true]] call _fnc_saveToTemplate;  // [classname,azimuth,isComputer].
