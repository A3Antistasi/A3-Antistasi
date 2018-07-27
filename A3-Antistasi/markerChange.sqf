if (!isServer) exitWith {};

private ["_winner","_marcador","_looser","_posicion","_other","_bandera","_banderas","_dist","_texto","_sides"];

_winner = _this select 0;
_marcador = _this select 1;
if ((_winner == "GREENFORSpawn") and (_marcador in aeropuertos) and (tierWar < 3)) exitWith {};
if ((_winner == "GREENFORSpawn") and (lados getVariable [_marcador,sideUnknown] == buenos)) exitWith {};
if ((_winner == "BLUFORSpawn") and (lados getVariable [_marcador,sideUnknown] == malos)) exitWith {};
if ((_winner == "OPFORSpawn") and (lados getVariable [_marcador,sideUnknown] == muyMalos)) exitWith {};
if (_marcador in markersChanging) exitWith {};
markersChanging pushBackUnique _marcador;
_posicion = getMarkerPos _marcador;
_looser = sideUnknown;
_sides = [buenos,malos,muyMalos];
_other = "";
_texto = "";
_prestigeMalos = 0;
_prestigeMuyMalos = 0;
_bandera = objNull;
_size = [_marcador] call sizeMarker;

if ((!(_marcador in ciudades)) and (spawner getVariable _marcador != 2)) then
	{
	_banderas = nearestObjects [_posicion, ["FlagCarrier"], _size];
	_bandera = _banderas select 0;
	};
if (isNil "_bandera") then {_bandera = objNull};
//[_bandera,"remove"] remoteExec ["flagaction",0,_bandera];

if (lados getVariable [_marcador,sideUnknown] == buenos) then
	{
	_looser = buenos;
	_texto = format ["%1 ",nameBuenos];
	[] call tierCheck;
	}
else
	{
	if (lados getVariable [_marcador,sideUnknown] == malos) then
		{
		_looser = malos;
		_texto = format ["%1 ",nameMalos];
		}
	else
		{
		_looser = muyMalos;
		_texto = format ["%1 ",nameMuyMalos];
		};
	};
garrison setVariable [_marcador,[],true];
if (_winner == "GREENFORSpawn") then
	{
	lados setVariable [_marcador,buenos,true];
	_winner = buenos;
	_super = if (_marcador in aeropuertos) then {true} else {false};
	[[_marcador,_looser,"",_super],"patrolCA"] call scheduler;
	//sleep 15;
	[[_marcador],"autoGarrison"] call scheduler;
	}
else
	{
	_soldados = [];
	{_soldados pushBack (typeOf _x)} forEach (allUnits select {(_x distance _posicion < (_size*3)) and (_x getVariable [_winner,false]) and (vehicle _x == _x) and (alive _x)});
	if (_winner == "BLUFORspawn") then
		{
		lados setVariable [_marcador,malos,true];
		_winner = malos;
		}
	else
		{
		lados setVariable [_marcador,muyMalos,true];
		_winner = muyMalos;
		};
	[_soldados,_winner,_marcador,0] remoteExec ["garrisonUpdate",2];
	};

_nul = [_marcador] call mrkUpdate;
_sides = _sides - [_winner,_looser];
_other = _sides select 0;
if (_marcador in aeropuertos) then
	{
	if (_winner == buenos) then
		{
		[0,10,_posicion] remoteExec ["citySupportChange",2];
		if (_looser == malos) then
			{
			_prestigeMalos = 20;
			_prestigeMuyMalos = 10;
			}
		else
			{
			_prestigeMalos = 10;
			_prestigeMuyMalos = 20;
			};
		}
	else
		{
		server setVariable [_marcador,dateToNumber date,true];
		[_marcador,60] call addTimeForIdle;
		if (_winner == malos) then
			{
			[10,0,_posicion] remoteExec ["citySupportChange",2]
			}
		else
			{
			[-10,-10,_posicion] remoteExec ["citySupportChange",2]
			};
		if (_looser == buenos) then
			{
			_prestigeMalos = -10;
			_prestigeMuyMalos = -10;
			};
		};
	["TaskSucceeded", ["", "Airbase Taken"]] remoteExec ["BIS_fnc_showNotification",_winner];
	["TaskFailed", ["", "Airbase Lost"]] remoteExec ["BIS_fnc_showNotification",_looser];
	["TaskUpdated",["",format ["%1 lost an Airbase",_texto]]] remoteExec ["BIS_fnc_showNotification",_other];
	killZones setVariable [_marcador,[],true];
	};
if (_marcador in puestos) then
	{
	if !(_winner == buenos) then
		{
		server setVariable [_marcador,dateToNumber date,true];
		if (_looser == buenos) then
			{
			if (_winner == malos) then {_prestigeMalos = -5} else {_prestigeMuyMalos = -5};
			};
		}
	else
		{
		if (_looser == malos) then {_prestigeMalos = 5} else {_prestigeMuyMalos = 5};
		};
	["TaskSucceeded", ["", "Outpost Taken"]] remoteExec ["BIS_fnc_showNotification",_winner];
	["TaskFailed", ["", "Outpost Lost"]] remoteExec ["BIS_fnc_showNotification",_looser];
	["TaskUpdated",["",format ["%1 lost an Outpost",_texto]]] remoteExec ["BIS_fnc_showNotification",_other];
	killZones setVariable [_marcador,[],true];
	};
