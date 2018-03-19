if (!isServer and hasInterface) exitWith{};

private ["_mrkOrigen","_pos","_lado","_cuenta","_mrkDestino","_veh","_posOrigen","_ladoMalos","_posDestino","_tipoVeh","_tipoMuni","_size","_vehicle","_vehCrew","_grupoVeh","_rondas","_objetivo","_objetivos","_tiempo"];

_mrkOrigen = _this select 0;
_lado = if (lados getVariable [_mrkOrigen,sideUnknown] == malos) then {malos} else {muyMalos};
_posOrigen = getMarkerPos _mrkOrigen;
_mrkDestino = _this select 1;
_ladoMalos = if (_lado == malos) then {muyMalos} else {malos};
_posDestino = getMarkerPos _mrkDestino;
_tipoVeh = if (_lado == malos) then {vehNATOMRLS} else {vehCSATMRLS};

if !([_tipoVeh] call vehAvailable) exitWith {};

_tipoMuni = if (_lado == malos) then {vehNATOMRLSMags} else {vehCSATMRLSMags};
_size = [_mrkOrigen] call sizeMarker;

_pos = [_posOrigen, 50, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
//_pos = _posicion findEmptyPosition [_size - 200,_size+50,_tipoveh];
_vehicle=[_pos, random 360,_tipoveh, _lado] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
_vehCrew = _vehicle select 1;
{[_x,_mrkOrigen] call NATOinit} forEach _vehCrew;
[_veh] call AIVEHinit;
_grupoVeh = _vehicle select 2;
_size = [_mrkDestino] call sizeMarker;

if (_posDestino inRangeOfArtillery [[_veh], ((getArtilleryAmmo [_veh]) select 0)]) then
	{
	while {(alive _veh) and ({_x select 0 == _tipoMuni} count magazinesAmmo _veh > 0) and (_mrkDestino in forcedSpawn)} do
		{
		_objetivo = objNull;
		_rondas = 1;
		_objetivos = vehicles select {((side driver _x == _ladoMalos) or (side driver _x == buenos)) and (_x distance _posDestino <= _size * 2) and (_lado knowsAbout _x >= 1.4) and (speed _x < 1)};
		if (count _objetivos > 0) then
			{
			{
			if (typeOf _x in vehAttack) exitWith {_objetivo = _x; _rondas = 4};
			} forEach _objetivos;
			if (isNull _objetivo) then {_objetivo = selectRandom _objetivos};
			}
		else
			{
			_objetivos = allUnits select {((side _x == _ladoMalos) or (side _x == buenos)) and (_x distance _posDestino <= _size * 2) and (_lado knowsAbout _x >= 1.4) and (_x == leader group _x)};
			if (count _objetivos > 0) then
				{
				_cuenta = 0;
				{
				_posible = _x;
				_cuentaGrupo = {(alive _x) and (!captive _x)} count units group _posible;
				if (_cuentaGrupo > _cuenta) then
					{
					if ((_lado == muyMalos) or ({(side _x == civilian) and (_x distance _posible < 100)} count allUnits == 0)) then
						{
						_objetivo = _posible;
						if (_cuentaGrupo > 6) then {_rondas = 2};
						};
					};
				} forEach _objetivos;
				};
			};
		if (!isNull _objetivo) then
			{
			_veh commandArtilleryFire [position _objetivo,_tipoMuni,_rondas];
			_tiempo = _veh getArtilleryETA [position _objetivo, ((getArtilleryAmmo [_veh]) select 0)];
			sleep 9 + ((_rondas - 1) * 3);
			}
		else
			{
			sleep 29;
			};
		sleep 1;
		};
	};

if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)) then {deleteVehicle _veh};

{
_veh = _x;
waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits) and (({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)};
deleteVehicle _veh;
} forEach _vehCrew;

deleteGroup _grupoVeh;

/*
_equis = _pos select 0;
_y = _pos select 1;
_cuenta = 0;

_amigos = "BLUFORSpawn";
if (_lado == muyMalos) then {_amigos = "OPFORSpawn"};
while {(!([300,1,_pos,_amigos] call distanceUnits)) and (_cuenta < 50)} do
	{
	_cuenta = _cuenta + 1;
	sleep (5 + (random 5));
	_shell1 = "Sh_82mm_AMOS" createVehicle [_equis + (150 - (random 300)),_y + (150 - (random 300)),200];
	_shell1 setVelocity [0,0,-50];
	};

