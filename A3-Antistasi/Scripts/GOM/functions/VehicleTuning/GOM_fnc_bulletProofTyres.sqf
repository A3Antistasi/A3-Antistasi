//GOM_fnc_bulletProofTyres.sqf
//by Grumpy Old Man
//V0.9
params ["_car"];
_car setvariable ["GOM_fnc_bulletProofTyres",true,true];
_ID = _car addEventHandler ["HandleDamage",{

	params ["_veh","_selection","_damage","_src","_projectile"];
	_check = false;
	_roundthings = ["wheel","tyre","tire"];

	{

		if (toUpper _selection find toUpper _x >= 0) then {_check = true;};

	} foreach _roundthings;


	if (_projectile isKindOf "BulletCore" AND _check) then {_damage = 0};

	_damage
}];
_car setvariable ["GOM_fnc_bulletProofTyresEHID",_ID,true];
true