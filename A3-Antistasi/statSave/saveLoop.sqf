if (savingClient) exitWith {hint "Your personal stats are being saved"};
if (!isDedicated) then
	{
	if (side player == buenos) then
		{
		savingClient = true;
		["loadoutPlayer", getUnitLoadout player] call fn_SaveStat;
		//["gogglesPlayer", goggles player] call fn_SaveStat;
		//["vestPlayer", vest player] call fn_SaveStat;
		//["outfit", uniform player] call fn_SaveStat;
		//["hat", headGear player] call fn_SaveStat;
		if (isMultiplayer) then
			{
			["scorePlayer", player getVariable "score"] call fn_SaveStat;
			["rankPlayer",rank player] call fn_SaveStat;
			_personalGarage = [];
			_personalGarage = _personalGarage + personalGarage;
			["personalGarage",_personalGarage] call fn_SaveStat;
			_resfondo = player getVariable "dinero";
			{
			_amigo = _x;
			if ((!isPlayer _amigo) and (alive _amigo)) then
				{
				_resfondo = _resfondo + (server getVariable (typeOf _amigo));
				if (vehicle _amigo != _amigo) then
					{
					_veh = vehicle _amigo;
					_tipoVeh = typeOf _veh;
					if (not(_veh in staticsToSave)) then
						{
						if ((_veh isKindOf "StaticWeapon") or (driver _veh == _amigo)) then
							{
							_resfondo = _resfondo + ([_tipoVeh] call A3A_fnc_vehiclePrice);
							if (count attachedObjects _veh != 0) then {{_resfondo = _resfondo + ([typeOf _x] call A3A_fnc_vehiclePrice)} forEach attachedObjects _veh};
							};
						};
					};
				};
			} forEach units group player;
			["dinero",_resfondo] call fn_SaveStat;
			};
		savingClient = false;
		};
	};

 if (!isServer) exitWith {};
 if (savingServer) exitWith {"Server data save is still in progress" remoteExecCall ["hint",theBoss]};
 savingServer = true;
 private ["_garrison"];
	["countCA", countCA] call fn_SaveStat;
	["gameMode", gameMode] call fn_SaveStat;
	["difficultyX", skillMult] call fn_SaveStat;
	["bombRuns", bombRuns] call fn_SaveStat;
	["smallCAmrk", smallCAmrk] call fn_SaveStat;
	["miembros", miembros] call fn_SaveStat;
	["antenas", antennasDead] call fn_SaveStat;
	//["mrkNATO", (markersX - controlsX) select {lados getVariable [_x,sideUnknown] == malos}] call fn_SaveStat;
	["mrkSDK", (markersX - controlsX - outpostsFIA) select {lados getVariable [_x,sideUnknown] == buenos}] call fn_SaveStat;
	["mrkCSAT", (markersX - controlsX) select {lados getVariable [_x,sideUnknown] == muyMalos}] call fn_SaveStat;
	["posHQ", [getMarkerPos respawnTeamPlayer,getPos fuego,[getDir caja,getPos caja],[getDir mapa,getPos mapa],getPos bandera,[getDir cajaVeh,getPos cajaVeh]]] call fn_Savestat;
	["prestigeNATO", prestigeNATO] call fn_SaveStat;
	["prestigeCSAT", prestigeCSAT] call fn_SaveStat;
	["fecha", date] call fn_SaveStat;
	["skillFIA", skillFIA] call fn_SaveStat;
	["destroyedCities", destroyedCities] call fn_SaveStat;
	["distanceSPWN", distanceSPWN] call fn_SaveStat;
	["civPerc", civPerc] call fn_SaveStat;
	["chopForest", chopForest] call fn_SaveStat;
	["maxUnits", maxUnits] call fn_SaveStat;
	["nextTick", nextTick - time] call fn_SaveStat;
	/*
	["unlockedWeapons", unlockedWeapons] call fn_SaveStat;
	["unlockedItems", unlockedItems] call fn_SaveStat;
	["unlockedMagazines", unlockedMagazines] call fn_SaveStat;
	["unlockedBackpacks", unlockedBackpacks] call fn_SaveStat;
	*/
	["weather",[fogParams,rain]] call fn_SaveStat;
	["destroyedBuildings",destroyedBuildings] call fn_SaveStat;
	//["firstLoad",false] call fn_SaveStat;
