//Game start
class first_load 		{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = $STR_antistasi_dialogs_lps_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_yes_text;
			tooltip = $STR_antistasi_dialogs_generic_button_yes_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [] spawn A3A_fnc_loadPreviousSession;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_no_text;
			tooltip = $STR_antistasi_dialogs_generic_button_no_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			//action = "closeDialog 0;if ((player == theBoss) and (isNil ""placementDone"") and !(isMultiplayer)) then {_nul = [] spawn A3A_fnc_placementselection};";
			action = "closeDialog 0;if ((player == theBoss) and (isNil ""placementDone"") and !(isMultiplayer)) then {closeDialog 0;[] execVM ""dialogs\difficultyMenu.sqf""};";
		};
	};
};

//FLAG
class HQ_menu 			{
	idd=100;
	movingenable=false;

	class controls {
		//Structure
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = $STR_antistasi_dialogs_hq_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		//Buttons L and R
		class HQ_button_load: RscButton
		{
			idc = 104; 	//L1
			text = $STR_antistasi_dialogs_hq_button_withdraw_text;
			tooltip = $STR_antistasi_dialogs_hq_button_withdraw_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (isMultiPlayer) then {if (player == theBoss) then {nul=call A3A_fnc_theBossSteal} else {hint ""Only Player Commander has access to this function""}} else {hint ""This function is MP only""};";
		};
		class HQ_button_savegame: RscButton
		{
			idc = 105; 	//L2
			text = $STR_antistasi_dialogs_hq_button_garrisons_text;
			tooltip = $STR_antistasi_dialogs_hq_button_garrisons_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (player == theBoss) then {nul=CreateDialog ""build_menu""} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_moveHQ: RscButton
		{
			idc = 106;	//L3
			text = $STR_antistasi_dialogs_hq_button_move_headquarters_text;
			tooltip = $STR_antistasi_dialogs_hq_button_move_headquarters_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (player == theBoss) then {nul = [] spawn A3A_fnc_moveHQ;} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_recruitUnit: RscButton
		{
			idc = 107;	//R1
			text = $STR_antistasi_dialogs_hq_button_members_list_text;
			tooltip = $STR_antistasi_dialogs_hq_button_members_list_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (isMultiplayer) then {nul = [] call A3A_fnc_membersList} else {hint ""This function is MP only""}} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_recruitSquad: RscButton
		{
			idc = 108;	//R2
			text = $STR_antistasi_dialogs_hq_button_rebuild_assets_text;
			tooltip = $STR_antistasi_dialogs_hq_button_rebuild_assets_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (player == theBoss) then {nul=[] spawn A3A_fnc_rebuildAssets} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_vehicle: RscButton
		{
			idc = 109;	//R3
			text = $STR_antistasi_dialogs_hq_button_train_ai_text;
			tooltip = $STR_antistasi_dialogs_hq_button_train_ai_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (player == theBoss) then {nul = [] call A3A_fnc_FIAskillAdd} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_skill: RscButton
		{
			idc = 110;	//M4
			text = $STR_antistasi_dialogs_hq_button_garage_text;
			tooltip = $STR_antistasi_dialogs_hq_button_garage_tooltip;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = QUOTE(closeDialog 0;nul = [GARAGE_FACTION] spawn A3A_fnc_garage);
		};
	};
}; 										//slots: 6+1
class build_menu  			{
	idd=-1;
	movingenable=false;

	class controls {
		//Structure
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = $STR_antistasi_dialogs_build_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""HQ_menu"";";
		};
		//Action Buttons
		class 4slots_L1: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_build_minefield_button_text;
			tooltip = $STR_antistasi_dialogs_build_minefield_button_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""minebuild_menu"";";
		};
		class 4slots_R1: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_build_outpost_button_text;
			tooltip = $STR_antistasi_dialogs_build_outpost_button_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; [""create""] spawn A3A_fnc_outpostDialog";
		};
		class 4slots_L2: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_build_recruit_units_button_text;
			tooltip = $STR_antistasi_dialogs_build_recruit_units_button_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; [""add""] spawn A3A_fnc_garrisonDialog";
		};
		class 4slots_R2: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_build_disband_units_button_text;
			tooltip = $STR_antistasi_dialogs_build_disband_units_button_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; [""rem""] spawn A3A_fnc_garrisonDialog";
		};
	};
}; 										//slots: 4
class garrison_recruit 			{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = $STR_antistasi_dialogs_garrison_recruit_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			tooltip = $STR_antistasi_dialogs_generic_button_back_tooltip;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""build_menu"";";
		};
		class HQ_button_rifleman: RscButton
		{
			idc = 104;
			text = $STR_antistasi_dialogs_garrison_spawn_rifleman_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMil] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_autorifleman: RscButton
		{
			idc = 105;
			text = $STR_antistasi_dialogs_garrison_spawn_autorifleman_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMG] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_medic: RscButton
		{
			idc = 126;
			text = $STR_antistasi_dialogs_garrison_spawn_medic_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMedic] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_engineer: RscButton
		{
			idc = 107;
			text = $STR_antistasi_dialogs_garrison_spawn_squad_lead_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKSL] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_explosive: RscButton
		{
			idc = 108;
			text = $STR_antistasi_dialogs_garrison_spawn_mortar_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [staticCrewTeamPlayer] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_grenadier: RscButton
		{
			idc = 109;
			text = $STR_antistasi_dialogs_garrison_spawn_grenadier_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKGL] spawn A3A_fnc_garrisonAdd";
		};
		class HQ_button_marksman: RscButton
		{
			idc = 110;
			text = $STR_antistasi_dialogs_garrison_spawn_marksman_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKSniper] spawn A3A_fnc_garrisonAdd";
		};

		class HQ_button_AT: RscButton
		{
			idc = 111;
			text = $STR_antistasi_dialogs_garrison_spawn_at_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKATman] spawn A3A_fnc_garrisonAdd";
		};
	};
};										//slots: 8
class minebuild_menu 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = $STR_antistasi_dialogs_minefield_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""build_menu"";";
		};
		class HQ_button_mortar: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_minefield_button_anti_personel_text;
			tooltip = $STR_antistasi_dialogs_minefield_button_anti_personel_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;[""APERSMine""] spawn A3A_fnc_mineDialog";
		};
		class HQ_button_MG: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_minefield_button_remove_text;
			tooltip = $STR_antistasi_dialogs_minefield_button_remove_tooltip;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; [""delete""] spawn A3A_fnc_mineDialog;";
		};
		class HQ_button_AT: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_minefield_button_anti_tank_text;
			tooltip = $STR_antistasi_dialogs_minefield_button_anti_tank_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; [""ATMine""] spawn A3A_fnc_mineDialog";
		};
	};
};
class unit_recruit 		{
	idd= 100;
	movingenable=false;
	class controls {
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = $STR_antistasi_dialogs_unit_recruit_frame_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_rifleman: RscButton
		{
			idc = 104;
			text = $STR_antistasi_dialogs_unit_recruit_militiaman_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMil] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_autorifleman: RscButton
		{
			idc = 105;
			text = $STR_antistasi_dialogs_unit_recruit_mg_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMG] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_medic: RscButton
		{
			idc = 126;
			text = $STR_antistasi_dialogs_unit_recruit_medic_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKMedic] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_engineer: RscButton
		{
			idc = 107;
			text = $STR_antistasi_dialogs_unit_recruit_engineer_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKEng] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_explosive: RscButton
		{
			idc = 108;
			text = $STR_antistasi_dialogs_unit_recruit_explosive_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKExp] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_grenadier: RscButton
		{
			idc = 109;
			text = $STR_antistasi_dialogs_unit_recruit_grenadier_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKGL] spawn A3A_fnc_reinfPlayer";
		};
		class HQ_button_marksman: RscButton
		{
			idc = 110;
			text = $STR_antistasi_dialogs_unit_recruit_marksman_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKSniper] spawn A3A_fnc_reinfPlayer";
		};

		class HQ_button_AT: RscButton
		{
			idc = 111;
			text = $STR_antistasi_dialogs_unit_recruit_antitank_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [SDKATman] spawn A3A_fnc_reinfPlayer";
		};
	};
};
class vehicle_option 	{
	idd=-1;
	movingenable=false;

