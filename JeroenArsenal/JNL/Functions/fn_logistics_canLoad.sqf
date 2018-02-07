/*
	Author: Jeroen Notenbomer

	Description:
	Returns a node the given object can be loaded on

	Parameter(s):
	OBJECT vehicle
	OBJECT object to load on vehicle

	Returns:
	INTEGER node number where object can be loaded on to
	or -1 if a other type was already loaded
	or -2 if there was no more space
	or -3 if this vehicle can't have any cargo at all
*/

params[ ["_vehicle",objNull,[objNull]], ["_object",objNull,[objNull]] ];

if(isNull _vehicle || isNull _object)exitWith{["Wrong input given veh:%1 ,obj:%2",_vehicle,_object] call BIS_fnc_error;};

private _typeObject  = _object call jn_fnc_logistics_getCargoType; //get _object type

//check current load
private _typeLoaded = -1;
private _nodesLoaded = 0;
{
	private _array = _x getVariable ["jnl_cargo",nil];//returns nr of node if the object was attached by JNL

	if(!isNil "_array")then{
		private _type = _array select 0;
		private _node = (_array select 1)+1;

		_typeLoaded = _type;
		if(_node > _nodesLoaded)then{_nodesLoaded = _node};
	};
} forEach attachedObjects _vehicle;

//cant load 2 different types
if(_typeLoaded != _typeObject && _typeLoaded != -1)exitWith{-1};


//available nodes
private _nodeTotal = 0;
{
	private _type = _x select 0;
	private _location = _x select 1;
	if(_type == _typeObject)then{_nodeTotal = _nodeTotal + 1;};
} forEach (_vehicle call jn_fnc_logistics_getNodes);

if(_nodeTotal == 0)exitWith{-3};

//there is some node free
if(_nodesLoaded < _nodeTotal)exitWith{_nodesLoaded};

//node type is correct but no nodes where free
-2;