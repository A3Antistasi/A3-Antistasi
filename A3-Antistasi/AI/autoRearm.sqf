private ["_unit","_Pweapon","_Sweapon","_countX","_magazines","_hasBox","_distanceX","_objectsX","_target","_muerto","_check","_timeOut","_arma","_armas","_rearming","_basePossible","_hmd","_helmet","_truckX","_autoLoot","_itemsUnit"];

_unit = _this select 0;

if (isPlayer _unit) exitWith {};
if !([_unit] call A3A_fnc_canFight) exitWith {};
_inPlayerGroup = (isPlayer (leader _unit));
//_ayudando = _unit getVariable "ayudando";
if (_unit getVariable ["ayudando",false]) exitWith {if (_inPlayerGroup) then {_unit groupChat "I cannot rearm right now. I'm healing a comrade"}};
_rearming = _unit getVariable ["rearming",false];
if (_rearming) exitWith {if (_inPlayerGroup) then {_unit groupChat "I am currently rearming. Cancelling."; _unit setVariable ["rearming",false]}};
if (vehicle _unit != _unit) exitWith {};
_unit setVariable ["rearming",true];

_Pweapon = primaryWeapon _unit;
_Sweapon = secondaryWeapon _unit;

_objectsX = [];
_hasBox = false;
_arma = "";
_armas = [];
_distanceX = 51;
_objectsX = nearestObjects [_unit, ["ReammoBox_F","LandVehicle","WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 50];
if (caja in _objectsX) then {_objectsX = _objectsX - [caja]};

_necesita = false;

if ((_Pweapon in initialRifles) or (_Pweapon == "")) then
	{
	_necesita = true;
	if (count _objectsX > 0) then
		{
		{
		_objeto = _x;
		if (_unit distance _objeto < _distanceX) then
			{
			if ((count weaponCargo _objeto > 0) and !(_objeto getVariable ["busy",false])) then
				{
				_armas = weaponCargo _objeto;
				for "_i" from 0 to (count _armas - 1) do
					{
					_potential = _armas select _i;
					_basePossible = [_potential] call BIS_fnc_baseWeapon;
					if ((not(_basePossible in ["hgun_PDW2000_F","hgun_Pistol_01_F","hgun_ACPC2_F","arifle_AKM_F","arifle_AKS_F","SMG_05_F","LMG_03_F"])) and ((_basePossible in arifles) or (_basePossible in srifles) or (_basePossible in mguns))) then
						{
						_target = _objeto;
						_hasBox = true;
						_distanceX = _unit distance _objeto;
						_arma = _potential;
						};
					};
				};
			};
		} forEach _objectsX;
		};
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a better weapon"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and ([_unit] call A3A_fnc_canFight) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["TakeWeapon",_target,_arma];
			sleep 5;
			if (primaryWeapon _unit == _arma) then
				{
				if (_inPlayerGroup) then {_unit groupChat "I have a better weapon now"};
				if (_target isKindOf "ReammoBox_F") then {_unit action ["rearm",_target]};
				};
			};
		_target setVariable ["busy",false];
		};
	_distanceX = 51;
	_Pweapon = primaryWeapon _unit;
	sleep 3;
	};
