private ["_typeX","_costs"];

_typeX = _this select 0;

_costs = server getVariable _typeX;

if (isNil "_costs") then
	{
	diag_log format ["Antistasi Error en vehicleprice: %!",_typeX];
	_costs = 0;
	}
else
	{
	_costs = round (_costs - (_costs * (0.1 * ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count seaports))));
	};

_costs