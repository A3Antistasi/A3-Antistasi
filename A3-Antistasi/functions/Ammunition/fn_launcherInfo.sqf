/**
	Gets the targets (ground/air) a launcher can lock on to, as well as which magazines can lock which targets.
	
	Params:
		launcherClassName: Class name of the launcher to test. DO NOT USE ON NON-LAUNCHERS.
		
	Returns:
		[canLockGroundTargets, canLockAirTargets, unguidedMagazines, groundLockMagazines, airLockMagazines] - magazine arrays may overlap.

**/

params ["_launcherClassName"];

private _rawMagazines = getArray (configFile >> "CfgWeapons" >> _launcherClassName >> "magazines");
private _magazineWells = getArray (configFile >> "CfgWeapons" >> _launcherClassName >> "magazineWell");
{
	{
		_rawMagazines pushBackUnique _x;
	} forEach getArray (configFile >> "CfgMagazineWells" >> _x >> "BI_Magazines");
} forEach _magazineWells;

private _isACEDisposable = getText (configFile >> "CfgWeapons" >> _launcherClassName >> "ACE_UsedTube") !=	"";
private _fakeLauncher =	false;

private _magazineAmmo = [];
{
	//Ignore fake magazines - unless we're an ACE disposable launcher, then only count
	if (getNumber (configFile >> "CfgMagazines" >> _x >> "count") > 0 && (!_isACEDisposable || _x == "ACE_PreloadedMissileDummy")) then {
		_magazineAmmo pushBack [_x, getText (configFile >> "CfgMagazines" >> _x >> "ammo")];
	} else {
		if (_x == "CBA_FakeLauncherMagazine") exitWith {
			_fakeLauncher = true;
		};
	};
} forEach _rawMagazines;

//Exit if it's a CBA fake launcher.
if (_fakeLauncher) exitWith {
	//If disposable launchers is loaded, check if we're holding a disposable launcher, and find the actual class if so.
	if (!isNil "cba_disposable_LoadedLaunchers") exitWith {
		private _fireableLauncherName = cba_disposable_LoadedLaunchers getVariable [_launcherClassName, ""];
		if (_fireableLauncherName != "") exitWith {
			[_fireableLauncherName] call A3A_fnc_launcherInfo;
		};
	};
	[false, false, [], [], []];
};

private _targetAir = false;
private _targetGround = false;

private _unguidedMagazines = [];
private _groundMagazines = [];
private _airMagazines = [];

{
	_x params ["_mag", "_ammoType"];
	if (_ammoType isKindOf "MissileCore") then {
		private _ammoConfig = configFile >> "CfgAmmo" >> _ammoType;
		//If have ACE and ACE Guidance is enabled, then it can target whatever it damn well likes. ACE isn't picky.
		if(hasACE && {isClass (_ammoConfig >> "ace_missileguidance") && {getNumber (_ammoConfig >> "ace_missileguidance" >> "enabled") == 1}}) exitWith {
			_targetGround = true;
			_targetAir = true;
			_groundMagazines pushBackUnique _mag;
			_airMagazines pushBackUnique _mag;
		};
	
		private _airLock = getNumber (_ammoConfig >> "airLock");
		switch (_airLock) do {
			case 0: {
				_targetGround = true;
				_groundMagazines pushBackUnique _mag;
			};
			case 1: {
				_targetGround = true;
				_targetAir = true;
				_groundMagazines pushBackUnique _mag;
				_airMagazines pushBackUnique _mag;
			};
			case 2: {
				_targetAir = true;
				_airMagazines pushBackUnique _mag;
			};
		};
	} else {
		_unguidedMagazines pushBackUnique _mag;
	};
} forEach _magazineAmmo;

if (_isACEDisposable) then {
	_unguidedMagazines = [];
	_groundMagazines = [];
	_airMagazines = [];
};

[_targetGround, _targetAir, _unguidedMagazines, _groundMagazines, _airMagazines];
