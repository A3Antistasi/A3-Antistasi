if (!isServer) exitWith {};

private ["_typeX","_posbase","_potentials","_sites","_exists","_siteX","_pos","_city", "_internalDistance"];

_typeX = _this select 0;

_posbase = getMarkerPos respawnTeamPlayer;
_potentials = [];
_sites = [];
_exists = false;

_silencio = false;
_internalDistance = distanceMission;

if (count _this > 1) then
    {
    _silencio = true;
    _internalDistance = _internalDistance / 2;
    };

if ([_typeX] call BIS_fnc_taskExists) exitWith {if (!_silencio) then {[petros,"globalChat","I already gave you a mission of this type"] remoteExec ["A3A_fnc_commsMP",theBoss]}};

if (_typeX == "AS") then
	{
	_sites = airportsX + citiesX + (controlsX select {!(isOnRoad getMarkerPos _x)});
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if ((count _sites > 0) and ({sidesX getVariable [_x,sideUnknown] == Occupants} count airportsX > 0)) then
		{
		//_potentials = _sites select {((getMarkerPos _x distance _posbase < _internalDistance) and (not(spawner getVariable _x)))};
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			_pos = getMarkerPos _siteX;
			if (_pos distance _posbase < _internalDistance) then
				{
				if (_siteX in controlsX) then
					{
					_markersX = markersX select {(getMarkerPos _x distance _pos < distanceSPWN) and (sidesX getVariable [_x,sideUnknown] == teamPlayer)};
					_markersX = _markersX - ["Synd_HQ"];
					_frontierX = if (count _markersX > 0) then {true} else {false};
					if (_frontierX) then
						{
						_potentials pushBack _siteX;
						};
					}
				else
					{
					if (spawner getVariable _siteX == 2) then {_potentials pushBack _siteX};
					};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no assasination missions for you. Move our HQ closer to the enemy or finish some other assasination missions in order to have better intel"] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Assasination Missions require cities, Patrolled Jungles or Airports closer than 4Km from your HQ."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		if (_siteX in airportsX) then {[[_siteX],"AS_Official"] remoteExec ["A3A_fnc_scheduler",2]} else {if (_siteX in citiesX) then {[[_siteX],"AS_Traitor"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"AS_SpecOP"] remoteExec ["A3A_fnc_scheduler",2]}};
		};
	};
if (_typeX == "CON") then
	{
	_sites = (controlsX select {(isOnRoad (getMarkerPos _x))})+ outposts + resourcesX;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (count _sites > 0) then
		{
		_potentials = _sites select {(getMarkerPos _x distance _posbase < _internalDistance)};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no Conquest missions for you. Move our HQ closer to the enemy or finish some other conquest missions in order to have better intel."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Conquest Missions require roadblocks or outposts closer than 4Km from your HQ."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		[[_siteX],"CON_Outpost"] remoteExec ["A3A_fnc_scheduler",2];
		};
	};
if (_typeX == "DES") then
	{
	_sites = airportsX select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	_sites = _sites + antennas;
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			if (_siteX in markersX) then {_pos = getMarkerPos _siteX} else {_pos = getPos _siteX};
			if (_pos distance _posbase < _internalDistance) then
				{
				if (_siteX in markersX) then
					{
					if (spawner getVariable _siteX == 2) then {_potentials pushBack _siteX};
					}
				else
					{
					_nearX = [markersX, getPos _siteX] call BIS_fnc_nearestPosition;
					if (sidesX getVariable [_nearX,sideUnknown] == Occupants) then {_potentials pushBack _siteX};
					};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no destroy missions for you. Move our HQ closer to the enemy or finish some other destroy missions in order to have better intel"] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Destroy Missions require Airbases or Radio Towers closer than 4Km from your HQ."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = _potentials call BIS_fnc_selectRandom;
		if (_siteX in airportsX) then {if (random 10 < 8) then {[[_siteX],"DES_Vehicle"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"DES_Heli"] remoteExec ["A3A_fnc_scheduler",2]}};
		if (_siteX in antennas) then {[[_siteX],"DES_antenna"] remoteExec ["A3A_fnc_scheduler",2]}
		};
	};
if (_typeX == "LOG") then
	{
	_sites = outposts + citiesX - destroyedCities;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (random 100 < 20) then {_sites = _sites + banks};
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			if (_siteX in markersX) then
				{
				_pos = getMarkerPos _siteX;
				}
			else
				{
				_pos = getPos _siteX;
				};
			if (_pos distance _posbase < _internalDistance) then
				{
				if (_siteX in citiesX) then
					{
					_dataX = server getVariable _siteX;
					_prestigeOPFOR = _dataX select 2;
					_prestigeBLUFOR = _dataX select 3;
					if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
						{
						_potentials pushBack _siteX;
						};
					}
				else
					{
					if ([_pos,_posbase] call A3A_fnc_isTheSameIsland) then {_potentials pushBack _siteX};
					};
				};
			if (_siteX in banks) then
				{
				_city = [citiesX, _pos] call BIS_fnc_nearestPosition;
				if (sidesX getVariable [_city,sideUnknown] == teamPlayer) then {_potentials = _potentials - [_siteX]};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no logistics missions for you. Move our HQ closer to the enemy or finish some other logistics missions in order to have better intel"] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Logistics Missions require Outposts, Cities or Banks closer than 4Km from your HQ."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = _potentials call BIS_fnc_selectRandom;
		if (_siteX in citiesX) then {[[_siteX],"LOG_Supplies"] remoteExec ["A3A_fnc_scheduler",2]};
		if (_siteX in outposts) then {[[_siteX],"LOG_Ammo"] remoteExec ["A3A_fnc_scheduler",2]};
		if (_siteX in banks) then {[[_siteX],"LOG_Bank"] remoteExec ["A3A_fnc_scheduler",2]};
		};
	};
if (_typeX == "RES") then
	{
	_sites = airportsX + outposts + citiesX;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			_pos = getMarkerPos _siteX;
			if (_siteX in citiesX) then {if (_pos distance _posbase < _internalDistance) then {_potentials pushBack _siteX}} else {if ((_pos distance _posbase < _internalDistance) and (spawner getVariable _siteX == 2)) then {_potentials = _potentials + [_siteX]}};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","I have no rescue missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Rescue Missions require Cities or Airports closer than 4Km from your HQ."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = _potentials call BIS_fnc_selectRandom;
		if (_siteX in citiesX) then {[[_siteX],"RES_Refugees"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"RES_Prisoners"] remoteExec ["A3A_fnc_scheduler",2]};
		};
	};
