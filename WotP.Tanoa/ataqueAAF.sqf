//if ([0.5] call fogCheck) exitWith {};
private ["_objetivos","_marcadores","_base","_objetivo","_cuenta","_aeropuerto","_datos","_prestigeOPFOR","_scoreLand","_scoreAir","_analizado","_garrison","_size","_estaticas","_salir"];

_objetivos = [];
_marcadores = [];
_cuentaFacil = 0;

_aeropuertos = aeropuertos select {(dateToNumber date > server getVariable _x) and !([distanciaSPWN/2,1,getMarkerPos _x,"GREENFORSpawn"] call distanceUnits) and (lados getVariable [_x,sideUnknown] != buenos)};
if ((tierWar < 3) and ({lados getVariable [_x,sideUnknown] == muyMalos} count _aeropuertos < 2)) then {_aeropuertos = _aeropuertos select {(lados getVariable [_x,sideUnknown] == malos)}};
_objetivos = marcadores - controles - puestosFIA - ["Synd_HQ","airport_1","airport_4"] - destroyedCities;
if (tierWar < 3) then {_objetivos = _objetivos - ciudades};
_objetivosFinal = [];
_basesFinal = [];
_cuentasFinal = [];
_objetivoFinal = [];
_faciles = [];
_puertoCSAT = if ({(lados getVariable [_x,sideUnknown] == muyMalos)} count puertos >0) then {true} else {false};
_puertoNATO = if ({(lados getVariable [_x,sideUnknown] == malos)} count puertos >0) then {true} else {false};
_waves = 1;

