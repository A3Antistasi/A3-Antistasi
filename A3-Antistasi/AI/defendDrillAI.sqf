private _grupo = _this select 0;
private _markerX = _this select 1;
private _modo = _this select 2;
_objectivesX = _grupo call A3A_fnc_enemyList;
_grupo setVariable ["objectivesX",_objectivesX];
private _size = [_markerX] call A3A_fnc_sizeMarker;
if (_modo != "FORTIFY") then {_grupo setVariable ["tarea","PatrolSoft"]} else {_grupo setVariable ["tarea","FORTIFY"]};
private _lado = side _grupo;
private _friendlies = if (_lado == malos) then {[malos,civilian]} else {[_lado]};
private _mortarsX = [];
private _mgs = [];
private _movable = [leader _grupo];
private _baseOfFire = [leader _grupo];

{
if (alive _x) then
	{
	_result = _x call A3A_fnc_typeOfSoldier;
	_x setVariable ["maneuvering",false];
	if (_result == "Normal") then
		{
		_movable pushBack _x;
		}
	else
		{
		if (_result == "StaticMortar") then
			{
			_mortarsX pushBack _x;
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

if (count _mortarsX == 1) then
	{
	_mortarsX append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _mortarsX > 1) then
		{
		//_mortarsX spawn A3A_fnc_mortarDrill;
		_mortarsX spawn A3A_fnc_staticMGDrill;//no olvides borrar la otra función si esto funciona
		}
	else
		{
		_movable pushBack (_mortarsX select 0);
		};
	};
if (count _mgs == 1) then
	{
	_mgs append ((units _grupo) select {_x getVariable ["typeOfSoldier",""] == "StaticBase"});
	if (count _mgs == 2) then
		{
		_mgs spawn A3A_fnc_staticMGDrill;
		}
	else
		{
		_movable pushBack (_mgs select 0);
		};
	};

_grupo setVariable ["movable",_movable];
_grupo setVariable ["baseOfFire",_baseOfFire];
if (side _grupo == buenos) then {_grupo setVariable ["autoRearmed",time + 300]};
_buildingsX = nearestTerrainObjects [getMarkerPos _markerX, ["House"],true];
_buildingsX = _buildingsX select {((_x buildingPos -1) isEqualTo []) and !((typeof _bld) in UPSMON_Bld_remove) and (_x inArea _markerX)};

if (_modo == "FORTIFY") then
	{
	_buildingsX = _buildingsX call BIS_fnc_arrayShuffle;
	_bldPos = [];
	_cuenta = count _movable;
	_exit = false;
	{
	_edificio = _x;
	if (_exit) exitWith {};
	{
	if ([_x] call isOnRoof) then
		{
		_bldPos pushBack _x;
		if (count _bldPos == _cuenta) then {_exit = true};
		};
	} forEach (_edificio buildingPos -1);
	} forEach _buildingsX;
	};
while {true} do
	{
	if (({alive _x} count (_grupo getVariable ["movable",[]]) == 0) or (isNull _grupo)) exitWith {};

	_objectivesX = _grupo call A3A_fnc_enemyList;
	_grupo setVariable ["objectivesX",_objectivesX];
	if !(_objectivesX isEqualTo []) then
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
		} forEach _objectivesX;
		_lider = leader _grupo;
		_allNearFriends = allUnits select {(_x distance _lider < (distanceSPWN/2)) and (side _x in _friendlies) and ([_x] call A3A_fnc_canFight)};
		{
		_unit = _x;
		{
		_objectiveX = _x select 4;
		if (_lider knowsAbout _objectiveX >= 1.4) then
			{
			_know = _unit knowsAbout _objectiveX;
			if (_know < 1.2) then {_unit reveal [_objectiveX,(_know + 0.2)]};
			};
		} forEach _objectivesX;
		} forEach (_allNearFriends select {_x == leader _x}) - [_lider];
		_numNearFriends = count _allNearFriends;
		_aire = objNull;
		_tanques = objNull;
		_numObjectives = count _objectivesX;
		_tarea = _grupo getVariable ["tarea","Patrol"];
		_nearX = _grupo call A3A_fnc_nearEnemy;
		_soldiers = ((units _grupo) select {[_x] call A3A_fnc_canFight}) - [_grupo getVariable ["mortero",objNull]];
		_numSoldiers = count _soldiers;
		if !(isNull _aire) then
			{
			if ({(_x call A3A_fnc_typeOfSoldier == "AAMan") or (_x call A3A_fnc_typeOfSoldier == "StaticGunner")} count _allNearFriends == 0) then
				{
				if (_lado != buenos) then {[[getPosASL _lider,_lado,"Air",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
				};
			//_nuevaTarea = ["Hide",_soldiers - (_soldiers select {(_x call A3A_fnc_typeOfSoldier == "AAMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner")})];
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};
		if !(isNull _tanques) then
			{
			if ({_x call A3A_fnc_typeOfSoldier == "ATMan"} count _allFriendlies == 0) then
				{
				_mortero = _grupo getVariable ["mortarsX",objNull];
				if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
					{
					if ({if (_x distance _tanques < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _tanques,4] spawn A3A_fnc_mortarSupport};
					}
				else
					{
					if (_lado != buenos) then {[[getPosASL _lider,_lado,"Tank",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
					};
				};
			//_nuevaTarea = ["Hide",_soldiers - (_soldiers select {(_x getVariable ["typeOfSoldier",""] == "ATMan")})];
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};
		if (_numObjectives > 2*_numNearFriends) then
			{
			if !(isNull _nearX) then
				{
				if (_lado != buenos) then {[[getPosASL _lider,_lado,"Normal",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]};
				_mortero = _grupo getVariable ["mortarsX",objNull];
				if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
					{
					if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
					};
				};
			_grupo setVariable ["tarea","Hide"];
			_tarea = "Hide";
			};


		if (_tarea == "Patrol") then
			{
			if ((_nearX distance _lider < 150) and !(isNull _nearX)) then
				{
				_grupo setVariable ["tarea","Assault"];
				_tarea = "Assault";
				}
			else
				{
				if (_numObjectives > 1) then
					{
					_mortero = _grupo getVariable ["mortarsX",objNull];
					if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
						{
						if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
						};
					};
				};
			};

		if (_tarea == "Assault") then
			{
			if (_nearX distance _lider < 50) then
				{
				_grupo setVariable ["tarea","AssaultClose"];
				_tarea = "AssaultClose";
				}
			else
				{
				if (_nearX distance _lider > 150) then
					{
					_grupo setVariable ["tarea","Patrol"];
					}
				else
					{
					if !(isNull _nearX) then
						{
						{
						[_x,_nearX] call A3A_fnc_suppressingFire;
						} forEach ((_grupo getVariable ["baseOfFire",[]]) select {([_x] call A3A_fnc_canFight) and ((_x getVariable ["typeOfSoldier",""] == "MGMan") or (_x getVariable ["typeOfSoldier",""] == "StaticGunner"))});
						_mortero = _grupo getVariable ["mortarsX",objNull];
						if (!(isNull _mortero) and ([_mortero] call A3A_fnc_canFight)) then
							{
							if ({if (_x distance _nearX < 100) exitWith {1}} count _allNearFriends == 0) then {[_mortero,getPosASL _nearX,1] spawn A3A_fnc_mortarSupport};
							};
						};
					};
				};
			};

		if (_tarea == "AssaultClose") then
			{
			if (_nearX distance _lider > 150) then
				{
				_grupo setVariable ["tarea","Patrol"];
				}
			else
				{
				if (_nearX distance _lider > 50) then
					{
					_grupo setVariable ["tarea","Assault"];
					}
				else
					{
					if !(isNull _nearX) then
						{
						_flankers = (_grupo getVariable ["flankers",[]]) select {([_x] call A3A_fnc_canFight) and !(_x getVariable ["maneuvering",false])};
						if (count _flankers != 0) then
							{
							{
							[_x,_x,_nearX] spawn A3A_fnc_chargeWithSmoke;
							} forEach ((_grupo getVariable ["baseOfFire",[]]) select {([_x] call A3A_fnc_canFight) and (_x getVariable ["typeOfSoldier",""] == "Normal")});
							if ([getPosASL _nearX] call A3A_fnc_isBuildingPosition) then
								{
								_engineerX = objNull;
								_building = nearestBuilding _nearX;
								if !(_building getVariable ["assaulted",false]) then
									{
									{
									if ((_x call A3A_fnc_typeOfSoldier == "Engineer") and {_x != leader _x} and {!(_x getVariable ["maneuvering",true])} and {_x distance _nearX < 50} and {[_x] call A3A_fnc_canFight}) exitWith {_engineerX = _x};
									} forEach (_grupo getVariable ["baseOfFire",[]]);
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
			if ((isNull _tanques) and {isNull _aire} and {_numObjectives <= 2*_numNearFriends}) then
				{
				_grupo setVariable ["tarea","Patrol"];
				}
			else
				{
				_movable = (_grupo getVariable ["movable",[]]) select {[_x] call A3A_fnc_canFight and !(_x getVariable ["maneuvering",false])};
				_movable spawn A3A_fnc_hideInBuilding;
				};
			};
		}
	else
		{
		if (_grupo getVariable ["tarea","Patrol"] != "Patrol") then
			{
			if (_grupo getVariable ["tarea","Patrol"] == "Hide") then {_grupo call A3A_fnc_recallGroup};
			_grupo setVariable ["tarea","Patrol"];
			};
		if (side _grupo == buenos) then
			{
			if (time >= _grupo getVariable ["autoRearm",time]) then
				{
				_grupo setVariable ["autoRearm",time + 120];
				{[_x] spawn A3A_fnc_autoRearm; sleep 1} forEach ((_grupo getVariable ["movable",[]]) select {[_x] call A3A_fnc_canFight and !(_x getVariable ["maneuvering",false])});
				};
			};
		};
	diag_log format ["Tarea:%1.Movable:%2.Base:%3.Flankers:%4",_grupo getVariable "tarea",_grupo getVariable "movable",_grupo getVariable "baseOfFire",_grupo getVariable "flankers"];
	sleep 30;
	};
