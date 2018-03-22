//if (!isServer) exitWith {};

private ["_cuentaFail","_texto"];

_fpsTotal = 0;
_fpsCuenta = 0;
_cuentaFail = 0;
_minimoFPS = if (isDedicated) then {15} else {25};

while {true} do
	{
	sleep 5;
	if (_fpsCuenta > 12) then
		{
		fpsAv = _fpsTotal / _fpsCuenta;
		publicVariable "fpsAv";
		_fpsTotal = diag_fps;
		_fpsCuenta = 1;
		}
	else
		{
		_fpsTotal = _fpsTotal + diag_fps;
		_fpsCuenta = _fpsCuenta + 1;
		};

	//if (debug) then {stavros globalChat format ["FPS Av:%1.FPS Lim:%2",_fpsTotal / _fpsCuenta, minimoFPS]};
	if (diag_fps < minimoFPS) then
		{
		{if ((alive _x) and (side _x == civilian) and (diag_fps < minimoFPS) and (typeOf _x in arrayCivs)) then {deleteVehicle _x; sleep 1}} forEach allUnits;
		//if (debug) then {stavros sideChat "Eliminados algunos civiles para incrementar FPS"};
		_cuentaFail = _cuentaFail + 1;
		if (_cuentaFail > 11) then
			{
			if (distRef > 800) then
				{
				distRef = distRef - 100;
				distanciaSPWN = distanciaSPWN - 100;
				distanciaSPWN1 = distanciaSPWN * 1.3;
				distanciaSPWN2 = distanciaSPWN / 2;
				publicVariable "distanciaSPWN";
				publicVariable "distanciaSPWN1";
				publicVariable "distanciaSPWN2";
				};
			if (civPerc > 0) then
				{
				civPerc = civPerc - 0.01;
				publicVariable "civPerc";
				};
			if (minimoFPS > _minimoFPS) then
				{
				minimoFPS = _minimoFPS;
				publicVariable "minimoFPS";
				};
			_cuentaFail = 0;
			{if (!alive _x) then {deleteVehicle _x}} forEach vehicles;
			{deleteVehicle _x} forEach allDead;
			_texto = format ["Server has a low FPS average:\n%1\n\nGame settings changed to:\nSpawn Distance: %2 mts\nCiv. Percentage: %3 percent\nFPS Limit established at %4\n\nAll wrecked vehicles and corpses have been deleted",round (_fpsTotal/_fpsCuenta), distRef,civPerc * 100, minimoFPS];
			[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
			if (isServer) then {allowPlayerRecruit = false; publicVariable "allowPlayerRecruit"};
			}
		else
			{
			if (distanciaSPWN > 600) then
				{
				distanciaSPWN = distanciaSPWN - 20;
				distanciaSPWN1 = distanciaSPWN * 1.3;
				distanciaSPWN2 = distanciaSPWN / 2;
				publicVariable "distanciaSPWN";
				publicVariable "distanciaSPWN1";
				publicVariable "distanciaSPWN2";
				};
			};
		}
	else
		{
		_cuentaFail = 0;
		if (!allowPlayerRecruit and isServer) then {allowPlayerRecruit = true; publicVariable "allowPlayerRecruit"};
		if (distanciaSPWN < distRef) then
			{
			distanciaSPWN = distanciaSPWN + 20;
			distanciaSPWN1 = distanciaSPWN * 1.3;
			distanciaSPWN2 = distanciaSPWN / 2;
			publicVariable "distanciaSPWN";
			publicVariable "distanciaSPWN1";
			publicVariable "distanciaSPWN2";
			};
		};
	};