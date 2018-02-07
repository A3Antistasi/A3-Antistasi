private ["_unit"];

_unit = _this select 0;

_result = false;

if ((hayTFAR) or (hayACRE)) then
	{
	_result = true;
	}
else
	{
	if ("ItemRadio" in assignedItems _unit) then {_result = true};
	};
_result