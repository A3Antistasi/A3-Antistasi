if (!isServer) exitWith {};

private ["_tipo","_posbase","_posibles","_sitios","_exists","_sitio","_pos","_ciudad"];

_tipo = _this select 0;

_posbase = getMarkerPos respawnBuenos;
_posibles = [];
_sitios = [];
_exists = false;

_silencio = false;
if (count _this > 1) then {_silencio = true};

if ([_tipo] call BIS_fnc_taskExists) exitWith {if (!_silencio) then {[petros,"globalChat","I already gave you a mission of this type"] remoteExec ["commsMP",theBoss]}};

if (_tipo == "AS") then
	{
	_sitios = aeropuertos + ciudades + (controles select {!(isOnRoad getMarkerPos _x)});
	_sitios = _sitios select {lados getVariable [_x,sideUnknown] != buenos};
	if ((count _sitios > 0) and ({lados getVariable [_x,sideUnknown] == malos} count aeropuertos > 0)) then
		{
		//_posibles = _sitios select {((getMarkerPos _x distance _posbase < distanciaMiss) and (not(spawner getVariable _x)))};
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in controles) then
					{
					_marcadores = marcadores select {(getMarkerPos _x distance _pos < distanciaSPWN) and (lados getVariable [_x,sideUnknown] == buenos)};
					_marcadores = _marcadores - ["Synd_HQ"];
					_frontera = if (count _marcadores > 0) then {true} else {false};
					if (_frontera) then
						{
						_posibles pushBack _sitio;
						};
					}
				else
					{
					if (spawner getVariable _sitio == 2) then {_posibles pushBack _sitio};
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no assasination missions for you. Move our HQ closer to the enemy or finish some other assasination missions in order to have better intel"] remoteExec ["commsMP",theBoss];
			[petros,"hint","Assasination Missions require cities, Patrolled Jungles or Airports closer than 4Km from your HQ."] remoteExec ["commsMP",theBoss];
			};
		}
	else
		{
		_sitio = selectRandom _posibles;
		if (_sitio in aeropuertos) then {[[_sitio],"AS_Oficial"] remoteExec ["scheduler",2]} else {if (_sitio in ciudades) then {[[_sitio],"AS_Traidor"] remoteExec ["scheduler",2]} else {[[_sitio],"AS_SpecOP"] remoteExec ["scheduler",2]}};
		};
	};
if (_tipo == "CON") then
	{
	_sitios = (controles select {(isOnRoad (getMarkerPos _x))})+ puestos + recursos;
	_sitios = _sitios select {lados getVariable [_x,sideUnknown] != buenos};
	if (count _sitios > 0) then
		{
		_posibles = _sitios select {(getMarkerPos _x distance _posbase < distanciaMiss)};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no Conquest missions for you. Move our HQ closer to the enemy or finish some other conquest missions in order to have better intel."] remoteExec ["commsMP",theBoss];
			[petros,"hint","Conquest Missions require roadblocks or outposts closer than 4Km from your HQ."] remoteExec ["commsMP",theBoss];
			};
		}
	else
		{
		_sitio = selectRandom _posibles;
		[[_sitio],"CON_Puestos"] remoteExec ["scheduler",2];
		};
	};
if (_tipo == "DES") then
	{
	_sitios = aeropuertos select {lados getVariable [_x,sideUnknown] != buenos};
	_sitios = _sitios + antenas;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then {_pos = getMarkerPos _sitio} else {_pos = getPos _sitio};
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in marcadores) then
					{
					if (spawner getVariable _sitio == 2) then {_posibles pushBack _sitio};
					}
				else
					{
					_cercano = [marcadores, getPos _sitio] call BIS_fnc_nearestPosition;
					if (lados getVariable [_cercano,sideUnknown] == malos) then {_posibles pushBack _sitio};
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no destroy missions for you. Move our HQ closer to the enemy or finish some other destroy missions in order to have better intel"] remoteExec ["commsMP",theBoss];
			[petros,"hint","Destroy Missions require Airbases or Radio Towers closer than 4Km from your HQ."] remoteExec ["commsMP",theBoss];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in aeropuertos) then {if (random 10 < 8) then {[[_sitio],"DES_Vehicle"] remoteExec ["scheduler",2]} else {[[_sitio],"DES_Heli"] remoteExec ["scheduler",2]}};
		if (_sitio in antenas) then {[[_sitio],"DES_antena"] remoteExec ["scheduler",2]}
		};
	};
