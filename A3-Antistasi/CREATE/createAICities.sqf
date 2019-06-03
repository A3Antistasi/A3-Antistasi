//NOTA: TAMBIÉN LO USO PARA FIA
if (!isServer and hasInterface) exitWith{};

private ["_markerX","_groups","_soldiers","_positionX","_num","_datos","_prestigeOPFOR","_prestigeBLUFOR","_esAAF","_params","_frontierX","_array","_countX","_grupo","_perro","_grp","_lado"];
_markerX = _this select 0;

_groups = [];
_soldiers = [];

_positionX = getMarkerPos (_markerX);

_num = [_markerX] call A3A_fnc_sizeMarker;
_lado = lados getVariable [_markerX,sideUnknown];
if ({if ((getMarkerPos _x inArea _markerX) and (lados getVariable [_x,sideUnknown] != _lado)) exitWith {1}} count markersX > 0) exitWith {};
_num = round (_num / 100);

_datos = server getVariable _markerX;
//_prestigeOPFOR = _datos select 3;
//_prestigeBLUFOR = _datos select 4;
_prestigeOPFOR = _datos select 2;
_prestigeBLUFOR = _datos select 3;
_esAAF = true;
if (_markerX in destroyedCities) then
	{
	_esAAF = false;
	_params = [_positionX,Invaders,CSATSpecOp];
	}
else
	{
	if (_lado == malos) then
		{
		_num = round (_num * (_prestigeOPFOR + _prestigeBLUFOR)/100);
		_frontierX = [_markerX] call A3A_fnc_isFrontline;
		if (_frontierX) then
			{
			_num = _num * 2;
			_params = [_positionX, malos, groupsNATOSentry];
			}
		else
			{
			_params = [_positionX, malos, groupsNATOGen];
			};
		}
	else
		{
		_esAAF = false;
		_num = round (_num * (_prestigeBLUFOR/100));
		_array = [];
		{if (random 20 < skillFIA) then {_array pushBack (_x select 0)} else {_array pushBack (_x select 1)}} forEach groupsSDKSentry;
		_params = [_positionX, teamPlayer, _array];
		};
	};
if (_num < 1) then {_num = 1};

_countX = 0;
while {(spawner getVariable _markerX != 2) and (_countX < _num)} do
	{
	_grupo = _params call A3A_fnc_spawnGroup;
	sleep 1;
	if (_esAAF) then
		{
		if (random 10 < 2.5) then
			{
			_perro = _grupo createUnit ["Fin_random_F",_positionX,[],0,"FORM"];
			[_perro] spawn A3A_fnc_guardDog;
			};
		};
	_nul = [leader _grupo, _markerX, "SAFE", "RANDOM", "SPAWNED","NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_groups pushBack _grupo;
	_countX = _countX + 1;
	};

if ((_esAAF) or (_markerX in destroyedCities)) then
	{
	{_grp = _x;
	{[_x,""] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grp;} forEach _groups;
	}
else
	{
	{_grp = _x;
	{[_x] spawn A3A_fnc_FIAinitBases; _soldiers pushBack _x} forEach units _grp;} forEach _groups;
	};

waitUntil {sleep 1;((spawner getVariable _markerX == 2)) or ({[_x,_markerX] call A3A_fnc_canConquer} count _soldiers == 0)};

if (({[_x,_markerX] call A3A_fnc_canConquer} count _soldiers == 0) and (_esAAF)) then
	{
	[[_positionX,malos,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2];
	};

waitUntil {sleep 1;(spawner getVariable _markerX == 2)};

{if (alive _x) then {deleteVehicle _x}} forEach _soldiers;
{deleteGroup _x} forEach _groups;