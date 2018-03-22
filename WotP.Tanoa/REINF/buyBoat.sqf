private ["_chequeo","_pos","_veh","_newPos","_coste"];

_chequeo = false;
{
	if (((side _x == muyMalos) or (side _x == malos)) and (_x distance player < 500) and (not(captive _x))) exitWith {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot buy vehicles with enemies nearby"};

private _tipo = _this select 0;

_coste = server getVariable _tipo;

if (server getVariable "resourcesFIA" < _coste) exitWith {hint format ["You need %1 € to buy a boat",_coste]};

_ang = 0;
_dist = 200;
private _posFinal = [0,0,0];
_posPlayer = position player;
while {true} do
	{
	_pos = _posPlayer getPos [_dist, _ang];
	if (surfaceIsWater _pos) then
		{
		_chequeo = true;
		while {_chequeo} do
			{
			_dist = _dist - 25;
			_newPos = _posPlayer getPos [_dist, _ang];
			if (!(surfaceIsWater _newPos)) then
				{
				_chequeo = false;
				if (_posFinal distance _posPlayer > _pos distance _posPlayer) then {_posFinal = _pos};
				};
			};
		};
	_ang = _ang + 31;
	if (_ang > 360) exitWith {};
	};

if (_posFinal isEqualTo [0,0,0]) exitWith {hint "To buy a boat you have to be near the coast shore"};

_veh = _tipo createVehicle _posFinal;

if (_tipo == civBoat) then {[_veh] spawn civVEHinit} else {[_veh] call AIVEHinit};
player reveal _veh;
[0,-200] remoteExec ["resourcesFIA",2];
hint "Boat purchased";