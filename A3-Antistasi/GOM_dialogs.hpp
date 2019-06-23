//GOM_dialogs.hpp
//by Grumpy Old Man
//V0.9
#define GUI_GRID_X      (0)
#define GUI_GRID_Y      (0)
#define GUI_GRID_W      (0.025)
#define GUI_GRID_H      (0.04)
#define GUI_GRID_WAbs   (1)
#define GUI_GRID_HAbs   (1)

class GOM_veh_tuning {
idd = 66;
movingEnable = 0;
class controls {


////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Grumpy Old Man, v1.063, #Doxyki)
////////////////////////////////////////////////////////

class RscButton_1612: RscButton
{
    idc = 1612;

    text = "Confirm"; //--- ToDo: Localize;
    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 17 * GUI_GRID_H + GUI_GRID_Y;
    w = 8 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscButton_1613: RscButton
{
    idc = 1613;

    text = "Cancel"; //--- ToDo: Localize;
    x = 29 * GUI_GRID_W + GUI_GRID_X;
    y = 17 * GUI_GRID_H + GUI_GRID_Y;
    w = 8 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class IGUIBack_2200: IGUIBack
{
    idc = 2200;

    x = 2.5 * GUI_GRID_W + GUI_GRID_X;
    y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
    w = 35 * GUI_GRID_W;
    h = 18 * GUI_GRID_H;
    colorBackground[] = {-1,-1,-1,0.3};
};
class RscButton_1620: RscButton
{
    idc = 1620;

    text = "Repair"; //--- ToDo: Localize;
    x = 15 * GUI_GRID_W + GUI_GRID_X;
    y = 17 * GUI_GRID_H + GUI_GRID_Y;
    w = 4 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscButton_1621: RscButton
{
    idc = 1621;

    text = "Refuel"; //--- ToDo: Localize;
    x = 21 * GUI_GRID_W + GUI_GRID_X;
    y = 17 * GUI_GRID_H + GUI_GRID_Y;
    w = 4 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscStructuredText_1101: RscStructuredText
{
    idc = 1101;

    text = "<t align='center'>--- Grumpy Old Mans Vehicle Workshop ---</t>"; //--- ToDo: Localize;
    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 1 * GUI_GRID_H + GUI_GRID_Y;
    w = 34 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscStructuredText_1102: RscStructuredText
{
    idc = 1102;

    text = "<t align='center'>Select Vehicle</t>"; //--- ToDo: Localize;
    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 3 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscListbox_1500: RscListBox
{
    idc = 1500;

    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 4 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 4 * GUI_GRID_H;
};
class RscStructuredText_1100: RscStructuredText
{
    idc = 1100;

    text = "<t align='center'>Upgrade Category</t>"; //--- ToDo: Localize;
    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 9 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscListbox_1501: RscListBox
{
    idc = 1501;

    x = 3 * GUI_GRID_W + GUI_GRID_X;
    y = 10 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 6.5 * GUI_GRID_H;
};
class RscStructuredText_1103: RscStructuredText
{
    idc = 1103;

    text = "<t align='center'>Select Upgrade</t>"; //--- ToDo: Localize;
    x = 15 * GUI_GRID_W + GUI_GRID_X;
    y = 9 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscListbox_1502: RscListBox
{
    idc = 1502;

    x = 15 * GUI_GRID_W + GUI_GRID_X;
    y = 10 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 6 * GUI_GRID_H;
};
class RscButton_1604: RscButton
{
    idc = 1604;

    text = "Install"; //--- ToDo: Localize;
    x = 15 * GUI_GRID_W + GUI_GRID_X;
    y = 16 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscStructuredText_1104: RscStructuredText
{
    idc = 1104;

    text = "<t align='center'>Select Vehicle</t>"; //--- ToDo: Localize;
    x = 15 * GUI_GRID_W + GUI_GRID_X;
    y = 3 * GUI_GRID_H + GUI_GRID_Y;
    w = 22 * GUI_GRID_W;
    h = 5 * GUI_GRID_H;
};
class PlateEdit: RscEdit
{
    idc = 1400;

    x = 26.5 * GUI_GRID_W + GUI_GRID_X;
    y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
    w = 10 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
    tooltip = "15 Characters max.! For Karts use 2 digit numbers. (05, etc)"; //--- ToDo: Localize;
};
class RscButton_1605: RscButton
{
    idc = 1605;

    text = "Set"; //--- ToDo: Localize;
    x = 34 * GUI_GRID_W + GUI_GRID_X;
    y = 12 * GUI_GRID_H + GUI_GRID_Y;
    w = 2.5 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscText_1010: RscText
{
    idc = 1010;

    text = "Plate:"; //--- ToDo: Localize;
    x = 30 * GUI_GRID_W + GUI_GRID_X;
    y = 9 * GUI_GRID_H + GUI_GRID_Y;
    w = 2.5 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
class RscButton_1606: RscButton
{
    idc = 1606;

    text = "Stock Plate"; //--- ToDo: Localize;
    x = 26.5 * GUI_GRID_W + GUI_GRID_X;
    y = 12 * GUI_GRID_H + GUI_GRID_Y;
    w = 6.5 * GUI_GRID_W;
    h = 1 * GUI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////


};









};
/* #Kygoce
   $[
        1.063,
        ["GOM_Veh_Tuning",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
        [1600,"RscButton_1612",[2,"Confirm",["3 * GUI_GRID_W + GUI_GRID_X","17 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1612;"]],
        [1601,"RscButton_1613",[2,"Cancel",["29 * GUI_GRID_W + GUI_GRID_X","17 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1613;"]],
        [2200,"IGUIBack_2200",[2,"",["2.5 * GUI_GRID_W + GUI_GRID_X","0.5 * GUI_GRID_H + GUI_GRID_Y","35 * GUI_GRID_W","18 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,0.3],[-1,-1,-1,-1],"","-1"],["idc = 2200;"]],
        [1602,"RscButton_1620",[2,"Repair",["15 * GUI_GRID_W + GUI_GRID_X","17 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1620;"]],
        [1603,"RscButton_1621",[2,"Refuel",["21 * GUI_GRID_W + GUI_GRID_X","17 * GUI_GRID_H + GUI_GRID_Y","4 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1621;"]],
        [1100,"RscStructuredText_1101",[2,"<t align='center'>--- Grumpy Old Mans Vehicle Workshop ---</t>",["3 * GUI_GRID_W + GUI_GRID_X","1 * GUI_GRID_H + GUI_GRID_Y","34 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1101;"]],
        [1101,"RscStructuredText_1102",[2,"<t align='center'>Select Vehicle</t>",["3 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1102;"]],
        [1000,"RscListbox_1500: RscListBox",[2,"",["3 * GUI_GRID_W + GUI_GRID_X","4 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","4 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1500;"]],
        [1102,"RscStructuredText_1100",[2,"<t align='center'>Upgrade Category</t>",["15 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1100;"]],
        [1001,"RscListbox_1501: RscListBox",[2,"",["15 * GUI_GRID_W + GUI_GRID_X","4 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","4 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1501;"]],
        [1103,"RscStructuredText_1103",[2,"<t align='center'>Select Upgrade</t>",["27 * GUI_GRID_W + GUI_GRID_X","3 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1103;"]],
        [1002,"RscListbox_1502: RscListBox",[2,"",["27 * GUI_GRID_W + GUI_GRID_X","4 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","4 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1502;"]],
        [1900,"RscSlider_1900",[2,"low threshold",["9 * GUI_GRID_W + GUI_GRID_X","14.3 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1900;"]],
        [1901,"RscSlider_1901",[2,"low threshold",["9 * GUI_GRID_W + GUI_GRID_X","15.6 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1901;"]],
        [1904,"RscSlider_1904",[2,"low threshold",["23 * GUI_GRID_W + GUI_GRID_X","15.6 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1904;"]],
        [1604,"RscButton_1604",[2,"Install",["27 * GUI_GRID_W + GUI_GRID_X","8 * GUI_GRID_H + GUI_GRID_Y","10 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1604;"]],
        [1104,"RscStructuredText_1104",[2,"<t align='center'>Select Vehicle</t>",["3 * GUI_GRID_W + GUI_GRID_X","9 * GUI_GRID_H + GUI_GRID_Y","34 * GUI_GRID_W","4 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["idc = 1104;"]],
        [1003,"",[2,"High Threshold:",["3 * GUI_GRID_W + GUI_GRID_X","14 * GUI_GRID_H + GUI_GRID_Y","6 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1004,"",[2,"Low Threshold:",["3 * GUI_GRID_W + GUI_GRID_X","15.3 * GUI_GRID_H + GUI_GRID_Y","6 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1005,"",[2,"km/h",["17.5 * GUI_GRID_W + GUI_GRID_X","14 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1006,"",[2,"km/h",["17.5 * GUI_GRID_W + GUI_GRID_X","15.3 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1007,"",[2,"boost",["33 * GUI_GRID_W + GUI_GRID_X","15.9 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1008,"",[2,"Nitro Power at Speed:",["23.5 * GUI_GRID_W + GUI_GRID_X","14.5 * GUI_GRID_H + GUI_GRID_Y","8 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
        [1009,"",[2,"km/h",["33 * GUI_GRID_W + GUI_GRID_X","14.9 * GUI_GRID_H + GUI_GRID_Y","5 * GUI_GRID_W","1 * GUI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
   ]
 */

