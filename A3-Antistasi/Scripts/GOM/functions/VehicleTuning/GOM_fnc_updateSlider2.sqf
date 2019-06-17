//GOM_fnc_updateSlider2.sqf
//by Grumpy Old Man
//V0.9
params ["_ctrl","_speed"];
if (lbCurSel 1500 < 0) exitwith {true};
_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
_car = _cars select (lbCurSel 1500);

_getmaxspeed = getnumber (configfile >> "CfgVehicles" >> typeOf _car >> "maxSpeed");
if (_getmaxspeed <= 300) then {_getmaxspeed = 300};
_maxspeedMulti = _car getvariable ["GOM_fnc_MaxSpeed",1];
_maxspeed = _getmaxspeed * _maxspeedMulti;
_maxspeed = [_maxspeed,2] call GOM_fnc_roundNum;
_speed = [_speed,2] call GOM_fnc_roundNum;
sliderSetRange [1900, 0, _maxspeed];
ctrlSetText [1005,format ["%1 km/h",_speed]];
_car setvariable ["GOM_fnc_nitroLowThreshold",str _speed,true];
(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />Until the vehicle reaches this speed, the nitro boost will slowly increase up to 100%1.</t>","%"];

if (sliderPosition 1901 > 0 AND sliderPosition 1901 <= _speed) then {sliderSetPosition [1901,_speed]};
true