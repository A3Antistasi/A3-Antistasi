if (isDedicated) exitWith {};

_chance = 8;
if (debug) then {_chance = 100};
_lado = malos;
if (count _this == 1) then
	{
	_markerX = _this select 0;
	if (_markerX isEqualType "") then
		{
		if (_markerX in airportsX) then {_chance = 30} else {_chance = 15};
		if (lados getVariable [_markerX,sideUnknown] == Invaders) then {_lado = Invaders};
		}
	else
		{
		_lado = side (group (_this select 0));
		_chance = random 25;
		};
	};

_texto = format ["<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];

if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOPlane] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 Planes Available<br/>",_texto,nameOccupants]} else {_texto = format ["%1 %2 Planes Unavailable<br/>",_texto,nameOccupants]}
		}
	else
		{
		if ([vehCSATPlane] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 Planes Available<br/>",_texto,nameInvaders]} else {_texto = format ["%1 %2 Planes Unavailable<br/>",_texto,nameInvaders]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ({[_x] call A3A_fnc_vehAvailable} count vehNATOAttackHelis > 0) then {_texto = format ["%1 %2 Attack Helis Available<br/>",_texto,nameOccupants]} else {_texto = format ["%1 %2 Attack Helis Unavailable<br/>",_texto,nameOccupants]}
		}
	else
		{
		if ({[_x] call A3A_fnc_vehAvailable} count vehCSATAttackHelis > 0) then {_texto = format ["%1 %2 Attack Helis Available<br/>",_texto,nameInvaders]} else {_texto = format ["%1 %2 Attack Helis Unavailable<br/>",_texto,nameInvaders]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ({[_x] call A3A_fnc_vehAvailable} count vehNATOAPC > 0) then {_texto = format ["%1 %2 APCs Available<br/>",_texto,nameOccupants]} else {_texto = format ["%1 %2 APCs Unavailable<br/>",_texto,nameOccupants]}
		}
	else
		{
		if ({[_x] call A3A_fnc_vehAvailable} count vehCSATAPC > 0) then {_texto = format ["%1 %2 APCs Available<br/>",_texto,nameInvaders]} else {_texto = format ["%1 %2 APCs Unavailable<br/>",_texto,nameInvaders]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOTank] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 Tanks Available<br/>",_texto,nameOccupants]} else {_texto = format ["%1 %2 Tanks Unavailable<br/>",_texto,nameOccupants]}
		}
	else
		{
		if ([vehCSATTank] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 Tanks Available<br/>",_texto,nameInvaders]} else {_texto = format ["%1 %2 Tanks Unavailable<br/>",_texto,nameInvaders]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOAA] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 AA Tanks Available<br/>",_texto,nameOccupants]} else {_texto = format ["%1 %2 AA Tanks Unavailable<br/>",_texto,nameOccupants]}
		}
	else
		{
		if ([vehCSATAA] call A3A_fnc_vehAvailable) then {_texto = format ["%1 %2 AA Tanks Available<br/>",_texto,nameInvaders]} else {_texto = format ["%1 %2 AA Tanks Unavailable<br/>",_texto,nameInvaders]}
		};
	};

_minesAAF = allmines - (detectedMines teamPlayer);
if (_lado == malos) then {_minesAAF = _minesAAF - (detectedMines Invaders)} else {_minesAAF = _minesAAF - (detectedMines malos)};
_revealMineX = false;
if (count _minesAAF > 0) then
	{
	{if (random 100 < _chance) then {teamPlayer revealMine _x; _revealMineX = true}} forEach _minesAAF;
	};
if (_revealMineX) then {_texto = format ["%1 New Mines marked on your map<br/>",_texto];};

if (_texto == "<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>") then {_texto = format ["<t size='0.6' color='#C1C0BB'>Intel Not Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];};

//[_texto,-0.9999,0,30,0,0,4] spawn bis_fnc_dynamicText;
[_texto, [safeZoneX, (0.2 * safeZoneW)], [0.25, 0.5], 30, 0, 0, 4] spawn bis_fnc_dynamicText;
