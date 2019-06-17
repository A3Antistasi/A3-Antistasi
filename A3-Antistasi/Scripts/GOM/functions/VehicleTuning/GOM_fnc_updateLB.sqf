
ctrlSetText [1604,"Install"];
(findDisplay 66) displayCtrl 1604 ctrlSetTextColor [1,1,1,1];

ctrlEnable [1604,false];
ctrlEnable [1620,false];
ctrlEnable [1621,false];
if (lbCurSel 1500 < 0) then {

	ctrlSetText [1604,"Select Vehicle"];
	lbclear 1501;	lbAdd [1501, "Select Vehicle"];
	lbclear 1502;	lbAdd [1502, "Select Vehicle"];
	(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />Select Vehicle</t>",""];
	true

};

if (lbCurSel 1500 >= 0) then {
	ctrlEnable [1620,true];
	ctrlEnable [1621,true];

	_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
	_car = _cars select (lbCurSel 1500);
	_number = getPlateNumber _car;

	if (typeof _car isKindOf 'Kart_01_Base_F') exitWith {

		_number = [_car] call GOM_fnc_getKartNumber;
	ctrlSetText [1400,_number];

	};

	ctrlSetText [1400,_number];
};

if (lbCurSel 1501 >= 0) then {
	ctrlSetText [1604,"Install"];
	ctrlEnable [1604,true];
};

if (lbCurSel 1501 < 0) then {
	(findDisplay 66) displayCtrl 1604 ctrlSetTextColor [1,0,0,1];


	ctrlSetText [1604,"Select Category"];
	lbclear 1502;	lbAdd [1502, "Select Category"];
	(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />Select Category</t>",""];
	true

};



_categoryArray = ["Engine Performance","Transmission","Brakes","Chassis","Luxuries","Color","Accessories"];

if (lbSize 1501 < 1) then {
	{
	lbAdd [1501, _x];
} foreach _categoryArray;
};

//taken out, some texts are too long for 4 rows, maybe add a scrollbar later
if (lbCurSel 1500 >= 0 AND lbCurSel 1501 < 0 AND lbCurSel 1502 < 0) then {

	_car = (((findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]]) select (lbCurSel 1500));


	_text = getText (configfile >> "CfgVehicles" >> typeOf _car >> "Library" >> "libTextDesc");
	(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'>%1</t>",_text];

};
_followUpInfo = ["Engine Performance","Transmission","Brakes","Chassis","Luxuries","Colors","Accessories"];
_followUpTextArray = ["Increases the engines performance. Can lead to a higher fuel consumption and engine wear.","Increases the vehicles top speed.","Increases the vehicles negative acceleration.","Reduces the vehicles weight.","James Bond would be jealous.","Changes the vehicles Colors.","Adds or removes Accessories."];
_valueArray = [["High Threshold","Low Threshold"],[],[],[]];

_engineNames = GOM_fnc_engineBoostParams apply {_x#0};
_transmissionNames = GOM_fnc_transmissionParams apply {_x#0};
_brakeNames = GOM_fnc_brakeParams apply {_x#0};
_chassisNames = GOM_fnc_chassisParams apply {_x#0};

_enginePrices = GOM_fnc_engineBoostParams apply {_x#2};
_transmissionPrices = GOM_fnc_transmissionParams apply {_x#2};
_brakePrices = GOM_fnc_brakeParams apply {_x#2};
_chassisPrices = GOM_fnc_chassisParams apply {_x#2};

_componentInfo = [

GOM_fnc_engineBoostParams apply {_x#3},
GOM_fnc_transmissionParams apply {_x#3},
GOM_fnc_brakeParams apply {_x#3},
GOM_fnc_chassisParams apply {_x#3}

];

_upgradeArray = [_engineNames,_transmissionNames,_brakeNames,_chassisNames,["Cruise Control","F.O.G. Machine","Ejection Seats","Bulletproof Tyres","GPS Tracker"],["Stock Color"],["No Accessories"]];
_luxuryInfo = ["Locks the vehicles speed at the time of engaging Cruise Control.<br />For proper operation release gas and brakes before engaging Cruise Control.","Installs a F.O.G. machine with 3 charges.<br /> Use at own risk.","James Bond style ejection seats for every passenger.<br />Parachutes may or may not be included.","Adds bulletproof tyres.","Installs cutting edge GPS tracking technology.<br />Tracks position and speed for the last 5 minutes."];

_car = (((findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]]) select (lbCurSel 1500));

if (_car getVariable ["GOM_fnc_NitroVolume",-1] <= 0) then {

	{

	ctrlShow [_x,false];

} foreach [1900,1901,1902,1003,1004,1005,1006,1007,1008,1009];

};

if (_car getVariable ["GOM_fnc_NitroVolume",-1] > 0) then {

	{

	ctrlShow [_x,true];

} foreach [1900,1901,1902,1003,1004,1005,1006,1007,1008,1009];

};

//add textures to dialog
_colorConfigs = "true" configClasses (configfile >> "CfgVehicles" >> typeof _car >> "textureSources");
_colorTextures = [];
if (count _colorConfigs > 0) then {

	_colorNames = [];
	{
	_colorNames pushback (getText (configfile >> "CfgVehicles" >> typeof _car >> "textureSources" >> configName _x >> "displayName"));
	_colorTextures pushback (getArray (configfile >> "CfgVehicles" >> typeof _car >> "textureSources" >> configName _x >> "textures"));
} foreach _colorConfigs;
_upgradeArray set [5,_colornames];

};

//add hidden animations to dialog
_animConfigs = "(getText (configfile >> 'CfgVehicles' >> typeof _car >> 'AnimationSources' >> configName _x >> 'displayName')) != ''" configClasses (configfile >> "CfgVehicles" >> typeof _car >> "AnimationSources");
_animSources = [];
if (count _animConfigs > 0) then {

	_animNames = [];
	{
	_animNames pushback (getText (configfile >> "CfgVehicles" >> typeof _car >> "AnimationSources" >> configName _x >> "displayName"));

} foreach _animConfigs;
_upgradeArray set [6,_animNames];

};





if !(lbCurSel 1501 isEqualTo -1) then {


	lbclear 1502;
//set text for followup listbox
_followUpInfoText = (_followUpInfo select (lbCurSel 1501));
_followUpText = (_followUpTextArray select (lbCurSel 1501));
(( findDisplay 66) displayCtrl 1103) ctrlSetStructuredText parsetext format ["<t align='center'>%1</t>",_followUpInfoText];

(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />%1</t>",_followUpText];


//display component info
if (lbCurSel 1502 >= 0 AND lbCurSel 1501 <= 3) then {
_info = _componentInfo#(lbcursel 1501)#(lbcursel 1502);
(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />%1</t>",_info];


};



{

	lbAdd [1502, _x];

} foreach ((_upgradeArray select (lbCurSel 1501)));

};

if (lbCurSel 1501 isEqualTo 4) then {


	(( findDisplay 66) displayCtrl 1104) ctrlSetStructuredText parsetext format ["<t align='center'><br />%1</t>",_luxuryInfo select lbCurSel 1502];


};
if (lbCurSel 1501 isEqualTo 6 AND lbCurSel 1502 >= 0) then {

	ctrlSetText [1604,"Toggle"];

};
