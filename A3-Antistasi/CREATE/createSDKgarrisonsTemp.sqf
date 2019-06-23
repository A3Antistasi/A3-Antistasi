private _marcador = _this select 0;
private _tipo = _this select 1;

if (_tipo isEqualType "") then {
    diag_log format ["[createSDKgarrisonsTemp] Spawning %1 now", _tipo];

    private _posicion = getMarkerPos _marcador;
    private _size = [_marcador] call A3A_fnc_sizeMarker;
    private _unit = objNull;
    private _veh = objNull;
    private _grupos = [];
    private _grupo = objNull;
    if (_tipo == staticCrewBuenos) then {
        diag_log format ["[createSDKgarrisonsTemp] %1 is mortar crew", _tipo];
        _grupos = allGroups select {(leader _x getVariable ["marcador",""] == _marcador) and ((typeOf (vehicle (leader _x)) == SDKMortar) && (typeOf (leader _x) == staticCrewBuenos)) and (side leader _x == buenos)};
        _pos = [_posicion] call A3A_fnc_mortarPos;
        _veh = SDKMortar createVehicle _pos;
        _nul = [_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
        [_veh] call A3A_fnc_AIVEHinit;
    } else {
        if(_tipo in SDKMil) then {
            diag_log format ["[createSDKgarrisonsTemp] Unit type %1 is SDKMil, looking for a static for them to gun", _tipo];

            private _statics = staticsToSave select {_x distance _posicion < _size and count (allTurrets _x) > 0};

            // Clear the dead from statics
            {
                private _gunner = gunner _x;
                if (!isNull _gunner and !alive _gunner) then {
                    diag_log format ["[createSDKgarrisonsTemp] Removing dead gunner %1 from %2", _gunner, _x];
                    unassignVehicle _gunner;
                    deleteVehicle _gunner;
                };
            } forEach _statics;

            // Get empty statics
            private _emptyStatics = _statics select {isNull (assignedGunner _x)};

            if(count _emptyStatics > 0) then { 
                _veh = _emptyStatics select 0; 
                diag_log format ["[createSDKgarrisonsTemp] Found a static %1 for unit to gun", _veh];
            };
        };
        // If the unit isn't going to be getting in a vehicle then we try to add them to an existing group
        if (isNull _veh) then {
            _grupos = allGroups select {(leader _x getVariable ["marcador",""] == _marcador) and (count units _x < 8) and (vehicle (leader _x) == leader _x) and (side (leader _x) == buenos)};
        };
    };

    // Create new group if we didn't find one
    _grupo = if (_grupos isEqualTo []) then { createGroup buenos } else { _grupos select 0 };

    private _centre = [ _posicion , _size * 0.25 + random (_size * 0.25) , random 360 ] call BIS_fnc_relPos;
    private _unit_spawn_pos = _centre findEmptyPosition [0, _size * 0.25];
    if (_unit_spawn_pos isEqualTo []) then {
        _unit_spawn_pos = _posicion;
    };

    // Create the unit
    _unit = _grupo createUnit [_tipo, _unit_spawn_pos, [], 0, "NONE"];
    // IF the unit type is a leader then make it the leader of the group
    if (_tipo in SDKSL) then {_grupo selectLeader _unit};
    [_unit,_marcador] call A3A_fnc_FIAinitBases;
    
    // Assign to a vehicle if one was specified
    if (!isNull _veh) then {
        diag_log format ["[createSDKgarrisonsTemp] Moving new unit %1 into static %2 as gunner", _unit, _veh];
        _unit assignAsGunner _veh;
        _unit moveInGunner _veh;
    } else {
        // We created a new group and it wasn't for a static vehicle, so add it to USPMON.
        if (_grupos isEqualTo []) then {
            _nul = [leader _grupo, _marcador, "SAFE","SPAWNED","ORIGINAL","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
        };
    };

    // Watch the unit for when we despawn the garrison, so we can clean it up.
    [_unit,_marcador] spawn {
        private _unit = _this select 0;
        private _marcador = _this select 1;
        waitUntil {sleep 1; (spawner getVariable _marcador == 2)};
        if (alive _unit) then {
            private _grupo = group _unit;
            if (typeOf _unit == staticCrewBuenos) then {deleteVehicle (vehicle _unit)};
            deleteVehicle _unit;
            if (count units _grupo == 0) then {deleteGroup _grupo};
        };
    };
};