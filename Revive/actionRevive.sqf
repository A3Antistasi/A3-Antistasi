_curado = _this select 0;
_curandero = _this select 1;

if ((not("FirstAidKit" in (items _curandero))) and (not("FirstAidKit" in (items _curado)))) exitWith {hint format ["You or %1 need a First Aid Kit to be able to revive",name _curado]};
if ((not("FirstAidKit" in (items _curandero))) and !(_curandero canAdd "FirstAidKit")) exitWith {hint format ["%1 has a First Aid Kit but you do not have enough space in your inventory to use it",name _curado]};
if ((_curado getVariable ["fatalWound",false]) and ((!(getNumber (configfile >> "CfgVehicles" >> (typeOf _curandero) >> "attendant") == 2)) and !(_curandero getUnitTrait "Medic"))) exitWith {hint format ["%1 is injured by a fatal wound, only a medic can revive him",name _curado]};
if (_curado getVariable ["llevado",false]) exitWith {hint format ["%1 is being carried and you cannot help him",name _curado]};
if (!isMultiplayer) then {_curado setVariable ["ayudado",_curandero]} else {_curado setVariable ["ayudado",_curandero,true]};
_lado = _curado getVariable ["lado",sideUnknown];
if ((_lado == malos) or (_lado == muyMalos)) then {_curado setVariable ["surrendered",true,true]};
if (not("FirstAidKit" in (items _curandero))) then
	{
	_curandero addItem "FirstAidKit";
	_curado removeItem "FirstAidKit";
	};
_curandero action ["HealSoldier",_curado];
sleep 10;
if (!isMultiplayer) then {_curado setVariable ["ayudado",objNull]} else {_curado setVariable ["ayudado",objNull,true]};