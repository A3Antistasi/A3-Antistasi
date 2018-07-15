private ["_unit","_veh","_lado","_tipo","_skill","_riflefinal","_magazines","_hmd","_marcador","_revelar"];

_unit = _this select 0;
if (isNil "_unit") exitWith {};
if (isNull _unit) exitWith {diag_log format ["Antistasi: Error enviando a NATOinit los parámetros:%1",_this]};
_tipo = typeOf _unit;
if (typeOf _unit == "Fin_random_F") exitWith {};
_lado = side _unit;
//_unit setVariable ["lado",_lado];
_unit addEventHandler ["HandleDamage",handleDamageAAF];

_unit addEventHandler ["killed",AAFKilledEH];
if (count _this > 1) then
	{
	_marcador = _this select 1;
	if (_marcador != "") then
		{
		_unit setVariable ["marcador",_marcador,true];
		if ((spawner getVariable _marcador != 0) and (vehicle _unit != _unit)) then {if (!isMultiplayer) then {_unit enableSimulation false} else {[_unit,false] remoteExec ["enableSimulationGlobal",2]}};
		};
	}
else
	{
	if (vehicle _unit != _unit) then
		{
		_veh = vehicle _unit;
		if (_unit in (assignedCargo _veh)) then
			{
			//if (typeOf _veh in vehAPCs) then {if (isMultiplayer) then {[_unit,false] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation false}};
			_unit addEventHandler ["GetOutMan",
				{
				_unit = _this select 0;
				_veh = _this select 2;
				_driver = driver _veh;
				if (!isNull _driver) then
					{
					if ((_driver getVariable ["BLUFORSpawn",false]) or (_driver getVariable ["OPFORSpawn",false])) then
						{
						if ((not(_unit getVariable ["BLUFORSpawn",false])) or ((not(_unit getVariable ["OPFORSpawn",false])))) then
							{
							_lado = side (group _unit);
							if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
							//if (!simulationEnabled _unit) then {if (isMultiplayer) then {[_unit,true] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation true}};
							};
						};
					};
				}];
			}
		else
			{
			if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
			};
		}
	else
		{
		if (_lado == malos) then {_unit setVariable ["BLUFORSpawn",true,true]} else {_unit setVariable ["OPFORSpawn",true,true]};
		};
	};

_skill = tierWar * 0.1 * skillMult;
if ((faction _unit != factionGEN) and (faction _unit != factionFIA)) then
	{
	if (side _unit == malos) then
		{
		_skill = _skill + 0.1;
		}
	else
		{
		if (count _this > 1) then
			{
			_skill = _skill + 0.2;
			}
		else
			{
			_skill = _skill + 0.3;
			};
		};
	}
else
	{
	if (faction _unit == factionFIA) then
		{
		_skill = _skill min 0.3;
		}
	else
		{
		_skill = _skill min 0.2;
		if (tierWar > 1) then
			{
			_rifleFinal = primaryWeapon _unit;
			_magazines = getArray (configFile / "CfgWeapons" / _rifleFinal / "magazines");
			{_unit removeMagazines _x} forEach _magazines;
			_unit removeWeaponGlobal (_rifleFinal);
			if (tierWar < 5) then {[_unit, "arifle_MX_Black_F", 6, 0] call BIS_fnc_addWeapon} else {[_unit, "arifle_AK12_F", 6, 0] call BIS_fnc_addWeapon};
			_unit selectWeapon (primaryWeapon _unit);
			};
		};
	};

if (_skill > 0.58) then {_skill = 0.58};
_unit setSkill _skill;
if (not(_tipo in sniperUnits)) then {if (_unit skill "aimingAccuracy" > 0.35) then {_unit setSkill ["aimingAccuracy",0.35]}};
if (_unit == leader _unit) then
	{
	_unit setskill ["courage",_skill + 0.2];
	_unit setskill ["commanding",_skill + 0.2];
	};
_hmd = hmd _unit;
if (sunOrMoon < 1) then
	{
	if (!hayRHS) then
		{
		if ((faction _unit != "BLU_CTRG_F") and (faction _unit != "OPF_V_F") and (_unit != leader (group _unit))) then
			{
			if (_hmd != "") then
				{
				if ((random 5 > tierWar) and (!haveNV)) then
					{
					_unit unassignItem _hmd;
					_unit removeItem _hmd;
					_hmd = "";
					};
				};
			};
		if (_hmd != "") then
			{
			if ("acc_pointer_IR" in primaryWeaponItems _unit) then
				{
				_unit action ["IRLaserOn", _unit]
				};
			}
		else
			{
			if (not("acc_flashlight" in primaryWeaponItems _unit)) then
				{
				_compatibles = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
				if ("acc_flashlight" in _compatibles) then
					{
					_unit addPrimaryWeaponItem "acc_flashlight";
				    _unit assignItem "acc_flashlight";
					};
				};
			_unit enableGunLights "AUTO";
			_unit setskill ["spotDistance",_skill - 0.2];
			_unit setskill ["spotTime",_skill - 0.2];
			};
		}
	else
		{
		_arr = (NVGoggles arrayIntersect (items _unit));
		if (count _arr > 0) then
			{
			_hmd = _arr select 0;
			if ((random 5 > tierWar) and (!haveNV)) then
				{
				_unit removeItem _hmd;
				}
			else
				{
				_unit assignItem _hmd;
				};
			};
		if (hmd _unit == "") then
			{
			_lampara = if (side _unit == muyMalos) then {lamparaMuyMalos} else {lamparaMalos};
			if (!(_lampara in primaryWeaponItems _unit)) then
				{
				_unit addPrimaryWeaponItem _lampara;
				_unit assignItem _lampara;
				};
			_unit enableGunLights "AUTO";
			_unit setskill ["spotDistance",_skill - 0.2];
			_unit setskill ["spotTime",_skill - 0.2];
			}
		else
			{
			_unit action ["IRLaserOn", _unit];
			};
		};
	}
else
	{
	if (!hayRHS) then
		{
		if ((faction _unit != "BLU_CTRG_F") and (faction _unit != "OPF_V_F")) then
			{
			if (_hmd != "") then
				{
				_unit unassignItem _hmd;
				_unit removeItem _hmd;
				};
			};
		}
	else
		{
		_arr = (NVGoggles arrayIntersect (items _unit));
		if (count _arr > 0) then
			{
			_hmd = _arr select 0;
			_unit removeItem _hmd;
			};
		};
	};
_revelar = false;
if (vehicle _unit != _unit) then
	{
	if (_unit == gunner (vehicle _unit)) then
		{
		_revelar = true;
		};
	}
else
	{
	if ((secondaryWeapon _unit) in mlaunchers) then {_revelar = true};
	};
if (_revelar) then
	{
	{
	_unit reveal [_x,1.5];
	} forEach allUnits select {(vehicle _x isKindOf "Air") and (_x distance _unit <= distanciaSPWN)};
	};