//GOM_fnc_installFromLB.sqf
//by Grumpy Old Man
//V0.9
_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
(findDisplay 66) displayCtrl 1604 ctrlSetTextColor [0,1,0,1];
if (_Cars isEqualTo []) exitwith {true};
	_car = _cars select (lbCurSel 1500);

	if (_car getVariable ["GOM_fnc_NitroVolume",-1] <= 0) then {

	{

		ctrlShow [_x,false];

	} foreach [1900,1901,1902,1003,1004,1005,1006,1007,1008,1009];

};

if (_car getVariable ["GOM_fnc_NitroVolume",-1] > 0) then {

	{

		ctrlShow [_x,true];

	} foreach [1900,1901,1902,1003,1004,1005,1006,1007,1008,1009];

};

_carName = getText (configfile >> "CfgVehicles" >> typeOf _car >> "displayName");
_confirmed = false;


if (lbCurSel 1501 isEqualTo 0 AND lbCurSel 1502 > -1) then {
	_confirmed = true;
	_engineMultis = GOM_fnc_engineBoostParams apply {_x#1};
		_engineKitName = GOM_fnc_engineBoostParams apply {_x#0};

	_car setvariable ['GOM_fnc_boostMulti',_engineMultis # (lbCurSel 1502),true];
	_car setVariable ['GOM_fnc_boostStage',lbCursel 1502];
	_car setvariable ['GOM_fnc_nitroSize',(lbCurSel 1502),true];
	_car setvariable ['GOM_fnc_NitroVolume',1,true];
	systemchat format ['%2: Engine Upgrade %1 installed.',_engineKitName # (lbCurSel 1502),_carName];
	lbSetCurSel [1502, -1];
	lbClear 1502;

};

if (lbCurSel 1501 isEqualTo 1 AND lbCurSel 1502 > -1) then {
	_confirmed = true;
	_multi = GOM_fnc_transmissionParams apply {_x#1};
	_car setVariable ['GOM_fnc_MaxSpeed',(_multi select (lbCurSel 1502)),true];
	_car setvariable ['GOM_fnc_MaxSpeedType',lbCurSel 1502,true];
	systemchat format ['%2: Transmission Upgrade %1 installed.',lbCurSel 1502,_carName];
	lbSetCurSel [1502, -1];

	_getmaxspeed = getnumber (configfile >> "CfgVehicles" >> typeOf _car >> "maxSpeed");
		_maxspeedMulti = _car getvariable ["GOM_fnc_MaxSpeed",1];
		_maxspeed = _getmaxspeed * _maxspeedMulti;

		{
		sliderSetRange [_x, 0, _maxspeed];
	} foreach [1900,1901,1902];
	lbClear 1502;

};

if (lbCurSel 1501 isEqualTo 2 AND lbCurSel 1502 > -1) then {

	_confirmed = true;
	_car setvariable ['GOM_fnc_brakeType',lbCurSel 1502,true];
	systemchat format ['%2: Brake Upgrade %1 installed.',lbCurSel 1502,_carName];
	lbSetCurSel [1502, -1];
	lbClear 1502;

};

if (lbCurSel 1501 isEqualTo 3 AND lbCurSel 1502 > -1) then {

	_confirmed = true;
	_massMulti = GOM_fnc_chassisParams apply {_x#1};
	_reduction = _massMulti select (lbCurSel 1502);
	if (lbCurSel 1502 isEqualTo 0) then {_reduction = 1};
		_car setmass ((_car getvariable ['GOM_fnc_initMass',1000]) * _reduction);
		_car setvariable ['GOM_fnc_ChassisKit',1,true];
		systemchat format ['%2: Chassis Upgrade %1 installed.',lbCurSel 1502,_carName];
		lbSetCurSel [1502, -1];
	lbClear 1502;

	};

	if (lbCurSel 1501 isEqualTo 4 AND lbCurSel 1502 > -1) then {

		_confirmed = true;

		if (lbCurSel 1502 isEqualto 0) then {

			_car setVariable ['GOM_fnc_CruiseControlInstalled',true,true];
			systemchat format ['%2: Cruise Control installed.',lbCurSel 1502,_carName];

		};

		if (lbCurSel 1502 isEqualto 1) then {

			_car setVariable ['GOM_fnc_FogMachineInstalled',true,true];
			_car setVariable ['GOM_fnc_FogMachineRounds',3,true];
			systemchat format ['%2: F.O.G. Machine (3 Charges) installed.',lbCurSel 1502,_carName];

		};

		if (lbCurSel 1502 isEqualto 2) then {

			_car setVariable ['GOM_fnc_EjectionSeatsInstalled',true,true];
			systemchat format ['%2: Ejection Seats installed.',lbCurSel 1502,_carName];

		};

		if (lbCurSel 1502 isEqualto 3) then {

		_check = _car getvariable ["GOM_fnc_bulletProofTyres",false];
		if !(_check) then {
		_car call GOM_fnc_bulletProofTyres;
			systemchat format ['%2: Bulletproof Tyres installed.',lbCurSel 1502,_carName];
		};

		};

		if (lbCurSel 1502 isEqualto 4) then {

		_check = _car getvariable ["GOM_fnc_GPSTracker",false];
		if !(_check) then {
		_car spawn GOM_fnc_GPSTracker;
			systemchat format ['%2: GPS Tracker installed.',lbCurSel 1502,_carName];
		};

		};
		lbSetCurSel [1502, -1];
	};

	if (lbCurSel 1501 isEqualTo 5 AND lbCurSel 1502 > -1) then {

		_colorConfigs = "true" configClasses (configfile >> "CfgVehicles" >> typeof _car >> "textureSources");
		_colorTextures = [];
		if (count _colorConfigs > 0) then {

			_colorNames = [];
			{
			_colorNames pushback (getText (configfile >> "CfgVehicles" >> typeof _car >> "textureSources" >> configName _x >> "displayName"));
			_colorTextures pushback (getArray (configfile >> "CfgVehicles" >> typeof _car >> "textureSources" >> configName _x >> "textures"));
		} foreach _colorConfigs;

		{
		_index = (_colorTextures select (lbCurSel 1502)) find _x;
		_car setObjectTextureGlobal [_index, (_colorTextures select (lbCurSel 1502)) select _index];
	} foreach (_colorTextures select (lbCurSel 1502));

	systemchat format ['%2: Changed color to %1.',(_colorNames select (lbCurSel 1502)),_carName];

};

};

	if (lbCurSel 1501 isEqualTo 6 AND lbCurSel 1502 > -1) then {
	_confirmed = true;
	_animConfigs = "(getText (configfile >> 'CfgVehicles' >> typeof _car >> 'AnimationSources' >> configName _x >> 'displayName')) != ''" configClasses (configfile >> "CfgVehicles" >> typeof _car >> "AnimationSources");
	if (count _animConfigs > 0) then {

	_anim = configname (_animconfigs select (lbcursel 1502));
	_forceAnim = getArray (configfile >> "CfgVehicles" >> typeof _car >> "AnimationSources" >> _anim >> "forceAnimate");
	_state = _car animationPhase _anim;

	if (_state isEqualTo 0) then {_state = 1} else {_state = 0};

	_car animate [_anim,_state];

		{

			if (typename _x isEqualTo "STRING") then {

				_index = _forceAnim find _x;
				_car animate [_x,_forceanim select (_index + 1)];

			};

		} foreach _forceAnim;

	};

};
if (_confirmed) then {
	playsound selectRandom ['FD_Target_PopDown_Large_F','FD_Target_PopDown_Small_F','FD_Target_PopUp_Small_F'];
	(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />Modification Installed.<br />Select another one or confirm.</t>",""];

	(findDisplay 66) displayCtrl 1604 ctrlSetTextColor [1,1,1,1];

};
true