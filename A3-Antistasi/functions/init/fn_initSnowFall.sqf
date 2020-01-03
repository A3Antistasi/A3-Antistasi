//Snow only on chernarus winter map
if(toLower worldName != "chernarus_winter") exitWith {};

while {true} do
{
    private _waitTime = (random 30) * 2; //30 minutes of wait time max
    private _snowTime = (random 15) * 4; //15 minutes of snow max
    private _sbursts = (random 2); // creates randomly a 0 or 1 to determine the amount of snow bursts
    sleep _waitTime;
    // Call Snow Storm Script
    //"_snowfall","_duration_storm","_ambient_sounds_al","_breath_vapors","_snow_burst","_effect_on_objects","_vanilla_fog","_local_fog","_intensifywind","_unitsneeze"
    [true,           _snowTime,                15,                true,        _sbursts,             false, 			true,         true,        false,          true] execvm "AL_snowstorm\al_snow.sqf";
    sleep _snowTime;
    //End snow script here if needed
}
