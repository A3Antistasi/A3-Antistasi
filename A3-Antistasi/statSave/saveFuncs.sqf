fn_SaveStat =
{
	_varName = _this select 0;
	_varValue = _this select 1;
	if (!isNil "_varValue") then
		{
		if (worldName == "Tanoa") then {profileNameSpace setVariable [_varName + serverID + "WotP",_varValue]} else {profileNameSpace setVariable [_varName + serverID + "Antistasi" + worldName,_varValue]};
		if (isDedicated) then {saveProfileNamespace};
		};
};

fn_LoadStat =
{
	private ["_varName","_varvalue"];
	_varName = _this select 0;
	if (worldName == "Tanoa") then {_varValue = profileNameSpace getVariable (_varName + serverID + "WotP")} else {_varValue = profileNameSpace getVariable (_varName + serverID + "Antistasi" + worldName)};
	if(isNil "_varValue") exitWith {diag_log format ["La variable %1 no existe en el entorno %2",_varname,(_varName + serverID + "WotP")]};
	[_varName,_varValue] call fn_SetStat;
};

//===========================================================================
//ADD VARIABLES TO THIS ARRAY THAT NEED SPECIAL SCRIPTING TO LOAD
/*specialVarLoads =
[
	"weaponsPlayer",
	"magazinesPlayer",
	"backpackPlayer",
	"mrkNATO",
	"mrkSDK",
	"prestigeNATO","prestigeCSAT", "hr","planesAAFcurrent","helisAAFcurrent","APCAAFcurrent","tanksAAFcurrent","armas","items","mochis","municion","fecha", "WitemsPlayer","prestigeOPFOR","prestigeBLUFOR","resourcesAAF","resourcesFIA","skillFIA"];
*/
specialVarLoads =
["puestosFIA","minas","estaticas","cuentaCA","antenas","mrkNATO","mrkSDK","prestigeNATO","prestigeCSAT","posHQ", "hr","armas","items","mochis","municion","fecha", "prestigeOPFOR","prestigeBLUFOR","resourcesFIA","skillFIA","distanciaSPWN","civPerc","maxUnits","destroyedCities","garrison","tasks",/*"gogglesPlayer","vestPlayer","outfit","hat",*/"scorePlayer","rankPlayer","smallCAmrk","dinero","miembros","vehInGarage","destroyedBuildings","personalGarage","idlebases","idleassets","chopForest","weather","killZones","jna_dataList","controlesSDK","loadoutPlayer","mrkCSAT","nextTick","firstLoad"];
//THIS FUNCTIONS HANDLES HOW STATS ARE LOADED
fn_SetStat =
{
	_varName = _this select 0;
	_varValue = _this select 1;
	if(isNil '_varValue') exitWith {};
	if(_varName in specialVarLoads) then
	{
		if(_varName == 'firstLoad') then {firstLoad = false; publicVariable "firstLoad"};
		if(_varName == 'cuentaCA') then {cuentaCA = _varValue; publicVariable "cuentaCA"};
		if(_varName == 'nextTick') then {nextTick = time + _varValue};
		if(_varName == 'miembros') then {miembros = +_varValue; publicVariable "miembros"};
		if(_varName == 'smallCAmrk') then {smallCAmrk = +_varValue};
		if(_varName == 'mrkNATO') then {{lados setVariable [_x,malos,true]} forEach _varValue;};
		if(_varName == 'mrkCSAT') then {{lados setVariable [_x,muyMalos,true]} forEach _varValue;};
		if(_varName == 'mrkSDK') then {{lados setVariable [_x,buenos,true]} forEach _varValue;};
		if(_varName == 'controlesSDK') then
			{
			{
			lados setVariable [_x,buenos,true]
			} forEach _varValue;
			};
		if(_varName == 'chopForest') then {chopForest = _varValue; publicVariable "chopForest"};
		if(_varName == 'dinero') then {player setVariable ["dinero",_varValue,true];};
		if(_varName == 'loadoutPlayer') then
			{
			_pepe = + _varValue;
			if (isMultiplayer) then
				{
				removeAllItemsWithMagazines player;
				{player removeWeaponGlobal _x} forEach weapons player;
				removeBackpackGlobal player;
				removeVest player;
				if ((not("ItemGPS" in unlockedItems)) and ("ItemGPS" in (assignedItems player))) then {player unlinkItem "ItemGPS"};
				if ((!hayTFAR) and (!hayACRE) and ("ItemRadio" in (assignedItems player)) and (not("ItemRadio" in unlockedItems))) then {player unlinkItem "ItemRadio"};
				["loadoutPlayer", getUnitLoadout player] call fn_SaveStat;
				};
			player setUnitLoadout _pepe;
			};
		if(_varName == 'scorePlayer') then {player setVariable ["score",_varValue,true];};
		if(_varName == 'rankPlayer') then {player setRank _varValue; player setVariable ["rango",_varValue,true]};
		if(_varName == 'personalGarage') then {personalGarage = +_varValue};
		if(_varName == 'jna_dataList') then {jna_dataList = +_varValue};
		if(_varName == 'prestigeNATO') then {prestigeNATO = _varValue; publicVariable "prestigeNATO"};
		if(_varName == 'prestigeCSAT') then {prestigeCSAT = _varValue; publicVariable "prestigeCSAT"};
		if(_varName == 'hr') then {server setVariable ["HR",_varValue,true]};
		if(_varName == 'fecha') then {setDate _varValue};
		if(_varName == 'weather') then
			{
			0 setFog (_varValue select 0);
			0 setRain (_varValue select 1);
			forceWeatherChange
			};
		if(_varName == 'resourcesFIA') then {server setVariable ["resourcesFIA",_varValue,true]};
		if(_varName == 'destroyedCities') then {destroyedCities = +_varValue; publicVariable "destroyedCities"};
		if(_varName == 'skillFIA') then
			{
			skillFIA = _varValue; publicVariable "skillFIA";
			{
			_coste = server getVariable _x;
			for "_i" from 1 to _varValue do
				{
				_coste = round (_coste + (_coste * (_i/280)));
				};
			server setVariable [_x,_coste,true];
			} forEach soldadosSDK;
			};
		if(_varName == 'distanciaSPWN') then {distanciaSPWN = _varValue; distanciaSPWN1 = distanciaSPWN * 1.3; distanciaSPWN2 = distanciaSPWN /2; publicVariable "distanciaSPWN";publicVariable "distanciaSPWN1";publicVariable "distanciaSPWN2"};
		if(_varName == 'civPerc') then {civPerc = _varValue; if (civPerc < 1) then {civPerc = 35}; publicVariable "civPerc"};
		if(_varName == 'maxUnits') then {maxUnits=_varValue; publicVariable "maxUnits"};
		if(_varName == 'vehInGarage') then {vehInGarage= +_varValue; publicVariable "vehInGarage"};
		if(_varName == 'destroyedBuildings') then
			{
			destroyedBuildings= +_varValue;
			publicVariable "destroyedBuildings";
			{
			_buildings = nearestObjects [_x,listMilBld,50];
			if !(_buildings isEqualto []) then
				{
				(_buildings Select 0) setdamage [1,false];
				};
			} forEach destroyedBuildings;
			};
		if(_varName == 'minas') then
			{
			for "_i" from 0 to (count _varvalue) - 1 do
				{
				_tipoMina = _varvalue select _i select 0;
				switch _tipoMina do
					{
					case "APERSMine_Range_Ammo": {_tipoMina = "APERSMine"};
					case "ATMine_Range_Ammo": {_tipoMina = "ATMine"};
					case "APERSBoundingMine_Range_Ammo": {_tipoMina = "APERSBoundingMine"};
					case "SLAMDirectionalMine_Wire_Ammo": {_tipoMina = "SLAMDirectionalMine"};
					case "APERSTripMine_Wire_Ammo": {_tipoMina = "APERSTripMine"};
					case "ClaymoreDirectionalMine_Remote_Ammo": {_tipoMina = "Claymore_F"};
					};
				_posMina = _varvalue select _i select 1;
				_mina = createMine [_tipoMina, _posMina, [], 0];
				_detectada = _varvalue select _i select 2;
				{_x revealMine _mina} forEach _detectada;
				if (count (_varvalue select _i) > 3) then//borrar esto en febrero
					{
					_dirMina = _varvalue select _i select 3;
					_mina setDir _dirMina;
					};
				};
			};
		if(_varName == 'garrison') then
			{
			//_marcadores = marcadores - puestosFIA - controles - ciudades;
			{garrison setVariable [_x select 0,_x select 1,true]} forEach _varvalue;
			};
		if(_varName == 'puestosFIA') then
			{
			if (count (_varValue select 0) == 2) then
				{
				{
				_posicion = _x select 0;
				_garrison = _x select 1;
				_mrk = createMarker [format ["FIApost%1", random 1000], _posicion];
				_mrk setMarkerShape "ICON";
				_mrk setMarkerType "loc_bunker";
				_mrk setMarkerColor colorBuenos;
				if (isOnRoad _posicion) then {_mrk setMarkerText format ["%1 Roadblock",nameBuenos]} else {_mrk setMarkerText format ["%1 Watchpost",nameBuenos]};
				spawner setVariable [_mrk,2,true];
				if (count _garrison > 0) then {garrison setVariable [_mrk,_garrison,true]};
				puestosFIA pushBack _mrk;
				lados setVariable [_mrk,buenos,true];
				} forEach _varvalue;
				};
			/*
			else
				{
				{
				_mrk = createMarker [format ["FIApost%1", random 1000], _x];
				_mrk setMarkerShape "ICON";
				_mrk setMarkerType "loc_bunker";
				_mrk setMarkerColor colorBuenos;
				if (isOnRoad _x) then
					{
					_mrk setMarkerText format ["%1 Roadblock",nameBuenos];
					}
				else
					{
					_mrk setMarkerText format ["%1 Watchpost",nameBuenos];
					};
				spawner setVariable [_mrk,2,true];
				puestosFIA pushBack _mrk;
				_garrison = [staticCrewBuenos];
				{
				if (random 20 <= skillFIA) then {_garrison pushBack (_x select 1)} else {_garrison pushBack (_x select 0)};
				} forEach gruposSDKAT;
				garrison setVariable [_mrk,_garrison,true];
				} forEach _varvalue;
				};
			*/};

		if(_varName == 'antenas') then
			{
			antenasmuertas = +_varvalue;
			for "_i" from 0 to (count _varvalue - 1) do
			    {
			    _posAnt = _varvalue select _i;
			    _mrk = [mrkAntenas, _posAnt] call BIS_fnc_nearestPosition;
			    _antena = [antenas,_mrk] call BIS_fnc_nearestPosition;
			    {if ([antenas,_x] call BIS_fnc_nearestPosition == _antena) then {[_x,false] spawn apagon}} forEach ciudades;
			    antenas = antenas - [_antena];
			    _antena removeAllEventHandlers "Killed";
			    sleep 1;
			    _antena setDamage 1;
			    deleteMarker _mrk;
			    };
			antenasmuertas = _varvalue;
			publicVariable "antenas";
			publicVariable "antenasMuertas";
			};
		if(_varname == 'prestigeOPFOR') then
			{
			for "_i" from 0 to (count ciudades) - 1 do
				{
				_ciudad = ciudades select _i;
				_datos = server getVariable _ciudad;
				_numCiv = _datos select 0;
				_numVeh = _datos select 1;
				_prestigeOPFOR = _varvalue select _i;
				_prestigeBLUFOR = _datos select 3;
				_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR];
				server setVariable [_ciudad,_datos,true];
				};
			};
		if(_varname == 'prestigeBLUFOR') then
			{
			for "_i" from 0 to (count ciudades) - 1 do
				{
				_ciudad = ciudades select _i;
				_datos = server getVariable _ciudad;
				_numCiv = _datos select 0;
				_numVeh = _datos select 1;
				_prestigeOPFOR = _datos select 2;
				_prestigeBLUFOR = _varvalue select _i;
				_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR];
				server setVariable [_ciudad,_datos,true];
				};
			};
		if(_varname == 'idlebases') then
			{
			{
			server setVariable [(_x select 0),(_x select 1),true];
			} forEach _varValue;
			};
		if(_varname == 'idleassets') then
			{
			{
			timer setVariable [(_x select 0),(_x select 1),true];
			} forEach _varValue;
			};
		if(_varname == 'killZones') then
			{
			{
			killZones setVariable [(_x select 0),(_x select 1),true];
			} forEach _varValue;
			};
		if(_varName == 'posHQ') then
			{
			{if (getMarkerPos _x distance _varvalue < 1000) then
				{
				lados setVariable [_x,buenos,true];
				};
			} forEach controles;
			"respawn_guerrila" setMarkerPos _varValue;
			petros setPos _varvalue;
			if (chopForest) then
				{
				if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [position petros,["tree","bush"],70])} else {{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [position petros,["tree","bush"],70])};
				};
			[] spawn buildHQ;
			};
		if(_varname == 'estaticas') then
			{
			for "_i" from 0 to (count _varvalue) - 1 do
				{
				_tipoVeh = _varvalue select _i select 0;
				_posVeh = _varvalue select _i select 1;
				_dirVeh = _varvalue select _i select 2;
				_veh = createVehicle [_tipoVeh,[0,0,0],[],0,"NONE"];
				_veh setPos _posVeh;
				_veh setDir _dirVeh;
				_veh setVectorUp surfaceNormal (position _veh);
				if ((_veh isKindOf "StaticWeapon") or (_veh isKindOf "Building")) then
					{
					staticsToSave pushBack _veh;
					};
				[_veh] call AIVEHinit;
				};
			publicVariable "staticsToSave";
			};
		if(_varname == 'tasks') then
			{
			{
			if (_x == "AtaqueAAF") then
				{
				[] call ataqueAAF;
				}
			else
				{
				if (_x == "DEF_HQ") then
					{
					[] spawn ataqueHQ;
					}
				else
					{
					[_x,true] call missionRequest;
					};
				};
			} forEach _varvalue;
			};
	}
	else
	{
		call compile format ["%1 = %2",_varName,_varValue];
	};
};

//==================================================================================================================================================================================================
saveFuncsLoaded = true;