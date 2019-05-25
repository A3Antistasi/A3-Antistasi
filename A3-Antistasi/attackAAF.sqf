//if ([0.5] call A3A_fnc_fogCheck) exitWith {};
private ["_objectivesX","_markersX","_base","_objectiveX","_cuenta","_airportX","_datos","_prestigeOPFOR","_scoreLand","_scoreAir","_analyzed","_garrison","_size","_staticsX","_salir"];

_objectivesX = [];
_markersX = [];
_cuentaFacil = 0;
_natoIsFull = false;
_csatIsFull = false;
_airportsX = airportsX select {([_x,false] call A3A_fnc_airportCanAttack) and (lados getVariable [_x,sideUnknown] != buenos)};
_objectivesX = markersX - controlsX - outpostsFIA - ["Synd_HQ","NATO_carrier","CSAT_carrier"] - destroyedCities;
if (gameMode != 1) then {_objectivesX = _objectivesX select {lados getVariable [_x,sideUnknown] == buenos}};
//_objectivesSDK = _objectivesX select {lados getVariable [_x,sideUnknown] == buenos};
if ((tierWar < 2) and (gameMode <= 2)) then
	{
	_airportsX = _airportsX select {(lados getVariable [_x,sideUnknown] == Occupants)};
	//_objectivesX = _objectivesSDK;
	_objectivesX = _objectivesX select {lados getVariable [_x,sideUnknown] == buenos};
	}
else
	{
	if (gameMode != 4) then {if ({lados getVariable [_x,sideUnknown] == Occupants} count _airportsX == 0) then {_airportsX pushBack "NATO_carrier"}};
	if (gameMode != 3) then {if ({lados getVariable [_x,sideUnknown] == } count _airportsX == 0) then {_airportsX pushBack "CSAT_carrier"}};
	if (([vehNATOPlane] call A3A_fnc_vehAvailable) and ([vehNATOMRLS] call A3A_fnc_vehAvailable) and ([vehNATOTank] call A3A_fnc_vehAvailable)) then {_natoIsFull = true};
	if (([vehCSATPlane] call A3A_fnc_vehAvailable) and ([vehCSATMRLS] call A3A_fnc_vehAvailable) and ([vehCSATTank] call A3A_fnc_vehAvailable)) then {_csatIsFull = true};
	};
if (gameMode != 4) then
	{
	if (tierWar < 3) then {_objectivesX = _objectivesX - citiesX};
	}
else
	{
	if (tierWar < 5) then {_objectivesX = _objectivesX - citiesX};
	};
//lets keep the nearest targets for each AI airbase in the target list, so we ensure even when they are surrounded of friendly zones, they remain as target
_nearestObjectives = [];
{
_lado = lados getVariable [_x,sideUnknown];
_tmpTargets = _objectivesX select {lados getVariable [_x,sideUnknown] != _lado};
if !(_tmpTargets isEqualTo []) then
	{
	_nearestTarget = [_tmpTargets,getMarkerPos _x] call BIS_fnc_nearestPosition;
	_nearestObjectives pushBack _nearestTarget;
	};
} forEach _airportsX;
//the following discards targets which are surrounded by friendly zones, excluding airbases and the nearest targets
_objectivesXProv = _objectivesX - airportsX - _nearestObjectives;
{
_posObj = getMarkerPos _x;
_sideObj = lados getVariable [_x,sideUnknown];
if (((markersX - controlsX - citiesX - outpostsFIA) select {lados getVariable [_x,sideUnknown] != _sideObj}) findIf {getMarkerPos _x distance2D _posObj < 2000} == -1) then {_objectivesX = _objectivesX - [_x]};
} forEach _objectivesXProv;

if (_objectivesX isEqualTo []) exitWith {};
_objectivesFinal = [];
_basesFinal = [];
_countFinal = [];
_objectiveFinal = [];
_easyX = [];
_easyArray = [];
_seaportCSAT = if ({(lados getVariable [_x,sideUnknown] == )} count seaports >0) then {true} else {false};
_seaportNATO = if ({(lados getVariable [_x,sideUnknown] == Occupants)} count seaports >0) then {true} else {false};
_waves = 1;

