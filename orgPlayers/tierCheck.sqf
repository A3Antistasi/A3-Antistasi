_tierWar = 1 + (floor (((5*({(_x in puestos) or (_x in recursos) or (_x in ciudades)} count mrkSDK)) + (10*({_x in puertos} count mrkSDK)) + (20*({_x in aeropuertos} count mrkSDK)))/10));
if (_tierWar > 10) then {_tierWar = 10};
if (_tierWar != tierWar) then
	{
	tierWar = _tierWar;
	publicVariable "tierWar";
	[petros,"tier",""] remoteExec ["commsMP",[buenos,civilian]];
	//[] remoteExec ["statistics",[buenos,civilian]];
	};