private ["_hrfondo","_resfondo","_veh","_tipoVeh","_armas","_ammunition","_items","_mochis","_containers","_arrayEst","_posVeh","_dierVeh","_prestigeOPFOR","_prestigeBLUFOR","_ciudad","_datos","_markersX","_garrison","_arrayMrkMF","_arrayOutpostsFIA","_pospuesto","_tipoMina","_posMina","_detected","_tipos","_exists","_amigo"];

_hrfondo = (server getVariable "hr") + ({(alive _x) and (not isPlayer _x) and (_x getVariable ["spawner",false]) and ((group _x in (hcAllGroups theBoss) or (isPlayer (leader _x))) and (side group _x == buenos))} count allUnits);
_resfondo = server getVariable "resourcesFIA";
/*
_armas = [];
_ammunition = [];
_items = [];
_mochis = [];*/
_vehInGarage = [];
_vehInGarage = _vehInGarage + vehInGarage;
{
_amigo = _x;
if ((_amigo getVariable ["spawner",false]) and (side group _amigo == buenos))then
	{
	if ((alive _amigo) and (!isPlayer _amigo)) then
		{
		if (((isPlayer leader _amigo) and (!isMultiplayer)) or (group _amigo in (hcAllGroups theBoss)) and (not((group _amigo) getVariable ["esNATO",false]))) then
			{
			_resfondo = _resfondo + (server getVariable [(typeOf _amigo),0]);
			_mochi = backpack _amigo;
			if (_mochi != "") then
				{
				switch (_mochi) do
					{
					case MortStaticSDKB: {_resfondo = _resfondo + ([SDKMortar] call A3A_fnc_vehiclePrice)};
					case AAStaticSDKB: {_resfondo = _resfondo + ([staticAABuenos] call A3A_fnc_vehiclePrice)};
					case MGStaticSDKB: {_resfondo = _resfondo + ([SDKMGStatic] call A3A_fnc_vehiclePrice)};
					case ATStaticSDKB: {_resfondo = _resfondo + ([staticATBuenos] call A3A_fnc_vehiclePrice)};
					};
				};
			if (vehicle _amigo != _amigo) then
				{
				_veh = vehicle _amigo;
				_tipoVeh = typeOf _veh;
				if (not(_veh in staticsToSave)) then
					{
					if ((_veh isKindOf "StaticWeapon") or (driver _veh == _amigo)) then
						{
						if ((group _amigo in (hcAllGroups theBoss)) or (!isMultiplayer)) then
							{
							_resfondo = _resfondo + ([_tipoVeh] call A3A_fnc_vehiclePrice);
							if (count attachedObjects _veh != 0) then {{_resfondo = _resfondo + ([typeOf _x] call A3A_fnc_vehiclePrice)} forEach attachedObjects _veh};
							};
						};
					};
				};
			};
		};
	};
} forEach allUnits;


["resourcesFIA", _resfondo] call fn_SaveStat;
["hr", _hrfondo] call fn_SaveStat;
["vehInGarage", _vehInGarage] call fn_SaveStat;

_arrayEst = [];
{
_veh = _x;
_tipoVeh = typeOf _veh;
if ((_veh distance getMarkerPos respawnTeamPlayer < 50) and !(_veh in staticsToSave) and !(_tipoVeh in ["ACE_SandbagObject","Land_PaperBox_01_open_boxes_F","Land_PaperBox_01_open_empty_F"])) then
	{
	if (((not (_veh isKindOf "StaticWeapon")) and (not (_veh isKindOf "ReammoBox")) and (not (_veh isKindOf "FlagCarrier")) and (not(_veh isKindOf "Building"))) and (not (_tipoVeh == "C_Van_01_box_F")) and (count attachedObjects _veh == 0) and (alive _veh) and ({(alive _x) and (!isPlayer _x)} count crew _veh == 0) and (not(_tipoVeh == "WeaponHolderSimulated"))) then
		{
		_posVeh = getPos _veh;
		_dirVeh = getDir _veh;
		_arrayEst pushBack [_tipoVeh,_posVeh,_dirVeh];
		};
	};
} forEach vehicles - [caja,bandera,fuego,cajaveh,mapa];

_sitios = markersX select {lados getVariable [_x,sideUnknown] == buenos};
{
_posicion = position _x;
if ((alive _x) and !(surfaceIsWater _posicion) and !(isNull _x)) then
	{
	_arrayEst pushBack [typeOf _x,getPos _x,getDir _x];
	/*
	_cercano = [_sitios,_posicion] call BIS_fnc_nearestPosition;
	if (_posicion inArea _cercano) then
		{
		_arrayEst pushBack [typeOf _x,getPos _x,getDir _x]
		};
	*/
	};
} forEach staticsToSave;

