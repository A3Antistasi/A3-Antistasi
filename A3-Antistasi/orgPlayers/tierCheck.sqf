_sitios = marcadores select {lados getVariable [_x,sideUnknown] == buenos};
_tierWar = 1 + (floor (((5*({(_x in puestos) or (_x in recursos) or (_x in ciudades)} count _sitios)) + (10*({_x in puertos} count _sitios)) + (20*({_x in aeropuertos} count _sitios)))/10));
if (_tierWar > 10) then {_tierWar = 10};
if (_tierWar != tierWar) then
	{
	tierWar = _tierWar;
	publicVariable "tierWar";
	[petros,"tier",""] remoteExec ["commsMP",[buenos,civilian]];
	//[] remoteExec ["statistics",[buenos,civilian]];
	};