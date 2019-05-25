private ["_estatica","_nearX","_playerX"];

_estatica = _this select 0;
_playerX = _this select 1;

if (!alive _estatica) exitWith {hint "You cannot steal a destroyed static weapon"};

if (alive gunner _estatica) exitWith {hint "You cannot steal a static weapon when someone is using it"};

if ((alive assignedGunner _estatica) and (!isPlayer (assignedGunner _estatica))) exitWith {hint "The gunner of this static weapon is still alive"};

if (activeGREF and ((typeOf _estatica == staticATteamPlayer) or (typeOf _estatica == staticAAteamPlayer))) exitWith {hint "This weapon cannot be dissassembled"};

_nearX = [markersX,_estatica] call BIS_fnc_nearestPosition;

if (not(lados getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {hint "You have to conquer this zone in order to be able to steal this Static Weapon"};

_estatica setOwner (owner _playerX);

_tipoEst = typeOf _estatica;

_typeB1 = ATStaticSDKB;
_typeB2 = supportStaticSDKB;

switch _tipoEst do
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

deleteVehicle _estatica;

_bag1 = _typeB1 createVehicle _positionX1;
_bag2 = _typeB2 createVehicle _positionX2;

[_bag1] call A3A_fnc_AIVEHinit;
[_bag2] call A3A_fnc_AIVEHinit;

hint "Weapon Stolen. It won't despawn when you assemble it again";