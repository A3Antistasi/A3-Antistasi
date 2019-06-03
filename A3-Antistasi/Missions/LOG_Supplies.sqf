//Mission: Logistic supplies
if (!isServer and hasInterface) exitWith{};
private ["_markerX","_difficultX","_salir","_contactX","_groupContact","_tsk","_posHQ","_citiesX","_ciudad","_tam","_positionX","_posHouse","_nameDest","_timeLimit","_dateLimit","_dateLimitNum","_pos","_camion","_cuenta"];

_markerX = _this select 0;

_difficultX = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contactX = objNull;
_groupContact = grpNull;
_tsk = "";
_positionX = getMarkerPos _markerX;

_timeLimit = if (_difficultX) then {30} else {60};
if (hayIFA) then {_timeLimit = _timeLimit * 2};
_dateLimit = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_dateLimitNum = dateToNumber _dateLimit;
_nameDest = [_markerX] call A3A_fnc_localizar;
_taskDescription = format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserved a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3. You may allways sell those supplies here, that money can be welcome. Just sell the truck and job is done",_nameDest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4];

[[buenos,civilian],"LOG",[_taskDescription,"City Supplies",_markerX],_positionX,false,0,true,"Heal",true] call BIS_fnc_taskCreate;
missionsX pushBack ["LOG","CREATED"]; publicVariable "missionsX";
_pos = (getMarkerPos respawnTeamPlayer) findEmptyPosition [1,50,"C_Van_01_box_F"];

//Creating the box
_camion = "Land_PaperBox_01_open_boxes_F" createVehicle _pos;
_camion allowDamage false;
_camion call jn_fnc_logistics_addAction;
_camion addAction ["Delivery infos",
	{
		_text = format ["Deliver this box to %1, unload it to start distributing to people",(_this select 0) getVariable "destinationX"]; //This need a rework
		_text remoteExecCall ["hint",_this select 2];	//This need a rework
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];
[_camion] call A3A_fnc_AIVEHinit;
//{_x reveal _camion} forEach (allPlayers - (entities "HeadlessClient_F"));
_camion setVariable ["destinationX",_nameDest,true];

[_camion,"Supply Box"] spawn A3A_fnc_inmuneConvoy;

waitUntil {sleep 1; (dateToNumber date > _dateLimitNum) or ((_camion distance _positionX < 40) and (isNull attachedTo _camion)) or (isNull _camion)};
_bonus = if (_difficultX) then {2} else {1};
if ((dateToNumber date > _dateLimitNum) or (isNull _camion)) then
	{
	["LOG",[_taskDescription,"City Supplies",_markerX],_positionX,"FAILED","Heal"] call A3A_fnc_taskUpdate;
	[5*_bonus,-5*_bonus,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
	[-10*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
	}
else
	{
	_cuenta = 120*_bonus;//120
	[[_positionX,malos,"",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2];
	["TaskFailed", ["", format ["%2 deploying supplies in %1",_nameDest,nameTeamPlayer]]] remoteExec ["BIS_fnc_showNotification",malos];
	{_amigo = _x;
	if (captive _amigo) then
		{
		[_amigo,false] remoteExec ["setCaptive",0,_amigo];
		_amigo setCaptive false;
		};
	{
	if ((side _x == malos) and (_x distance _positionX < distanceSPWN)) then
		{
		if (_x distance _positionX < 300) then {_x doMove _positionX} else {_x reveal [_amigo,4]};
		};
	if ((side _x == civilian) and (_x distance _positionX < 300) and (vehicle _x == _x)) then {_x doMove position _camion};
	} forEach allUnits;
	} forEach ([300,0,_camion,buenos] call A3A_fnc_distanceUnits);
	while {(_cuenta > 0)/* or (_camion distance _positionX < 40)*/ and (dateToNumber date < _dateLimitNum) and !(isNull _camion)} do
		{
		while {(_cuenta > 0) and (_camion distance _positionX < 40) and ({[_x] call A3A_fnc_canFight} count ([80,0,_camion,buenos] call A3A_fnc_distanceUnits) == count ([80,0,_camion,buenos] call A3A_fnc_distanceUnits)) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0) and (dateToNumber date < _dateLimitNum) and (isNull attachedTo _camion)} do
			{
			_formatX = format ["%1", _cuenta];
			{if (isPlayer _x) then {[petros,"countdown",_formatX] remoteExec ["A3A_fnc_commsMP",_x]}} forEach ([80,0,_camion,buenos] call A3A_fnc_distanceUnits);
			sleep 1;
			_cuenta = _cuenta - 1;
			};
		if (_cuenta > 0) then
			{
			_cuenta = 120*_bonus;//120
			if (((_camion distance _positionX > 40) or (not([80,1,_camion,buenos] call A3A_fnc_distanceUnits)) or ({(side _x == malos) and (_x distance _camion < 50)} count allUnits != 0)) and (alive _camion)) then {{[petros,"hint","Don't get the truck far from the city center, and stay close to it, and clean all BLUFOR presence in the surroundings or count will restart"] remoteExec ["A3A_fnc_commsMP",_x]} forEach ([100,0,_camion,buenos] call A3A_fnc_distanceUnits)};
			waitUntil {sleep 1; ((_camion distance _positionX < 40) and ([80,1,_camion,buenos] call A3A_fnc_distanceUnits) and ({(side _x == malos) and (_x distance _camion < 50)} count allUnits == 0)) or (dateToNumber date > _dateLimitNum) or (isNull _camion)};
			};
		if (_cuenta < 1) exitWith {};
		};
		if ((dateToNumber date < _dateLimitNum) and !(isNull _camion)) then
			{
			[petros,"hint","Supplies Delivered"] remoteExec ["A3A_fnc_commsMP",[buenos,civilian]];
			["LOG",[_taskDescription,"City Supplies",_markerX],_positionX,"SUCCEEDED","Heal"] call A3A_fnc_taskUpdate;
			{if (_x distance _positionX < 500) then {[10*_bonus,_x] call A3A_fnc_playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
			[5*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
			if (!isMultiplayer) then {_bonus = _bonus + ((20-skillFIA)*0.1)};
			[-1*(20-skillFIA),15*_bonus,_markerX] remoteExec ["A3A_fnc_citySupportChange",2];
			[-3,0] remoteExec ["A3A_fnc_prestige",2];
			}
		else
			{
			["LOG",[_taskDescription,"City Supplies",_markerX],_positionX,"FAILED","Heal"] call A3A_fnc_taskUpdate;
			[5*_bonus,-5*_bonus,_positionX] remoteExec ["A3A_fnc_citySupportChange",2];
			[-10*_bonus,theBoss] call A3A_fnc_playerScoreAdd;
			};
	};

_ecpos = getpos _camion;
deleteVehicle _camion;
_emptybox = "Land_PaperBox_01_open_empty_F" createVehicle _ecpos;

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,"LOG"] spawn A3A_fnc_deleteTask;
waitUntil {sleep 1; (not([distanceSPWN,1,_camion,buenos] call A3A_fnc_distanceUnits)) or (_camion distance (getMarkerPos respawnTeamPlayer) < 60)};

deleteVehicle _emptybox;