	class controls {

		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Buy Vehicle"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_vehicle_purchase_civie_text;
			tooltip = $STR_antistasi_dialogs_vehicle_purchase_civie_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul=[] execVM ""Dialogs\buy_vehicle_civ.sqf"";";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_vehicle_purchase_military_text;
			tooltip = $STR_antistasi_dialogs_vehicle_purchase_military_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle.sqf"";";
		};
	};
};
class buy_vehicle 			{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = $STR_antistasi_dialogs_vehicle_purchase_military_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0; nul = createDialog ""vehicle_option"";";
		};
		class HQ_button_quad: RscButton
		{
			idc = 104;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_quad_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closedialog 0; nul = [vehSDKBike] spawn A3A_fnc_addFIAveh";
		};
		class HQ_button_offroad: RscButton
		{
			idc = 105;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_offroad_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [vehSDKLightUnarmed] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_truck: RscButton
		{
			idc = 106;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_truck_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [vehSDKTruck] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_Aoffroad: RscButton
		{
			idc = 107;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_a_offroad_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [vehSDKLightArmed] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_MG: RscButton
		{
			idc = 108;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_mg_text;
			tooltip = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_mg_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [SDKMGStatic] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_mortar: RscButton
		{
			idc = 109;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_mortar_text;
			tooltip = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_mortar_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [SDKMortar] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_AT: RscButton
		{
			idc = 110;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_at_text;
			tooltip = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_at_tooltip;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [staticATteamPlayer] spawn A3A_fnc_addFIAveh;";
		};

		class HQ_button_AA: RscButton
		{
			idc = 111;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_aa_text;
			tooltip = $STR_antistasi_dialogs_dialog_vehicle_purchase_military_s_aa_tooltip;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [staticAAteamPlayer] spawn A3A_fnc_addFIAveh;";
		};
	};
};
class civ_vehicle 			{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_civ_text;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0; nul = createDialog ""vehicle_option"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = 104;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_civ_offroad_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [civCar] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = 105;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_civ_truck_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [civTruck] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_Gremove: RscButton
		{
			idc = 106;
			text = $STR_antistasi_dialogs_dialog_vehicle_purchase_civ_heli_text;
			//x = 0.37749 * safezoneW + safezoneX;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [civHeli] spawn A3A_fnc_addFIAveh;";
		};
		class HQ_button_offroad: RscButton
		{
			idc = 107;
		 	text = $STR_antistasi_dialogs_dialog_vehicle_purchase_civ_boat_text;
			x = 0.272481 * safezoneW + safezoneX;
		 	y = 0.415981 * safezoneH + safezoneY;
		 	w = 0.175015 * safezoneW;
		 	h = 0.0560125 * safezoneH;
		 	action = "closeDialog 0;[civBoat] spawn A3A_fnc_addFIAveh;";
		 };
	};
};

//Map
class game_options 		{
		idd=-1;
	movingenable=false;
	class controls {
		//Menu Structure
		class 8slots_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class 8slots_frame: RscFrame
		{
			idc = -1;
			text = "Game Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class 8slots_Back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		//Action Buttons
		class 8slots_L1: RscButton
		{
			idc = -1;
			text = "Civ Limit"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Set the max number of spawned civilians. Affects game performance";
			action = "if (player == theBoss) then {closeDialog 0; nul = createDialog ""civ_config""} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_R1: RscButton
		{
			idc = -1;
			text = "Spawn Distance"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Affects performance. Please use this with caution. Set it to lower distances if you feel Antistasi is running bad";
			action = "if (player == theBoss) then {closeDialog 0; nul = createDialog ""spawn_config""} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_L2: RscButton
		{
			idc = -1;
			text = "AI Limiter"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Sets how much local and simulated AI can spawn in the map. Affects performance and AI ""intelligence"". Use with caution. This is not an exact number as vehicles and squad leaders will allways spawn";
			action = "if (player == theBoss) then {closeDialog 0; nul = createDialog ""fps_limiter""} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_R2: RscButton
		{
			idc = -1;
			text = "Music ON/OFF"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Disables/Enable situational music";
			action = "closedialog 0; if (musicON) then {musicON = false; hint ""Music turned OFF""} else {musicON = true; hint ""Music turned ON""}; nul = execVM ""musica.sqf"";";
		};
		/*
		class 8slots_L3: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "";
			action = "";
		};
		class 8slots_R3: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "";
			action = "";
		};

		class 8slots_L4: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "";
			action = "";
		};
		class 8slots_R4: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "";
			action = "";
		};
		*/
		class 8slots_M4: RscButton
		{
			idc = -1;
			text = "Persistent Save"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Use this option to save your current game. It does save the most important data in a ""Grand Theft Auto"" way. This opnion allows good MP save and independent saves of any version update. Vanilla saves are disabled because of lack of several features";
			action = "closeDialog 0;if (player == theBoss) then {[""statSave\saveLoop.sqf"",""BIS_fnc_execVM""] call BIS_fnc_MP} else {_nul = [] execVM ""statSave\saveLoop.sqf""; hintC ""Personal Stats Saved""};";
		};
	};
};										//slots 6+1
class fps_limiter 			{
	idd=-1;
	movingenable=false;

	class controls {

		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "AI Limiter"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""game_options"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "+10 AI Limit"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (maxUnits < 200) then {maxUnits = maxUnits + 10; publicVariable ""maxUnits""; hint format [""AI Limit has been set at %1"",maxUnits]} else {hint ""AI Limit cannot be raised from 200""}} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "-10 AI Limit"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (maxUnits > 80) then {maxUnits = maxUnits - 10; publicVariable ""maxUnits""; hint format [""AI Limit has been set at %1"",maxUnits]} else {hint ""AI Limit cannot be less than 80""}} else {hint ""Only Player Commander has access to this function""};";
		};
	};
};
class spawn_config 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Spawn Distance Config"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""game_options"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "+100 Spawn Dist."; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (distanceSPWN < 2000) then {distanceSPWN = distanceSPWN + 100; distanceSPWN1 = distanceSPWN * 1.3; distanceSPWN2 = distanceSPWN /2; publicVariable ""distanceSPWN"";publicVariable ""distanceSPWN1"";publicVariable ""distanceSPWN2""}; hint format [""Spawn Distance Set to %1 meters. Be careful, this may affect game performance"",distanceSPWN]} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "-100 Spawn Dist."; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (distanceSPWN > 600) then {distanceSPWN = distanceSPWN - 100; if (distanceSPWN < 600) then {distanceSPWN = 600}; distanceSPWN1 = distanceSPWN * 1.3; distanceSPWN2 = distanceSPWN /2; if (distanceSPWN < 600) then {distanceSPWN = 600};publicVariable ""distanceSPWN"";publicVariable ""distanceSPWN1"";publicVariable ""distanceSPWN2"";}; hint format [""Spawn Distance Set to %1 meters"",distanceSPWN]} else {hint ""Only Player Commander has access to this function""};";
		};
	};
};
class civ_config 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Civ Presence Config"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""game_options"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "+1 Max Civs"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (civPerc < 150) then {civPerc = civPerc + 1; if (civPerc > 150) then {civPerc = 150}; publicVariable ""civPerc"";}; hint format [""Maximum Number of Civilians Set to %1"",civPerc]} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "-1 Max Civs"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "if (player == theBoss) then {if (civPerc > 0) then {civPerc = civPerc - 1; if (civPerc < 0) then {civPerc = 0};publicVariable ""civPerc"";}; hint format [""Maximum Number of Civilians Set to %1"",civPerc]} else {hint ""Only Player Commander has access to this function""};";
		};
	};
};

