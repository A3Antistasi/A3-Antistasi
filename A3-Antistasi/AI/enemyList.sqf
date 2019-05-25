private _group = _this;

private _LeaderX = leader _group;

private _lado = side _group;
private _enemySides = _lado call BIS_fnc_enemySides;
private _objectivesX = (_LeaderX nearTargets  500) select {((_x select 2) in _enemySides) and ([_x select 4] call A3A_fnc_canFight)};
_objectivesX = [_objectivesX,[_LeaderX],{_input0 distance (_x select 0)},"ASCEND"] call BIS_fnc_sortBy;
_group setVariable ["objectivesX",_objectivesX];
_objectivesX