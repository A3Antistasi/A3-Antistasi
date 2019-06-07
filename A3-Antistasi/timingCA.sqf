
params [
    "_base", 
    ["_range", 0],
    ["_reason", "unknown"]
    ];

if(isNil "cuentaCA") then {
    cuentaCA = 0;
    publicVariable "cuentaCA";
};

private _t = (0.0005 * timeSinceLastAttack);
private _factor = 1 / (1 + _t * _t);
private _unmodified_amount = _base + random(_range);

if(_unmodified_amount < 0) then {
    _factor = 1 - _factor;
};

private _final_change = _unmodified_amount * _factor;
cuentaCA = cuentaCA + _final_change;

diag_log format ["[timingCA] base = %1, range = %2, reason = %3. Final change = %4, new timing = %5", 
    _base, _range, _reason, _final_change, cuentaCA];


// _mayor = if (_tiempo >= 3600) then {true} else {false};

// _tiempo = _tiempo - (((tierWar + difficultyCoef)-1)*400);

// if (_tiempo < 0) then {_tiempo = 0};

// cuentaCA = cuentaCA + round (random _tiempo);

// if (_mayor and (cuentaCA < 1200)) then {cuentaCA = 1200};