//Solomon Maru
class mission_menu 		{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Available Missions"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_AS: RscButton
		{
			idc = -1;
			text = "Assasination Mission"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""AS""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_CONV: RscButton
		{
			idc = -1;
			text = "Convoy Ambush"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""CONVOY""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_DES: RscButton
		{
			idc = -1;
			text = "Destroy Missions"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""DES""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_LOG: RscButton
		{
			idc = -1;
			text = "Logistics Mission"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""LOG""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_RES: RscButton
		{
			idc = -1;
			text = "Rescue Missions"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""RES""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_vehicle: RscButton
		{
			idc = -1;
			text = "Conquest Missions"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {[[""CON""],""A3A_fnc_missionRequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_exit: RscButton
		{
			idc = -1;
			text = "EXIT"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;";
		};
	};
};


//Y menu
class radio_comm 		{
	idd=-1;
	movingenable=false;
	class controls {
		//Menu Structure
		class 8slots_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class 8slots_frame: RscFrame
		{
			idc = -1;
			text = "Battle Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class 8slots_Back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		//Action Buttons
		class 8slots_L1: RscButton
		{
			idc = -1;
			text = "Fast Travel"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Teleport your squad or a HC selected squad to a friendly zone depending on several factors";
			action = "closeDialog 0;nul = [] execVM ""fastTravelRadio.sqf"";";
		};
		class 8slots_R1: RscButton
		{
			idc = -1;
			text = "Player and Money"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Look at some player and interact with him";
			action = "closeDialog 0;if (isMultiPlayer) then {nul = createDialog ""player_money""} else {hint ""MP Only Menu""};";
		};
		class 8slots_L2: RscButton
		{
			idc = -1;
			text = "Undercover ON"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Become Undercover if you match the requirements. Enemy AI won't attack you until they discover you";
			action = "closeDialog 0;nul = [] spawn A3A_fnc_undercover";
		};
		class 8slots_R2: RscButton
		{
			idc = -1;
			text = "Construct Here"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Construct in the spot where you are a selected building facing this direction";
			action = "closeDialog 0;_nul = createDialog ""construction_menu"";";
		};
		class 8slots_L3: RscButton
		{
			idc = -1;
			text = "Garage Vehicle"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Vehicle or Static gun you're looking at will be garaged, interact with Flag to retrieve";
			action = "closeDialog 0;_nul = createDialog ""garage_check"";";
		};
		class 8slots_R3: RscButton
		{
			idc = -1;
			text = "Unlock Vehicle"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Allow other groups to mount this vehicle";
			action = "closeDialog 0;[] call A3A_fnc_unlockVehicle";
		};
		class 8slots_L4: RscButton
		{
			idc = -1;
			text = "AI Management"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Several AI options";
			action = "if (player == leader group player) then {closeDialog 0;nul = createDialog ""AI_management""} else {hint ""Only group leaders may access to this option""};";
		};
		class 8slots_R4: RscButton
		{
			idc = -1;
			text = "Commander"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Open commander options";
			action = "closeDialog 0; nul = createDialog ""commander_comm"";";
		};
		class 8slots_L5: RscButton
        {
            idc = -1;
            text = "Refresh stats bar"; //--- ToDo: Localize;
            x = 0.272481 * safezoneW + safezoneX;
            y = 0.710047 * safezoneH + safezoneY;
            w = 0.175015 * safezoneW;
            h = 0.0560125 * safezoneH;
            tooltip = "Refresh stats bar";
            action = "closeDialog 0;nul = [] spawn A3A_fnc_statistics;;";
        };
	};
}; 										// slots: 8
class vehicle_manager 		{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Vehicle Manager"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""radio_comm"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Garage\Sell Vehicle"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Add to garage / sell the vehicle you are currently looking at";
			action = "closeDialog 0;nul = createDialog ""garage_sell"";";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Vehicles and Squads"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Options related to vehicle management in HC controlled squads";
			action = "closeDialog 0; if (player == theBoss) then {nul = createDialog ""squad_manager""} else {hint ""Only Player Commander has access to this function""};";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Add to Air Support"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Gain Airstrike points giving this vehicle to the faction Air pool";
			action = "closeDialog 0;nul = [] call A3A_fnc_addBombRun";
		};
		class HQ_button_unlock: RscButton
		{
			idc = -1;
			text = "Unlock Vehicle"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Allow other groups to mount this vehicle";
			action = "closeDialog 0;[] call A3A_fnc_unlockVehicle";
		};
	};
};
class veh_query 				{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = "Add Vehicle to Squad?"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;vehQuery = nil; if (player == theBoss) then {nul= [] execVM ""Dialogs\squad_recruit.sqf""} else {hint ""Only Player Commander has access to this function""};";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = 104;
			text = "YES"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; vehQuery = true";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = 105;
			text = "NO"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; vehQuery = nil";
		};
	};
};
class squad_manager 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "HC Squad Otions"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""radio_comm"";";
		};
		class HQ_button_mortar: RscButton
		{
			idc = -1;
			text = "Squad Add Vehicle"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Look at some vehicle and assign it to the selected squad for it's use";
			action = "closeDialog 0;[] call A3A_fnc_addSquadVeh;";
		};
		class HQ_button_MG: RscButton
		{
			idc = -1;
			text = "Squad SITREP"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "If the selected squad is using some vehicle, know remotely it's status";
			action = "[""stats""] call A3A_fnc_vehStats;";
		};
		class HQ_button_AT: RscButton
		{
			idc = -1;
			text = "Mount / Dismount"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Force squad to mount or dismount their assigned vehicle";
			action = "[""mount""] call A3A_fnc_vehStats";
		};
		class HQ_button_AA: RscButton
		{
			idc = -1;
			text = "Static Autotarget"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Use this option on AT / AA mounted squads. The truck driver will try to point his truck's back to any detected enemy";
			action = "closeDialog 0; [] spawn A3A_fnc_staticAutoT";
		};
	};
};
class AI_management 		{
	idd=-1;
	movingenable=false;
	class controls {
		//Menu Structure
		class 8slots_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class 8slots_frame: RscFrame
		{
			idc = -1;
			text = "Battle Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class 8slots_Back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.05 * safezoneH;
			action = "closeDialog 0;nul = createDialog ""radio_comm"";";
		};
		//Action Buttons
		class 8slots_L1: RscButton
		{
			idc = -1;
			text = "Temp. AI Control"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Take personal control of the selected squad member or HC squad leader and be able to perform any kind of actions for 60 seconds. Control state will be cancelled if the player or the controlled unit receives any kind of damage";
		action = "closeDialog 0; if ((count groupselectedUnits player > 0) and (count hcSelected player > 0)) exitWith {hint ""You must select from HC or Squad Bars, not both""}; if (count groupselectedUnits player == 1) then {nul = [groupselectedUnits player] execVM ""REINF\controlunit.sqf""}; if (count hcSelected player == 1) then {nul = [hcSelected player] execVM ""REINF\controlHCsquad.sqf"";};";
		};
		class 8slots_R1: RscButton
		{
			idc = -1;
			text = "Auto Rearm \ Loot"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "AI will search for better weapons, vests, helmets etc. If they are in a vehicle, they will just store what they scavenge in the vehicle. If not, they will equip them";
			action = "closeDialog 0; if (count groupselectedUnits player == 0) then {nul = (units group player) spawn A3A_fnc_rearmCall} else {nul = (groupselectedUnits player) spawn A3A_fnc_rearmCall};";
		};
		class 8slots_L2: RscButton
		{
			idc = -1;
			text = "Auto Heal"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "AI squad mates will heal proactively each other";
			action = "if (autoHeal) then {autoHeal = false; hint ""Auto Healing disabled"";} else {autoHeal = true; hint ""Auto Heal enabled""; nul = [] spawn A3A_fnc_autoHealFnc}";
		};
		class 8slots_R2: RscButton
		{
			idc = -1;
			text = "Squad SITREP"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Recover info about a HC squad status";
			action = "[""stats""] call A3A_fnc_vehStats;";
		};
		class 8slots_L3: RscButton
		{
			idc = -1;
			text = "Garrison Units / Squads"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Adds selected units or squads to a map selected garrison";
			action = "closeDialog 0;if (count groupselectedUnits player > 0) then {nul = [groupselectedUnits player] execVM ""REINF\addToGarrison.sqf""} else {if (count (hcSelected player) > 0) then {nul = [hcSelected player] execVM ""REINF\addToGarrison.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}";
		};
		class 8slots_R3: RscButton
		{
			idc = -1;
			text = "Squad Add Vehicle"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Look at some vehicle and assign it to the selected squad for it's use";
			action = "closeDialog 0;[] call A3A_fnc_addSquadVeh;";
		};
		class 8slots_L4: RscButton
		{
			idc = -1;
			text = "Dismiss Units / Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Dimiss selected units or squads, recovering it's cost to the proper resource pool";
			action = "closeDialog 0;if (count groupselectedUnits player > 0) then {nul = [groupselectedUnits player] execVM ""REINF\dismissPlayerGroup.sqf""} else {if (count (hcSelected player) > 0) then {nul = [hcSelected player] execVM ""REINF\dismissSquad.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}";
		};
		class 8slots_R4: RscButton
		{
			idc = -1;
			text = "Mount / Dismount"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Force squad to mount or dismount their assigned vehicle";
			action = "[""mount""] call A3A_fnc_vehStats";
		};
	};
};
class commander_comm 		{
	idd=-1;
	movingenable=false;
	class controls {
		//Menu Structure
		class 8slots_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class 8slots_frame: RscFrame
		{
			idc = -1;
			text = "Commander Battle Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class 8slots_Back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.05 * safezoneH;
			action = "closeDialog 0;nul = createDialog ""radio_comm"";";
		};
		//Action Buttons
		class 8slots_L1: RscButton
		{
			idc = -1;
			text = "Recruit Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Recruit new squads and manage them with the HC Module (CTRL + SPACE)";
			action = "closeDialog 0;if (player == theBoss) then {nul= [] execVM ""Dialogs\squad_recruit.sqf""} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_R1: RscButton
		{
			idc = -1;
			text = "Air Support"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Ask for Air Support (uses Airstrike points)";
			action = "closeDialog 0;if (player == theBoss) then {_nul = createDialog ""carpet_bombing""} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_L2: RscButton
		{
			idc = -1;
			text = "O.Post - Roadblock"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Establish a new watchpost or roadblock depending on the type of terrain you select";
			action = "if (player == theBoss) then {closeDialog 0;[""create""] spawn A3A_fnc_outpostDialog} else {hint ""You're not the Commander!""};";
		};
		class 8slots_R2: RscButton
		{
			idc = -1;
			text = "Garbage Clean"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cleans several things in game. Use with caution as it freezes the mission";
			action = "if (player == theBoss) then {closedialog 0;[] remoteExec [""A3A_fnc_garbageCleaner"",2]} else {hint ""Only Player Commander has access to this function""};";
		};
		class 8slots_L3: RscButton
		{
			idc = -1;
			text = "O.Post-Roadblock Delete"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Remove selected observation post or roadblock, money will be refunded";
			action = "if (player == theBoss) then {closeDialog 0; [""delete""] spawn A3A_fnc_outpostDialog} else {hint ""You're not the Commander!""};";
		};
		class 8slots_R3: RscButton
		{
			idc = -1;
			text = "Faction Garage"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Look at a vehicle and garage it into faction garage (shared among commanders)";
			action = "if (player == theBoss) then {closeDialog 0;nul = [true] call A3A_fnc_garageVehicle;} else {hint ""You're not the Commander!""};";
		};
		class 8slots_L4: RscButton
		{
			idc = -1;
			text = "Resign / Eligible"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Step down from commander or toggle eligibility";
			action = "if (isMultiplayer) then {closedialog 0;execVM ""orgPlayers\commResign.sqf""} else {hint ""This feature is MP Only""};";
		};
		class 8slots_R4: RscButton
		{
			idc = -1;
			text = "Sell Vehicle"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Look at a vehicle and sell it for money";
			action = "if (player == theBoss) then {closeDialog 0; nul = [] call A3A_fnc_sellVehicle} else {hint ""Only the Commander can sell vehicles""};";
		};
	};
};
class carpet_bombing 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Carpet Bombing Strike"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0; nul = createDialog ""radio_comm"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "HE Bombs"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 1 point";
			action = "closeDialog 0;[""HE""] spawn A3A_fnc_NATObomb;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Carpet Bombing"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 1 point";
			action = "closeDialog 0;[""CARPET""] spawn A3A_fnc_NATObomb;";
		};
		class 4slots_L2: RscButton
		{
			idc = -1;
			text = "NAPALM Bomb"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 1 point";
			action = "closeDialog 0;[""NAPALM""] spawn A3A_fnc_NATObomb;";
		};
		class 4slots_R2: RscButton
		{
			idc = -1;
			text = "Add to Air Support"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Gain Airstrike points giving this aircraft to the faction Air pool";
			action = "closeDialog 0;nul = [] call A3A_fnc_addBombRun";
		};
	};
};


