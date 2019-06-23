params ["_veh",["_num","",[""]]];

if !(_num select [0,1] in ["0","1","2","3","4","5","6","7","8","9"]) exitWith {false};
if (_num isEqualTo "" OR call compile _num > 99 OR {call compile _num < 0}) exitWith {false};

_numArray = _num splitString "";
_texture2 = format ["\A3\Soft_F_Kart\Kart_01\Data\Kart_num_%1_CA.paa",_numArray#0];
_texture3 = format ["\A3\Soft_F_Kart\Kart_01\Data\Kart_num_%1_CA.paa",_numArray#1];
_veh setObjectTextureGlobal [2,_texture2];
_veh setObjectTextureGlobal [3,_texture3];
true