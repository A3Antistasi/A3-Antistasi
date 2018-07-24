//usage: place on the map markers covering the areas where you want the AAF operate, and put names depending on if they are powerplants,resources, bases etc.. The marker must cover the whole operative area, it's buildings etc.. (for example in an airport, you must cover more than just the runway, you have to cover the service buildings etc..)
//markers cannot have more than 500 mts size on any side or you may find "insta spawn in your nose" effects.
//do not do it on cities and hills, as the mission will do it automatically
//the naming convention must be as the following arrays, for example: first power plant is "power", second is "power_1" thir is "power_2" after you finish with whatever number.
//to test automatic zone creation, init the mission with debug = true in init.sqf
//of course all the editor placed objects (petros, flag, respawn marker etc..) have to be ported to the new island
//deletion of a marker in the array will require deletion of the corresponding marker in the editor
//only touch the commented arrays

forcedSpawn = [];
ciudades = [];
if (worldName == "Tanoa") then
    {
    aeropuertos = ["airport","airport_1","airport_2","airport_3","airport_4"];//airports
    spawnPoints = ["spawnPoint","spawnPoint_1","spawnPoint_2","spawnPoint_3","spawnPoint_4"];
    recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"];//economic resources
    fabricas = ["factory","factory_1","factory_2","factory_3","factory_4"];//factories
    puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13","puesto_14"];//any small zone with mil buildings
    puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4","puerto_5"];//seaports, adding a lot will affect economics, 5 is ok
    controles = ["control","control_1","control_2","control_3","control_4","control_5","control_6","control_7","control_8","control_9","control_10","control_11","control_12","control_13","control_14","control_15","control_16","control_17","control_18","control_19","control_20","control_21","control_22","control_23","control_24","control_25","control_26","control_27","control_28","control_29","control_30","control_31","control_32","control_33","control_34","control_35","control_36","control_37","control_38","control_39","control_40","control_41","control_42","control_43","control_44","control_45","control_46","control_47","control_48","control_49","control_50","control_51"];//use this for points where you want a roadblock (logic/strategic points, such as crossroads, airport or bases entrances etc..) game will add some more automatically
    seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21"];
    seaSpawn = ["seaSpawn","seaSpawn_1","seaSpawn_2","seaSpawn_3","seaSpawn_4","seaSpawn_5","seaSpawn_6","seaSpawn_7","seaSpawn_8","seaSpawn_9","seaSpawn_10","seaSpawn_11","seaSpawn_12","seaSpawn_13","seaSpawn_14","seaSpawn_15","seaSpawn_16","seaSpawn_17","seaSpawn_18","seaSpawn_19","seaSpawn_20","seaSpawn_21","seaSpawn_22","seaSpawn_23","seaSpawn_24","seaSpawn_25","seaSpawn_26","seaSpawn_27","seaSpawn_28","seaSpawn_29","seaSpawn_30","seaSpawn_31","seaSpawn_32"];
    seaAttackSpawn = ["seaAttackSpawn","seaAttackSpawn_1","seaAttackSpawn_2","seaAttackSpawn_3","seaAttackSpawn_4","seaAttackSpawn_5","seaAttackSpawn_6","seaAttackSpawn_7","seaAttackSpawn_8","seaAttackSpawn_9","seaAttackSpawn_10"];
    }
