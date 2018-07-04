private ["_marcador","_ciudad","_pos","_power","_datos","_powered","_numCiv","_numVeh","_roads","_prestigeOPFOR","_prestigeBLUFOR","_sitio"];

_marcador = _this select 0;

{
_ciudad = _x;
_pos = getMarkerPos _x;
_power = [power,_pos] call BIS_fnc_nearestPosition;
_powered = true;
if (_power == _marcador) then
	{
	//_datos = server getVariable _ciudad;
	if (_marcador in destroyedCities) then
		{
		_powered = false;
		//[-10,-10,_pos] remoteExec ["citySupportChange",2];
		}
	else
		{
		//_powered = _datos select 4;
		if (lados getVariable [_marcador,sideUnknown] == buenos) then
			{
			if (lados getVariable [_ciudad,sideUnknown] == buenos) then
				{
				//hint format ["You brought more power to %1, more people there will support our cause",_ciudad];
				//[-10,10,_pos] remoteExec ["citySupportChange",2];
				_nul = [5,0] remoteExec ["prestige",2];
				}
			else
				{
				//hint format ["You cut off power to %1, less people there will support NATO",_ciudad];
				//[-10,0,_pos] remoteExec ["citySupportChange",2];
				_nul = [-5,0] remoteExec ["prestige",2];
				_powered = false;
				};
			}
		else
			{
			if (lados getVariable [_ciudad,sideUnknown] == buenos) then
				{
				//hint format ["NATO has cut off power to %1, less people there support our cause",_ciudad];
				//[0,-10,_pos] remoteExec ["citySupportChange",2];
				_nul = [5,0] remoteExec ["prestige",2];
				_powered = false;
				};
			};
		};
	[_ciudad,_powered] spawn apagon;
	};
} forEach ciudades;

_marcadores = fabricas + recursos;
{
_sitio = _x;
_pos = getMarkerPos _x;
_power = [power,_pos] call BIS_fnc_nearestPosition;
_powered = true;
if (_power == _marcador) then
	{
	if (_marcador in destroyedCities) then
		{
		_powered = false;
		//[-10,-10,_pos] remoteExec ["citySupportChange",2];
		}
	else
		{
		if (lados getVariable [_marcador,sideUnknown] == buenos) then
			{
			if (lados getVariable [_sitio,sideUnknown] == malos) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["You cut off power to NATO resources near %1. They will be less productive from now",_ciudad];
				_powered = false;
				};
			}
		else
			{
			if (lados getVariable [_sitio,sideUnknown] == buenos) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["NATO cut off power supply to our resources near %1. They will be less productive from now",_ciudad];
				_powered = false;
				};
			};
		};
	[_sitio,_powered] spawn apagon;
	};
} forEach _marcadores;
