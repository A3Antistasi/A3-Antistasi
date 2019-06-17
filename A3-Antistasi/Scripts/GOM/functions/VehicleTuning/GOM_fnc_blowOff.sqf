params ["_veh"];
_lockoutTime = 0.4;
_blowOffLockout = _veh getVariable ["GOM_fnc_blowOffLockout",0];
if (time < _blowOffLockout + _lockoutTime) exitWith {false};
_veh setVariable ["GOM_fnc_blowOffLockout",time];
_sounds = ["GOM_VT_valve1","GOM_VT_valve2","GOM_VT_valve3","GOM_VT_valve4"];
_crewPlayers = ((crew _veh) select {isPlayer _x});
_rest = (allPlayers - [_crewPlayers]) select {_x distance2D _veh < 300};

_sound = selectRandom _sounds;

//play 2d sound for everyone in the car
[_sound] remoteExec ["playSound",_crewPlayers];

//play 3d sound for those poor peasants outside the car
_pitch = 0.95 + random 0.1;
[_veh,[_sound,300,_pitch]] remoteExec ["say3D",_rest];
true