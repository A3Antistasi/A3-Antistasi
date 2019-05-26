private ["_display","_childControl","_coste","_costeHR","_unidades","_formato"];
if (!([player] call A3A_fnc_hasRadio)) exitWith {if !(hayIFA) then {hint "You need a radio in your inventory to be able to give orders to other squads"} else {hint "You need a Radio Man in your group to be able to give orders to other squads"}};
_nul = createDialog "squad_recruit";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 104;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (groupsSDKSquad select 0));
	//_unidades = [_formato] call groupComposition;
	//{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach groupsSDKSquad;
	//_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 105;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (groupsSDKmid select 0));
	//_unidades = [_formato] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach groupsSDKmid;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 106;
	_coste = 0;
	_costeHR = 0;
	//_formato = (cfgSDKInf >> (groupsSDKAT select 0));
	//_unidades = [_formato] call groupComposition;
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach groupsSDKAT;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 107;
	_coste = 0;
	_costeHR = 0;
	//_unidades = [SDKSL,SDKSL];
	{_coste = _coste + (server getVariable (_x select 0)); _costeHR = _costeHR +1} forEach groupsSDKSniper;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 108;
	_coste = (2*(server getVariable staticCrewTeamPlayer));
	_costeHR = 2;
	//_unidades = [SDKGL,SDKRifleman];
	_coste = _coste + ([SDKMGStatic] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];


	_ChildControl = _display displayCtrl 109;
	_coste = (2*(server getVariable staticCrewTeamPlayer));
	_costeHR = 2;
	_coste = _coste + ([vehSDKAT] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 110;
	_coste = (2*(server getVariable staticCrewTeamPlayer));
	_costeHR = 2;
	_coste = _coste + ([vehSDKTruck] call A3A_fnc_vehiclePrice) + ([staticAABuenos] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 111;
	_coste = (2*(server getVariable staticCrewTeamPlayer));
	_costeHR = 2;
	_coste = _coste + ([SDKMortar] call A3A_fnc_vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];
};