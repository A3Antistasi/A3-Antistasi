private ["_pos","_rnd","_posFire"];
_movido = false;
if (petros != (leader group petros)) then
	{
	_movido = true;
	groupPetros = createGroup buenos;
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
	cajaVeh hideObjectGlobal false;
	mapa hideObjectGlobal false;
	fuego hideObjectGlobal false;
	bandera hideObjectGlobal false;
	}
else
	{
	if (_movido) then {hint "Please wait while HQ assets are moved to selected position"};
	//sleep 5
	caja hideObject false;
	cajaVeh hideObject false;
	mapa hideObject false;
	fuego hideObject false;
	bandera hideObject false;
	};
//fuego inflame true;
[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",buenos,true];
[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",civilian,true];
_posFire = [getPos petros, 3, getDir petros] call BIS_Fnc_relPos;
fuego setPos _posFire;
_rnd = getdir Petros;
if (isMultiplayer) then {sleep 5};
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
caja setPos _pos;
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
mapa setPos _pos;
mapa setDir ([fuego, mapa] call BIS_fnc_dirTo);
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
_pos = _pos findEmptyPosition [0,50,(typeOf bandera)];
if (_pos isEqualTo []) then {_pos = getPos petros};
bandera setPos _pos;
_rnd = _rnd + 45;
_pos = [_posFire, 3, _rnd] call BIS_Fnc_relPos;
cajaVeh setPos _pos;
//if (_movido) then {_nul = [] call A3A_fnc_empty};
petros setBehaviour "SAFE";
"Synd_HQ" setMarkerPos getPos petros;
if (isNil "placementDone") then {placementDone = true; publicVariable "placementDone"};
chopForest = false; publicVariable "chopForest";
sleep 5;
[Petros,"mission"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],petros];

