/*
 * Author: IrLED
 * Executes the initialization of headless client.
 * That includes registartion of ownerId on the Server
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

if !(isNil "AS_workerInit") exitWith {};
if (!hasInterface && !isDedicated) then {
    [] spawn {
        waitUntil {!isNull player};
        waitUntil {sleep 1; !isNil "AS_workerServer"};
        LOG_1("allPlayers: %1", allPlayers);
        INFO_1("Headless client initialization. ownerID: %1", clientOwner);
        LOG("Sending registration info to the server");
        [clientOwner] remoteExec ["AS_fnc_registerWorker", 2];
    };
};
AS_workerInit = 1;
