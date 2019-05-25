private ["_isMarker","_sitio","_time","_dateNum","_dateArray"];
_sitio = _this select 0;
_time = _this select 1;
_isMarker = false;
if (_sitio isEqualType "") then {_isMarker = true};
_dateNum = if (_isMarker) then {server getVariable [_sitio,0]} else {timer getVariable [(typeOf _sitio),0]};
if (_dateNum < dateToNumber date) then {_dateNum = dateToNumber date};
if (!_isMarker) then
	{
	if (side _sitio == Occupants) then
		{
		_time = round (_time * 1.5)
		}
	else
		{
		if ({sidesX getVariable [_x,sideUnknown] == } count airportsX == 1) then {_time = 0};
		};
	};
_dateArray = numberToDate [2035,_dateNum];

_dateArray = [_dateArray select 0, _dateArray select 1, _dateArray select 2, _dateArray select 3, (_dateArray select 4) + _time];

if (_isMarker) then {server setVariable [_sitio,dateToNumber _dateArray,true]} else {timer setVariable [(typeOf _sitio),dateToNumber _dateArray,true]};
