_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < 100) exitWith {hint "FIA has not enough resources to grab"};
[100] call resourcesPlayer;
server setvariable ["resourcesFIA",_resourcesFIA - 100, true];
[-2,stavros] call playerScoreAdd;
["scorePlayer", player getVariable "score"] call fn_SaveStat;

hint "You grabbed 100 € from the SDK Money Pool.\n\nThis will affect your prestige and status among SDK forces";