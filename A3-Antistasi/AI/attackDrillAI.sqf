private _grupo = _this;

_objetivos = _grupo call enemyList;
_grupo setVariable ["objetivos",_objetivos];
_grupo setVariable ["tarea","Patrol"];
private _lado = side _grupo;
private _friendlies = if (_lado == malos) then {[malos,civilian]} else {[_lado]};
_morteros = [];
_mgs = [];
_movable = [leader _grupo];
_baseOfFire = [leader _grupo];
_flankers = [];

{
if (alive _x) then
	{
	_result = _x call typeOfSoldier;
	_x setVariable ["maniobrando",false];
	if (_result == "Normal") then
		{
		_movable pushBack _x;
		_flankers pushBack _x;
		}
	else
		{
		if (_result == "StaticMortar") then
			{
			_morteros pushBack _x;
			}
		else
			{
			if (_result == "StaticGunner") then
				{
				_mgs pushBack _x;
				};
			_movable pushBack _x;
			_baseOfFire pushBack _x;
			};
		};
	};
} forEach (units _grupo);

if (count _morteros == 1) then
	{
	_morteros append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _morteros > 1) then
		{
		_morteros spawn mortarDrill;
		}
	else
		{
		_movable pushBack (_morteros select 0);
		_flankers pushBack (_morteros select 0);
		};
	};
if (count _mgs == 1) then
	{
	_mgs append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _mgs == 2) then
		{
		_mgs spawn staticMGDrill;
		}
	else
		{
		_movable pushBack (_mgs select 0);
		_flankers pushBack (_mgs select 0);
		};
	};

_grupo setVariable ["movable",_movable];
_grupo setVariable ["baseOfFire",_baseOfFire];
_grupo setVariable ["flankers",_flankers];

