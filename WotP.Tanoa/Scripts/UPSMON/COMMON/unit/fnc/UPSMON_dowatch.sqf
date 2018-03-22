/****************************************************************
File: UPSMON_dowatch.sqf
Author: MONSADA

Description:
	Funci�n para  mirar en una direcci�n
Parameter(s):
	<--- Unit
	<--- Position to watch
Returns:

****************************************************************/
private["_target","_npc","_height"];	
	
_npc = _this select 0;
_target = _this select 1;
_height = 1;
If (count _this > 2) then {_height = _this select 2};	

If (typename _target == "ARRAY") then
{
	_target = [(_this select 1) select 0,(_this select 1) select 1,_height];
}
else
{
	_target = getposATL _target;
	_target set [2,_height];
};

if (!alive _npc) exitwith{};
_npc doWatch ObjNull;
_npc doWatch _target;
