if (player != theBoss) exitWith {hint "Only Player Commander is allowed to move HQ assets"};
private ["_object","_player","_id","_sitios","_marcador","_size","_posicion"];

_object = _this select 0;
_player = _this select 1;
_id = _this select 2;

if (!(isNull attachedTo _object)) exitWith {hint "The asset you want to move is being moved by another player"};
if (vehicle _player != _player) exitWith {hint "You cannot move HQ assets while in a vehicle"};

if ({!(isNull _x)} count (attachedObjects _player) != 0) exitWith {hint "You have other things attached, you cannot move this"};
_sitios = marcadores select {lados getVariable [_x,sideUnknown] == buenos};
_marcador = [_sitios,_player] call BIS_fnc_nearestPosition;
_size = [_marcador] call A3A_fnc_sizeMarker;
_posicion = getMarkerPos _marcador;
if (_player distance2D _posicion > _size) exitWith {hint "This asset needs to be closer to it relative zone center to be able to be moved"};

private _world_pos = _object modelToWorld [0,0,0.1];
_object removeAction _id;
private _relative_pos = _player worldToModel _world_pos;
private _starting_h = getCameraViewDirection _player select 2;
_object enableSimulationGlobal false;
_object attachTo [_player, _player worldToModel _world_pos];//[0,2,1]];

["SetHQObjectHeight", "onEachFrame", {
	params ["_obj", "_mover", "_relative_pos", "_starting_h"];
	private _relative_h = (getCameraViewDirection _mover select 2) - _starting_h;
	detach _obj;
	_obj attachTo [_mover, _relative_pos vectorAdd [0, 0, _relative_h * vectorMagnitude _relative_pos]];
}, [_object, _player, _relative_pos, _starting_h]] call BIS_fnc_addStackedEventHandler;

accion = _player addAction ["Drop Here", {
	["SetHQObjectHeight", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	{
		detach _x;
		_x enableSimulationGlobal true;
	} forEach attachedObjects player;
	player removeAction (_this select 2);
},nil,0,false,true,"",""];

waitUntil {sleep 1; 
	(count attachedObjects _player == 0) or 
	(vehicle _player != _player) or 
	(_player distance2D _posicion > (_size-3)) or 
	!([_player] call A3A_fnc_canFight) or 
	(!isPlayer _player)};

{
	detach _x;
	_x enableSimulationGlobal true;
} forEach attachedObjects _player;
{detach _x} forEach attachedObjects _player;
player removeAction accion;
["SetHQObjectHeight", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

_object addAction ["Move this asset", "moveHQObject.sqf",nil,0,false,true,"","(_this == theBoss)"];

if (vehicle _player != _player) exitWith {hint "You cannot move HQ assets while in a vehicle"};

if  (_player distance2D _posicion > _size) exitWith {hint "This asset cannot be moved more far away for its zone center"};