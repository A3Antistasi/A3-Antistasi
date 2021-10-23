params [["_side", sideEnemy]];
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
/*  Handles the large attack that also are missions

    Execution on: HC or Server

    Scope: Internal

    Params:
        None

    Returns:
        Nothing
*/

private _originalSide = _side;

Info_1("Starting large attack script for side %1", _side);

if (A3A_hasIFA and (sunOrMoon < 1)) exitWith
{
    Info("Aborting attack as IFA has no nightvision (at least thats what I assume)");
};

private _possibleTargets = markersX - controlsX - outpostsFIA - ["Synd_HQ","NATO_carrier","CSAT_carrier"] - destroyedSites;;
private _possibleStartBases = airportsX select {([_x,false] call A3A_fnc_airportCanAttack)};
private _targetSide = sideEnemy;
//No AI vs AI, possible targets are only bases held by rebels
if (gameMode != 1) then
{
    _possibleTargets = _possibleTargets select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
    _possibleStartBases = _possibleStartBases select {sidesX getVariable [_x,sideUnknown] == _side};
    _targetSide = teamPlayer;
}
else
{
    //Select the target side and reduce possible targets based on it
    private _playersHold = 0;
    private _ownHold = 0;
    private _enemyAIHold = 0;

    {
        switch (sidesX getVariable [_x, sideUnknown]) do
        {
            case (teamPlayer):
            {
                _playersHold = _playersHold + 1;
            };
            case (_side):
            {
                _ownHold = _ownHold + 1;
            };
            default
            {
                _enemyAIHold = _enemyAIHold + 1;
            };
        };
    } forEach (airportsX + outposts + seaports + factories + resourcesX);

    private _allTargetsCount = _playersHold + _ownHold + _enemyAIHold;

    private _playersHoldRatio = _playersHold / _allTargetsCount;
    private _enemyAIHoldRatio = _enemyAIHold / _allTargetsCount;

    private _attackerAggro = 0;
    private _defenderAggro = 0;
    private _enemySide = sideUnknown;

    if(_side == Occupants) then
    {
        _attackerAggro = aggressionOccupants;
        _defenderAggro = aggressionInvaders;
        _enemySide = Invaders;
    }
    else
    {
        _attackerAggro = aggressionInvaders;
        _defenderAggro = aggressionOccupants;
        _enemySide = Occupants;
    };

    //Select the side to attack and the remaining targets
    _targetSide = selectRandomWeighted [teamPlayer, (0.5 * _playersHoldRatio) + (0.5 * (_attackerAggro/100)), _enemySide, _enemyAIHoldRatio];

    //Side selected, check for counter attack
    if(_targetSide != teamPlayer) then
    {
        private _aggroChance = (100 - _defenderAggro) - (100 - _attackerAggro);
        private _winChance = 50 - (_aggroChance/2);
        private _loseChance = 100 - _winChance;
        Debug_2("Attacker win chance is %1, counter chance is %2", _winChance, _loseChance);
        private _attackerWon = selectRandomWeighted [false, _loseChance, true, _winChance];
        if(!_attackerWon) then
        {
            Debug_2("Attack from %1 got countered by %2, reversing attack sides", _side, _enemySide);
            _targetSide = _side;
            _side = _enemySide;
        };
    };

    _possibleStartBases = _possibleStartBases select {sidesX getVariable [_x,sideUnknown] == _side};
    _possibleTargets = _possibleTargets select {sidesX getVariable [_x,sideUnknown] == _targetSide};
    Debug_1("Selected target side is %1", _targetSide);
};

if((_side == Occupants) && (gameMode != 4)) then
{
    _possibleStartBases pushBack "NATO_carrier";
};
if((_side == Invaders) && (gameMode != 3)) then
{
    _possibleStartBases pushBack "CSAT_carrier";
};

//On low level remove cities from target list
if (gameMode != 4) then
{
	if (tierWar < 3) then {_possibleTargets = _possibleTargets - citiesX;};
}
else
{
	if (tierWar < 5) then {_possibleTargets = _possibleTargets - citiesX;};
};

