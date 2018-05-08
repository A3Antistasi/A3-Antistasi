private ["_unit","_skill"];

_unit = _this select 0;
_marcador = "";
if (count _this > 1) then
	{
	_marcador = _this select 1;
	_unit setVariable ["marcador",_marcador,true];
	if ((spawner getVariable _marcador != 0) and (vehicle _unit != _unit)) then
		{
		if (!isMultiplayer) then
			{
			_unit enableSimulation false
			}
		else
			{
			[_unit,false] remoteExec ["enableSimulationGlobal",2]
			}
		};
	};
[_unit] call initRevive;

_unit allowFleeing 0;
_tipo = typeOf _unit;
_skill = if (_tipo in sdkTier1) then {0.1 + (skillFIA * 0.2)} else {if (_tipo in sdkTier2) then {0.2 + (skillFIA * 0.2)} else {0.3 + (skillFIA * 0.2)}};
if ((_marcador == "Synd_HQ") and (isMultiplayer)) then {_skill = 1};
_unit setSkill (_skill + 0.1);
if (not((uniform _unit) in uniformsSDK)) then {[_unit] call reDress};
if (_tipo in SDKSniper) then
	{
	if (count unlockedSN > 0) then
		{
		[_unit, selectRandom unlockedSN, 8, 0] call BIS_fnc_addWeapon;
		if (count unlockedOptics > 0) then
			{
			_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
			_posibles = unlockedOptics select {_x in _compatibles};
			if (count _posibles > 0) then {_unit addPrimaryWeaponItem (_posibles select 0)};
			};
		}
	else
		{
		[_unit,unlockedRifles] call randomRifle;
		};
	}
else
	{
	if (_unit skill "aimingAccuracy" > 0.35) then {_unit setSkill ["aimingAccuracy",0.35]};
	if (random 40 < skillFIA) then
		{
		removeHeadgear _unit;
		_unit addHeadgear (selectRandom cascos);
		};
	if (_tipo in SDKMil) then
		{
		[_unit,unlockedRifles] call randomRifle;
		if ((loadAbs _unit < 340) and (_tipo in SDKMil)) then
			{
			if ((random 20 < skillFIA) and (count unlockedAA > 0)) then
				{
				_unit addbackpack (unlockedBackpacks select 0);
				[_unit, selectRandom unlockedAA, 2, 0] call BIS_fnc_addWeapon;
				//removeBackpack _unit;
				};
			};
		}
	else
		{
		if (_tipo in SDKMG) then
			{
			if (count unlockedMG > 0) then
				{
				[_unit,unlockedMG] call randomRifle;
				}
			else
				{
				[_unit,unlockedRifles] call randomRifle;
				};
			}
		else
			{
			if (_tipo in SDKGL) then
				{
				if (count unlockedGL > 0) then
					{
					[_unit,unlockedGL] call randomRifle;
					}
				else
					{
					[_unit,unlockedRifles] call randomRifle;
					};
				}
			else
				{
				[_unit,unlockedRifles] call randomRifle;
				if (_tipo in SDKMedic) then
					{
					_unit setUnitTrait ["medic",true]
					}
				else
					{
					if (_tipo in SDKATman) then
						{
						_rlauncher = selectRandom unlockedAT;
						if (_rlauncher != secondaryWeapon _unit) then
							{
							_magazines = getArray (configFile / "CfgWeapons" / (secondaryWeapon _unit) / "magazines");
							{_unit removeMagazines _x} forEach _magazines;
							_unit removeWeaponGlobal (secondaryWeapon _unit);
							[_unit, _rlauncher, 4, 0] call BIS_fnc_addWeapon;
							};
						};
					};
				};
			};
		};
	};


_unit selectWeapon (primaryWeapon _unit);

if (!haveRadio) then {_unit unlinkItem "ItemRadio"};

if (sunOrMoon < 1) then
	{
	if (haveNV) then
		{
		_unit linkItem (selectRandom NVGoggles);
		if ("acc_pointer_IR" in unlockedItems) then
			{
			_unit addPrimaryWeaponItem "acc_pointer_IR";
	        _unit assignItem "acc_pointer_IR";
	        _unit enableIRLasers true;
			};
		}
	else
		{
		_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
		_array = lamparasSDK arrayIntersect _compatibles;
		if (count _array > 0) then
			{
			_compatible = _array select 0;
			_unit addPrimaryWeaponItem _compatible;
		    _unit assignItem _compatible;
		    _unit enableGunLights _compatible;
			};
	    };
	};
if ({if (_x in humo) exitWith {1}} count unlockedMagazines > 0) then {_unit addMagazines [selectRandom humo,2]};
if (_unit == leader _unit) then
	{
	_unit setskill ["courage",_skill + 0.2];
	_unit setskill ["commanding",_skill + 0.2];
	};

_EHkilledIdx = _unit addEventHandler ["killed", {
	_muerto = _this select 0;
	_killer = _this select 1;
	[_muerto] remoteExec ["postmortem",2];
	if (isPlayer _killer) then
		{
		if (!isMultiPlayer) then
			{
			_nul = [0,20] remoteExec ["resourcesFIA",2];
			_killer addRating 1000;
			};
		};
	if (side _killer == malos) then
		{
		[0,-0.25,getPos _muerto] remoteExec ["citySupportChange",2];
		[-0.25,0] remoteExec ["prestige",2];
		}
	else
		{
		if (side _killer == muyMalos) then {[0,-0.25] remoteExec ["prestige",2]};
		};
	_marcador = _muerto getVariable "marcador";
	if (!isNil "_marcador") then
		{
		if (lados getVariable [_marcador,sideUnknown] == buenos) then
			{
			_garrison = [];
			_garrison = _garrison + (garrison getVariable [_marcador,[]]);
			if (_garrison isEqualType []) then
				{
				for "_i" from 0 to (count _garrison -1) do
					{
					if (typeOf _muerto == (_garrison select _i)) exitWith {_garrison deleteAt _i};
					};
				garrison setVariable [_marcador,_garrison,true];
				};
			if (!(_marcador in controles)) then {[_marcador] call mrkUpdate};
			_muerto setVariable [_marcador,nil,true];
			};
		};
	}];

