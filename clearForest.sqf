if (player != stavros) exitWith {hint "Only Commanders can order to clean the forest"};
if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [getMarkerPos "respawn_guerrila",["tree","bush"],70])} else {{[_x,true] remoteExec ["hideObjectGlobal",2]} foreach (nearestTerrainObjects [getMarkerPos "respawn_guerrila",["tree","bush"],70])};
hint "You've cleared the surroundigs of trees and bushes";
chopForest = true; publicVariable "chopForest";
