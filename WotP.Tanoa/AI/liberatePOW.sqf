_unit = _this select 0;
_jugador = _this select 1;

[_unit,"remove"] remoteExec ["flagaction",[buenos,civilian],_unit];

//removeAllActions _unit;

if (captive _jugador) then
	{
	[_jugador,false] remoteExec ["setCaptive"];
	};

_jugador globalChat "You are free. Come with us!";
_unit setDir (getDir _jugador);
_jugador playMove "MountSide";
sleep 3;
_unit sideChat "Thank you. I owe you my life!";

_unit enableAI "MOVE";
_unit enableAI "AUTOTARGET";
_unit enableAI "TARGET";
_unit enableAI "ANIM";
sleep 5;
_jugador playMove "";
//_unit playMove "SitStandUp";
[_unit,false] remoteExec ["setCaptive"];
[_unit] join group _jugador;
[_unit] spawn FIAInit;
