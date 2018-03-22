/*
 * Author: IrLED
 * Executes the initialization of headless client.
 * That includes registartion of ownerId on the Server
 *
 * Arguments:
 * 0: id of the worker to register <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

if !isServer exitWith {};
_this spawn{
    params["_id"];
    INFO_1("Registartion request received. ID: %1", _id);
    //validation
    private _time = diag_tickTime + 300;
    waitUntil{sleep 1; ({owner _x == _id;}count allPlayers == 1) OR diag_tickTime > _time}; //300sec timeout for sync issues
    LOG_1("AllPlayers: %1", allPlayers);
    LOG_1("Count of ids: %1", {owner _x == _id;}count allPlayers);
    if ({owner _x == _id;}count allPlayers != 1) exitWith {ERROR_1("Validation failed, no entity with id:%1 found", _id);};
    INFO("Validation passed");
    //registartion
    workerArray pushBackUnique _id;

    //custom post-registartion execution
    private _workerInitialization ={
        if ((['AS_enableVCOM', 0] call BIS_fnc_getParamValue) == 1) then {
            [] execVM "VCOMAI\init.sqf";
        };
        INFO("[SERVER] Registartion successful.");
    };
    [_workerInitialization] remoteExec ["call", _id];
};
