private ["_gunner","_helperX"];
private _isMortar = false;
{if (_x getVariable ["typeOfSoldier",""] == "StaticGunner") then {_gunner = _x} else {_helperX = _x}} forEach _this;
{if (_x getVariable ["typeOfSoldier",""] == "StaticMortar") then {_gunner = _x;_isMortar = true} else {_helperX = _x}} forEach _this;
private _grupo = group _gunner;
private _mounted = false;
private _veh = objNull;
private _lado = side _grupo;
private _tipoVeh = 	if !(_isMortar) then
						{
						if (_lado == malos) then {NATOMG} else {if (_lado == Invaders) then {CSATMG} else {SDKMGStatic}};
						}
					else
						{
						if (_lado == malos) then {NATOMortar} else {if (_lado == Invaders) then {CSATMortar} else {SDKMortar}};
						};
private _mochiG = backPack _gunner;
private _mochiA = backpack _helperX;
while {(alive _gunner)} do
	{
	if (!(alive _helperX) and !(_mounted)) exitWith {};
	if (!(isNull _veh) and !(alive _veh)) exitWith {};
	_objectivesX = _grupo getVariable ["objectivesX",[]];
	_enemyX = objNull;
	if (!(_objectivesX isEqualTo []) and (((_objectivesX select 0) select 4) distance _gunner > 150))  then
		{
		if !(_isMortar) then
			{
			{
			_eny = _x select 4;
			if !(_eny isKindOf "Tank") then
				{
				if  (([objNull, "VIEW"] checkVisibility [eyePos _eny, eyePos _gunner]) > 0) then
					{
					_enemyX = _eny;
					};
				};
			if !(isNull _enemyX) exitWith {};
			} forEach _objectivesX;
			}
		else
			{
			_enemyX = ((_objectivesX select 0) select 4);
			};
		};
	if !(isNull _enemyX) then
		{
		if !(_mounted) then
			{
			if !(_gunner getVariable ["maneuvering",false]) then
				{
				if (([_gunner] call A3A_fnc_canFight) and ([_helperX] call A3A_fnc_canFight)) then
					{
					_gunner setVariable ["maneuvering",true];
					_gunner playMoveNow selectRandom medicAnims;
					_gunner setVariable ["timeToBuild",time + 30];
					_gunner addEventHandler ["AnimDone",
						{
						private _gunner = _this select 0;
						if ((time > _gunner getVariable ["timeToBuild",0]) or !([_gunner] call A3A_fnc_canFight)) then
							{
							_gunner removeEventHandler ["AnimDone",_thisEventHandler];
							_gunner setVariable ["maneuvering",false];
							}
						else
							{
							_gunner playMoveNow selectRandom medicAnims;
							};
						}];
					waitUntil {sleep 0.5; !(_gunner getVariable ["maneuvering",false])};
					_gunner setVariable ["timeToBuild",nil];
					if ([_gunner] call A3A_fnc_canFight) then
						{
						private _veh = _tipoVeh createVehicle [0,0,1000];
						_veh setPos position (_gunner);
						removeBackpackGlobal _gunner;
						removeBackpackGlobal _helperX;
						_grupo addVehicle _veh;
						_gunner assignAsGunner _veh;
						[_gunner] orderGetIn true;
						[_gunner] allowGetIn true;
						_gunner moveInGunner _veh;
						[_veh] call A3A_fnc_AIVEHinit;
						_mounted = true;
						if (_isMortar) then {_grupo setVariable ["mortarsX",_gunner]};
						sleep 60;
						};
					};
				};
			}
		else
			{
			if (_gunner getVariable ["maneuvering",false]) then
				{
				if (([_gunner] call A3A_fnc_canFight) and ([_helperX] call A3A_fnc_canFight)) then
					{
					[_gunner] orderGetIn false;
					[_gunner] allowGetIn false;
					waitUntil {sleep 1; (vehicle _gunner == _gunner) or !(alive _gunner)};
					if (alive _gunner) then
						{
						_mounted = false;
						_gunner addBackpackGlobal _mochiG;
						_helperX addBackpackGlobal _mochiA;
						deleteVehicle _veh;
						_gunner call A3A_fnc_recallGroup;
						if (_isMortar) then {_grupo setVariable ["mortarsX",objNull]};
						};
					};
				};
			};
		}
	else
		{
		if (_mounted) then
			{
			if (([_gunner] call A3A_fnc_canFight) and ([_helperX] call A3A_fnc_canFight)) then
				{
				[_gunner] orderGetIn false;
				[_gunner] allowGetIn false;
				_veh = vehicle _gunner;
				moveOut _gunner;
				_mounted = false;
				_gunner addBackpackGlobal _mochiG;
				_helperX addBackpackGlobal _mochiA;
				deleteVehicle _veh;
				_gunner call A3A_fnc_recallGroup;
				if (_isMortar) then {_grupo setVariable ["mortarsX",objNull]};
				};
			};
		};

	sleep 15;
	};
if (alive _gunner) then
	{
	[_gunner] orderGetIn false;
	[_gunner] allowGetIn false;
	moveOut _gunner;
	_gunner setVariable ["maneuvering",false];
	_flankers = _grupo getVariable ["flankers",[]];
	_flankers pushBack _gunner;
	_grupo setVariable ["flankers",_flankers];
	_gunner call A3A_fnc_recallGroup;
	};
if (alive _helperX) then
	{
	_helperX setVariable ["maneuvering",false];
	_flankers = _grupo getVariable ["flankers",[]];
	_flankers pushBack _helperX;
	_grupo setVariable ["flankers",_flankers];
	_helperX call A3A_fnc_recallGroup;
	};
