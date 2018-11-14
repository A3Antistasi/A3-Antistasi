private ["_display","_childControl","_veh","_texto","_coste","_tipoVeh"];
_nul = createDialog "headquarters";

sleep 1;
disableSerialization;

_display = findDisplay 100;
if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 109;
	_ChildControl ctrlSetTooltip format [ localize "str_antistasi_hq_button_train_ai_tooltip", skillFIA, 1000 + (1.5 * ((skillFIA) * 750)) ];
};
