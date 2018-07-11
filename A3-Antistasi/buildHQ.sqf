private ["_pos","_rnd"];
_movido = false;
if (petros != (leader group petros)) then
	{
	_movido = true;
	grupoPetros = createGroup buenos;
	publicVariable "grupoPetros";
	[petros] join grupoPetros;
	};
[petros,"remove"] remoteExec ["flagaction",0,petros];
petros disableAI "MOVE";
petros disableAI "AUTOTARGET";
respawnBuenos setMarkerPos getPos petros;
"Synd_HQ" setMarkerPos getPos petros;
posHQ = getMarkerPos respawnBuenos; publicVariable "posHQ";
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
	if (_movido) then {hint "Please wait while HQ assets are moved to selected postion"};
	//sleep 5
	caja hideObject false;
	cajaVeh hideObject false;
	mapa hideObject false;
	fuego hideObject false;
	bandera hideObject false;
	};
//fuego inflame true;
[respawnBuenos,1] remoteExec ["setMarkerAlphaLocal",buenos,true];
[respawnBuenos,1] remoteExec ["setMarkerAlphaLocal",civilian,true];
_pos = [getPos petros, 3, getDir petros] call BIS_Fnc_relPos;
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
if (_movido) then {_nul = [] call vaciar};
petros setBehaviour "SAFE";
placementDone = true; publicVariable "placementDone";
sleep 5;
[Petros,"mission"] remoteExec ["flagaction",[buenos,civilian],petros];

