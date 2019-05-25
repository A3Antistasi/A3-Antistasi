_muerto = _this select 0;
sleep cleantime;
deleteVehicle _muerto;
_group = group _muerto;
if (!isNull _group) then
	{
	if ({alive _x} count units _group == 0) then {deleteGroup _group};
	}
else
	{
	if (_muerto in staticsToSave) then {staticsToSave = staticsToSave - [_muerto]; publicVariable "staticsToSave";};
	};
