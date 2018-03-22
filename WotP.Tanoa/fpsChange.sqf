if (!isServer) exitWith {};

_cambio = _this select 0;

_cambio = _cambio + minimoFPS;

if (_cambio < 0) then {_cambio = 0};

_media = fpsAV;
_texto = "";

if ((_cambio > _media * 0.6) and (_media > 24)) then
	{
	_cambio = round (_media * 0.6);
	_texto = format ["FPS limit set to %2.\n\nAverage FPS on server is %1, a higher limit may stop enemies spawning.",_media, _cambio];
	minimoFPS = _cambio;
	}
else
	{
	minimoFPS = _cambio;
	_texto = format ["FPS limit set to %2.\n\nAverage FPS on server is %1.",_media, _cambio];
	};

[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
publicVariable "minimoFPS";