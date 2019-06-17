//GOM_fnc_vehicleTuning.sqf
//by Grumpy Old Man
//V0.9
// Allows player to upgrade and modify vehicles.
// Usage:
// _tuning = [player] call GOM_fnc_vehicleTuning;

//parameters to tweak are found in scripts\GOM\functions\VehicleTuning\GOM_fnc_initParams.sqf


params ["_object"];

[_object,["Tune Vehicles", {

	params ["_object","_activator"];

if !(_activator getVariable ["GOM_fnc_VTdiary",false]) then {
	_activator setVariable ["GOM_fnc_VTdiary",true,true];
	systemchat "'GOM Vehicle Tuning' manual added.";
	systemchat "Check diary for more details.";
_activator createDiarySubject ["GOM_veh_tuning", "GOM - Vehicle Tuning"];
_activator createDiarySubject ["GOM_veh_records", "Drag Racing Records"];

_activator createDiaryRecord ["GOM_veh_tuning", ["Guide", "Use this at your own risk.<br /><br />Usage:<br /><br />Use the scroll menu to open the tuning window.<br />Choose your options.<br />Click on OK.<br />Use the 'measure performance' action to retrieve various values, just do a quarter mile drag and you'll see.<br />Activate Nitro with Primary Weapon button.<br />Deactivate Nitro by releasing the forward button or by using the brake.<br />NOTE: You need to activate the Nitro manually after engaging the brake.<br />This is a safety measure.<br />Some vehicles are capable of reaching speeds above 400km/h. Expect airplane - like behaviour.<br />Try not to crash.<br /><br />Acceleration and top speed values depend on the vehicle.<br /><br />General guidance:<br /><br />When the vehicle slips, get off the gas or tip the brakes.<br />This will give you control over your vehicle.<br />Also try to countersteer when possible and only use nitro on straights.<br /><br />Some vehicles work better than others, seems to be caused by PhysX.<br /><br />The Powerband feature works as follows:<br /><br />If you set the thresholds to 100km/h and 300km/h, the nitro will be most efficient between those two speeds.<br />The low threshold sets the limit until the nitro reaches 100% efficiency.<br />The high threshold sets the limit before the nitro starts losing efficiency.<br />Choosing awkward numbers might break the nitro.<br />It's best to set them to values between 100 for the lower, and 300 for the upper threshold.<br />NOTE: Setting the lower threshold to a higher value could possibly lead to a better acceleration due to the vehicle being easier to control.<br />Strongly depends on the vehicle, so best experiment with these values.<br />Average horsepower is being calculated with the elapsed time over quarter mile formula, taking vehicle mass into account.<br /><br />Enjoy"]];
};

	createDialog "GOM_veh_tuning";
	playsound "Simulation_Restart";

	{
		ctrlShow [_x, false];
	} foreach [1900, 1901, 1902, 1003, 1004, 1005, 1006, 1007, 1008, 1009];
ctrlEnable [1604,false];
ctrlEnable [1620,false];
ctrlEnable [1621,false];
	_cars = _object nearEntities [ ["Car", "Motorcycle", "Tank", "Armor"], 25];
	(findDisplay 66)setvariable ["GOM_fnc_vehTuningCars", _cars];
	if (count _cars isEqualTo 0) exitwith {

		hint "No valid vehicle found. Get within 25m of a valid vehicle first.";
		_killHint = [] spawn GOM_fnc_killHint;
		playsound "Simulation_Restart";
	};

	// set listbox entries
	{

		_vehName = getText (configfile >> "CfgVehicles" >> typeOf _x >> "displayName");

		_driver = assignedDriver _x;
		_driverName = if (_driver isEqualTo objnull) then {"No owner."} else {name _driver};

		lbAdd [1500, format ["%1 - %2", _vehName, _driverName]];

		if (_x getvariable ["GOM_fnc_initMass", "init"] isEqualTo "init") then {

			_x setvariable ["GOM_fnc_initMass", getmass _x,true];
		};



	} foreach _cars;

	// listbox EH:
	sliderSetPosition [1900, 0];
	sliderSetPosition [1901, 1];
	sliderSetPosition [1902, 0];

	buttonSetAction [1604, "
	_nul = call GOM_fnc_InstallFromLB
	"];


	_EHs = [];
	_ID = findDisplay 66 displayCtrl 1500 ctrlAddEventhandler ["lbSelChanged", GOM_fnc_updateLB];
	_EHs pushBack _ID;

	_ID = findDisplay 66 displayCtrl 1501 ctrlAddEventhandler ["lbSelChanged", GOM_fnc_updateLB];
	_EHs pushBack _ID;

	_ID = findDisplay 66 displayCtrl 1502 ctrlAddEventhandler ["lbSelChanged", GOM_fnc_updateLB];
	_EHs pushBack _ID;

	(findDisplay 66) setVariable ["GOM_fnc_lbEHs", _EHs];
	_EHs = [];
	_ID = findDisplay 66 displayCtrl 1900 ctrlAddEventhandler ["SliderPosChanged", GOM_fnc_updateSlider2];
	_EHs pushBack _ID;

	_ID = findDisplay 66 displayCtrl 1901 ctrlAddEventhandler ["SliderPosChanged", GOM_fnc_updateSlider1];
	_EHs pushBack _ID;

	_ID = findDisplay 66 displayCtrl 1902 ctrlAddEventhandler ["SliderPosChanged", GOM_fnc_updateBoostDisplay];
	_EHs pushBack _ID;
	(findDisplay 66) setVariable ["GOM_fnc_sliderEHs", _EHs];

	playsound "Simulation_Restart";
	disableSerialization;
	buttonSetAction [1620, "
	_car = (((findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]]) select (lbCurSel 1500));

	ctrlEnable [1620, false];
	_car setdamage 0;
	ctrlSetText [1620, 'Repaired'];

	playsound selectRandom ['FD_Target_PopDown_Large_F','FD_Target_PopDown_Small_F','FD_Target_PopUp_Small_F'];
	"];

	buttonSetAction [1621, "
	ctrlEnable [1621, false];
	ctrlSetText [1621, 'Full'];
	_car = (((findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]]) select (lbCurSel 1500));
	_car setfuel 1;
	_car setvariable ['GOM_fnc_NitroVolume',1,true];
	hintsilent 'Vehicle refuelled.';
	_killHint = [] spawn GOM_fnc_killHint;

	"];


	GOM_fnc_confirmButton = {


	_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
	if (_Cars isEqualTo []) exitwith {true};
		_car = _cars select (lbCurSel 1500);
		_run = [_car] call GOM_fnc_vehTuning;

		//add engine EH
		_engineEH = _car getVariable ['GOM_fnc_engineEH',-1];
		if (_engineEH isEqualTo -1) then {

			_engineEH = _car addEventHandler ['Engine',{
				params ['_veh','_engineState'];
				If (_engineState) then {[_veh] remoteExec ['GOM_fnc_boost',driver _veh]};

			}];
			_car setVariable ['GOM_fnc_engineEH',_engineEH];

		};

		closeDialog 0;
		playsound 'Topic_Selection';

	};

	buttonSetAction [1612, "
call GOM_fnc_confirmButton;
		"];
		buttonSetAction [1613, "closeDialog 0;playsound 'Topic_Deselection';"];

		buttonSetAction [1605, "

		_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
		if (_Cars isEqualTo []) exitwith {true};
		_car = _cars select (lbCurSel 1500);

		if (typeof _car isKindOf 'Kart_01_Base_F') exitWith {


			[_car,(ctrlText 1400 select [0,2])] call GOM_fnc_setKartNumber;

		};

		_plate = toUpper (ctrlText 1400 select [0,15]);
		[_car,_plate] remoteExec ['setPlateNumber',_car,true];

		"];

		buttonSetAction [1606, "
		_cars = (findDisplay 66) getvariable ['GOM_fnc_vehTuningCars',[]];
		if (_Cars isEqualTo []) exitwith {true};
		_car = _cars select (lbCurSel 1500);

		_plate = [] call GOM_fnc_licensePlate;
		ctrlSetText [1400,_plate];
		[_car,_plate] remoteExec ['setPlateNumber',_car,true];

		"];

	_color = [0,0,0,0.6];
	_dark = [1500,1010,1606,1400,1605,1604,1603,1602,1601,1600,1501,1502,1103,1102,1101,1100,1620,1621,1612,1613,2200];
	{

		findDisplay 66 displayCtrl _x ctrlSetBackgroundColor _color;


	} forEach _dark;

},[],0,true,true,"","_this isEqualTo vehicle _this and _this getVariable ['GOM_fnc_qualifiedMechanic',false]",15]] remoteExec ["addAction",[0,-2] select isDedicated,true];
true