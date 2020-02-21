private _damage = _this select 2;
private _injurer = _this select 3;

/*  Handles the damage for AI units if hit by player
*   Params:
*       The HandleDamage EH params
*
*   Returns:
*       _damage : NUMBER : The amount of damage dealt
*/

//This is only triggered by damage dealt by players? It is fine for going down, but maybe the AI stuff should be calculated for AI vs AI too
if (side _injurer == teamPlayer) then
{
	private _unit = _this select 0;
	private _part = _this select 1;
	private _group = group _unit;
	if (time > _group getVariable ["movedToCover",0]) then
	{
		if ((behaviour leader _group != "COMBAT") and (behaviour leader _group != "STEALTH")) then
		{
			_group setVariable ["movedToCover",time + 120];
			{
                [_x,_injurer] call A3A_fnc_unitGetToCover
            } forEach units _group;
		};
	};
	if (_part == "") then
	{
		if (_damage >= 1) then
		{
			if (!(_unit getVariable ["incapacitated",false])) then
			{
				_unit setVariable ["incapacitated",true,true];
				_unit setUnconscious true;
				_damage = 0.9;
				[_unit,_injurer] spawn A3A_fnc_unconsciousAAF;
			}
			else
			{
                //Not really getting this part here
                //Maybe this is the reason why downed AI can take so much damage?
				_overall = (_unit getVariable ["overallDamage",0]) + (_damage - 1);
				if (_overall > 0.5) then
				{
					_unit removeAllEventHandlers "HandleDamage";
				}
				else
				{
					_unit setVariable ["overallDamage",_overall];
					_damage = 0.9;
				};
			};
		}
		else
		{
            //Abort helping if hit too hard
			if (_damage > 0.25) then
			{
				if (_unit getVariable ["helping",false]) then
				{
					_unit setVariable ["cancelRevive",true];
				};
			};
            //Really big hit, seek cover
			if (_damage > 0.6) then
            {
                [_unit,_injurer] spawn A3A_fnc_unitGetToCover
            };
		};
	}
	else
	{
		if (_damage >= 1) then
		{
			if !(_part in ["arms","hands","legs"]) then
			{
				_damage = 0.9;
				if (_part == "head" || _part == "body") then
				{
                    if (!(_unit getVariable ["incapacitated",false])) then
                    {
                        _unit setVariable ["incapacitated",true,true];
                        _unit setUnconscious true;
                        if (vehicle _unit != _unit) then
                        {
                            moveOut _unit;
                        };
                        if (isPlayer _unit) then
                        {
                            _unit allowDamage false
                        };
                        [_unit,_injurer] spawn A3A_fnc_unconsciousAAF;
                    };
                    //Remove helmet if hit
					if (_part == "head" && (getNumber (configfile >> "CfgWeapons" >> headgear _unit >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") > 0)) then
					{
						removeHeadgear _unit;
					};
				};
			};
		};
	};
};

_damage
