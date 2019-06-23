if (!isServer) exitWith{};

{
	private _ciudad = _x;
	// ["TaskFailed", ["", format ["%1 joined %2",[_ciudad, false] call A3A_fnc_fn_location, nameMalos]]] remoteExec ["BIS_fnc_showNotification",buenos];
	lados setVariable [_ciudad,malos,true];
	_mrkD = format ["Dum%1",_ciudad];
	_mrkD setMarkerColor colorMalos;
	garrison setVariable [_ciudad,[],true];
} forEach ciudades;

nextTick = time + 15;
