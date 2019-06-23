private ["_flag","_tipo"];

if (!hasInterface) exitWith {};

_flag = _this select 0;
_tipo = _this select 1;

private _radius = 50;

switch _tipo do
	{
	case "take":
		{
		removeAllActions _flag;
		_accion = _flag addAction ["<t color='#FF0000'>Take the Flag</t> <img image='\A3\ui_f\data\igui\cfg\actions\takeflag_ca.paa' size='1.8' shadow=2 />", {[_this select 0, _this select 1] call A3A_fnc_mrkWIN},nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
		_flag setUserActionText [_accion,"<t color='#FF0000'>Take the Flag</t>","<t size='2'><img image='\A3\ui_f\data\igui\cfg\actions\takeflag_ca.paa'/></t>"];
		};
	case "unit": {_flag addAction ["<t color='#00FF00'>Unit Recruitment</t>", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "You cannot recruit units while there are enemies near you"} else {nul=[] execVM "Dialogs\unit_recruit.sqf"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius]};
	case "vehicle": {_flag addAction ["<t color='#20FF20'>Buy Vehicle</t>", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "You cannot buy vehicles while there are enemies near you"} else {nul = createDialog "vehicle_option"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius]};
	case "mission": {petros addAction ["<t color='#00FFFF'>Mission Request</t>", {nul=CreateDialog "mission_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "camion": {accion = _flag addAction ["<t color='#20FF00'>Transfer Ammobox to Truck</t> <img image='\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa' size='1.8' shadow=2 />", "Municion\transfer.sqf",nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	//case "heal": {if (player != _flag) then {_flag addAction [format ["Revive %1",name _flag], "Revive\actionRevive.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]}};
	case "heal": {
				if (player != _flag) then
					{
					if ([_flag] call A3A_fnc_fatalWound) then
						{
						_accion = _flag addAction [format ["<t color='#2040FF'>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' />",name _flag], "Revive\actionRevive.sqf",nil,6,true,true,"","!(_this getVariable [""ayudando"",false]) and (isNull attachedTo _target)",4];
						_flag setUserActionText [_accion,format ["<t color='#2040FF'>Revive %1</t>",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa'/></t>"];
						}
					else
						{
						_accion = _flag addAction [format ["<t color='#4040FF'>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa' />",name _flag], "Revive\actionRevive.sqf",nil,6,true,true,"","!(_this getVariable [""ayudando"",false]) and (isNull attachedTo _target)",4];
						_flag setUserActionText [_accion,format ["<t color='#4040FF'>Revive %1</t>",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa'/></t>"];
						};
					};
				};
	case "heal1":
		{
		if (player != _flag) then
			{
			if ([_flag] call A3A_fnc_fatalWound) then
				{
				_accion = _flag addAction [format ["<t color='#2040FF'>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' />",name _flag], "Revive\actionRevive.sqf",nil,6,true,false,"","!(_this getVariable [""ayudando"",false]) and (isNull attachedTo _target)",4];

				_flag setUserActionText [_accion,format ["<t color='#2040FF'>Revive %1</t>",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa'/></t>"];
				}
			else
				{
				_accion = _flag addAction [format ["<t color='#4040FF'>Revive %1</t> <img size='1.8' <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa' />",name _flag], "Revive\actionRevive.sqf",nil,6,true,false,"","!(_this getVariable [""ayudando"",false]) and (isNull attachedTo _target)",4];
				_flag setUserActionText [_accion,format ["<t color='#4040FF'>Revive %1</t>",name _flag],"<t size='2'><img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa'/></t>"];
				};
			//_flag addAction [format ["Revive %1",name _flag], "Revive\actionRevive.sqf",nil,0,false,true,"","!(_this getVariable [""ayudando"",false]) and (isNull attachedTo _target)"];

			_accion = _flag addAction [format ["<t color='#4000FF'>Carry %1</t> <img image='\A3\ui_f\data\igui\cfg\actions\take_ca.paa' size='1.6' shadow=2 />",name _flag], "Revive\carry.sqf",nil,5,true,false,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (isNull attachedTo _target) and !(_this getVariable [""ayudando"",false]);",4];
			_flag setUserActionText [_accion,format ["<t color='#4000FF'>Carry %1</t>",name _flag],"<t size='2'><img image='\A3\ui_f\data\igui\cfg\actions\take_ca.paa'/></t>"];
			[_flag] call jn_fnc_logistics_addActionLoad;
			};
		};
	case "moveS": {_flag addAction ["<t color='#00AA00'>Move this asset</t>", "moveHQObject.sqf",nil,0,false,true,"","(_this == theBoss)"]};
	case "remove":
		{
		if (player == _flag) then
			{
			if (isNil "accion") then
				{
				removeAllActions _flag;
				if (player == player getVariable ["owner",player]) then {[] call SA_Add_Player_Tow_Actions};
				}
			else
				{
				_flag removeAction accion;
				};
			}
		else
			{
			removeAllActions _flag
			};
		};
	case "refugiado": {_flag addAction ["<t color='#4040FF'>Liberate</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", "AI\liberaterefugee.sqf",nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};//"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa"
	case "prisionero": {_flag addAction ["<t color='#4040FF'>Liberate POW</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", "AI\liberatePOW.sqf",nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "interrogar": {_flag addAction ["<t color='#FFFF00'>Interrogate</t>", "AI\interrogar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "capturar": {_flag addAction ["<t color='#4040FF'>Release POW</t> <img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa' size='1.6' shadow=2 />", "AI\capturar.sqf",nil,6,true,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "buildHQ": {_flag addAction ["<t color='#FF20FF'>Build HQ here</t>", {[] spawn A3A_fnc_buildHQ},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "seaport": {_flag addAction ["<t color='#20FF20'>Buy Boat</t>", {[vehSDKBoat] spawn A3A_fnc_addFIAVeh},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "steal": {_flag addAction ["<t color='#AA0000'>Steal Static</t>", "REINF\stealStatic.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4]};
	case "garage":
		{
		if (isMultiplayer) then
			{
			_flag addAction ["<t color='#40FF40'>Personal Garage</t>", {nul = [true] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])", _radius];
			_flag addAction ["<t color='#40FFFF'>Faction Garage</t>", {nul = [false] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])", _radius];
			}
		else
			{
			_flag addAction ["<t color='#40FFFF'>Faction Garage</t>", {nul = [false] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])", _radius]
			};
		};
	case "fuego":
		{
		fuego addAction ["<t color='#0040FF'>Rest for 8 Hours</t>", "skiptime.sqf",nil,0,false,true,"","(_this == theBoss)",4];
		fuego addAction ["<t color='#0040FF'>Clear Nearby Forest</t>", "clearForest.sqf",nil,0,false,true,"","(_this == theBoss)",4];
		fuego addAction ["<t color='#0040FF'>On\Off Lamp</t>", "onOffLamp.sqf",nil,0,false,true,"","(isPlayer _this)",4];
		fuego addAction ["<t color='#0040FF'>I hate the fog</t>", "[10,0] remoteExec [""setFog"",2]",nil,0,false,true,"","(_this == theBoss)",4];
		};

	case "SDKFlag":
		{
		removeAllActions _flag;
		_flag addAction ["<t color='#00FF00'>Unit Recruitment</t>", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "You cannot recruit units while there are enemies near you"} else {nul=[] execVM "Dialogs\unit_recruit.sqf"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])", _radius];
		_flag addAction ["<t color='#20FF20'>Buy Vehicle</t>", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "You cannot buy vehicles while there are enemies near you"} else {nul = createDialog "vehicle_option"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius];
		if (isMultiplayer) then
			{
			_flag addAction ["<t color='#40FF40'>Personal Garage</t>", {nul = [true] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius];
			_flag addAction ["<t color='#40FFFF'>Faction Garage</t>", {nul = [false] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius];
			}
		else
			{
			_flag addAction ["<t color='#40FFFF'>Faction Garage</t>", {nul = [false] spawn A3A_fnc_garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",_radius]
			};
		};
	};