private ["_pos","_siteX","_city","_textX"];

_siteX = _this select 0;

_pos = getMarkerPos _siteX;

_textX = "";


if (_siteX in citiesX) then
	{
	_textX = format ["%1",[_siteX,false] call A3A_fnc_location];
	}
else
	{
	_city = [citiesX,_pos] call BIS_fnc_nearestPosition;
	_city = [_city,false] call A3A_fnc_location;
	if (_siteX in airportsX) then {_textX = format ["%1 Airbase",_city]};
	if (_siteX in resourcesX) then {_textX = format ["Resource near %1",_city]};
	if (_siteX in factories) then {_textX = format ["Factory near %1",_city]};
	if (_siteX in outposts) then {_textX = format ["Outpost near %1",_city]};
	if (_siteX in seaports) then {_textX = format ["Seaport near %1",_city]};
	if (_siteX in controlsX) then
		{
		if (isOnRoad getMarkerPos _siteX) then
			{
			_textX = format ["Roadblock near %1",_city]
			}
		else
			{
			_textX = format ["Forest near %1",_city]
			};
		}
	else{
		if ((_siteX == "NATO_carrier") or (_siteX == "CSAT_carrier")) then {_textX = "their carrier"};
		};
	};
_textX