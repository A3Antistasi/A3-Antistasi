_credits = [ [ "Authors:", ["Barbolani","Official AntiStasi Community"] ] ];
_layers = ["credits1" call bis_fnc_rscLayer];
_delay = 5;
_duration = 5;
{
_title = [_x,0,""] call bis_fnc_paramin;
_names = _x select 1;
_text = format ["<t font='PuristaBold'>%1</t>",toUpper (_title)] + "<br />";
{
  _text = _text + _x + "<br />";
} foreach _names;
_text = format ["<t size='0.8'>%1</t>",_text];
_index = _foreachindex % 2;
_layer = _layers select _index;
[_layer,_text,_index,_duration] spawn {
 disableserialization;
 _layer = _this select 0;
 _text = _this select 1;
 _index = _this select 2;
 _duration = _this select 3;
 _fadeTime = 0.5;
 _time = time + _duration - _fadeTime;
 _layer cutrsc ["RscDynamicText","plain"];
 _display = uinamespace getvariable ["BIS_dynamicText",displaynull];
 _ctrlText = _display displayctrl 9999;
 _ctrlText ctrlsetstructuredtext parsetext _text;
 _offsetX = 0.1;
 _offsetY = 0.3;
 _posW = 0.4;
 _posH = ctrltextheight _ctrlText + _offsetY;
 _pos = [
  [safezoneX + _offsetX,safezoneY + _offsetY,_posW,_posH],
  [safezoneX + safezoneW - _posW - _offsetX,safezoneY + safezoneH - _posH,_posW,_posH]
 ] 	select _index;
	_ctrlText ctrlsetposition _pos;
	_ctrlText ctrlsetfade 1;
	_ctrlText ctrlcommit 0;
	_ctrlText ctrlsetfade 0;
	_ctrlText ctrlcommit _fadeTime;
	waituntil {time > _time};
	_ctrlText ctrlsetfade 1;
	_ctrlText ctrlcommit _fadeTime;
};
_time = time + _delay;
waituntil {time > _time};
} foreach _credits;