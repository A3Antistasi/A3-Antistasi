_typeFire = if (typeOf fireX == "Land_Camping_Light_F") then {"Land_Camping_Light_off_F"} else {"Land_Camping_Light_F"};
_pos = getPos fireX;
deleteVehicle fireX;
fireX = createVehicle [_typeFire,_pos, [], 0, "CAN_COLLIDE"];
publicVariable "fireX";
fireX allowDamage false;
[fireX,"fireX"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian]];

