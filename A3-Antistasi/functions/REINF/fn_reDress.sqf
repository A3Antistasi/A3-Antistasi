//if (worldName != "Tanoa") exitWith {};
private ["_unit"];

_unit = _this select 0;

_unit addUniform (selectRandom faction_reb getVariable "uniforms");

_unit addItemToUniform "FirstAidKit";
