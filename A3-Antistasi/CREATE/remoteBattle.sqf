private _soldados = _this;

// Wait until no soldiers in vehicles
waitUntil {sleep 10;{([_x] call A3A_fnc_canFight) and (vehicle _x == _x)} count _soldados == {[_x] call A3A_fnc_canFight} count _soldados};


// If there are no soldiers we can early out
if ({[_x] call A3A_fnc_canFight} count _soldados == 0) exitWith {
	diag_log format["[remoteBattle] No soldiers can fight, exiting"];
};

// SDK join the other side always.
private _lado = side (group (_soldados select 0));
private _eny = [buenos];
if (_lado == malos) then {_eny pushBack muyMalos} else {_eny pushBack malos};

diag_log format["[remoteBattle] Starting %1 attacking %2", _lado, _eny];
// TODO: improve this simulation by looking at unit proximities.


// Loop until either the player arrives or all the soldiers are dead
while {true} do {
	// TODO: calculate sleep based on proximities of forces.
	sleep (10 + random(60)); //poner 10
	//sleep(1);

	_soldados = _soldados select {[_x] call A3A_fnc_canFight};
	if (_soldados isEqualTo []) exitWith {};
	_exit = false;
	_enemigos = [];
	{
		_soldado = _x;

		// For all existing units except the attackers
		// TODO: this is n*m operation, quite inefficient.
		{
			// Stop remote battle simulation if player is nearish.
			if ((isPlayer _x) and (_x distance _soldado < (2*distanciaSPWN))) then {
				_exit = true
			} else {
				// If the unit is enemy to the soldier, on foot and in proximity then add them to the list for combat simulation.
				if (([_x] call A3A_fnc_canFight) 
						and (side group _x in _eny) 
						and (vehicle _x == _x) 
						and (_x distance _soldado < (distanciaSPWN/2))) then {
					_enemigos pushBackUnique _x;
				};
			};
		} forEach (allUnits - _soldados);
	} forEach _soldados;

	if (_exit) exitWith {};

	diag_log format["[remoteBattle] %1 %2 vs %3 %4", count _soldados, _lado, count _enemigos, _eny];

	if !(_enemigos isEqualTo []) then {
		_chanceToKill = 50 * ((count _soldados) / (count _enemigos));
		if (random 100 <= _chanceToKill) then {
			(selectRandom _enemigos) setDamage 1;
		} else {
			(selectRandom _soldados) setDamage 1;
		};
	};
};