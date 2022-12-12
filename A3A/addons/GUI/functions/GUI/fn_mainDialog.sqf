/*
Maintainer: DoomMetal
    Handles the initialization and tab switching on the Main Dialog (aka the Y-Menu).
    This function should only be called from MainDialog onLoad and control activation EHs.

Arguments:
    <STRING> Mode, e.g. "onLoad", "switchTab"
    <ARRAY<ANY>> Array of params for the mode when applicable. Params for specific modes are documented in the modes.

Return Value:
    Nothing

Scope: Clients, Local Arguments, Local Effect
Environment: Scheduled for onLoad mode / Unscheduled for everything else unless specified
Public: No
Dependencies:
    None

Example:
    ["onLoad"] spawn A3A_fnc_mainDialog; // initialization
    ["switchTab", ["player"]] call A3A_fnc_mainDialog; // switching to the player tab
*/

#include "..\..\dialogues\ids.inc"
#include "..\..\dialogues\defines.hpp"
#include "..\..\dialogues\textures.inc"
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params[["_mode","onLoad"], ["_params",[]]];

// Get display
private _display = findDisplay A3A_IDD_MAINDIALOG;

switch (_mode) do
{
    case ("onLoad"):
    {
        Debug("MainDialog onLoad starting...");

        // Disable/hide unavailable tab buttons
        if (player != theBoss) then {
            private _commanderTabButton = _display displayCtrl A3A_IDC_COMMANDERTABBUTTON;
            _commanderTabButton ctrlEnable false;
            _commanderTabButton ctrlSetTooltip localize "STR_antistasi_dialogs_main_commander_tab_disabled_tooltip";
        };

        if !((isServer && hasInterface) || admin owner player > 0) then {
            private _adminTabButton = _display displayCtrl A3A_IDC_ADMINTABBUTTON;
            _adminTabButton ctrlEnable false;
            _adminTabButton ctrlshow false;
        };

        // Hide HC group icons to stop them from interfering with map controls
        _display setVariable ["HCgroupIcons", groupIconsVisible];
        setGroupIconsVisible [false, false];
        setGroupIconsSelectable false;

        // Show player tab content
        ["switchTab", ["player"]] call A3A_fnc_mainDialog;

        // Cache group info in map control
        Debug("Caching group info");

        private _commanderMap = _display displayCtrl A3A_IDC_COMMANDERMAP;
        private _hcGroupData = [];
        if (player == theBoss) then
        {
            {
                private _groupData = [_x] call A3A_fnc_getGroupInfo;
                _hcGroupData pushBack _groupData;
            } forEach hcallGroups player;
        };
        _commanderMap setVariable ["hcGroupData", _hcGroupData];
        Debug_1("%1 Groups cached", count (_commanderMap getVariable "hcGroupData"));

        // Init selected group
        private _selectedGroup = grpNull;
        if (count (hcSelected player) == 1) then
        {
            _selectedGroup = (hcSelected player) # 0;
        };
        _commanderMap setVariable ["selectedGroup", _selectedGroup];


        // Commander map Draw EHs
        // Fire mission markers
        private _fireMissionEH = _commanderMap ctrlAddEventHandler ["Draw","call A3A_fnc_fireMissionEH"];
        Debug_1("Adding Fire Mission Draw EH to commander map: %1", _fireMissionEH);
        // Select marker
        private _commanderHcSelectEH = _commanderMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawSelectEH"];
        Debug_1("Adding HC group selection Draw EH to commander map: %1", _commanderHcSelectEH);
        // High command groups
        private _commanderHcGroupsEH = _commanderMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawHcGroupsEH"];
        Debug_1("Adding HC group marker Draw EH to commander map: %1", _commanderHcGroupsEH);
        // Outposts
        private _commanderOutpostsEH = _commanderMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawOutpostsEH"];
        Debug_1("Adding outposts Draw EH to commander map: %1", _commanderOutpostsEH);
        // User Markers
        private _commanderUserMarkersEH = _commanderMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawUserMarkersEH"];
        Debug_1("Adding user markers Draw EH to commander map: %1", _commanderUserMarkersEH);




        // Fast Travel map Draw EHs
        private _fastTravelMap = _display displayCtrl A3A_IDC_FASTTRAVELMAP;
        // Select marker
        private _fastTravelSelectEH = _fastTravelMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawSelectEH"];
        Debug_1("Adding destination select marker Draw EH to Fast Travel map: %1", _fastTravelSelectEH);
        // Outposts
        private _fastTravelOutpostsEH = _fastTravelMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawOutpostsEH"];
        Debug_1("Adding outposts Draw EH to Fast Travel map: %1", _fastTravelOutpostsEH);


        Debug("MainDialog onLoad complete.");

        // TODO UI-update: temp. map control debug stuff, remove when done
        _nul = [] spawn {
            while {dialog} do {
                _display = findDisplay 7000;
                _commanderMap = _display displayCtrl 7201;
                _mapScale = ctrlMapScale _commanderMap;
                diag_log(format ["MAP SCALE: %1", _mapScale]);
                sleep 1;
            };
        };
    };

    case ("onUnload"):
    {
        Debug("MainDialog onUnload starting...");

        // Remove map drawing EH
        _commanderMap ctrlRemoveAllEventHandlers "Draw";

        // Restore HC group icons state
        private _groupIcons = _display getVariable ["HCgroupIcons", [false,false]];
        setGroupIconsVisible _groupIcons;
        setGroupIconsSelectable true;

        Debug("MainDialog onUnload complete.");
    };

    case ("switchTab"):
    {
        // Takes 1 parameter: <STRING> name of tab

        // Get selected tab
        private _selectedTab = _params select 0;

        Debug_1("MainDialog switching tab to %1.", _selectedTab);

        // Get IDC for selected tab if user has permission to use it
        private _selectedTabIDC = -1;
        switch (_selectedTab) do
        {
            case ("player"):
            {
                // No permission check needed
                _selectedTabIDC = A3A_IDC_PLAYERTAB;
            };

            case ("commander"):
            {
                if (player == theBoss) then {
                    _selectedTabIDC = A3A_IDC_COMMANDERTAB;
                };
            };

            case ("admin"):
            {
                if ((isServer && hasInterface) || admin owner player > 0) then {
                    _selectedTabIDC = A3A_IDC_ADMINTAB;
                };
            };

            case ("fasttravel"):
            {
                _selectedTabIDC = A3A_IDC_FASTTRAVELTAB;
            };

            case ("construct"):
            {
                _selectedTabIDC = A3A_IDC_CONSTRUCTTAB;
            };

            case ("aimanagement"):
            {
                _selectedTabIDC = A3A_IDC_AIMANAGEMENTTAB;
            };

            case ("donate"):
            {
                _selectedTabIDC = A3A_IDC_DONATETAB;
            };

            case ("airsupport"):
            {
                _selectedTabIDC = A3A_IDC_AIRSUPPORTTAB;
            };

            case ("playermanagement"):
            {
                _selectedTabIDC = A3A_IDC_PLAYERMANAGEMENTTAB;
            };
        };

        // Log attempt at accessing tab without permission
        if (_selectedTabIDC == -1) exitWith {
            Error("Attempted to access tab without permission : %1", _selectedTab);
        };

        // Array of IDCs for all the tabs, including subtabs (like AI & player management)
        // Commander and fast travel maps are also hidden here, and shown again in updateCommanderTab
        private _allTabs = [
            A3A_IDC_PLAYERTAB,
            A3A_IDC_COMMANDERTAB,
            A3A_IDC_COMMANDERMAP,
            A3A_IDC_ADMINTAB,
            A3A_IDC_FASTTRAVELTAB,
            A3A_IDC_FASTTRAVELMAP,
            A3A_IDC_CONSTRUCTTAB,
            A3A_IDC_AIMANAGEMENTTAB,
            A3A_IDC_DONATETAB,
            A3A_IDC_AIRSUPPORTTAB,
            A3A_IDC_PLAYERMANAGEMENTTAB
        ];

        // Hide all tabs
        Debug("Hiding all tabs");
        {
            private _ctrl = _display displayCtrl _x;
            _ctrl ctrlShow false;
        } forEach _allTabs;

        // Hide back button, enable in update tab mode when/if needed
        private _backButton = _display displayCtrl A3A_IDC_MAINDIALOGBACKBUTTON;
        _backButton ctrlShow false;

        // Show selected tab
        Debug("Showing selected tab");
        private _selectedTabCtrl = _display displayCtrl _selectedTabIDC;
        _selectedTabCtrl ctrlShow true;

        // Update tab
        Debug("Updating selected tab");
        switch (_selectedTab) do
        {
            case ("player"):
            {
                ["update"] call A3A_fnc_playerTab;
            };

            case ("commander"):
            {
                ["update"] call A3A_fnc_commanderTab;
            };

            case ("admin"):
            {
                ["update"] call A3A_fnc_adminTab;
            };

            case ("fasttravel"):
            {
                ["clearSelectedLocation"] call A3A_fnc_fastTravelTab;
                ["update"] call A3A_fnc_fastTravelTab;
            };

            case ("construct"):
            {
                ["update"] call A3A_fnc_constructTab;
            };

            case ("aimanagement"):
            {
                ["update"] call A3A_fnc_aiManagementTab;
            };

            case ("donate"):
            {
                ["update"] call A3A_fnc_donateTab;
            };

            case ("airsupport"):
            {
                ["update"] call A3A_fnc_airSupportTab;
            };

            case ("playermanagement"):
            {
                ["update"] call A3A_fnc_playerManagementTab;
            };
        };
    };

    default {
    // Log error if attempting to call a mode that doesn't exist
    Error_1("Main Dialog mode does not exist: %1", _mode);
    };
};
