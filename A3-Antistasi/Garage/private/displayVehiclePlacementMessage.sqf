#include "..\defineCommon.inc"

//THIS SHOULDN'T BE CALLED OUTSIDE OF THE VEHICLE PLACEMENT SCRIPTS
//CALL AT YOUR OWN RISK

params ["_vehType"];

private _vehName = getText (configFile >> "CfgVehicles" >> _vehType >> "displayName");
[format ["<t size='0.7'>%1</t><br/><t size='0.5'>%2</t><br/><t size='0.5'>SPACE to place vehicle<br/>Arrow Left-Right to rotate<br/>ENTER to Exit</t>", _vehName, vehPlace_extraMessage],0,0,5,0,0,4] spawn bis_fnc_dynamicText;
