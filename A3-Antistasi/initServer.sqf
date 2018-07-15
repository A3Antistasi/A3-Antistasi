if (!isMultiplayer) exitWith {};
if (!(isNil "serverInitDone")) exitWith {};
diag_log "Antistasi MP Server init";
caja allowDamage false;
bandera allowDamage false;
cajaVeh allowDamage false;
fuego allowDamage false;
mapa allowDamage false;
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
savingServer = true;
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
membershipEnabled = if (paramsArray select 2 == 1) then {true} else {false}; publicVariable "membershipEnabled";
switchCom = if (paramsArray select 3 == 1) then {true} else {false};
tkPunish = if (paramsArray select 4 == 1) then {true} else {false}; publicVariable "tkPunish";
distanciaMiss = paramsArray select 5; publicVariable "distanciaMiss";
skillMult = paramsArray select 8; publicVariable "skillMult";
minWeaps = paramsArray select 9;
civTraffic = paramsArray select 10; publicVariable "civTraffic";
//waitUntil {!isNil "bis_fnc_preload_init"};
//waitUntil {!isNil "BIS_fnc_preload_server"};
if (loadLastSave) then
    {

    diag_log "Antistasi: Persitent Load selected";
    ["miembros"] call fn_LoadStat;
    if (isNil "miembros") then
        {
        loadLastSave = false;
        diag_log "Antistasi: Persitent Load selected but there is no older session";
        };
    };
publicVariable "loadLastSave";
if (loadLastSave) then
    {
    _nul = [] execVM "statSave\loadAccount.sqf";
    waitUntil {!isNil"statsLoaded"};
    if (membershipEnabled and (miembros isEqualTo [])) then
        {
        [petros,"hint","Membership is enabled but members list is empty. Current players will be added to the member list"] remoteExec ["commsMP"];
        diag_log "Antistasi: Persitent Load done but membership enabled with members array empty";
        {
        miembros pushBack (getPlayerUID _x);
        } forEach playableUnits;
        publicVariable "miembros";
        sleep 3;
        };
    theBoss = objNull;
    {
    if (([_x] call isMember) and (side _x == buenos)) exitWith
        {
        theBoss = _x;
        //_x setRank "CORPORAL";
        //[_x,"CORPORAL"] remoteExec ["ranksMP"];
        //_x setVariable ["score", 25,true];
        };
    } forEach playableUnits;
    publicVariable "theBoss";
    }
else
    {
     if (serverName in servidoresOficiales) then
        {
        //["miembros"] call fn_LoadStat;
        call compile preprocessFileLineNumbers "orgPlayers\mList.sqf";
        theBoss = objNull;
        {
        if (([_x] call isMember) and (side _x == buenos)) exitWith
            {
            theBoss = _x;
            //_x setRank "CORPORAL";
            //[_x,"CORPORAL"] remoteExec ["ranksMP"];
            //_x setVariable ["score", 25,true];
            };
        } forEach playableUnits;
        publicVariable "theBoss";
        }
    else
        {
        theBoss = objNull;
        diag_log "Antistasi: New Game selected";
        if (isNil "comandante") then {comandante = (playableUnits select 0)};
        if (isNull comandante) then {comandante = (playableUnits select 0)};
        theBoss = comandante;
        publicVariable "theBoss";
        theBoss setRank "CORPORAL";
        [theBoss,"CORPORAL"] remoteExec ["ranksMP"];
        if (membershipEnabled) then {miembros = [getPlayerUID theBoss]} else {miembros = []};
        publicVariable "miembros";
        };
    _nul = [caja] call cajaAAF;
    };
    /*
    {
    if (_x!=comandante) then
        {
        //_x setVariable ["score", 0,true];
        }
    else
        {
        theBoss = _x;
        publicVariable "theBoss";
        _x setRank "CORPORAL";
        [_x,"CORPORAL"] remoteExec ["ranksMP"];
        if (membershipEnabled) then {miembros = [getPlayerUID _x]} else {miembros = []};
        publicVariable "miembros"};
        //_x setVariable ["score", 25,true];
        };
    } forEach (playableUnits select {side _x == buenos});*/
diag_log "Antistasi MP Server. Players are in";

{
private _index = _x call jn_fnc_arsenal_itemType;
[_index,_x,-1] call jn_fnc_arsenal_addItem;
}foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);


diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint","Server Init Completed"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{[_this select 0] call onPlayerDisconnect;false}];
addMissionEventHandler ["BuildingChanged",
        {
        _building = _this select 0;
        if !(_building in antenas) then
            {
            if (_this select 2) then
                {
                destroyedBuildings pushBack (getPosATL _building);
                };
            };
        }];

serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";

waitUntil {sleep 1;!(isNil "placementDone")};
distancias = [] spawn distancias4;
resourcecheck = [] execVM "resourcecheck.sqf";
[] execVM "Scripts\fn_advancedTowingInit.sqf";
savingServer = false;

//if (serverName in chungos) then {["asshole",false,true] remoteExec ["BIS_fnc_endMission"]};