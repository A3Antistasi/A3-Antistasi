class A3A
{
	class Base
	{
		class addHC {};
		class addTimeForIdle {};
		class AILoadInfo {};
		class attackAAF {};
		class blackout {};
		class buildHQ {};
		class citiesToCivPatrol {};
		class citySupportChange {};
		class commsMP {};
		class createControls {};
		class createOutpostsFIA {};
		class createPetros {};
		class deleteControls {};
		class destroyCity {};
		class distances4 {};
		class distanceUnits {};
		class economicsAI {};
		class ejectPvPPlayerIfInvalidVehicle {};
		class FIAradio {};
		class findBasesForConvoy {};
		class findNearestGoodRoad {};
		class flagaction {};
		class fn_location {};
		class fogCheck {};
		class garbageCleaner {};
		class garrisonInfo {};
		class intelFound {};
		class isFrontline {};
		class isTheSameIsland {};
		class keys {};
		class localizar {};
		class logPerformance {};
		class markerChange {};
		class moveHQ {};
		class mrkUpdate {};
		class mrkWIN {};
		class NATOFT {};
		class numericRank {};
		class onHeadlessClientDisconnect {};
		class onPlayerDisconnect {};
		class outpostDialog {};
		class patrolDestinations {};
		class placementSelection {};
		class playerHasBeenPvPCheck {};
		class powerCheck {};
		class powerReorg {};
		class prestige {};
		class punishment {};
		class radioCheck {};
		class rebuildAssets {};
		class relocateHQObjects {};
		class repairRuinedBuilding {};
		class resourceCheckSkipTime {};
		class resourcesFIA {};
		class returnMuzzle {};
		class revealToPlayer {};
		class scheduler {};
		class sellVehicle {};
		class sizeMarker {};
		class statistics {};
		class stripGearFromLoadout {};
		class teleportVehicleToBase {};
		class timingCA {};
		class translateVariable {};
		class undercover {};
		class unlockVehicle {};
		class zoneCheck {};
	}

	class AI
	{
		class AAFKilledEH {};
		class airdrop {};
		class AIreactOnKill {};
		class airstrike {};
		class artillery {};
		class artySupport {};
		class askHelp {};
		class assaultBuilding {};
		class attackDrillAI {};
		class autoHealFnc {};
		class autoLoot {};
		class autoRearm {};
		class canConquer {};
		class canFight {};
		class chargeWithSmoke {};
		class coverage {};
		class destroyBuilding {};
		class doFlank {};
		class enemyList {};
		class entriesLand {};
		class fastrope {};
		class findSafeRoadToUnload {};
		class guardDog {};
		class hasRadio {};
		class help {};
		class hideInBuilding {};
		class inmuneConvoy {};
		class isBuildingPosition {};
		class landThreatEval {};
		class mineSweep {};
		class mortarDrill {};
		class mortarSupport {};
		class mortyAI {};
		class napalm {};
		class napalmDamage {};
		class nearEnemy {};
		class rearmCall {};
		class recallGroup {};
		class smokeCoverAuto {};
		class staticAutoT {};
		class staticMGDrill {};
		class suppressingFire {};
		class surrenderAction {};
		class typeOfSoldier {};
		class undercoverAI {};
		class unitGetToCover {};
		class useFlares {};
		class VANTinfo {};
		class vehicleMarkers {};
	}

	class CREATE
	{
		class AAFroadPatrol {};
		class airportCanAttack {};
		class AIVEHinit {};
		class cargoSeats {};
		class CIVinit {};
		class civVEHinit {};
		class cleanserVeh {};
		class createAIAirplane {};
		class createAICities {};
		class createAIcontrols {};
		class createAIOutposts {};
		class createAIResources {};
		class createCIV {};
		class createFIAOutposts2 {};
		class createSDKGarrisons {};
		class createSDKgarrisonsTemp {};
		class CSATpunish {};
		class FIAinitBases {};
		class garrisonReorg {};
		class garrisonSize {};
		class garrisonUpdate {};
		class groupDespawner {};
		class milBuildings {};
		class minefieldAAF {};
		class mortarPos {};
		class NATOinit {};
		class patrolCA {};
		class patrolReinf {};
		class reinforcementsAI {};
		class remoteBattle {};
		class removeVehFromPool {};
		class spawnGroup {};
		class vehAvailable {};
		class VEHdespawner {};
		class wavedCA {};
	}

	class Debugging
	{
		class deleteEmptyGroupsOnSide {};
		class spawnDebuggingLoop {};
	}

	class Dialogs
	{
		class mineDialog {};
	}

	class Garage
	{
		//Public API - Call these to do things
		class garage {file="Garage\garage2.sqf";};
		class garageVehicle {file="Garage\garageVehicle.sqf";};
		class placeEmptyVehicle {file="Garage\placeEmptyVehicle.sqf";};
		class vehPlacementBegin {file="Garage\vehPlacementBegin.sqf";};
		class vehPlacementCallbacks {file="Garage\vehPlacementCallbacks.sqf";};
		class vehPlacementCancel {file="Garage\vehPlacementCancel.sqf";};
		class vehPlacementChangeVehicle {file="Garage\vehPlacementChangeVehicle.sqf";};
		//Garage modifiers, public API
		class addToPersonalGarage {file="Garage\personalGarage\addToPersonalGarage.sqf";};
		class addToPersonalGarageLocal {file="Garage\personalGarage\addToPersonalGarageLocal.sqf";};
		class getPersonalGarage {file="Garage\personalGarage\getPersonalGarage.sqf";};
		class getPersonalGarageLocal {file="Garage\personalGarage\getPersonalGarageLocal.sqf";};
		class setPersonalGarage {file="Garage\personalGarage\setPersonalGarage.sqf";};
		class setPersonalGarageLocal {file="Garage\personalGarage\setPersonalGarageLocal.sqf";};
		//Private - Do NOT call these elsewhere
		class attemptPlaceVehicle {file="Garage\private\attemptPlaceVehicle.sqf";};
		class displayVehiclePlacementMessage {file="Garage\private\displayVehiclePlacementMessage.sqf";};
		class handleVehPlacementCancelled {file="Garage\private\handleVehPlacementCancelled.sqf";};

		class vehPlacementCleanup {file="Garage\private\vehPlacementCleanup.sqf";};
	}

	class Missions
	{
		class attackHQ {file="Missions\attackHQ.sqf";};
		class deleteTask {file="Missions\deleteTask.sqf";};
		class missionRequest {file="Missions\missionrequest.sqf";};
		class missionRequestAUTO {file="Missions\missionrequestAUTO.sqf";};
		class taskUpdate {file="Missions\taskUpdate.sqf";};
		class underAttack {file="Missions\underAttack.sqf";};
	}

	class Ammunition
	{
		class ACEpvpReDress {file="Ammunition\ACEpvpReDress.sqf";};
		class arsenalManage {file="Ammunition\arsenalManage.sqf";};
		class CSATCrate {file="Ammunition\CSATCrate.sqf";};
		class ammunitionTransfer {file="Ammunition\ammunitionTransfer.sqf";};
		class NATOCrate {file="Ammunition\NATOCrate.sqf";};
		class randomRifle {file="Ammunition\randomRifle.sqf";};
		class dress {file="Ammunition\dress.sqf";};
		class empty {file="Ammunition\empty.sqf";};
		class getRadio {file="Ammunition\getRadio.sqf";};
		class checkRadiosUnlocked {file="Ammunition\checkRadiosUnlocked.sqf";};
		//class boxAAF {file="Ammunition\boxAAF.sqf";};
	}

	class OrgPlayers
	{
		class assigntheBoss {file="orgPlayers\assignStavros.sqf";};
		class donateMoney {file="orgPlayers\donateMoney.sqf";};
		class isMember {file="orgPlayers\isMember.sqf";};
		class memberAdd {file="orgPlayers\memberAdd.sqf";};
		class membersList {file="orgPlayers\membersList.sqf";};
		class playerScoreAdd {file="orgPlayers\playerScoreAdd.sqf";};
		class ranksMP {file="orgPlayers\ranksMP.sqf";};
		class resourcesPlayer {file="orgPlayers\resourcesPlayer.sqf";};
		class theBossInit {file="orgPlayers\stavrosInit.sqf";};
		class theBossSteal {file="orgPlayers\stavrosSteal.sqf";};
		class tierCheck {file="orgPlayers\tierCheck.sqf";};
	}

	class REINF
	{
		class addBombRun {file="REINF\addBombRun.sqf";};
		class addFIAsquadHC {file="REINF\addFIAsquadHC.sqf";};
		class addFIAveh {file="REINF\addFIAveh.sqf";};
		class addSquadVeh {file="REINF\addSquadVeh.sqf";};
		class autoGarrison {file="REINF\autoGarrison.sqf";};
		class build {file="REINF\Building\build.sqf";};
		class buildCreateVehicleCallback {file="REINF\Building\buildCreateVehicleCallback.sqf";};
		class buildMinefield {file="REINF\buildMinefield.sqf";};
		class enemyNearCheck {file="REINF\enemyNearCheck.sqf";};
		class FIAinit {file="REINF\FIAinit.sqf";};
		class FIAskillAdd {file="REINF\FIAskillAdd.sqf";};
		class garrisonAdd {file="REINF\garrisonAdd.sqf";};
		class garrisonDialog {file="REINF\garrisonDialog.sqf";};
		class NATObomb {file="REINF\NATObomb.sqf";};
		class NATOQuadbike {file="REINF\NATOQuadbike.sqf";};
		class postmortem {file="REINF\postmortem.sqf";};
		class reDress {file="REINF\reDress.sqf";};
		class reinfPlayer {file="REINF\reinfplayer.sqf";};
		class vehiclePrice {file="REINF\vehiclePrice.sqf";};
		class vehStats {file="REINF\vehStats.sqf";};
	}

	class Revive
	{
		class actionRevive {file="Revive\actionRevive.sqf";};
		class fatalWound {file="Revive\fatalWound.sqf";};
		class handleDamage {file="Revive\handleDamage.sqf";};
		class handleDamageAAF {file="Revive\handleDamageAAF.sqf";};
		class unconscious {file="Revive\unconscious.sqf";};
		class unconsciousAAF {file="Revive\unconsciousAAF.sqf";};
		class initRevive {file="Revive\initRevive.sqf";};
		class isMedic {file="Revive\isMedic.sqf";};
		class respawn {file="Revive\respawn.sqf";};
	}

	class Runways
	{
		class getRunwayTakeoffForAirportMarker {file="getRunwayTakeoffForAirportMarker.sqf";};
		class runwayInfo {file="runwayInfo.sqf";};
	}

	class Save
	{
		class playerHasSave {file="statSave\playerHasSave.sqf";};
		class loadPlayer {file="statSave\loadPlayer.sqf";};
		class savePlayer {file="statSave\savePlayer.sqf";};
		class loadPreviousSession {file="statSave\loadPreviousSession.sqf";};
	}

	class Templates
	{
		class getLoadout {file="Templates\Loadouts\getLoadout.sqf";};
	}

	class Utility
	{
		class basicBackpack {file="Ammunition\basicBackpack.sqf";};
		class dateToTimeString {file="dateToTimeString.sqf";};
	}

	class init
	{
		class getArrayMrks {};
	}
}
