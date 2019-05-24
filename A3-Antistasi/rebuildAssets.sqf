
_resourcesFIA = server getVariable "resourcesFIA";

if (_resourcesFIA < 5000) exitWith {hint "You do not have enough money to rebuild any Asset. You need 5.000 €"};

_destroyedCities = destroyedCities - ciudades;

if (!visibleMap) then {openMap true};
positionTel = [];
hint "Click on the zone you want to rebuild.";

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_sitio = [marcadores,_positionTel] call BIS_fnc_nearestPosition;

if (getMarkerPos _sitio distance _positionTel > 50) exitWith {hint "You must click near a map marker"};

if ((not(_sitio in _destroyedCities)) and (!(_sitio in puestos))) exitWith {hint "You cannot rebuild that"};

_salir = false;
_antennaDead = [];
_texto = "That Outpost does not have a destroyed Radio Tower";
if (_sitio in puestos) then
	{
	_antennasDead = antennasDead select {_x inArea _sitio};
	if (count _antennasDead > 0) then
		{
		if (lados getVariable [_sitio, sideUnknown] != buenos) then
			{
			_salir = true;
			_texto = format ["You cannot rebuild a Radio Tower in an Outpost which does not belong to %1",nameBuenos];
			}
		else
			{
			_antennaDead = _antennasDead select 0;
			};
		}
	else
		{
		_salir = true
		};
	};

if (_salir) exitWith {hint format ["%1",_texto]};

if (count _antennaDead == 0) then
	{
	_nombre = [_sitio] call A3A_fnc_localizar;

	hint format ["%1 Rebuilt"];

	[0,10,_positionTel] remoteExec ["A3A_fnc_citySupportChange",2];
	[5,0] remoteExec ["A3A_fnc_prestige",2];
	destroyedCities = destroyedCities - [_sitio];
	publicVariable "destroyedCities";
	}
else
	{
	hint "Radio Tower rebuilt";
	antennasDead = antennasDead - [_antennaDead]; publicVariable "antennasDead";
	_antena = nearestBuilding _antennaDead;
	if (isMultiplayer) then {[_antena,true] remoteExec ["hideObjectGlobal",2]} else {_antena hideObject true};
	_antena = createVehicle ["Land_Communication_F", _antennaDead, [], 0, "NONE"];
	antenas pushBack _antena; publicVariable "antenas";
	{if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,true] spawn A3A_fnc_blackout}} forEach ciudades;
	_mrkfin = createMarker [format ["Ant%1", count antenas], _antennaDead];
	_mrkfin setMarkerShape "ICON";
	_mrkfin setMarkerType "loc_Transmitter";
	_mrkfin setMarkerColor "ColorBlack";
	_mrkfin setMarkerText "Radio Tower";
	mrkAntenas pushBack _mrkfin;
	publicVariable "mrkAntenas";
	_antena addEventHandler ["Killed",
		{
		_antena = _this select 0;
		{if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,false] spawn A3A_fnc_blackout}} forEach ciudades;
		_mrk = [mrkAntenas, _antena] call BIS_fnc_nearestPosition;
		antenas = antenas - [_antena]; antennasDead = antennasDead + [getPos _antena]; deleteMarker _mrk;
		["TaskSucceeded",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",buenos];
		["TaskFailed",["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification",malos];
		publicVariable "antenas"; publicVariable "antennasDead";
		}
		];
	};
[0,-5000] remoteExec ["A3A_fnc_resourcesFIA",2];