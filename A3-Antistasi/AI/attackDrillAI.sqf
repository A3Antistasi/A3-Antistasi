private _grupo = _this;
_objectivesX = _grupo call A3A_fnc_enemyList;
_grupo setVariable ["objectivesX",_objectivesX];
_grupo setVariable ["tarea","Patrol"];
private _lado = side _grupo;
private _friendlies = if ((_lado == malos) or (_lado == buenos)) then {[_lado,civilian]} else {[_lado]};
_morteros = [];
_mgs = [];
_movable = [leader _group];
_baseOfFire = [leader _group];
_flankers = [];

{
if (alive _x) then
	{
	_result = _x call A3A_fnc_typeOfSoldier;
	_x setVariable ["maneuvering",false];
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
} forEach (units _group);

if (count _morteros == 1) then
	{
	_morteros append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _morteros > 1) then
		{
		//_morteros spawn A3A_fnc_mortarDrill;
		_morteros spawn A3A_fnc_staticMGDrill;//no olvides borrar la otra función si esto funciona
		}
	else
		{
		_movable pushBack (_morteros select 0);
		_flankers pushBack (_morteros select 0);
		};
	};
if (count _mgs == 1) then
	{
	_mgs append ((units _group) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _mgs == 2) then
		{
		_mgs spawn A3A_fnc_staticMGDrill;
		}
	else
		{
		_movable pushBack (_mgs select 0);
		_flankers pushBack (_mgs select 0);
		};
	};

_group setVariable ["movable",_movable];
_group setVariable ["baseOfFire",_baseOfFire];
_group setVariable ["flankers",_flankers];
if (side _group == teamPlayer) then {_group setVariable ["autoRearmed",time + 300]};
{
if (vehicle _x != _x) then
	{
	if !(vehicle _x isKindOf "Air") then
		{
		if ((assignedVehicleRole _x) select 0 == "Cargo") then
			{
			if (isNull(_group getVariable ["transporte",objNull])) then {_group setVariable ["transporte",vehicle _x]};
			};
		};
	};
} forEach units _group;

