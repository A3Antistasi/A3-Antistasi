if (!isServer) exitWith{};

if (isMultiplayer) then {waitUntil {!isNil "switchCom"}};

private ["_texto"];
scriptName "resourcecheck";
private _cuentaSave = 3600;

private _powerScaling = 1;

while {true} do {

    //sleep 600;//600
    nextTick = time + 600; publicVariable "nextTick";
    waitUntil {sleep 3; time >= nextTick};
    if (isMultiplayer) then {waitUntil {sleep 10; isPlayer theBoss}};
    //_suppBoost = 1 + ({lados getVariable [_x,sideUnknown] == buenos} count puertos);
    private _recAddSDK = 25;//0
    private _hrAddBLUFOR = 0;//0
    private _popFIA = 0;
    private _popAAF = 0;
    private _popCSAT = 0;
    private _popTotal = 0;
    private _bonusFIA = 1 + (0.25*({(lados getVariable [_x,sideUnknown] == buenos) and !(_x in destroyedCities)} count fabricas));
    {
        private _ciudad = _x;
        private _recAddCiudadSDK = 0;
        private _hrAddCiudad = 0;
        private _datos = server getVariable _ciudad;
        private _numCiv = _datos select 0;
        private _numVeh = _datos select 1;
        //_roads = _datos select 2;
        private _prestigeNATO = _datos select 2;
        private _prestigeSDK = _datos select 3;
        private _power = [_ciudad] call A3A_fnc_powerCheck;
        _popTotal = _popTotal + _numCiv;
        private _numCivSDK = _numCiv * (_prestigeSDK / 100);
        private _numCivNATO = _numCiv * (_prestigeNATO / 100);
        _popFIA = _popFIA + _numCivSDK;
        _popAAF = _popAAF + _numCivNATO;
        private _multiplicandorec = if (_power != buenos) then {0.5} else {1};
        //if (not _power) then {_multiplicandorec = 0.5};

        if (_ciudad in destroyedCities) then {
            _recAddCiudadSDK = 0;
            _hrAddCiudad = 0;
            _popCSAT = _popCSAT + _numCIV;
        } else {
            _recAddCiudadSDK = ((_numciv * _multiplicandorec*(_prestigeSDK / 100))/3);
            _hrAddCiudad = (_numciv * (_prestigeSDK / 10000));///20000 originalmente
            switch (_power) do {
                case buenos: {
                    // Spread support based on proximity
                    private _spread_effect = 0;
                    {
                        private _ciudad2 = _x;
                        private _distKm = ((getMarkerPos _ciudad2) distance (getMarkerPos _ciudad)) / 1000;
                        private _range_effect = 1/(1 + 3 * _distKm);
                        // This effect terminates at about 3km
                        if (_range_effect > 0.1) then {
                            private _datos2 = server getVariable _ciudad2;
                            private _numCiv2 = _datos select 0;
                            private _numVeh2 = _datos select 1;
                            private _prestigeNATO2 = _datos select 2;
                            private _prestigeSDK2 = _datos select 3;
                            private _numCivSDK2 = _numCiv2 * (_prestigeSDK2 / 100);
                            private _numCivNATO2 = _numCiv2 * (_prestigeNATO2 / 100);
                            if(_numCivNATO2 > 0) then {
                                _spread_effect = _spread_effect + _range_effect * (_numCivNATO2 / (_numCivNATO2 + _numCivSDK));
                            };
                        };
                    } forEach ciudades - [_ciudad];
                    [0, -_spread_effect, _ciudad, "City Proximity Spread"] spawn A3A_fnc_citySupportChange;

                };//{[-_powerScaling,0,_ciudad] spawn A3A_fnc_citySupportChange};
                // TODO: Make this based on the antenna distance, just call citySupportChange with antenna positions instead...
                case malos: {[_powerScaling, -_powerScaling, _ciudad, "NATO Antenna Influence"] spawn A3A_fnc_citySupportChange};
                case muyMalos: {[-_powerScaling, -_powerScaling, _ciudad, "CSAT Antenna Influence"] spawn A3A_fnc_citySupportChange};
            };
            if (lados getVariable [_ciudad,sideUnknown] == malos) then {
                _recAddCiudadSDK = (_recAddCiudadSDK/2);
                _hrAddCiudad = (_hrAddCiudad/2);
            };
        };
        _recAddSDK = _recAddSDK + _recAddCiudadSDK;
        _hrAddBLUFOR = _hrAddBLUFOR + _hrAddCiudad;

        // revuelta civil!!
        // Need to exceed NATO support by 20, and have greater support than 50 to flip the city.
        if ((_prestigeNATO < (_prestigeSDK - 20)) and (_prestigeSDK > 50) and (lados getVariable [_ciudad,sideUnknown] == malos)) then {
            ["TaskSucceeded", ["", format ["%1 joined %2",[_ciudad, false] call A3A_fnc_fn_location,nameBuenos]]] remoteExec ["BIS_fnc_showNotification",buenos];
            lados setVariable [_ciudad,buenos,true];
            _nul = [5,0] remoteExec ["A3A_fnc_prestige",2];
            _mrkD = format ["Dum%1",_ciudad];
            _mrkD setMarkerColor colorBuenos;
            garrison setVariable [_ciudad,[],true];
            sleep 5;
            {_nul = [_ciudad,_x] spawn A3A_fnc_deleteControles} forEach controles;
            if ((!(["CONVOY"] call BIS_fnc_taskExists)) and (!bigAttackInProgress)) then {
                _base = [_ciudad] call A3A_fnc_findBasesForConvoy;
                if (_base != "") then {
                    [[_ciudad,_base],"CONVOY"] call A3A_fnc_scheduler;
                };
            };
            [] call A3A_fnc_tierCheck;
        };
        if (((_prestigeNATO > _prestigeSDK) or (_prestigeSDK < 50)) and (lados getVariable [_ciudad,sideUnknown] == buenos)) then {
            ["TaskFailed", ["", format ["%1 joined %2",[_ciudad, false] call A3A_fnc_fn_location,nameMalos]]] remoteExec ["BIS_fnc_showNotification",buenos];
            lados setVariable [_ciudad,malos,true];
            _nul = [-5,0] remoteExec ["A3A_fnc_prestige",2];
            _mrkD = format ["Dum%1",_ciudad];
            _mrkD setMarkerColor colorMalos;
            garrison setVariable [_ciudad,[],true];
            sleep 5;
            [] call A3A_fnc_tierCheck;
        };
    } forEach ciudades;
    
    if (_popCSAT > (_popTotal / 3)) then {
        ["destroyedCities",false,true] remoteExec ["BIS_fnc_endMission"];
    } else {
        if (_popCSAT > (_popTotal / 4)) then {
            ["TaskFailed", ["", format ["%1 are close to winning this war!", nameMuyMalos]]] remoteExec ["BIS_fnc_showNotification", buenos];
        };
    };

    if ((_popFIA > _popAAF) and ({lados getVariable [_x,sideUnknown] == buenos} count aeropuertos == count aeropuertos)) then {
        ["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0];
    };
    /*
    {
    _fabrica = _x;
    if (lados getVariable [_fabrica,sideUnknown] == buenos) then
        {
        if (not(_fabrica in destroyedCities)) then {_bonusFIA = _bonusFIA + 0.25};
        };
    } forEach fabricas;
    */
    {
        _recurso = _x;
        if (lados getVariable [_recurso, sideUnknown] == buenos and not(_recurso in destroyedCities)) then {
            _recAddSDK = _recAddSDK + (300 * _bonusFIA);
        };
    } forEach recursos;

    // Apply HR growth scaling, faster below 5, slower above it.
    _hrAddBLUFOR = sqrt (5 * _hrAddBLUFOR);
    _hrAddBLUFOR = _hrAddBLUFOR;

    // Cap total HR at support * 0.1
    private _hr = server getVariable "hr";
    private _hrCap = ceil(_popFIA * 0.1);
    _hrAddBLUFOR = 0 max (_hrAddBLUFOR min (_hrCap - _hr));
    private _new_hr = _hr + _hrAddBLUFOR;
    server setVariable ["hr",_new_hr,true];
    server setVariable ["hrCap",_hrCap,true];
    
    // Apply resource increase
    _recAddSDK = ceil _recAddSDK;
    private _rec = server getVariable "resourcesFIA";
    _rec =  _rec + _recAddSDK;
    server setVariable ["resourcesFIA",_rec,true];

    private _hrString = if (_new_hr >= _hrCap) then { "Full" } else { floor(_new_hr - _hr) };
    _texto = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €",_hrString,_recAddSDK];
    
    [] call A3A_fnc_FIAradio;
    //_updated = false;
    _updated = [] call A3A_fnc_arsenalManage;
    if (_updated != "") then {_texto = format ["%1<br/>Arsenal Updated<br/><br/>%2",_texto,_updated]};
    [petros,"taxRep",_texto] remoteExec ["A3A_fnc_commsMP",[buenos,civilian]];

    bombRuns = bombRuns + (({lados getVariable [_x,sideUnknown] == buenos} count aeropuertos) * 0.25);
    [petros,"taxRep",_texto] remoteExec ["A3A_fnc_commsMP",[buenos,civilian]];
    [] call A3A_fnc_economicsAI;
    if (isMultiplayer) then {
        [] spawn A3A_fnc_assigntheBoss;
        difficultyCoef = floor ((({side group _x == buenos} count playableUnits) - ({side group _x != buenos} count playableUnits)) / 5);
        publicVariable "difficultyCoef";
    };

    // TODO: improve auto mission creation
    if ((!bigAttackInProgress) and (random 100 < 25)) then {[] call A3A_fnc_missionRequestAUTO};

    [[],"A3A_fnc_reinforcementsAI"] call A3A_fnc_scheduler;
    {
        _veh = _x;
        if ((_veh isKindOf "StaticWeapon") and ({isPlayer _x} count crew _veh == 0) and (alive _veh)) then {
            _veh setDamage 0;
            [_veh,1] remoteExec ["setVehicleAmmoDef",_veh];
        };
    } forEach vehicles;

    cuentaCA = 0 max (cuentaCA - 600); publicVariable "cuentaCA";
    timeSinceLastAttack = timeSinceLastAttack + 600; publicVariable "timeSinceLastAttack";
    
    if (cuentaCA == 0 /* and (diag_fps > minimoFPS)*/) then {
        diag_log format ["[resourceCheck] Spawning big attack"];
        timeSinceLastAttack = 0; publicVariable "timeSinceLastAttack";
        [1200, 600, "Spawning big attack"] remoteExec ["A3A_fnc_timingCA", 2];
        if (!bigAttackInProgress) then {
            _script = [] spawn A3A_fnc_ataqueAAF;
            waitUntil {sleep 5; scriptDone _script};
        };
        cuentaCANonBuenos = cuentaCANonBuenos + 1200 + random(1200); publicVariable "cuentaCANonBuenos";
    };
    cuentaCANonBuenos = 0 max (cuentaCANonBuenos - 600); publicVariable "cuentaCANonBuenos";

    if (cuentaCANonBuenos == 0) then {
        diag_log format ["[resourceCheck] Spawning big NATO vs CSAT attack"];
        if (!bigAttackInProgress) then {
            _script = [true] spawn A3A_fnc_ataqueAAF;
            waitUntil {sleep 5; scriptDone _script};
        };
        cuentaCANonBuenos = cuentaCANonBuenos + 1800 + random(1800); publicVariable "cuentaCANonBuenos";
    };

    diag_log format ["[resourceCheck] cuentaCA: %1, timeSinceLastAttack: %2, cuentaCANonBuenos: %3", cuentaCA, timeSinceLastAttack, cuentaCANonBuenos];

    sleep 3;
    if ((count antenasMuertas > 0) and (not(["REP"] call BIS_fnc_taskExists))) then {
        _posibles = [];
        {
            _marcador = [marcadores, _x] call BIS_fnc_nearestPosition;
            if ((lados getVariable [_marcador,sideUnknown] == malos) and (spawner getVariable _marcador == 2)) exitWith {
                _posibles pushBack [_marcador,_x];
            };
        } forEach antenasMuertas;
        if (count _posibles > 0) then {
            _posible = selectRandom _posibles;
            [[_posible select 0,_posible select 1],"REP_Antena"] call A3A_fnc_scheduler;
        };
    } else {
        _cambiado = false;
        {
            _chance = 5;
            if ((_x in recursos) and (lados getVariable [_x,sideUnknown] == muyMalos)) then {_chance = 20};
            if (random 100 < _chance) then {
                _cambiado = true;
                destroyedCities = destroyedCities - [_x];
                _nombre = [_x] call A3A_fnc_localizar;
                ["TaskSucceeded", ["", format ["%1 Rebuilt",_nombre]]] remoteExec ["BIS_fnc_showNotification",[buenos,civilian]];
                sleep 2;
            };
        } forEach (destroyedCities - ciudades) select {lados getVariable [_x,sideUnknown] != buenos};

        if (_cambiado) then {publicVariable "destroyedCities"};
    };
    if (isDedicated) then {
        {
            if (side _x == civilian) then {
                _var = _x getVariable "statusAct";
                if (isNil "_var") then {
                    if (local _x) then {
                        if ((typeOf _x) in arrayCivs) then {
                            if (vehicle _x == _x) then {
                                if (primaryWeapon _x == "") then {
                                    _grupo = group _x;
                                    deleteVehicle _x;
                                    if ({alive _x} count units _grupo == 0) then {deleteGroup _grupo};
                                };
                            };
                        };
                    };
                };
            };
        } forEach allUnits;

        if (autoSave) then {
            // TODO: make autosave time flexible
            _cuentaSave = _cuentaSave - 600;
            if (_cuentaSave <= 0) then {
                _cuentaSave = 3600;
                _nul = [] execVM "statSave\saveLoop.sqf";
            };
        };
    };
    sleep 4;
};