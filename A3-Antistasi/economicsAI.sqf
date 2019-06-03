{
_lado = _x;
_accelerator = if (_lado == malos) then {if (tierWar == 1) then {0} else {1+((tierWar + difficultyCoef)/20)}} else {1.2+((tierWar + difficultyCoef)/20)};
_airbases = {lados getVariable [_x,sideUnknown] == _lado} count airportsX;
_outposts =  {lados getVariable [_x,sideUnknown] == _lado} count outposts;
_seaports = {lados getVariable [_x,sideUnknown] == _lado} count seaports;
//at
_maxItems = (_outposts * 0.2) + (_airbases * 0.5);
_tipo = if (_lado == malos) then {staticATOccupants} else {staticATInvaders};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _accelerator),true];
	};
//aa
_maxItems = (_airbases * 2);
_tipo = if (_lado == malos) then {staticAAOccupants} else {staticAAInvaders};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _accelerator),true];
	};
//apcs
_maxItems = (_outposts * 0.3) + (_airbases * 2);
_tipo = if (_lado == malos) then {vehNATOAPC} else {vehCSATAPC};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _accelerator),true];
		};
	};
//tanks
_maxItems = (_outposts * 0.5) + (_airbases * 2);
_tipo = if (_lado == malos) then {vehNATOTank} else {vehCSATTank};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _accelerator),true];
	};
//aaTANKS
_maxItems = _airbases;
_tipo = if (_lado == malos) then {vehNATOAA} else {vehCSATAA};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.1 * _accelerator),true];
	};
//ATTACK BOATS
_maxItems = _seaports;
_tipo = if (_lado == malos) then {vehNATOBoat} else {vehCSATBoat};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.3 * _accelerator),true];
	};
//CAS PLANE
_maxItems = _airbases * 4;
_tipo = if (_lado == malos) then {vehNATOPlane} else {vehCSATPlane};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _accelerator),true];
	};
//AA PLANE
_maxItems = _airbases * 4;
_tipo = if (_lado == malos) then {vehNATOPlaneAA} else {vehCSATPlaneAA};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _accelerator),true];
	};
//AIR TRANSPORTS
_maxItems = _airbases * 4;
_tipo = if (_lado == malos) then {vehNATOTransportHelis - [vehNATOPatrolHeli]} else {vehCSATTransportHelis - [vehCSATPatrolHeli]};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _accelerator),true];
		};
	};
//ATTACK HELIS
_maxItems = _airbases * 4;
_tipo = if (_lado == malos) then {vehNATOAttackHelis} else {vehCSATAttackHelis};
if !(_tipo isEqualTo []) then
	{
	_currentItems = 0;
	{_currentItems = _currentItems + (timer getVariable [_x,0])} forEach _tipo;
	if (_currentItems < _maxItems) then
		{
		timer setVariable [selectRandom _tipo,_currentItems + (0.2 * _accelerator),true];
		};
	};
//ARTY
_maxItems = _airbases + (_outposts * 0.2);
_tipo = if (_lado == malos) then {vehNATOMRLS} else {vehCSATMRLS};
_currentItems = timer getVariable [_tipo,0];
if (_currentItems < _maxItems) then
	{
	timer setVariable [_tipo,_currentItems + (0.2 * _accelerator),true];
	};
} forEach [malos,Invaders];