params ["_newPosition"];

respawnTeamPlayer setMarkerPos _newPosition;
posHQ = _newPosition; publicVariable "posHQ";

[respawnTeamPlayer,1] remoteExec ["setMarkerAlphaLocal",[teamPlayer,civilian]];
[respawnTeamPlayer,0] remoteExec ["setMarkerAlphaLocal",[Occupants,Invaders]];

private _firePos = [_newPosition, 3, getDir petros] call BIS_Fnc_relPos;
fireX setPos _firePos;
_rnd = getdir petros;
_pos = [_firePos, 3, _rnd] call BIS_Fnc_relPos;
boxX setPos _pos;
_rnd = _rnd + 45;
_pos = [_firePos, 3, _rnd] call BIS_Fnc_relPos;
mapX setDir ([_firePos, _pos] call BIS_fnc_dirTo);
mapX setPos _pos;
_rnd = _rnd + 45;
_pos = [_firePos, 3, _rnd] call BIS_Fnc_relPos;
_emptyPos = _pos findEmptyPosition [0,50,(typeOf flagX)];
_pos = if (count _emptyPos > 0) then {_emptyPos} else {_pos};
flagX setPos _pos;
_rnd = _rnd + 45;
_pos = [_firePos, 3, _rnd] call BIS_Fnc_relPos;
vehicleBox setPos _pos;

boxX hideObjectGlobal false;
vehicleBox hideObjectGlobal false;
mapX hideObjectGlobal false;
fireX hideObjectGlobal false;
flagX hideObjectGlobal false;

"Synd_HQ" setMarkerPos _newPosition;
chopForest = false; publicVariable "chopForest";