if (!isMultiplayer) exitWith {};
if (!(isNil "serverInitDone")) exitWith {};
diag_log "Antistasi MP Server init";
_nul = call compile preprocessFileLineNumbers "initVar.sqf";
initVar = true; publicVariable "initVar";
diag_log format ["Antistasi MP. InitVar done. Version: %1",antistasiVersion];
_nul = call compile preprocessFileLineNumbers "initFuncs.sqf";
diag_log "Antistasi MP Server. Funcs init finished";
_nul = call compile preprocessFileLineNumbers "initZones.sqf";
diag_log "Antistasi MP Server. Zones init finished";

[] execVM "initPetros.sqf";
["Initialize"] call BIS_fnc_dynamicGroups;//Exec on Server
waitUntil {(count playableUnits) > 0};
waitUntil {({(isPlayer _x) and (!isNull _x) and (_x == _x)} count allUnits) == (count playableUnits)};//ya estamos todos
_nul = [] execVM "modBlacklist.sqf";

stavros = objNull;
maxPlayers = playableSlotsNumber buenos;
if (serverName in servidoresOficiales) then
    {
    _nul = [] execVM "serverAutosave.sqf";
    }
else
    {
    if (isNil "comandante") then {comandante = (playableUnits select 0)};
    if (isNull comandante) then {comandante = (playableUnits select 0)};
    {
    if (_x!=comandante) then
        {
        //_x setVariable ["score", 0,true];
        }
    else
        {
        stavros = _x;
        publicVariable "stavros";
        _x setRank "CORPORAL";
        [_x,"CORPORAL"] remoteExec ["ranksMP"];
        //_x setVariable ["score", 25,true];
        };
    } forEach (playableUnits select {side _x == buenos});
    diag_log "Antistasi MP Server. Players are in";
    };
publicVariable "maxPlayers";

hcArray = [];

//{if (owner _x != owner server) then {hcArray pushBack _x}} forEach entities "HeadlessClient_F";

if (!isNil "HC1") then {hcArray pushBack HC1};
if (!isNil "HC2") then {hcArray pushBack HC2};
if (!isNil "HC3") then {hcArray pushBack HC3};

HCciviles = 2;
HCgarrisons = 2;
HCattack = 2;
if (count hcArray > 0) then
    {
    HCciviles = 2;
    HCgarrisons = hcArray select 0;
    HCattack = 2;
    diag_log "Antistasi MP Server. Headless Client 1 detected";
    if (count hcArray > 1) then
        {
        HCciviles = hcArray select 1;
        HCattack = hcArray select 1;
        diag_log "Antistasi MP Server. Headless Client 2 detected";
        if (count hcArray > 2) then
            {
            HCciviles = hcArray select 2;
            diag_log "Antistasi MP Server. Headless Client 3 detected";
            };
        };
    };
//[] remoteExec ["fpsCheck",HCGarrisons];
publicVariable "HCciviles";
publicVariable "HCgarrisons";
publicVariable "HCattack";
publicVariable "hcArray";
//lockedWeapons = lockedWeapons - unlockedWeapons;
caja call jn_fnc_arsenal_init;
{
private _index = _x call jn_fnc_arsenal_itemType;
[_index,_x,-1] call jn_fnc_arsenal_addItem;
}foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);
//["buttonInvToJNA"] call jn_fnc_arsenal;



diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint","Server Init Completed"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{[_this select 0] call onPlayerDisconnect;false}];
/*
caja addEventHandler ["ContainerOpened",
    {
    _jugador = _this select 1;
    if (not([_jugador] call isMember)) then
        {
        _jugador setPos position petros;
        "You are not in the Member's List of this Server.\n\nAsk the Commander in order to be allowed to access the HQ Ammobox.\n\nIn the meantime you may use the other box to store equipment and share it with others." remoteExecCall ["hint", _jugador];
        };
    }
];
*/

serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";
//if (serverName in chungos) then {["asshole",false,true] remoteExec ["BIS_fnc_endMission"]};