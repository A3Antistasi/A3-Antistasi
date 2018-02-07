private ["_unit","_grupos","_oldUnit","_oldProviders","_HQ","_providerModule","_used"];
_unit = _this select 0;
_grupos = hcAllGroups stavros;
_oldUnit = stavros;

if (!isNil "_grupos") then
  {
  {
  _oldUnit hcRemoveGroup _x;
  } forEach _grupos;
  };
_oldUnit synchronizeObjectsRemove [HC_comandante];
//apoyo synchronizeObjectsRemove [_oldUnit];
HC_comandante synchronizeObjectsRemove [_oldUnit];
stavros = _unit;
publicVariable "stavros";
[group _unit, _unit] remoteExec ["selectLeader",_unit];
stavros synchronizeObjectsAdd [HC_comandante];
HC_comandante synchronizeObjectsAdd [stavros];
//apoyo synchronizeObjectsAdd [stavros];
if (!isNil "_grupos") then
	{
  	{_unit hcSetGroup [_x]} forEach _grupos;
  	}
else
	{
	{
	if (_x getVariable ["esNATO",false]) then
		{
		_unit hcSetGroup [_x];
		};
	if ((leader _x getVariable ["GREENFORSpawn",false]) and (!isPlayer leader _x)) then
		{
		_unit hcSetGroup [_x];
		};
	} forEach allGroups;
	};

if (isNull _oldUnit) then
	{
	[_oldUnit,[group _oldUnit]] remoteExec ["hcSetGroup",_oldUnit];
	};
