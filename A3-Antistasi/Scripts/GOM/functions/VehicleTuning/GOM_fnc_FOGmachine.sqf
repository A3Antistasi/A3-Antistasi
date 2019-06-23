//GOM_fnc_FOGmachine.sqf
//by Grumpy Old Man
//V0.9
params ["_veh"];

_rounds = _veh getVariable ['GOM_fnc_FogMachineRounds',0];
if (_rounds <= 0) exitWith {true};
	_rounds = _rounds - 1;
	_actionID = _veh getvariable ["GOM_fnc_FOGactionID",-1];
	_veh setUserActionText [_actionID, format ["Engage 'Fog' Machine (%1 Charges)",_rounds]];
	_veh setVariable ['GOM_fnc_FogMachineRounds',_rounds,true];

	for "_i" from 0 to random [8,10,12] do {

		if !(alive _veh) exitWith {true};
			sleep 0.3;
			_vel = velocity _veh;
			_vel params ["_velX","_velY","_velZ"];
			_pos = getposatl _veh;
			_rndsmoke = selectRandom ["SmokeShellBlue","SmokeShellGreen","SmokeShellOrange","SmokeShellYellow","SmokeShellPurple","SmokeShellRed","SmokeShell"];
			_pos set [2,((_pos select 2) + 3)];
			_smoke = _rndSmoke createVehicle _pos;
			_delete = [_smoke] spawn {
			params ["_smoke"];
			_deleteTime = time + 15;
			waituntil {time > _deleteTime};
			if !(alive _smoke) exitWith {true};
				deletevehicle _smoke;
				true
			};
			_smoke setposatl _pos;
			_smoke say3D "SN_Flare_Weapon_Fired";

			_dir = random 360;
			_smoke setVelocity [

			_velX + (random [2,3,4] * (sin _dir)),
			_velY + (random [2,3,4] * (cos _dir)),
			_velZ + 15

			];

		};
true