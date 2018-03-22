if (player != Stavros) exitWith {hint "Only Commander Stavros has access to this function"};

if (skillFIA > 19) exitWith {hint "Your troops have the maximum training"};
if ((skillFIA + 1) > (tierWar*2)) exitWith {hint "You cannot upgrade training in the current War Level"};
_resourcesFIA = server getVariable "resourcesFIA";
_coste = 1000 + (1.5*(skillFIA *750));
if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money to afford additional training. %1 € needed",_coste]};

_resourcesFIA = _resourcesFIA - _coste;
skillFIA = skillFIA + 1;
hint format ["Syndikat Skill Level has been Upgraded\nCurrent level is %1",skillFIA];
publicVariable "skillFIA";
server setVariable ["resourcesFIA",_resourcesFIA,true];
[] call statistics;
{
_coste = server getVariable _x;
_coste = round (_coste + (_coste * (skillFIA/280)));
server setVariable [_x,_coste,true];
} forEach soldadosSDK;
