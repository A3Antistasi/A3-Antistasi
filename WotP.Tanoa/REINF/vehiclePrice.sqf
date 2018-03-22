private ["_tipo","_coste"];

_tipo = _this select 0;

_coste = server getVariable _tipo;

if (isNil "_coste") then
	{
	diag_log format ["Antistasi Error en vehicleprice: %!",_tipo];
	/*
	if (_tipo in vehAAFnormal) then
		{
		_coste = 300;
		}
	else
		{
		if (_tipoVeh in vehAAFAT) then
			{
			if ((_tipoVeh == "I_APC_tracked_03_cannon_F") or (_tipoVeh == "I_APC_Wheeled_03_cannon_F")) then {_coste = 1000} else {_coste = 5000};
			}
		else
			{
			if (_tipoVeh in arrayCivVeh) then
				{
				if (_tipoveh == "C_Van_01_fuel_F") then {_coste = 50} else {_coste = 25};
				}
			else
				{
				_coste = 0;
				diag_log format ["Antistasi: Error en vehicle prize con este: %1",_tipo];
				};
			};
		};
	*/
	_coste = 0;
	}
else
	{
	//_coste = _coste + (_coste * ({_x in mrkNATO} count puertos));
	_coste = round (_coste - (_coste * (0.1 * ({lados getVariable [_x,sideUnknown] == buenos} count puertos))));
	};

_coste