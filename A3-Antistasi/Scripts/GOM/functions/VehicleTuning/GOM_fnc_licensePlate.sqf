_world = worldName;
_plateFormat = getText (configfile >> "CfgWorlds" >> _world >> "plateFormat");
_plateLetters = (getText (configfile >> "CfgWorlds" >> _world >> "plateLetters") splitString "");
_plateArray = _plateFormat splitString "";

_result = _plateArray apply {

_return = _x;
if (_x isEqualTo "$") then {_return = selectRandom _plateLetters};
if (_x isEqualTo "#") then {_return = round random 9};
_return

};

_licensePlate = _result joinString "";

_licensePlate