params [["_location", []]];

_oldPetros = if (isNil "petros") then {objNull}	else {petros};

groupPetros = createGroup teamPlayer;
publicVariable "groupPetros";

private _position = if (count _location > 0) then {
	_location
} else {
	if (getPos _oldPetros isEqualTo [0,0,0]) then {
		getMarkerPos respawnTeamPlayer
	} else {
		getPos _oldPetros
	};
};

petros = groupPetros createUnit [typePetros, _position, [], 10, "NONE"];
publicVariable "petros";

groupPetros setGroupIdGlobal ["Petros","GroupColor4"];
petros setIdentity "friendlyX";

if (worldName == "Tanoa") then {petros setName "Maru"} else {petros setName "Petros"};

petros disableAI "MOVE";
petros disableAI "AUTOTARGET";

if (group _oldPetros == groupPetros) then {
	[Petros,"mission"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],petros]
} else {
	[Petros,"buildHQ"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],petros]
};

[] execVM "initPetros.sqf";

deleteVehicle _oldPetros;