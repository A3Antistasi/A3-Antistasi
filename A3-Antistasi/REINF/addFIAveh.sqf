if (player != player getVariable ["owner",player]) exitWith {hint "You cannot buy vehicles while you are controlling AI"};

_chequeo = false;
{
	if (((side _x == muyMalos) or (side _x == malos)) and (_x distance player < 300) and ([_x] call canFight) and !(isPlayer _x)) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot buy vehicles with enemies nearby"};

private ["_tipoVeh","_coste","_resourcesFIA","_marcador","_pos","_veh","_tipoVeh"];

_tipoveh = _this select 0;

_coste = [_tipoVeh] call vehiclePrice;

if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"} else
	{
	if (player != theBoss) then
		{
		_resourcesFIA = player getVariable "dinero";
		}
	else
		{
		if ((_tipoVeh == SDKMortar) or (_tipoVeh == staticATBuenos) or (_tipoVeh == staticAABuenos) or (_tipoVeh == SDKMGStatic)) then {_resourcesFIA = server getVariable "resourcesFIA"} else {_resourcesFIA = player getVariable "dinero"};
		};
	};

if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};
_pos = position player findEmptyPosition [3,50,_tipoveh];
if (count _pos == 0) exitWith {hint "Not enough space to place this type of vehicle"};
_veh = _tipoveh createVehicle _pos;
if (!isMultiplayer) then
	{
	[0,(-1* _coste)] spawn resourcesFIA;
	}
else
	{
	if (player != theBoss) then
		{
		[-1* _coste] call resourcesPlayer;
		_veh setVariable ["duenyo",getPlayerUID player,true];
		}
	else
		{
		if ((_tipoVeh == SDKMortar) or (_tipoVeh == staticATBuenos) or (_tipoVeh == staticAABuenos) or (_tipoVeh == SDKMGStatic)) then
			{
			_nul = [0,(-1* _coste)] remoteExecCall ["resourcesFIA",2]
			}
		else
			{
			[-1* _coste] call resourcesPlayer;
			_veh setVariable ["duenyo",getPlayerUID player,true];
			};
		};
	};
if (_veh isKindOf "Car") then {_veh setPlateNumber format ["%1",name player]};

//if ((_tipoVeh == SDKMortar) or (_tipoVeh == staticATBuenos) or (_tipoVeh == staticAABuenos) or (_tipoVeh == SDKMGStatic)) then {staticsToSave pushBackUnique _veh; publicVariable "staticsToSave"};
if (_veh isKindOf "StaticWeapon") then {staticsToSave pushBackUnique _veh; publicVariable "staticsToSave"};
[_veh] call AIVEHinit;

//hint "Vehicle Purchased";
player reveal _veh;
petros directSay "SentGenBaseUnlockVehicle";