if (!isServer and hasInterface) exitWith{};

private ["_veh","_text","_pos","_side","_newPos","_road"];

_veh = _this select 0;
_text = _this select 1;
_convoy = false;

if ((_text == "Convoy Objective") or (_text == "Mission Vehicle") or (_text == "Supply Box")) then {_convoy = true};

waitUntil {sleep 1; (not(isNull driver _veh)) or _convoy};

if (debug) then {revelar = true};

_veh setVariable ["revelado",false];
while {alive _veh} do
	{
	if (!(_veh getVariable ["revelado",false])) then
		{
		if ((buenos knowsAbout _veh > 1.4) or revelar or _convoy) then
			{
			_veh setVariable ["revelado",true,true];
			[_veh,_text] remoteExec ["vehicleMarkers",[buenos,civilian]];
			};
		}
	else
		{
		if ((buenos knowsAbout _veh <= 1.4) and !(revelar) and !(_convoy)) then
			{
			_veh setVariable ["revelado",false,true];
			};
		};
	_pos = getPos _veh;
	sleep 60;
	_newPos = getPos _veh;

	_condu = driver _veh;
	if ((_newPos distance _pos < 5) and (_text != "Supply Box") and !(isNull _condu)) then
		{
		if (_veh isKindOf "Air") then
			{
			if (isTouchingGround _veh) then
				{
				{
				unAssignVehicle _x;
	   			moveOut _x;
	   			sleep 1.5;
				} forEach assignedCargo _veh;
				};
			}
		else
			{
			if (not(_veh isKindOf "Ship")) then
				{
				if ({_x distance _newPos < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0) then
					{
					_puentes = nearestObjects [_newPos, ["Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F","Land_BridgeSea_01_pillar_F","Land_BridgeWooden_01_pillar_F"], 50];
					if !(_puentes isEqualTo []) then
						{
						_nextWaypoint = currentWaypoint (group _condu);
						_wpPos = waypointPosition ((waypoints (group _condu)) select _nextWaypoint);
						_ang = [_newPos, _wpPos] call BIS_fnc_DirTo;
						_newPos = _newPos getPos [100,_ang];
						};
					_road = [_newPos,100] call BIS_fnc_nearestRoad;
					if (!isNull _road) then
						{
						_veh setPos getPos _road;
						if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [position _road,["tree","bush"],15])} else {{[_x,true] remoteExec ["hideObjectGlobal",2]} foreach (nearestTerrainObjects [position _road,["tree","bush"],15])};
						};
					};
				};
			};
		};
	};