else
    {
    if (worldName == "Altis") then
        {
        aeropuertos = ["airport","airport_1","airport_2","airport_3","airport_4","airport_5"];//airports
        spawnPoints = ["spawnPoint","spawnPoint_1","spawnPoint_2","spawnPoint_3","spawnPoint_4","spawnPoint_5"];
        recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"];//economic resources
        fabricas = ["factory","factory_1","factory_2","factory_3","factory_4","factory_5","factory_6","factory_7","factory_8","factory_9","factory_10","factory_11"];//factories
        puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13","puesto_14","puesto_15","puesto_16","puesto_17","puesto_18","puesto_19","puesto_20","puesto_21","puesto_22","puesto_23","puesto_24","puesto_25","puesto_26","puesto_27","puesto_28","puesto_29","puesto_30","puesto_31","puesto_32","puesto_33","puesto_34","puesto_35","puesto_36","puesto_37","puesto_38","puesto_39","puesto_40","puesto_41","puesto_42"];
        puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4"];//seaports, adding a lot will affect economics, 5 is ok
        controles = ["control","control_1","control_2","control_3","control_4","control_5","control_6","control_7","control_8","control_9","control_10","control_11","control_12","control_13","control_14","control_15","control_16","control_17","control_18","control_19","control_20","control_21","control_22","control_23","control_24","control_25","control_26","control_27","control_28","control_29","control_30","control_31","control_32","control_33","control_34","control_35","control_36","control_37","control_38","control_39","control_40","control_41","control_42","control_43","control_44","control_45","control_46","control_47","control_48","control_49","control_50","control_51","control_52","control_53","control_54","control_55","control_56","control_57","control_58"];//use this for points where you want a roadblock (logic/strategic points, such as crossroads, airport or bases entrances etc..) game will add some more automatically
        seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21","seaPatrol_22","seaPatrol_23","seaPatrol_24","seaPatrol_25","seaPatrol_26","seaPatrol_27"];
        seaSpawn = ["seaSpawn","seaSpawn_1","seaSpawn_2","seaSpawn_3","seaSpawn_4","seaSpawn_5","seaSpawn_6","seaSpawn_7","seaSpawn_8","seaSpawn_9"];
        seaAttackSpawn = ["seaAttackSpawn","seaAttackSpawn_1","seaAttackSpawn_2","seaAttackSpawn_3","seaAttackSpawn_4","seaAttackSpawn_5","seaAttackSpawn_6"];
        {
        _name = text _x;
        if ((_name != "Magos") AND !(_name == "")) then {
            _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
            _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
            _size = if (_sizeX > _sizeY) then {_sizeX} else {_sizeY};
            _pos = getPos _x;
            if (_size < 10) then {_size = 50};

            _mrk = createmarker [format ["%1", _name], _pos];
            _mrk setMarkerSize [_size, _size];
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "SOLID";
            _mrk setMarkerColor "ColorRed";
            _mrk setMarkerText _name;
            controles pushBack _name;
        };
        } foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["Hill"], worldSize/1.414]);
        }
    else
        {
        if (worldName == "Staszow") then
            {
            aeropuertos = ["airport","airport_1","airport_2"];
            spawnPoints = ["spawnPoint","spawnPoint_1","spawnPoint_2"];
            recursos = ["resource"];
            fabricas = ["factory"];
            puestos = ["puesto"];
            puertos = [];
            controles = ["control"];
            seaMarkers = [];
            seaSpawn = [];
            seaAttackSpawn = [];
            };
        };
    };

defaultControlIndex = (count controles) - 1;
puestosFIA = [];
_mrkSDK = ["Synd_HQ"];
garrison setVariable ["Synd_HQ",[],true];
_mrkNATO = [];
_mrkCSAT = [];

if (worldName == "Tanoa") then
    {
    _mrkCSAT = ["airport_1","puerto_5","puesto_10","control_20"]
    }
else
    {
    if (worldName == "Altis") then
        {
        _mrkCSAT = ["airport_2","puerto_4","puesto_5","control_52","control_33"];
        }
    else
        {
        if (worldName == "Staszow") then {_mrkCSAT = ["airport"]};
        };
    };

destroyedCities = [];

