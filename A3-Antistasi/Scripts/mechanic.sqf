_uid = getplayerUID player;
_mechanic = ["xxxxxx"];
if (_uid in _mechanic) then {
  hint format  ["%1 Mechanic\n ID = %2",(name player),_uid];
  _allowed = true;
  player setVariable ["GOM_fnc_qualifiedMechanic",_allowed,true];
};
