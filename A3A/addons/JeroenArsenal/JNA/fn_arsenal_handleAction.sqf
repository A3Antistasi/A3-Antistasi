/**
	Handler for when the 'Arsenal' action is taken.
	
	Usage:
		_thing addAction ["Action", JN_fnc_arsenal_handleAction];
	
	Params:
		Same as any 'addAction' handler
**/

if (!arsenalInit) exitWith {};
//start loading screen
["jn_fnc_arsenal", "Loading Nutz™ Arsenal"] call bis_fnc_startloadingscreen;
[] spawn {
uisleep 10;
private _ids = missionnamespace getvariable ["BIS_fnc_startLoadingScreen_ids",[]];
  if("jn_fnc_arsenal" in _ids)then{
	private _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
	titleText["ERROR DURING LOADING ARSENAL", "PLAIN"];
	_display closedisplay 2;
	["jn_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
  };

  //TODO this is a temp fix for rhs because it freezes the loading screen if no primaryWeapon was equiped. This will be fix in rhs 0.4.9
if("bis_fnc_arsenal" in _ids)then{
	private _display =  uiNamespace getVariable ["arsanalDisplay","No display"];
	titleText["Non Fatal Error, RHS?", "PLAIN"];
	diag_log "JNA: Non Fatal Error, RHS?";
	["bis_fnc_arsenal"] call BIS_fnc_endLoadingScreen;
};
};

//save proper ammo because BIS arsenal rearms it, and I will over write it back again
missionNamespace setVariable ["jna_magazines_init",  [
	magazinesAmmoCargo (uniformContainer player),
	magazinesAmmoCargo (vestContainer player),
	magazinesAmmoCargo (backpackContainer player)
]];

//Save attachments in containers, because BIS arsenal removes them
_attachmentsContainers = [[],[],[]];
{
	_container = _x;
	_weaponAtt = weaponsItemsCargo _x;
	_attachments = [];

	if!(isNil "_weaponAtt")then{

		{
			_atts = [_x select 1,_x select 2,_x select 3,_x select 5];
			_atts = _atts - [""];
			_attachments = _attachments + _atts;
		} forEach _weaponAtt;
		_attachmentsContainers set [_foreachindex,_attachments];
	}
} forEach [uniformContainer player,vestContainer player,backpackContainer player];
missionNamespace setVariable ["jna_containerCargo_init", _attachmentsContainers];

//set type
UINamespace setVariable ["jn_type","arsenal"];

//request server to open arsenal
[clientOwner] remoteExecCall ["jn_fnc_arsenal_requestOpen",2];