class dismiss_menu 				{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Dismiss Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Dismiss Units / Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Dimiss selected units or squads, recovering it's cost to the proper resource pool";
			action = "closeDialog 0;if (count groupselectedUnits player > 0) then {nul = [groupselectedUnits player] execVM ""REINF\dismissPlayerGroup.sqf""} else {if (count (hcSelected player) > 0) then {nul = [hcSelected player] execVM ""REINF\dismissSquad.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Garrison Units / Squads"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Adds selected units or squads to a map selected garrison";
			action = "closeDialog 0;if (count groupselectedUnits player > 0) then {nul = [groupselectedUnits player] execVM ""REINF\addToGarrison.sqf""} else {if (count (hcSelected player) > 0) then {nul = [hcSelected player] execVM ""REINF\addToGarrison.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}";
		};
		/*
		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Remove Garrison Squads"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [] call removeGarrison";
		};
		*/
	};
};
class construction_menu 	{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Construction Menu"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""radio_comm"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Small Trench"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Make a quick small trench for one man";
			action = "closeDialog 0;nul = [""Land_SandbagBarricade_01_half_F"",20,0,""OFF_ROAD""] spawn A3A_fnc_build;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Medium Trench"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "A mid sized trench with capabilities for more than one soldier";
			action = "closeDialog 0; nul = [""Land_SandbagBarricade_01_F"",40,0,""OFF_ROAD""] spawn A3A_fnc_build;";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Vehicle obstacles"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Build some obstacles for vehicles";
			action = "closeDialog 0;nul = [""Land_CzechHedgehog_01_F"",60,0,""ON_ROAD""] spawn A3A_fnc_build;";
		};
		class HQ_button_unlock: RscButton
		{
			idc = -1;
			text = "Bunker and sandbags"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Need to be built in garrison controlled zones and cost money";
			action = "closeDialog 0;nul = createDialog ""bunker_menu""";
		};
	};
};
class bunker_menu 				{
	idd=-1;
	movingenable=false;

