private ["_morty","_helperX"];

{if (_x getVariable ["typeOfSoldier",""] == "StaticMortar") then {_morty = _x} else {_helperX = _x}} forEach _this;

private _grupo = group _morty;
while {true} do
	{
	_enemigo = _grupo call A3A_fnc_nearEnemy;
	if (isNull _enemigo) exitWith {};
	if (_enemigo distance _morty > 50) exitWith {};
	if ((!alive _morty) or (!alive _helperX)) exitWith {};
	sleep 30;
	};
if ((!alive _morty) or (!alive _helperX)) exitWith {};
private _tipoVeh = if (side _morty == malos) then {NATOMortar} else {CSATMortar};
private _pos = [];
while {true} do
	{
	_pos = position _morty findEmptyPosition [1,30,_tipoVeh];
	if !(_pos isEqualTo []) exitWith {};
	if ((!alive _morty) or (!alive _helperX)) exitWith {};
	sleep 30;
	};

if ((!alive _morty) or (!alive _helperX)) exitWith {};
_morty setVariable ["maneuvering",true];
while {true} do
	{
	if (_morty distance _pos < 5) exitWith {};
	_morty doMove _pos;
	_helperX doMove _pos;
	if ((!alive _morty) or (!alive _helperX)) exitWith {};
	sleep 10;
	};

if ((!alive _helperX) and (alive _morty)) then
	{
	_morty setVariable ["maneuvering",false];
	_movable = _grupo getVariable ["movable",[]];
	_movable pushBack _morty;
	_grupo setVariable ["movable",_movable];
	_flankers = _grupo getVariable ["flankers",[]];
	_flankers pushBack _morty;
	_grupo setVariable ["flankers",_flankers];
	_morty call A3A_fnc_recallGroup;
	};
if ((alive _helperX) and !(alive _morty)) then
	{
	_movable = _grupo getVariable ["movable",[]];
	_movable pushBack _helperX;
	_grupo setVariable ["movable",_movable];
	_flankers = _grupo getVariable ["flankers",[]];
	_flankers pushBack _helperX;
	_grupo setVariable ["flankers",_flankers];
	_helperX call A3A_fnc_recallGroup;
	};

if ((!alive _morty) or (!alive _helperX)) exitWith {};

private _mortero = _tipoVeh createVehicle _pos;
removeBackpackGlobal _morty;
removeBackpackGlobal _helperX;
_grupo addVehicle _mortero;
_morty assignAsGunner _mortero;
[_morty] orderGetIn true;
[_morty] allowGetIn true;
_nul = [_mortero] call A3A_fnc_AIVEHinit;
_movable = _grupo getVariable ["movable",[]];
_movable pushBack _helperX;
_grupo setVariable ["movable",_movable];
_flankers = _grupo getVariable ["flankers",[]];
_flankers pushBack _helperX;
_grupo setVariable ["flankers",_flankers];
_helperX call A3A_fnc_recallGroup;

waitUntil {sleep 1; (vehicle _morty == _mortero) or !(alive _morty) or !(alive _mortero)};

if !(alive _morty) exitWith {};

if !(alive _mortero) exitWith {_morty call A3A_fnc_recallGroup};

_grupo setVariable ["mortarsX",_morty];

_morty addEventHandler ["Killed",
	{
	(group (_this select 0)) setVariable ["mortarsX",objNull];
	}];