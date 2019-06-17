//GOM_fnc_vehTuning.sqf
//by Grumpy Old Man
//V0.9
params ["_vehicle"];
_IDs = _vehicle getvariable ["GOM_fnc_nitroActionIDs",[-1]];

if (_IDs select 0 > -1) exitWith {};

	{_vehicle removeAction _x} foreach _IDs;


	_displayEHs = player getvariable ["GOM_fnc_displayEHs",[]];
	if !(_displayEHs isEqualTo []) then {

		(findDisplay 46) displayRemoveEventHandler ["KeyDown",(_displayEHs select 0)];
		(findDisplay 46) displayRemoveEventHandler ["KeyUp",(_displayEHs select 1)];

	};
	_stackedID = _vehicle getVariable ["GOM_fnc_stackedEH",""];
	if !(_stackedID isEqualTo "") then {

		[_stackedID, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

	};

	_engineID = _vehicle getVariable ["GOM_fnc_nitroEngineEH",-1];
	_vehicle removeEventHandler ["Engine",_engineID];



	_nitroActionIDs = [];

	_ID =	_vehicle addAction ["Ejection Seat",{(_this select 1) call GOM_fnc_ejectionSeat;},nil,0,false,true,"","_this in crew _target AND _target getvariable [""GOM_fnc_EjectionSeatsInstalled"",false]"];
	_nitroActionIDs pushBack _ID;


	_ID =	_vehicle addAction ["'Fog' Machine (3 Charges)",{(_this select 0) spawn GOM_fnc_fogMachine;},nil,0,false,true,"","_this isequalto driver _target AND _target getvariable [""GOM_fnc_FogMachineInstalled"",false] AND _target getvariable [""GOM_fnc_FogMachineRounds"",0] > 0"];
	_nitroActionIDs pushBack _ID;
	_vehicle setvariable ["GOM_fnc_FOGactionID",_ID];
	_ID =	_vehicle addaction ["Cruise-Control On",{(_this select 0) setvariable ["GOM_fnc_CruiseControl",speed (_this select 0)]},nil,0,false,true,"","((vehicle _target getvariable [""GOM_fnc_CruiseControl"",-1])< 0) AND _this isEqualTo driver _target AND isEngineOn _target AND _target getvariable [""GOM_fnc_CruiseControlInstalled"",false]"];
	_nitroActionIDs pushBack _ID;

	_ID = _vehicle addaction ["Cruise-Control Off",{_this select 0 setvariable ["GOM_fnc_CruiseControl",-1]},nil,0,false,true,"","((vehicle _target getvariable [""GOM_fnc_CruiseControl"",-1])> 0) AND _this isEqualTo driver _target AND isEngineOn _target AND _target getvariable [""GOM_fnc_CruiseControlInstalled"",false]"];
	_nitroActionIDs pushBack _ID;



_ID = _vehicle addaction ["Measure Performance",{

params ["_veh"];
_veh setvariable ["GOM_fnc_nitroMeasuring",true];
playSound "Topic_Selection";
_acc = [_veh] spawn GOM_fnc_acceleration;
_qm = [_veh] spawn GOM_fnc_quartermile

},nil,0,false,true,"","(!(vehicle _target getvariable [""GOM_fnc_nitroMeasuring"",false])) AND _this isEqualTo driver _target"];
_nitroActionIDs pushBack _ID;


_vehicle setvariable ["GOM_fnc_nitroActionIDs",_nitroActionIDs];
disableSerialization;
_display = (findDisplay 46);
_displayEHs = [];
_ID = _display displayAddEventHandler ["KeyDown","_veh = vehicle player;if ((_this select 1) isEqualTo 31) then {_veh setvariable ['GOM_fnc_CruiseControl',-1];_veh setvariable ['GOM_fnc_braking',true]}"];

_displayEHs pushBack _ID;

_ID =_display displayAddEventHandler ["KeyUp","_veh = vehicle player;if ((_this select 1) isEqualTo 31) then {_veh setvariable ['GOM_fnc_braking',false]}"];
_displayEHs pushBack _ID;
player setvariable ["GOM_fnc_displayEHs",_displayEHs];
_stackedEHID = "GOM_fnc_nitroOnEachFrameID";
_vehicle setVariable ["GOM_fnc_stackedEH",_stackedEHID];


GOM_fnc_acceleration = {


params ["_veh"];
_texts = [];
_maxG = 0;//using gmeterz soundcontroller to grab g value
waituntil {_veh getvariable ["GOM_fnc_nitroMeasuring",false]};

_getmaxspeed = getnumber (configfile >> "CfgVehicles" >> typeOf _veh >> "maxSpeed");


	_maxspeedMulti = _veh getvariable ["GOM_fnc_MaxSpeed",1];
	_maxspeed = _getmaxspeed * _maxspeedMulti;
	_vehName = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "displayName");
	_vehDifferential = getText (configfile >> "CfgVehicles" >> typeOf _veh >> "differentialType");
	_diffTypes = ["","all_open", "all_limited", "front_open", "front_limited", "rear_open", "rear_limited"];
	_diffReferences = ["N/A","4WD","4WD, limited-slip differential","FWD","FWD, limited-slip differential","RWD","RWD, limited-slip differential"];

	_vehDiffText = if (_vehDifferential in _diffTypes) then {_diffReferences select (_diffTypes find _vehDifferential)} else {_diffReferences select 0};

	_mass = getMass _veh;

	_nitroIndex = _veh getVariable ["GOM_fnc_boostStage",0];
	_nitroTypes = GOM_fnc_engineBoostParams apply {_x#0};
	_nitroStageText = format ["%1",_nitroTypes # _nitroIndex];

	_transmissionIndex = _veh getVariable ["GOM_fnc_MaxSpeedType",0];
	_transmissionTypes = GOM_fnc_transmissionParams apply {_x#0};
	_transmissionText = format ["%1",_transmissionTypes # _transmissionIndex];

	_brakeIndex = _veh getVariable ["GOM_fnc_brakeType",0];
	_braketypes = GOM_fnc_brakeParams apply {_x#0};
	_braketext = format ["%1",_braketypes # _brakeIndex];

	_chassisIndex = _veh getVariable ["GOM_fnc_ChassisKit",0];
	_chassistypes = GOM_fnc_chassisParams apply {_x#0};
	_chassistext = format ["%1",_chassistypes # _chassisIndex];

	_text = format ["--- NEW RUN ---<br />Run start time: %1.<br />%2 in %3 - %4kg.<br />Max. Speed: %5km/h.<br />%6<br />%7<br />%8<br />%9",[daytime] call BIS_fnc_timeToString,name player,_vehName,[getmass _veh,2] call GOM_fnc_roundNum,[_maxspeed,2] call GOM_fnc_roundNum,_nitroStageText,_transmissionText,_braketext,_chassistext];
	_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
	_log set [0,_text];
	_veh setVariable ["GOM_fnc_performanceLog",_log];

	waituntil {player != _veh};

	hintsilent "Ready to measure, accelerate!";	_killHint = [] spawn GOM_fnc_killHint;

	playsound "FD_Start_F";

	waituntil {speed _veh > 0};

	_vInit = 0;
	_starttime = time;
	_kmhToMphMulti = 0.278;

	waituntil {
		_g = _veh getSoundController "gmeterz";
		if (_g > _maxG) then {_maxG = _g};

	speed _veh >= 96.5606};//0-60 mph


	_accel = (((speed _veh * _kmhToMphMulti) - _vInit) / (time - _starttime));
	_text = format ["0 - 60mph: %1s.<br />Avg. Accel.: %2m/s² - %3g.<br />Max. Accel. %4m/s² - %5g.",[(time - _starttime),2] call GOM_fnc_roundNum,[_accel,2] call GOM_fnc_roundNum,[(_accel / 9.807),2] call GOM_fnc_roundNum,[(_maxG * 9.807),2] call GOM_fnc_roundNum,[_maxG,2] call GOM_fnc_roundNum];
	_g = 0;
	_maxG = 0;
	_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
	_log set [1,_text];
	_veh setVariable ["GOM_fnc_performanceLog",_log];

	waituntil {
		_g = _veh getSoundController "gmeterz";
		if (_g > _maxG) then {_maxG = _g};
	speed _veh >= 100};//0-100 kmh

	_accel = (((speed _veh * _kmhToMphMulti) - _vInit) / (time - _starttime));
	_text = format ["0 - 100kmh: %1s.<br />Avg. Accel.: %2m/s² - %3g.<br />Max. Accel. %4m/s² - %5g.",[(time - _starttime),2] call GOM_fnc_roundNum,[_accel,2] call GOM_fnc_roundNum,[(_accel / 9.807),2] call GOM_fnc_roundNum,[(_maxG * 9.807),2] call GOM_fnc_roundNum,[_maxG,2] call GOM_fnc_roundNum];
	_g = 0;
	_maxG = 0;

	_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
	_log set [2,_text];
	_veh setVariable ["GOM_fnc_performanceLog",_log];

	waituntil {speed _veh isEqualto 0};

	sleep 3;

	waituntil {!(_veh getvariable ["GOM_fnc_nitroMeasuring",false])};



};

GOM_fnc_quartermile = {

params ["_veh"];
_maxG = 0;
_texts = [];
_kmhToMphMulti = 0.278;
waituntil {_veh getvariable ["GOM_fnc_nitroMeasuring",false]};

waituntil {speed _veh > 0};

_vInit = 0;
_startpos = getposATL _veh;
_starttime = time;

waituntil {
_g = _veh getSoundController "gmeterz";
		if (_g > _maxG) then {_maxG = _g};

getposatl _veh distance2d _startpos >= 201};//1/8 mile

_accel = (((speed _veh * _kmhToMphMulti) - _vInit) / (time - _starttime));
	_text = format ["Eigth mile: %1s - %2km/h.<br />Avg. Accel.: %3m/s² - %4g.<br />Max. Accel. %5m/s² - %6g.",[(time - _starttime),2] call GOM_fnc_roundNum,[speed _veh,2] call GOM_fnc_roundNum,[_accel,2] call GOM_fnc_roundNum,[(_accel / 9.807),2] call GOM_fnc_roundNum,[(_maxG * 9.807),2] call GOM_fnc_roundNum,[_maxG,2] call GOM_fnc_roundNum];
	_g = 0;
	_maxG = 0;
_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
_log set [3,_text];
_veh setVariable ["GOM_fnc_performanceLog",_log];

waituntil {
_g = _veh getSoundController "gmeterz";
		if (_g > _maxG) then {_maxG = _g};

getposatl _veh distance2d _startpos >= 402};//1/4 mile

_accel = (((speed _veh * _kmhToMphMulti) - _vInit) / (time - _starttime));
	_text = format ["Quarter mile: %1s - %2km/h.<br />Avg. Accel.: %3m/s² - %4g.<br />Max. Accel. %5m/s² - %6g.",[(time - _starttime),2] call GOM_fnc_roundNum,[speed _veh,2] call GOM_fnc_roundNum,[_accel,2] call GOM_fnc_roundNum,[(_accel / 9.807),2] call GOM_fnc_roundNum,[(_maxG * 9.807),2] call GOM_fnc_roundNum,[_maxG,2] call GOM_fnc_roundNum];
	_g = 0;
	_maxG = 0;
_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
_log set [4,_text];
_veh setVariable ["GOM_fnc_performanceLog",_log];
_horsepower = (getmass _veh * 2.20462)/(((time - _starttime)/5.825)^3);
_text = format ["Calculated power: %1hp - %2kW.",[_horsepower,2] call GOM_fnc_roundNum,[(_horsepower * 0.7457),2] call GOM_fnc_roundNum];
_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
_log set [0,format ["%1<br />%2",_log select 0,_text]];
_veh setVariable ["GOM_fnc_performanceLog",_log];
playsound "FD_Finish_F";
hintsilent "Measuring finished. Logging results to Diary.";
_killHint = [] spawn GOM_fnc_killHint;

waituntil {speed _veh isEqualto 0};

sleep 3;

_log = _veh getvariable ["GOM_fnc_performanceLog",[]];
reverse _log;

{

	player createDiaryRecord ["GOM_veh_records",["Records",_x]];

} foreach  _log;

_veh setvariable ["GOM_fnc_nitroMeasuring",false];

};



true