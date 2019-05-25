private ["_display","_childControl","_veh","_texto","_costs","_typeVehX"];
_nul = createDialog "HQ_menu";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 109;
	_ChildControl  ctrlSetTooltip format ["Current level: %2. Next Level Training Cost: %1 €",1000 + (1.5*((skillFIA) *750)),skillFIA];
/*
	_ChildControl = _display displayCtrl 110;
	{
	_subVeh = _x;
	if ((_subVeh distance flagX < 10) and (_subVeh!=caja) and (_subVeh!=mapa) and (_subVeh!=vehicleBox)) then {_veh = _subVeh}
	} forEach vehicles;

	if (isNil "_veh") then
		{
		_texto = "No vehicles to sell"
		}
	else
		{
		_typeVehX = typeOf _veh;
		_costs = 0;

		if (_typeVehX in vehFIA) then {_costs = round (([_typeVehX] call A3A_fnc_vehiclePrice)/2); _texto = "Fia Vehicle."};

		if (_typeVehX in arrayCivVeh) then
			{
			if (_typeVehX == "C_Van_01_fuel_F") then {_costs = 50} else {_costs = 25};
			_texto = "Civ Vehicle."
			};
		if (_typeVehX in vehAAFAT) then
			{
			if ((_typeVehX == "I_APC_tracked_03_cannon_F") or (_typeVehX == "I_APC_Wheeled_03_cannon_F")) then
				{
				_costs = 1000;
				}
			else
				{
				_costs = 5000;
				};
			_texto = "AAF Tank";
			};
		if (_typeVehX in vehAAFnormal) then {_costs = 300; _texto = "AAF Normal Vehicle."};
		if (_costs == 0) then
			{
			_texto = "The closest vehicle is not suitable in our marketplace"
			}
		else
			{
			_costs = round (_costs * (1-damage _veh));
			_texto = format ["%2 Price: %1 €",_costs,_texto];
			};
		};

	_ChildControl  ctrlSetTooltip format ["%1",_texto];
    //You need this to cue animation -- will smoothly animate to new position.  Could use zero here
	//_ChildControl ctrlCommit 1;
*/
};
