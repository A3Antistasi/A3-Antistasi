#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params["_vehicle", "_caller", "_actionID"];

if(!isPlayer _caller) exitWith {["Breach Vehicle", "Only players are currently able to breach vehicles!"] call A3A_fnc_customHint;};

//Only engineers should be able to breach a vehicle
private _isEngineer = _caller getUnitTrait "engineer";
if(!_isEngineer) exitWith
{
    ["Breach Vehicle", "You have to be an engineer to breach a vehicle!"] call A3A_fnc_customHint;;
};

if(!alive _vehicle) exitWith
{
    ["Breach Vehicle", "Why would you want to breach a destroyed vehicle?"] call A3A_fnc_customHint;
    _vehicle removeAction _actionID;
};

private _vehCrew = crew _vehicle;
private _aliveCrew = _vehCrew select {alive _x};
if(count _aliveCrew == 0) exitWith
{
    ["Breach Vehicle", "There is no living crew left, no need for breaching!"] call A3A_fnc_customHint;
    _vehicle lock false;
    _vehicle removeAction _actionID;
};

if(side (_aliveCrew select 0) == teamPlayer) exitWith
{
    ["Breach Vehicle", "You cannot breach a vehicle which is controlled by the rebels!"] call A3A_fnc_customHint;
    _vehicle removeAction _actionID;
};

private _isTank = (typeOf _vehicle) in FactionGet(all,"vehiclesTanks");

private _magazines = magazines _caller;
private _magazineArray = [];

//Sort magazines
private _index = -1;
{
    private _mag =_x;
    _index = _magazineArray findIf {(_x select 0) == _mag};
    if(_index == -1) then
    {
        _magazineArray pushBack [_mag, 1];
    }
    else
    {
        private _element = _magazineArray select _index;
        _element set [1, (_element select 1) + 1];
    };
} forEach _magazines;

//Abort if no explosives found
if(_magazineArray isEqualTo []) exitWith
{
    ["Breach Vehicle", "You carry no explosives. You will need some to breach vehicles!"] call A3A_fnc_customHint;
};

private _explosive = "";
private _explosiveCount = 0;

private _fn_selectExplosive =
{
    params ["_array", "_mags"];
    private _result = [];
    {
        private _breach = _x select 0;
        private _index = _mags findIf {(_x select 0) == _breach};
        if(_index != -1) then
        {
            if((_mags select _index) select 1 >= (_x select 1)) then
            {
                _result = [_breach, _x select 1];
            };
        };

    } forEach _array;
    _result;
};

_index = -1;

private _needed = FactionGet(reb, (if(_isTank) then {"breachingExplosivesTank"} else {"breachingExplosivesAPC"}));
private _explo = [_needed, _magazineArray] call _fn_selectExplosive;
if(!(_explo isEqualTo [])) then
{
    _explosive = _explo select 0;
    _explosiveCount = _explo select 1;
};

if(_explosiveCount == 0) exitWith
{
    ["Breach Vehicle", "You don't have the right explosives, check the briefing notes to see what you need!"] call A3A_fnc_customHint;
};

private _time = 15 + (random 5);
private _damageDealt = 0;
if(_isTank) then
{
    _time = 45 + (random 15);
    _damageDealt = 0.25 + random 0.25;
}
else
{
    _time = 25 + (random 10);
    _damageDealt = 0.15 + random 0.15;
};

_caller setVariable ["timeToBreach",time + _time];
_caller playMoveNow selectRandom medicAnims;
_caller setVariable ["breachVeh", _vehicle];
_caller setVariable ["animsDone",false];
_caller setVariable ["cancelBreach",false];

private _action = _caller addAction ["Cancel Breaching", {(_this select 1) setVariable ["cancelBreach",true]},nil,6,true,true,"","(isPlayer _this) && (_this == vehicle _this)"];
_vehicle removeAction _actionID;

