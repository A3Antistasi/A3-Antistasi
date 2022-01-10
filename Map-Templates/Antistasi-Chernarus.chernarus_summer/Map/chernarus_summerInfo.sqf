/*
    Author: []
    [Description]
        map data getter

    Arguments:
    0. <String> key for globals need in file

	Return:
	0. <any> data returned

    Scope: Server
    Environment: scheduled 
    Public: [yes]
    Dependencies:

    Example:
	private _fnc_mapInfo = compile preProcessFileLineNumbers ("Map\"+ toLower worldName +"Info.sqf");
	("antennas" call _fnc_mapInfo) params [["_posAntennas", [], [[]]], ["_blacklistIndex",[],[[]]]];

    License: MIT license 
*/
#include "..\Includes\common.inc"

params["_filename", ""];

switch (_filename) do {
		case "population": {
		private _popValue = [["vill_NovySobor",129],["city_StarySobor",149],["vill_Guglovo",26],["vill_Vyshnoye",41],["vill_Kabanino",86],["vill_Rogovo",66],["vill_Mogilevka",104],["city_Gorka",115],
		["vill_Grishino",168],["vill_Shakhovka",55],["vill_Pogorevka",57],["vill_Pulkovo",26],["vill_Nadezhdino",109],["city_Vybor",180],["vill_Polana",118],["vill_Staroye",115],
		["vill_Dubrovka",86],["vill_Pustoshka",163],["vill_Kozlovka",100],["vill_Pusta",52],["vill_Dolina",83],["vill_Gvozdno",78],["vill_Prigorodki",145],["vill_Drozhino",58],
		["vill_Sosnovka",54],["vill_Msta",96],["vill_Lopatino",159],["city_Zelenogorsk",280],["vill_Orlovets",65],["city_Berezino",340],["vill_Myshkino",49],["vill_Petrovka",45],
		["city_Chernogorsk",761],["vill_Bor",46],["vill_Nizhnoye",146],["vill_Balota",147],["vill_Khelm",110],["city_Krasnostav",194],["vill_Komarovo",127],["city_Elektrozavodsk",745],
		["city_Solnychniy",224],["vill_Kamyshovo",196],["vill_Tulga",35],["vill_Pavlovo",99],["vill_Kamenka",127],["vill_Olsha",20]];

		
		
		//[_popValue, _disableTownName];
		[_popValue, nil];
	};
	case "antennas": {
		private _posAntennas =
		[[3029.11,2350.27,0.229149], [4547.68,3132.05,0.693176], [3715.81,5984.25,0], [6563.68,3405.56,0.0547333],
		[5264.35,5314.45,-0.00253296], [6443.78,6545.48,0.0928955], [4967.81,9966.56,0], [8127.52,9151.57,0],
		[13477.6,3345.84,0.0730896], [13010.1,5964.96,-0.0163116], [12937,12763.6,0.164017]];
		private _blacklistIndex = [0, 4, 8, 9];

		//[_posAntennas, _blacklistIndex,]
		[_posAntennas, _blacklistIndex];
	};
	case "bank": {
		//_posBank
		[nil];
	};
	case "garrison": {
		private _mrkCSAT = ["outpost_21"];

		//[_mrkNATO, _mrkCSAT, _controlsNATO, _controlsCSAT];
		[nil, _mrkCSAT, nil, nil];
	};
	case "climate": {
	"temperate";
	};
	case "fuelStationTypes":{
		private _fuelStationTypes = ["Land_A_FuelStation_Feed"];
		//_fuelStationTypes
		[_fuelStationTypes];
	};
	default {
		Info("Map Info given unknown parameter");
	};
};