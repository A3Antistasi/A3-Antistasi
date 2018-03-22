private ["_pool","_vehInGarage","_chequeo"];

_pool = true;
if (_this select 0) then {_pool = false};
if (_pool and (not([player] call isMember))) exitWith {hint "You cannot access the Garage as you are guest in this server"};
if (player != player getVariable "owner") exitWith {hint "You cannot access the Garage while you are controlling AI"};
_chequeo = false;
{
	if (((side _x == muyMalos) or (side _x == malos)) and (_x distance player < 500) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot manage the Garage with enemies nearby"};
vehInGarageShow = [];
_hayAire = false;
_aeropuertos = aeropuertos select {_x in mrkSDK and (player distance getMarkerPos _x < 100)};
if (count _aeropuertos > 0) then {_hayAire = true};
_hayMar = false;
garagePos = [];
garagePosSea = [];
for "_i" from 0 to 3 do
	{
	_pos = (position player) getPos [200,(_i*90)];
	if (surfaceIsWater _pos) exitWith
		{
		_hayMar = true;
		garagePosSea = [position player, 10, 200, 10, 2, 0.3, 1] call BIS_Fnc_findSafePos;
		};
	};
{
if (_x in vehBoats) then
	{
	if (_hayMar) then {vehInGarageShow pushBack _x};
	}
else
	{
	if ((_x in vehPlanes) or (_x in vehAttackHelis) or (_x in vehTransportAir)) then
		{
		if (_hayAire) then {vehInGarageShow pushBack _x};
		}
	else
		{
		vehInGarageShow pushBack _x;
		};
	};
} forEach (if (_pool) then {vehInGarage} else {personalGarage});

if (count vehInGarageShow == 0) exitWith {hintC "The Garage is empty or the vehicles you have are not suitable to recover in the place you are.\n\nAir vehicles need to be recovered near Airport flags.\n\nShips need to ve recovered on shore areas"};

garagePos = position player findEmptyPosition [5,45,"B_MBT_01_TUSK_F"];
if (count garagePos == 0) exitWith {hintC "Couldn't find a safe position to spawn the vehicle, or the area is too crowded to spawn it safely"};

cuentaGarage = 0;
_tipo = vehInGarageShow select cuentaGarage;
Cam = "camera" camCreate (player modelToWorld [0,0,4]);
Cam cameraEffect ["internal", "BACK"];
//garageVeh = (vehInGarage select cuentaGarage) createVehicle garagePos;
if (_tipo in vehBoats) then
	{
	garageVeh = createVehicle [_tipo, garagePosSea, [], 0, "NONE"];
	Cam camSetTarget garagePosSea;
	}
else
	{
	garageVeh = createVehicle [_tipo, garagePos, [], 0, "NONE"];
	Cam camSetTarget garagePos;
	};
Cam camCommit 0;
garageVeh allowDamage false;
garageVeh enableSimulationGlobal false;
/*
cam = "camera" camcreate garagePos;
cam cameraeffect ["internal","back"];
cam campreparefocus [-1,-1];
cam campreparefov 0.35;
cam camcommitprepared 0;
cameraEffectEnableHUD true;
showcinemaborder false;
*/


["<t size='0.6'>Garage Keys.<t size='0.5'><br/>A-D Navigate<br/>SPACE to Select<br/>ENTER to Exit",0,0,5,0,0,4] spawn bis_fnc_dynamicText;

garageKeys = (findDisplay 46) displayAddEventHandler ["KeyDown",
		{
		_handled = false;
		_salir = false;
		_cambio = false;
		_comprado = false;
		["<t size='0.6'>Garage Keys.<t size='0.5'><br/>A-D Navigate<br/>SPACE to Select<br/>ENTER to Exit",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
		if (_this select 1 == 57) then
			{
			_salir = true;
			_comprado = true;
			};
		if (_this select 1 == 28) then
			{
			_salir = true;
			deleteVehicle garageVeh;
			};
		if (_this select 1 == 32) then
			{
			if (cuentaGarage + 1 > (count vehInGarageShow) - 1) then {cuentaGarage = 0} else {cuentaGarage = cuentaGarage + 1};
			_cambio = true;
			//["",0,0,0.34,0,0,4] spawn bis_fnc_dynamicText;
			};
		if (_this select 1 == 30) then
			{
			if (cuentaGarage - 1 < 0) then {cuentaGarage = (count vehInGarageShow) - 1} else {cuentaGarage = cuentaGarage - 1};
			_cambio = true;
			//["",0,0,0.34,0,0,4] spawn bis_fnc_dynamicText;
			};
		if (_cambio) then
			{
			deleteVehicle garageVeh;
			_tipo = vehInGarageShow select cuentaGarage;
			if (isNil "_tipo") then {_salir = true};
			if (typeName _tipo != typeName "") then {_salir = true};
			if (!_salir) then
				{
				if (_tipo in vehBoats) then
					{
					garageVeh = createVehicle [_tipo, garagePosSea, [], 0, "NONE"];
					Cam camSetTarget garagePosSea;
					}
				else
					{
					garageVeh = createVehicle [_tipo, garagePos, [], 0, "NONE"];
					Cam camSetTarget garagePos;
					};
				Cam camCommit 0;
				garageVeh allowDamage false;
				garageVeh enableSimulationGlobal false;
				};
			};
		if (_salir) then
			{
			Cam camSetPos position player;
			Cam camCommit 1;
			Cam cameraEffect ["terminate", "BACK"];
			camDestroy Cam;
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", garageKeys];
			if (!_comprado) then
				{
				["",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
				}
			else
				{
				[garageVeh] call AIVEHinit;
				["<t size='0.6'>Vehicle retrieved from Garage",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
				_pool = false;
				if (vehInGarageShow isEqualTo vehInGarage) then {_pool = true};
				_newArr = [];
				_found = false;
				if (_pool) then
					{
					{
					if ((_x != (vehInGarageShow select cuentaGarage)) or (_found)) then {_newArr pushBack _x} else {_found = true};
					} forEach vehInGarage;
					vehInGarage = _newArr;
					publicVariable "vehInGarage";
					}
				else
					{
					{
					if ((_x != (vehInGarageShow select cuentaGarage)) or (_found)) then {_newArr pushBack _x} else {_found = true};
					} forEach personalGarage;
					personalGarage = _newArr;
					["personalGarage",_newArr] call fn_SaveStat;
					garageVeh setVariable ["duenyo",getPlayerUID player,true];
					};
				if (garageVeh isKindOf "StaticWeapon") then {staticsToSave = staticsToSave + [garageVeh]; publicVariable "staticsToSave"};
				clearMagazineCargoGlobal garageVeh;
				clearWeaponCargoGlobal garageVeh;
				clearItemCargoGlobal garageVeh;
				clearBackpackCargoGlobal garageVeh;
				garageVeh allowDamage true;
				garageVeh enableSimulationGlobal true;
				};
			};
		_handled;
		}];