marcadores = aeropuertos + recursos + fabricas + puestos + puertos + controles + ["Synd_HQ"];
{_x setMarkerAlpha 0;
spawner setVariable [_x,2,true];
} forEach marcadores;
{_x setMarkerAlpha 0} forEach (seaMarkers + seaSpawn + seaAttackSpawn + spawnPoints);
private ["_sizeX","_sizeY","_size"];
{
//_nombre = text _x;
_nombre = [text _x, true] call fn_location;
if ((_nombre != "") and (_nombre != "Lakatoro01") and (_nombre != "Galili01") and (_nombre != "Sosovu01") and (_nombre != "Ipota01") and (_nombre != "hill12")) then//sagonisi is blacklisted in Altis for some reason. If your island has a city in a small island you should blacklist it (road patrols will try to reach it)
    {
    _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
    _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
    if (_sizeX > _sizeY) then {_size = _sizeX} else {_size = _sizeY};
    _pos = getPos _x;
    if (_size < 200) then {_size = 400};
    _roads = [];
    _numCiv = 0;
    if ((worldName != "Tanoa") and (worldName != "Altis")) then//If Tanoa, data is picked from a DB in initVar.sqf, if not, is built on the fly.
        {
        _numCiv = (count (nearestObjects [_pos, ["house"], _size]));
        _roadsProv = _pos nearRoads _size;
        //_roads = [];
        {
        _roadcon = roadsConnectedto _x;
        if (count _roadcon == 2) then
            {
            _roads pushBack (getPosATL _x);
            };
        } forEach _roadsProv;
        carreteras setVariable [_nombre,_roads];
        }
    else
        {
        _roads = carreteras getVariable _nombre;
        _numCiv = server getVariable _nombre;
        if (isNil "_numCiv") then {hint format ["A mi no me sale en %1",_nombre]};
        if (typeName _numCiv != typeName 0) then {hint format ["Datos erróneos en %1. Son del tipo %2",_nombre, typeName _numCiv]};
        //if (isNil "_roads") then {hint format ["A mi no me sale en %1",_nombre]};
        };
    _numVeh = round (_numCiv / 3);
    _nroads = count _roads;
    _nearRoadsFinalSorted = [_roads, [], { _pos distance _x }, "ASCEND"] call BIS_fnc_sortBy;
    _pos = _nearRoadsFinalSorted select 0;
    if (isNil "_pos") then {diag_log format ["Falla %1",_nombre]};
    _mrk = createmarker [format ["%1", _nombre], _pos];
    _mrk setMarkerSize [_size, _size];
    _mrk setMarkerShape "RECTANGLE";
    _mrk setMarkerBrush "SOLID";
    _mrk setMarkerColor colorMalos;
    _mrk setMarkerText _nombre;
    _mrk setMarkerAlpha 0;
    ciudades pushBack _nombre;
    spawner setVariable [_nombre,2,true];
    _dmrk = createMarker [format ["Dum%1",_nombre], _pos];
    _dmrk setMarkerShape "ICON";
    _dmrk setMarkerType "loc_Ruin";
    _dmrk setMarkerColor colorMalos;
    if (_nroads < _numVeh) then {_numVeh = _nroads};

    _info = [_numCiv, _numVeh, prestigeOPFOR,prestigeBLUFOR];
    server setVariable [_nombre,_info,true];

    //_nul = [_nombre] call crearControles;
    };
}foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCityCapital","NameCity","NameVillage","CityCenter"], 25000]);