// Remove cities anyway unless they're rebel-controlled, because punishments vs occupants are broken
_possibleTargets = _possibleTargets - (citiesX select {sidesX getVariable [_x, sideUnknown] != teamPlayer});

//Attacks on rebels should be closer than mission range
_possibleTargets = _possibleTargets select {sidesX getVariable [_x, sideUnknown] != teamPlayer || (getMarkerPos _x) distance2D (getMarkerPos "Synd_HQ") < distanceMission};

if((count _possibleTargets == 0) || (count _possibleStartBases == 0)) exitWith
{
    Info("Attack found no suitable targets or no suitable start bases, aborting!");
};

Debug_2("%1 possible targets for attack found, possible start points are %2", count _possibleTargets, _possibleStartBases);

private _easyTargets = [];
private _availableTargets = [];
{
    private _startAirport = _x;
    private _airportSide = sidesX getVariable [_startAirport, sideUnknown];

    //Gather position and killzones of airport
    private _killZones = killZones getVariable [_startAirport, []];
    private _startAirportPos = getMarkerPos _startAirport;
    {
        //For each target, calculate the distance to the airport
        private _target = _x;
        private _distance = (getMarkerPos _target) distance2D _startAirportPos;
        //In air range, add to target list
        if(_distance < distanceForAirAttack) then
        {
            //If in land range, half the distance
            if(_distance < distanceForLandAttack && {[_startAirport, _target] call A3A_fnc_arePositionsConnected}) then
            {
                _distance = _distance * 0.5;
            };

            //If the target is surrounded by our friendly markers, remove points
            private _nearbyFriendlyMarkers = (markersX - controlsX - citiesX - outpostsFIA) select
            {
                (sidesX getVariable [_x,sideUnknown] == _airportSide) &&
                {(getMarkerPos _x) distance2D (getMarkerPos _target) < 1500}
            };
            _distance = _distance - (300 * (count _nearbyFriendlyMarkers));
            if (_distance < 0) then {_distance = 0};

            //if(count _nearbyFriendlyMarkers >= 5 && {!(_target in citiesX)}) then
            //{
            //    Debug_1("%1 is surrounded by us, considering easy target", _target);
            //    _easyTargets pushBack _target;
            //};

            //If in killzones, double the distance
            if (_target in _killZones) then
            {
                _distance = _distance * 2;
            };

            //Add airport to the possible start bases for attack to this target, use distance as points (the lower the better)
            private _index = _availableTargets findIf {(_x select 0) == _target};
            if(_index == -1) then
            {
                _availableTargets pushBack [_target, [[_startAirport, _distance]]];
            }
            else
            {
                private _targetArray = _availableTargets select _index;
                (_targetArray select 1) pushBack [_startAirport, _distance];
            };
        };
    } forEach _possibleTargets;
} forEach _possibleStartBases;

if (count _availableTargets == 0) exitWith
{
    Info("Attack could not find available targets, aborting!");
};

