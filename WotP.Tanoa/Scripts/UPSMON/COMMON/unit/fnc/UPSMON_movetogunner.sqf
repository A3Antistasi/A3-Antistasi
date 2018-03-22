/****************************************************************
File: UPSMON_movetogunner.sqf
Author: MONSADA

Description:
	Funci�n que mueve al soldado a la posici�n de conductor
Parameter(s):
	<--- unit
	<--- Vehicle to mount
Returns:

****************************************************************/
private["_vehicle","_npc"];		

_npc = _this ;
_vehicle = vehicle _npc;
	
sleep 0.05;
//Si est� muerto
if (vehicle _npc == _npc || !alive _npc || !canmove _npc || !(_npc iskindof "Man")) exitwith{};
	
if (isnull(gunner _vehicle) || !alive(gunner _vehicle) || !canmove(gunner _vehicle)) then 
{ 	
	if (UPSMON_Debug>0) then {player sidechat format["%1: Moving to gunner of %2 ",_npc,typeof _vehicle]}; 	
	_npc action ["getOut", _vehicle];
	doGetOut _npc;
	WaitUntil {vehicle _npc==_npc || !alive _npc || !canmove _npc};
	//Si est� muerto
	if (!alive _npc || !canmove _npc) exitwith{};		
	unassignVehicle _npc;
	_npc assignasgunner _vehicle;
	_npc moveingunner _vehicle;
};