/*
	Returns the unit's radio - be it vanilla, TFAR or ACRE.

    Inputs:
        1: unit			"Unit to get radio from"

    Outputs
        Class name of radio or "" if not found
*/

//Note: This file has been optimised. Avoid changing unless necessary.

params ["_unit"];

private _items = assignedItems _unit;
//in order: vanilla, tfar, acre, vn
private _radioPosition = _items findIf {_x == "ItemRadio" || {_x find "tf_" > -1} || {"TFAR_" in _x} || {_x find "acre_" > -1} || {"item_radio" in _x}};

if (_radioPosition > -1) then {
	_items select _radioPosition;
} else {
	"";
};
