private ["_unit","_enemiesX"];

_unit = _this select 0;

_unit setSkill 0;

_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
//Stops civilians from shouting out commands.
[_unit, "NoVoice"] remoteExec ["setSpeaker", 0, _unit];

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
	_victim = _this select 0;
	_killer = _this select 1;
	if (_victim == _killer) then
		{
		_nul = [-1,-1,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
		}
	else
		{
		if (isPlayer _killer) then
			{
			if (!isMultiPlayer) then
				{
				_nul = [0,20] remoteExec ["A3A_fnc_resourcesFIA",2];
				_killer addRating 1000;
				}
			else
				{
				if (typeOf _victim == "C_man_w_worker_F") then {_killer addRating 1000};
				[-10,_killer] call A3A_fnc_playerScoreAdd
				}
			};
		_multiplier = 1;
		if (typeOf _victim == "C_journalist_F") then {_multiplier = 10};
		if (side _killer == teamPlayer) then
			{
			_nul = [1*_multiplier,0] remoteExec ["A3A_fnc_prestige",2];
			_nul = [1,0,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
			}
		else
			{
			if (side _killer == Occupants) then
				{
				//_nul = [-1*_multiplier,0] remoteExec ["A3A_fnc_prestige",2];
				_nul = [0,1,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
				}
			else
				{
				if (side _killer == Invaders) then
					{
					//_nul = [2*_multiplier,0] remoteExec ["A3A_fnc_prestige",2];
					_nul = [-1,1,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
					};
				};
			};
		};
	}
	];
