private ["_unit","_distancia","_hayMedico","_medico","_units","_ayudando","_pidiendoAyuda"];
_unit = _this select 0;
_ayudado = _unit getVariable ["ayudado",objNull];
if (!isNull _ayudado) exitWith {};

_enemy = _unit findNearestEnemy _unit;
_distancia = 81;
_medico = objNull;
_units = units group _unit;
if ((([objNull, "VIEW"] checkVisibility [eyePos _enemy, eyePos _unit]) > 0) or (_unit distance _enemy < 100) and (!isPlayer _unit)) then
	{
	{
	if (!isPlayer _x) then
		{
		if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (lifestate _x == "INCAPACITATED")) and (vehicle _x == _x) and (_x distance _unit < _distancia)) then
			{
			_medico == _unit;
			};
		};
	} forEach _units;
	//hint format ["No curo: intento %1",distanciaSPWN]; distanciaSPWN = distanciaSPWN + 1;
	}
else
	{
	//if (count _this == 1) then {_units = units group _unit} else {_units = units (_this select 1)};
	{
	if (!isPlayer _x) then
		{
		if ((getNumber (configfile >> "CfgVehicles" >> (typeOf _x) >> "attendant") == 2) or (_x getUnitTrait "Medic")) then
			{
			if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (lifestate _x == "INCAPACITATED")) and (vehicle _x == _x) and (_x distance _unit < 81)) then
				{
				_ayudando = _x getVariable "ayudando";
				if ((isNil "_ayudando") and (!(_x getVariable ["rearming",false]))) then
					{
					_medico = _x;
					_distancia = _x distance _unit;
					};
				};
			};
		};
	} forEach _units;

	if (((isNull _medico) or (lifestate _unit == "INCAPACITATED")) and (!(_unit getVariable ["fatalWound",false]))) then
		{
		{
		if (!isPlayer _x) then
			{
			if ((getNumber (configfile >> "CfgVehicles" >> (typeOf _x) >> "attendant") != 2) and !(_x getUnitTrait "Medic")) then
				{
				if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (lifestate _x == "INCAPACITATED")) and (vehicle _x == _x) and (_x distance _unit < _distancia)) then
					{
					_ayudando = _x getVariable "ayudando";
					if ((isNil "_ayudando") and (!(_x getVariable ["rearming",false]))) then
						{
						_medico = _x;
						_distancia = _x distance _unit;
						};
					};
				};
			};
		} forEach _units;
		};
	if (!isNull _medico) then
		{
		if (isNull(_unit getVariable ["ayudado",objNull])) then {[_unit,_medico] spawn ayudar};
		}
	else
		{
		_distancia = 81;
		{
		if (!isPlayer _x) then
			{
			if ((alive _x) and ("FirstAidKit" in (items _x)) and (not (lifestate _x == "INCAPACITATED")) and (vehicle _x == _x) and (_x distance _unit < _distancia)) then
				{
				_medico == _unit;
				};
			};
		} forEach _units;
		};
	//hint format ["Si curo: intento %1.Eny: %2",distanciaSPWN,_enemy]; distanciaSPWN = distanciaSPWN + 1;
	};
_medico