["staticsX", _arrayEst] call fn_SaveStat;
[] call A3A_fnc_arsenalManage;

_jna_dataList = [];
_jna_dataList = _jna_dataList + jna_dataList;
["jna_dataList", _jna_dataList] call fn_SaveStat;

_prestigeOPFOR = [];
_prestigeBLUFOR = [];

{
_ciudad = _x;
_datos = server getVariable _ciudad;
_prestigeOPFOR = _prestigeOPFOR + [_datos select 2];
_prestigeBLUFOR = _prestigeBLUFOR + [_datos select 3];
} forEach citiesX;

["prestigeOPFOR", _prestigeOPFOR] call fn_SaveStat;
["prestigeBLUFOR", _prestigeBLUFOR] call fn_SaveStat;

_markersX = markersX - outpostsFIA - controlsX;
_garrison = [];
{
_garrison pushBack [_x,garrison getVariable [_x,[]]];
} forEach _markersX;

["garrison",_garrison] call fn_SaveStat;
/*
_arrayMrkMF = [];

{
_posMineF = getMarkerPos _x;
_arrayMrkMF = _arrayMrkMF + [_posMineF];
} forEach minefieldMrk;

["mineFieldMrk", _arrayMrkMF] call fn_SaveStat;
*/
_arrayMines = [];
{
_tipoMina = typeOf _x;
_posMina = getPos _x;
_dirMina = getDir _x;
_detected = [];
if (_x mineDetectedBy buenos) then
	{
	_detected pushBack buenos
	};
if (_x mineDetectedBy malos) then
	{
	_detected pushBack malos
	};
if (_x mineDetectedBy muyMalos) then
	{
	_detected pushBack muyMalos
	};
_arrayMines = _arrayMines + [[_tipoMina,_posMina,_detected,_dirMina]];
} forEach allMines;

["minas", _arrayMines] call fn_SaveStat;

_arrayOutpostsFIA = [];

{
_pospuesto = getMarkerPos _x;
_arrayOutpostsFIA pushBack [_pospuesto,garrison getVariable [_x,[]]];
} forEach outpostsFIA;

["outpostsFIA", _arrayOutpostsFIA] call fn_SaveStat;

if (!isDedicated) then
	{
	_tipos = [];
	{
	if ([_x] call BIS_fnc_taskExists) then
		{
		_state = [_x] call BIS_fnc_taskState;
		if (_state == "CREATED") then
			{
			_tipos pushBackUnique _x;
			};
		};
	} forEach ["AS","CON","DES","LOG","RES","CONVOY","DEF_HQ","AttackAAF"];

	["tasks",_tipos] call fn_SaveStat;
	};

_datos = [];
{
_datos pushBack [_x,server getVariable _x];
} forEach airportsX + puestos;

["idlebases",_datos] call fn_SaveStat;

_datos = [];
{
_datos pushBack [_x,timer getVariable _x];
} forEach (vehAttack + vehNATOAttackHelis + vehPlanes + vehCSATAttackHelis);

["idleassets",_datos] call fn_SaveStat;

_datos = [];
{
_datos pushBack [_x,killZones getVariable [_x,[]]];
} forEach airportsX + puestos;

["killZones",_datos] call fn_SaveStat;

_controlsX = controlsX select {(lados getVariable [_x,sideUnknown] == buenos) and (controlsX find _x < defaultControlIndex)};
["controlsSDK",_controlsX] call fn_SaveStat;

savingServer = false;
[[petros,"hint",format ["Savegame Done.\n\nYou won't lose your stats in the event of a game update.\n\nRemember: if you want to preserve any vehicle, it must be near the HQ Flag with no AI inside.\nIf AI are inside, you will save the funds you spent on it.\n\nAI will be refunded\n\nStolen and purchased Static Weapons need to be ASSEMBLED in order to be saved. You can save disassembled Static Weapons in the ammo box.\n\nMounted Statics (Mortar/AA/AT squads) won't get saved, but you will be able to recover the cost.\n\nSame for assigned vehicles more than 50m away from HQ.\n\n%1 fund count:\nHR: %2\nMoney: %3 €",nameTeamPlayer,_hrFondo,_resFondo]],"A3A_fnc_commsMP"] call BIS_fnc_MP;
diag_log "Antistasi: Persistent Save Done";