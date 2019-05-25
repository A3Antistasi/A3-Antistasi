private ["_markerX","_mrkD"];

_markerX = _this select 0;

_mrkD = format ["Dum%1",_markerX];
if (lados getVariable [_markerX,sideUnknown] == buenos) then
	{
	_texto = if (count (garrison getVariable [_markerX,[]]) > 0) then {format [": %1", count (garrison getVariable [_markerX,[]])]} else {""};
	if (markerColor _mrkD != colourTeamPlayer) then {_mrkD setMarkerColor colourTeamPlayer};
	if (_markerX in airportsX) then
		{
		_texto = format ["%2 Airbase%1",_texto,nameTeamPlayer];
		[_mrkD,format ["%1 Airbase",nameTeamPlayer]] remoteExec ["setMarkerTextLocal",[malos,],true];
		//_mrkD setMarkerText format ["SDK Airbase%1",_texto];
		if (markerType _mrkD != "flag_Syndicat") then {_mrkD setMarkerType "flag_Syndicat"};
		}
	else
		{
		if (_markerX in puestos) then
			{
			_texto = format ["%2 Outpost%1",_texto,nameTeamPlayer];
			[_mrkD,format ["%1 Outpost",nameTeamPlayer]] remoteExec ["setMarkerTextLocal",[malos,],true];
			}
		else
			{
			 if (_markerX in resourcesX) then
			 	{
			 	_texto = format ["Resouces%1",_texto];
			 	}
			 else
			 	{
			 	if (_markerX in factories) then
            		{
            		_texto = format ["Factory%1",_texto];
            		}
            	else
            		{
            		if (_markerX in puertos) then {_texto = format ["Sea Port%1",_texto]};
            		};
			 	};
			};
		};
	[_mrkD,_texto] remoteExec ["setMarkerTextLocal",[buenos,civilian],true];
	}
else
	{
	if (lados getVariable [_markerX,sideUnknown] == malos) then
		{
		if (_markerX in airportsX) then
			{_mrkD setMarkerText format ["%1 Airbase",nameOccupants];
			_mrkD setMarkerType flagNATOmrk
			}
		else
			{
			if (_markerX in puestos) then
				{
				_mrkD setMarkerText format ["%1 Outpost",nameOccupants]
				};
			};
		_mrkD setMarkerColor colorOccupants;
		}
	else
		{
		if (_markerX in airportsX) then {_mrkD setMarkerText format ["%1 Airbase",nameInvaders];_mrkD setMarkerType flagCSATmrk} else {
		if (_markerX in puestos) then {_mrkD setMarkerText format ["%1 Outpost",nameInvaders]}};
		_mrkD setMarkerColor colorInvaders;
		};
	if (_markerX in resourcesX) then
	 	{
	 	if (markerText _mrkD != "Resources") then {_mrkD setMarkerText "Resouces"};
	 	}
	 else
	 	{
	 	if (_markerX in factories) then
    		{
    		if (markerText _mrkD != "Factory") then {_mrkD setMarkerText "Factory"};
    		}
    	else
    		{
    		if (_markerX in puertos) then
    			{
    			if (markerText _mrkD != "Sea Port") then {_mrkD setMarkerText "Sea Port"};
    			};
    		};
	 	};
	};

