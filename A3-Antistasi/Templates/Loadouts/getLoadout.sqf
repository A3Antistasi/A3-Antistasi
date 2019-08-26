params ["_loadoutName"];

private _loadoutArray = missionNamespace getVariable [_loadoutName, []];

if (_loadoutArray isEqualTo []) then {
	_loadoutArray = call compile preprocessFileLineNumbers format ["Templates\Loadouts\%1.sqf", _loadoutName];
	missionNamespace setVariable [_loadoutName, _loadoutArray];
};

_loadoutArray;