/*
Author: Håkon
Description:
    handles spawning in HC groups

Arguments:
0. <Array> Units types to spawn
1. <String> ID format for the group
2. <String> Special handling of group spawning
3. <Object> Vehicle to assign to the group (optional)

Return Value:
<Group> The spawned group

Scope: Any
Environment: Any
Public: Yes
Dependencies:

Example:

License: MIT License
*/
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params [
    ["_unitTypes", [], [[]]]
    , ["_idFormat", "", [""]]
    , ["_special", "", [""]]
    , ["_vehicle", objNull, [objNull]]
];

//calculate base cost
private _cost = if (isNull _vehicle) then { 0 } else { [typeOf _vehicle] call A3A_fnc_vehiclePrice };
private _costHR = 0;
{
    _cost = _cost + (server getVariable _x); _costHR = _costHR +1
} forEach _unitTypes;

//spawn group
private _pos = [(getMarkerPos respawnTeamPlayer), 30, random 360] call BIS_Fnc_relPos;
private _group = [_pos, teamPlayer, _unitTypes, true] call A3A_fnc_spawnGroup;
_group setGroupIdGlobal [_idFormat + str ({side (leader _x) == teamPlayer} count allGroups)];

private _units = units _group;
{[_x] call A3A_fnc_FIAinit} forEach _units;
theBoss hcSetGroup [_group];

petros directSay "SentGenReinforcementsArrived";
["Recruit Squad", format ["Group %1 at your command.<br/><br/>Groups are managed from the High Command bar (Default: CTRL+SPACE)<br/><br/>If the group gets stuck, use the AI Control feature to make them start moving. Mounted Static teams tend to get stuck (solving this is WiP)<br/><br/>To assign a vehicle for this group, look at some vehicle, and use Vehicle Squad Mngmt option in Y menu.", groupID _group]] call A3A_fnc_customHint;

private _countUnits = count _units -1;
private _bypassAI = true;

//vehicle init funcs
private _initInfVeh = {
    if (isNull _vehicle) exitWith {};
    leader _group moveInDriver _vehicle;
    call _initVeh;
    ["Recruit Squad", "Vehicle Purchased"] call A3A_fnc_customHint;
    petros directSay "SentGenBaseUnlockVehicle";
};

private _initVeh = {
    [_vehicle, teamPlayer] call A3A_fnc_AIVEHinit;
    [_vehicle] spawn A3A_fnc_vehDespawner;
    _group addVehicle _vehicle;
    _vehicle setVariable ["owner",_group,true];
    driver _vehicle action ["engineOn", _vehicle];
    { if (vehicle _x == _x) then { _x moveInAny _vehicle } } forEach units _group;
};

// special handling
switch _special do {
    //static squad
    case "staticAutoT": {
        private _staticType = switch _idFormat do {
            case "Mort-": {FactionGet(reb,"staticMortar")};
            case "MG-": {FactionGet(reb,"staticMG")};
            default {""};
        };

        call _initInfVeh;
        _group setVariable ["staticAutoT",false,true];
        [_group, _staticType] spawn A3A_fnc_MortyAI;
        _cost = _cost + ([_staticType] call A3A_fnc_vehiclePrice);
    };

    //vehicle squad
    case "BuildAA": {
        private _static = ((attachedObjects _vehicle) select {typeOf _x == FactionGet(reb,"staticAA")})#0;
        (_units # (_countUnits -1)) moveInDriver _vehicle;
        (_units # _countUnits) moveInGunner _static;
        call _initVeh;
        _cost = _cost + ([FactionGet(reb,"staticAA")] call A3A_fnc_vehiclePrice);

    };
    case "VehicleSquad": {
        (_units # (_countUnits -1)) moveInDriver _vehicle;
        (_units # _countUnits) moveInGunner _vehicle;
        call _initVeh;
    };

    //inf squad
    _bypassAI = false;
    call _initInfVeh;
    case "MG": {
        private _backpacks = getArray (configFile/"CfgVehicles"/FactionGet(reb,"staticMG")/"assembleInfo"/"dissasembleTo");
        (_units # (_countUnits - 1)) addBackpackGlobal (_backpacks#1);
        (_units # _countUnits) addBackpackGlobal (_backpacks#0);
        _cost = _cost + ([FactionGet(reb,"staticMG")] call A3A_fnc_vehiclePrice);
    };
    case "Mortar": {
        private _backpacks = getArray (configFile/"CfgVehicles"/FactionGet(reb,"StaticMortar")/"assembleInfo"/"dissasembleTo");
        (_units # (_countUnits - 1)) addBackpackGlobal (_backpacks#1);
        (_units # _countUnits) addBackpackGlobal (_backpacks#0);
        _cost = _cost + ([FactionGet(reb,"staticMortar")] call A3A_fnc_vehiclePrice);
    };
};

[- _costHR, - _cost] remoteExec ["A3A_fnc_resourcesFIA", 2];

if !(_bypassAI) then {_group spawn A3A_fnc_attackDrillAI};

_group