	class controls {

		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select Bunker Type"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Sandbag Bunker"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Requires to be in a garrisoned zone. It will be permanent";
			action = "closeDialog 0;nul = [""Land_BagBunker_01_small_green_F"",60,100,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Concrete Bunker"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Requires to be in a garrisoned zone. It will be permanent";
			action = "closeDialog 0;nul = [""Land_PillboxBunker_01_big_F"",120,300,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Other buildings"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Large sandbags, garage thing, etc.";
			action = "closeDialog 0;nul = createDialog ""coolshit_menu""";
		};

	};
};

class coolshit_menu 		{
	idd=-1;
	movingenable=false;
	class controls {
		//Menu Structure
		class 8slots_box: BOX
		{
			idc = -1;
			text = "Other buildings";
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class 8slots_frame: RscFrame
		{
			idc = -1;
			text = "Battle Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class 8slots_Back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		//Action Buttons
		class 8slots_L1: RscButton
		{
			idc = -1;
			text = "1 Large sandbag"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "1 large bagged boy. That's it. Just 1.";
			action = "closeDialog 0;nul = [""Land_HBarrier_1_F"",60,75,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
			//[""someAsset"",100,1000] 100 = time, 1000 = cost.
		};
		class 8slots_R1: RscButton
		{
			idc = -1;
			text = "3 Large sandbags"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "A few large bagged boys next to each other. Useful for a wall or something.";
			action = "closeDialog 0;nul = [""Land_HBarrier_3_F"",120,150,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_L2: RscButton
		{
			idc = -1;
			text = "Double stacked sandbags"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "This huge boy is big, like real big. I mean huge. Good enough for base walls.";
			action = "closeDialog 0;nul = [""Land_HBarrierWall4_F"",160,500,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_R2: RscButton
		{
			idc = -1;
			text = "Double stacked corner"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "This huge boy is not only really big, but he can also make a corner. Makes him very valuable in bases.";
			action = "closeDialog 0;nul = [""Land_HBarrierWall_corner_F"",160,500,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_L3: RscButton
		{
			idc = -1;
			text = "Extra large sandbags"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "BIG Large huge SANDY boy, capable of large.";
			action = "closeDialog 0;nul = [""Land_HBarrier_Big_F"",200,750,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_R3: RscButton
		{
			idc = -1;
			text = "Roof"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "This huge thing will prevent water from the sky from hitting you, wonderful invention really.";
			action = "closeDialog 0;nul = [""Land_Shed_Big_F"",200,750,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_L4: RscButton
		{
			idc = -1;
			text = "Concrete wall"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "This badass here will get hit by a feather of a passing bird and fall to the ground. Very useful and at the same time, very useless.";
			action = "closeDialog 0;nul = [""Land_CncWall4_F"",90,250,""OFF_ROAD_FRIENDLY""] spawn A3A_fnc_build;";
		};
		class 8slots_R4: RscButton
		{
			idc = -1;
			text = "Null"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Null";
			action = "closeDialog 0";
		};
		/*
		class 8slots_L5: RscButton
        {
            idc = -1;
            text = "Refresh stats bar"; //--- ToDo: Localize;
            x = 0.272481 * safezoneW + safezoneX;
            y = 0.710047 * safezoneH + safezoneY;
            w = 0.175015 * safezoneW;
            h = 0.0560125 * safezoneH;
            tooltip = "Refresh stats bar";
            action = "closeDialog 0;nul = [] spawn A3A_fnc_statistics;;";
        };
        */
	};
};
class squad_recruit 			{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = 101;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = 102;
			text = "Squad Recruitment Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0; _nul = createDialog ""radio_comm"";";
		};
		class HQ_button_infsquad: RscButton
		{
			idc = 104;
			text = "Recruit Inf. Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;[] execVM ""Dialogs\squadOptions.sqf"";";
		};
		class HQ_button_infteam: RscButton
		{
			idc = 105;
			text = "Recruit Inf. Team"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [groupsSDKmid] spawn A3A_fnc_addFIAsquadHC";
		};
		class HQ_button_ATteam: RscButton
		{
			idc = 106;
			text = "Recruit AT Team"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [groupsSDKAT] spawn A3A_fnc_addFIAsquadHC";
		};
		class HQ_button_sniperTeam: RscButton
		{
			idc = 107;
			text = "Recruit Sniper Team"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [groupsSDKSniper] spawn A3A_fnc_addFIAsquadHC";
		};
		class HQ_button_infsquadM: RscButton
		{
			idc = 108;
			text = "Recruit MG Team"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [SDKMGStatic] spawn A3A_fnc_addFIAsquadHC";
		};
		class HQ_button_infteamM: RscButton
		{
			idc = 109;
			text = "Recruit AT Car"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [vehSDKAT] spawn A3A_fnc_addFIAsquadHC";
		};
		class HQ_button_ATteamM: RscButton
		{
			idc = 110;
			text = "Recruit AA Truck"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [staticAAteamPlayer] spawn A3A_fnc_addFIAsquadHC";
		};

		class HQ_button_mortar: RscButton
		{
			idc = 111;
			text = "Recruit Mortar Team"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [SDKMortar] spawn A3A_fnc_addFIAsquadHC";
		};
	};
};
class player_money 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Player and Money Interaction"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""radio_comm"";";
		};
		class HQ_button_mortar: RscButton
		{
			idc = -1;
			text = "Add Server Member"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Use this option to add the player which you are currently looking to the member's list";
			action = "if (isMultiplayer) then {closeDialog 0;nul = [""add""] call A3A_fnc_memberAdd;} else {hint ""This function is MP only""};";
		};
		class HQ_button_MG: RscButton
		{
			idc = -1;
			text = "Remove Server Member"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Use this option to remove the player which you are currently looking to the member's list";
			action = "if (isMultiplayer) then {closeDialog 0;nul = [""remove""] call A3A_fnc_memberAdd;} else {hint ""This function is MP only""};";
		};
		class HQ_button_AT: RscButton
		{
			idc = -1;
			text = "Donate 100 € to player"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[true] call A3A_fnc_donateMoney;";
		};
		class HQ_button_AA: RscButton
		{
			idc = -1;
			text = "Donate 100 € to Faction"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "It will increase your prestige among your faction";
			action = "[] call A3A_fnc_donateMoney;";
		};
	};
};
class garage_sell 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Sell or Garage Vehicle"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""vehicle_manager"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Garage Vehicle"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;if (player != theBoss) then {nul = [false] call A3A_fnc_garageVehicle} else {if (isMultiplayer) then {_nul = createDialog ""garage_check""} else {nul = [true] call A3A_fnc_garageVehicle}};";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Sell Vehicle"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; if (player == theBoss) then {nul = [] call A3A_fnc_sellVehicle} else {hint ""Only the Commander can sell vehicles""};";
		};
		/*
		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Remove Garrison Squads"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [] call removeGarrison";
		};
		*/
	};
};
class garage_check 				{
	idd=-1;
	movingenable=false;

