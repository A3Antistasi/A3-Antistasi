
class HQ_menu
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = 102;
	text = "SDK HQ Options - Commander Only"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = 103;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0";
};
class HQ_button_load: RscButton
{
	idc = 104;
	text = "Grab 100 € from Pool"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (isMultiPlayer) then {if (player == Stavros) then {nul=call stavrosSteal} else {hint ""Only Player Commander has access to this function""}} else {hint ""This function is MP only""};";
};
class HQ_button_savegame: RscButton
{
	idc = 105;
	text = "Manage Garrisons"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {nul=CreateDialog ""garrison_menu""} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_moveHQ: RscButton
{
	idc = 106;
	text = "Move HQ to another Zone"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {nul = [] spawn moveHQ;} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_recruitUnit: RscButton
{
	idc = 107;
	text = "Ingame Member's List"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {if (isMultiplayer) then {nul = [] call membersList} else {hint ""This function is MP only""}} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_recruitSquad: RscButton
{
	idc = 108;
	text = "Rebuild Assets"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	tooltip = "Cost: 5.000 €";
	action = "closeDialog 0;if (player == Stavros) then {nul=[] spawn rebuildAssets} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_vehicle: RscButton
{
	idc = 109;
	text = "Train SDK - Skill Upgrade"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	tooltip = "";
	action = "closeDialog 0;if (player == Stavros) then {nul = [] call FIAskillAdd} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_skill: RscButton
{
	idc = 110;
	text = "Garage Access"; //--- ToDo: Localize;
	x = 0.37749 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	tooltip = "";
	action = "closeDialog 0;nul = [false] spawn garage";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class unit_recruit
{
	idd= 100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = 102;
	text = "Recruitment Options"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = 103;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0";
};
class HQ_button_rifleman: RscButton
{
	idc = 104;
	text = "Recruit Militiaman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMil] spawn reinfPlayer";
};
class HQ_button_autorifleman: RscButton
{
	idc = 105;
	text = "Recruit Autorifleman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMG] spawn reinfPlayer";
};
class HQ_button_medic: RscButton
{
	idc = 126;
	text = "Recruit Medic"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMedic] spawn reinfPlayer";
};
class HQ_button_engineer: RscButton
{
	idc = 107;
	text = "Recruit Engineer"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKEng] spawn reinfPlayer";
};
class HQ_button_explosive: RscButton
{
	idc = 108;
	text = "Recruit Bomb Specialist"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKExp] spawn reinfPlayer";
};
class HQ_button_grenadier: RscButton
{
	idc = 109;
	text = "Recruit Grenadier"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKGL] spawn reinfPlayer";
};
class HQ_button_marksman: RscButton
{
	idc = 110;
	text = "Recruit Marksman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKSniper] spawn reinfPlayer";
};

class HQ_button_AT: RscButton
{
	idc = 111;
	text = "Recruit AT"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKATman] spawn reinfPlayer";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class squad_recruit
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;nul = [gruposSDKSquad] spawn addFIAsquadHC";
};
class HQ_button_infteam: RscButton
{
	idc = 105;
	text = "Recruit Inf. Team"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [gruposSDKmid] spawn addFIAsquadHC";
};
class HQ_button_ATteam: RscButton
{
	idc = 106;
	text = "Recruit AT Team"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [gruposSDKAT] spawn addFIAsquadHC";
};
class HQ_button_sniperTeam: RscButton
{
	idc = 107;
	text = "Recruit Sniper Team"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [gruposSDKSniper] spawn addFIAsquadHC";
};
class HQ_button_infsquadM: RscButton
{
	idc = 108;
	text = "Recruit Sentry"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [gruposSDKSentry] spawn addFIAsquadHC";
};
class HQ_button_infteamM: RscButton
{
	idc = 109;
	text = "Recruit AT Truck"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [staticATBuenos] spawn addFIAsquadHC";
};
class HQ_button_ATteamM: RscButton
{
	idc = 110;
	text = "Recruit AA Truck"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [staticAABuenos] spawn addFIAsquadHC";
};

class HQ_button_mortar: RscButton
{
	idc = 111;
	text = "Recruit Mortar Team"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [SDKMortar] spawn addFIAsquadHC";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class buy_vehicle
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = 102;
	text = "Purchase Military Vehicle"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = 103;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0; nul = createDialog ""vehicle_option"";";
};
class HQ_button_quad: RscButton
{
	idc = 104;
	text = "Buy Quadbike"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closedialog 0; nul = [vehSDKBike] call addFIAveh";
};
class HQ_button_offroad: RscButton
{
	idc = 105;
	text = "Buy Offroad"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [vehSDKLightUnarmed] call addFIAveh;";
};
class HQ_button_truck: RscButton
{
	idc = 106;
	text = "Buy Truck"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [vehSDKTruck] call addFIAveh;";
};
class HQ_button_Aoffroad: RscButton
{
	idc = 107;
	text = "Buy Armed Offroad"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [vehSDKLightArmed] call addFIAveh;";
};
class HQ_button_MG: RscButton
{
	idc = 108;
	text = "Buy MG"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [SDKMGStatic] call addFIAveh;";
};
class HQ_button_mortar: RscButton
{
	idc = 109;
	text = "Buy Mortar"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [SDKMortar] call addFIAveh;";
};
class HQ_button_AT: RscButton
{
	idc = 110;
	text = "Buy Static AT"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [staticATBuenos] call addFIAveh;";
};

class HQ_button_AA: RscButton
{
	idc = 111;
	text = "Buy Static AA"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [staticAABuenos] call addFIAveh;";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class game_options
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Game Options"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0";
};
class HQ_button_civplus: RscButton
{
	idc = -1;
	text = "Civ Config"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {closeDialog 0; nul = createDialog ""civ_config""} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_civless: RscButton
{
	idc = -1;
	text = "Resign Comm.Career"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closedialog 0; if (isMultiplayer) then {execVM ""orgPlayers\commResign.sqf""} else {hint ""This feature is MP Only""};";
};
class HQ_button_music: RscButton
{
	idc = -1;
	text = "Music ON/OFF"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closedialog 0; if (musicON) then {musicON = false; hint ""Music turned OFF"";} else {musicON = true; nul = execVM ""musica.sqf""; hint ""Music turned ON""};";
};
class HQ_button_garbageclean: RscButton
{
	idc = -1;
	text = "Garbage Clean"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closedialog 0;if (player == Stavros) then {[] remoteExec [""garbageCleaner"",2]} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_loadgame: RscButton
{
	idc = -1;
	text = "Reinit UI \ Radio"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[] execVM ""reinitY.sqf"";statistics= [] execVM ""statistics.sqf"";";
};
class HQ_button_savegame: RscButton
{
	idc = -1;
	text = "Persistent Save"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {[""statSave\saveLoop.sqf"",""BIS_fnc_execVM""] call BIS_fnc_MP} else {_nul = [] execVM ""statSave\saveLoop.sqf""; hintC ""Personal Stats Saved""};";
};
class HQ_button_fpsplus: RscButton
{
	idc = -1;
	text = "AI Limiter"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {closeDialog 0; nul = createDialog ""fps_limiter""} else {hint ""Only Player Commander has access to this function""};";
};

class HQ_button_AA: RscButton
{
	idc = -1;
	text = "Spawn Dist. Config"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {closeDialog 0; nul = createDialog ""spawn_config""} else {hint ""Only Player Commander has access to this function""};";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};


class first_load
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.20 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Load previous session?"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.18 * safezoneH;//28
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "YES"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) and (isNil ""placementDone"")) then {[""statSave\loadAccount.sqf"",""BIS_fnc_execVM""] call BIS_fnc_MP; placementDone = true; publicVariable ""placementDone""} else {nul = [] execVM ""statSave\loadAccount.sqf"";};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "NO"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == stavros) and (isNil ""placementDone"")) then {_nul = [] spawn placementselection};";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class init_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.30 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Enable Switch Commander?"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.28 * safezoneH;//28
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "YES"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "switchCom = true; publicVariable ""switchCom""; hint ""Switch Commander Enabled\n\nGame will auto assign Commander position to the highest ranked player"";";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "NO"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "switchCom = false; publicVariable ""switchCom""; hint ""Switch Commander Disabled\n\nGame will only assign Commander position upon Commander disconnection"";";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "Done"; //--- ToDo: Localize;
	x = 0.37749 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (!isNil ""switchCom"") then {closedialog 0; nul = [] execVM ""Dialogs\membersMenu.sqf"";} else {hint ""Select an option first""};";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class build_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.30 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Building Otions"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.28 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""radio_comm"";";
};
class HQ_button_mortar: RscButton
{
	idc = -1;
	text = "Build Minefield"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""minebuild_menu"";";
};
class HQ_button_MG: RscButton
{
	idc = -1;
	text = "Remove Minefield"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; [""delete""] spawn mineDialog;";
};
class HQ_button_AT: RscButton
{
	idc = -1;
	text = "O.Post - Roadblock"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; [""create""] spawn puestoDialog";
};
class HQ_button_AA: RscButton
{
	idc = -1;
	text = "O.Post-Roadblock Delete"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; [""delete""] spawn puestoDialog";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class mission_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""AS""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_CONV: RscButton
{
	idc = -1;
	text = "Convoy Ambush"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""CONVOY""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_DES: RscButton
{
	idc = -1;
	text = "Destroy Missions"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""DES""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_LOG: RscButton
{
	idc = -1;
	text = "Logistics Mission"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""LOG""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_RES: RscButton
{
	idc = -1;
	text = "Rescue Missions"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""RES""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_vehicle: RscButton
{
	idc = -1;
	text = "Conquest Missions"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if ((player == Stavros) or (not(isPlayer Stavros))) then {[[""CON""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class radio_comm
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Battle Options"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0";
};
class HQ_button_AS: RscButton
{
	idc = -1;
	text = "Fast Travel"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [] execVM ""fastTravelRadio.sqf"";";
};
class HQ_button_CONV: RscButton
{
	idc = -1;
	text = "Undercover ON"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [] spawn undercover";
};
class HQ_button_DES: RscButton
{
	idc = -1;
	text = "Vehicle Manager"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; nul = createDialog ""vehicle_manager"";";
};
class HQ_button_LOG: RscButton
{
	idc = -1;
	text = "Air Support"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {_nul = createDialog ""carpet_bombing""} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_RES: RscButton
{
	idc = -1;
	text = "Building Options"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {nul=CreateDialog ""build_menu""} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_vehicle: RscButton
{
	idc = -1;
	text = "Recruit Squad"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (player == Stavros) then {nul= [] execVM ""Dialogs\squad_recruit.sqf""} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_fpsplus: RscButton
{
	idc = -1;
	text = "AI Management"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == leader group player) then {closeDialog 0;nul = createDialog ""AI_management""} else {hint ""Only group leaders may access to this option""};";
};

class HQ_button_AA: RscButton
{
	idc = -1;
	text = "Player and Money"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (isMultiPlayer) then {nul = createDialog ""player_money""} else {hint ""MP Only Menu""};";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class garrison_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.20 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Garrison Menu"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.18 * safezoneH;//28
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""HQ_menu"";";
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "Recruit Garrison"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[""add""] spawn garrisonDialog";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Remove Garrison"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[""rem""] spawn garrisonDialog";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class garrison_recruit
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.492103 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = 102;
	text = "Garrison Recruitment Options"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.462103 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = 103;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""garrison_menu"";";
};
class HQ_button_rifleman: RscButton
{
	idc = 104;
	text = "Recruit Militiaman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMil] call garrisonAdd";
};
class HQ_button_autorifleman: RscButton
{
	idc = 105;
	text = "Recruit Autorifleman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMG] call garrisonAdd";
};
class HQ_button_medic: RscButton
{
	idc = 126;
	text = "Recruit Medic"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKMedic] call garrisonAdd";
};
class HQ_button_engineer: RscButton
{
	idc = 107;
	text = "Recruit Squad Leader"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKSL] call garrisonAdd";
};
class HQ_button_explosive: RscButton
{
	idc = 108;
	text = "Recruit Mortar"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [staticCrewBuenos] call garrisonAdd";
};
class HQ_button_grenadier: RscButton
{
	idc = 109;
	text = "Recruit Grenadier"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKGL] call garrisonAdd";
};
class HQ_button_marksman: RscButton
{
	idc = 110;
	text = "Recruit Marksman"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKSniper] call garrisonAdd";
};

class HQ_button_AT: RscButton
{
	idc = 111;
	text = "Recruit AT"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "nul = [SDKATman] call garrisonAdd";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class fps_limiter
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "if (player == Stavros) then {if (maxUnits < 200) then {maxUnits = maxUnits + 10; publicVariable ""maxUnits""; hint format [""AI Limit has been set at %1"",maxUnits]} else {hint ""AI Limit cannot be raised from 200""}} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "-10 AI Limit"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {if (maxUnits > 80) then {maxUnits = maxUnits - 10; publicVariable ""maxUnits""; hint format [""AI Limit has been set at %1"",maxUnits]} else {hint ""AI Limit cannot be less than 80""}} else {hint ""Only Player Commander has access to this function""};";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class spawn_config
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	//action = "if (player == Stavros) then {if (distanciaSPWN < 2000) then {distanciaSPWN = distanciaSPWN + 100; distanciaSPWN1 = distanciaSPwN * 1.3; distanciaSPWN2 = distanciaSPWN /2; if (distanciaSPWN > 2000) then {distanciaSPWN = 2000};publicVariable ""distanciaSPWN"";publicVariable ""distanciaSPWN1"";publicVariable ""distanciaSPWN2"";}; hint format [""Spawn Distance Set to %1 meters. Be careful, this may affect game performance"",distanciaSPWN]} else {hint ""Only Player Commander has access to this function""};";
	action = "if (player == Stavros) then {if (distRef < 2000) then {distRef = distRef + 100; if (distRef > 2000) then {distRef = 2000};publicVariable ""distRef""}; hint format [""Spawn Distance Set to %1 meters. Be careful, this may affect game performance"",distRef]} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "-100 Spawn Dist."; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {if (distRef > 600) then {distRef = distRef - 100; if (distRef < 600) then {distRef = 600}; publicVariable ""distRef""; distanciaSPWN = distRef;  distanciaSPWN1 = distanciaSPwN * 1.3; distanciaSPWN2 = distanciaSPWN /2; if (distanciaSPWN < 600) then {distanciaSPWN = 600};publicVariable ""distanciaSPWN"";publicVariable ""distanciaSPWN1"";publicVariable ""distanciaSPWN2"";}; hint format [""Spawn Distance Set to %1 meters"",distanciaSPWN]} else {hint ""Only Player Commander has access to this function""};";
	//action = "if (player == Stavros) then {if (distRef > 600) then {distRef = distRef - 100; if (distRef < 600) then {distRef = 600};publicVariable ""distRef"";}; hint format [""Spawn Distance Set to %1 meters"",distRef]} else {hint ""Only Player Commander has access to this function""};";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class civ_config
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""game_options"";";
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "+1% Civ Spawn."; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {if (civPerc < 1) then {civPerc = civPerc + 0.01; if (civPerc > 1) then {civPerc = 1}; publicVariable ""civPerc"";}; hint format [""Civilian Percentage Set to %1 percent"",civPerc * 100]} else {hint ""Only Player Commander has access to this function""};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "-1% Civ Spawn."; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (player == Stavros) then {if (civPerc > 0) then {civPerc = civPerc - 0.01; if (civPerc < 0) then {civPerc = 0};publicVariable ""civPerc"";}; hint format [""Civilian Percentage Set to %1 percent"",civPerc * 100]} else {hint ""Only Player Commander has access to this function""};";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class squad_manager
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;[] call addSquadVeh;";
};
class HQ_button_MG: RscButton
{
	idc = -1;
	text = "Squad Vehicle Stats"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "[""stats""] call vehStats;";
};
class HQ_button_AT: RscButton
{
	idc = -1;
	text = "Mount / Dismount"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "[""mount""] call vehStats";
};
class HQ_button_AA: RscButton
{
	idc = -1;
	text = "Static Autotarget"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; [] spawn staticAutoT";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class veh_query
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = 101;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;vehQuery = nil; if (player == Stavros) then {nul= [] execVM ""Dialogs\squad_recruit.sqf""} else {hint ""Only Player Commander has access to this function""};";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class player_money
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "if (isMultiplayer) then {closeDialog 0;nul = [""add""] call memberAdd;} else {hint ""This function is MP only""};";
};
class HQ_button_MG: RscButton
{
	idc = -1;
	text = "Remove Server Member"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (isMultiplayer) then {closeDialog 0;nul = [""remove""] call memberAdd;} else {hint ""This function is MP only""};";
};
class HQ_button_AT: RscButton
{
	idc = -1;
	text = "Donate 100 € to player"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "[true] call donateMoney;";
};
class HQ_button_AA: RscButton
{
	idc = -1;
	text = "Donate 100 € to SDK"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "[] call donateMoney;";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class members_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.30 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Enable Server Membership?"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.28 * safezoneH;//28
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "YES"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "miembros = []; {miembros pushBack (getPlayerUID _x)} forEach playableUnits; publicVariable ""miembros""; hint ""Server Membership Enabled.\n\nAll the present players have been added to the Member's List.\n\nNon-members cannot use the HQ Ammobox and cannot be commanders, even with Switch Commander enabled.\n\nIf you load a session with this feature disabled, it will change to disabled.\n\nUse this option for Open Server Environments"";";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "NO"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "miembros = []; publicVariable ""miembros""; hint ""Server Membership Disabled.\n\nAnyone can use the HQ Ammobox and become Commander (if Switch Commander is enabled).\n\nIf you load a session with this feature enabled, it will become enabled.\n\nUse this option for Private Server environments."";";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "Done"; //--- ToDo: Localize;
	x = 0.37749 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (!isNil ""miembros"") then {closedialog 0; nul = [] execVM ""Dialogs\firstLoad.sqf"";} else {hint ""Select an option first""};";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class vehicle_manager
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0; if (player == Stavros) then {nul = createDialog ""squad_manager""} else {hint ""Only Player Commander has access to this function""};";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "Add to Air Support"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [] call addBombRun";
};
class HQ_button_unlock: RscButton
{
	idc = -1;
	text = "Unlock Vehicle"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[] call unlockVehicle";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class garage_sell
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;if (player != stavros) then {nul = [false] call garageVehicle} else {if (isMultiplayer) then {_nul = createDialog ""garage_check""} else {nul = [true] call garageVehicle}};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Sell Vehicle"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; if (player == stavros) then {nul = [] call sellVehicle} else {hint ""Only the Commander can sell vehicles""};";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class garage_check
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.20 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Personal or SDK Garage?"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.18 * safezoneH;//28
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;nul = [false] call garageVehicle;";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "SDK Garage"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; nul = [true] call garageVehicle;";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class vehicle_option
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0";
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "Civilian Vehicle"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul=[] execVM ""Dialogs\buy_vehicle_civ.sqf"";";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Military Vehicle"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle.sqf"";";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class civ_vehicle
{
	idd=100;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.30 * safezoneH;
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Buy Civilian Vehicle"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.28 * safezoneH;
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0; nul = createDialog ""vehicle_option"";";
};
class HQ_button_Gsquad: RscButton
{
	idc = 104;
	text = "Offroad"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [civCar] call addFIAveh;";
};
class HQ_button_Gstatic: RscButton
{
	idc = 105;
	text = "Truck"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [civTruck] call addFIAveh;";
};
class HQ_button_Gremove: RscButton
{
	idc = 109;
	text = "Helicopter"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = [civHeli] call addFIAveh;";
};
class HQ_button_offroad: RscButton
{
	idc = 105;
	text = "Boat"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;nul = execVM ""\REINF\buyBoat.sqf"";";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class carpet_bombing
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;[""HE""] spawn NATObomb;";
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
	action = "closeDialog 0;[""CARPET""] spawn NATObomb;";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "NAPALM Bomb"; //--- ToDo: Localize;
	x = 0.37749 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	tooltip = "Cost: 1 point";
	action = "closeDialog 0;[""NAPALM""] spawn NATObomb;";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class tu_madre
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	//text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;[""HE""] spawn NATObomb;";
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
	action = "closeDialog 0;[""CARPET""] spawn NATObomb;";
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
	action = "closeDialog 0;[""NAPALM""] spawn NATObomb;";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class AI_management
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.30 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "AI Management"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.28 * safezoneH;//28
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;nul = createDialog ""radio_comm"";";
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "Temp. AI Control"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; if ((count groupselectedUnits player > 0) and (count hcSelected player > 0)) exitWith {hint ""You must select from HC or Squad Bars, not both""}; if (count groupselectedUnits player == 1) then {nul = [groupselectedUnits player] execVM ""REINF\controlunit.sqf""}; if (count hcSelected player == 1) then {nul = [hcSelected player] execVM ""REINF\controlHCsquad.sqf"";};";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Auto Rearm \ Loot"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; if (count groupselectedUnits player == 0) then {nul = (units group player) spawn rearmCall} else {nul = (groupselectedUnits player) spawn rearmCall};";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "Auto Heal"; //--- ToDo: Localize;
	//x = 0.37749 * safezoneW + safezoneX;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "if (autoHeal) then {autoHeal = false; hint ""Auto Healing disabled"";} else {autoHeal = true; hint ""Auto Heal enabled""; nul = [] spawn autoHealFnc}";
};
class dismiss_units: RscButton
{
	idc = -1;
	text = "Dismiss Units/Squads"; //--- ToDo: Localize;
	//x = 0.37749 * safezoneW + safezoneX;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;if (count groupselectedUnits player > 0) then {nul = [groupselectedUnits player] execVM ""REINF\dismissPlayerGroup.sqf""} else {if (count (hcSelected player) > 0) then {nul = [hcSelected player] execVM ""REINF\dismissSquad.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class rounds_number
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;rondas = 1;";
};
class HQ_button_CONV: RscButton
{
	idc = -1;
	text = "2"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;rondas = 2";
};
class HQ_button_DES: RscButton
{
	idc = -1;
	text = "3"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; rondas = 3";
};
class HQ_button_LOG: RscButton
{
	idc = -1;
	text = "5"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;rondas = 5";
};
class HQ_button_RES: RscButton
{
	idc = -1;
	text = "7"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.514003 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;rondas = 7";
};
class HQ_button_vehicle: RscButton
{
	idc = -1;
	text = "6"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;rondas = 6";
};
class HQ_button_fpsplus: RscButton
{
	idc = -1;
	text = "4"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; rondas = 4";
};

class HQ_button_AA: RscButton
{
	idc = -1;
	text = "8"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.612025 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;rondas = 8";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class strike_type
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;tipoArty = ""NORMAL"";";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Barrage Strike"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; tipoArty = ""BARRAGE"";";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class mbt_type
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;tipoMuni = ""32Rnd_155mm_Mo_shells"";";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Laser Guided"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; tipoMuni = ""2Rnd_155mm_Mo_LG"";";
};

class HQ_button_Gremove: RscButton
{
	idc = -1;
	text = "Smoke"; //--- ToDo: Localize;
	x = 0.37749 * safezoneW + safezoneX;
	y = 0.415981 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; tipoMuni = ""6Rnd_155mm_Mo_smoke"";";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};
class mortar_type
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;tipoMuni = SDKMortarHEMag;";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Smoke"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; tipoMuni = SDKMortarSmokeMag;";
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
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class minebuild_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
	x = 0.244979 * safezoneW + safezoneX;
	y = 0.223941 * safezoneH + safezoneY;
	w = 0.445038 * safezoneW;
	h = 0.20 * safezoneH;//30
};
class HQ_frame: RscFrame
{
	idc = -1;
	text = "Build Minefield"; //--- ToDo: Localize;
	x = 0.254979 * safezoneW + safezoneX;
	y = 0.233941 * safezoneH + safezoneY;
	w = 0.425038 * safezoneW;
	h = 0.18 * safezoneH;//28
};
class HQ_button_back: RscButton
{
	idc = -1;
	text = "Back"; //--- ToDo: Localize;
	x = 0.61 * safezoneW + safezoneX;
	y = 0.251941 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;//0.175015
	h = 0.05 * safezoneH;
	action = "closeDialog 0;_nul = createDialog ""build_menu"";";
};
class HQ_button_Gsquad: RscButton
{
	idc = -1;
	text = "APERS Mines"; //--- ToDo: Localize;
	x = 0.272481 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[""APERSMine""] spawn mineDialog";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "AT Mines"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0; [""ATMine""] spawn mineDialog";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class NATO_player
{
	idd=-1;
	movingenable=false;

	class controls
	{
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Alber, v1.063, #Ledyti)
////////////////////////////////////////////////////////
class HQ_box: BOX
{
	idc = -1;
	text = ""; //--- ToDo: Localize;
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
	text = "Back"; //--- ToDo: Localize;
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
	action = "closeDialog 0;[] call NATOQuadbike";
};
class HQ_button_Gstatic: RscButton
{
	idc = -1;
	text = "Fast Travel"; //--- ToDo: Localize;
	x = 0.482498 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.175015 * safezoneW;
	h = 0.0560125 * safezoneH;
	action = "closeDialog 0;[] spawn NATOFT";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
	};
};

class RscTitles
	{
	class Default
       {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
       };
    class H8erHUD
    	{
        idd = 745;
        movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  10e10;
        fadein       =  0;
        fadeout      =  0;
        name = "H8erHUD";
		onLoad = "with uiNameSpace do { H8erHUD = _this select 0 }";
		class controls
        	{
		    class structuredText
            	{
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
					class Attributes
						{
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