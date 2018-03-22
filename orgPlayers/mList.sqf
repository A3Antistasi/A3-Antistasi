//Credits to Author IrLED
//#define DEBUG_SYNCHRONOUS
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
if !(isServer) exitWith {};
LOG("Loading external members list");
//This is the path to external storage folder(folder has to be created in the root of arma3 folder).
externalConfigFolder = "\A3Antistasi";
private _mList = [];

LOG_1("isFilePatchingEnabled: %1", isFilePatchingEnabled);
if(isFilePatchingEnabled) then {
    private _memberList = loadFile (externalConfigFolder + "\memberlist.txt");
    if ( _memberList != "" ) then
	{
	    //Members list is in form of CRLF separated playerIds
	    _mList = _memberList splitString toString [13,10];
	    LOG_1("External content from %1",externalConfigFolder + "\memberlist.txt");
	};
};

{
    //comma (,) and whitespace are the delimeters, only the first element is considered the ID
    private _memberID = (_x splitString ", ") select 0;
    LOG_1("add memberID: %1", _memberID);
    miembros pushBackUnique _memberID;
} forEach _mList;
publicVariable "miembros";