	class controls {

		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Personal or Faction Garage?"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""garage_sell"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Personal Garage"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [false] call A3A_fnc_garageVehicle;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Faction Garage"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; nul = [true] call A3A_fnc_garageVehicle;";
		};
		/*
		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Remove Garrison Squads"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [] call removeGarrison";
		};
		*/
	};
};
class tu_madre 				{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Carpet Bombing Strike"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;//28
		};
		class HQ_button_back: RscListBox
		{
			idc = -1;
			//text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 35) * 1.2)";
			colorText[] = {1,1,1,1}; // Text and frame color
			colorDisabled[] = {1,1,1,0.5}; // Disabled text color
			colorSelect[] = {1,1,1,1}; // Text selection color
			colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
			colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)
			pictureColor[] = {1,1,1,1}; // Picture color
			pictureColorSelect[] = {1,1,1,1}; // Selected picture color
			pictureColorDisabled[] = {0,1,0,1}; // Disabled picture color


			//action = "closeDialog 0; nul = createDialog ""NATO_Options"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "HE Bombs"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 10 points";
			action = "closeDialog 0;[""HE""] spawn A3A_fnc_NATObomb;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Carpet Bombing"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 10 points";
			action = "closeDialog 0;[""CARPET""] spawn A3A_fnc_NATObomb;";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "NAPALM Bomb"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			tooltip = "Cost: 10 points";
			action = "closeDialog 0;[""NAPALM""] spawn A3A_fnc_NATObomb;";
		};
	};
};



