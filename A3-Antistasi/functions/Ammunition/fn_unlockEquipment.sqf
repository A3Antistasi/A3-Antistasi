/**
	Unlocks the specified item of equipment for use in the arsenal.
	
	Updates the appropriate global arrays for quick reference.
	
	Params:
		_className - Class of the equipment to unlock.
		
	Returns:
		None
**/

params ["_className"];

private _categories = _className call A3A_fnc_equipmentClassToCategories;

//Add the equipment to the arsenal.
private _arsenalTab = _className call jn_fnc_arsenal_itemType;
[_arsenalTab,_className,-1] call jn_fnc_arsenal_addItem;

{
	private _categoryName = _x;
	//Consider making this pushBackUnique.
	(missionNamespace getVariable ("unlocked" + _categoryName)) pushBack _className;
	publicVariable ("unlocked" + _categoryName);
} forEach _categories;
