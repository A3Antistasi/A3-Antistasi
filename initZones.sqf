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
aeropuertos = ["airport","airport_1","airport_2","airport_3","airport_4"];//airports
spawnPoints = ["spawnPoint","spawnPoint_1","spawnPoint_2","spawnPoint_3","spawnPoint_4"];
recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"];//economic resources
fabricas = ["factory","factory_1","factory_2","factory_3","factory_4"];//factories
puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13"];//any small zone with mil buildings
puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4","puerto_5"];//seaports, adding a lot will affect economics, 5 is ok
controles = ["control","control_1","control_2","control_3","control_4","control_5","control_6","control_7","control_8","control_9","control_10","control_11","control_12","control_13","control_14","control_15","control_16","control_17","control_18","control_19","control_20","control_21","control_22","control_23","control_24","control_25","control_26","control_27","control_28","control_29","control_30","control_31","control_32","control_33","control_34","control_35","control_36","control_37","control_38","control_39","control_40","control_41","control_42","control_43","control_44","control_45","control_46","control_47","control_48","control_49","control_50","control_51"];//use this for points where you want a roadblock (logic/strategic points, such as crossroads, airport or bases entrances etc..) game will add some more automatically
seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21"];
seaSpawn = ["seaSpawn","seaSpawn_1","seaSpawn_2","seaSpawn_3","seaSpawn_4","seaSpawn_5","seaSpawn_6","seaSpawn_7","seaSpawn_8","seaSpawn_9","seaSpawn_10","seaSpawn_11","seaSpawn_12","seaSpawn_13","seaSpawn_14","seaSpawn_15","seaSpawn_16","seaSpawn_17","seaSpawn_18","seaSpawn_19","seaSpawn_20","seaSpawn_21","seaSpawn_22","seaSpawn_23","seaSpawn_24","seaSpawn_25","seaSpawn_26","seaSpawn_27","seaSpawn_28","seaSpawn_29","seaSpawn_30","seaSpawn_31","seaSpawn_32"];
seaAttackSpawn = ["seaAttackSpawn","seaAttackSpawn_1","seaAttackSpawn_2","seaAttackSpawn_3","seaAttackSpawn_4","seaAttackSpawn_5","seaAttackSpawn_6","seaAttackSpawn_7","seaAttackSpawn_8","seaAttackSpawn_9","seaAttackSpawn_10"];
puestosFIA = [];
mrkSDK = ["Synd_HQ"];
garrison setVariable ["Synd_HQ",[],true];
mrkNATO = [];
mrkCSAT = ["airport_1","puerto_5","puesto_10","control_20"];//
destroyedCities = [];

