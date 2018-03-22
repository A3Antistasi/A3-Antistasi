_marcador = [marcadores,player] call BIS_fnc_nearestPosition;

_lado = side player;

if (((_lado == malos) and (not(lados getVariable [_marcador,sideUnknown] == malos))) or ((_lado == muyMalos) and (not(lados getVariable [_marcador,sideUnknown] == muyMalos)))) exitWith {hint "You need to be close to an Airbase, Seaport or Outpost of your side in order to request a bike"};
if ((!(_marcador in aeropuertos)) and (!(_marcador in puertos)) and (!(_marcador in puestos))) exitWith {hint "You need to be close to an Airbase, Seaport or Outpost of your side in order to request a bike"};
if (not(player inArea _marcador)) exitWith {hint "You need to be close to an Airbase, Seaport or Outpost in order to request a bike"};

_tipoBike = if (_lado == malos) then {vehNATOBike} else {vehCSATBike};

if (!isNull moto) then
	{
	if (moto distance player < 100) then {deleteVehicle moto};
	};

hint "Quadbike available";
moto = createVehicle [_tipoBike, position player, [], 10, "NONE"];

[moto] call AIVEHinit;