while {true} do
	{
	if (({alive _x} count (_grupo setVariable ["movable",[]]) == 0) or (isNull _grupo)) exitWith {};

	_objetivos = _grupo call enemyList;
	_grupo setVariable ["objetivos",_objetivos];
	if !(_objetivos isEqualTo []) then
		{
		_aire = objNull;
		_tanques = objNull;
		{
		_eny = assignedVehicle (_x select 4);
		if (_eny isKindOf "Tank") then
			{
			_tanques = _eny;
			}
		else
			{
			if (_eny isKindOf "Air") then
				{
				if (count (weapons _eny) > 1) then
					{
					_aire = _eny;
					};
				};
			};
		if (!(isNull _aire) and !(isNull _tanques)) exitWith {};
		} forEach _objetivos;
		_lider = leader _grupo;
		_allNearFriends = allUnits select {(_x distance _lider < (distanciaSPWN/2)) and (side _x in _friendlies) and ([_x] call canFight)};
		_numNearFriends = count _allNearFriends;
		_aire = objNull;
		_tanques = objNull;
		_numObjetivos = count _objetivos;
		_tarea = _grupo getVariable ["tarea","Patrol"];
		_cercano = _grupo call enemigoCercano;
		_soldados = ((units _grupo) select {[_x] call canFight}) - [_grupo getVariable ["mortero",objNull]];
		_numSoldados = count _soldados;
		if !(isNull _aire) then
			{
			if ({(_x call typeOfSoldier == "AAMan") or (_x call typeOfSoldier == "StaticGunner")} count _allNearFriends == 0) then
				{
				if (_lado != buenos) then {[[getPosASL _lider,_lado,"Air",false],"patrolCA"] remoteExec ["scheduler",2]};
				};
			//_nuevaTarea = ["Hide",_soldados - (_soldados select {(_x call typeOfSoldier == "AAMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner")})];
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};
		if !(isNull _tanques) then
			{
			if ({_x call typeOfSoldier == "ATMan"} count _allFriendlies == 0) then
				{
				_mortero = _grupo getVariable ["morteros",objNull];
				if (!(isNull _mortero) and ([_mortero] call canFight)) then
					{
					if ({if (_x distance _tanques < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _tanques,4] spawn mortarSupport};
					}
				else
					{
					if (_lado != buenos) then {[[getPosASL _lider,_lado,"Tank",false],"patrolCA"] remoteExec ["scheduler",2]};
					};
				};
			//_nuevaTarea = ["Hide",_soldados - (_soldados select {(_x getVariable ["typeOfSoldier",""] == "ATMan")})];
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};
		if (_numObjetivos > 2*_numNearFriends) then
			{
			if !(isNull _cercano) then
				{
				if (_lado != buenos) then {[[getPosASL _lider,_lado,"Normal",false],"patrolCA"] remoteExec ["scheduler",2]};
				_mortero = _grupo getVariable ["morteros",objNull];
				if (!(isNull _mortero) and ([_mortero] call canFight)) then
					{
					if ({if (_x distance _cercano < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _cercano,1] spawn mortarSupport};
					};
				};
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};


		if (_tarea == "Patrol") then
			{
			if ((_cercano distance _lider < 150) and !(isNull _cercano)) then
				{
				_grupo setVariable ["tarea","Assault"];
				_tarea = "Assault";
				}
			else
				{
				if (_numObjetivos > 1) then
					{
					_mortero = _grupo getVariable ["morteros",objNull];
					if (!(isNull _mortero) and ([_mortero] call canFight)) then
						{
						if ({if (_x distance _cercano < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _cercano,1] spawn mortarSupport};
						};
					};
				};
			};

		if (_tarea == "Assault") then
			{
			if (_cercano distance _lider < 50) then
				{
				_grupo setVariable ["tarea","AssaultClose"];
				_tarea = "AssaultClose";
				}
			else
				{
				if (_cercano distance _lider > 150) then
					{
					_grupo setVariable ["tarea","Patrol"];
					}
				else
					{
					if !(isNull _cercano) then
						{
						{
						[_x,_cercano] call fuegoSupresor;
						} forEach ((_grupo getVariable ["baseOfFire",[]]) select {([_x] call canFight) and ((_x getVariable ["typeOfSoldier",""] == "MGMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner"))});
						_mortero = _grupo getVariable ["morteros",objNull];
						if (!(isNull _mortero) and ([_mortero] call canFight)) then
							{
							if ({if (_x distance _cercano < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _cercano,1] spawn mortarSupport};
							};
						};
					};
				};
			};

		if (_tarea == "AssaultClose") then
			{
			if (_cercano distance _lider > 150) then
				{
				_grupo setVariable ["tarea","Patrol"];
				}
			else
				{
				if (_cercano distance _lider > 50) then
					{
					_grupo setVariable ["tarea","Assault"];
					}
				else
					{
					if !(isNull _cercano) then
						{
						_flankers = (_grupo getVariable ["flankers",[]]) select {([_x] call canFight) and !(_x getVariable ["maniobrando",false])};
						if (count _flankers != 0) then
							{
							{
							[_x,_x,_cercano] spawn cubrirConHumo;
							} forEach ((_grupo getVariable ["baseOfFire",[]]) select {([_x] call canFight) and (_x getVariable ["typeOfSoldier",""] == "Normal")});
							if ([getPosASL _cercano] call isBuildingPosition) then
								{
								_ingeniero = objNull;
								_building = nearestBuilding _cercano;
								if !(_building getVariable ["asaltado",false]) then
									{
									{
									if ((_x call typeOfSoldier == "Engineer") and {_x != leader _x} and {!(_x getVariable ["maniobrando",true])} and {_x distance _cercano < 50} and {[_x] call canFight}) exitWith {_ingeniero = _x};
									} forEach (_grupo getVariable ["baseOfFire",[]]);
									if !(isNull _ingeniero) then
										{
										[_ingeniero,_cercano,_building] spawn destroyBuilding;
										}
									else
										{
										[[_flankers,_cercano] call BIS_fnc_nearestPosition,_cercano,_building] spawn assaultBuilding;
										};
									};
								}
							else
								{
								[_flankers,_cercano] spawn doFlank;
								};
							};
						};
					};
				};
			};

		if (_tarea == "Hide") then
			{
			if ((isNull _tanques) and {isNull _aire} and {_numObjetivos <= 2*_numNearFriends}) then
				{
				_grupo setVariable ["tarea","Patrol"];
				}
			else
				{
				_movable = (_grupo getVariable ["movable",[]]) select {[_x] call canFight and !(_x getVariable ["maniobrando",false])};
				_movable spawn hideInBuilding;
				};
			};
		}
	else
		{
		if (_grupo getVariable ["tarea","Patrol"] != "Patrol") then
			{
			if (_grupo getVariable ["tarea","Patrol"] == "Hide") then {_grupo call recallGroup};
			_grupo setVariable ["tarea","Patrol"];
			};
		};

	sleep 30;
	};
