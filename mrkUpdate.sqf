private ["_marcador","_mrkD"];

_marcador = _this select 0;

_mrkD = format ["Dum%1",_marcador];
if (lados getVariable [_marcador,sideUnknown] == buenos) then
	{
	_mrkD setMarkerColor colorBuenos;
	if (_marcador in aeropuertos) then {_mrkD setMarkerText "SDK Airbase";_mrkD setMarkerType "flag_Syndicat"} else {
	if (_marcador in puestos) then {_mrkD setMarkerText "SDK Outpost"}};
	}
else
	{
	if (lados getVariable [_marcador,sideUnknown] == malos) then
		{
		if (_marcador in aeropuertos) then {_mrkD setMarkerText "NATO Airbase";_mrkD setMarkerType flagNATOmrk} else {
		if (_marcador in puestos) then {_mrkD setMarkerText "NATO Outpost"}};
		_mrkD setMarkerColor colorMalos;
		}
	else
		{
		if (_marcador in aeropuertos) then {_mrkD setMarkerText "CSAT Airbase";_mrkD setMarkerType flagCSATmrk} else {
		if (_marcador in puestos) then {_mrkD setMarkerText "CSAT Outpost"}};
		_mrkD setMarkerColor colorMuyMalos;
		};
	};

