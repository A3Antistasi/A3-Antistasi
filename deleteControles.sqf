private ["_marcador","_control","_cercano","_pos"];

_marcador = _this select 0;
_control = _this select 1;

_pos = getMarkerPos _control;

_cercano = [marcadores,_pos] call BIS_fnc_nearestPosition;

if (_cercano == _marcador) then
	{
	waitUntil {sleep 1;(spawner getVariable _control == 2)};
	if (_marcador in mrkSDK) then
		{
		if (_control in mrkNATO) then {mrkNATO = mrkNATO - [_control]; publicVariable "mrkNATO"} else {mrkCSAT = mrkCSAT - [_control]; publicVariable "mrkCSAT";};
		mrkSDK = mrkSDK pushBackUnique _control;
		publicVariable "mrkSDK";
		}
	else
		{
		if (_marcador in mrkNATO) then
			{
			if (_control in mrkSDK) then {mrkSDK = mrkSDK - [_control]; publicVariable "mrkSDK"} else {mrkCSAT = mrkCSAT - [_control]; publicVariable "mrkCSAT";};
			mrkNATO = mrkNATO pushBackUnique _control;
			publicVariable "mrkNATO";
			}
		else
			{
			if (_control in mrkSDK) then {mrkSDK = mrkSDK - [_control]; publicVariable "mrkSDK"} else {mrkNATO = mrkNATO - [_control]; publicVariable "mrkNATO"};
			mrkCSAT = mrkCSAT pushBackUnique _control;
			publicVariable "mrkCSAT";
			};
		};
	};