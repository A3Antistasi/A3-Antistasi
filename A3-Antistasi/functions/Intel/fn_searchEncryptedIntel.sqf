/*
Author: Håkon
Description:
    Non futuristic large intel searching proccess

Arguments:
0. <Object> Intel object
1. <Object> Caller (unused)
2. <Int>    Action id

Return Value: <Nil>

Scope: Clients
Environment: Any
Public: No
Dependencies:

Example: [_intel, objNull, _actionID] call A3A_fnc_searchEncryptedIntel;

License: MIT License
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [["_intel", objNull, [objNull]], "", ["_id", -1, [0]]];

if (isNull _intel || _id isEqualTo -1) exitWith {Error_2("Invalid arguments | Intel obj: %1 | Action ID: %2", _intel, _id)};

[_intel, _id] remoteExecCall ["removeAction", 0, _intel];

{
    [_x, false] remoteExec ["setCaptive", owner _x];
} forEach ([200, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits);

private _marker = _intel getVariable "marker";
private _side = _intel getVariable "side";
private _isAirport = (_marker in airportsX);

private _pointSum = 0;
private _neededPoints = 500 + random 500;
private _pointsPerSecond = switch (true) do {
    case (tierWar > 4): {25 - tierWar * 2};
    case (tierWar > 2): {25 - tierWar};
    default {25};
};

private _noAttackChance = switch (true) do {
    case (_isAirport): {0};
    case (tierWar > 3): {0.2 - 0.2 * tierWar};
    default {0.2};
};

private _largeAttackChance = switch (true) do {
    case (_isAirport): {0.4};
    case (tierWar > 3): {0.2 + 0.2 * tierWar};
    default {0.2};
};

private _attack = selectRandomWeighted ["No", _noAttackChance, "Small", 0.6, "Large", _largeAttackChance];
if (_attack != "No") then {
    private _isLargeAttack = (_attack == "Large");
    [[_marker, _side, _isLargeAttack],"A3A_fnc_singleAttack"] remoteExec ["A3A_fnc_scheduler",2];
};

//decryption proccess
_intel setVariable ["ActionNeeded", false, true];
["", 0, 0] params ["_errorText", "_errorChance", "_enemyCounter"];
private _lastTime = time;
private _timeDiff = 0;
while {_pointSum <= _neededPoints} do {

    sleep 1;
    _timeDiff = (time - _lastTime) max 1;
    _lastTime = time;

    //Checking for players in range
    private _playerList = [20, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits;
    if({[_x] call A3A_fnc_canFight} count _playerList == 0) exitWith
    {
        _pointSum = 0;
        {
            [petros,"hint","No one in range of the intel, need to start from scratch", "Search Intel"] remoteExec ["A3A_fnc_commsMP",_x]
        } forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    };

    //action not needed, random chance increasing over time to add a action to do
    private _actionNeeded = _intel getVariable ["ActionNeeded", false];
    if (!_actionNeeded) then {
        _errorChance = _errorChance + ((1 + (0.1 * tierWar)) * _timeDiff);
        if (random 500 < _errorChance) then {
            _actionNeeded = true;
            _intel setVariable ["Actionneeded", _actionNeeded, true];
            private _error = selectRandomWeighted [1, 0.25, 2, 0.2, 3, 0.15, 4, 0.1];
            private _actionText = "";
            private _actionTime = 1;
            switch (_error) do {
                case 1: {
                    _errorText = "Reference to unknown loaction, need to locate location to continue decifering";
                    _actionText = "Locate location";
                    _actionTime = 3;
                };
                case 2: {
                    _errorText = "Ilegible text encountered, need to decifer meaning from context";
                    _actionText = "Decifer meaning";
                    _actionTime = 5;
                };
                case 3: {
                    _errorText = "Unkown codename encountered, need to decifer the codename reference";
                    _actionText = "Decifer codename";
                    _actionTime = 10;
                };
                case 4: {
                    _errorText = "Section of texts meaning hidden behind a riddle, have to solve it to continue";
                    _actionText = "Solve riddle";
                    _actionTime = 15;
                }
            };

            [_intel, _actionText, "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                "_this distance _target < 3", "_caller distance _target < 3",
                {}, {}, {
                    _this params ["_intel", "", "_id"];
                    _intel setVariable ["Actionneeded", false, true];
                    [_intel, _id] remoteExecCall ["BIS_fnc_holdActionRemove", 0, _intel]
                }, {}, [], _actionTime, 0, true, false
            ] remoteExecCall ["BIS_fnc_holdActionAdd", 0, _intel];
        };
    };

    //move enemies to attack intel gatherers
    if(_enemyCounter > 10) then {
        {
            _x doMove (getPos _intel);
        } forEach ([300, 0, _intel, Invaders] call A3A_fnc_distanceUnits);
        {
            _x doMove (getPos _intel);
        } forEach ([300, 0, _intel, Occupants] call A3A_fnc_distanceUnits);
        _enemyCounter = 0;
    } else { _enemyCounter = _enemyCounter + 1 };

    if (_actionNeeded) then {
        //if action needed hint to nearby players
        [
            "Search Intel"
            , _errorText
        ] remoteExec ["A3A_fnc_customHint", (_intel nearEntities ["CAManBase", 25]) select {isPlayer _x}];
    } else {
        //else tick up pointsum and notify nearby players of progress
        _pointSum = _pointSum + (_pointsPerSecond * _timeDiff);
        [
            "Search Intel"
            , "Decryption progress at "+ str (round (_pointSum/_neededPoints * 100) min 100) + "%"
        ] remoteExec ["A3A_fnc_customHint", (_intel nearEntities ["CAManBase", 25]) select {isPlayer _x}];
    };
};

if (_pointSum >= _neededPoints) then {
    private _intelText = ["Large", _side] call A3A_fnc_selectIntel;
    [_intelText] remoteExec ["A3A_fnc_showIntel", 0];
    {
        ["Search Intel", "You managed to decifer the intel!"] call A3A_fnc_customHint;
        [10,_x] call A3A_fnc_playerScoreAdd;
    } forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    [5, theBoss] call A3A_fnc_playerScoreAdd;
} else {
    _intel remoteExecCall ["removeAllActions", 0, _intel];
    [_intel, "Intel_Large"] remoteExec ["A3A_fnc_flagaction",0, _intel];
};
