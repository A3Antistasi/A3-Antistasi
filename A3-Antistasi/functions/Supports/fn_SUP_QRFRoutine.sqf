params ["_side", "_vehicles", "_groups", "_posDestination", "_supportName"];

/*  The despawn routine of the QRF support

    Execution on: HC or Server

    Scope: Internal

    Parameters:
        _side: SIDE : The side of the attackers
        _vehicles: ARRAY of OBJECTS : All vehicles used by the QRF
        _groups: ARRAY of GROUPS : All groups used by the QRF
        _posDestination: POSITION : The target position
        _supportName: STRING : The callname of the support

    Returns:
        Nothing
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
//Prepare despawn conditions
private _endTime = time + 2700;
private _qrfHasArrived = false;
private _qrfHasWon = false;

private _targetList = server getVariable [format ["%1_targets", _supportName], []];
private _reveal = _targetList select 0 select 1;

while {true} do
{
    if !(_qrfHasArrived) then
    {
        //Not yet arrived
        private _index = _vehicles findIf {getPos _x distance2D _posDestination < 300};
        if(_index != -1) then
        {
            Info_1("%1 has arrived with at least one vehicle, attacking now", _supportName);
            _qrfHasArrived = true;

            private _textMarker = createMarker [format ["%1_text", _supportName], _posDestination];
            _textMarker setMarkerShape "ICON";
            _textMarker setMarkerType "mil_dot";
            _textMarker setMarkerText "QRF";
            if(_side == Occupants) then
            {
                _textMarker setMarkerColor colorOccupants;
            }
            else
            {
                _textMarker setMarkerColor colorInvaders;
            };
            _textMarker setMarkerAlpha 0;
            [_reveal, _posDestination, _side, "QRF", format ["%1_coverage", _supportName], _textMarker] spawn A3A_fnc_showInterceptedSupportCall;
        };
    }
    else
    {
        //QRF in combat, check if won
        private _nearbyEnemyGroups = allGroups select {(side _x != _side) && (side _x != civilian) && {getPos (leader _x) distance2D _posDestination < 300}};
        if(count _nearbyEnemyGroups == 0) then
        {
            Info_1("%1 has arrived with at least one vehicle, attacking now", _supportName);
            _qrfHasWon = true;
        };
    };
    if(_qrfHasWon) exitWith {};

    private _groupAlive = false;
    {
        private _index = (units _x) findIf {[_x] call A3A_fnc_canFight};
        if(_index != -1) exitWith
        {
            _groupAlive = true;
        };
    } forEach _groups;

    if !(_groupAlive) exitWith
    {
        Info_1("%1 has been eliminated, starting despawn routines", _supportName);
        [_side, 10, 60] remoteExec ["A3A_fnc_addAggression", 2];
    };

    sleep 15;
    if(_endTime < time) exitWith
    {
        Info_1("%1 timed out without winning or losing, starting despawn routines", _supportName);
    };
};

{
    [_x] spawn A3A_fnc_VEHDespawner;
} forEach _vehicles;

{
    [_x] spawn A3A_fnc_groupDespawner;
} forEach _groups;

private _waitTime = 3 - (tierWar - 1);
if(_waitTime < 0) then {_waitTime = 0};
[_supportName, _side, _waitTime] spawn A3A_fnc_endSupport;
