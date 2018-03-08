private ["_marcador","_control","_cercano","_pos"];

_marcador = _this select 0;
_control = _this select 1;

_pos = getMarkerPos _control;

_cercano = [marcadores,_pos] call BIS_fnc_nearestPosition;

if (_cercano == _marcador) then
	{
	waitUntil {sleep 1;(spawner getVariable _control == 2)};
	if (lados getVariable [_marcador,sideUnknown] == buenos) then
		{
		if (lados getVariable [_control,sideUnknown] == malos) then {mrkNATO = mrkNATO - [_control]; publicVariable "mrkNATO"} else {mrkCSAT = mrkCSAT - [_control]; publicVariable "mrkCSAT";};
		mrkSDK = mrkSDK pushBackUnique _control;
		publicVariable "mrkSDK";
		lados setVariable [_control,buenos,true];
		}
	else
		{
		if (lados getVariable [_marcador,sideUnknown] == malos) then
			{
			if (lados getVariable [_control,sideUnknown] == buenos) then {mrkSDK = mrkSDK - [_control]; publicVariable "mrkSDK"} else {mrkCSAT = mrkCSAT - [_control]; publicVariable "mrkCSAT";};
			mrkNATO = mrkNATO pushBackUnique _control;
			publicVariable "mrkNATO";
			lados setVariable [_control,malos,true];
			}
		else
			{
			if (lados getVariable [_control,sideUnknown] == buenos) then {mrkSDK = mrkSDK - [_control]; publicVariable "mrkSDK"} else {mrkNATO = mrkNATO - [_control]; publicVariable "mrkNATO"};
			mrkCSAT = mrkCSAT pushBackUnique _control;
			publicVariable "mrkCSAT";
			lados setVariable [_control,muyMalos,true];
			};
		};
	};