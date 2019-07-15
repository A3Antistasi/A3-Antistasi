private _playerId =	param [0];
private _playerUnit = param [1];

if (hasInterface) then {
	if (isNil "_playerId" || isNil "_playerUnit") then {
		_playerId = getPlayerUID player;
		_playerUnit = player;
	};
};

if (isMultiplayer && !isServer) exitwith {
	[_playerId, _playerUnit] remoteExec ["A3A_fnc_savePlayer", 2];
};

savingClient = true;

[_playerId, "loadoutPlayer", getUnitLoadout _playerUnit] call fn_SavePlayerStat;
if (isMultiplayer) then
	{
	[_playerId, "scorePlayer", _playerUnit getVariable "score"] call fn_SavePlayerStat;
	[_playerId, "rankPlayer", rank _playerUnit] call fn_SavePlayerStat;
	[_playerId, "personalGarage",[_playerUnit] call A3A_fnc_getPersonalGarage] call fn_SavePlayerStat;
	_resourcesBackground = _playerUnit getVariable "moneyX";
	{
	_friendX = _x;
	if ((!isPlayer _friendX) and (alive _friendX)) then
		{
		_resourcesBackground = _resourcesBackground + (server getVariable (typeOf _friendX));
		if (vehicle _friendX != _friendX) then
			{
			_veh = vehicle _friendX;
			_typeVehX = typeOf _veh;
			if (not(_veh in staticsToSave)) then
				{
				if ((_veh isKindOf "StaticWeapon") or (driver _veh == _friendX)) then
					{
					_resourcesBackground = _resourcesBackground + ([_typeVehX] call A3A_fnc_vehiclePrice);
					if (count attachedObjects _veh != 0) then {{_resourcesBackground = _resourcesBackground + ([typeOf _x] call A3A_fnc_vehiclePrice)} forEach attachedObjects _veh};
					};
				};
			};
		};
	} forEach units group _playerUnit;
	diag_log "Saving money";
	[_playerId, "moneyX",_resourcesBackground] call fn_SavePlayerStat;
	};
	
savingClient = false;
true;