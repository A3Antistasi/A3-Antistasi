private ["_unit","_recursos","_hr","_armas","_municion","_items","_pos"];

_unit = _this select 0;

_recursos = 0;
_hr = 0;

if (_unit == theBoss) then
	{
	{
	if (!(_x getVariable ["esNATO",false])) then
		{
		if ((leader _x getVariable ["GREENFORSpawn",false]) and ({isPlayer _x} count (units _x) == 0)) then
			{
			_uds = units _x;
				{
				if (alive _x) then
					{
					_recursos = _recursos + (server getVariable (typeOf _x));
					_hr = _hr + 1;
					};
				if (!isNull (assignedVehicle _x)) then
					{
					_veh = assignedVehicle _x;
					_tipoVeh = typeOf _veh;
					if ((_veh isKindOf "StaticWeapon") and (not(_veh in staticsToSave))) then
						{
						_recursos = _recursos + ([_tipoVeh] call vehiclePrice) + ([typeOf (vehicle leader _x)] call vehiclePrice);
						}
					else
						{
						if (_tipoVeh in vehFIA) then {_recursos = _recursos + ([_tipoVeh] call vehiclePrice);};
						/*
						if (_tipoVeh in vehAAFnormal) then {_recursos = _recursos + 300};
						if (_tipoVeh in vehAAFAT) then
							{
							if ((_tipoVeh == "I_APC_tracked_03_cannon_F") or (_tipoVeh == "I_APC_Wheeled_03_cannon_F")) then {_recursos = _recursos + 1000} else {_recursos = _recursos + 5000};
							};
						*/
						if (count attachedObjects _veh > 0) then
							{
							_subVeh = (attachedObjects _veh) select 0;
							_recursos = _recursos + ([(typeOf _subVeh)] call vehiclePrice);
							deleteVehicle _subVeh;
							};
						};
					if (!(_veh in staticsToSave)) then {deleteVehicle _veh};
					};
				deleteVehicle _x;
				} forEach _uds;
			};
		};
	} forEach allGroups;
	if (((count playableUnits > 0) and (!membershipEnabled)) or ({(getPlayerUID _x) in miembros} count playableUnits > 0)) then
		{
		[] spawn assigntheBoss;
		};
	if (group petros == group _unit) then {[] spawn buildHQ};
	};
//{if (groupOwner _x ==)} forEach allGroups select {(side _x == civilian) and (!isPlayer leader _x)};
if ((side _unit == buenos) or (side _unit == civilian)) then
	{
	if ((_hr > 0) or (_recursos > 0)) then {[_hr,_recursos] spawn resourcesFIA};

	_pos = getPosATL _unit;
	_wholder = nearestObjects [_pos, ["weaponHolderSimulated", "weaponHolder"], 2];
	{deleteVehicle _x} forEach _wholder + [_unit];
	if (alive _unit) then
		{
		_unit setVariable ["owner",_unit,true];
		_unit setDamage 1;
		};
	};
if ((_unit == HC1) or (_unit == HC2) or (_unit == HC3)) then
	{
	["hcDown",true,true,true,true] remoteExec ["BIS_fnc_endMission"]
	};
//diag_log format ["Datos de handledisconnect: %1",_this];