//Mortar shift+Y
class mortar_type {
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select Mortar Ammo"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "HE"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeAmmunition = SDKMortarHEMag;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Smoke"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeAmmunition = SDKMortarSmokeMag;";
		};
		/*
		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Remove Garrison Squads"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [] call removeGarrison";
		};
		*/
	};
};
class rounds_number {
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.492103 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select No. Rounds to be fired"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_AS: RscButton
		{
			idc = -1;
			text = "1"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 1;";
		};
		class HQ_button_CONV: RscButton
		{
			idc = -1;
			text = "2"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 2";
		};
		class HQ_button_DES: RscButton
		{
			idc = -1;
			text = "3"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; roundsX = 3";
		};
		class HQ_button_LOG: RscButton
		{
			idc = -1;
			text = "5"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 5";
		};
		class HQ_button_RES: RscButton
		{
			idc = -1;
			text = "7"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 7";
		};
		class HQ_button_vehicle: RscButton
		{
			idc = -1;
			text = "6"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 6";
		};
		class HQ_button_fpsplus: RscButton
		{
			idc = -1;
			text = "4"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; roundsX = 4";
		};

		class HQ_button_AA: RscButton
		{
			idc = -1;
			text = "8"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;roundsX = 8";
		};
	};
};
class strike_type {
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select type of strike"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Single Point Strike"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;typeArty = ""NORMAL"";";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Barrage Strike"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeArty = ""BARRAGE"";";
		};
		/*
		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Remove Garrison Squads"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "nul = [] call removeGarrison";
		};
		*/
	};
};

