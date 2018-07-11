//Arma 3 - Antistasi - Warlords of the Pacific by Barbolani
//Do whatever you want with this code, but credit me for the thousand hours spent making this.
enableSaving [false,false];
mapa setObjectTexture [0,"pic.jpg"];
if (isServer and (isNil "serverInitDone")) then {skipTime random 24};

if (!isMultiPlayer) then
    {
    _nul = [] execVM "musica.sqf";
    diag_log "Starting Antistasi SP";
    call compile preprocessFileLineNumbers "initVar.sqf";//this is the file where you can modify a few things.
    initVar = true;
    [] execVM "briefing.sqf";
    diag_log format ["Antistasi SP. InitVar done. Version: %1",antistasiVersion];
    {if (/*(side _x == buenos) and */(_x != comandante) and (_x != Petros)) then {_grupete = group _x; deleteVehicle _x; deleteGroup _grupete}} forEach allUnits;
    _serverHasID = profileNameSpace getVariable ["ss_ServerID",nil];
    if(isNil "_serverHasID") then
        {
        _serverID = str(round((random(100000)) + random 10000));
        profileNameSpace setVariable ["SS_ServerID",_serverID];
        };
    serverID = profileNameSpace getVariable "ss_ServerID";
    publicVariable "serverID";
    call compile preprocessFileLineNumbers "initFuncs.sqf";
    diag_log "Antistasi SP. Funcs init finished";
    call compile preprocessFileLineNumbers "initZones.sqf";//this is the file where you can transport Antistasi to another island
    diag_log "Antistasi SP. Zones init finished";
    [] execVM "initPetros.sqf";

    hcArray = [];
    serverInitDone = true;
    diag_log "Antistasi SP. serverInitDone is true. Arsenal loaded";
    _nul = [] execVM "modBlacklist.sqf";
    autoSave = false;
    membershipEnabled = false;
    switchCom = false;
    tkPunish = false;
    distanciaMiss = 4000;
    skillMult = 1;
    minWeaps = 24;
    civTraffic = 1;
    {
    private _index = _x call jn_fnc_arsenal_itemType;
    [_index,_x,-1] call jn_fnc_arsenal_addItem;
    }foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);
    _nul = [caja] call cajaAAF;
    waitUntil {sleep 1;!(isNil "placementDone")};
    distancias = [] spawn distancias4;
    resourcecheck = [] execVM "resourcecheck.sqf";
    [] execVM "Scripts\fn_advancedTowingInit.sqf";
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
    }
else
    {
    if !(isServer) then
        {
        membershipEnabled = if (paramsArray select 2 == 1) then {true} else {false};
        switchCom = if (paramsArray select 3 == 1) then {true} else {false};
        tkPunish = if (paramsArray select 4 == 1) then {true} else {false};
        distanciaMiss = paramsArray select 5;
        skillMult = paramsArray select 8;
        minWeaps = paramsArray select 9;
        civTraffic = paramsArray select 10;
        };
    };


