_contacto = _this select 0;
_llamador = _this select 1;

_salir = false;
_underCover = true;
{
if ((_x getVariable ["GREENFORSpawn",true]) and (_x distance _contacto < 50) and (!captive _x)) exitWith {_underCover = false}
} forEach allUnits;

if (!_underCover) then
	{
	{
	if ((side _x != civilian) and (side _x != buenos) and (_x distance _contacto < 150)) exitWith {_salir = false};
	} forEach allUnits;
	};

if (_salir) exitWith {_contacto globalChat "It is not safe to talk now"; hint "All players near need to be in Undercover or there must be no enemies around to be able to speak with your contact"};

_contacto setVariable ["statusAct",true,true];
[_contacto,"remove"] remoteExec ["flagaction",[buenos,civilian],_contacto];

if (random 100 < 10) then
	{
	_bases = aeropuertos select {(not(lados getVariable [_x,sideUnknown] == buenos)) and (getMarkerPos _x distance _contacto < 15000)};
	if (count _bases >0) then
		{
		_base = [_bases,_contacto] call BIS_fnc_NearestPosition;
		_lado = if (lados getVariable [_base,sideUnknown] == malos) then {malos} else {muyMalos};
		[[getPosASL _contacto,_lado,"",false],"patrolCA"] remoteExec ["scheduler",2];
		};
	sleep cleantime;
	if (captive _llamador) then {[_llamador,false] remoteExec ["setCaptive",0,_llamador]; _llamador setCaptive false};
	};