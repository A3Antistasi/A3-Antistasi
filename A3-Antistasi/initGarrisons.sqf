

_mrkNATO = [];
_mrkCSAT = [];
_controlsNATO = [];
_controlsCSAT = [];

if (gameMode == 1) then
	{
    _controlsNATO = controlsX;
	if (worldName == "Tanoa") then
	    {
	    _mrkCSAT = ["airport_1","puerto_5","puesto_10","control_20"];
	    _controlsNATO = _controlsNATO - ["control_20"];
	    _controlsCSAT = ["control_20"];
	    }
	else
	    {
	    if (worldName == "Altis") then
	        {
	        _mrkCSAT = ["airport_2","puerto_4","puesto_5","control_52","control_33"];
	        _controlsNATO = _controlsNATO - ["control_52","control_33"];
	    	_controlsCSAT = ["control_52","control_33"];
	        }
        else
            {
            if (worldName == "chernarus_summer") then
                {
                _mrkCSAT = ["puesto_21"];
                };
            };
	    };
	_mrkNATO = markersX - _mrkCSAT - ["Synd_HQ"];
	}
else
	{
	if (gameMode == 4) then
		{
		_mrkCSAT = markersX - ["Synd_HQ"];
		_controlsCSAT = controlsX;
		}
	else
		{
		_mrkNATO = markersX - ["Synd_HQ"];
		_controlsNATO = controlsX;
		};
	};
{lados setVariable [_x,malos,true]} forEach _controlsNATO;
{lados setVariable [_x,muyMalos,true]} forEach _controlsCSAT;
{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_garrNum = [_x] call A3A_fnc_garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
killZones setVariable [_x,[],true];
if (_x in _mrkCSAT) then
    {
    _dmrk setMarkerType flagCSATmrk;
    _dmrk setMarkerText format ["%1 Airbase",nameInvaders];
    _dmrk setMarkerColor colorInvaders;
    for "_i" from 1 to _garrNum do
        {
        _garrison append (selectRandom groupsCSATSquad);
        };
    garrison setVariable [_x,_garrison,true];
    lados setVariable [_x,muyMalos,true];
    }
else
    {
    _dmrk setMarkerType flagNATOmrk;
    _dmrk setMarkerText format ["%1 Airbase",nameMalos];
    _dmrk setMarkerColor colorOccupants;
    for "_i" from 1 to _garrNum do
        {
        _garrison append (selectRandom groupsNATOSquad);
        };
    garrison setVariable [_x,_garrison,true];
    lados setVariable [_x,malos,true];
    };
_nul = [_x] call A3A_fnc_createControls;
server setVariable [_x,0,true];//fecha en fomrato dateToNumber en la que estarán idle
} forEach airportsX;

{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_garrNum = [_x] call A3A_fnc_garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
_dmrk setMarkerType "loc_rock";
_dmrk setMarkerText "Resources";
for "_i" from 1 to _garrNum do
   {
   _garrison append (selectRandom groupsFIASquad);
   };
if (_x in _mrkCSAT) then
	{
	_dmrk setMarkerColor colorInvaders;
	lados setVariable [_x,muyMalos,true];
	}
else
	{
	_dmrk setMarkerColor colorOccupants;
	lados setVariable [_x,malos,true];
	};
garrison setVariable [_x,_garrison,true];
_nul = [_x] call A3A_fnc_createControls;
} forEach recursos;

{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_garrNum = [_x] call A3A_fnc_garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
_dmrk setMarkerType "u_installation";
_dmrk setMarkerText "Factory";
for "_i" from 1 to _garrNum do
   {
   _garrison append (selectRandom groupsFIASquad);
   };
if (_x in _mrkCSAT) then
	{
	_dmrk setMarkerColor colorInvaders;
    lados setVariable [_x,muyMalos,true];
	}
else
	{
	_dmrk setMarkerColor colorOccupants;
    lados setVariable [_x,malos,true];
    };
garrison setVariable [_x,_garrison,true];
_nul = [_x] call A3A_fnc_createControls;
} forEach fabricas;

{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_garrNum = [_x] call A3A_fnc_garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
killZones setVariable [_x,[],true];
_dmrk setMarkerType "loc_bunker";
if !(_x in _mrkCSAT) then
    {
    _dmrk setMarkerColor colorOccupants;
    _dmrk setMarkerText format ["%1 Outpost",nameMalos];
    for "_i" from 1 to _garrNum do
        {
        _garrison append (selectRandom groupsFIASquad);
        };
    lados setVariable [_x,malos,true];
    }
else
    {
    _dmrk setMarkerText format ["%1 Outpost",nameInvaders];
    _dmrk setMarkerColor colorInvaders;
    if (gameMode == 4) then
    	{
    	for "_i" from 1 to _garrNum do
	       {
	       _garrison append (selectRandom groupsFIASquad);
	       };
    	}
    else
    	{
	    for "_i" from 1 to _garrNum do
	        {
	        _garrison append (selectRandom groupsCSATSquad);
	        };
	    };
    lados setVariable [_x,muyMalos,true];
    };
garrison setVariable [_x,_garrison,true];
server setVariable [_x,0,true];
_nul = [_x] call A3A_fnc_createControls;
} forEach puestos;

{
_pos = getMarkerPos _x;
_dmrk = createMarker [format ["Dum%1",_x], _pos];
_dmrk setMarkerShape "ICON";
_garrNum = [_x] call A3A_fnc_garrisonSize;
_garrNum = _garrNum / 8;
_garrison = [];
_dmrk setMarkerType "b_naval";
_dmrk setMarkerText "Sea Port";
if (_x in _mrkCSAT) then
    {
    _dmrk setMarkerColor colorInvaders;
	for "_i" from 1 to _garrNum do
	   {
	   _garrison append (selectRandom groupsCSATSquad);
	   };
    lados setVariable [_x,muyMalos,true];
    }
else
    {
    _dmrk setMarkerColor colorOccupants;
    for "_i" from 1 to _garrNum do
        {
        _garrison append (selectRandom groupsNATOSquad);
        };
    lados setVariable [_x,malos,true];
    };
garrison setVariable [_x,_garrison,true];
_nul = [_x] call A3A_fnc_createControls;
} forEach puertos;

lados setVariable ["NATO_carrier",malos,true];
lados setVariable ["CSAT_carrier",muyMalos,true];