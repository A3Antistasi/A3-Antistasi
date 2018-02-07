private ["_tipo","_return","_tiempo"];
_tipo = _this select 0;

_return = true;
_tiempo = timer getVariable _tipo;
if (!isNil "_tiempo") then
	{
	if (tierWar < 3) then
		{
		if (tierWar == 1) then
			{
			if ((_tipo in vehNATOAttack) or (_tipo == vehNATOPlane) or (_tipo in vehNATOAttackHelis) or (_tipo == vehNATOPlaneAA)) then {_return = false} else {if (dateToNumber date < _tiempo) then {_return = false}}
			}
		else
			{
			if ((_tipo == vehNATOTank) or (_tipo == vehNATOPlane) or (_tipo == vehNATOPlaneAA)) then {_return = false} else {if (dateToNumber date < _tiempo) then {_return = false}};
			};
		}
	else
		{
		if (dateToNumber date < _tiempo) then {_return = false};
		};
	};

_return;