if (_typeX == "CONVOY") then
	{
	if (!bigAttackInProgress) then
		{
		_sites = (airportsX + resourcesX + factories + seaports + outposts - blackListDest) + (citiesX select {count (garrison getVariable [_x,[]]) < 10});
		_sites = _sites select {(sidesX getVariable [_x,sideUnknown] != teamPlayer) and !(_x in blackListDest)};
		if (count _sites > 0) then
			{
			for "_i" from 0 to ((count _sites) - 1) do
				{
				_siteX = _sites select _i;
				_pos = getMarkerPos _siteX;
				_base = [_siteX] call A3A_fnc_findBasesForConvoy;
				if ((_pos distance _posbase < (_internalDistance*2)) and (_base !="")) then
					{
					if ((_siteX in citiesX) and (sidesX getVariable [_siteX,sideUnknown] == teamPlayer)) then
						{
						if (sidesX getVariable [_base,sideUnknown] == Occupants) then
							{
							_dataX = server getVariable _siteX;
							_prestigeOPFOR = _dataX select 2;
							_prestigeBLUFOR = _dataX select 3;
							if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
								{
								_potentials pushBack _siteX;
								};
							}
						}
					else
						{
						if (((sidesX getVariable [_siteX,sideUnknown] == Occupants) and (sidesX getVariable [_base,sideUnknown] == Occupants)) or ((sidesX getVariable [_siteX,sideUnknown] == Invaders) and (sidesX getVariable [_base,sideUnknown] == Invaders))) then {_potentials pushBack _siteX};
						};
					};
				};
			};
		if (count _potentials == 0) then
			{
			if (!_silencio) then
				{
				[petros,"globalChat","I have no Convoy missions for you. Move our HQ closer to the enemy or finish some other missions in order to have better intel"] remoteExec ["A3A_fnc_commsMP",theBoss];
				[petros,"hint","Convoy Missions require Airports or Cities closer than 5Km from your HQ, and they must have an idle friendly base in their surroundings."] remoteExec ["A3A_fnc_commsMP",theBoss];
				};
			}
		else
			{
			_siteX = _potentials call BIS_fnc_selectRandom;
			_base = [_siteX] call A3A_fnc_findBasesForConvoy;
			[[_siteX,_base],"CONVOY"] remoteExec ["A3A_fnc_scheduler",2];
			};
		}
	else
		{
		[petros,"globalChat","There is a big battle around, I don't think the enemy will send any convoy"] remoteExec ["A3A_fnc_commsMP",theBoss];
		[petros,"hint","Convoy Missions require a calmed status around the island, and now it is not the proper time."] remoteExec ["A3A_fnc_commsMP",theBoss];
		};
	};

if ((count _potentials > 0) and (!_silencio)) then {[petros,"globalChat","I have a mission for you"] remoteExec ["A3A_fnc_commsMP",theBoss]};
