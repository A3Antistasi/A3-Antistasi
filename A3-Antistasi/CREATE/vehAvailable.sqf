private ["_tipo","_return","_tiempo"];
_tipo = _this select 0;
if (_tipo == "") exitWith {false};
_return = true;
_tiempo = timer getVariable _tipo;
if (!isNil "_tiempo") then
	{
	if ((tierWar + difficultyCoef) < 3) then
		{
		if ((_tipo == vehNATOAA) or (_tipo == vehNATOMRLS) or (_tipo == vehNATOPlane) or (_tipo == vehNATOPlaneAA) or (_tipo == vehNATOTank)) then
			{
			_return = false
			}
		else
			{
			if (tierWar == 1) then
				{
				if ((_tipo in vehNATOAttack) or (_tipo in vehNATOAttackHelis)) then {_return = false} else {if (dateToNumber date < _tiempo) then {_return = false}}
				}
			else
				{
				if (dateToNumber date < _tiempo) then {_return = false};
				};
			};
		}
	else
		{
		if (dateToNumber date < _tiempo) then {_return = false};
		};
	};

_return;