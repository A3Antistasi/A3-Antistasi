private ["_staticX","_nearX","_playerX"];

_staticX = _this select 0;
_playerX = _this select 1;

if (!alive _staticX) exitWith {hint "You cannot steal a destroyed static weapon"};

if (alive gunner _staticX) exitWith {hint "You cannot steal a static weapon when someone is using it"};

if ((alive assignedGunner _staticX) and (!isPlayer (assignedGunner _staticX))) exitWith {hint "The gunner of this static weapon is still alive"};

if (activeGREF and ((typeOf _staticX == staticATteamPlayer) or (typeOf _staticX == staticAAteamPlayer))) exitWith {hint "This weapon cannot be dissassembled"};

_nearX = [markersX,_staticX] call BIS_fnc_nearestPosition;

if (not(lados getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {hint "You have to conquer this zone in order to be able to steal this Static Weapon"};

_staticX setOwner (owner _playerX);

_typeStaticX = typeOf _staticX;

_typeB1 = ATStaticSDKB;
_typeB2 = supportStaticSDKB;

switch _typeStaticX do
	{
	case staticATOccupants: {_typeB1 = ATStaticNATOB; _typeB2 = supportStaticNATOB};
	case staticATInvaders: {_typeB1 = ATStaticCSATB; _typeB2 = supportStaticCSATB};
	case NATOMortar: {_typeB1 = MortStaticNATOB; _typeB2 = supportStaticNATOB3};
	case NATOMG: {_typeB1 = MGStaticNATOB; _typeB2 = supportStaticNATOB2};
	case CSATMG: {_typeB1 = MGStaticCSATB; _typeB2 = supportStaticCSATB2};
	case SDKMGStatic: {_typeB1 = MGStaticSDKB; _typeB2 = supportStaticsSDKB2;};
	case staticAAteamPlayer: {_typeB1 = AAStaticSDKB};
	case SDKMortar: {_typeB1 = MortStaticSDKB; _typeB2 = supportStaticsSDKB3};
	};

_positionX1 = [_playerX, 1, (getDir _playerX) - 90] call BIS_fnc_relPos;
_positionX2 = [_playerX, 1, (getDir _playerX) + 90] call BIS_fnc_relPos;

deleteVehicle _staticX;

_bag1 = _typeB1 createVehicle _positionX1;
_bag2 = _typeB2 createVehicle _positionX2;

[_bag1] call A3A_fnc_AIVEHinit;
[_bag2] call A3A_fnc_AIVEHinit;

hint "Weapon Stolen. It won't despawn when you assemble it again";