if (_tipo == "LOG") then
	{
	_sitios = puestos + ciudades - destroyedCities;
	_sitios = _sitios select {lados getVariable [_x,sideUnknown] != buenos};
	if (random 100 < 20) then {_sitios = _sitios + bancos};
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then
				{
				_pos = getMarkerPos _sitio;
				}
			else
				{
				_pos = getPos _sitio;
				};
			if (_pos distance _posbase < distanciaMiss) then
				{
				if (_sitio in ciudades) then
					{
					_datos = server getVariable _sitio;
					_prestigeOPFOR = _datos select 2;
					_prestigeBLUFOR = _datos select 3;
					if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
						{
						_posibles pushBack _sitio;
						};
					}
				else
					{
					if ([_pos,_posbase] call isTheSameIsland) then {_posibles pushBack _sitio};
					};
				};
			if (_sitio in bancos) then
				{
				_ciudad = [ciudades, _pos] call BIS_fnc_nearestPosition;
				if (lados getVariable [_ciudad,sideUnknown] == buenos) then {_posibles = _posibles - [_sitio]};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no logistics missions for you. Move our HQ closer to the enemy or finish some other logistics missions in order to have better intel"] remoteExec ["commsMP",theBoss];
			[petros,"hint","Logistics Missions require Outposts, Cities or Banks closer than 4Km from your HQ."] remoteExec ["commsMP",theBoss];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[[_sitio],"LOG_Suministros"] remoteExec ["scheduler",2]};
		if (_sitio in puestos) then {[[_sitio],"LOG_Ammo"] remoteExec ["scheduler",2]};
		if (_sitio in bancos) then {[[_sitio],"LOG_Bank"] remoteExec ["scheduler",2]};
		};
	};
if (_tipo == "RES") then
	{
	_sitios = aeropuertos + puestos + ciudades;
	_sitios = _sitios select {lados getVariable [_x,sideUnknown] != buenos};
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if (_sitio in ciudades) then {if (_pos distance _posbase < distanciaMiss) then {_posibles pushBack _sitio}} else {if ((_pos distance _posbase < distanciaMiss) and (spawner getVariable _sitio == 2)) then {_posibles = _posibles + [_sitio]}};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no rescue missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"] remoteExec ["commsMP",theBoss];
			[petros,"hint","Rescue Missions require Cities or Airports closer than 4Km from your HQ."] remoteExec ["commsMP",theBoss];
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[[_sitio],"RES_Refugiados"] remoteExec ["scheduler",2]} else {[[_sitio],"RES_Prisioneros"] remoteExec ["scheduler",2]};
		};
	};
if (_tipo == "CONVOY") then
	{
	if (!bigAttackInProgress) then
		{
		_sitios = (aeropuertos + recursos + fabricas + puertos + puestos - blackListDest) + (ciudades select {count (garrison getVariable [_x,[]]) < 10});
		_sitios = _sitios select {(lados getVariable [_x,sideUnknown] != buenos) and !(_x in blackListDest)};
		if (count _sitios > 0) then
			{
			for "_i" from 0 to ((count _sitios) - 1) do
				{
				_sitio = _sitios select _i;
				_pos = getMarkerPos _sitio;
				_base = [_sitio] call findBasesForConvoy;
				if ((_pos distance _posbase < (distanciaMiss*2)) and (_base !="")) then
					{
					if ((_sitio in ciudades) and (lados getVariable [_sitio,sideUnknown] == buenos)) then
						{
						if (lados getVariable [_base,sideUnknown] == malos) then
							{
							_datos = server getVariable _sitio;
							_prestigeOPFOR = _datos select 2;
							_prestigeBLUFOR = _datos select 3;
							if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
								{
								_posibles pushBack _sitio;
								};
							}
						}
					else
						{
						if (((lados getVariable [_sitio,sideUnknown] == malos) and (lados getVariable [_base,sideUnknown] == malos)) or ((lados getVariable [_sitio,sideUnknown] == muyMalos) and (lados getVariable [_base,sideUnknown] == muyMalos))) then {_posibles pushBack _sitio};
						};
					};
				};
			};
		if (count _posibles == 0) then
			{
			if (!_silencio) then
				{
				[petros,"globalChat","I have no Convoy missions for you. Move our HQ closer to the enemy or finish some other missions in order to have better intel"] remoteExec ["commsMP",theBoss];
				[petros,"hint","Convoy Missions require Airports or Cities closer than 5Km from your HQ, and they must have an idle friendly base in their surroundings."] remoteExec ["commsMP",theBoss];
				};
			}
		else
			{
			_sitio = _posibles call BIS_fnc_selectRandom;
			_base = [_sitio] call findBasesForConvoy;
			[[_sitio,_base],"CONVOY"] remoteExec ["scheduler",2];
			};
		}
	else
		{
		[petros,"globalChat","There is a big battle around, I don't think the enemy will send any convoy"] remoteExec ["commsMP",theBoss];
		[petros,"hint","Convoy Missions require a calmed status around the island, and now it is not the proper time."] remoteExec ["commsMP",theBoss];
		};
	};

if ((count _posibles > 0) and (!_silencio)) then {[petros,"globalChat","I have a mission for you"] remoteExec ["commsMP",theBoss]};