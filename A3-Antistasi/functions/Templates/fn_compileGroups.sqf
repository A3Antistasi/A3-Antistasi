/*
Author: Håkon
Description:
    Adds the unit and group definitions to the faction hashmap

    note this is only the name of the data for unit creation, not the actuall unit data.
    as all factions group data is generated with this file some groups do not have coresponding loadout data.

Arguments:
0. <Hashmap> Faction data hashmap
1. <String>  Faction prefix

Return Value: nil

Scope: Server,Server/HC,Clients,Any
Environment: Scheduled/unscheduled/Any
Public: Yes/No
Dependencies:

Example:

License: MIT License
*/
params ["_faction", "_prefix"];

//Defines
#define unit(SECTION, TYPE) ("loadouts_"+_prefix+"_"+ #SECTION +"_"+ TYPE)
#define double(X) [X, X]

//---------------|
// AI Group data |
//---------------|
if (_prefix in ["occ", "inv"]) exitWith {

//singular units
_faction set ["unitGrunt", unit(military, "Rifleman")];
_faction set ["unitBodyguard", unit(military, "Rifleman")];
_faction set ["unitMarksman", unit(military, "Marksman")];
_faction set ["unitStaticCrew", unit(military, "Rifleman")];

_faction set ["unitOfficial", unit(other, "Official")];
_faction set ["unitTraitor", unit(other, "Traitor")];
_faction set ["unitCrew", unit(other, "Crew")];
_faction set ["unitUnarmed", unit(other, "Unarmed")];
_faction set ["unitPilot", unit(other, "Pilot")];

_faction set ["unitMilitiaGrunt", unit(militia, "Rifleman")];
_faction set ["unitMilitiaMarksman", unit(militia, "Marksman")];

_faction set ["unitPoliceOfficer", unit(police, "SquadLeader")];
_faction set ["unitPoliceGrunt", unit(police, "Standard")];

//military
_faction set ["groupSentry", [unit(military, "Grenadier"), unit(military, "Rifleman")]];
_faction set ["groupSniper", [unit(military, "Sniper"), unit(military, "Rifleman")]];
_faction set ["groupsSmall", [_faction get "groupSentry", _faction get "groupSniper"]];
_faction set ["groupAA", [unit(military, "SquadLeader"), unit(military, "AA"), unit(military, "AA"), unit(military, "Rifleman")]];
_faction set ["groupAT", [unit(military, "SquadLeader"), unit(military, "AT"), unit(military, "AT"), unit(military, "Rifleman")]];
_faction set ["groupsMedium", [
    [unit(military, "SquadLeader"), unit(military, "MachineGunner"), unit(military, "Grenadier"), unit(military, "LAT")]
    , _faction get "groupAA", _faction get "groupAT"
]];

//old randomised behaviour maintained because... reasons
private _squads = [];
for "_i" from 1 to 5 do {
    _squads pushBack [
        unit(military, "SquadLeader"),
        selectRandomWeighted [unit(military, "LAT"), 2, unit(military, "MachineGunner"), 1],
        selectRandomWeighted [unit(military, "Rifleman"), 2, unit(military, "Grenadier"), 1],
        selectRandomWeighted [unit(military, "MachineGunner"), 2, unit(military, "Marksman"), 1],
        selectRandomWeighted [unit(military, "Rifleman"), 4, unit(military, "AT"), 1],
        selectRandomWeighted [unit(military, "AA"), 1, unit(military, "Engineer"), 4],
        unit(military, "Rifleman"),
        unit(military, "Medic")
    ];
};
_faction set ["groupsSquads", _squads];

//specops
_faction set ["groupSpecOps", [
    unit(SF, "SquadLeader")
    , unit(SF, "Rifleman")
    , unit(SF, "MachineGunner")
    , unit(SF, "ExplosivesExpert")
    , unit(SF, "LAT")
    , unit(SF, "Medic")
]];

//militia
_faction set ["groupsMilitiaSmall", [
    [unit(militia, "Grenadier"), unit(militia, "Rifleman")]
    , [unit(militia, "Marksman"), unit(militia, "Rifleman")]
    , [unit(militia, "Marksman"), unit(militia, "Grenadier")]
]];

private _militiaMid = [];
for "_i" from 1 to 6 do {
    _militiaMid pushBack [
        unit(militia, "SquadLeader"),
        unit(militia, "Grenadier"),
        unit(militia, "MachineGunner"),
        selectRandom [
            unit(militia, "LAT"),
            unit(militia, "Marksman"),
            unit(militia, "Engineer")
        ]
    ];
};
_faction set ["groupsMilitiaMedium", _militiaMid];

private _militiaSquads = [];
for "_i" from 1 to 5 do {
    _militiaSquads pushBack [
        unit(militia, "SquadLeader"),
        unit(militia, "MachineGunner"),
        unit(militia, "Grenadier"),
        unit(militia, "Rifleman"),
        selectRandom [unit(militia, "Rifleman"), unit(militia, "Marksman")],
        selectRandomWeighted [unit(militia, "Rifleman"), 2, unit(militia, "Marksman"), 1],
        selectRandom [unit(militia, "Rifleman"), unit(militia, "ExplosivesExpert")],
        unit(militia, "LAT"),
        unit(militia, "Medic")
    ];
};
_faction set ["groupsMilitiaSquads", _militiaSquads];

//police
_faction set ["groupPolice", [_faction get "unitPoliceOfficer", _faction get "unitPoliceGrunt"]];
_faction set ["groupPoliceSquad", [
    _faction get "unitPoliceOfficer", _faction get "unitPoliceGrunt", _faction get "unitPoliceGrunt", _faction get "unitPoliceGrunt"
    , _faction get "unitPoliceGrunt", _faction get "unitPoliceGrunt", _faction get "unitPoliceGrunt", _faction get "unitPoliceGrunt"
]];

};

