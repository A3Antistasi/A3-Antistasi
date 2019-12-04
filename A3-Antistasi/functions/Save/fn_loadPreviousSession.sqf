if (!isMultiplayer) exitWith {
  loadLastSave = true;
};

if (hasInterface) then {
  [] spawn A3A_fnc_loadPlayer;
};


