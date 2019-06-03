if (player != theBoss) exitWith {hint "Only Player Commander is allowed to move HQ assets"};
private ["_cosa","_playerX","_id","_sitios","_markerX","_size","_positionX"];

_cosa = _this select 0;
_playerX = _this select 1;
_id = _this select 2;

if (!(isNull attachedTo _cosa)) exitWith {hint "The asset you want to move is being moved by another player"};
if (vehicle _playerX != _playerX) exitWith {hint "You cannot move HQ assets while in a vehicle"};

if ({!(isNull _x)} count (attachedObjects _playerX) != 0) exitWith {hint "You have other things attached, you cannot move this"};
_sitios = markersX select {lados getVariable [_x,sideUnknown] == buenos};
_markerX = [_sitios,_playerX] call BIS_fnc_nearestPosition;
_size = [_markerX] call A3A_fnc_sizeMarker;
_positionX = getMarkerPos _markerX;
if (_playerX distance2D _positionX > _size) exitWith {hint "This asset needs to be closer to it relative zone center to be able to be moved"};

_cosa removeAction _id;
_cosa attachTo [_playerX,[0,2,1]];
actionX = _playerX addAction ["Drop Here", {{detach _x} forEach attachedObjects player; player removeAction actionX},nil,0,false,true,"",""];

waitUntil {sleep 1; (count attachedObjects _playerX == 0) or (vehicle _playerX != _playerX) or (_playerX distance2D _positionX > (_size-3)) or !([_playerX] call A3A_fnc_canFight) or (!isPlayer _playerX)};

{detach _x} forEach attachedObjects _playerX;
player removeAction actionX;
/*
for "_i" from 0 to (_playerX addAction ["",""]) do
	{
	_playerX removeAction _i;
	};
*/
_cosa addAction ["Move this asset", "moveHQObject.sqf",nil,0,false,true,"","(_this == theBoss)"];

_cosa setPosATL [getPosATL _cosa select 0,getPosATL _cosa select 1,0];

if (vehicle _playerX != _playerX) exitWith {hint "You cannot move HQ assets while in a vehicle"};

if  (_playerX distance2D _positionX > _size) exitWith {hint "This asset cannot be moved more far away for its zone center"};
