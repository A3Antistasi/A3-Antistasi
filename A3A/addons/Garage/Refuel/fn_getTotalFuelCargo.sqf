/*
Author: Håkon
Description:
    Sums the total available fuel from sources in the garage

Arguments: <nil>

Return Value:
<Number> The total fuel from sources in the garage (in liters)

Scope: Any
Environment: unscheduled
Public: Yes
Dependencies:

Example:

License: APL-ND
*/
private _totalFuelCargo = 0;
{
    private "_vehData";
    for "_i" from 0 to 4 do { _vehData = (HR_GRG_Vehicles#_i) get _x; if (!isNil "_vehdata") exitWith {}; }; //find vehicles in categorys, typically cat 0 "cars"
    private _fuelData = _vehData#4#0;
    _totalFuelCargo = _totalFuelCargo + (if (A3A_hasAce) then {
        private _aceFuelCargo = _fuelData#2;
        if (isNil "_aceFuelCargo") then {0} else {_aceFuelCargo}
    } else {
        private _transportFuel = getNumber (configFile/"CfgVehicles"/_vehData#1/"transportFuel");
        (_fuelData#1) * _transportFuel
    });
} forEach (HR_GRG_Sources#1);

_totalFuelCargo;