_caller addEventHandler ["AnimDone",
{
	private _caller = _this select 0;
  private _vehicle = _caller getVariable "breachVeh";
	if
  (
    (alive _vehicle) &&
    {(_caller == vehicle _caller) &&
    {(_caller distance _vehicle < 8) &&
    {([_caller] call A3A_fnc_canFight) &&
    {(time <= (_caller getVariable ["timeToBreach",time])) &&
    {!(_caller getVariable ["cancelBreach",false])}}}}}
  ) then
	{
		_caller playMoveNow selectRandom medicAnims;
	}
	else
	{
		_caller removeEventHandler ["AnimDone",_thisEventHandler];
		_caller setVariable ["animsDone",true];
	};
}];

//Wait for anims to finish
waitUntil {sleep 0.5; (_caller getVariable ["animsDone",false])};

_caller setVariable ["breachVeh", objNull];
_caller removeAction _action;

if
(
  !alive _vehicle ||
  {_caller != vehicle _caller || //TODO there was something about that on the optimisation page, look it up
  {_caller distance _vehicle >= 8 ||
  {!([_caller] call A3A_fnc_canFight) ||
  {_caller getVariable ["cancelBreach",false]}}}}
) exitWith
{
  ["Breach Vehicle", "Breaching cancelled."] call A3A_fnc_customHint;
  _caller setVariable ["cancelBreach",nil];
  if(alive _vehicle) then {
	_vehicle call A3A_fnc_addActionBreachVehicle;
  };
};

//Remove the correct amount of explosives
for "_count" from 1 to _explosiveCount do
{
    _caller removeMagazineGlobal _explosive;
};

//Added as the vehicle might blow up. Best not to blow up in the player's face.
//Pause AFTER removing the explosive in case they decide to drop it or something.
["Breach Vehicle", "Breaching in 10 seconds."] call A3A_fnc_customHint;
sleep 10;

private _hitPointsConfigPath = configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "HitPoints";

private _hullHitPoint = getText (_hitPointsConfigPath >> "HitHull" >> "name");
private _currentDamage = _vehicle getHit _hullHitPoint;
private _result = _currentDamage + _damageDealt;
if(_result > 1) then {_result = 1};
_vehicle setHit [_hullHitPoint, _result];

private _fuelHitPoint = getText (_hitPointsConfigPath >> "HitFuel" >> "name");
_currentDamage = _vehicle getHitPointDamage _fuelHitPoint;
_result = _currentDamage + _damageDealt;
if(_result > 1) then {_result = 1};
_vehicle setHit [_fuelHitPoint, _result];

private _engineHitPoint = getText (_hitPointsConfigPath >> "HitEngine" >> "name");
_currentDamage = _vehicle getHitPointDamage _engineHitPoint;
_result = _currentDamage + _damageDealt;
if(_result > 1) then {_result = 1};
_vehicle setHit [_engineHitPoint, _result];

private _bodyHitPoint = getText (_hitPointsConfigPath >> "HitBody" >> "name");
_currentDamage = _vehicle getHitPointDamage _bodyHitPoint;
_result = _currentDamage + _damageDealt;
if(_result > 1) then {_result = 1};
_vehicle setHit [_bodyHitPoint, _result];

if(((damage _vehicle) + _damageDealt) > 0.9) exitWith
{
  private _bomb = "SatchelCharge_Remote_Ammo_Scripted" createVehicle (getPos _vehicle);
  _bomb setDamage 1;
  _vehicle setDamage 1;
};

playSound3D [ "A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions3.wss", _vehicle, false, (getPos _vehicle), 4, 1, 0 ];

sleep 0.5;
_vehicle lock 0;

private _crew = crew _vehicle;
{
    if(random 10 > 7) then
    {
      _x setDamage 1;
    };
    if(alive _x) then
    {
        moveOut _x;
        [_x] remoteExec ["A3A_fnc_surrenderAction", _x];		// execute local to crewman
    }
    else
    {
        private _dropPos = _vehicle getRelPos [5, random 360];
        _x setPos _dropPos;
    };
} forEach _crew;

[_vehicle, teamPlayer, true] call A3A_fnc_vehKilledOrCaptured;
