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
	_texto = format ["<t size='0.55'>" + "HR: %1 | %9 Money: %2 € | Airstrikes: %5 | %7 Aggr: %3 | %8 Aggr: %4 | War Level: %6 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA",floor prestigeNATO,floor prestigeCSAT,floor bombRuns,tierWar,nameMalos,nameMuyMalos,nameBuenos];
	}
else
	{
	if (player != stavros) then
		{
		if (isPlayer stavros) then {_nombreC = name stavros} else {_nombreC = "None"};
		_texto = format ["<t size='0.55'>" + "Commander: %3 | Rank: %2 | HR: %1 | Your Money: %4 € | %8 Aggr: %5 | %9 Aggr: %6 | War Level: %7 | Undercover Mode:", server getVariable "hr", rank player, _nombreC, player getVariable "dinero",floor prestigeNATO, floor prestigeCSAT,tierWar,nameMalos,nameMuyMalos];
		}
	else
		{
		_texto = format ["<t size='0.55'>" + "Rank: %5 | HR: %1 | Your Money: %6 € | %11 Money: %2 € | Airstrikes: %7 | %9 Aggr: %3 | %10 Aggr: %4 | War Level: %8 | Undercover Mode:", server getVariable "hr", server getVariable "resourcesFIA", floor prestigeNATO, floor prestigeCSAT,rank player, player getVariable "dinero",floor bombRuns,tierWar,nameMalos,nameMuyMalos,nameBuenos];
		};
	};

if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
_setText ctrlCommit 0;