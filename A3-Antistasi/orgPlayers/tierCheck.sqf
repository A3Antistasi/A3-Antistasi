_sitios = markersX select {lados getVariable [_x,sideUnknown] == buenos};
_tierWar = 1 + (floor (((5*({(_x in puestos) or (_x in resourcesX) or (_x in citiesX)} count _sitios)) + (10*({_x in puertos} count _sitios)) + (20*({_x in airportsX} count _sitios)))/10));
if (_tierWar > 10) then {_tierWar = 10};
if (_tierWar != tierWar) then
	{
	tierWar = _tierWar;
	publicVariable "tierWar";
	[petros,"tier",""] remoteExec ["A3A_fnc_commsMP",[buenos,civilian]];
	//[] remoteExec ["A3A_fnc_statistics",[buenos,civilian]];
	};