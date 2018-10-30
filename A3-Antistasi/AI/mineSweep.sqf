if (!isServer and hasInterface) exitWith {};

private ["_coste","_grupo","_unit","_minas","_tam","_roads","_camion","_mina","_cuenta"];

_coste = (server getVariable (SDKExp select 0)) + ([vehSDKRepair] call A3A_fnc_vehiclePrice);

[-1,-1*_coste] remoteExec ["A3A_fnc_resourcesFIA",2];

_grupo = createGroup buenos;

_unit = _grupo createUnit [(SDKExp select 0), getMarkerPos respawnBuenos, [], 0, "NONE"];
_grupo setGroupId ["MineSw"];
_minas = [];
sleep 1;
_road = [getMarkerPos respawnBuenos] call A3A_fnc_findNearestGoodRoad;
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];

_camion = vehSDKRepair createVehicle _pos;

[_camion] call A3A_fnc_AIVEHinit;
[_unit] spawn A3A_fnc_FIAinit;
clearMagazineCargo unitBackpack _unit;
_unit addItemToBackpack "MineDetector";

_grupo addVehicle _camion;
[_unit] orderGetIn true;
// Add Mine Detector to detect invisible APERS
clearMagazineCargo (unitBackpack _unit);
_unit addItemToBackpack "MineDetector";
//_unit setBehaviour "SAFE";
theBoss hcSetGroup [_grupo];

while {alive _unit} do
	{
	waitUntil {sleep 1;(!alive _unit) or (unitReady _unit)};
	if (alive _unit) then
		{
		if (alive _camion) then
			{
			if ((count magazineCargo _camion > 0) and (_unit distance (getMarkerPos respawnBuenos) < 50)) then
				{
				[_camion,caja] remoteExec ["A3A_fnc_munitionTransfer",2];
				sleep 30;
				};
			};
		_minas = (detectedMines buenos) select {(_x distance _unit) < 100};
		if (count _minas == 0) then
			{
			waitUntil {sleep 1;(!alive _unit) or (!unitReady _unit)};
			}
		else
			{
			moveOut _unit;
			[_unit] orderGetin false;
			_minas = [_minas,[],{_unit distance _x},"ASCEND"] call BIS_fnc_sortBy;
			_cuenta = 0;
			_total = count _minas;
			hint format ["Mine sweeper found %1 mines, deactivating", _total];
			diag_log format ["Antistasi Mine sweep: Found %1 mines, deactivating", _total];
			while {(alive _unit) and (_cuenta < _total)} do
				{
				_mina = _minas select _cuenta;
				[_unit] orderGetin false;
				diag_log format ["Antistasi Mine sweep: Moving to mine %1", _cuenta + 1];
				_unit doMove position _mina;
				_timeOut = time + 120;
				waitUntil {sleep 0.5; (_unit distance _mina < 8) or (!alive _unit) or (time > _timeOut)};
				if (alive _unit) then
					{
					diag_log format ["Antistasi Mine sweep: Deactivating mine %1 of %2", _cuenta + 1, _total];
					_unit action ["Deactivate",_unit,_mina];
					//_unit action ["deactivateMine", _unit];
					sleep 3;
					_toDelete = nearestObjects [position _unit, ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 9];
					if (count _toDelete > 0) then
						{
						diag_log format ["Antistasi Mine sweep: Deleting %1 containers for mine %2", count _toDelete, _cuenta + 1];
						_wh = _toDelete select 0;
						if (alive _camion) then {_camion addMagazineCargoGlobal [((magazineCargo _wh) select 0),1]};
						deleteVehicle _mina;
						deleteVehicle _wh;
						};
					_cuenta = _cuenta + 1;
					};
				};
			if(alive _unit) then
				{
				[_unit] orderGetIn true;
				diag_log "Antistasi Mine sweep: All mines deactivated";
				hint "Mine sweeper deactivated all mines";
				} else {
				hint "Mine sweeper is dead";
				diag_log "Antistasi Mine sweep: Mine sweeper is dead";
				};
			};
		};
	sleep 1;
	};