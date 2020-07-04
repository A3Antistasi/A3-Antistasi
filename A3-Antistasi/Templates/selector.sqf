/*
    This file controls the selection of templates based on the mods loaded and map used.
    When porting new mods/maps be sure to add them to their respective sections!
*/

//Map checker
aridmaps = ["Altis","Kunduz","Malden","tem_anizay","Tembelan"];
tropicalmaps = ["Tanoa"];
temperatemaps = ["Enoch","chernarus_summer","vt7"];
arcticmaps = ["chernarus_winter"];
//Mod selector

if(teamplayer != independent){//This section is for Altis Blufor ONLY!
  switch(true) do {
    case (has3CB): {
      call compile preProcessFileLineNumbers "Templates\3CB_Reb_TPGM_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\BAF_Occ_TKA_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\3CB_Inv_TKM_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\3CB_Civ.sqf";
    };
    case (hasRHS): {
      call compile preProcessFileLineNumbers "Templates\RHS_Reb_CDF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Occ_CDF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Civ.sqf";
    };
    default {
      call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_B_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_AAF_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Civ.sqf";
    };
  };
}else{//This is for non-blufor (THE ONE THAT MATTERS!!)
  switch(true) do{
    case (has3CB): {
      switch(mapname in) do {
        case (arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\BAF_Occ_BAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_UKN_Temp.sqf";
        };
        case (temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\BAF_Occ_BAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_UKN_Temp.sqf";
        };
        case (tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Trop.sqf";
          call compile preProcessFileLineNumbers "Templates\BAF_Occ_BAF_Trop.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_UKN_Trop.sqf";
        };
        default {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_TTF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\BAF_Occ_BAF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_TKM_Arid.sqf";
        };
      };
      call compile preProcessFileLineNumbers "Templates\3CB_Civ.sqf";
    };
    case (hasRHS): {
      switch(mapname in) do {
        case (arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Wdl.sqf";
        };
        case (temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Wdl.sqf";
        };
        case (tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Wdl.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Wdl.sqf";
        };
        default {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Arid.sqf";
        };
      };
      call compile preProcessFileLineNumbers "Templates\RHS_Civ.sqf";
    };
    case (hasIFA): {
      switch(mapname in) do {
        case (arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arct.sqf";
        };
        case (temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
        };
        case (tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
        };
        default {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arid.sqf";
        };
      };
      call compile preProcessFileLineNumbers "Templates\IFA_Civ.sqf";
    };
    default {
      switch(mapname) do {//This one (vanilla) works differently so that we don't get DLC kit on modded maps.
        case ("Enoch"): {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Enoch.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_WDL.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Enoch.sqf";
        };
        case ("Tanoa"): {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Tanoa.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Tanoa.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Tanoa.sqf";
        };
        default {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Altis.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Altis.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Altis.sqf";
        };
      };
      call compile preProcessFileLineNumbers "Templates\Vanilla_Civ.sqf";
    };
  };
};