marcadores = marcadores + ciudades;
//esto de abajo hay que hacerlo con foreach particulares sin if, en lugar de un foreach general
{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_dmrk setMarkerColor colorMalos;

//garrison setVariable [_x,0,true];

_garrNum = [_x] call garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
if (_x in aeropuertos) then
    {
    killZones setVariable [_x,[],true];
    if (_x in _mrkCSAT) then
        {
        _dmrk setMarkerType flagCSATmrk;
        _dmrk setMarkerText format ["%1 Airbase",nameMuyMalos];
        _dmrk setMarkerColor colorMuyMalos;
        for "_i" from 1 to _garrNum do
            {
            _garrison append (selectRandom gruposCSATSquad);
            };
        garrison setVariable [_x,_garrison,true];
        _nul = [_x] call crearControles;
        }
    else
        {
        _dmrk setMarkerType flagNATOmrk;
        _dmrk setMarkerText format ["%1 Airbase",nameMalos];
        for "_i" from 1 to _garrNum do
            {
            _garrison append (selectRandom gruposNATOSquad);
            };
        garrison setVariable [_x,_garrison,true];
        _nul = [_x] call crearControles;
        };
    server setVariable [_x,0,true];//fecha en fomrato dateToNumber en la que estarán idle
    }
else
    {
    if (_x in recursos) then
        {
        _dmrk setMarkerType "loc_rock";
        _dmrk setMarkerText "Resources";
        for "_i" from 1 to _garrNum do
            {
            _garrison append (selectRandom gruposFIASquad);
            };
        garrison setVariable [_x,_garrison,true];
        _nul = [_x] call crearControles;
        }
    else
        {
        if (_x in fabricas) then
            {
            _dmrk setMarkerType "u_installation";
            _dmrk setMarkerText "Factory";
            for "_i" from 1 to _garrNum do
                {
                _garrison append (selectRandom gruposFIASquad);
                };
            garrison setVariable [_x,_garrison,true];
            _nul = [_x] call crearControles;
            }
        else
            {
            if (_x in puestos) then
                {
                killZones setVariable [_x,[],true];
                _dmrk setMarkerType "loc_bunker";
                if !(_x in _mrkCSAT) then
                    {
                    _dmrk setMarkerText format ["%1 Outpost",nameMalos];
                    for "_i" from 1 to _garrNum do
                        {
                        _garrison append (selectRandom gruposFIASquad);
                        };
                    garrison setVariable [_x,_garrison,true];
                    server setVariable [_x,0,true];
                    }
                else
                    {
                    _dmrk setMarkerText format ["%1 Outpost",nameMuyMalos];
                    _dmrk setMarkerColor colorMuyMalos;
                    for "_i" from 1 to _garrNum do
                        {
                        _garrison append (selectRandom gruposCSATSquad);
                        };
                    garrison setVariable [_x,_garrison,true];
                    server setVariable [_x,0,true];
                    };
                _nul = [_x] call crearControles;
                }
            else
                {
                _dmrk setMarkerType "b_naval";
                _dmrk setMarkerText "Sea Port";
                if (_x in _mrkCSAT) then
                    {
                    _dmrk setMarkerColor colorMuyMalos;
                    for "_i" from 1 to _garrNum + 1 do
                        {
                        _garrison append (selectRandom gruposCSATSquad);
                        };
                    garrison setVariable [_x,_garrison,true];
                    }
                else
                    {
                    for "_i" from 1 to _garrNum do
                        {
                        _garrison append (selectRandom gruposNATOSquad);
                        };
                    garrison setVariable [_x,_garrison,true];
                    };
                _nul = [_x] call crearControles;
                };
            };
        };
    };
} forEach marcadores - ciudades - controles - ["Synd_HQ"];

_mrkNATO = marcadores - _mrkCSAT - ["Synd_HQ"];

antenasmuertas = [];
bancos = [];

_posAntenas = [];
_posBancos = [];
_blacklistPos = [];
mrkAntenas = [];
if (worldName == "Tanoa") then
    {
    _posAntenas = [[6617.95,7853.57,0.200073],[7486.67,9651.9,1.52588e-005],[6005.47,10420.9,0.20298],[2437.25,7224.06,0.0264893],[4701.6,3165.23,0.0633469],[11008.8,4211.16,-0.00154114],[10114.3,11743.1,9.15527e-005],[10949.8,11517.3,0.14209],[11153.3,11435.2,0.210876],[12889.2,8578.86,0.228729],[2682.94,2592.64,-0.000686646],[2690.54,12323,0.0372467],[2965.33,13087.1,0.191544],[13775.8,10976.8,0.170441]];
    _blacklistPos = [8,12];
    _posbancos = [[5893.41,10253.1,-0.687263],[9507.5,13572.9,0.133848]];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
    antenas = [antena];
    _posAntenas pushBack (getPos antena);
    }
