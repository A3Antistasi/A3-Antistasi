//Snow only on chernarus winter map
if(toLower worldName != "chernarus_winter") exitWith {};

while {true} do
{
    private _waitTime = (random 30) * 60; //30 minutes of wait time max
    private _snowTime = (random 15) * 60; //15 minutes of snow max
    sleep _waitTime;
    //Trigger snow script here
    sleep _snowTime;
    //End snow script here if needed
}