if (player != Stavros) exitWith {hint "Only Commander has the ability to control HC units"};

_grupos = _this select 0;

_grupo = _grupos select 0;
_unit = leader _grupo;

if !([_unit] call canFight) exitWith {hint "You cannot control an unconscious or dead unit"};
//if (!alive _unit) exitWith {hint "You cannot control a dead unit"};
//if ((not(typeOf _unit in soldadosSDK)) and (typeOf _unit != SDKUnarmed)) exitWith {hint "You cannot control a unit which does not belong to Syndikat"};

while {(count (waypoints _grupo)) > 0} do
 {
  deleteWaypoint ((waypoints _grupo) select 0);
 };

_wp = _grupo addwaypoint [getpos _unit,0];

{
if (_x != vehicle _x) then
	{
	[_x] orderGetIn true;
	};
} forEach units group player;

hcShowBar false;
hcShowBar true;

_unit setVariable ["owner",player,true];
selectPlayer _unit;

_tiempo = 60;

_unit addAction ["Return Control to AI",{selectPlayer (player getVariable ["owner",player])}];

waitUntil {sleep 1; hint format ["Time to return control to AI: %1", _tiempo]; _tiempo = _tiempo - 1; (_tiempo < 0) or (isPlayer Stavros)};

removeAllActions _unit;
if (!isPlayer (_unit getVariable ["owner",_unit])) then {selectPlayer (_unit getVariable ["owner",_unit])};
//_unit setVariable ["owner",nil,true];

{[_x] joinsilent group stavros} forEach units group stavros;
group stavros selectLeader Stavros;
hint "";

