/*
 * Author: IrLED
 * Initializes worker server infrastructure
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

workerArray = [2];

//VCOM initialization
if(isServer AND (['AS_enableVCOM', 0] call BIS_fnc_getParamValue) == 1) then {
    [] execVM "VCOMAI\init.sqf";
};

addMissionEventHandler ["PlayerDisconnected",{[_this select 4] call AS_fnc_unregisterWorker;}];
[] spawn {
    LOG("Waiting for allPlayers !isEqualTo []");
    waitUntil {sleep 1; !(allPlayers isEqualTo []);};
    LOG("SUCCESS allPlayers !isEqualTo []");
    AS_workerServer=true;
    publicVariable "AS_workerServer";
    LOG("AS_workerServer set");
};
INFO("WorkerServer init done");
