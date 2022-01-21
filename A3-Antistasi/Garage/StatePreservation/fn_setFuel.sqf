/*
    Author: [Håkon]
    [Description]
        Sets the fuel state of a vehicle

    Arguments:
        0. <Objet> Vehicle
        1. <Array> [
            <Int> Fuel
            <Int> Fuel cargo
            <Int> Ace Fuel cargo
        ] Fuel state

    Return Value: <nil>

    Scope: Any
    Environment: Any
    Public: Yes
    Dependencies:

    Example:

    License: APL-ND
*/
params ["_vehicle", "_fuelStats"];
if !(local _vehicle) exitWith {};
_fuelStats params [["_fuel",1, [0]], ["_fuelCargo",-1,[0]], "_aceFuel"];
_vehicle setFuel _fuel;
_vehicle setFuelCargo _fuelCargo;
if (!isNil "_aceFuel") then {
    _vehicle setVariable ["ace_refuel_currentFuelCargo", _aceFuel, true];
};
