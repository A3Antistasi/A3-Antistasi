_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < 100) exitWith {hint "FIA has not enough resources to grab"};
[100] call resourcesPlayer;
server setvariable ["resourcesFIA",_resourcesFIA - 100, true];
[] remoteExec ["statistics",theBoss];
[-2,theBoss] call playerScoreAdd;
["scorePlayer", player getVariable "score"] call fn_SaveStat;

hint format ["You grabbed 100 € from the %1 Money Pool.\n\nThis will affect your prestige and status among %1 forces",nameBuenos];