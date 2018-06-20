if (!isNil "placementDone") then
	{
	stavros allowDamage false;
	format ["%1 is Dead",name petros] hintC format ["%1 has been killed. You lost part of your assets and need to select a new HQ position far from any enemies.",name petros];
	}
else
	{
	diag_log "Antistasi: New Game selected";
	"Initial HQ Placement Selection" hintC ["Click on the map position you want to start the game.","Close the map with M to start in the default position.","Don't select areas with enemies nearby!\n\nGame experience changes significantly in different starting positions."];
	};

hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload",
	{
	0 = _this spawn
		{
		_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
		hintSilent "";
		};
	}];

private ["_posicionTel","_marcador","_marcadores"];
_marcadores = marcadores select {lados getVariable [_x,sideUnknown] != buenos};
_posicionTel = [];
if (isNil "placementDone") then
	{
	_marcadores = _marcadores - controles;
	openMap true;
	}
else
	{
	_marcadores = _marcadores - (controles select {!isOnRoad (getMarkerPos _x)});
	//openMap [true,true];
	openMap [true,true];
	};
_mrkDum = [];
{
_mrk = createMarkerLocal [format ["%1dumdum", count _mrkDum], getMarkerPos _x];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerSizeLocal [500,500];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrkDum pushBack _mrk;
} forEach _marcadores;
while {true} do
	{
	posicionTel = [];
	onMapSingleClick "posicionTel = _pos;";
	waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
	onMapSingleClick "";
	if (not visiblemap) exitWith {};
	_posicionTel = posicionTel;
	_marcador = [_marcadores,_posicionTel] call BIS_fnc_nearestPosition;
	if (getMarkerPos _marcador distance _posicionTel < 500) then {hint "Position selected is too close to enemy zones.\n\n Please select another position"};
	if (surfaceIsWater _posicionTel) then {hint "Selected position cannot be in water"};
	_enemigos = false;
	if (!isNil "placementDone") then
		{
		{
		if ((side _x == malos) or (side _x == muyMalos)) then
			{
			if (_x distance _posicionTel < 500) then {_enemigos = true};
			};
		} forEach allUnits;
		};
	if (_enemigos) then {hint "There are enemies in the surrounding area, please select another position."};
	if ((getMarkerPos _marcador distance _posicionTel >= 500) and (!surfaceIsWater _posicionTel) and (!_enemigos)) exitWith {};
	sleep 0.1;
	};
if (visiblemap) then
	{
	if (isNil "placementDone") then
		{
		{
		if (getMarkerPos _x distance _posicionTel < distanciaSPWN) then
			{
			lados setVariable [_x,buenos,true];
			};
		} forEach controles;
		petros setPos _posicionTel;
		}
	else
		{
		_controles = controles select {!(isOnRoad (getMarkerPos _x))};
		{
		if (getMarkerPos _x distance _posicionTel < distanciaSPWN) then
			{
			lados setVariable [_x,buenos,true];
			};
		} forEach _controles;
		_viejo = petros;
		grupoPetros = createGroup buenos;
		publicVariable "grupoPetros";
        petros = grupoPetros createUnit [tipoPetros, _posicionTel, [], 0, "NONE"];
        grupoPetros setGroupId ["Maru","GroupColor4"];
        petros setIdentity "amiguete";
        if (worldName == "Tanoa") then {petros setName "Maru"} else {petros setName "Petros"};
        petros disableAI "MOVE";
        petros disableAI "AUTOTARGET";
        if (group _viejo == grupoPetros) then {[Petros,"mission"] remoteExec ["flagaction",[buenos,civilian],petros]} else {[Petros,"buildHQ"] remoteExec ["flagaction",[buenos,civilian],petros]};
        _nul= [] execVM "initPetros.sqf";
        deleteVehicle _viejo;
        publicVariable "petros";
		};
	"respawn_guerrila" setMarkerPos _posicionTel;
	["respawn_guerrila",1] remoteExec ["setMarkerAlphaLocal",[buenos,civilian]];
	["respawn_guerrila",0] remoteExec ["setMarkerAlphaLocal",[malos,muyMalos]];
	if (isMultiplayer) then {hint "Please wait while HQ Assets are moved to the selected position";sleep 5};
	_pos = [_posicionTel, 3, getDir petros] call BIS_Fnc_relPos;
	fuego setPos _pos;
	_rnd = getdir Petros;
	if (isMultiplayer) then {sleep 5};
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	caja setPos _pos;
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	mapa setPos _pos;
	mapa setDir ([fuego, mapa] call BIS_fnc_dirTo);
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	bandera setPos _pos;
	_rnd = _rnd + 45;
	_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
	cajaVeh setPos _pos;
	if (isNil "placementDone") then {if (isMultiplayer) then {{if ((side _x == buenos) or (side _x == civilian)) then {_x setPos getPos petros}} forEach playableUnits} else {stavros setPos (getMarkerPos "respawn_guerrila")}};
	stavros allowDamage true;
	if (isMultiplayer) then
		{
		caja hideObjectGlobal false;
		cajaVeh hideObjectGlobal false;
		mapa hideObjectGlobal false;
		fuego hideObjectGlobal false;
		bandera hideObjectGlobal false;
		}
	else
		{
		caja hideObject false;
		cajaVeh hideObject false;
		mapa hideObject false;
		fuego hideObject false;
		bandera hideObject false;
		};
	openmap [false,false];
	};
{deleteMarkerLocal _x} forEach _mrkDum;
"Synd_HQ" setMarkerPos (getMarkerPos "respawn_guerrila");
posHQ = getMarkerPos "respawn_guerrila"; publicVariable "posHQ";
if (isNil "placementDone") then {placementDone = true; publicVariable "placementDone"};
chopForest = false; publicVariable "chopForest";
