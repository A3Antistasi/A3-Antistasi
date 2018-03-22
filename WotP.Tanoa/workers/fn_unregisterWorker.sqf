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
params["_id"];
if !(_id in workerArray) exitWith {};
INFO_1("Deregistartion request received. ID: %1", _id);
workerArray = workerArray - [_id];