while {true} do
	{
	if !(isPlayer (leader _group)) then
		{
		_movable = _movable select {[_x] call A3A_fnc_canFight};
		_baseOfFire = _baseOfFire select {[_x] call A3A_fnc_canFight};
		_flankers = _flankers select {[_x] call A3A_fnc_canFight};
		_objectivesX = _group call A3A_fnc_enemyList;
		_group setVariable ["objectivesX",_objectivesX];
		if !(_objectivesX isEqualTo []) then
			{
			_aire = objNull;
			_tanksX = objNull;
			{
			_eny = assignedVehicle (_x select 4);
			if (_eny isKindOf "Tank") then
				{
				_tanksX = _eny;
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
			if (!(isNull _aire) and !(isNull _tanksX)) exitWith {};
			} forEach _objectivesX;
			_LeaderX = leader _group;
			_allNearFriends = allUnits select {(_x distance _LeaderX < (distanceSPWN/2)) and (side group _x in _friendlies)};
			{
			_unit = _x;
			{
			_objetivo = _x select 4;
			if (_lider knowsAbout _objetivo >= 1.4) then
				{
				_know = _unit knowsAbout _objetivo;
				if (_know < 1.2) then {_unit reveal [_objetivo,(_know + 0.2)]};
				};
			} forEach _objectivesX;
			} forEach (_allNearFriends select {_x == leader _x}) - [_LeaderX];
			_numNearFriends = count _allNearFriends;
			//_aire = objNull;
			//_tanksX = objNull;
			_numObjectives = count _objectivesX;
			_tarea = _grupo getVariable ["tarea","Patrol"];
			_cercano = _grupo call A3A_fnc_nearEnemy;
			_soldados = ((units _grupo) select {[_x] call A3A_fnc_canFight}) - [_grupo getVariable ["mortero",objNull]];
			_numSoldiers = count _soldados;
			if !(isNull _aire) then
				{
				if (_allNearFriends findIf {(_x call A3A_fnc_typeOfSoldier == "AAMan") or (_x call A3A_fnc_typeOfSoldier == "StaticGunner")} == -1) then
					{
					if (_lado != teamPlayer) then {[[getPosASL _LeaderX,_lado,"Air",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
					};
				//_nuevaTarea = ["Hide",_soldados - (_soldados select {(_x call A3A_fnc_typeOfSoldier == "AAMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner")})];
				_grupo setVariable ["tarea","Hide"];
				_tarea = "Hide";
				};
			if !(isNull _tanksX) then
				{
				if (_allNearFriends findIf {_x call A3A_fnc_typeOfSoldier == "ATMan"} == -1) then
					{
					_mortero = _grupo getVariable ["morteros",objNull];
					if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
						{
						if ({if (_x distance _tanksX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortarX,getPosASL _tanksX,4] spawn A3A_fnc_mortarSupport};
						}
					else
						{
						if (_lado != teamPlayer) then {[[getPosASL _LeaderX,_lado,"Tank",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
						};
					};
				//_nuevaTarea = ["Hide",_soldados - (_soldados select {(_x getVariable ["typeOfSoldier",""] == "ATMan")})];
				_grupo setVariable ["tarea","Hide"];
				_tarea = "Hide";
				};
			if (_numObjectives > 2*_numNearFriends) then
				{
				if !(isNull _nearX) then
					{
					if (_lado != buenos) then {[[getPosASL _lider,_lado,"Normal",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
					_mortero = _grupo getVariable ["morteros",objNull];
					if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
						{
						if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortarX,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
						};
					};
				_group setVariable ["tarea","Hide"];
				_tarea = "Hide";
				};
			_transporte = _group getVariable ["transporte",objNull];
			if (isNull(_group getVariable ["transporte",objNull])) then
				{
				_exit = false;
				{
				_veh = vehicle _x;
				if (_veh != _x) then
					{
					if !(_veh isKindOf "Air") then
						{
						if ((assignedVehicleRole _x) select 0 == "Cargo") then
							{
							_group setVariable ["transporte",_veh];
							_transporte = _veh;
							_exit = true;
							};
						};
					};
				if (_exit) exitWith {};
				} forEach units _group;
				};
			if !(isNull(_transporte)) then
				{
				if !(_transporte isKindOf "Tank") then
					{
					_driver = driver (_transporte);
					if !(isNull _driver) then
						{
						[_driver]  allowGetIn false;
						};
					};
				(units _group select {(assignedVehicleRole _x) select 0 == "Cargo"}) allowGetIn false;
				};

			if (_tarea == "Patrol") then
				{
				if ((_nearX distance _LeaderX < 150) and !(isNull _nearX)) then
					{
					_group setVariable ["tarea","Assault"];
					_tarea = "Assault";
					}
				else
					{
					if (_numObjectives > 1) then
						{
						_mortero = _grupo getVariable ["morteros",objNull];
						if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
							{
							if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortarX,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
							};
						};
					};
				};

			if (_tarea == "Assault") then
				{
				if (_nearX distance _LeaderX < 50) then
					{
					_group setVariable ["tarea","AssaultClose"];
					_tarea = "AssaultClose";
					}
				else
					{
					if (_nearX distance _LeaderX > 150) then
						{
						_group setVariable ["tarea","Patrol"];
						}
					else
						{
						if !(isNull _nearX) then
							{
							{
							[_x,_nearX] call A3A_fnc_suppressingFire;
							} forEach _baseOfFire select {(_x getVariable ["typeOfSoldier",""] == "MGMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner")};
							if (sunOrMoon < 1) then
								{
								if !(haveNV) then
									{
									if (hasIFA) then
										{
										if (([_LeaderX] call A3A_fnc_canFight) and ((typeOf _LeaderX) in squadLeaders)) then {[_LeaderX,_nearX] call A3A_fnc_useFlares}
										}
									else
										{
										{
										[_x,_nearX] call A3A_fnc_suppressingFire;
										} forEach _baseOfFire select {(_x getVariable ["typeOfSoldier",""] == "Normal") and (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)};
										};
									};
								};
							_mortero = _grupo getVariable ["morteros",objNull];
							if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
								{
								if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortarX,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
								};
							};
						};
					};
				};

			if (_tarea == "AssaultClose") then
				{
				if (_nearX distance _LeaderX > 150) then
					{
					_group setVariable ["tarea","Patrol"];
					}
				else
					{
					if (_nearX distance _LeaderX > 50) then
						{
						_group setVariable ["tarea","Assault"];
						}
					else
						{
						if !(isNull _nearX) then
							{
							_flankers = _flankers select {!(_x getVariable ["maneuvering",false])};
							if (count _flankers != 0) then
								{
								{
								[_x,_x,_nearX] spawn A3A_fnc_chargeWithSmoke;
								} forEach (_baseOfFire select {(_x getVariable ["typeOfSoldier",""] == "Normal")});
								if ([getPosASL _nearX] call A3A_fnc_isBuildingPosition) then
									{
									_engineerX = objNull;
									_building = nearestBuilding _nearX;
									if !(_building getVariable ["assaulted",false]) then
										{
										{
										if ((_x call A3A_fnc_typeOfSoldier == "Engineer") and {_x != leader _x} and {!(_x getVariable ["maneuvering",true])} and {_x distance _nearX < 50}) exitWith {_engineerX = _x};
										} forEach _baseOfFire;
										if !(isNull _engineerX) then
											{
											[_engineerX,_nearX,_building] spawn A3A_fnc_destroyBuilding;
											}
										else
											{
											[[_flankers,_nearX] call BIS_fnc_nearestPosition,_nearX,_building] spawn A3A_fnc_assaultBuilding;
											};
										};
									}
								else
									{
									[_flankers,_nearX] spawn A3A_fnc_doFlank;
									};
								};
							};
						};
					};
				};

			if (_tarea == "Hide") then
				{
				if ((isNull _tanksX) and {isNull _aire} and {_numObjectives <= 2*_numNearFriends}) then
					{
					_group setVariable ["tarea","Patrol"];
					}
				else
					{
					_movable = _movable select {!(_x getVariable ["maneuvering",false])};
					_movable spawn A3A_fnc_hideInBuilding;
					};
				};
			}
		else
			{
			if (_group getVariable ["tarea","Patrol"] != "Patrol") then
				{
				if (_group getVariable ["tarea","Patrol"] == "Hide") then {_group call A3A_fnc_recallGroup};
				_group setVariable ["tarea","Patrol"];
				};
			if (side _group == teamPlayer) then
				{
				if (time >= _group getVariable ["autoRearm",time]) then
					{
					_group setVariable ["autoRearm",time + 120];
					{[_x] spawn A3A_fnc_autoRearm; sleep 1} forEach (_movable select {!(_x getVariable ["maneuvering",false])});
					};
				};
			if !(isNull(_group getVariable ["transporte",objNull])) then
				{
				(units _group select {vehicle _x == _x}) allowGetIn true;
				};
			};
		//diag_log format ["Tarea:%1.Movable:%2.Base:%3.Flankers:%4",_group getVariable "tarea",_group getVariable "movable",_group getVariable "baseOfFire",_group getVariable "flankers"];
		sleep 30;
		_movable =  (_group getVariable ["movable",[]]) select {alive _x};
		if ((_movable isEqualTo []) or (isNull _group)) exitWith {};
		_group setVariable ["movable",_movable];
		_baseOfFire = (_group getVariable ["baseOfFire",[]]) select {alive _x};
		_group setVariable ["baseOfFire",_baseOfFire];
		_flankers = (_group getVariable ["flankers",[]]) select {alive _x};
		_group setVariable ["flankers",_flankers];
		};
	};
