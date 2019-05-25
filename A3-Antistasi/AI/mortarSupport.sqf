private _morty = _this select 0;
private _mortero = vehicle _morty;
if (_mortero == _morty) exitWith {};
if (!alive _mortero) exitWith
	{
	(group _morty) setVariable ["mortarsX",objNull];
	};
if !(unitReady _morty) exitWith {};
private _positionX = _this select 1;
private _rounds = _this select 2;
private _typeAmmunition = (getArray (configfile >> "CfgVehicles" >> (typeOf _mortero) >> "Turrets" >> "MainTurret" >> "magazines")) select 0;
if ({(_x select 0) == _typeAmmunition} count (magazinesAmmo _mortero) == 0) exitWith
	{
	moveOut _morty;
	(group _morty) setVariable ["mortarsX",objNull];
	};
if !(_positionX inRangeOfArtillery [[_mortero], ((getArtilleryAmmo [_mortero]) select 0)]) exitWith {};

_mortero commandArtilleryFire [_positionX,_typeAmmunition,_rounds];
