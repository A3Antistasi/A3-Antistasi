if !(isServer) exitWith {};
if (isNil "miembros") then {miembros = []};
{
	miembros pushBackUnique _x;
} forEach [
	"76561198036417817", // Barbolani
];
publicVariable "miembros";
