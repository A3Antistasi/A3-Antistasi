private ["_unit","_enemigos"];

_unit = _this select 0;

_unit setSkill 0;

_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit addEventHandler ["HandleDamage",
	{
	_dam = _this select 2;
	_proy = _this select 4;
	if (_proy == "") then
		{
		_injurer = _this select 3;
		if ((_dam > 0.95) and (!isPlayer _injurer)) then {_dam = 0.9};
		};
	_dam
	}
	];
_EHkilledIdx = _unit addEventHandler ["killed",
	{
	_muerto = _this select 0;
	_killer = _this select 1;
	if (_muerto == _killer) then
		{
		_nul = [-1,-1,getPos _muerto] remoteExec ["citySupportChange",2];
		}
	else
		{
		if (isPlayer _killer) then
			{
			if (!isMultiPlayer) then
				{
				_nul = [0,20] remoteExec ["resourcesFIA",2];
				_killer addRating 1000;
				}
			else
				{
				if (typeOf _muerto == "C_man_w_worker_F") then {_killer addRating 1000};
				[-10,_killer] call playerScoreAdd
				}
			};
		_multiplicador = 1;
		if (typeOf _muerto == "C_journalist_F") then {_multiplicador = 10};
		if (side _killer == buenos) then
			{
			_nul = [1*_multiplicador,0] remoteExec ["prestige",2];
			_nul = [1,0,getPos _muerto] remoteExec ["citySupportChange",2];
			}
		else
			{
			if (side _killer == malos) then
				{
				//_nul = [-1*_multiplicador,0] remoteExec ["prestige",2];
				_nul = [0,1,getPos _muerto] remoteExec ["citySupportChange",2];
				}
			else
				{
				if (side _killer == muyMalos) then
					{
					//_nul = [2*_multiplicador,0] remoteExec ["prestige",2];
					_nul = [-1,1,getPos _muerto] remoteExec ["citySupportChange",2];
					};
				};
			};
		};
	}
	];
/*
if (typeOf _unit == "C_man_w_worker_F") then
	{
	if (side _unit == civilian) then {_enemigos = ([distanciaSPWN,0,_unit,"GREENFORSpawn"] call distanceUnits)} else {_enemigos = [distanciaSPWN,0,_unit,"OPFORSpawn"] call distanceUnits};
	waitUntil {sleep 1;(not (alive _unit)) or (fleeing _unit)};

	if ((alive _unit) and ({_x distance _unit < 300} count _enemigos > 0) and (vehicle _unit == _unit)) then
		{
		_unit setCaptive true;
		_unit stop true;
		_unit disableAI "MOVE";
		_unit disableAI "AUTOTARGET";
		_unit disableAI "TARGET";
		_unit setUnitPos "UP";
		_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
		};
	};