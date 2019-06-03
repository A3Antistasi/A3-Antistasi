//if (!isMultiplayer) exitWith {};
if ((side player == malos) or (side player == Invaders)) exitWith {};
private ["_puntos","_playerX","_puntosJ","_moneyJ"];
_puntos = _this select 0;
_playerX = _this select 1;

if (!isPlayer _playerX) exitWith {};

//if (rank _playerX == "COLONEL") exitWith {};
_playerX = _playerX getVariable ["owner",_playerX];
//if (typeName _playerX == typeName "") exitWith {diag_log format ["Antistasi Error: Intento de asignar puntos a un %1 siendo en realidad %2",_playerX, _this select 1]};
if (isMultiplayer) exitWith
	{
	_puntosJ = _playerX getVariable ["score",0];
	_moneyJ = _playerX getVariable ["moneyX",0];
	if (_puntos > 0) then
		{
		_moneyJ = _moneyJ + (_puntos * 10);
		_playerX setVariable ["moneyX",_moneyJ,true];
		if (_puntos > 1) then
			{
			_texto = format ["<br/><br/><br/><br/><br/><br/>Money +%1 €",_puntos*10];
			[petros,"income",_texto] remoteExec ["A3A_fnc_commsMP",_playerX];
			//[] remoteExec ["A3A_fnc_statistics",_playerX];
			};
		};
	_puntos = _puntos + _puntosJ;
	_playerX setVariable ["score",_puntos,true];
	};

if (_puntos > 0) then
	{
	if (_puntos != 1) then {[0,(_puntos * 5)] remoteExec ["A3A_fnc_resourcesFIA",2]} else {[0,20-(tierWar * 2)] remoteExec ["A3A_fnc_resourcesFIA",2]};
	};