{
_base = _x;
_posBase = getMarkerPos _base;
_killZones = killZones getVariable [_base,[]];
_tmpObjetivos = [];
_baseNATO = true;
if (lados getVariable [_base,sideUnknown] == malos) then {_tmpObjetivos = _objetivos select {lados getVariable [_x,sideUnknown] != malos}} else {_baseNATO = false; _tmpObjetivos = _objetivos select {lados getVariable [_x,sideUnknown] != muyMalos}};

_tmpObjetivos = _tmpObjetivos select {getMarkerPos _x distance2D _posBase < 10000};
_cercano = [_tmpObjetivos,_base] call BIS_fnc_nearestPosition;
	{
	_esCiudad = if (_x in ciudades) then {true} else {false};
	_proceder = true;
	_posSitio = getMarkerPos _x;
	_esSDK = false;
	_isTheSameIsland = [_x,_base] call isTheSameIsland;
	if ([_x,true] call fogCheck >= 0.3) then
		{
		if (lados getVariable [_x,sideUnknown] == buenos) then
			{
			_esSDK = true;
			_valor = if (_baseNATO) then {prestigeNATO} else {prestigeCSAT};
			if (random 100 > _valor) then
				{
				_proceder = false
				}
			else
				{
				if (count _faciles < 4) then
					{
					if (not _esCiudad) then
						{
						_sitio = _x;
						if !(_sitio in _killZones) then
							{
							_garrison = garrison getVariable [_sitio,[]];
							_estaticas = staticsToSave select {_x distance _posSitio < distanciaSPWN};
							_puestos = puestosFIA select {getMarkerPos _x distance _posSitio < distanciaSPWN};
							_cuenta = ((count _garrison) + (3*(count _puestos)) + (2*(count _estaticas)));
							if (_cuenta <= 4) then
								{
								_proceder = false;
								_faciles pushBack [_sitio,_base];
								};
							};
						};
					};
				};
			};
		if (!_isTheSameIsland and (not(_x in aeropuertos))) then
			{
			if (!_esSDK) then {_proceder = false};
			};
		}
	else
		{
		_proceder = false;
		};
	if (_proceder) then
		{
		_times = 1;
		if (_baseNATO) then
			{
			if ({lados getVariable [_x,sideUnknown] == malos} count aeropuertos == 1) then {_times = 2};
			if (!_esCiudad) then
				{
				if ((_x in puestos) or (_x in puertos)) then
					{
					if (!_esSDK) then
						{
						if (({[_x] call vehAvailable} count vehNATOAttack > 0) or ({[_x] call vehAvailable} count vehNATOAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
						}
					else
						{
						_times = 2*_times;
						};
					}
				else
					{
					if (_x in aeropuertos) then
						{
						if (!_esSDK) then
							{
							if (([vehNATOPlane] call vehAvailable) or (!([vehCSATAA] call vehAvailable))) then {_times = 5*_times} else {_times = 0};
							}
						else
							{
							if (!_isTheSameIsland) then {_times = 5*_times} else {_times = 2*_times};
							};
						};
					};
				};
			if (_times > 0) then
				{
				_aeropCercano = [aeropuertos,_posSitio] call bis_fnc_nearestPosition;
				if ((lados getVariable [_aeropCercano,sideUnknown] == muyMalos) and (_x != _aeropCercano)) then {_times = 0};
				};
			}
		else
			{
			_times = 2;
			if (!_esCiudad) then
				{
				if (_x in puertos) then
					{
					if (!_esSDK) then
						{
						if (({[_x] call vehAvailable} count vehCSATAttack > 0) or ({[_x] call vehAvailable} count vehCSATAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
						}
					else
						{
						_times = 2*_times;
						};
					}
				else
					{
					if (_x in recursos) then
						{
						if (!_esSDK) then
							{
							if (({[_x] call vehAvailable} count vehCSATAttack > 0) or ({[_x] call vehAvailable} count vehCSATAttackHelis > 0)) then {_times = 3*_times} else {_times = 0};
							}
						else
							{
							_times = 3*_times;
							};
						}
					else
						{
						if (_x in aeropuertos) then
							{
							if (!_esSDK) then
								{
								if (([vehCSATPlane] call vehAvailable) or (!([vehNATOAA] call vehAvailable))) then {_times = 5*_times} else {_times = 0};
								}
							else
								{
								if (!_isTheSameIsland) then {_times = 5*_times} else {_times = 2*_times};
								};
							}
						}
					}
				};
			if (_times > 0) then
				{
				_aeropCercano = [aeropuertos,_posSitio] call bis_fnc_nearestPosition;
				if ((lados getVariable [_aeropCercano,sideUnknown] == malos) and (_x != _aeropCercano)) then {_times = 0};
				};
			};
		if (_times > 0) then
			{
			if ((!_esSDK) and (!_esCiudad)) then
				{
				//_times = _times + (floor((garrison getVariable [_x,0])/8))
				_numGarr = [_x] call garrisonSize;
				if ((_numGarr/2) < count (garrison getVariable [_x,[]])) then {if ((_numGarr/3) < count (garrison getVariable [_x,[]])) then {_times = _times + 6} else {_times = _times +2}};
				};
			if (_isTheSameIsland) then
				{
				if (_posSitio distance _posBase < 5000) then
					{
					if  (!_esCiudad) then
						{
						_times = _times * 4
						};
					};
				};
			if (!_esCiudad) then
				{
				_esMar = false;
				if ((_baseNATO and _puertoNATO) or (!_baseNATO and _puertoCSAT)) then
					{
					for "_i" from 0 to 3 do
						{
						_pos = _posSitio getPos [1000,(_i*90)];
						if (surfaceIsWater _pos) exitWith {_esMar = true};
						};
					};
				if (_esMar) then {_times = _times * 2};
				};
			if (_x == _cercano) then {_times = _times * 4};
			if (_x in _killZones) then
				{
				_sitio = _x;
				_times = _times / (({_x == _sitio} count _killZones) + 1);
				};
			_times = round (_times);
			_index = _objetivosFinal find _x;
			if (_index == -1) then
				{
				_objetivosFinal pushBack _x;
				_basesFinal pushBack _base;
				_cuentasFinal pushBack _times;
				}
			else
				{
				if ((_times > (_cuentasFinal select _index)) or ((_times == (_cuentasFinal select _index)) and (random 1 < 0.5))) then
					{
					_objetivosFinal deleteAt _index;
					_basesFinal deleteAt _index;
					_cuentasFinal deleteAt _index;
					_objetivosFinal pushBack _x;
					_basesFinal pushBack _base;
					_cuentasFinal pushBack _times;
					};
				};
			};
		};
	} forEach _tmpObjetivos;
} forEach _aeropuertos;


if ((count _objetivosFinal > 0) and (count _faciles < 3)) then
	{
	_arrayFinal = [];
	{
	for "_i" from 1 to _x do
		{
		_arrayFinal pushBack [(_objetivosFinal select _forEachIndex),(_basesFinal select _forEachIndex)];
		};
	} forEach _cuentasFinal;
	_objetivoFinal = selectRandom _arrayFinal;
	_destino = _objetivoFinal select 0;
	_origen = _objetivoFinal select 1;
	///aquí decidimos las oleadas
	if (_waves == 1) then
		{
		if (lados getVariable [_destino,sideUnknown] == buenos) then
			{
			_waves = (round (random tierWar));
			if (_waves == 0) then {_waves = 1};
			}
		else
			{
			if (lados getVariable [_origen,sideUnknown] == muyMalos) then
				{
				if (_destino in aeropuertos) then
					{
					if ({lados getVariable [_x,sideUnknown] == muyMalos} count aeropuertos == 1) then {_waves = 0} else {_waves = 1 + round (random 2)};
					}
				else
					{
					if (!(_destino in ciudades)) then
						{
						_waves = 1 + round (random ((tierWar - 3)/2));
						};
					};
				}
			else
				{
				if (!(_destino in ciudades)) then
					{
					_waves = 1 + round (random ((tierWar - 3)/2));
					};
				};
			};
		};
	if (not(_destino in ciudades)) then
		{
		[_destino,_origen,_waves] remoteExec ["wavedCA",HCattack];
		}
	else
		{
		if (lados getVariable [_origen,sideUnknown] == malos) then {[_destino,_origen,_waves] remoteExec ["wavedCA",HCattack]} else {[_destino,_origen] remoteExec ["CSATpunish",HCattack]};
		};
	};

if (_waves == 1) then
	{
	{[_x select 0,_x select 1] remoteExec ["patrolCA",HCattack]} forEach _faciles;
	};

if ((not(["CONVOY"] call BIS_fnc_taskExists)) and (_waves == 1)) then
	{
	if ((count _objetivoFinal == 0) and (count _faciles < 2)) then
		{
		_objetivos = [];
		{
		_base = [_x] call findBasesForConvoy;
		if (_base != "") then
			{
			_datos = server getVariable _x;
			_prestigeOPFOR = _datos select 2;
			_prestigeBLUFOR = _datos select 3;
			if (_prestigeOPFOR + _prestigeBLUFOR < 95) then
				{
				if (count (garrison getVariable [_x,[]]) == 0) then {_objetivos pushBack [_x,_base]};
				};
			};
		} forEach (ciudades select {lados getVariable [_x,sideUnknown] == buenos});
		if (count _objetivos > 0) then
			{
			_objetivo = selectRandom _objetivos;
			[(_objetivo select 0),(_objetivo select 1)] remoteExec ["CONVOY",HCattack];
			};
		};
	};
