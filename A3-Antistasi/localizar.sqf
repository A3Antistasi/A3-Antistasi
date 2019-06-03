private ["_pos","_sitio","_ciudad","_texto"];

_sitio = _this select 0;

_pos = getMarkerPos _sitio;

_texto = "";


if (_sitio in citiesX) then
	{
	_texto = format ["%1",[_sitio,false] call A3A_fnc_fn_location];
	}
else
	{
	_ciudad = [citiesX,_pos] call BIS_fnc_nearestPosition;
	_ciudad = [_ciudad,false] call A3A_fnc_fn_location;
	if (_sitio in airportsX) then {_texto = format ["%1 Airbase",_ciudad]};
	if (_sitio in resourcesX) then {_texto = format ["Resource near %1",_ciudad]};
	if (_sitio in factories) then {_texto = format ["Factory near %1",_ciudad]};
	if (_sitio in seaports) then {_texto = format ["Outpost near %1",_ciudad]};
	if (_sitio in seaports) then {_texto = format ["Seaport near %1",_ciudad]};
	if (_sitio in controlsX) then
		{
		if (isOnRoad getMarkerPos _sitio) then
			{
			_texto = format ["Roadblock near %1",_ciudad]
			}
		else
			{
			_texto = format ["Forest near %1",_ciudad]
			};
		}
	else{
		if ((_sitio == "NATO_carrier") or (_sitio == "CSAT_carrier")) then {_texto = "their carrier"};
		};
	};
_texto