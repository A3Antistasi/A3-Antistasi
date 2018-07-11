_posHQ = getMarkerPos respawnBuenos;
_ciudades = ciudades select {getMarkerPos _x distance _posHQ < distanciaMiss};
if (count _ciudades == 0) exitWith {["",objNull]};
_ciudad = selectRandom _ciudades;

_tam = [_ciudad] call sizeMarker;
_posicion = getMarkerPos _ciudad;
_casas = nearestObjects [_posicion, ["house"], _tam] select {!((typeOf _x) in UPSMON_Bld_remove)};
_posCasa = [];
_casa = objNull;
while {count _posCasa == 0} do
	{
	_casa = selectRandom _casas;
	_posCasa = _casa buildingPos -1;
	_casas = _casas - [_casa];
	};
_grpContacto = createGroup civilian;
_pos = selectRandom _posCasa;
_contacto = _grpContacto createUnit [selectRandom arrayCivs, _pos, [], 0, "NONE"];
_contacto allowDamage false;
_contacto setPos _pos;
_contacto setVariable ["statusAct",false,true];
_contacto forceSpeed 0;
_contacto setUnitPos "UP";
[_contacto,"missionGiver"] remoteExec ["flagaction",[buenos,civilian],_contacto];
[_ciudad,_contacto]
