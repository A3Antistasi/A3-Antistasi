private ["_pos","_rnd","_posFire"];
_movido = false;
if (petros != (leader group petros)) then
	{
	_movido = true;
	groupPetros = createGroup teamPlayer;
	publicVariable "groupPetros";
	[petros] join groupPetros;
	};
[petros,"remove"] remoteExec ["A3A_fnc_flagaction",0,petros];
petros disableAI "MOVE";
petros disableAI "AUTOTARGET";
respawnTeamPlayer setMarkerPos getPos petros;
posHQ = getMarkerPos respawnTeamPlayer; publicVariable "posHQ";
if (isMultiplayer) then
	{
	caja hideObjectGlobal false;
	vehicleBox hideObjectGlobal false;
	mapa hideObjectGlobal false;
	fireX hideObjectGlobal false;
	flagX hideObjectGlobal false;
	}
else
	{
	if (_movido) then {hint "Please wait while HQ assets are moved to selected position"};
	//sleep 5
	caja hideObject false;
	vehicleBox hideObject false;
	mapa hideObject false;
	fireX hideObject false;
	flagX hideObject false;
	};
//fireX inflame true;
[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",teamPlayer,true];
[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",civilian,true];
_posFire = [getPos petros, 3, getDir petros] call BIS_Fnc_relPos;
fireX setPos _posFire;
_rnd = getdir Petros;
if (isMultiplayer) then {sleep 5};
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
caja setPos _pos;
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
mapa setPos _pos;
mapa setDir ([fireX, mapa] call BIS_fnc_dirTo);
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
_pos = _pos findEmptyPosition [0,50,(typeOf flagX)];
if (_pos isEqualTo []) then {_pos = getPos petros};
flagX setPos _pos;
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
vehicleBox setPos _pos;
//if (_movido) then {_nul = [] call A3A_fnc_empty};
petros setBehaviour "SAFE";
"Synd_HQ" setMarkerPos getPos petros;
if (isNil "placementDone") then {placementDone = true; publicVariable "placementDone"};
chopForest = false; publicVariable "chopForest";
sleep 5;
[Petros,"mission"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],petros];

