params ["_unit", ["_marker", ""], "_isSpawner"];
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
/*  Inits the given unit with all needed data, flags and weapons
*   Params:
*       _unit : OBJECT : The unit that needs to be initialized
*       _marker : STRING : The name of the marker (default "")
*       _isSpawner : BOOL : (Optional) Whether the unit should be made a spawner, otherwise automatic
*
*   Returns:
*       Nothing
*/

//TODO we may want to rename that file to AIinit or something
if ((isNil "_unit") || (isNull _unit)) exitWith
{
    Error_1("Bad init parameter: %1", _this);
};

private _type = _unit getVariable "unitType";
private _side = side (group _unit);

if (isNil "_type") then {
    Error_2("Unit does not have a type assigned: %1, vehicle: %2", typeOf _unit, typeOf vehicle _unit);
    _type = typeOf _unit;
};

if (_type == "Fin_random_F") exitWith {};

//Sets the EH for the unit
_unit addEventHandler ["HandleDamage", A3A_fnc_handleDamageAAF];
_unit addEventHandler ["killed", A3A_fnc_occupantInvaderUnitKilledEH];

if !(isNil "_isSpawner") then
{
    if (_isSpawner) then { _unit setVariable ["spawner",true,true] };
}
else
{
    private _veh = objectParent _unit;
    if (_marker != "") exitWith
    {
        // Persistent garrison units are never spawners.
	    _unit setVariable ["markerX",_marker,true];
	    if ((spawner getVariable _marker != 0) && (isNull _veh)) then
	    {
            // Garrison drifted out of spawn range, disable simulation on foot units
            // this is re-enabled in distance.sqf when spawn range is re-entered
            [_unit,false] remoteExec ["enableSimulationGlobal",2];
        };
    };

    if (_unit in (assignedCargo _veh)) exitWith
    {
        // Cargo units aren't spawners until they leave the vehicle.
        // Assumes that they'll get out if the crew are murdered.
        _unit addEventHandler
        [
            "GetOutMan",
            {
                _unit = _this select 0;
                if !(_unit getVariable ["surrendered", false]) then {
                    _unit setVariable ["spawner",true,true];
                };
            }
        ];
    };

	// Fixed-wing aircraft spawn far too much with little effect.
	// Don't even spawn if ejected, because they often end up miles away from the real action
	if (_veh isKindOf "Plane") exitWith {};

    // Everyone else is a spawner
	_unit setVariable ["spawner",true,true]
};

//Calculates the skill of the given unit
private _skill = (0.15 * skillMult) + (0.04 * difficultyCoef) + (0.02 * tierWar);
if ("militia_" in (_unit getVariable "unitType")) then
{
    _skill = _skill min (0.2 * skillMult);
};
if ("police" in (_unit getVariable "unitType")) then
{
    _skill = _skill min (0.12 * skillMult);
};
_unit setSkill _skill;

//Adjusts squadleaders with improved skill and adds intel action
if (_type in FactionGet(all,"SquadLeaders")) then
{
    _unit setskill ["courage",_skill + 0.2];
    _unit setskill ["commanding",_skill + 0.2];
    private _hasIntel = ((random 100) < 80);
    _unit setVariable ["hasIntel", _hasIntel, true];
    _unit setVariable ["side", _side, true];
    [_unit, "Intel_Small"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian], _unit];
};

//Sets NVGs, lights, lasers, radios and spotting skills for the night
private _hmd = hmd _unit;
if !(A3A_hasIFA) then
{
    if (sunOrMoon < 1) then
    {
        if (!("SF_" in (_unit getVariable "unitType")) and (_unit != leader (group _unit))) then
            {
                if (_hmd != "") then
                {
                    if ((random 5 > tierWar) and (!haveNV)) then
                    {
                        _unit unassignItem _hmd;
                        _unit removeItem _hmd;
                        _hmd = "";
                    };
                };
            }
        else
        {
            private _arr = (allNVGs arrayIntersect (items _unit));
            if (!(_arr isEqualTo []) or (_hmd != "")) then
            {
                if ((random 5 > tierWar) and (!haveNV) and (_unit != leader (group _unit))) then
                {
                    if (_hmd == "") then
                    {
                        _hmd = _arr select 0;
                        _unit removeItem _hmd;
                    }
                    else
                    {
                        _unit unassignItem _hmd;
                        _unit removeItem _hmd;
                    };
                    _hmd = "";
                }
                else
                {
                    _unit assignItem _hmd;
                };
            };
        };
        private _weaponItems = primaryWeaponItems _unit;
        if (_hmd != "") then
        {
            if (_weaponItems findIf {_x in allLaserAttachments} != -1) then
            {
                _unit action ["IRLaserOn", _unit];
                _unit enableIRLasers true;
            };
        }
        else
        {
            private _pointers = _weaponItems arrayIntersect allLaserAttachments;
            if !(_pointers isEqualTo []) then
            {
                _unit removePrimaryWeaponItem (_pointers select 0);
            };
            private _lamp = "";
            private _lamps = _weaponItems arrayIntersect allLightAttachments;
            if (_lamps isEqualTo []) then
            {
                private _compatibleLamps = ((primaryWeapon _unit) call BIS_fnc_compatibleItems) arrayIntersect allLightAttachments;
                if !(_compatibleLamps isEqualTo []) then
                {
                    _lamp = selectRandom _compatibleLamps;
                    _unit addPrimaryWeaponItem _lamp;
                    _unit assignItem _lamp;
                };
            }
            else
            {
                _lamp = _lamps select 0;
            };
            if (_lamp != "") then
            {
                _unit enableGunLights "AUTO";
            };
            //Reduce their magical night-time spotting powers.
            _unit setskill ["spotDistance", _skill * 0.7];
            _unit setskill ["spotTime", _skill * 0.5];
        };
    }
    else
    {
        if !("SF_" in (_unit getVariable "unitType")) then
            {
                if (_hmd != "") then
                {
                    _unit unassignItem _hmd;
                    _unit removeItem _hmd;
                };
            }
        else
        {
            private _arr = (allNVGs arrayIntersect (items _unit));
            if (count _arr > 0) then
            {
                _hmd = _arr select 0;
                _unit removeItem _hmd;
            };
        };
    };
}
else
{
    _unit unlinkItem (_unit call A3A_fnc_getRadio);
};

//Reveals all air vehicles to the unit, if it is either gunner of a vehicle or equipted with a launcher
private _reveal = false;
if !(isNull objectParent _unit) then
{
    if (_unit == gunner (objectParent _unit)) then
    {
        _reveal = true;
    };
}
else
{
    if ((secondaryWeapon _unit) in allMissileLaunchers) then
    {
        _reveal = true;
    };
};
if (_reveal) then
{
    {
        _unit reveal [_x,1.5];
    } forEach allUnits select {(vehicle _x isKindOf "Air") and (_x distance _unit <= distanceSPWN)}
};
