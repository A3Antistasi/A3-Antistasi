if (!isMultiplayer) exitWith {};
if (!(isNil "serverInitDone")) exitWith {};
diag_log "Antistasi MP Server init";

_serverHasID = profileNameSpace getVariable ["ss_ServerID",nil];
if(isNil "_serverHasID") then
    {
    _serverID = str(round((random(100000)) + random 10000));
    profileNameSpace setVariable ["SS_ServerID",_serverID];
    };
serverID = profileNameSpace getVariable "ss_ServerID";
publicVariable "serverID";

waitUntil {!isNil "serverID"};

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

hcArray = [];
{
private _index = _x call jn_fnc_arsenal_itemType;
[_index,_x,-1] call jn_fnc_arsenal_addItem;
}foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);
//["buttonInvToJNA"] call jn_fnc_arsenal;



loadLastSave = if (paramsArray select 0 == 1) then {true} else {false};
autoSave = if (paramsArray select 1 == 1) then {true} else {false};
membershipEnabled = if (paramsArray select 2 == 1) then {true} else {false};
switchCom = if (paramsArray select 3 == 1) then {true} else {false};
tkPunish = if (paramsArray select 4 == 1) then {true} else {false};
distanciaMiss = paramsArray select 5;
skillMult = paramsArray select 8;
minWeaps = paramsArray select 9;
civTraffic = paramsArray select 10;

if (loadLastSave) then
    {
    ["firstLoad"] call fn_LoadStat;
    if (isNil "firstLoad") then {loadLastSave = false; publicVariable "loadLastSave"};
    };
if (loadLastSave) then
    {
    _nul = [] execVM "statSave\loadAccount.sqf";
    waitUntil {!isNil"statsLoaded"};
    {
    if (([_x] call isMember) and (side _x == buenos)) exitWith
        {
        stavros = _x;
        _x setRank "CORPORAL";
        [_x,"CORPORAL"] remoteExec ["ranksMP"];
        publicVariable "stavros";
        //_x setVariable ["score", 25,true];
        };
    } forEach playableUnits;
    }
else
    {
     if (serverName in servidoresOficiales) then
        {
        ["miembros"] call fn_LoadStat;
        _nul = [] execVM "orgPlayers\mList.sqf";
        };
    stavros = objNull;

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
        if (membershipEnabled) then {miembros = [getPlayerUID _x]} else {miembros = []};
        publicVariable "miembros"};
        //_x setVariable ["score", 25,true];
        };
    } forEach (playableUnits select {side _x == buenos});
diag_log "Antistasi MP Server. Players are in";

{
private _index = _x call jn_fnc_arsenal_itemType;
[_index,_x,-1] call jn_fnc_arsenal_addItem;
}foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);


diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint","Server Init Completed"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{[_this select 0] call onPlayerDisconnect;false}];

serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";

_nul = [caja] call cajaAAF;
waitUntil {sleep 1;!(isNil "placementDone")};
distancias = [] spawn distancias4;
resourcecheck = [] execVM "resourcecheck.sqf";
[] execVM "Scripts\fn_advancedTowingInit.sqf";


//if (serverName in chungos) then {["asshole",false,true] remoteExec ["BIS_fnc_endMission"]};