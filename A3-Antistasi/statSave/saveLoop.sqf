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
			_resourcesBackground = player getVariable "dinero";
			{
			_amigo = _x;
			if ((!isPlayer _amigo) and (alive _amigo)) then
				{
				_resourcesBackground = _resourcesBackground + (server getVariable (typeOf _amigo));
				if (vehicle _amigo != _amigo) then
					{
					_veh = vehicle _amigo;
					_typeVehX = typeOf _veh;
					if (not(_veh in staticsToSave)) then
						{
						if ((_veh isKindOf "StaticWeapon") or (driver _veh == _amigo)) then
							{
							_resourcesBackground = _resourcesBackground + ([_typeVehX] call A3A_fnc_vehiclePrice);
							if (count attachedObjects _veh != 0) then {{_resourcesBackground = _resourcesBackground + ([typeOf _x] call A3A_fnc_vehiclePrice)} forEach attachedObjects _veh};
							};
						};
					};
				};
			} forEach units group player;
			["dinero",_resourcesBackground] call fn_SaveStat;
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
	["membersX", membersX] call fn_SaveStat;
	["antennas", antennasDead] call fn_SaveStat;
	//["mrkNATO", (markersX - controlsX) select {lados getVariable [_x,sideUnknown] == Occupants}] call fn_SaveStat;
	["mrkSDK", (markersX - controlsX - outpostsFIA) select {lados getVariable [_x,sideUnknown] == buenos}] call fn_SaveStat;
	["mrkCSAT", (markersX - controlsX) select {lados getVariable [_x,sideUnknown] == }] call fn_SaveStat;
	["posHQ", [getMarkerPos respawnTeamPlayer,getPos fuego,[getDir caja,getPos caja],[getDir mapa,getPos mapa],getPos flagX,[getDir vehicleBox,getPos vehicleBox]]] call fn_Savestat;
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
private ["_hrBackground","_resourcesBackground","_veh","_typeVehX","_armas","_ammunition","_items","_mochis","_containers","_arrayEst","_posVeh","_dierVeh","_prestigeOPFOR","_prestigeBLUFOR","_city","_datos","_markersX","_garrison","_arrayMrkMF","_arrayOutpostsFIA","_posoutpost","_tipoMina","_posMina","_detected","_tipos","_exists","_amigo"];

_hrBackground = (server getVariable "hr") + ({(alive _x) and (not isPlayer _x) and (_x getVariable ["spawner",false]) and ((group _x in (hcAllGroups theBoss) or (isPlayer (leader _x))) and (side group _x == buenos))} count allUnits);
_resourcesBackground = server getVariable "resourcesFIA";
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
			_resourcesBackground = _resourcesBackground + (server getVariable [(typeOf _amigo),0]);
			_mochi = backpack _amigo;
			if (_mochi != "") then
				{
				switch (_mochi) do
					{
					case MortStaticSDKB: {_resourcesBackground = _resourcesBackground + ([SDKMortar] call A3A_fnc_vehiclePrice)};
					case AAStaticSDKB: {_resourcesBackground = _resourcesBackground + ([staticAABuenos] call A3A_fnc_vehiclePrice)};
					case MGStaticSDKB: {_resourcesBackground = _resourcesBackground + ([SDKMGStatic] call A3A_fnc_vehiclePrice)};
					case ATStaticSDKB: {_resourcesBackground = _resourcesBackground + ([staticATBuenos] call A3A_fnc_vehiclePrice)};
					};
				};
			if (vehicle _amigo != _amigo) then
				{
				_veh = vehicle _amigo;
				_typeVehX = typeOf _veh;
				if (not(_veh in staticsToSave)) then
					{
					if ((_veh isKindOf "StaticWeapon") or (driver _veh == _amigo)) then
						{
						if ((group _amigo in (hcAllGroups theBoss)) or (!isMultiplayer)) then
							{
							_resourcesBackground = _resourcesBackground + ([_typeVehX] call A3A_fnc_vehiclePrice);
							if (count attachedObjects _veh != 0) then {{_resourcesBackground = _resourcesBackground + ([typeOf _x] call A3A_fnc_vehiclePrice)} forEach attachedObjects _veh};
							};
						};
					};
				};
			};
		};
	};
} forEach allUnits;


