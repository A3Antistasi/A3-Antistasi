//GOM_fnc_getKartNumber
//0.0112ms, may be possible to increase this if needed
params ["_veh"];
_textures = (getObjectTextures _veh);
_textures params ["","","_tens","_single"];
_first = _tens splitString "";
_second = _single splitString "";

_firstNum = _first#(count _first - 8);
_secondNum = _second#(count _second - 8);
_result = _firstNum + _secondNum;
_result