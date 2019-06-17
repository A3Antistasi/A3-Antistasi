//GOM_fnc_updateBoostDisplay.sqf
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

_speedMulti = _car getvariable ["GOM_fnc_speedMulti",1];
_finalMulti = _speedMulti;
_lowThreshold = call compile (_car getvariable ["GOM_fnc_nitroLowThreshold","100"]);
_highThreshold = call compile  (_car getvariable ["GOM_fnc_nitroHighThreshold","300"]);

if (_speed > 0) then {

	if (_speed <= _lowThreshold) then {

		_finalMulti = _speedMulti / (_lowThreshold / _speed);

	};

	if (_speed >= _highThreshold) then {

		_finalMulti = _speedMulti / (_speed / _highThreshold);

	};

	_boostpercent = [((_finalmulti / _speedmulti) * 100),2] call GOM_fnc_roundNum;

	sliderSetRange [1902, 0, _maxspeed];
	ctrlSetText [1007,format ["%1km/h",_speed]];
	ctrlSetText [1009,format ["%1%2",_boostpercent,"%"]];
};
(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />This slider displays the boost provided by the nitro injection at the specified speed.</t>",""];
true