["resourcesFIA", _resourcesBackground] call fn_SaveStat;
["hr", _hrBackground] call fn_SaveStat;
["vehInGarage", _vehInGarage] call fn_SaveStat;

_arrayEst = [];
{
_veh = _x;
_typeVehX = typeOf _veh;
if ((_veh distance getMarkerPos respawnTeamPlayer < 50) and !(_veh in staticsToSave) and !(_typeVehX in ["ACE_SandbagObject","Land_PaperBox_01_open_boxes_F","Land_PaperBox_01_open_empty_F"])) then
	{
	if (((not (_veh isKindOf "StaticWeapon")) and (not (_veh isKindOf "ReammoBox")) and (not (_veh isKindOf "FlagCarrier")) and (not(_veh isKindOf "Building"))) and (not (_typeVehX == "C_Van_01_box_F")) and (count attachedObjects _veh == 0) and (alive _veh) and ({(alive _x) and (!isPlayer _x)} count crew _veh == 0) and (not(_typeVehX == "WeaponHolderSimulated"))) then
		{
		_posVeh = getPos _veh;
		_dirVeh = getDir _veh;
		_arrayEst pushBack [_typeVehX,_posVeh,_dirVeh];
		};
	};
} forEach vehicles - [caja,flagX,fuego,vehicleBox,mapa];

_sitios = markersX select {lados getVariable [_x,sideUnknown] == buenos};
{
_positionX = position _x;
if ((alive _x) and !(surfaceIsWater _positionX) and !(isNull _x)) then
	{
	_arrayEst pushBack [typeOf _x,getPos _x,getDir _x];
	/*
	_nearX = [_sitios,_positionX] call BIS_fnc_nearestPosition;
	if (_positionX inArea _nearX) then
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
_city = _x;
_datos = server getVariable _city;
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
_dirMine = getDir _x;
_detected = [];
if (_x mineDetectedBy buenos) then
	{
	_detected pushBack buenos
	};
if (_x mineDetectedBy Occupants) then
	{
	_detected pushBack Occupants
	};
if (_x mineDetectedBy ) then
	{
	_detected pushBack 
	};
_arrayMines = _arrayMines + [[_tipoMina,_posMina,_detected,_dirMine]];
} forEach allMines;

["minas", _arrayMines] call fn_SaveStat;

_arrayOutpostsFIA = [];

{
_posoutpost = getMarkerPos _x;
_arrayOutpostsFIA pushBack [_posoutpost,garrison getVariable [_x,[]]];
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
} forEach airportsX + outposts;

["idlebases",_datos] call fn_SaveStat;

_datos = [];
{
_datos pushBack [_x,timer getVariable _x];
} forEach (vehAttack + vehNATOAttackHelis + vehPlanes + vehCSATAttackHelis);

["idleassets",_datos] call fn_SaveStat;

_datos = [];
{
_datos pushBack [_x,killZones getVariable [_x,[]]];
} forEach airportsX + outposts;

["killZones",_datos] call fn_SaveStat;

_controlsX = controlsX select {(lados getVariable [_x,sideUnknown] == buenos) and (controlsX find _x < defaultControlIndex)};
["controlsSDK",_controlsX] call fn_SaveStat;

savingServer = false;
[[petros,"hint",format ["Savegame Done.\n\nYou won't lose your stats in the event of a game update.\n\nRemember: if you want to preserve any vehicle, it must be near the HQ Flag with no AI inside.\nIf AI are inside, you will save the funds you spent on it.\n\nAI will be refunded\n\nStolen and purchased Static Weapons need to be ASSEMBLED in order to be saved. You can save disassembled Static Weapons in the ammo box.\n\nMounted Statics (Mortar/AA/AT squads) won't get saved, but you will be able to recover the cost.\n\nSame for assigned vehicles more than 50m away from HQ.\n\n%1 fund count:\nHR: %2\nMoney: %3 €",nameTeamPlayer,_hrBackground,_resourcesBackground]],"A3A_fnc_commsMP"] call BIS_fnc_MP;
diag_log "Antistasi: Persistent Save Done";