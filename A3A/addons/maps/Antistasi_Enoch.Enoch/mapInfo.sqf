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
	private _fnc_mapInfo = compile preProcessFileLineNumbers format [ EQPATHTOFOLDER(maps,Antistasi_%1.%1\mapInfo.sqf), worldName];;
	("antennas" call _fnc_mapInfo) params [["_posAntennas", [], [[]]], ["_blacklistIndex",[],[[]]]];

    License: MIT license
*/
#include "..\script_component.hpp"

params["_filename", ""];

switch (_filename) do {
	case "population": {
		//To improve Performance, reduces pop from 13972 to 4850
		private _popValue = [["Adamow",200],["Bielawa",150],["Borek",150],["Brena",150],["Dolnik",100],["Gieraltow",400],["Gliniska",150],["Grabin",250],["Huta",150],["Karlin",50],["Kolembrody",100],
		["Lembork",50],["Lipina",100],["Lukow",200],["Muratyn",50],["Nadbor",600],["Nidek",100],["Olszanka",100],["Polana",100],["Radacz",150],["Radunin",150],["Roztoka",50],
		["Sitnik",150],["Sobotka",100],["Tarnow",200],["Topolin",650],["Zalesie",150],["Zapadlisko",100]];


		//[_popValue, _disableTownName];
		[_popValue, nil];
	};
	case "antennas": {
		private _posAntennas =
		[[3830.61,1827.19,0], [5007.39,2131.27,0], [1583.47,7162.08,0.000152588], [3146.07,7024.41,0.00133514],
		[1408.43,8675.08,-1.00183], [8894.99,2049.1,0.00387573], [2382.53,11479.5,3.05176e-005], [6293.86,9910.17,-7.62939e-006],
		[3585.76,11540.7,-0.000236511], [7906.11,9917.2,0.0120544], [7776.88,10082.3,0.0262146], [7866.34,10102.5,3.05176e-005],
		[6908.45,11119.5,-2.40052], [9257.02,10282.7,0.0631027], [10610.4,10890.6,0.166985], [11172.6,11424.1,-2.82624]];
		private _blacklistIndex = [2, 3, 4, 6, 8, 11, 12, 13, 14, 15];

		//[_posAntennas, _blacklistIndex,]
		[_posAntennas, _blacklistIndex];
	};
	case "bank": {
		//_posBank
		[nil];
	};
	case "garrison": {
		private _mrkCSAT = ["airport_3", "control_14"];
		private _controlsCSAT = ["control_14"];

		//[_mrkNATO, _mrkCSAT, _controlsNATO, _controlsCSAT];
		[nil, _mrkCSAT, nil, _controlsCSAT];
	};
	case "climate": {
	"temperate";
	};
	case "fuelStationTypes":{
		private _fuelStationTypes = ["Land_Fuelstation_Feed_F", "Land_fs_feed_F", "Land_FuelStation_01_pump_F", "Land_FuelStation_01_pump_malevil_F", "Land_FuelStation_03_pump_F", "Land_FuelStation_02_pump_F"];
		//_fuelStationTypes
		[_fuelStationTypes];
	};
	default {
		Info("Map Info given unknown parameter");
	};
};