_hasBox = false;
_countX = 4;
if (_Pweapon in mguns) then {_countX = 2};
_magazines = getArray (configFile / "CfgWeapons" / _Pweapon / "magazines");
if ({_x in _magazines} count (magazines _unit) < _countX) then
	{
	_necesita = true;
	_hasBox = false;
	if (count _objectsX > 0) then
		{
		{
		_objeto = _x;
		if (({_x in _magazines} count magazineCargo _objeto) > 0) then
			{
			if (_unit distance _objeto < _distanceX) then
				{
				_target = _objeto;
				_hasBox = true;
				_distanceX = _unit distance _objeto;
				};
			};
		} forEach _objectsX;
		};
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if (({_x in _magazines} count (magazines _muerto) > 0) and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;
	};
if ((_hasBox) and (_unit getVariable "rearming")) then
	{
	_unit stop false;
	if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
	_unit doMove (getPosATL _target);
	if (_inPlayerGroup) then {_unit groupChat "Rearming"};
	_timeOut = time + 60;
	waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
	if ((unitReady _unit) and ([_unit] call A3A_fnc_canFight) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
	if (_unit distance _target < 3) then
		{
		_unit action ["rearm",_target];
		if ({_x in _magazines} count (magazines _unit) >= _countX) then
			{
			if (_inPlayerGroup) then {_unit groupChat "Rearmed"};
			}
		else
			{
			if (_inPlayerGroup) then {_unit groupChat "Partially Rearmed"};
			};
		};
	_target setVariable ["busy",false];
	}
else
	{
	if (_inPlayerGroup) then {_unit groupChat "No source to rearm my primary weapon"};
	};
_hasBox = false;
if ((_Sweapon == "") and (loadAbs _unit < 340)) then
	{
	if (count _objectsX > 0) then
		{
		{
		_objeto = _x;
		if (_unit distance _objeto < _distanceX) then
			{
			if ((count weaponCargo _objeto > 0) and !(_objeto getVariable ["busy",false])) then
				{
				_armas = weaponCargo _objeto;
				for "_i" from 0 to (count _armas - 1) do
					{
					_potential = _armas select _i;
					if ((_potential in mlaunchers) or (_potential in rlaunchers)) then
						{
						_target = _objeto;
						_hasBox = true;
						_distanceX = _unit distance _objeto;
						_arma = _potential;
						};
					};
				};
			};
		} forEach _objectsX;
		};
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a secondary weapon"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and ([_unit] call A3A_fnc_canFight) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["TakeWeapon",_target,_arma];
			sleep 3;
			if (secondaryWeapon _unit == _arma) then
				{
				if (_inPlayerGroup) then {_unit groupChat "I have a secondary weapon now"};
				if (_target isKindOf "ReammoBox_F") then {sleep 3;_unit action ["rearm",_target]};
				};
			};
		_target setVariable ["busy",false];
		};
	_Sweapon = secondaryWeapon _unit;
	_distanceX = 51;
	sleep 3;
	};
_hasBox = false;
if (_Sweapon != "") then
	{
	_magazines = getArray (configFile / "CfgWeapons" / _Sweapon / "magazines");
	if ({_x in _magazines} count (magazines _unit) < 2) then
		{
		_necesita = true;
		_hasBox = false;
		_distanceX = 50;
		if (count _objectsX > 0) then
			{
			{
			_objeto = _x;
			if ({_x in _magazines} count magazineCargo _objeto > 0) then
				{
				if (_unit distance _objeto < _distanceX) then
					{
					_target = _objeto;
					_hasBox = true;
					_distanceX = _unit distance _objeto;
					};
				};
			} forEach _objectsX;
			};
		_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
		{
		_muerto = _x;
		if (({_x in _magazines} count (magazines _muerto) > 0) and (_unit distance _muerto < _distanceX)) then
			{
			_target = _muerto;
			_hasBox = true;
			_distanceX = _muerto distance _unit;
			};
		} forEach _muertos;
		};
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if (!alive _target) then {_target setVariable ["busy",true]};
		_unit doMove (position _target);
		if (_inPlayerGroup) then {_unit groupChat "Rearming"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and ([_unit] call A3A_fnc_canFight) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			if ((backpack _unit == "") and (backPack _target != "")) then
				{
				_unit addBackPackGlobal ((backpack _target) call BIS_fnc_basicBackpack);
				_unit action ["rearm",_target];
				sleep 3;
				{_unit addItemToBackpack _x} forEach (backpackItems _target);
				removeBackpackGlobal _target;
				}
			else
				{
				_unit action ["rearm",_target];
				};

			if ({_x in _magazines} count (magazines _unit) >= 2) then
				{
				if (_inPlayerGroup) then {_unit groupChat "Rearmed"};
				}
			else
				{
				if (_inPlayerGroup) then {_unit groupChat "Partially Rearmed"};
				};
			};
		_target setVariable ["busy",false];
		}
	else
		{
		if (_inPlayerGroup) then {_unit groupChat "No source to rearm my secondary weapon"};
		};
	sleep 3;
	};
_hasBox = false;
if ((not("ItemRadio" in assignedItems _unit)) and !haveRadio) then
	{
	_necesita = true;
	_hasBox = false;
	_distanceX = 50;
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if (("ItemRadio" in (assignedItems _muerto)) and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a Radio"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit linkItem "ItemRadio";
			_target unlinkItem "ItemRadio";
			};
		_target setVariable ["busy",false];
		};
	};
