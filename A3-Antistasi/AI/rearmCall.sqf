{
if (vehicle _x == _x) then {[_x] spawn autoRearm} else {[_x,vehicle _x] spawn autoLoot};
sleep 3+(random 5)
} forEach _this;