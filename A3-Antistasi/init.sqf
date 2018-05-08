//Arma 3 - Antistasi - Warlords of the Pacific by Barbolani
//Do whatever you want with this code, but credit me for the thousand hours spent making this.
enableSaving [false,false];
mapa setObjectTexture [0,"pic.jpg"];
if (isServer and (isNil "serverInitDone")) then {skipTime random 24};

if (!isMultiPlayer) then
    {
    [] execVM "briefing.sqf";

    _nul = [] execVM "musica.sqf";
    diag_log "Starting Antistasi SP";
    call compile preprocessFileLineNumbers "initVar.sqf";//this is the file where you can modify a few things.
    diag_log format ["Antistasi SP. InitVar done. Version: %1",antistasiVersion];
    {if (/*(side _x == buenos) and */(_x != comandante) and (_x != Petros)) then {_grupete = group _x; deleteVehicle _x; deleteGroup _grupete}} forEach allUnits;
    call compile preprocessFileLineNumbers "initFuncs.sqf";
    diag_log "Antistasi SP. Funcs init finished";
    call compile preprocessFileLineNumbers "initZones.sqf";//this is the file where you can transport Antistasi to another island
    diag_log "Antistasi SP. Zones init finished";
    [] execVM "initPetros.sqf";
    //lockedWeapons = lockedWeapons - unlockedWeapons;
    /*
    [caja,unlockedItems,true,false] call addVirtualItemCargo;
    [caja,unlockedMagazines,true,false] call addVirtualMagazineCargo;
    [caja,unlockedWeapons,true,false] call addVirtualWeaponCargo;
    [caja,unlockedBackpacks,true,false] call addVirtualBackpackCargo;

    HCciviles = 2;
    HCgarrisons = 2;
    HCattack = 2;*/
    hcArray = [];
    serverInitDone = true;
    diag_log "Antistasi SP. serverInitDone is true. Arsenal loaded";
    _nul = [] execVM "modBlacklist.sqf";
    //[] spawn fpsCheck;
    };

waitUntil {(!isNil "saveFuncsLoaded") and (!isNil "serverInitDone")};

call jn_fnc_logistics_init;
caja call jn_fnc_arsenal_init;

if(isServer) then
    {
    {
    private _index = _x call jn_fnc_arsenal_itemType;
    [_index,_x,-1] call jn_fnc_arsenal_addItem;
    }foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);
    //["buttonInvToJNA"] call jn_fnc_arsenal;

    _serverHasID = profileNameSpace getVariable ["ss_ServerID",nil];
    if(isNil "_serverHasID") then
        {
        _serverID = str(round((random(100000)) + random 10000));
        profileNameSpace setVariable ["SS_ServerID",_serverID];
        };
    serverID = profileNameSpace getVariable "ss_ServerID";
    publicVariable "serverID";

    waitUntil {!isNil "serverID"};

    if (serverName in servidoresOficiales) then
        {
        ["miembros"] call fn_LoadStat;
        _nul = [] execVM "orgPlayers\mList.sqf";
        {
        if (([_x] call isMember) and (isNull stavros) and (side _x == buenos)) then
            {
            stavros = _x;
            _x setRank "CORPORAL";
            [_x,"CORPORAL"] remoteExec ["ranksMP"];
            //_x setVariable ["score", 25,true];
            };
        } forEach playableUnits;
        publicVariable "stavros";
        if (isNull stavros) then
            {
            _nul = [] execVM "statSave\loadAccount.sqf"; switchCom = true; publicVariable "switchCom";
            diag_log "Antistasi MP Server. Players are in, no members";
            }
        else
            {
            diag_log "Antistasi MP Server. Players are in, member detected";
            };
        }
    else
        {
        waitUntil {!isNil "stavros"};
        waitUntil {isPlayer stavros};
        };
    /*
    if (isMultiplayer) then
        {
        ["miembros"] call fn_LoadStat;
        _nul = [] execVM "orgPlayers\mList.sqf";
        {
        if (([_x] call isMember) and (isNull stavros) and (side _x == buenos)) then
            {
            stavros = _x;
            _x setRank "CORPORAL";
            [_x,"CORPORAL"] remoteExec ["ranksMP"];
            //_x setVariable ["score", 25,true];
            };
        } forEach playableUnits;
        publicVariable "stavros";
        if (isNull stavros) then
            {
            _nul = [] execVM "statSave\loadAccount.sqf"; switchCom = true; publicVariable "switchCom";
            diag_log "Antistasi MP Server. Players are in, no members";
            }
        else
            {
            diag_log "Antistasi MP Server. Players are in, member detected";
            };
        };
*/
    _nul = [caja] call cajaAAF;
    waitUntil {!(isNil "placementDone")};
    distancias = [] spawn distancias4;
    resourcecheck = [] execVM "resourcecheck.sqf";
    [] execVM "Scripts\fn_advancedTowingInit.sqf";
    };
