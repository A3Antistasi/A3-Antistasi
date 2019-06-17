//this file is called by engine eventhandler and remoteexecd on the player client who's driving it
//

_ID = addMissionEventHandler ["Draw3D",{


	_veh = vehicle player;
	if (!isEngineOn _veh OR !alive _veh OR isNull driver _veh) exitWith {removeMissionEventHandler ["Draw3D",_thisEventHandler];};

	if (player isEqualTo _veh OR {!isTouchingGround _veh}) exitWith {false};

	_initMass = _veh getVariable ["GOM_fnc_initMass",1000];
	_boostMulti = _veh getvariable ['GOM_fnc_boostMulti',0];

	_force = (_initMass * (_boostMulti / 9)) max 0;
	_baseForce = _force;

	_maxSpeedMulti = _veh getvariable ["GOM_fnc_MaxSpeed",1];
	_maxSpeed = getNumber (configfile >> "CfgVehicles" >> typeOf _veh >>
	"maxSpeed") * _maxSpeedMulti;

	_prefersRoads = (getNumber (configfile >> "CfgVehicles" >> typeOf _veh >> "preferRoads") > 0);
	_isOnRoad = isOnRoad _veh;

	_forward = (["CarForward","CarFastForward","CarSlowForward"] findIf {inputAction _x > 0} >= 0);




	if (inputAction "CarSlowForward" > 0) then {

		_force = _baseForce * 0.25;

	};

	if (inputAction "CarForward" > 0) then {

		_force = _baseForce * 0.5;

	};

	if (inputAction "CarFastForward" > 0) then {

		_force = _baseForce;

	};



	_boost = inputAction "vehicleTurbo" > 0 AND _forward;
	//add nitro option here
	if (_boost) then {

		_force = _baseForce;

	};


	//surfaceCoefficient:
	_surf = (surfaceType getPosATLVisual _veh);
	_surfaceType = _surf select [1,count _surf];
	_surfaceCoef = getNumber (configfile >> "CfgSurfaces" >> _surfaceType >> "maxSpeedCoef");

	_force = _force * _surfaceCoef;

	//now we tie force to rpm:
	_idleRPM = getNumber (configfile >> "CfgVehicles" >> typeof _veh >> "idleRpm");
	_redRPM = getNumber (configfile >> "CfgVehicles" >> typeof _veh >> "redRpm");
	_currentRPM = _veh getSoundController "rpm";

	_force = linearConversion [_idleRPM,_redRPM,_currentRPM,_force / 3,_force,true];
	_rpmForce = _force;
	//also tie force to speed to emulate air resistance
	_force = linearConversion [100,_maxSpeed,speed _veh,_force,_force * 0.65,true];
	_airForce = _force;

	if (_forward AND round speed _veh > 0 AND round speed _veh <= _maxSpeed) then {
	_veh addForce [_veh vectorModelToWorldVisual [0,_force,0],[0,0,-1]];

	};

	if (inputAction "CarBack" > 0 AND speed _veh >= 1) then {
	_brakeMulti = GOM_fnc_brakeParams apply {_x#1};
	_brakeForce = -75 * (_brakeMulti select (_veh getVariable ["GOM_fnc_brakeType",0]));
	_veh addForce [_veh vectorModelToWorldVisual [0,_brakeForce,0],[0,0,-1]];

	};


	//hintsilent format ["Boost Active: %1\nBase force: %2\nRPM force: %3\nAir+RPM force: %4\nForce applied: %5\nSurface Coef: %6",_boost,_baseForce,_rpmForce,_airForce,_force,_surfaceCoef];

	//blowOff valve

	_lastFrameRPM = _veh getVariable ["GOM_fnc_lastFrameRPM",_redRPM];


	_blowOffToggle = _veh getVariable ["GOM_fnc_blowOffToggle",true];

	if (_blowOffToggle AND {_currentRPM < (_lastFrameRPM)} AND (_veh getSoundController "thrust" > 0.3)) then {

		[_veh] spawn GOM_fnc_blowOff;
		_veh setVariable ["GOM_fnc_blowOffToggle",false];
	};

	if (_currentRPM > (_lastFrameRPM)) then {

		_veh setVariable ["GOM_fnc_blowOffToggle",true];

	};


		_veh setVariable ["GOM_fnc_lastFrameRPM",_currentRPM];



}];
_ID