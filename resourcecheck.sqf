if (!isServer) exitWith{};

if (isMultiplayer) then {waitUntil {!isNil "switchCom"}};

private ["_texto"];
scriptName "resourcecheck";
while {true} do
	{
	sleep 600;//600
	if (isMultiplayer) then {waitUntil {sleep 10; isPlayer stavros}};

	_recAddSDK = 25;//0
	_hrAddBLUFOR = 0;//0
	_popFIA = 0;
	_popAAF = 0;
	_popCSAT = 0;
	_popTotal = 0;
	_bonusFIA = 1;
	{
	_ciudad = _x;
	_recAddCiudadSDK = 0;
	_hrAddCiudad = 0;
	_datos = server getVariable _ciudad;
	_numCiv = _datos select 0;
	_numVeh = _datos select 1;
	//_roads = _datos select 2;
	_prestigeNATO = _datos select 2;
	_prestigeSDK = _datos select 3;
	_power = [_ciudad] call powerCheck;
	_popTotal = _popTotal + _numCiv;
	_popFIA = _popFIA + (_numCiv * (_prestigeSDK / 100));
	_popAAF = _popAAF + (_numCiv * (_prestigeNATO / 100));
	_multiplicandorec = 1;
	if (not _power) then {_multiplicandorec = 0.5};

	if (_ciudad in destroyedCities) then
		{
		_recAddCiudadSDK = 0;
		_hrAddCiudad = 0;
		_popCSAT = _popCSAT + _numCIV;
		}
	else
		{
		_recAddCiudadSDK = ((_numciv * _multiplicandorec*(_prestigeSDK / 100))/3);
		_hrAddCiudad = (_numciv * (_prestigeSDK / 20000));
		if (_ciudad in mrkSDK) then
			{
			if (_power) then
				{
				if (_prestigeSDK + _prestigeNATO + 1 <= 100) then {[-1,1,_ciudad] spawn citySupportChange};
				}
			else
				{
				[0,-1,_ciudad] spawn citySupportChange;
				};
			}
		else
			{
			_recAddCiudadSDK = (_recAddCiudadSDK/2);
			_hrAddCiudad = (_hrAddCiudad/2);
			if (_power) then
				{
				if (_prestigeNATO + _prestigeSDK + 1 <= 100) then {[1,-1,_ciudad] spawn citySupportChange};
				}
			else
				{
				[-1,0,_ciudad] spawn citySupportChange
				};
			};
		};
	_recAddSDK = _recAddSDK + _recAddCiudadSDK;
	_hrAddBLUFOR = _hrAddBLUFOR + _hrAddCiudad;
	// revuelta civil!!
	if ((_prestigeNATO < _prestigeSDK) and (_ciudad in mrkNATO)) then
		{
		["TaskSucceeded", ["", format ["%1 joined SDK",[_ciudad, false] call fn_location]]] remoteExec ["BIS_fnc_showNotification",buenos];
		mrkNATO = mrkNATO - [_ciudad];
		mrkSDK = mrkSDK + [_ciudad];
		publicVariable "mrkNATO";
		publicVariable "mrkSDK";
		_nul = [5,0] remoteExec ["prestige",2];
		_mrkD = format ["Dum%1",_ciudad];
		_mrkD setMarkerColor colorBuenos;
		garrison setVariable [_ciudad,[],true];
		sleep 5;
		{_nul = [_ciudad,_x] spawn deleteControles} forEach controles;
		if ((!(["CONVOY"] call BIS_fnc_taskExists)) and (!bigAttackInProgress)) then
			{
			_base = [_ciudad] call findBasesForConvoy;
			if (_base != "") then
				{
				[_ciudad,_base] remoteExec ["CONVOY",HCattack];
				};
			};
		[] call tierCheck;
		};
	if ((_prestigeNATO > _prestigeSDK) and (_ciudad in mrkSDK)) then
		{
		["TaskFailed", ["", format ["%1 joined NATO",[_ciudad, false] call fn_location]]] remoteExec ["BIS_fnc_showNotification",buenos];
		mrkNATO = mrkNATO + [_ciudad];
		mrkSDK = mrkSDK - [_ciudad];
		publicVariable "mrkNATO";
		publicVariable "mrkSDK";
		_nul = [-5,0] remoteExec ["prestige",2];
		_mrkD = format ["Dum%1",_ciudad];
		_mrkD setMarkerColor colorMalos;
		garrison setVariable [_ciudad,[],true];
		sleep 5;
		[] call tierCheck;
		};
	} forEach ciudades;
	if (_popCSAT > (_popTotal / 3)) then {["destroyedCities",false,true] remoteExec ["BIS_fnc_endMission"]};
	if ((_popFIA > _popAAF) and ({_x in mrkSDK} count aeropuertos == count aeropuertos)) then {["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0]};
	{
	_fabrica = _x;
	if (_fabrica in mrkSDK) then
		{
		if (not(_fabrica in destroyedCities)) then {_bonusFIA = _bonusFIA + 0.25};
		};
	} forEach fabricas;

	{
	_recurso = _x;
	if (_recurso in mrkSDK) then
		{
		if (not(_recurso in destroyedCities)) then {_recAddSDK = _recAddSDK + (300 * _bonusFIA)};
		};
	} forEach recursos;
	_hrAddBLUFOR = (round _hrAddBLUFOR);
	_recAddSDK = (round _recAddSDK);

	_texto = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €",_hrAddBLUFOR,_recAddSDK];
	[] call FIAradio;
	//_updated = false;
	_updated = [] call arsenalManage;
	if (_updated != "") then {_texto = format ["%1<br/>Arsenal Updated<br/><br/>%2",_texto,_updated]};
	[petros,"taxRep",_texto] remoteExec ["commsMP",[buenos,civilian]];
	_hrAddBLUFOR = _hrAddBLUFOR + (server getVariable "hr");
	_recAddSDK = _recAddSDK + (server getVariable "resourcesFIA");
	server setVariable ["hr",_hrAddBLUFOR,true];
	server setVariable ["resourcesFIA",_recAddSDK,true];
	bombRuns = bombRuns + (({_x in mrkSDK} count aeropuertos) * 0.25);
	[petros,"taxRep",_texto] remoteExec ["commsMP",[buenos,civilian]];
	//[] remoteExec ["statistics",[buenos,civilian]];
	if (isMultiplayer) then {[] spawn assignStavros};
	if ((!bigAttackInProgress) and (random 100 < 50)) then {[] call missionRequestAUTO};
	[] remoteExec ["reinforcementsAI",hcAttack];
	/*
	_aiSkillLimit = ({_x in mrkSDK} count (aeropuertos + puestos + recursos + puertos));
	if (_aiSkillLimit < 2) then {_aiSkillLimit = 2};
	if (_aiSkillLimit != aiSkillLimit) then {aiSkillLimit = _aiSkillLimit; publicVariable "aiSkillLimit"};
	*/
	{
	_veh = _x;
	if ((_veh isKindOf "StaticWeapon") and ({isPlayer _x} count crew _veh == 0) and (alive _veh)) then
		{
		_veh setDamage 0;
		[_veh,1] remoteExec ["setVehicleAmmoDef",_veh];
		};
	} forEach vehicles;
	cuentaCA = cuentaCA - 600;
	if (cuentaCA < 0) then {cuentaCA = 0};
	publicVariable "cuentaCA";
	if ((cuentaCA == 0)/* and (diag_fps > minimoFPS)*/) then
		{
		[1200] remoteExec ["timingCA",2];
		if (!bigAttackInProgress) then
			{
			_script = [] spawn ataqueAAF;
			waitUntil {sleep 5; scriptDone _script};
			};
		};
	sleep 3;
	if ((count antenasMuertas > 0) and (not(["REP"] call BIS_fnc_taskExists))) then
		{
		_posibles = [];
		{
		_marcador = [marcadores, _x] call BIS_fnc_nearestPosition;
		if ((_marcador in mrkNATO) and (spawner getVariable _marcador == 2)) exitWith
			{
			_posibles pushBack [_marcador,_x];
			};
		} forEach antenasMuertas;
		if (count _posibles > 0) then
			{
			_posible = selectRandom _posibles;
			[_posible select 0,_posible select 1] remoteExec ["REP_Antena",HCattack];
			};
		}
	else
		{
		_cambiado = false;
		{
		_chance = 5;
		if ((_x in recursos) and (_x in mrkCSAT)) then {_chace = 20};
		if (random 100 < _chance) then
			{
			_cambiado = true;
			destroyedCities = destroyedCities - [_x];
			["TaskSucceeded", ["", format ["%1 Rebuilt",_nombre]]] remoteExec ["BIS_fnc_showNotification",[buenos,civilian]];
			sleep 2;
			};
		} forEach (destroyedCities - ciudades - mrkSDK);
		if (_cambiado) then {publicVariable "destroyedCities"};
		};
	sleep 4;
	};