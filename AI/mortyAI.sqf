private ["_morty","_camion","_mortero","_pos"];

_morty = _this select 0;
_camion = _this select 1;
_mortero = _this select 2;

_camionero = driver _camion;
_grupo = group _morty;
_grupo addVehicle _camion;

while {(alive _morty) and (alive _mortero) and (canMove _camion)} do
	{
	waitUntil {sleep 1; (!unitReady _camionero) or (not((alive _morty) and (alive _mortero)))};

	moveOut _morty;
	_morty assignAsCargo _camion;
	_morty addBackpackGlobal MortStaticSDKB;
	_camionero addBackpackGlobal soporteStaticSDKB3;
	deleteVehicle _mortero;
	//_mortero attachTo [_camion,[0,-1.5,0.2]];
	//_mortero setDir (getDir _camion + 180);

	waitUntil {sleep 10; ((unitReady _camionero) or (!canMove _camion) or (!alive _camionero) and (speed _camion == 0)) or (not((alive _morty) and (alive _mortero)))};

	moveOut _morty;
	//_mortero allowDamage false;
	//detach _mortero;
	_pos = position _camion findEmptyPosition [1,30,SDKMortar];
	_mortero = SDKMortar createVehicle _pos;
	removeBackpackGlobal _morty;
	removeBackpackGlobal _camionero;
	_grupo addVehicle _mortero;
	_morty assignAsGunner _mortero;
	_nul = [_mortero] call AIVEHinit;
	//_morty moveInGunner _mortero;
	//_mortero setPos _pos;

	//_mortero allowDamage true;
	};