{
    _x params ["_target", "_baseArray"];

    //Multiplier is used as an overall multiplier based on types
    private _targetMultiplier = 1;
    //Additional points based on marker specific traits
    private _targetPoints = 0;

    //Selecting a multiplier based on target type (lowest is best)
    switch (true) do
    {
        case (_target in airportsX): {_targetMultiplier = 0.05};
        case (_target in outposts): {_targetMultiplier = 0.25};
        case (_target in resourcesX): {_targetMultiplier = 0.35};
        case (_target in factories): {_targetMultiplier = 0.5};
        case (_target in seaports): {_targetMultiplier = 0.7};
        case (_target in citiesX): {_targetMultiplier = [2, 0.5] select (_side == Invaders)};
        //If I have missed something, multiplier stays the same
        default {_targetMultiplier = 1};
    };

    //Adding points based on nearby friendly locations
    private _nearbyFriendlyMarkers = (markersX - controlsX - citiesX - outpostsFIA) select
    {
        (sidesX getVariable [_x,sideUnknown] == _targetSide) &&
        {(getMarkerPos _x) distance2D (getMarkerPos _target) < 1500}
    };
    _targetPoints = 500 * (count _nearbyFriendlyMarkers);

    //Adding points based on garrison and statics
    private _garrison = garrison getVariable [_target,[]];
    private _nearbyStatics = staticsToSave select {(_x distance2D (getMarkerPos _target)) < distanceSPWN};
    _targetPoints = _targetPoints + (10 * (count _garrison) + (50 * (count _nearbyStatics)));

    //if((count _garrison <= 8) && (_targetSide == teamPlayer) && {(count _nearbyStatics <= 2) && {!(_target in citiesX)}}) then
    //{
        //Only minimal garrison, consider it an easy target
    //    Debug_1("%1 has only minimal garrison, considering easy target", _target);
    //    _easyTargets pushBackUnique _target;
    //};

    //Apply the new points to the base array
    _baseArray = _baseArray apply {[_x select 0, ((_x select 1) + _targetPoints) * _targetMultiplier]};
} forEach _availableTargets;

/*
All targets are now having values which airport can attack them how efficient
We will check for easy targets first, if we have four of them we will attack them
instead of starting one large attack. In both cases we check which are the most efficient ones
to attack from which airport
*/

private _fnc_flipMarker =
{
    params ["_side", "_marker"];
    Info_2("Autowin %1 for side %2 to avoid unnecessary calculations", _marker, _side);
    [_side, _marker] spawn A3A_fnc_markerChange;
    private _faction = Faction(_side);
    sleep 10;
    private _maxTroops = 12 max round ((0.5 + random 0.5) * ([_marker] call A3A_fnc_garrisonSize));
    private _soldiers = [];
    while {count _soldiers < _maxTroops} do
    {
        _soldiers append selectRandom ((_faction get "groupsSquads") + (_faction get "groupsMedium"));
    };
    _soldiers resize _maxTroops;
    [_soldiers,_side,_marker,0] remoteExec ["A3A_fnc_garrisonUpdate",2];
};


