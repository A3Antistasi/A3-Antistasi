if !(membershipEnabled) exitWith {hint "Server Member feature is disabled"};
private ["_cuenta"];
_texto = "In Game Members\n\n";
_countN = 0;

{
_playerX = _x getVariable ["owner",objNull];
if (!isNull _playerX) then
	{
	//_uid = getPlayerUID _playerX;
	if ([_playerX] call A3A_fnc_isMember) then {_texto = format ["%1%2\n",_texto,name _playerX]} else {_countN = _countN + 1};
	};
} forEach playableUnits;

_texto = format ["%1\nNo members:\n%2",_texto,_countN];

hint format ["%1",_texto];