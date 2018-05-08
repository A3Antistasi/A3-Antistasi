private ["_unit","_jugador"];

_unit = _this select 0;
_jugador = _this select 1;

[_unit,"remove"] remoteExec ["flagaction",[buenos,civilian],_unit];
//removeAllActions _unit;

_jugador globalChat "You are free. Come with us!";
if (captive _jugador) then
	{
	[_jugador,false] remoteExec ["setCaptive"];
	};
sleep 3;
_unit globalChat "Thank you. I owe you my life!";
_unit enableAI "MOVE";
_unit enableAI "AUTOTARGET";
_unit enableAI "TARGET";
_unit enableAI "ANIM";
[_unit] join group _jugador;
[_unit] spawn FIAInit;
if (captive _unit) then {[_unit,false] remoteExec ["setCaptive"]};