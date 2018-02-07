if (isDedicated) exitWith {};

_chance = 8;
if (debug) then {_chance = 100};
_lado = malos;
if (count _this == 1) then
	{
	_marcador = _this select 0;
	if (_marcador isEqualType "") then
		{
		if (_marcador in aeropuertos) then {_chance = 30} else {_chance = 15};
		if (_marcador in mrkCSAT) then {_lado = muyMalos};
		}
	else
		{
		_lado = (_this select 0) getVariable "lado";
		_chance = random 25;
		};
	};

_texto = format ["<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];

if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOPlane] call vehAvailable) then {_texto = format ["%1 NATO Planes Available<br/>",_texto]} else {_texto = format ["%1 NATO Planes Unavailable<br/>",_texto]}
		}
	else
		{
		if ([vehCSATPlane] call vehAvailable) then {_texto = format ["%1 CSAT Planes Available<br/>",_texto]} else {_texto = format ["%1 CSAT Planes Unavailable<br/>",_texto]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ({[_x] call vehAvailable} count vehNATOAttackHelis > 0) then {_texto = format ["%1 NATO Attack Helis Available<br/>",_texto]} else {_texto = format ["%1 NATO Attack Helis Unavailable<br/>",_texto]}
		}
	else
		{
		if ({[_x] call vehAvailable} count vehCSATAttackHelis > 0) then {_texto = format ["%1 CSAT Attack Helis Available<br/>",_texto]} else {_texto = format ["%1 CSAT Attack Helis Unavailable<br/>",_texto]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ({[_x] call vehAvailable} count vehNATOAPC > 0) then {_texto = format ["%1 NATO APCs Available<br/>",_texto]} else {_texto = format ["%1 NATO APCs Unavailable<br/>",_texto]}
		}
	else
		{
		if ({[_x] call vehAvailable} count vehCSATAPC > 0) then {_texto = format ["%1 CSAT APCs Available<br/>",_texto]} else {_texto = format ["%1 CSAT APCs Unavailable<br/>",_texto]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOTank] call vehAvailable) then {_texto = format ["%1 NATO Tanks Available<br/>",_texto]} else {_texto = format ["%1 NATO Tanks Unavailable<br/>",_texto]}
		}
	else
		{
		if ([vehCSATTank] call vehAvailable) then {_texto = format ["%1 CSAT Tanks Available<br/>",_texto]} else {_texto = format ["%1 CSAT Tanks Unavailable<br/>",_texto]}
		};
	};
if (random 100 < _chance) then
	{
	if (_lado == malos) then
		{
		if ([vehNATOAA] call vehAvailable) then {_texto = format ["%1 NATO AA Tanks Available<br/>",_texto]} else {_texto = format ["%1 NATO AA Tanks Unavailable<br/>",_texto]}
		}
	else
		{
		if ([vehCSATAA] call vehAvailable) then {_texto = format ["%1 CSAT AA Tanks Available<br/>",_texto]} else {_texto = format ["%1 CSAT AA Tanks Unavailable<br/>",_texto]}
		};
	};

_minasAAF = allmines - (detectedMines buenos);
if (_lado == malos) then {_minasAAF = _minasAAF - (detectedMines muyMalos)} else {_minasAAF = _minasAAF - (detectedMines malos)};
_revelaMina = false;
if (count _minasAAF > 0) then
	{
	{if (random 100 < _chance) then {buenos revealMine _x; _revelaMina = true}} forEach _minasAAF;
	};
if (_revelaMina) then {_texto = format ["%1 New Mines marked on your map<br/>",_texto];};

if (_texto == "<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>") then {_texto = format ["<t size='0.6' color='#C1C0BB'>Intel Not Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];};

//[_texto,-0.9999,0,30,0,0,4] spawn bis_fnc_dynamicText;
[_texto, [safeZoneX, (0.2 * safeZoneW)], [0.25, 0.5], 30, 0, 0, 4] spawn bis_fnc_dynamicText;
