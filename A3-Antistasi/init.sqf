diag_log format ["%1: [Antistasi] | INFO | Init Started.",servertime];
//Arma 3 - Antistasi - Warlords of the Pacific by Barbolani & The Official AntiStasi Community
//Do whatever you want with this code, but credit me for the thousand hours spent making this.
private _fileName = "init.sqf";
scriptName "init.sqf";

if (isNil "logLevel") then {logLevel = 2};
[2,"Init SQF started",_fileName] call A3A_fnc_log;

enableSaving [false,false];
mapX setObjectTexture [0,"pic.jpg"];

[2,"Init finished",_fileName] call A3A_fnc_log;