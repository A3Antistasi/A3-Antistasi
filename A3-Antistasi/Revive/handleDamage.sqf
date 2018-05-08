private ["_unit","_part","_dam","_injurer"];
_unit = _this select 0;
_part = _this select 1;
_dam = _this select 2;
_injurer = _this select 3;

if (isPlayer _unit) then
	{
	_owner = _unit getVariable ["owner",player];
	if (_owner!=player) then
		{
		selectPlayer _owner;
		removeAllActions _unit;
		{[_x] joinsilent group player} forEach units group player;
		group player selectLeader player;
		hint "Returned to original Unit as controlled AI received damage";
		};
	}
else
	{
	if (local _unit) then
		{
		_owner = _unit getVariable "owner";
		if (!isNil "_owner") then
			{
			if (_owner==_unit) then
				{
				removeAllActions player;
				selectPlayer _owner;
				{[_x] joinsilent group player} forEach units group player;
				group player selectLeader player;
				hint "Returned to original Unit as it received damage";
				};
			};
		};
	};

if (_part == "") then
	{
	if (_dam >= 1) then
		{
		if (side _injurer == civilian) then
			{
			_dam = 0.9;
			}
		else
			{
			if (!(lifestate _unit == "INCAPACITATED")) then
				{
				if (vehicle _unit != _unit) then
					{
					//_unit action ["getOut", vehicle _unit];
					moveOut _unit;
					};
				_unit setUnconscious true;
				_dam = 0.9;
				if (isPlayer _unit) then {_unit allowDamage false};
				if (!isNull _injurer) then {[_unit,side _injurer] spawn inconsciente} else {[_unit,sideUnknown] spawn inconsciente};
				}
			else
				{
				_overall = (_unit getVariable ["overallDamage",0]) + (_dam - 1);
				if (_overall > 1) then
					{
					if (isPlayer _unit) then
						{
						_dam = 0;
						[_unit] spawn respawn;
						if (isPlayer _injurer) then
							{
							if ((_injurer != _unit) and (side _injurer == buenos) and (_unit getVariable ["GREENFORSpawn",false])) then {[_injurer,60] remoteExec ["castigo",_injurer]};
							};
						}
					else
						{
						_unit removeAllEventHandlers "HandleDamage";
						};
					}
				else
					{
					_unit setVariable ["overallDamage",_overall];
					_dam = 0.9;
					};
				};
			};
		}
	else
		{
		if (_dam > 0.25) then
			{
			if (isPlayer (leader group _unit)) then
				{
				if (autoheal) then
					{
					_ayudado = _unit getVariable ["ayudado",objNull];
					if (isNull _ayudado) then {[_unit] call pedirAyuda;};
					};
				}
			else
				{
				if (_dam > 0.6) then {[_unit,_unit] spawn cubrirConHumo};
				};
			};
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
//stavros sidechat format ["Final Daño_ %1. Parte %2",_dam,_part];
_dam