#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3A_core"};
        author = AUTHOR;
        authors[] = { AUTHORS };
        authorUrl = "";
        VERSION_CONFIG;
    };
};

class CfgMissions
{
    class MPMissions
    {
        class Antistasi_Altis
        {
            briefingName = $STR_antistasi_mission_info_altis_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Altis.Altis";
        };
        class Antistasi_cam_lao_nam
        {
            briefingName = $STR_antistasi_mission_info_camlaonam_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_cam_lao_nam.cam_lao_nam";
        };
        class Antistasi_chernarus_summer
        {
            briefingName = $STR_antistasi_mission_info_cherna_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_chernarus_summer.chernarus_summer";
        };
        class Antistasi_chernarus_winter
        {
            briefingName = $STR_antistasi_mission_info_chernawinter_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_chernarus_winter.chernarus_winter";
        };
        class Antistasi_Enoch
        {
            briefingName = $STR_antistasi_mission_info_livonia_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Enoch.Enoch";
        };
        class Antistasi_Kunduz
        {
            briefingName = $STR_antistasi_mission_info_kunduz_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Kunduz.Kunduz";
        };
        class Antistasi_Malden
        {
            briefingName = $STR_antistasi_mission_info_malden_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Malden.Malden";
        };
        class Antistasi_sara
        {
            briefingName = $STR_antistasi_mission_info_sahrani_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_sara.sara";
        };

        class Antistasi_Stratis
        {
            briefingName = $STR_antistasi_mission_info_stratis_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Stratis.Stratis";
        };

        class Antistasi_takistan
        {
            briefingName = $STR_antistasi_mission_info_takistan_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_takistan.takistan";
        };
        class Antistasi_Tanoa
        {
            briefingName = $STR_antistasi_mission_info_tanoa_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Tanoa.Tanoa";
        };
        class Antistasi_tem_anizay
        {
            briefingName = $STR_antistasi_mission_info_anizay_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_tem_anizay.tem_anizay";
        };
        class Antistasi_Tembelan
        {
            briefingName = $STR_antistasi_mission_info_tembelan_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Tembelan.Tembelan";
        };
        class Antistasi_vt7
        {
            briefingName = $STR_antistasi_mission_info_virolahti_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_vt7.vt7";
        };
    };
};
