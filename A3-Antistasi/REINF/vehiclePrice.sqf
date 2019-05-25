private ["_tipo","_costs"];

_tipo = _this select 0;

_costs = server getVariable _tipo;

if (isNil "_costs") then
	{
	diag_log format ["Antistasi Error en vehicleprice: %!",_tipo];
	_costs = 0;
	}
else
	{
	_costs = round (_costs - (_costs * (0.1 * ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count seaports))));
	};

_costs