//NATO
class NATO_player {
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "SpecOp Menu"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "Quadbike"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;[] call A3A_fnc_NATOQuadbike";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Fast Travel"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;[] spawn A3A_fnc_NATOFT";
		};
	};
};


//Undefined
class mbt_type {
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.20 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select type ammo for the strike"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.18 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = -1;
			text = "HE"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeAmmunition = ""32Rnd_155mm_Mo_shells"";";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = -1;
			text = "Laser Guided"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeAmmunition = ""2Rnd_155mm_Mo_LG"";";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = -1;
			text = "Smoke"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; typeAmmunition = ""6Rnd_155mm_Mo_smoke"";";
		};
	};
};
class squad_options 	{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;//30
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Squad Options"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;//28
		};
		class HQ_button_back: RscButton
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_button_back_text;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0;_nul = createDialog ""squad_recruit"";";
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = 104;
			text = "Normal Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			//tooltip = "";
			action = "closeDialog 0;nul = [groupsSDKSquad] spawn A3A_fnc_addFIAsquadHC;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = 105;
			text = "Engineer Squad"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; nul = [groupsSDKSquadEng] spawn A3A_fnc_addFIAsquadHC;";
		};

		class HQ_button_Gremove: RscButton
		{
			idc = 106;
			text = "MG Squad"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [groupsSDKSquadSupp,""MG""] spawn A3A_fnc_addFIAsquadHC;";
		};
		class HQ_button_unlock: RscButton
		{
			idc = 107;
			text = "Mortar Squad"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;nul = [groupsSDKSquadSupp,""Mortar""] spawn A3A_fnc_addFIAsquadHC;";
		};
	};
};
class diff_menu 			{
	idd=-1;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Choose difficulty"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_mortar: RscButton
		{
			idc = -1;
			text = "Easy"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;skillMult = 0.5";
		};
		class HQ_button_MG: RscButton
		{
			idc = -1;
			text = "Normal"; //--- ToDo: Localize;
			x = 0.37749 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;";
		};
		class HQ_button_AT: RscButton
		{
			idc = -1;
			text = "Hard"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0; skillMult = 2";
		};
	};
};

class gameMode_menu 			{
	idd=100;
	movingenable=false;

	class controls {
		class HQ_box: BOX
		{
			idc = -1;
			text = $STR_antistasi_dialogs_generic_box_text;
			x = 0.244979 * safezoneW + safezoneX;
			y = 0.223941 * safezoneH + safezoneY;
			w = 0.445038 * safezoneW;
			h = 0.30 * safezoneH;
		};
		class HQ_frame: RscFrame
		{
			idc = -1;
			text = "Select your Game Mode"; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.28 * safezoneH;
		};
		class HQ_button_Gsquad: RscButton
		{
			idc = 104;
			text = "Reb vs Gov vs Inv"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;gameMode = 1;";
		};
		class HQ_button_Gstatic: RscButton
		{
			idc = 105;
			text = "Rev vs Gov & Inv"; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;gameMode = 2;";
		};
		class HQ_button_Gremove: RscButton
		{
			idc = 106;
			text = "Reb vs Gov"; //--- ToDo: Localize;
			//x = 0.37749 * safezoneW + safezoneX;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "closeDialog 0;gameMode = 3;";
		};
		class HQ_button_offroad: RscButton
		{
			idc = 107;
		 	text = "Reb vs Inv"; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
		 	y = 0.415981 * safezoneH + safezoneY;
		 	w = 0.175015 * safezoneW;
		 	h = 0.0560125 * safezoneH;
		 	action = "closeDialog 0;gameMode = 4";
		 };
	};
};

class RscTitles {
	class Default {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
    };
    class H8erHUD {
        idd = 745;
        movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  10e10;
        fadein       =  0;
        fadeout      =  0;
        name = "H8erHUD";
		onLoad = "with uiNameSpace do { H8erHUD = _this select 0 }";
		class controls {
		    class structuredText {
                access = 0;
                type = 13;
                idc = 1001;
                style = 0x00;
                lineSpacing = 1;
				x = 0.103165 * safezoneW + safezoneX;
				y = 0.007996 * safezoneH + safezoneY;//0.757996
				w = 0.778208 * safezoneW;
				h = 0.0660106 * safezoneH;
                size = 0.055;//0.020
                colorBackground[] = {0,0,0,0};
                colorText[] = {0.34,0.33,0.33,0};//{1,1,1,1}
                text = "";
                font = "PuristaSemiBold";
				class Attributes {
					font = "PuristaSemiBold";
					color = "#C1C0BB";//"#FFFFFF";
					align = "CENTER";
					valign = "top";
					shadow = true;
					shadowColor = "#000000";
					underline = false;
					size = "4";//4
				};
            };
		};
	};
};
