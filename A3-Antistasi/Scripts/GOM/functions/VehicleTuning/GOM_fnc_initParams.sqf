
//contains array of ["NAME",performance multiplier,cost,description]
_engineBoostParams = [
//stock multi should be 0, so no boost is applied
["Stock Engine",0,5000,"Run of the mill engine that comes with the vehicle."],
["Engine Kit 1",1.1,15000,"Custom exhaust and air intake."],
["Engine Kit 2",1.2,30000,"Same as Engine Kit 1 + custom ECM and valve timings."],
["Engine Kit 3",1.3,60000,"Same as Engine Kit 2 + racing exhaust and custom manifold."],
["NASCAR Kit",2.2,150000,"Big bore V8 engine with all the bells and whistles."],
["Drag Racing Kit",4,500000,"The whole package, reduces lifespan of driver."]
];

_transmissionParams = [
["Stock Transmission",1,2500,"Run of the mill transmission that comes with the vehicle."],
["Transmission Kit 1",1.1,7500, "Slight increase of maximum speed."],
["Transmission Kit 2",1.2,15000, "Medium increase of maximum speed."],
["Transmission Kit 3",1.3,30000, "Decent increase of maximum speed."],
["NASCAR Transmission",2,75000, "Only use if the Transmission Kit 3 isn't cutting it."],
["Drag Racing Transmission",4,250000, "Way beyond legal at this point."]
];

_brakeParams = [
["Stock Brakes",1,2000,""],
["Brake Kit 1",1.1,7000,""],
["Brake Kit 2",1.2,10000,""],
["Brake Kit 3",1.3,25000,""],
["Ceramic Brakes",1.5,40000,""],
["NASCAR Brakes",1.8,70000,""],
["Drag Racing Brakes",2.5,200000,""]
];

_chassisParams = [
["Stock Chassis",1,8000,""],
["Chassis Kit 1",0.9,24000,""],
["Chassis Kit 2",0.8,48000,""],
["Chassis Kit 3",0.7,80000,""],
["Carbon Chassis",0.55,150000,""]
];


missionNamespace setVariable ["GOM_fnc_engineBoostParams",_engineBoostParams,true];
missionNamespace setVariable ["GOM_fnc_transmissionParams",_transmissionParams,true];
missionNamespace setVariable ["GOM_fnc_brakeParams",_brakeParams,true];
missionNamespace setVariable ["GOM_fnc_chassisParams",_chassisParams,true];