else
    {
    if (worldName == "Altis") then
        {
        _posAntenas = [[14451.5,16338,0.000354767],[15346.7,15894,-3.8147e-005],[16085.1,16998,7.08781],[17856.7,11734.1,0.863045],[9496.2,19318.5,0.601898],[9222.87,19249.1,0.0348206],[20944.9,19280.9,0.201118],[20642.7,20107.7,0.236603],[18709.3,10222.5,0.716034],[6840.97,16163.4,0.0137177],[19319.8,9717.04,0.215622],[19351.9,9693.04,0.639175],[10316.6,8703.94,0.0508652],[8268.76,10051.6,0.0100708],[4583.61,15401.1,0.262543],[4555.65,15383.2,0.0271606],[4263.82,20664.1,-0.0102234],[26274.6,22188.1,0.0139847],[26455.4,22166.3,0.0223694]];
        _blacklistPos = [1,4,7,8,9,10,12,15,17];
        _posBancos = [[16586.6,12834.5,-0.638584],[16545.8,12784.5,-0.485485],[16633.3,12807,-0.635017],[3717.34,13391.2,-0.164862],[3692.49,13158.3,-0.0462074],[3664.31,12826.5,-0.379545],[3536.99,13006.6,-0.508585],[3266.42,12969.9,-0.549738]];
        antenas = [];
        }
    else
        {
        antenas = nearestObjects [[worldSize /2,worldSize/2,0],["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], worldSize];
        bancos = nearestObjects [[worldSize /2,worldSize/2,0],["Land_Offices_01_V1_F"],worldSize];
        {
        _mrkfin = createMarker [format ["Ant%1", _x], position _x];
        _mrkfin setMarkerShape "ICON";
        _mrkfin setMarkerType "loc_Transmitter";
        _mrkfin setMarkerColor "ColorBlack";
        _mrkfin setMarkerText "Radio Tower";
        mrkAntenas pushBack _mrkfin;
        _x addEventHandler ["Killed",
            {
            _antena = _this select 0;
            {if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,false] spawn apagon}} forEach ciudades;
            _mrk = [mrkAntenas, _antena] call BIS_fnc_nearestPosition;
            antenas = antenas - [_antena]; antenasmuertas pushBack (getPos _antena); deleteMarker _mrk;
            publicVariable "antenas"; publicVariable "antenasMuertas";
            ["TaskSucceeded",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",buenos];
            ["TaskFailed",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",malos];
            }
            ];
        } forEach antenas;
        };
    };

if (count _posAntenas > 0) then
    {
    for "_i" from 0 to (count _posAntenas - 1) do
        {
        _antenaProv = nearestObjects [_posAntenas select _i,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], 25];
        if (count _antenaProv > 0) then
            {
            _antena = _antenaProv select 0;
            if (_i in _blacklistPos) then
                {
                _antena setdamage 1;
                }
            else
                {
                antenas pushBack _antena;
                _mrkfin = createMarker [format ["Ant%1", _i], _posantenas select _i];
                _mrkfin setMarkerShape "ICON";
                _mrkfin setMarkerType "loc_Transmitter";
                _mrkfin setMarkerColor "ColorBlack";
                _mrkfin setMarkerText "Radio Tower";
                mrkAntenas pushBack _mrkfin;
                _antena addEventHandler ["Killed",
                    {
                    _antena = _this select 0;
                    {if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,false] spawn apagon}} forEach ciudades;
                    _mrk = [mrkAntenas, _antena] call BIS_fnc_nearestPosition;
                    antenas = antenas - [_antena]; antenasmuertas pushBack (getPos _antena); deleteMarker _mrk;
                    publicVariable "antenas"; publicVariable "antenasMuertas";
                    ["TaskSucceeded",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",buenos];
                    ["TaskFailed",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",malos];
                    }
                ];
                };
            };
        };
    };

if (count _posBancos > 0) then
    {
    for "_i" from 0 to (count _posBancos - 1) do
        {
        _bancoProv = nearestObjects [_posbancos select _i,["Land_Offices_01_V1_F"], 25];
        if (count _bancoProv > 0) then
            {
            _banco = _bancoProv select 0;
            bancos = bancos + [_banco];
            };
        };
    };

if (worldName == "Tanoa") then
    {
    carreteras setVariable ["airport",[[[6988.38,7135.59,10.0673],17.0361,"MG"],[[6873.83,7472,3.19066],262.634,"MG"],[[6902.09,7427.71,13.0559],359.999,"MG"],[[6886.75,7445.52,0.0368803],360,"Mort"],[[6888.47,7440.31,0.0368826],0.000531628,"Mort"],[[6882.14,7445.42,0.0368817],360,"Mort"],[[6886.49,7436.58,0.0368807],360,"Mort"],[[6970.32,7188.49,-0.0339937],359.999,"Tank"],[[6960.98,7188.49,-0.0339937],359.999,"Tank"],[[6950.71,7187.42,-0.033505],359.999,"Tank"]],true];

    carreteras setVariable ["airport_1",[[[2175.14,13402.4,-0.01863],138.861,"Tank"],[[2183.31,13409.7,-0.0184679],139.687,"Tank"],[[2211.39,13434.4,0.0164337],141.512,"Tank"],[[2221.62,13440.6,0.016408],142.886,"Tank"],[[2221.31,13195,0.0368757],0.000337857,"Mort"],[[2224.09,13197.6,0.038271],1.30051e-005,"Mort"],[[2218.96,13199.1,0.0382385],0.00923795,"Mort"],[[2071.1,13308.5,14.4943],133.738,"MG"]],true];

    carreteras setVariable ["airport_2",[[[11803,13051.6,0.0368805],360,"Mort"],[[11813.5,13049.2,0.0368915],0.000145629,"Mort"],[[11799.5,13043.2,0.0368919],360,"Mort"],[[11723.3,13114.6,18.1545],300.703,"MG"],[[11782.3,13058.1,0.0307827],19.6564,"Tank"],[[11810.6,13040.2,0.0368905],360,"Tank"],[[11832.9,13042.1,0.0283785],16.3683,"Tank"]],true];
    carreteras setVariable ["airport_3",[[[11658,3055.02,0.036881],360,"Mort"],[[11662.6,3060.14,0.0368819],0.000294881,"Mort"],[[11664.8,3049.94,0.0368805],360,"Mort"],[[11668.9,3055.64,0.0368805],2.08056e-005,"Mort"],[[11747.8,2982.95,18.1513],249.505,"MG"],[[11784.1,3132.77,0.183631],214.7,"Tank"],[[11720.3,3176.15,0.112019],215.055,"Tank"]],true];
    carreteras setVariable ["airport_4",[[[2092.87,3412.98,0.0372648],0.00414928,"Mort"],[[2091.5,3420.69,0.0369596],360,"Mort"],[[2099.93,3422.53,0.0373936],0.00215797,"Mort"],[[2100.13,3416.28,0.0394554],0.0043371,"Mort"],[[2198.24,3471.03,18.0123],0.00187816,"MG"],[[2133.01,3405.88,-0.0156536],315.528,"Tank"],[[2145.82,3416.83,-0.00544548],316.441,"Tank"],[[2163.9,3432.18,-0.0256157],318.777,"Tank"]],true];
    }
else
    {
    if (worldName == "Altis") then
        {
        carreteras setVariable ["airport",[[[21175.06,7369.336,0],62.362,"Tank"],[[21178.89,7361.573,0.421],62.36,"Tank"],[[20961.332,7295.678,0],0,"Mort"],[[20956.143,7295.142,0],0,"Mort"],[[20961.1,7290.02,0.262632],0,"Mort"]],true];
        carreteras setVariable ["airport_1",[[[23044.8,18745.7,0.0810001],88.275,"Tank"],[[23046.8,18756.8,0.0807302],88.275,"Tank"],[[23214.8,18859.5,0],267.943,"Tank"],[[22981.2,18903.9,0],0,"Mort"],[[22980.1,18907.5,0.553066],0,"Mort"]],true];
        carreteras setVariable ["airport_2",[[[26803.1,24727.7,0.0629988],359.958,"Mort"],[[26809,24728.2,0.03755],359.986,"Mort"],[[26815.2,24729,0.0384922],359.972,"Mort"],[[26821.3,24729.1,0.0407047],359.965,"Mort"],[[26769.1,24638.7,0.290344],131.324,"Tank"],[[26774.2,24643.9,0.282555],134.931,"Tank"]],true];
        carreteras setVariable ["airport_3",[[[14414.9,16327.8,-0.000991821],207.397,"Tank"],[[14471.9,16383.2,0.0378571],359.939,"Mort"],[[14443,16379.2,0.0369205],359.997,"Mort"],[[14449.4,16376.9,0.0369892],359.996,"Mort"],[[14458,16375.9,0.0369167],359.997,"Mort"],[[14447.2,16397.1,3.71081],269.525,"MG"],[[14472.3,16312,12.1993],317.315,"MG"],[[14411,16229,0.000303268],40.6607,"Tank"],[[14404.4,16235,-0.0169964],50.5741,"Tank"],[[14407.2,16331.7,0.0305004],204.588,"Tank"]],true];
        carreteras setVariable ["airport_4",[[[11577.4,11953.6,0.241838],122.274,"Tank"],[[11577.8,11964.3,0.258125],124.324,"Tank"],[[11633.3,11762,0.0372791],359.996,"Mort"],[[11637.3,11768.1,0.043232],0.0110098,"Mort"],[[11637.1,11763.1,0.0394402],0.00529677,"Mort"]],true];
        carreteras setVariable ["airport_5",[[[9064.02,21531.3,0.00117016],138.075,"Tank"],[[9095.12,21552.8,0.614614],157.935,"Tank"],[[9030.28,21531.1,0.261349],157.935,"Mort"],[[9033.91,21534.7,0.295588],157.935,"Mort"]],true];
        };
    };

{lados setVariable [_x,buenos,true]} forEach _mrkSDK;
{lados setVariable [_x,malos,true]} forEach _mrkNATO;
{lados setVariable [_x,muyMalos,true]} forEach _mrkCSAT;
lados setVariable ["NATO_carrier",malos,true];
lados setVariable ["CSAT_carrier",muyMalos,true];

blackListDest = (marcadores - controles - ["Synd_HQ"] - ciudades) select {!((position ([getMarkerPos _x] call findNearestGoodRoad)) inArea _x)};

publicVariable "blackListDest";
//the following is the console code snippet I use to pick positions of any kind of building. You may do this for gas stations, banks, radios etc.. markerPos "Base_4" is because it's in the middle of the island, and inside the array you may find the type of building I am searching for. Paste the result in a txt and add it to the corresponding arrays.
/*
pepe = nearestObjects [markerPos "base_4", ["Land_Communication_F","Land_TTowerBig_1_F","Land_TTowerBig_2_F"], 16000];
pospepe = [];
{pospepe = pospepe + getPos _x} forEach pepe;
copytoclipboard str pospepe;
*/
if (isMultiplayer) then {[[petros,"hint","Zones Init Completed"],"commsMP"] call BIS_fnc_MP};
publicVariable "marcadores";
publicVariable "ciudades";
publicVariable "aeropuertos";
publicVariable "recursos";
publicVariable "fabricas";
publicVariable "puestos";
publicVariable "controles";
publicVariable "puertos";
publicVariable "destroyedCities";
publicVariable "forcedSpawn";
publicVariable "puestosFIA";
publicVariable "seaMarkers";
publicVariable "spawnPoints";
publicVariable "antenas";
publicVariable "antenasMuertas";
publicVariable "mrkAntenas";
publicVariable "bancos";
publicVariable "seaSpawn";
publicVariable "seaAttackSpawn";
publicVariable "defaultControlIndex";