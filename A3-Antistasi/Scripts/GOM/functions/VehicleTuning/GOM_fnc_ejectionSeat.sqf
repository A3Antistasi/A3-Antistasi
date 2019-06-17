//GOM_fnc_ejectionSeat.sqf
//by Grumpy Old Man
//V0.9
params ["_unit"];

_veh = vehicle _unit;
_usedEjectionSeats = _veh getVariable ["GOM_fnc_usedEjectionSeats",[]];
_check = false;
_seat = -1;

{

	if (_x select 0 isEqualTo _unit AND !(_x select 2 in _usedEjectionSeats)) then {_check = true;	_seat = _x select 2;};

} foreach fullCrew _veh;

if !(_check) exitWith {

	hintsilent "You can only eject once from each seat!";
	_killHint = [] spawn GOM_fnc_killHint;
	true

};

_usedEjectionSeats pushbackUnique _seat;
_veh setVariable ["GOM_fnc_usedEjectionSeats",_usedEjectionSeats,true];
_unit allowdamage false;
_pos = getposatl _unit;
_pos set [2,(_pos select 2) + 2];
_unit setposatl _pos;
_unit say "SN_Flare_Weapon_Fired";
_unit switchMove "afalpercmstpsnonwnondnon";
_vel = velocityModelSpace _veh;
_vel = _vel vectorAdd [0,0,35];
_unit setVelocityModelSpace _vel;
_descend = [_unit] spawn {

	params ["_unit"];

	waituntil {((velocity _unit) select 2) < -1};

	_unit playmove "HaloFreeFall_non";
	_sleep = random [2,2.5,3] + time;
	waituntil {time > _sleep OR ((getposatl _unit) select 2) < 15};
	_pos = getPosASL _unit;
	_pos set [2,(_pos select 2) + 4];
	_chute = "Steerable_Parachute_F" createVehicle [0,0,500];
	_chute setdir getdir _unit;
	_unit allowdamage false;
	_chute setposASL _pos;
	_vel = velocityModelSpace _unit;
	_chute setVelocityModelSpace _vel;
	_unit moveindriver _chute;
	_unit allowdamage true;

};
true