_check = false;
_obj = (_this select 0) getVariable ["owner",_this select 0];
if ((count miembros == 0) or ((getPlayerUID _obj) in miembros) or (!isMultiplayer)) then {_check = true};

_check
