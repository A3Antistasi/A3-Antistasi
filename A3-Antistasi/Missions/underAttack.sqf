private ["_marcador","_nameDest","_nameENY"];
_marcador = _this select 0;
_nameDest = [_marcador] call A3A_fnc_localizar;
_sideEny = _this select 1;
_nameENY = if (_sideEny == teamPlayer) then
				{
				nameTeamPlayer
				}
			else
				{
				if (_sideEny == muyMalos) then {nameInvaders} else {nameOccupants};
				};
_lado = _this select 2;
if (_lado == teamPlayer) then {_lado = [teamPlayer,civilian]};

[_lado,_marcador,[format ["%2 is attacking us in %1. Help the defense if you can",_nameDest,_nameENY],format ["%1 Contact Rep",_nameENY],_marcador],getMarkerPos _marcador,false,0,true,"Defend",true] call BIS_fnc_taskCreate;

if (_lado isEqualType []) then {_lado = teamPlayer};

waitUntil {sleep 10; (lados getVariable [_marcador,sideUnknown] != _lado) or (spawner getVariable _marcador == 2)};

[0,_marcador] spawn A3A_fnc_deleteTask;
