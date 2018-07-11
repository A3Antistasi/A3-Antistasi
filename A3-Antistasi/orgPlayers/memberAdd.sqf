if (player != theBoss) exitWith {hint "Only Player Commander has access to this function"};

if !(serverCommandAvailable "#logout") exitWith {hint "Only Server Admins can add a new member"};

if !(membershipEnabled) exitWith {hint "Server Member feature is disabled"};

if (isNil "miembros") exitWith {hint "Membership feature not yet initialised. Please try again later"};

_target = cursortarget;

if (!isPlayer _target) exitWith {hint "You are not pointing to anyone"};
_uid = getPlayerUID _target;
if ((_this select 0 == "add") and ([_target] call isMember)) exitWith {hint "The player is already a member of this server"};
if ((_this select 0 == "remove") and  !([_target] call isMember)) exitWith {hint "The player is not a member of this server"};

if (_this select 0 == "add") then
	{
	miembros pushBackUnique _uid;
	hint format ["%1 has been added to the Server Members List",name _target];
	}
else
	{
	miembros = miembros - [_uid];
	hint format ["%1 has been removed from the Server Members List",name _target];
	};
publicVariable "miembros";