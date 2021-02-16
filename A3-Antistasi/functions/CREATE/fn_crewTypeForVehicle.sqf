/*
    File: fn_crewTypeForVehicle.sqf
    Author: Spoffy
    
    Description:
		Guesses the correct crew type for the given vehicle.
    
    Parameter(s):
		_side - Side of the vehicle [SIDE]
		_vehicle - Vehicle to guess on [OBJECT]
    
    Returns:
		Unit type [STRING]
    
    Example(s):
*/

params ["_side", "_vehicle"];

private _sideIndex = [west, east, independent, civilian] find _side;

if (_vehicle isKindOf "Plane") exitWith {
	[NATOPilot, CSATPilot, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

if (_vehicle isKindOf "Tank" || _vehicle isKindOf "Helicopter") exitWith {
	[NATOCrew, CSATCrew, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

[NATOGrunt, CSATGrunt, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
