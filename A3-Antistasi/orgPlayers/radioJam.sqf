private _jammed = false;
private _lado = side player;
while {true} do
	{
	private _antena = if (_lado == malos) then {[([cajaVeh] + antenas),player] call BIS_fnc_nearestPosition} else {[antenas,player] call BIS_fnc_nearestPosition};
	if (player distance2D _antena < 1000) then
		{
		if ((_lado == malos) and (_antena == cajaVeh)) then
			{
			_jammed = true;
			}
		else
			{
			_puesto = "";
			{
			if (_antena inArea _x) exitWith {_puesto = _x};
			} forEach puestos;
			if (_puesto != "") then
				{
				if (lados getVariable [_puesto,sideUnknown] != _lado) then {_jammed = true};
				};
			};
		};
	if (_jammed) then
		{
		while {_jammed and (alive _antena)} do
			{
			_dist = player distance2D _antena;
   			//_interference = 99 - ((_dist / 1000) * 99) + 1;
   			_interference = _dist / 1000;
   			player setVariable ["tf_receivingDistanceMultiplicator", _interference];
			player setVariable ["tf_transmittingDistanceMultiplicator", _interference];
			if (_dist > 1000) exitWith
				{
				_jammed = false;
				player setVariable ["tf_receivingDistanceMultiplicator", 1];
				player setVariable ["tf_transmittingDistanceMultiplicator", 1];
				};
			sleep 10;
			};
		};
	sleep 10;
	};