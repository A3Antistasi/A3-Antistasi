_nul=createDialog "should_load_personal_save";

waitUntil {dialog};
hint "W A R N I N G\n\nREAD THIS!!!\n\n\nAntistasi does NOT support vanilla save. Do not expect 100% of functionalities if you Save&Exit and after you come back with Resume option. Both on SP and MP.\n\n\nAntistasi has an in built save system, GTA alike, which is the system you have to use in order to have full functionalities.\n\nTo Save: Go to the Map Board, select ""Game Options"" and hit on ""Persistent Save"" button.\n\nTo load: RESTART the game and click YES on this window";
waitUntil {!dialog};

[] spawn A3A_fnc_credits;
diag_log "[Antistasi] Saving is now possible.";
player setVariable ['canSave', true, true];