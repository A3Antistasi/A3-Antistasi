//if (!isMultiplayer) exitWith {};
if ((side player == Occupants) or (side player == Invaders)) exitWith {};
private ["_pointsX","_playerX","_pointsXJ","_moneyJ","_kills"];
_pointsX = _this select 0;
_playerX = _this select 1;

if (!isPlayer _playerX) exitWith {};

//if (rank _playerX == "COLONEL") exitWith {};
_playerX = _playerX getVariable ["owner",_playerX];
//if (typeName _playerX == typeName "") exitWith {diag_log format ["Antistasi Error: Intento de asignar pointsX a un %1 siendo en realidad %2",_playerX, _this select 1]};
if (isMultiplayer) exitWith
	{
	_pointsXJ = _playerX getVariable ["score",0];
	_moneyJ = _playerX getVariable ["moneyX",0];
	_kills = _playerX getVariable ["kills", 0];
	if (_pointsX > 0) then
		{
		_moneyJ = _moneyJ + (_pointsX * 10);
		_playerX setVariable ["moneyX",_moneyJ,true];
		if (_pointsX > 1) then
			{
			_textX = format ["<br/><br/><br/><br/><br/><br/>Money +%1 €",_pointsX*10];
			[petros,"income",_textX] remoteExec ["A3A_fnc_commsMP",_playerX];
			//[] remoteExec ["A3A_fnc_statistics",_playerX];
			};
		};
	_pointsX = _pointsX + _pointsXJ;
	_playerX setVariable ["score",_pointsX,true];
	if (_pointsX == 1) then
	    {
	    diag_log format ["%1: [Antistasi] | INFO | Adding kills to player",servertime];
	    _playerX setVariable ["kills", _kills + 1, true];
	    };
	};

if (_pointsX > 0) then
	{
	if (_pointsX != 1) then {[0,(_pointsX * 5)] remoteExec ["A3A_fnc_resourcesFIA",2]} else {[0,20-(tierWar * 2)] remoteExec ["A3A_fnc_resourcesFIA",2]};
	};

