private ["_chequeo","_pos","_veh","_newPos","_coste"];

_chequeo = false;
{
	if (((side _x == muyMalos) or (side _x == malos)) and (_x distance player < 500) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot buy vehicles with enemies nearby"};

_coste = server getVariable vehSDKBoat;

if (server getVariable "resourcesFIA" < _coste) exitWith {hint format ["You need %1 € to buy a boat",_coste]};

_ang = 0;
_dist = 200;

while {true} do
	{
	_pos = [position player, _dist, _ang] call BIS_Fnc_relPos;
	if (surfaceIsWater _pos) then
		{
		while {true} do
			{
			_dist = _dist - 5;
			_newPos = [position player, _dist, _ang] call BIS_Fnc_relPos;
			if (!(surfaceIsWater _newPos)) exitWith {_chequeo = true};
			};
		};
	if (_chequeo) exitWith {};
	_ang = _ang + 31;
	};

_veh = vehSDKBoat createVehicle _pos;

[_veh] call AIVEHinit;
player reveal _veh;
[0,-200] remoteExec ["resourcesFIA",2];
hint "Boat purchased";