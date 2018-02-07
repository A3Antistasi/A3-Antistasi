_config = _this select 0;

_array = [];

for "_i" from 0 to (count _config) - 1 do
	{
	_item = _config select _i;
	if (isClass _item) then
		{
		_array = _array + [getText(_item >> "vehicle")];
		};
	};
_array