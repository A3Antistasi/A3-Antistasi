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
if !(serverName in servidoresOficiales) then
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


caja call jn_fnc_arsenal_init;
{
private _index = _x call jn_fnc_arsenal_itemType;
[_index,_x,-1] call jn_fnc_arsenal_addItem;
}foreach (unlockeditems + unlockedweapons + unlockedMagazines + unlockedBackpacks);


diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint","Server Init Completed"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{[_this select 0] call onPlayerDisconnect;false}];
/*addMissionEventHandler ["PlayerDisconnected",{
    _owner = _this select 4;
    {
    if ((groupOwner _x == _owner) and (side _x == civilian)) then
        {
        _grupo = _x;
        {deleteVehicle _x} forEach units _grupo;
        _grupo spawn {sleep 15; deleteGroup _this};
        };
    } forEach allGroups;
    }];
*/

serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";
//if (serverName in chungos) then {["asshole",false,true] remoteExec ["BIS_fnc_endMission"]};