private ["_markerX","_result","_positionX"];
_markerX = _this select 0;
//if (!(_markerX in citiesX)) exitWith {true; diag_log format ["Error en cálculo de Antena para %1",_markerX]};
if (count antennas == 0) exitWith {sideUnknown};
//_result = false;
_positionX = getMarkerPos _markerX;
_ant1 = [antennas,_positionX] call BIS_fnc_nearestPosition;
_ant2 = [antennasDead, _positionX] call BIS_fnc_nearestPosition;

if (_ant1 distance _positionX > _ant2 distance _positionX) exitWith {sideUnknown};

_puesto = [markersX,_ant1] call BIS_fnc_NearestPosition;
/*
if (lados getVariable [_markerX,sideUnknown] == buenos) then
	{
	if (lados getVariable [_puesto,sideUnknown] == buenos) then {_result = true};
	}
else
	{
	if (lados getVariable [_puesto,sideUnknown] == malos) then {_result = true};
	};*/
private _lado = lados getVariable [_puesto,sideUnknown];
//_result
_lado