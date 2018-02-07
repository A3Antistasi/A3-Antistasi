private ["_tipo","_posicionTel","_cercano","_garrison","_coste","_hr","_size"];
_tipo = _this select 0;

if (_tipo == "add") then {hint "Select a zone to add garrisoned troops"} else {hint "Select a zone to remove it's Garrison"};

openMap true;
posicionTel = [];

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;
posicionGarr = "";

_cercano = [marcadores,_posicionTel] call BIS_fnc_nearestPosition;
_posicion = getMarkerPos _cercano;

if (getMarkerPos _cercano distance _posicionTel > 40) exitWith {hint "You must click near a marked zone"; _nul=CreateDialog "garrison_menu";};

if (not(_cercano in mrkSDK)) exitWith {hint "That zone does not belong to Syndikat"; _nul=CreateDialog "garrison_menu";};

if ((_cercano in puestosFIA) /*or (_cercano in ciudades)*/ or (_cercano in controles)) exitWith {hint "You cannot manage garrisons on this kind of zone"; _nul=CreateDialog "garrison_menu"};

_garrison = garrison getVariable [_cercano,[]];

if (_tipo == "rem") then
	{
	if (count _garrison == 0) exitWith {hint "The place has no garrisoned troops to remove"; _nul=CreateDialog "garrison_menu";};
	_coste = 0;
	_hr = 0;
	if (spawner getVariable _cercano != 2) then
		{
		if ({(alive _x) and (!captive _x) and ((side _x == malos) or (side _x == muyMalos)) and (_x distance _posicion < 500)} count allUnits > 0) then
			{
			hint "You cannot remove garrisons while there are enemies nearby";
			_nul=CreateDialog "garrison_menu"
			}
		else
			{
			{
			if (side _x == buenos) then
				{
				if (_x getVariable ["marcador",""] == _cercano) then
					{
					if (alive _x) then
						{
						if (typeOf _x == staticCrewBuenos) then {_coste = _coste + ([SDKMortar] call vehiclePrice)};
						_hr = _hr + 1;
						_coste = _coste + (server getVariable (typeOf _x));
						if (typeOf (vehicle _x) == SDKMortar) then {deleteVehicle vehicle _x};
						deleteVehicle _x;
						};
					};
				};
			} forEach allUnits;
			};
		}
	else
		{
		{
		if (_x == staticCrewBuenos) then {_coste = _coste + ([SDKMortar] call vehiclePrice)};
		_hr = _hr + 1;
		_coste = _coste + (server getVariable _x);
		} forEach _garrison;
		};
	[_hr,_coste] remoteExec ["resourcesFIA",2];
	garrison setVariable [_cercano,[],true];
	[_cercano] call mrkUpdate;
	hint format ["Garrison removed\n\nRecovered Money: %1 €\nRecovered HR: %2",_coste,_hr];
	_nul=CreateDialog "garrison_menu";
	}
else
	{
	if (spawner getVariable _cercano != 2) then
		{
		if ({(alive _x) and (!captive _x) and ((side _x == malos) or (side _x == muyMalos)) and (_x distance _posicion < 500)} count allUnits > 0) exitWith {hint "You cannot add soldiers to this garrison while there are enemies nearby"; _nul=CreateDialog "garrison_menu"};
		};
	posicionGarr = _cercano;
	publicVariable "posicionGarr";
	hint format ["Info%1",[_cercano] call garrisonInfo];
	closeDialog 0;
	_nul=CreateDialog "garrison_recruit";
	sleep 1;
	disableSerialization;

	_display = findDisplay 100;

	if (str (_display) != "no display") then
		{
		_ChildControl = _display displayCtrl 104;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMil select 0)];
		_ChildControl = _display displayCtrl 105;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMG select 0)];
		_ChildControl = _display displayCtrl 126;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKMedic select 0)];
		_ChildControl = _display displayCtrl 107;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKSL select 0)];
		_ChildControl = _display displayCtrl 108;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",(server getVariable staticCrewBuenos) + ([SDKMortar] call vehiclePrice)];
		_ChildControl = _display displayCtrl 109;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKGL select 0)];
		_ChildControl = _display displayCtrl 110;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKSniper select 0)];
		_ChildControl = _display displayCtrl 111;
		_ChildControl  ctrlSetTooltip format ["Cost: %1 €",server getVariable (SDKATman select 0)];
		};
	};