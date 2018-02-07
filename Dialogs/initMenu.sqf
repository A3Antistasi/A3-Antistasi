_nul = createDialog "init_menu";

waitUntil {dialog};
waitUntil {!dialog};

if (isNil"switchCom") then
	{
	switchCom = false;
	publicVariable "switchCom";
	hint "Switch Commander Disabled\n\nGame will only assign Commander position upon Commander disconnection";
	_nul = [] execVM "Dialogs\membersMenu.sqf";
	};