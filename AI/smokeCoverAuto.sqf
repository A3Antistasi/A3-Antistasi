private ["_veh"];

_veh = _this select 0;

if !(alive _veh) exitWith {};

if ({"SmokeLauncher" in (_veh weaponsTurret _x)} count (allTurrets _veh) > 0) then
	{
	_veh fire "SmokeLauncher";
	}
else
	{
	private ["_pos","_humo"];
	_tipoHumo = selectRandom humo;
	for "_i" from 0 to 8 do
		{
		_pos = position _veh getPos [30,_i*40];
		_humo = _tipoHumo createVehicle [_pos select 0, _pos select 1,getPos _veh select 2];
		};
	};