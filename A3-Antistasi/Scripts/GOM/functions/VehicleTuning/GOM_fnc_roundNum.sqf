//GOM_fnc_roundNum.sqf
//by Grumpy Old Man
//V0.9
params ["_input","_decimals"];
_whoopdeedoo = (10 ^ _decimals);
round (_input * _whoopdeedoo) / _whoopdeedoo