if (_marcador in puertos) then
	{
	if !(_winner == buenos) then
		{
		if (_looser == buenos) then
			{
			if (_winner == malos) then {_prestigeMalos = -5} else {_prestigeMuyMalos = -5};
			};
		}
	else
		{
		if (_looser == malos) then {_prestigeMalos = 5} else {_prestigeMuyMalos = 5};
		};
	["TaskSucceeded", ["", "Seaport Taken"]] remoteExec ["BIS_fnc_showNotification",_winner];
	["TaskFailed", ["", "Seaport Lost"]] remoteExec ["BIS_fnc_showNotification",_looser];
	["TaskUpdated",["",format ["%1 lost a Seaport",_texto]]] remoteExec ["BIS_fnc_showNotification",_other];
	};
if (_marcador in fabricas) then
	{
	["TaskSucceeded", ["", "Factory Taken"]] remoteExec ["BIS_fnc_showNotification",_winner];
	["TaskFailed", ["", "Factory Lost"]] remoteExec ["BIS_fnc_showNotification",_looser];
	["TaskUpdated",["",format ["%1 lost a Factory",_texto]]] remoteExec ["BIS_fnc_showNotification",_other];
	};
if (_marcador in recursos) then
	{
	["TaskSucceeded", ["", "Resource Taken"]] remoteExec ["BIS_fnc_showNotification",_winner];
	["TaskFailed", ["", "Resource Lost"]] remoteExec ["BIS_fnc_showNotification",_looser];
	["TaskUpdated",["",format ["%1 lost a Resource",_texto]]] remoteExec ["BIS_fnc_showNotification",_other];
	};

{_nul = [_marcador,_x] spawn deleteControles} forEach controles;
if (_winner == buenos) then
	{
	[] call tierCheck;
	if (!isNull _bandera) then
		{
		//[_bandera,"remove"] remoteExec ["flagaction",0,_bandera];
		[_bandera,"SDKFlag"] remoteExec ["flagaction",0,_bandera];
		[_bandera,"\A3\Data_F_exp\Flags\Flag_Synd_CO.paa"] remoteExec ["setFlagTexture",_bandera];
		sleep 2;
		//[_bandera,"unit"] remoteExec ["flagaction",[buenos,civilian],_bandera];
		//[_bandera,"vehicle"] remoteExec ["flagaction",[buenos,civilian],_bandera];
		//[_bandera,"garage"] remoteExec ["flagaction",[buenos,civilian],_bandera];
		if (_marcador in puertos) then {[_bandera,"seaport"] remoteExec ["flagaction",[buenos,civilian],_bandera]};
		};
	[_prestigeMalos,_prestigeMuyMalos] spawn prestige;
	waitUntil {sleep 1; ((spawner getVariable _marcador == 2)) or ({((_x getVariable ["BLUFORSpawn",false]) or (_x getVariable ["OPFORSpawn",false])) and ([_x,_marcador] call canConquer)} count allUnits > 3*({(side _x == buenos) and ([_x,_marcador] call canConquer)} count allUnits))};
	if (spawner getVariable _marcador != 2) then
		{
		sleep 10;
		[_marcador,buenos] remoteExec ["zoneCheck",2];
		};
	}
else
	{
	if (!isNull _bandera) then
		{
		if (_looser == buenos) then
			{
			[_bandera,"remove"] remoteExec ["flagaction",0,_bandera];
			sleep 2;
			[_bandera,"take"] remoteExec ["flagaction",[buenos,civilian],_bandera];
			};
		if (_winner == malos) then
			{
			[_bandera,"\A3\Data_F\Flags\Flag_NATO_CO.paa"] remoteExec ["setFlagTexture",_bandera];
			}
		else
			{
			[_bandera,"\A3\Data_F\Flags\Flag_CSAT_CO.paa"] remoteExec ["setFlagTexture",_bandera];
			};
		};
	IF (_looser == buenos) then {[_prestigeMalos,_prestigeMuyMalos] spawn prestige};
	};
if ((_winner != buenos) and (_looser != buenos)) then
	{
	if (_marcador in puestos) then
		{
		_cercanos = (puertos + recursos + fabricas) select {((getMarkerPos _x) distance _posicion < distanciaSPWN) and (lados getVariable [_x,sideUnknown] != buenos)};
		if (_looser == malos) then  {_cercanos = _cercanos select {lados getVariable [_x,sideUnknown] == malos}; _winner = "OPFORSpawn"} else {_cercanos = _cercanos select {lados getVariable [_x,sideUnknown] == muyMalos}; _winner = "BLUFORSpawn"};
		{[_winner,_x] spawn markerChange; sleep 5} forEach _cercanos;
		}
	else
		{
		if (_marcador in aeropuertos) then
			{
			_cercanos = (puertos + puestos) select {((getMarkerPos _x) distance _posicion < distanciaSPWN) and (lados getVariable [_x,sideUnknown] != buenos)};
			_cercanos append ((fabricas + recursos) select {(lados getVariable [_x,sideUnknown] != buenos) and (lados getVariable [_x,sideUnknown] != _winner) and ([aeropuertos,_x] call BIS_fnc_nearestPosition == _marcador)}); hint format ["%1",_cercanos];
			if (_looser == malos) then  {_cercanos = _cercanos select {lados getVariable [_x,sideUnknown] == malos}; _winner = "OPFORSpawn"} else {_cercanos = _cercanos select {lados getVariable [_x,sideUnknown] == muyMalos}; _winner = "BLUFORSpawn"};
			{[_winner,_x] spawn markerChange; sleep 5} forEach _cercanos;
			};
		};
	};
markersChanging = markersChanging - [_marcador];