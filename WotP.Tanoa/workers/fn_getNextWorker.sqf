/*
 * Author: IrLED
 * Requests next worker according to the set strategy
 *
 * Arguments:
 *
 * Return Value:
 * id of the worker of choice <NUMBER>
 *
 * Public: No
 */

if (isNil "workerArray") then {//Called not on server (by mistake?), some PDA functions (USMC Resupply) are executed on client
    //Will run on server
    2;
}else{
    //Only one worker - nothing to calculatr
    if (count workerArray == 1) exitWith {workerArray select 0};

    //Calculating AIs with coef
    private _accuArray = [];
    {
        private _currOwn = _x;
        _accuArray pushBack (({owner _x == _currOwn} count allUnits)* ([1,6] select (_currOwn == 2)));
    }forEach workerArray;

    //Select minimum
    private _minIdx = 0;
    private _minVal = _accuArray select _minIdx;
    {
        if(_x < _minVal) then {
            _minVal = _x; _minIdx = _forEachIndex;
        }
    }forEach _accuArray;
    workerArray select _minIdx;
};