// JJ: Easy targets currently disabled due to overspawning/ineffectiveness
if(count _easyTargets >= 4) then
{
    //We got four easy targets, attacking them now
    private _attackList = [objNull, objNull, objNull, objNull];
    {
        private _target = _x;
        private _index = _availableTargets findIf {(_x select 0) == _target};
        private _startArray = (_availableTargets select _index) select 1;

        //Search for the best option for attacking this target (lowest number is best)
        private _attackParams = objNull;
        {
            if(!(_attackParams isEqualType []) || {(_attackParams select 1) > (_x select 1)}) then
            {
                _attackParams = _x;
            };
        } forEach _startArray;
        _attackParams pushBack _target;

        //Check if the attack is better than one of the current selected ones
        private _insertIndex = _attackList findIf {(!(_x isEqualType [])) || {(_x select 1) > (_attackParams select 1)}};
        if(_insertIndex != -1) then
        {
            if(_insertIndex == 3) then
            {
                _attackList set [3, _attackParams];
            }
            else
            {
                //Sort in and push all worse option down by one
                for "_i" from 3 to _insertIndex step -1 do
                {
                    _attackList set [_i + 1, _attackList select _i];
                };
                //Set attack and then cut of the last option
                _attackList set [_insertIndex, _attackParams];
                _attackList resize 4;
            };
        };
    } forEach _easyTargets;

    DebugArray("Found four targets to attack, these are:", _attackList);

    //In case of four small attacks have 90 minutes break
    [5400, _originalSide] call A3A_fnc_timingCA;

    //Execute the attacks from the given bases to the targets
    {
        private _target = _x select 2;
        private _nearPlayers = allPlayers findIf {(getMarkerPos (_target) distance2D _x) < 1500};
        if((_nearPlayers != -1) || ((spawner getVariable _target) != 2) || (sidesX getVariable _target == teamPlayer)) then
        {
            Info_2("Starting single attack against %1 from %2", _target, _x select 0);
            [[_target, _x select 0, false],"A3A_fnc_singleAttack"] remoteExec ["A3A_fnc_scheduler",2];
            sleep 180;
        }
        else
        {
            private _side = sidesX getVariable (_x select 0);
            [_side, _target] spawn _fnc_flipMarker;
        };
        sleep 15;
    } forEach _attackList;
}
else
{
    //Not enough easy targets, attack the best non easy target if available
    private _mainTarget = objNull;
    private _easyTarget = objNull;
    {
        _x params ["_target", "_startArray"];

        //Select the best attack option for the target
        private _attackParams = objNull;
        {
            if(!(_attackParams isEqualType []) || {(_attackParams select 1) > (_x select 1)}) then
            {
                _attackParams = _x;
            };
        } forEach _startArray;
        _attackParams pushBack _target;

        //It makes less sense to hit a weak target with a strong waved attack, save it seperated
        if (_target in _easyTargets) then
        {
            if (!(_easyTarget isEqualType []) || {(_easyTarget select 1) > (_attackParams select 1)}) then
            {
                _easyTarget = _attackParams;
            };
        }
        else
        {
            if(!(_mainTarget isEqualType []) || {(_mainTarget select 1) > (_attackParams select 1)}) then
            {
                _mainTarget = _attackParams;
            };
        };
    } forEach _availableTargets;

    Debug_2("Main target is %1, easy target is %2", _mainTarget, _easyTarget);

    //If one if the target is not set, use the other one
    private _finalTarget = objNull;
    if(!(_mainTarget isEqualType [])) then
    {
        Debug("Main target not set, selecting easy target");
        _finalTarget = _easyTarget;
    }
    else
    {
        if(!(_easyTarget isEqualType [])) then
        {
            Debug("Easy target not set, selecting main target");
            _finalTarget = _mainTarget;
        }
        else
        {
            //If both are set, select easy target only if it is 2 times better than the main target
            if(((_easyTarget select 1) * 2) < (_mainTarget select 1)) then
            {
                _finalTarget = _easyTarget;
            }
            else
            {
                _finalTarget = _mainTarget;
            };
        };
    };

    Debug_1("Selected target is %1!", _finalTarget);

    _finalTarget params ["_attackOrigin", "_attackPoints", "_attackTarget"];

    //Select the number of waves based on the points as higher points mean higher difficulty
    // JJ: Nope, degenerate behaviour with target distance. Revert to a dumb version for the moment.
    private _waves =
        0.5 + random 1 +
        + ([0, 1.5] select (_attackTarget in airportsX))
        + ([0, 0.5] select (_attackTarget in outposts))
        + ([0, 0.5] select (_side == Invaders))
        + (tierWar / 10);

	_waves = 1 max (round _waves);

    //Send the actual attacks
    if (sidesX getVariable [_attackOrigin, sideUnknown] == Occupants || {!(_attackTarget in citiesX)}) then
    {
        private _nearPlayers = allPlayers findIf {(getMarkerPos (_attackTarget) distance2D _x) < 1500};
        if((_nearPlayers != -1) || ((spawner getVariable _attackTarget) != 2) || (sidesX getVariable _attackTarget == teamPlayer) || (_attackTarget in citiesX)) then
        {
            //Sending real attack, execute the fight
            Info_3("Starting waved attack with %1 waves from %2 to %3", _waves, _attackOrigin, _attackTarget);
            [_attackTarget, _attackOrigin, _waves, _originalSide] spawn A3A_fnc_wavedCA;
        }
        else
        {
            [_side, _attackTarget] spawn _fnc_flipMarker;
            [3600, _originalSide] call A3A_fnc_timingCA;
        };
    }
    else
    {
        Info_2("Starting punishment mission from %1 to %2", _attackOrigin, _attackTarget);
        [_attackTarget, _attackOrigin] spawn A3A_fnc_invaderPunish;
    };
};