//------------------|
// Rebel Group data |
//------------------|

//singular units
_faction set ["unitPetros", unit(militia, "Petros")];
_faction set ["unitCrew", unit(militia, "staticCrew")];
_faction set ["unitUnarmed", unit(militia, "Unarmed")];
_faction set ["unitSniper", unit(militia, "Sniper")];
_faction set ["unitLAT", unit(militia, "LAT")];
_faction set ["unitMedic", unit(militia, "Medic")];
_faction set ["unitMG", unit(militia, "MachineGunner")];
_faction set ["unitExp", unit(militia, "ExplosivesExpert")];
_faction set ["unitGL", unit(militia, "Grenadier")];
_faction set ["unitRifle", unit(militia, "Rifleman")];
_faction set ["unitSL", unit(militia, "SquadLeader")];
_faction set ["unitEng", unit(militia, "Engineer")];

//groups
_faction set ["groupMedium", [_faction get "unitSL", _faction get "unitGL", _faction get "unitMG", _faction get "unitRifle"]];
_faction set ["groupAT", [_faction get "unitSL", _faction get "unitMG", _faction get "unitLAT", _faction get "unitLAT", _faction get "unitLAT"]];
_faction set ["groupSquad", [
    _faction get "unitSL"
    , _faction get "unitGL"
    , _faction get "unitRifle"
    , _faction get "unitMG"
    , _faction get "unitRifle"
    , _faction get "unitLAT"
    , _faction get "unitRifle"
    , _faction get "unitMedic"
]];
_faction set ["groupSquadEng", [
    _faction get "unitSL"
    , _faction get "unitGL"
    , _faction get "unitRifle"
    , _faction get "unitMG"
    , _faction get "unitExp"
    , _faction get "unitLAT"
    , _faction get "unitEng"
    , _faction get "unitMedic"
]];
_faction set ["groupSquadSupp", [
    _faction get "unitSL"
    , _faction get "unitGL"
    , _faction get "unitRifle"
    , _faction get "unitMG"
    , _faction get "unitLAT"
    , _faction get "unitMedic"
    , _faction get "unitCrew"
    , _faction get "unitCrew"
]];
_faction set ["groupSniper", double( _faction get "unitSniper" )];
_faction set ["groupSentry", [_faction get "unitGL", _faction get "unitRifle"]];

_faction set ["unitsSoldiers", (_faction get "groupSquadEng") + [_faction get "unitSniper", _faction get "unitCrew"]];

