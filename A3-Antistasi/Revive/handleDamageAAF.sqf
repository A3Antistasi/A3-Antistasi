private ["_unit","_part","_dam","_injurer"];
_dam = _this select 2;
_injurer = _this select 3;
if (side _injurer == buenos) then
	{
	_unit = _this select 0;
	_part = _this select 1;
	if (_part == "") then
		{
		if (_dam >= 1) then
			{
			if (!(lifestate _unit == "INCAPACITATED")) then
				{
				_unit setUnconscious true;
				_dam = 0.9;
				[_unit,_injurer] spawn inconscienteAAF;
				}
			else
				{
				_overall = (_unit getVariable ["overallDamage",0]) + (_dam - 1);
				if (_overall > 0.5) then
					{
					_unit removeAllEventHandlers "HandleDamage";
					}
				else
					{
					_unit setVariable ["overallDamage",_overall];
					_dam = 0.9;
					};
				};
			}
		else
			{
			if (_dam > 0.6) then {[_unit,_unit] spawn cubrirConHumo};
			};
		}
	else
		{
		if (_dam > 0.95) then
			{
			_dam = 0.9;
			if (_part == "head") then
				{
				if (getNumber (configfile >> "CfgWeapons" >> headgear _unit >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") > 0) then
					{
					removeHeadgear _unit;
					}
				else
					{
					_unit setVariable ["fatalWound",true,true];
					};
				};
			};
		};
	};
//stavros sidechat format ["Final Daño_ %1. Parte %2",_dam,_part];
_dam