_hasBox = false;
if (hmd _unit == "") then
	{
	_necesita = true;
	_hasBox = false;
	_distanceX = 50;
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if ((hmd _muerto != "") and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;

	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_hmd = hmd _target;
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking NV Googles"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit linkItem _hmd;
			_target unlinkItem _hmd;
			};
		_target setVariable ["busy",false];
		};
	};
_hasBox = false;
if (not(headgear _unit in helmets)) then
	{
	_necesita = true;
	_hasBox = false;
	_distanceX = 50;
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if (((headgear _muerto) in helmets) and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_helmet = headgear _target;
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a Helmet"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit addHeadgear _helmet;
			removeHeadgear _target;
			};
		_target setVariable ["busy",false];
		};
	};
_hasBox = false;
_minFA = if ([_unit] call A3A_fnc_isMedic) then {10} else {1};

if ({_x == "FirstAidKit"} count (items _unit) < _minFA) then
	{
	_necesita = true;
	_hasBox = false;
	_distanceX = 50;
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if (("FirstAidKit" in items _muerto) and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a First Aid Kit"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			while {{_x == "FirstAidKit"} count (items _unit) < _minFA} do
				{
				_unit action ["rearm",_target];
				_unit addItem "FirstAidKit";
				_target removeItem "FirstAidKit";
				if ("FirstAidKit" in items _muerto) then {sleep 3};
				};
			};
		_target setVariable ["busy",false];
		};
	};
_hasBox = false;
_number = getNumber (configfile >> "CfgWeapons" >> vest cursortarget >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor");
_distanceX = 50;
_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
{
_muerto = _x;
if ((getNumber (configfile >> "CfgWeapons" >> vest _muerto >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor") > _number) and (_unit distance _muerto < _distanceX)) then
	{
	_target = _muerto;
	_hasBox = true;
	_distanceX = _muerto distance _unit;
	};
} forEach _muertos;
if ((_hasBox) and (_unit getVariable "rearming")) then
	{
	_unit stop false;
	_target setVariable ["busy",true];
	_unit doMove (getPosATL _target);
	if (_inPlayerGroup) then {_unit groupChat "Picking a a better vest"};
	_timeOut = time + 60;
	waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
	if (_unit distance _target < 3) then
		{
		_itemsUnit = vestItems _unit;
		_unit addVest (vest _target);
		{_unit addItemToVest _x} forEach _itemsUnit;
		_unit action ["rearm",_target];
		//{_unit addItemCargoGlobal [_x,1]} forEach ((backpackItems _target) + (backpackMagazines _target));
		_cosas = nearestObjects [_target, ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 5];
		if (count _cosas > 0) then
			{
			_cosa = _cosas select 0;
			{_cosa addItemCargoGlobal [_x,1]} forEach (vestItems _target);
			};
		removeVest _target;
		};
	_target setVariable ["busy",false];
	};

if (backpack _unit == "") then
	{
	_necesita = true;
	_hasBox = false;
	_distanceX = 50;
	_muertos = allDead select {(_x distance _unit < 51) and (!(_x getVariable ["busy",false]))};
	{
	_muerto = _x;
	if ((backpack _muerto != "") and (_unit distance _muerto < _distanceX)) then
		{
		_target = _muerto;
		_hasBox = true;
		_distanceX = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hasBox) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_unit doMove (getPosATL _target);
		if (_inPlayerGroup) then {_unit groupChat "Picking a Backpack"};
		_timeOut = time + 60;
		waitUntil {sleep 1; !([_unit] call A3A_fnc_canFight) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit addBackPackGlobal ((backpack _target) call BIS_fnc_basicBackpack);
			_unit action ["rearm",_target];
			//{_unit addItemCargoGlobal [_x,1]} forEach ((backpackItems _target) + (backpackMagazines _target));
			_cosas = nearestObjects [_target, ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 5];
			if (count _cosas > 0) then
				{
				_cosa = _cosas select 0;
				{_cosa addItemCargoGlobal [_x,1]} forEach (backpackItems _target);
				};
			removeBackpackGlobal _target;
			};
		_target setVariable ["busy",false];
		};
	};
_unit doFollow (leader _unit);
if (!_necesita) then {if (_inPlayerGroup) then {_unit groupChat "No need to rearm"}} else {if (_inPlayerGroup) then {_unit groupChat "Rearming Done"}};
_unit setVariable ["rearming",false];