marcadores = aeropuertos + recursos + fabricas + puestos + puertos + controles + ["Synd_HQ"];
{_x setMarkerAlpha 0;
spawner setVariable [_x,2,true];
} forEach marcadores;
{_x setMarkerAlpha 0} forEach (seaMarkers + seaSpawn + seaAttackSpawn);
private ["_sizeX","_sizeY","_size"];
{
//_nombre = text _x;
_nombre = [text _x, true] call fn_location;
if ((_nombre != "") and (_nombre != "Lakatoro01") and (_nombre != "Galili01") and (_nombre != "Sosovu01") and (_nombre != "Ipota01")) then//sagonisi is blacklisted in Altis for some reason. If your island has a city in a small island you should blacklist it (road patrols will try to reach it)
    {
    _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
    _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
    if (_sizeX > _sizeY) then {_size = _sizeX} else {_size = _sizeY};
    _pos = getPos _x;
    if (_size < 200) then {_size = 400};
    _roads = [];
    _numCiv = 0;
    if (worldName != "Tanoa") then//If Tanoa, data is picked from a DB in initVar.sqf, if not, is built on the fly.
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
    if (_x == "airport_1") then
        {
        _dmrk setMarkerType FLAGcsatMRK;
        _dmrk setMarkerText "CSAT Airbase";
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
        _dmrk setMarkerText "NATO Airbase";
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
            _garrison append (FIASquad);
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
                _garrison append (FIASquad);
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
                if (_x != "puesto_10") then
                    {
                    _dmrk setMarkerText "NATO Outpost";
                    for "_i" from 1 to _garrNum do
                        {
                        _garrison append (FIASquad);
                        };
                    garrison setVariable [_x,_garrison,true];
                    server setVariable [_x,0,true];
                    }
                else
                    {
                    _dmrk setMarkerText "CSAT Outpost";
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
                if (_x == "puerto_5") then
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

mrkNATO = marcadores - mrkCSAT - ["Synd_HQ"];

_posantenas = [[6617.95,7853.57,0.200073],[7486.67,9651.9,1.52588e-005],[6005.47,10420.9,0.20298],[2437.25,7224.06,0.0264893],[4701.6,3165.23,0.0633469],[11008.8,4211.16,-0.00154114],[10114.3,11743.1,9.15527e-005],[10949.8,11517.3,0.14209],[11153.3,11435.2,0.210876],[12889.2,8578.86,0.228729],[2682.94,2592.64,-0.000686646],[2690.54,12323,0.0372467],[2965.33,13087.1,0.191544],[13775.8,10976.8,0.170441]];
antenas = [antena];
mrkAntenas = [];

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
for "_i" from 0 to (count _posantenas - 1) do
    {
    _antenaProv = nearestObjects [_posantenas select _i,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], 25];
    if (count _antenaProv > 0) then
        {
        _antena = _antenaProv select 0;
        if ((_i == 8) or (_i == 12)) then
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
antenasmuertas = [];

_posbancos = [[5893.41,10253.1,-0.687263],[9507.5,13572.9,0.133848]];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
bancos = [];
for "_i" from 0 to (count _posbancos - 1) do
    {
    _bancoProv = nearestObjects [_posbancos select _i,["Land_Offices_01_V1_F"], 25];
    if (count _bancoProv > 0) then
        {
        _banco = _bancoProv select 0;
        bancos = bancos + [_banco];
        };
    };

carreteras setVariable ["airport",[[[6988.38,7135.59,10.0673],17.0361,"MG"],[[6873.83,7472,3.19066],262.634,"MG"],[[6902.09,7427.71,13.0559],359.999,"MG"],[[6886.75,7445.52,0.0368803],360,"Mort"],[[6888.47,7440.31,0.0368826],0.000531628,"Mort"],[[6882.14,7445.42,0.0368817],360,"Mort"],[[6886.49,7436.58,0.0368807],360,"Mort"],[[6970.32,7188.49,-0.0339937],359.999,"Tank"],[[6960.98,7188.49,-0.0339937],359.999,"Tank"],[[6950.71,7187.42,-0.033505],359.999,"Tank"]],true];

carreteras setVariable ["airport_1",[[[2175.14,13402.4,-0.01863],138.861,"Tank"],[[2183.31,13409.7,-0.0184679],139.687,"Tank"],[[2211.39,13434.4,0.0164337],141.512,"Tank"],[[2221.62,13440.6,0.016408],142.886,"Tank"],[[2221.31,13195,0.0368757],0.000337857,"Mort"],[[2224.09,13197.6,0.038271],1.30051e-005,"Mort"],[[2218.96,13199.1,0.0382385],0.00923795,"Mort"],[[2071.1,13308.5,14.4943],133.738,"MG"]],true];

carreteras setVariable ["airport_2",[[[11803,13051.6,0.0368805],360,"Mort"],[[11813.5,13049.2,0.0368915],0.000145629,"Mort"],[[11799.5,13043.2,0.0368919],360,"Mort"],[[11723.3,13114.6,18.1545],300.703,"MG"],[[11782.3,13058.1,0.0307827],19.6564,"Tank"],[[11810.6,13040.2,0.0368905],360,"Tank"],[[11832.9,13042.1,0.0283785],16.3683,"Tank"]],true];
carreteras setVariable ["airport_3",[[[11658,3055.02,0.036881],360,"Mort"],[[11662.6,3060.14,0.0368819],0.000294881,"Mort"],[[11664.8,3049.94,0.0368805],360,"Mort"],[[11668.9,3055.64,0.0368805],2.08056e-005,"Mort"],[[11747.8,2982.95,18.1513],249.505,"MG"],[[11784.1,3132.77,0.183631],214.7,"Tank"],[[11720.3,3176.15,0.112019],215.055,"Tank"]],true];
carreteras setVariable ["airport_4",[[[2092.87,3412.98,0.0372648],0.00414928,"Mort"],[[2091.5,3420.69,0.0369596],360,"Mort"],[[2099.93,3422.53,0.0373936],0.00215797,"Mort"],[[2100.13,3416.28,0.0394554],0.0043371,"Mort"],[[2198.24,3471.03,18.0123],0.00187816,"MG"],[[2133.01,3405.88,-0.0156536],315.528,"Tank"],[[2145.82,3416.83,-0.00544548],316.441,"Tank"],[[2163.9,3432.18,-0.0256157],318.777,"Tank"]],true];

{lados setVariable [_x,buenos,true]} forEach mrkSDK;
{lados setVariable [_x,malos,true]} forEach mrkNATO;
{lados setVariable [_x,muyMalos,true]} forEach mrkCSAT;
//the following is the console code snippet I use to pick positions of any kind of building. You may do this for gas stations, banks, radios etc.. markerPos "Base_4" is because it's in the middle of the island, and inside the array you may find the type of building I am searching for. Paste the result in a txt and add it to the corresponding arrays.
/*
pepe = nearestObjects [markerPos "base_4", ["Land_Communication_F","Land_TTowerBig_1_F","Land_TTowerBig_2_F"], 16000];
pospepe = [];
{pospepe = pospepe + getPos _x} forEach pepe;
copytoclipboard str pospepe;
*/
if (isMultiplayer) then {[[petros,"hint","Zones Init Completed"],"commsMP"] call BIS_fnc_MP};
publicVariable "mrkNATO";
publicVariable "mrkSDK";
publicVariable "mrkCSAT";
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