{
_base = _x;
_posBase = getMarkerPos _base;
_killZones = killZones getVariable [_base,[]];
_tmpObjectives = [];
_baseNATO = true;
if (lados getVariable [_base,sideUnknown] == Occupants) then
	{
	_tmpObjectives = _objectivesX select {lados getVariable [_x,sideUnknown] != Occupants};
	_tmpObjectives = _tmpObjectives - (citiesX select {([_x] call A3A_fnc_powerCheck) == buenos});
	}
else
	{
	_baseNATO = false;
	_tmpObjectives = _objectivesX select {lados getVariable [_x,sideUnknown] != };
	_tmpObjectives = _tmpObjectives - (citiesX select {(((server getVariable _x) select 2) + ((server getVariable _x) select 3) < 90) and ([_x] call A3A_fnc_powerCheck != Occupants)});
	};

_tmpObjectives = _tmpObjectives select {getMarkerPos _x distance2D _posBase < distanceForAirAttack};
if !(_tmpObjectives isEqualTo []) then
	{
	_nearX = [_tmpObjectives,_base] call BIS_fnc_nearestPosition;
	{
	_isCity = if (_x in citiesX) then {true} else {false};
	_proceed = true;
	_posSite = getMarkerPos _x;
	_esSDK = false;
	_isTheSameIsland = [_x,_base] call A3A_fnc_isTheSameIsland;
	if ([_x,true] call A3A_fnc_fogCheck >= 0.3) then
		{
		if (lados getVariable [_x,sideUnknown] == buenos) then
			{
			_esSDK = true;
			/*
			_valor = if (_baseNATO) then {prestigeNATO} else {prestigeCSAT};
			if (random 100 > _valor) then
				{
				_proceed = false
				}
			*/
			};
		if (!_isTheSameIsland and (not(_x in airportsX))) then
			{
			if (!_esSDK) then {_proceed = false};
			};
		}
	else
		{
		_proceed = false;
		};
	if (_proceed) then
		{
		if (!_isCity) then
			{
			if !(_x in _killZones) then
				{
				if !(_x in _easyArray) then
					{
					_sitio = _x;
					if (((!(_sitio in airportsX)) or (_esSDK)) and !(_base in ["NATO_carrier","CSAT_carrier"])) then
						{
						_sideENY = if (_baseNATO) then {} else {Occupants};
						if ({(lados getVariable [_x,sideUnknown] == _sideENY) and (getMarkerPos _x distance _posSite < distanceSPWN)} count airportsX == 0) then
							{
							_garrison = garrison getVariable [_sitio,[]];
							_staticsX = staticsToSave select {_x distance _posSite < distanceSPWN};
							_outposts = outpostsFIA select {getMarkerPos _x distance _posSite < distanceSPWN};
							_cuenta = ((count _garrison) + (count _outposts) + (2*(count _staticsX)));
							if (_cuenta <= 8) then
								{
								if (!hayIFA or (_posSite distance _posBase < distanceForLandAttack)) then
									{
									_proceed = false;
									_easyX pushBack [_sitio,_base];
									_easyArray pushBackUnique _sitio;
									};
								};
							};
						};
					};
				};
			};
		};
	if (_proceed) then
		{
		_times = 1;
		if (_baseNATO) then
			{
			if ({lados getVariable [_x,sideUnknown] == Occupants} count airportsX <= 1) then {_times = 2};
			if (!_isCity) then
				{
				if ((_x in outposts) or (_x in seaports)) then
					{
					if (!_esSDK) then
						{
						if (({[_x] call A3A_fnc_vehAvailable} count vehNATOAttack > 0) or ({[_x] call A3A_fnc_vehAvailable} count vehNATOAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
						}
					else
						{
						_times = 2*_times;
						};
					}
				else
					{
					if (_x in airportsX) then
						{
						if (!_esSDK) then
							{
							if (([vehNATOPlane] call A3A_fnc_vehAvailable) or (!([vehCSATAA] call A3A_fnc_vehAvailable))) then {_times = 5*_times} else {_times = 0};
							}
						else
							{
							if (!_isTheSameIsland) then {_times = 5*_times} else {_times = 2*_times};
							};
						}
					else
						{
						if ((!_esSDK) and _natoIsFull) then {_times = 0};
						};
					};
				};
			if (_times > 0) then
				{
				_airportNear = [airportsX,_posSite] call bis_fnc_nearestPosition;
				if ((lados getVariable [_airportNear,sideUnknown] == ) and (_x != _airportNear)) then {_times = 0};
				};
			}
		else
			{
			_times = 2;
			if (!_isCity) then
				{
				if ((_x in outposts) or (_x in seaports)) then
					{
					if (!_esSDK) then
						{
						if (({[_x] call A3A_fnc_vehAvailable} count vehCSATAttack > 0) or ({[_x] call A3A_fnc_vehAvailable} count vehCSATAttackHelis > 0)) then {_times = 2*_times} else {_times = 0};
						}
					else
						{
						_times = 2*_times;
						};
					}
				else
					{
					if (_x in airportsX) then
						{
						if (!_esSDK) then
							{
							if (([vehCSATPlane] call A3A_fnc_vehAvailable) or (!([vehNATOAA] call A3A_fnc_vehAvailable))) then {_times = 5*_times} else {_times = 0};
							}
						else
							{
							if (!_isTheSameIsland) then {_times = 5*_times} else {_times = 2*_times};
							};
						}
					else
						{
						if ((!_esSDK) and _csatIsFull) then {_times = 0};
						};
					}
				};
			if (_times > 0) then
				{
				_airportNear = [airportsX,_posSite] call bis_fnc_nearestPosition;
				if ((lados getVariable [_airportNear,sideUnknown] == Occupants) and (_x != _airportNear)) then {_times = 0};
				};
			};
		if (_times > 0) then
			{
			if ((!_esSDK) and (!_isCity)) then
				{
				//_times = _times + (floor((garrison getVariable [_x,0])/8))
				_numGarr = [_x] call A3A_fnc_garrisonSize;
				if ((_numGarr/2) < count (garrison getVariable [_x,[]])) then {if ((_numGarr/3) < count (garrison getVariable [_x,[]])) then {_times = _times + 6} else {_times = _times +2}};
				};
			if (_isTheSameIsland) then
				{
				if (_posSite distance _posBase < distanceForLandAttack) then
					{
					if  (!_isCity) then
						{
						_times = _times * 4
						};
					};
				};
			if (!_isCity) then
				{
				_esMar = false;
				if ((_baseNATO and _seaportNATO) or (!_baseNATO and _seaportCSAT)) then
					{
					for "_i" from 0 to 3 do
						{
						_pos = _posSite getPos [1000,(_i*90)];
						if (surfaceIsWater _pos) exitWith {_esMar = true};
						};
					};
				if (_esMar) then {_times = _times * 2};
				};
			if (_x == _nearX) then {_times = _times * 5};
			if (_x in _killZones) then
				{
				_sitio = _x;
				_times = _times / (({_x == _sitio} count _killZones) + 1);
				};
			_times = round (_times);
			_index = _objectivesFinal find _x;
			if (_index == -1) then
				{
				_objectivesFinal pushBack _x;
				_basesFinal pushBack _base;
				_countFinal pushBack _times;
				}
			else
				{
				if ((_times > (_countFinal select _index)) or ((_times == (_countFinal select _index)) and (random 1 < 0.5))) then
					{
					_objectivesFinal deleteAt _index;
					_basesFinal deleteAt _index;
					_countFinal deleteAt _index;
					_objectivesFinal pushBack _x;
					_basesFinal pushBack _base;
					_countFinal pushBack _times;
					};
				};
			};
		};
	if (count _easyX == 4) exitWith {};
	} forEach _tmpObjectives;
	};
if (count _easyX == 4) exitWith {};
} forEach _airportsX;

if (count _easyX == 4) exitWith
	{
	{[[_x select 0,_x select 1,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2];sleep 30} forEach _easyX;
	};
if (hayIFA and (sunOrMoon < 1)) exitWith {};
if ((count _objectivesFinal > 0) and (count _easyX < 3)) then
	{
	_arrayFinal = [];
	/*{
	for "_i" from 1 to _x do
		{
		_arrayFinal pushBack [(_objectivesFinal select _forEachIndex),(_basesFinal select _forEachIndex)];
		};
	} forEach _countFinal;*/
	for "_i" from 0 to (count _objectivesFinal) - 1 do
		{
		_arrayFinal pushBack [_objectivesFinal select _i,_basesFinal select _i];
		};
	//_objectiveFinal = selectRandom _arrayFinal;
	_objectiveFinal = _arrayFinal selectRandomWeighted _countFinal;
	_destinationX = _objectiveFinal select 0;
	_origen = _objectiveFinal select 1;
	///aquí decidimos las oleadas
	if (_waves == 1) then
		{
		if (lados getVariable [_destinationX,sideUnknown] == buenos) then
			{
			_waves = (round (random tierWar));
			if (_waves == 0) then {_waves = 1};
			}
		else
			{
			if (lados getVariable [_origen,sideUnknown] == ) then
				{
				if (_destinationX in airportsX) then
					{
					_waves = 2 + round (random tierWar);
					}
				else
					{
					if (!(_destinationX in citiesX)) then
						{
						_waves = 1 + round (random (tierWar)/2);
						};
					};
				}
			else
				{
				if (!(_destinationX in citiesX)) then
					{
					_waves = 1 + round (random ((tierWar - 3)/2));
					};
				};
			};
		};
	if (not(_destinationX in citiesX)) then
		{
		///[[_destinationX,_origen,_waves],"A3A_fnc_wavedCA"] call A3A_fnc_scheduler;
		[_destinationX,_origen,_waves] spawn A3A_fnc_wavedCA;
		}
	else
		{
		//if (lados getVariable [_origen,sideUnknown] == Occupants) then {[[_destinationX,_origen,_waves],"A3A_fnc_wavedCA"] call A3A_fnc_scheduler} else {[[_destinationX,_origen],"A3A_fnc_CSATpunish"] call A3A_fnc_scheduler};
		if (lados getVariable [_origen,sideUnknown] == Occupants) then {[_destinationX,_origen,_waves] spawn A3A_fnc_wavedCA} else {[_destinationX,_origen] spawn A3A_fnc_CSATpunish};
		};
	};

if (_waves == 1) then
	{
	{[[_x select 0,_x select 1,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]} forEach _easyX;
	};
