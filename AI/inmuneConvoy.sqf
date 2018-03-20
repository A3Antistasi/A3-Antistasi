if (!isServer and hasInterface) exitWith{};

private ["_veh","_text","_pos","_side","_newPos","_road"];

_veh = _this select 0;
_text = _this select 1;
_enemigo = true;
_convoy = false;

if ((_text == "Convoy Objective") or (_text == "Mission Vehicle")) then {_convoy = true;};

waitUntil {sleep 1; (not(isNull driver _veh)) or _convoy};

if (debug) then {revelar = true};

_veh setVariable ["revelado",false];
while {alive _veh} do
	{
	if (!(_veh getVariable ["revelado",false])) then
		{
		if ((buenos knowsAbout _veh > 1.4) or (!_enemigo) or revelar or _convoy) then
			{
			//_revelado = true;
			_veh setVariable ["revelado",true];
			[_veh,_text] remoteExec ["vehicleMarkers",[buenos,civilian]];
			};
		};
	_pos = getPos _veh;
	sleep 50;
	_newPos = getPos _veh;
	/*
	if (_aRevelar and revelar) then
		{
		[_veh,_text] remoteExec ["vehicleMarkers",[buenos,civilian]];
		};
	*/
	if (_newPos distance _pos < 5) then
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
				if ({_x distance _newPos < 500} count (allPlayers - hcArray) == 0) then
					{
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