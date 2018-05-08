if (!hasInterface) exitWith {};
private ["_texto","_display","_setText"];
//sleep 3;
disableSerialization;
//waitUntil {!isNull (uiNameSpace getVariable "H8erHUD")};
if (isNull (uiNameSpace getVariable "H8erHUD")) exitWith {};
_display = uiNameSpace getVariable "H8erHUD";
_setText = _display displayCtrl 1001;
_setText ctrlSetBackgroundColor [0,0,0,0];
_nombreC = "None";
if (!isMultiplayer) then
	{
	_texto = format ["<t size='0.55'>" + "HR: %1 | SDK Money: %2 € | Airstrikes: %5 | NATO Aggr: %3 | CSAT Aggr: %4 | War Level: %6 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA",floor prestigeNATO,floor prestigeCSAT,floor bombRuns,tierWar];
	}
else
	{
	if (player != stavros) then
		{
		if (isPlayer stavros) then {_nombreC = name stavros} else {_nombreC = "None"};
		_texto = format ["<t size='0.55'>" + "Commander: %3 | Rank: %2 | HR: %1 | Your Money: %4 € | NATO Aggr: %5 | CSAT Aggr: %6 | War Level: %7 | Undercover Mode:", server getVariable "hr", rank player, _nombreC, player getVariable "dinero",floor prestigeNATO, floor prestigeCSAT,tierWar];
		}
	else
		{
		_texto = format ["<t size='0.55'>" + "Rank: %5 | HR: %1 | Your Money: %6 € | SDK Money: %2 € | Airstrikes: %7 | NATO Aggr: %3 | CSAT Aggr: %4 | War Level: %8 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA", floor prestigeNATO, floor prestigeCSAT,rank player, player getVariable "dinero",floor bombRuns,tierWar];
		};
	};

if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
_setText ctrlCommit 0;

/*
_viejoTexto = "";

if (isMultiplayer) then
	{
	private ["_nombreC"];
	while {true} do
		{
		waitUntil {sleep 0.5; player == player getVariable ["owner",player]};
		if (player != stavros) then
			{
			if (isPlayer stavros) then {_nombreC = name stavros} else {_nombreC = "NONE"};
			_texto = format ["<t size='0.55'>" + "Commander: %3 | Rank: %2 | HR: %1 | Your Money: %4 € | NATO Aggr: %5 | CSAT Aggr: %6 | War Level: %7 | Undercover Mode:", server getVariable "hr", rank player, _nombreC, player getVariable "dinero",floor prestigeNATO, floor prestigeCSAT,tierWar];
			}
		else
			{
			_texto = format ["<t size='0.55'>" + "Rank: %5 | HR: %1 | Your Money: %6 € | SDK Money: %2 € | Airstrikes: %7 | NATO Aggr: %3 | CSAT Aggr: %4 | War Level: %8 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA", floor prestigeNATO, floor prestigeCSAT,rank player, player getVariable "dinero",floor bombRuns,tierWar];
			};
		if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
		if (_texto != _viejoTexto) then
			{
			//[_texto,-0.1,-0.4,601,0,0,5] spawn bis_fnc_dynamicText;
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_viejoTexto = _texto;
			};
		if (player == leader (group player)) then
			{
			if (not(group player in (hcAllGroups player))) then {player hcSetGroup [group player]};
			};
		sleep 0.5;
		};
	}
else
	{
	while {true} do
		{
		waitUntil {sleep 0.5; player == player getVariable ["owner",player]};
		_texto = format ["<t size='0.55'>" + "HR: %1 | SDK Money: %2 € | Airstrikes: %5 | NATO Aggr: %3 | CSAT Aggr: %4 | War Level: %6 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA",floor prestigeNATO,floor prestigeCSAT,floor bombRuns,tierWar];
		if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
		if (_texto != _viejoTexto) then
			{
			//[_texto,-0.1,-0.4,601,0,0,5] spawn bis_fnc_dynamicText;
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_viejoTexto = _texto;
			};
		sleep 0.5;
		};
	};
