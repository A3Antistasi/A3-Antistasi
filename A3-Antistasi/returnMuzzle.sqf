private ["_unit","_muzzles","_muzzle","_magazines"];

_unit = _this select 0;

_muzzles = [];
_magazines = magazines _unit;

if ("SmokeShell" in _magazines) then {_muzzles pushBack "SmokeShellMuzzle"};
if ("SmokeShellRed" in _magazines) then {_muzzles pushBack "SmokeShellRedMuzzle"};
if ("SmokeShellGreen" in _magazines) then {_muzzles pushBack "SmokeShellGreenMuzzle"};
if ("SmokeShellBlue" in _magazines) then {_muzzles pushBack "SmokeShellBlueMuzzle"};
if ("SmokeShellYellow" in _magazines) then {_muzzles pushBack "SmokeShellYellowMuzzle"};
if ("SmokeShellPurple" in _magazines) then {_muzzles pushBack "SmokeShellPurpleMuzzle"};
if ("SmokeShellOrange" in _magazines) then {_muzzles pushBack "SmokeShellOrangeMuzzle"};

if (count _muzzles > 0) then {_muzzle = _muzzles call BIS_fnc_selectRandom} else {_muzzle = ""};

_muzzle
