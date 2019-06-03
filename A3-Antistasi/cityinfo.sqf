
private ["_texto","_datos","_numCiv","_prestigeOPFOR","_prestigeBLUFOR","_power","_busy","_sitio","_positionTel","_garrison"];
positionTel = [];

_popFIA = 0;
_popAAF = 0;
_popCSAT = 0;
_pop = 0;
{
_datos = server getVariable _x;
_numCiv = _datos select 0;
_prestigeOPFOR = _datos select 2;
_prestigeBLUFOR = _datos select 3;
_popFIA = _popFIA + (_numCiv * (_prestigeBLUFOR / 100));
_popAAF = _popAAF + (_numCiv * (_prestigeOPFOR / 100));
_pop = _pop + _numCiv;
if (_x in destroyedCities) then {_popCSAT = _popCSAT + _numCIV};
} forEach citiesX;
_popFIA = round _popFIA;
_popAAF = round _popAAF;
hint format ["%7\n\nTotal pop: %1\n%6 Support: %2\n%5 Support: %3 \n\nMurdered Pop: %4\n\nClick on the zone",_pop, _popFIA, _popAAF, _popCSAT,nameOccupants,nameTeamPlayer,worldName];

if (!visibleMap) then {openMap true};

onMapSingleClick "positionTel = _pos;";


//waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
while {visibleMap} do
	{
	sleep 1;
	if (count positionTel > 0) then
		{
		_positionTel = positionTel;
		_sitio = [markersX, _positionTel] call BIS_Fnc_nearestPosition;
		_texto = "Click on the zone";
		_nameFaction = if (lados getVariable [_sitio,sideUnknown] == buenos) then {nameTeamPlayer} else {if (lados getVariable [_sitio,sideUnknown] == malos) then {nameOccupants} else {nameInvaders}};
		if (_sitio == "Synd_HQ") then
			{
			_texto = format ["%2 HQ%1",[_sitio] call A3A_fnc_garrisonInfo,nameTeamPlayer];
			};
		if (_sitio in citiesX) then
			{
			_datos = server getVariable _sitio;

			_numCiv = _datos select 0;
			_prestigeOPFOR = _datos select 2;
			_prestigeBLUFOR = _datos select 3;
			_power = [_sitio] call A3A_fnc_powerCheck;
			_texto = format ["%1\n\nPop %2\n%6 Support: %3 %5\n%7 Support: %4 %5",[_sitio,false] call A3A_fnc_fn_location,_numCiv,_prestigeOPFOR,_prestigeBLUFOR,"%",nameOccupants,nameTeamPlayer];
			_positionX = getMarkerPos _sitio;
			_result = "NONE";
			switch (_power) do
				{
				case buenos: {_result = format ["%1",nameTeamPlayer]};
				case malos: {_result = format ["%1",nameOccupants]};
				case Invaders: {_result = format ["%1",nameInvaders]};
				};
			/*_ant1 = [antennas,_positionX] call BIS_fnc_nearestPosition;
			_ant2 = [antennasDead, _positionX] call BIS_fnc_nearestPosition;
			if (_ant1 distance _positionX > _ant2 distance _positionX) then
				{
				_result = "NONE";
				}
			else
				{
				_puesto = [markersX,_ant1] call BIS_fnc_NearestPosition;
				if (lados getVariable [_sitio,sideUnknown] == buenos) then
					{
					if (lados getVariable [_puesto,sideUnknown] == buenos) then {_result = format ["%1",nameTeamPlayer]} else {if (lados getVariable [_puesto,sideUnknown] == Invaders) then {_result = "NONE"}};
					}
				else
					{
					if (lados getVariable [_puesto,sideUnknown] == buenos) then {_result = format ["%1",nameTeamPlayer]} else {if (lados getVariable [_puesto,sideUnknown] == Invaders) then {_result = "NONE"}};
					};
				};
			*/
			_texto = format ["%1\nInfluence: %2",_texto,_result];
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			if (lados getVariable [_sitio,sideUnknown] == buenos) then {_texto = format ["%1\n%2",_texto,[_sitio] call A3A_fnc_garrisonInfo]};
			};
		if (_sitio in airportsX) then
			{
			if (not(lados getVariable [_sitio,sideUnknown] == buenos)) then
				{
				_texto = format ["%1 Airport",_nameFaction];
				_busy = [_sitio,true] call A3A_fnc_airportCanAttack;
				if (_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
				_garrison = count (garrison getVariable _sitio);
				if (_garrison >= 40) then {_texto = format ["%1\nGarrison: Good",_texto]} else {if (_garrison >= 20) then {_texto = format ["%1\nGarrison: Weakened",_texto]} else {_texto = format ["%1\nGarrison: Decimated",_texto]}};
				}
			else
				{
				_texto = format ["%2 Airport%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				};
			};
		if (_sitio in resourcesX) then
			{
			if (not(lados getVariable [_sitio,sideUnknown] == buenos)) then
				{
				_texto = format ["%1 Resources",_nameFaction];
				_garrison = count (garrison getVariable _sitio);
				if (_garrison >= 30) then {_texto = format ["%1\nGarrison: Good",_texto]} else {if (_garrison >= 10) then {_texto = format ["%1\nGarrison: Weakened",_texto]} else {_texto = format ["%1\nGarrison: Decimated",_texto]}};
				}
			else
				{
				_texto = format ["%2 Resources%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		if (_sitio in factories) then
			{
			if (not(lados getVariable [_sitio,sideUnknown] == buenos)) then
				{
				_texto = format ["%1 Factory",_nameFaction];
				_garrison = count (garrison getVariable _sitio);
				if (_garrison >= 16) then {_texto = format ["%1\nGarrison: Good",_texto]} else {if (_garrison >= 8) then {_texto = format ["%1\nGarrison: Weakened",_texto]} else {_texto = format ["%1\nGarrison: Decimated",_texto]}};
				}
			else
				{
				_texto = format ["%2 Factory%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		if (_sitio in puestos) then
			{
			if (not(lados getVariable [_sitio,sideUnknown] == buenos)) then
				{
				_texto = format ["%1 Grand Outpost",_nameFaction];
				_busy = [_sitio,true] call A3A_fnc_airportCanAttack;
				if (_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
				_garrison = count (garrison getVariable _sitio);
				if (_garrison >= 16) then {_texto = format ["%1\nGarrison: Good",_texto]} else {if (_garrison >= 8) then {_texto = format ["%1\nGarrison: Weakened",_texto]} else {_texto = format ["%1\nGarrison: Decimated",_texto]}};
				}
			else
				{
				_texto = format ["%2 Grand Outpost%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				};
			};
		if (_sitio in puertos) then
			{
			if (not(lados getVariable [_sitio,sideUnknown] == buenos)) then
				{
				_texto = format ["%1 Seaport",_nameFaction];
				_garrison = count (garrison getVariable _sitio);
				if (_garrison >= 20) then {_texto = format ["%1\nGarrison: Good",_texto]} else {if (_garrison >= 8) then {_texto = format ["%1\nGarrison: Weakened",_texto]} else {_texto = format ["%1\nGarrison: Decimated",_texto]}};
				}
			else
				{
				_texto = format ["%2 Seaport%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				};
			};
		if (_sitio in outpostsFIA) then
			{
			if (isOnRoad (getMarkerPos _sitio)) then
				{
				_texto = format ["%2 Roadblock%1",[_sitio] call A3A_fnc_garrisonInfo,_nameFaction];
				}
			else
				{
				_texto = format ["%1 Watchpost",_nameFaction];
				};
			};
		hint format ["%1",_texto];
		};
	positionTel = [];
	};
onMapSingleClick "";








