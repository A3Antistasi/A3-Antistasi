Changelog
**************





|

-----

|


Version 2.5.3
===============



.. note::
   10th October 2021



.. admonition:: Major




   .. rubric:: :issue:`2119` Rework of punishment attacks

   - Punishment attacks no longer sent against occupant-controlled towns.
   - Player scaling added to delay time and attacker vehicle count.
   - Improved vehicle choice and maxUnits control, ensure 2+ transports.
   - Defender ("civilian") count non-linearised, splits to groups of 4.
   - Removed civInit from defenders, so that they shoot and don't affect aggro.
   - Use combat landing in preference to fastrope, remove slow landing.
   - Simplified termination conditions.
   - Results now only adjust support of nearby cities.
   - Destroyed cities are now coloured black on the map.
   - Destroyed cities are now invader-side, to prevent some weird spawning.
   - Destroyed cities no longer switch side, provide rebel HR or resources.



   .. rubric:: :issue:`2121` Rebalanced reinforcements

   - Balance reinforcement system for player count.
   - Enable reinforcing from "carriers".
   - Separate road patrol generation from reinforcements and rebalance.
   - Sanitize garrison sizes (fewer giant and tiny garrisons, units of 4 rather than 8).
   - Use more 4-man teams in garrisons for both init and reinf.
   - Prevent new reinf convoys spamming after a recapture.
   - Fill out the AA & AT squads with a fourth soldier, cap militia squads to 8.



   .. rubric:: :issue:`2124` Added player-count based balance for QRFs / singleAttack / wavedCA




.. admonition:: Minor


   .. rubric:: :issue:`2107` Garaging now only is possible at locations with flipable flags and at HQ

   - Airports, outposts, Seaports, Factories, Resources



   .. rubric:: :issue:`2126` Updated the VN templates based on the SOG Prairie Fire update 1.1



.. admonition:: Groundwork


   .. rubric:: :issue:`2081` - :issue:`2137` Implements logging of logs over the char limit and arrays



   .. rubric:: :issue:`2112` Changed Civ detection for support-choosing to city+house detection

   - Occupants are not bombing as much cities anymore



.. admonition:: Refactor


   .. rubric:: Converted functions.hpp tabs to spaces



.. admonition:: Bugfixes


  * :issue:`2100` Fixed inability to garage vehicles when player host was inside a vehicle
  * :issue:`2102` Moved singleAttack and patrolReinf logging to server
  * :issue:`2103` Fixed fastrope spawning corpses underground after being hit whilst fastroping
  * :issue:`2105` Fixed allowCrewInImmobile not being applied to convoy vehicles
  * :issue:`2106` Fixed vehicle pools not being properly saved
  * :issue:`2107` Vehicles near HQ now also have state preservation
  * :issue:`2109` Made HC squad vehicle placement use the garage placing code
  * :issue:`2109` Fixed broken object carrying
  * :issue:`2110` Fixed scaling and bugs plus added logging on economicsAI
  * :issue:`2111` Fixed Petros having no ammunition by giving him a vest
  * :issue:`2113` Fixed QRFs and singleAttacks being limited by incorrect maxUnits check
  * :issue:`2116` Fixed simulated attacks massively overfilling garrisons
  * :issue:`2120` Added more explanations to parameters
  * :issue:`2125` Fixed multiple issues regarding mortar type checking and locality
  * :issue:`2131` Fixed typos and punctuations in customHints
  * :issue:`2135` Fixed incorrect attack countdown incrementing
  * :issue:`2136` Fixed imbalance between the difficulty settings
  * :issue:`2141` Fixed bad exitWith in resourceCheck causing incorrect losses
  * :issue:`2144` Fixed degenerate behaviour in rebelAttack
  * :issue:`2147` Reduced capture response delay time
  * :issue:`2148` Fixed airborne troops being able to flip flags
  * :issue:`2149` Fixed exploit where commander could become permanently undercover
  * :issue:`2151` Fixed multiple bugs with squad/vehicle pricing
  * :issue:`2156` Fixed garage feedback displaying on wrong clients
  * :issue:`2157` Added setOvercast functionality on rain-removal
  * :issue:`2157` Fixed lamp drop action not being added after respawn
  * :issue:`2158` Fixed not removing undercover status when placing ACE explosives
  * :issue:`2160` Fixed Nato gunship support

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.5.2
===============

.. note::
   27th August 2021



.. admonition:: Major


   * none

.. admonition:: Minor


   * none

.. admonition:: Groundwork


   * none

.. admonition:: Refactor


   * none

.. admonition:: Bugfixes


   .. rubric:: :issue:`2067` Prevent bad unit types being added to garrisons, repairs corrupted saves

   - childproofs the system and fixes loading issues on saves with problematic garrisons



   .. rubric:: :issue:`2078` :issue:`2085` Resolved JIP conflict between logistics and garrison static actions



   .. rubric:: :issue:`2077` Changed zoneCheck to use marker size based capture radius

   - radius is decreased and distance to marker is taken into account
   - people close to the marker can outnumber more people further away from the marker



   .. rubric:: :issue:`2075` Fixed missing return value on actionRevive



   .. rubric:: :issue:`2066` Fixed issues with the buyable light



   .. rubric:: :issue:`2068` Changed garage addVehicle checks order

   - also fixes the issue that vehicles could be garaged everywhere with enemies nearby



   .. rubric:: :issue:`2084` Fix vehicle kill event handler

   - vehicle kill handler got broken in an Arma update, so vehicle kills were not being registered for any purpose



   .. rubric:: pressing Y (opening the battle menu) during placing cancels the placement



   .. rubric:: Improved garaging consistency and reliability

   - prevents cases of items from vehicle arsenal getting lost when garaging

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.5.1
===============

.. note::
   12th August 2021



.. rubric:: Major


* none

.. rubric:: Minor


* blocked rebel auto capture - player needs to take the flag manually
* ability to toggle on/off the the top bar by using ALT + Home plus disabling the top bar in the garage
* added buyable lightsource on the vehicle box for 25€
* updated feedback for vehicleBoxHeal

.. rubric:: Groundwork


* none

.. rubric:: Refactor


* none

.. rubric:: Bugfixes


* fixed addVehicleClass lacking source detection
* fixed missing remoteExec target causing RPT span in task delete
* fixed missing time param in punishment
* fixed 2.4.x garrisons not being compatible with 2.5.x
* fixed loophole where fog can be broken
* fixed attackHQ transport planes

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.5.0
===============

.. note::
   10th August 2021



.. rubric:: Major


* singleplayer is disabled for all the missions - please switch to local hosted multiplayer to continue your savegame
* implemented new Garage (under APL-ND license, not MIT) - The new garage is a shared garage that replaces both the personal and faction garage.
    It features full 3D inspection, vehicle state preservation, visual vehicle customisation, vehicle locking, vehicle services, and logistics integration.
    Some CBA settings have also been added to let players and admins tweak the garage to their preference.
* implemented Street Artist Navigation Grid Editor (tool for map porting) and changed all systems to work with new navGrids (under APL-ND license, not MIT)
* fully implemented the SOG Prairie Fire (VN) release into the main repo
* added new faction templates for 3CB mods
   * MDF, New Default Occupants on Malden
   * HIDF, New Default Occupants on Tanoa
   * AAF, New Default Occupants on Altis
   * ANA, New Default Occupants on Kunduz (Since its Afghanistan)
   * ADA, currently unused
* adapted main license - please read when planning to rework and publish this mission

.. rubric:: Minor


* added ACRE2 items to be given/distributed correctly
* added dynamic crewing for rebel garrison statics
* added full TFAR BETA compatibility
* Convoy mission rework
* expanded starting gear for VN
* added VN weapon category filtering
* Cam Lao Nam map update
* Dressup Simulator - added uniforms, headgear, glasses to templates
   * direct lists for uniforms used by civs
   * rebell uniforms given to arsenal
   * headgear given to civs
   * headgear given to rebell AI
* updated Simplified Chinese translation
* added garbage clean timer to game info
* updated AFRF templates with content from RHS update
* replaced vanilla militia MRAPS with HMG offroads
* Tunguska got removed from 3CB Factions templates

.. rubric:: Groundwork


* updated AI minefield stuff
* improved performance of distanceUnits
* added SignalSmokeGrenates and FlagMarkerType to templates
* improved logging for bad spawns
* renamed fn_compatibilityLoadFaction and all related references
* implemented type-dependent classes for rebel AIs
* implemented new issue forms on GitHub
* implemented time span types
* moved changelog to main folder

.. rubric:: Refactor


* refactors as preparation of the new UI
* adjusted healAndRepair for new garage system
* generalised hasVN to template variables

.. rubric:: Bugfixes


* fixed punishment missions spawning more than 40 civs
* adjusted spawn vehicle velocity for spawnVehicle
* fix error from equipmentIsValidForCurrentmodset
* fixed references to FlagCarrier for VN flagpoles
* changed VN lootboxes to vanilla lootboxes because of incorrect maximumLoad in configs
* fixed bug with maxunits code deleting cargoless vehicles
* fixed logistics issues for VN
* deleted unnecessary bak files
* set max civ amount for punishment-missions
* updated fn_SUP_CASRoutine
* fixed vanilla medical issues (like revive cancel) and implemented VN AI compatibility
* fixed missing aggro penalty for killing surrendered enemies
* spawn related optimizations and bugfixes
* fixed perma lockout in resourceFIA
* cleaned out NVGs
* fixed partial distribution of controlsX
* added isLoadable check and implemented it in AIVehInit
* fixed Support HandleDamage Eventhandlers
* fixed check-order in vehicle sales
* fixed fake launcher magazines being added to loadouts
* fixed a return case in configsorting
* fixed converted explosives from unlocking
* disabled problematic ACE settings
* added null check for logistics unload
* fixed incorrect remoteExec target in AILoadInfo
* fixed and improved FF scripts
* fixed equipRebell to assign correct tools
* fixed order in fastTravel checks
* fixed error in refund system
* fixed ADR DLC issue
* added safety checks to prevent duping
* unified persistent save titles
* fixed too high amount of civs in North Hanoi (Cam Lap Nam)

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.4.1.VN.03
=====================

.. note::
   29th June 2021



.. rubric:: Major


* none

.. rubric:: Minor


* none

.. rubric:: Groundwork


* none

.. rubric:: Refactor


* none

.. rubric:: Bugfixes


* fixed punishment missions spawning more than 40 civs

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.4.1.VN.02
=====================

.. note::
   15th May 2021




.. rubric:: Major



* GAMEPLAY CHANGES
* none

* PARAMETER CHANGES
* none

* MAP CHANGES
* small adaptations to Cam Lao Nam

* OTHER CHANGES
* none

.. rubric:: Minor


* expanded starting gear with VN modset

.. rubric:: Groundwork


* none

.. rubric:: Refactor


* none

.. rubric:: Bugfixes


* fixed FirstAidKits not available
* adapted DLC filtering
* fixed error from equipmentIsValidForCurrentmodset
* fixed references to FlagCarrier so VN flagpoles are working
* for the time being changed loot boxes to plastic boxes from vanilla as the VN boxes have infinite inventory space
* fixed AI medical functionality so it works with VN medic assets
* adapted VN weapon category filtering
* fixed revive animation not stopping when cancelled

.. rubric:: Code


* none

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.4.1.VN.01
=====================

.. note::
   06th May 2021




.. rubric:: Most significant changes with description



* S.O.G. Prairie Fire compatibility
   * adaptation of the CDLC map Cam Lao Nam
   * generation of templates based on the CDLC assets including logistic nodes
   * compatibility with milbuildings, radiotowers, AA-spawnplaces etc.
   * removal of vanilla items when VN enabled (medical, engineer,..)
   * adaptation for intel system

.. rubric:: Major



* GAMEPLAY CHANGES
* none

* PARAMETER CHANGES
* added parameter for VN (needs to be enabled to play Cam Lao Nam with the CDLC assets)

* MAP CHANGES
* NEW MAP - Cam Lao Nam ... duuh

* OTHER CHANGES
* none

.. rubric:: Minor


* disabled VN dynamic radio music at bases and such
* disabled flyGear and diveGear when VN active
* helicopters can now perform airstrikes
* VN radios are recogniced as radios.

.. rubric:: Groundwork


* adaptation of FSMs from 3D to 2D nav grids.

.. rubric:: Refactor


* improved mod autodetection item sorting for VN

.. rubric:: Bugfixes


* fix for tree-hugging helis

.. rubric:: Code


* implemented script that changes the aperture to make the map more playable at night

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.4.1
===============

.. note::
   30th April 2021



.. rubric:: Major



* GAMEPLAY CHANGES
* removed PvP

* PARAMETER CHANGES
* removed two PvP related parameters

* MAP CHANGES
* none

* OTHER CHANGES
* added support for TFAR BETA

.. rubric:: Minor


* added smoke trails to artillery/mortar and enhanced impact radius

.. rubric:: Groundwork


* none

.. rubric:: Refactor


* none

.. rubric:: Bugfixes


* fixed being able to add Petros to garrison
* fixed town markers not being placed on roads and therefore fixing related issues
* improvements to mission request and therefore fixing issues like ammo truck missions spawning at already spawned outposts
* fixed troops being deleted when adding to unspawned garrisons
* fixed rebel city garrisons not spawning
* added new and fixed prior logistic nodes for 3CB Faction assets
* added missing and deleted incorrect 3CB BAF assets
* added missing unarmed loadouts which for example caused invader punishment missions to auto-complete
* defending civs in punishment missions are now using unlocked weapons instead of hardcoded vanilla weapons
* disabled gunship unless vanilla
* fixed uncorrect variable in unlockEquipment logging
* fixed a check in SUP_QRFAvailable
* fixed function for saved vehicle positions
* fixed createVehicleCrew leader selection
* separated task types from IDs to fix multiple task bugs
* removed ACE loading from BoxX
* fixed broken description.ext's for Sahrani, Takistan and Chernarus_winter
* fixed AI having no vanilla-med items with ACE-non-medical loaded
* synchronised vehicle textures
* fixed various locality and JIP issues with prisoners and refugee missions
* fixed QRF APCs and transport aircraft using the wrong behaviour
* fixed safeVehicleSpawn to spawn air vehicles in the air

.. rubric:: Code


* logs are now being created with logMacros
* updated mod detection
* prestige was renamed to aggro as the naming was incorrect and confusing
* updated debug list with current IDs
* added info for BattlEye compatibility

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.4.0
===============

.. note::
   21st March 2021



.. rubric:: Most significant changes with description



* LTC
   * The Loot to crate system is a new system implemented to allow for faster and less bothersome looting experience while still keeping balance with the new support system.
      This system allows you to use the surrender crates of enemies to quickly and easily loot the aftermath of battles, buy gathering nearby loot from enemies and on the ground in to the crate. In addition to this you can also load the contents of the crates into the inventory of vehicles and the crates themselves can be loaded onto vehicles.
      To make things even easier you can now also purchase these crates at the vehicle box at HQ for 10€, and you can also refund these crates by storing them in the garage.
      Happy looting!

* New support system
   * Gave the AI the tools to fight any kind of rebel attack in a fun and interesting way.
      Watch them bring tank killer planes against your vehicles, air superiority fighter against your helicopters and heavy gunships against infantry positions. If you hear the brrrt, it is already too late.

* New navGrid system
   * Completely redid the antistasi internal pathfinding mechanics, enabling us to utilize roads more and better, as we can ensure that the AI does not decide to drive the tank through half a kilometer of wood any more. At least in most cases.

* New template system
   * The new template system allows modders to quickly and easily set up new, highly customized factions by listing the vehicles and equipment available. These new templates introduce enemies which wield a larger variety of weapons and gear, providing more diverse opponents and a greater variety of tools to fight back against the oppressors.
      These new templates also lay the groundwork for allowing any faction to be used as either the occupants or invaders, or pitting factions from different mods against each other. However, right now this functionality is experimental and will be enabled fully in a later release.

* MIE
   * The MIE project seeked to centralise the process of mod integration, taking the various changes necessary to make a new mod function within the mission away from the important code files and into dedicated areas within the template folder. This makes new mod integration much safer and more accessible to people less confident or knowledgeable in SQF.
      There are, however, some sections that have yet to be centralised however, such as loot and supports, but most of the important sections, such as mod detection, templates and template selection, and logistic nodes have all been covered by the MIE project.

.. rubric:: Major



* GAMEPLAY CHANGES
    * BLUFOR is discontinued as it will be obsolete with the new template system
            This ability to switch functions is not yet completely integrated and is lacking a plug and play interface. We will deliver that in the next versions.
    * Local singleplayer got disabled    * please play locally hosted MP
            To make your lives a little bit easier, we gave the default commander slot the ability to be a medic and an engineer at the same time, so you can do everything you need to. Further balances will come in the next versions.

* PARAMETER CHANGES
    * added parameters for the new support system
    * added parameters for the LTC system
    * added parameter to enable/disable Art of War content within the mission
    * added option 1,000,000 to unlock parameters to have no unlocked assets anymore

* MAP CHANGES
    * NEW MAP: Antistasi Sahrani added
    * NEW MAP: Antistasi Takistan added
    * Kunduz has two custom bridges now
    * Malden has a new outpost to fill a gap and provide an extra point to attack
    * Fixed some helipads on outposts on Malden as the AI was unable to perform with the given assets

* OTHER CHANGES
    * snow script was removed as it was broken and deactivated for quite some time
    * RDS vehicle compatibility integrated
    * D3S vehicle compatibility integrated
    * Ivory cars vehicle compatibility integrated
    * added ADV support
    * All the startup messages got removed
    * Napalm effect overhauled and re-enabled
    * Paradrop approach reworked into something actually resembling a paradrop
    * Combat landing approach for helicopters reworked, they are now faster and more precise

.. rubric:: Minor


* replaced heightmaps on whiteboards with satellite pics
* added templated surrender and salvage crates
* added buyable AA vehicles to all templates
* more russian translations in the stringtable
* added airstrike conversion to airfields
* added "stop rain" function on the tent
* added multilingual support for Dialog Menu
* added small trees to "clear forest"
* more vehicles can now be sold
* autosave now delayes after a manual save
* loot crate respawns are now limited - no crate farming possible anymore
* when a commander now buys a vehicle, the faction money is used instead of the personal money
* influence of loosing radiotowers is minimized
* added radiobagpacks to item sorting
* optimised mission root path parsing
* allow commander and admins to edit game options plus logging of changes
* improvements within the FF scripts as well as the logging

.. rubric:: Groundwork


* moved non-map-specific items from description.ext to MissionDescription to decrease mission-size and loading-time
* overhauled hint system with easier dismissable hints
* added logging for unlocks
* added first steps of UNSUNG compatibility - not playable yet
* added first steps of FFAA compatibility - not playable yet
* added list of global UI vars and UI processes
* added nestedObject wrapping for createNamespace
* parameters now are saved from the initial load and are carried over after restarts

.. rubric:: Refactor


* fn_typeOfSoldier
* fn_distance
* mod detection system
* initVarCommon to get rid of obsolete content

.. rubric:: Bugfixes


* towing of logistics cargo is now blocked
* dead units no longer blocking statics which are mounted
* added towing check for garaging vehicles
* added a bunch of new assets to the garbage clean
* fixed duplication exploits
* you can't sell Petros anymore
* fixed spam sell vehicle exploit
* removed servicing container from 3CB vehicle array
* fixed duplication of single mags
* fixed salvage rope
* fixed captive state being stripped from handcuffed units when waking up
* fixed missions spawning outside of the map borders
* fixed issue with players being able to load assets which are not in the arsenal
* fixed the state of city supplies crate not being saved
* fixed fast towing exploit
* fixed garrison spawning in/on destroyed buildings
* fixed teleportation bugs with ff-punishment system
* fixed roadblock issues
* fixed undercover heli exploit
* fixed issues with having UAV terminals from unusable sides in crates
* fixed roadblocks being destroyed on engagement
* minimized the amount of errors thrown from fnc_createCIV
* removed city supplies box from saving

.. rubric:: Code


* introduced log level integration with logMacros

.. warning::


   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.3.2
===============

.. note::
   05th December 2020



.. rubric:: Bugfixes



* Fixed the rope issue in the salvage mission
* Disabled two towns (Kuusela and Niemela) on the Virolahti map

.. warning::


   * Significant template changes are still underway. You might want to avoid making custom templates for a while!
   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.3.1
===============

.. note::
   16th October 2020



.. rubric:: Major



* GAMEPLAY CHANGES
* Implemented new hint system with dismissable hints
* Implemented out-of-bounds kill zone

* PARAMETER CHANGES
* Removed "Reb vs Inv" option from gamemode parameter

* MAP CHANGES
* Altis - new position for initial HQ and other small changes

* OTHER CHANGES
* Added Korean translation

.. rubric:: Minor


* FF-system changes and improvements
* Some assets changed for 3CB modset
* added new asset for citysupply mission
* Added new ACE settings
* Small template changes and bugfixes
* Added CUP/Enoch buildings for intel system and AA placements

.. rubric:: Groundwork


-

.. rubric:: Refactor


* missionRequest refactor

.. rubric:: Bugfixes


* Taken assassination missions from the RNG array
* Added failsafe for artillery spawn breaking
* Failsafe for findEmptyPosition for desHeli mission
* Added seaports to list of markers that break undercover
* Fixed arsenal exploits
* Fixed issues in missionrequest
* Fixed killZones issue where no QRF could be deployed
* Fixed setWaypointStatements
* Preventet equipping zero-count items from the arsenal
* Fixed Tanoa attack bugs
* Fixed surrender/release code
* Fixed initClient running on HCs
* Fixed road search bugs
* Fixed non-hosted rebel airstrikes
* patrolReinf termination overhaul

.. rubric:: Code


* Added bugfix branch to Travis

.. warning::


   * Significant template changes are still underway. You might want to avoid making custom templates for a while!
   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.3.0
===============

.. note::
   26th July 2020



.. rubric:: Most significant changes with description



Overhauled airstrikes to keep the sanity:
* Halved the number of bombs in any given airstrike, Made the bombs used more sensible. (MK82 for HE, CBU for cluster, Glide bomb for napalm.

New Salvage Mission implemented:
* In this new mission a ship bound for the rebellion with supplies have been discovered and sunk just off the coast, these supplies are now at the bottom of the sea and about to be recovered by the hostile forces that sunk it in the first place. But all hope is not yet lost, we have a shot window of opportunity to recover theses supplies, by diving down and winching the supplies from the bottom of the sea right underneath their noses. Time is of the essence so hurry and locate a suitable boat with a winch like the motorboat and get our supplies back.

Introduced new Aggro and Warlevel system
* Aggression is now displayed better, synched correctly and actual playable. Say goodbye to steady 100 aggression.

Adapted QRFs and attacks
* Adapted vehicle selection for QRFs. The heavier the unit, the later it will arrive in the game.
* Adapted vehicle amount for QRFs and attacks. These are now heavily dependant on the aggression of the attacking faction. Doesn't mean you wont get overrun sometimes.

Introduced a new Intel system
* Search enemies and locations for valuable intel on the enemy faction. But be aware that there is nothing without a risk.

Temporary blackscreen for singleplayer
* As we in the future will seize SP compatibility we have implemented a blackscreen which pops up when joining a SP campaign so players are informed regarding that. The blackscreen only lasts a few seconds and currently people are still able to continue and finish their campaigns.
* Please note that we advice to play locally hosted MP even if you only want to play on your own. This is more stable, has less bugs and gives you the possibility to adapt parameters to your liking.

Implemented Jeroen Nots Enhanced Debug Console
* We added an enhanced debug console in which you can save debug commands. To set a name for a saved command, add a comment in the first line. Example: //ThisIsaTitle

.. rubric:: Major



* GAMEPLAY CHANGES
* New salvage mission integrated
* Reintroduced fuel trucks as spawning civ vehicles
* Introduced new Aggro and Warlevel system
* Deactivated IFA compatibility
* Introduced a new Intel system

* PARAMETER CHANGES
* Introduced more understandable descriptions for unlockItem and allowFT

* MAP CHANGES
* Chernarus summer overhauled with added assets
* Chernarus winter overhauled with added assets
* Livonia overhaul with building adaptations
* General small overhauls/adaptations for every other map

* OTHER CHANGES
* Implemented Jeroen Nots Enhanced Debug Console
* Temporary blackscreen for singleplayer
* Added Czech translation
* Added French translation

.. rubric:: Minor


* Deactivated forced TFAR default radioVolume
* Added PvP role descriptions
* Replaced the ingame Antistasi logos on the whiteboard with corresponding heightmaps of the currently played map
* Added PvP loadout for Takistanis (3CB)
* Petros now can be moved around like the other HQ assets
* Added stamina reset to the heal box at HQ
* Increased boat placement radius at HQ
* Removed thermals from unlocking on Vanilla
* Deactivated ACE options on the vehicleBox
* Overhauled airstrikes to keep the sanity
* Overhauled airport marker colours
* Removed Civ uniforms as well as such things as IDAP clothing
* Added more assets to garbage clean
* 3CB template overhaul (added new assets)
* Fixed starting items for night combat compatibility
* Fixed mission dates so the first night has a full moon
* Adapted QRFs and Heli responses so they are working with the new system and more reasonable/balanced
* Vehicle mass changes when cargo is un/-loaded
* Added flight suits to airport crates
* Improved static placement in milBuildings
* Changed infinite personal garage to limited (including parameter)
* Enhanced storing capabilities of faction garage
* Implemented boundaries to garaging capabilities (distance & enemies)
* Disabled unlocking of M152 remote detonator from start

.. rubric:: Groundwork


* Updated ACRE compatibility
* Updated performance logging in the RPTs
* Changed folder structure so all map related assets are in the map template folders
* Added information to distinguish between sources (Server, Client, HC) in the logs
* Unified the functions for the lootcreate creation
* Added documentation in countCA
* Removed ADV integration as it's not updated anymore
* Improved template selection system

.. rubric:: Refactor


* Refactor of Antenna stuff in initZones
* Refactor of fn_rebelAttack
* Refactor of the hint system
* Refactor of AIVEHinit
* Refactor/recrite of patrolCA
* Refactor/rewrite of wavedCA

.. rubric:: Bugfixes


* Money exploit regarding AI refunds
* Contact report issue with ACE
* Livonia invisible buildings
* Wrong magazine type in SDKMortar Reb_CDF
* Incorrect faction names in outpost and airport markers
* Bugs and performance issues with civ vehicles
* RHS civ ural not detected as civ vehicle
* RHS doomsday rounds still spawning
* More money exploits
* Wrong message for end mission in some cases
* Commander role vanishing
* Visibility of commander eligibility hints
* Status bar breaking when controlling AIs
* Give command to "cursor target" not working
* IFA civ trucks not being recognized
* Non-blufor crew in blufor vehicle
* stupid crashing airstrike planes because flying too low
* Lootcrates can be loaded whilst being undercover
* Tent retains velocity when being moved
* Debug log for NATOcrate not working properly
* Error in JN_fnc_logistigs_getCargoOffsetAndDir
* Darter drone can be sold for airstrikes
* War level calculation
* Disabled snow script because it breaks servers
* CsatPlaneAA-AFRF issue
* Breaching script issue with RHS
* Startup loading issues in local hosted MP
* Error in the traitor mission script
* Error in A3A_fnc_savePlayer
* Error in A3A_fnc_randomRifle
* Error in SelectIntel
* Error in waved CA
* Broken spawn distance decrease button
* Surrendered soldiers and crates not vanishing
* WW2 Ai weapon choice
* Backwards winner/loser params
* startWithLongRangeRadio not set in SP
* ACE not overwriting the Antistasi revive system
* Petros has "build HQ" option at start of campaign
* Disappearing RHS headgear
* Leaking groups in createSDKGarrisons
* Refilling crates which were already emptied after restart
* Filled ammo trucks after ungaraging
* Multiple arsenal issues regarding loadouts and sorting
* Added missing global variable for CSATRepairTruck
* Fixed inventory transfer for planes and helis
* Fixed misleading text for loading previous save
* Fixed 3CB ammo being eaten by the arsenal
* JNL adaptations for certain vehicles
* Fixed double-savings on global saves
* Fixed orphaned and inaccessible saves
* Fixed marker and flag bugs
* Fixed disappearing vehicles
* Fixing outposts needing a road to spawn the truck for the crate
* Fixed addGarrison variables fucking up
* Fixed diving gear spawn
* Fixed Arsenal exploit based on Armas inability to count
* Deleted vanilla units in RHS modset
* Improved texts for reinforcement convoy markers which are revealed through intel
* Fixed navGrid issues with headless clients
* Fixed convoy depart timer
* Fixed convoy spawning as they went poof a lot
* Fixed Arsenal dublication exploit
* Fixed Hangar spawn issue
* Fixed AA vehicles not being breachable
* Fixed airstrike issues
* Disabled some ACE Group Actions to prevent exploiting
* Moved VTOLs from helo array to plane array
* Fixed civ vehicles not being usable as undercover
* Fixed leadership issue with enemy AI
* Deactivated enemy patrols from spawning in units (was a reason for AI clutter)
* Fixed police cars not getting filled with enemy AI
* Fixed issue with picked up radios not changing to 5km versions
* Addes seaSpawn and seaPatrol markers to Chernarus Summer and Chernarus Winter
* Fixed Island markers for Tanoa
* Fixed slot order for all maps (now greenfor is being shown initially)

.. rubric:: Code


* Enhanced Travis for build checking

.. warning::


   * Significant template changes are still underway. You might want to avoid making custom templates for a while!
   * Please note that this changelog may contain both spelling/grammatical errors and/or factual errors. Should any factual errors exist, we apologise but with the sheer number of changes made per version it can be easy to lose or mistake a change when writing up the changelog.




|

-----

|


Version 2.2.1
===============

.. note::
   07th February 2020



.. rubric:: Major



* GAMEPLAY CHANGES
* Re-enabled unit traits.

* PARAMETER CHANGES
* Created parameter to allow unlock of LRs from the start (only regarding TFAR LRs)

* MAP CHANGES (OLDER MAPS WILL NO LONGER WORK WITH 2.2 OR ABOVE)
* Added assets to positions like outposts on Chernarus Winter.
* Changed vehicle placement on Tanoa positions.
* Every map now only has 32 slots on the rebel side. Reason: Performance.

.. rubric:: Minor


* Disabled unlocked IEDs in Vanilla arsenal.
* Changed playable Officer roles to TeamLead roles.
* Enabled further vehicles to be utilized for JNL loading.
* Added ACE spare barrel recognition.

.. rubric:: Groundwork


* Added building from CUP to be recognized as military buildings (also concerning 50. cal placements).

.. rubric:: Bugfixes


* Fixed an exploit where guests could grab certain gear using a loadout.
* Fixed added aggro for hostages/surrenderes.
* Fixed PvP loadout assignment.
* Fixed roadblock creation issue.
* Fixed airstrike issue.
* Fixed RPT spam based on town road setup.
* Fixed vehicle saving issue near HQ flag.
* Fixed weapon spawn issues in loot crates.
* Fixed issues in snow script (for snow maps like currently Chernarus Winter).
* Fixed radio tower rebuild issue.
* Fixed template issue regarding vehSDKTrucks.
* Fixed Bob's forgotten D.
* Fixed Zeus not being able to access all assets.
* Fixed initVar spam.

.. rubric:: Code



*DISCLAIMER* - Significant template changes are still underway. You might want to avoid making custom templates for a while!
* CSAT outposts and airfields are set in fn_initGarrison.sqf now.




|

-----

|


Version 2.2.0
===============

.. note::
   04th January 2020



.. rubric:: Major



* GAMEPLAY CHANGES
* Changed vehicle spawn mechanic. Vehicles now spawn in suitable positions and without the unwanted explosion.
* Added random convoys driving around and attacking roadblocks on their way. These will grow stronger over time and follow a specific system, but we wont reveal this yet.
* Random convoys attack roadblocks on their ways.
* Added the ability to breach open vehicles with explosives. Get an engineer and break these pesky vehicles open. You maybe want to keep a medic close, damaged vehicles tend to explode.
* Changed the way resource points and factories become destroyed. You see something unusual, shoot it, a industrial building is blocking your way, mortar it, strange civis running around, sho.. You get the point. And watch the barrels.
* Complete overhaul of starting weapons and equipment for all variations of rebel side. Guerilla fighters don't start with high-end weaponary, they start with sandals.
* Rebel AI now appropriately gear from unlocked equipment. Can't win a rebellion with fishing vests, you know.
* Overhaul of the loot tables. A much wider variety of gear should spawn.
* Complete re-balance of AI Skill. Cut the brains of the enemies in half and implanted the other half into your AI units. They should be a lot less useless while fighting worse enemies.
* Adapted Antistasi to the new Ace version 3.13.0.

* PARAMETER CHANGES
* Created parameters to allow DLC gear. Currently, this affects items in crates and civilian vehicles. We heard your call for it. Just make sure you use it with caution.
* Created parameters to customise the variety and amount of loot that gets spawned in crates.
* Created parameters to allow unlocked guided launchers and explosives. So please stop asking for cheats in the help channel.
* Created a parameter to stop an unlocked weapon from unlocking its first valid magazine. For the ones, who really love looting.
* Created a parameter to disable members having access to the Faction Garage, allowing only the commander access.
* Created a (experimental) parameter that disables all of the balance checks on loot crates. Want 100% random loot crates? Toggle this. (Not advised, but feel free to for science.)
* Added an option to disable civilian traffic. The group state they are driving in is careless, and it is a fitting descripting of their driving skills. You can now turn off random death by driving civilians.

* MAP CHANGES (OLDER MAPS WILL NO LONGER WORK WITH 2.2 OR ABOVE)
* Added Kunduz as a playable map.
* Added Tembelan as a playable map.
* Added Chernarus_winter including a snow script as a playable map.
* Added Anizay as a playable map.
* Reworked map marker for Altis, Tanoa, Malden, Chernarus_summer and Livonia.

.. rubric:: Minor



* Undercover medics can now heal civilians/undercover players without becoming overt. You never know, when you need it. Also check the known errors.
* Made punishment missions a bit less punishing. They are won easier now. Did someone said casuals?
* Updated stringtable. French is now partly available.
* All items now get removed when player respawn. No more stolen radios from the afterlive.
* Readd maps when player respawn. Yeah, that wasn't considered enough.
* Regular players are now allowed to place the HQ if Petros died and there is no boss.
* Moved vehicle-specific actions to VehicleBox. You know, the repair box. Vehicles can now access the arsenal from there too!
* Increased spawn distance on HC vehicles. You may have to search a bit, but the spawning should be better now.
* Every airfield has at least one manned AA vehicle in every case.
* Members now have access to the faction garage by default.
* Complete overhaul of starting weapons and equipment for all variations of rebel side.
* Removed non-USAF troops from traitor spawn pool.
* Added polaris to RHS Blufor PvP vehicle pool.
* Swapped panzerfaust to RPG-75 for Greenfor RHS rebels.
* Added an option to disable civilian traffic.
* Balance pass for "CSAT Punishment" mission.

.. rubric:: Groundwork



* Reworked the garrison system to build a new reinforcement system on top of it. Believe us, you will know once we got this running.
* Added a system to simulate convoys of all types. Convoys 12 kilometer away will no longer kill your server performance. Even if there are many.
* Created a template naming convention and precursory files. New names for better understanding. But also alot more files.
* Added Nav Grids. They are large and we are sorry about this. But they have a really important job.
* Added localisation support for Map briefing screen.
* Set the NATOCrates to use a weighted distribution method, rather than random.
* Created a new Parameter for truly random Crates, if wanted. Look for the [Experimental] option in parameter selection.

.. rubric:: Bugfixes



* Fixed schrodingers' buildings - they should no longer be both destroyed and not. Maybe. We won't know until we check!
* Fixed convoys not moving or stopping moving when attacked (i.e - Convoy missions work again!)
* Dialog back buttons now work correctly. No struggling with dialogs anymore.
* ACRE radios are now recognized correctly.
* Fixed an error relating to toolkits being added to the arsenal incorrectly.
* Fixed one of the civilian traffic options not working. 0.5 (Low) was never working. Did anyone catch that?
* Fixed broken easy difficulty setting.
* Fixed "Destroy the Helicopter" mission.
* Fixed access to HC squad level commands on map interface.
* Certain weapons no longer include base attachments with them. No more free bipods.
* Fixed many bad case and improper item defines throughout the mission.
* Fixed money loss on death to only penalize once. It was 10% + 5%, now it is 15%. Why was it like this? We don't know either.
* There should be much less inconsistency in save data. You know, first this, then that, just like your Ex. We broke up, too.
* Fixed needed time displayed wrong in supply mission description.
* Fixed truck reference in supply mission description.
* Fixed RHS side detection.
* Readded dedicated server startup delay. We figured out it was actually needed. Humans make mistakes you know.
* Fixed money-by-dismissal exploit. No more human trafficing. That was bad from the start.
* Fixed ACRE2 radios not being recognized as such.
* Fixed TFAR radios not being unlocked on start.
* Fixed GPS not in starting items.
* Fixed medical kits claiming to be unknown in arsenal. We all know you're there, don't act up.
* Fixed arsenal being called before it could init.
* Fixed Petros not respawning. Well, at least in theory.
* Fixed statics at base sneaking away. We got you, sneaky bastards.
* Fixed the player being able to take Petros as a prisoner.
* Fixed the player being able to join Petros' group.
* Fixed playable rebell units by stripping them so their initial gear can't be glitched in.
* Fixed most cases of exploding vehicles when Outposts spawn.
* Fixed prices for helicopters so they can't be used for a money glitch.

.. rubric:: Code



* Arsenal can now be setup in multiple objects.
* Rebuilt items detection system completely.
* Items system now scans config for defines instead of relying on manual input.
* Extensive sorting and commenting on format for template files, and initVar.
* Moved all units of the same side to the same template (police and militia).
* Added logging to various server functions.
* Stopped modifying items in 'onPlayerRespawn'.
* Stopped player reading a significant portion of initVar on connecting to a server.
* Began work on removing faction or side names from variable names throughout mission.
* Changed destroyedCities to destroyedSites.
* Significant refactoring and organizing of various scripts throughout the mission. They all kept their names, but you may have to search for them.
* Moved map templates. They don't have to be in the unit templates folder. We don't want them there.
* Reworked marker detection. It's even faster now.
* Added a log function for arrays.
* Unified all template files. Makes changing it alot easier for all of us.
* Added a PR templates. We should have done this a long time ago.
* PlayerMarker parameter is now enforced by server.
* Replaced BIS_fnc_selectRandom with selectRandom.
* Replaced type checks with isEqualType.
* Renamed AAFKilledEH to invaderOccupantUnitKilledEH.
* Changed the way dlc items get detected.
* Map templates have been moved to the top level of the mission.
* Small initVar addition to accept new gear arrays.

.. rubric:: Known issues



*DISCLAIMER* - Significant template changes are still underway. You might want to avoid making custom templates for a while!
* (Destroy Heli Mission) If you manage to steal the truck while it is trying to transport the heli back, the mission will fail (The fix for this is WIP)
* The updated ACE version 3.13.0 maybe has introduced new issues with ACRE. We are investigating and thankful for input.




|

-----

|


Version 2.1.2
===============

.. note::
   06 September 2019



.. rubric:: Improvements


• Clean up README on GitHub
• Implementation of Malden and Livonia to stringtable
• Change of weird variable names
• Update of different mission.sqm’s

.. rubric:: Fixes


• Garage wipes
• Lost gear when hit “heal, repair and rearm” whilst being in vehicle
• Unsynchronised buildings
• Punishment is not triggering on dead bodies anymore
• Revert start parameter changes
• Membership fix for Singleplayer
• Error on loot crates
• Start-up error regarding HC
• InitVar for Malden and Livonia




|

-----

|


Version 2.1.1
===============

.. note::
   31st August 2019

.. attention::
   To shorten the version number and to distinguish this version from 1.4 we changed the version to 2.1.1 instead of having 1.4c2.1.1.

.. rubric:: Improvements

• Antistasi ported to Malden (beta) and Livonia (beta)
• Resized and repositioned markers in all the maps
• Moved HQ management from the flag to Petros
• Start of localisation as the basis for translated versions
• UI update for readability
• PvP players are not spawning friendly AI anymore
• Members now also can get missions from Petros – not only the commander
• Improved chopper and plane spawns on airfields
• Punishment and logging implemented for friendly fire
• PvP switch time-out enabled
• Loadouts and starting gear overhaul
• Improved ammo truck mission
• Complete overhaul of PvP units
• Multiple functions rewritten for readability

.. rubric:: Fixes


• Fixed boat spawning on Malden
• Changed the object of fireX into a tent got rid of clipping through the floor
• Misc items are now unlocking
• Blufor units spawning as Greenfor with 3CB loadouts
• Non-RHS NVGs removed when using RHS
• Loading issue on Linux servers resolved
• Radio tower repair missions working again
• HQ grenade shield re-implemented
• Island-recognition for maps with multiple islands fixed
• Static weapons in outposts couldn’t be manned by AI
• Static weapons at airfields can be stolen
• Russian aircraft spawning in Armia Krajowa fixed


Version 1.4c1.01 through to 1.4c2.0 - 10th August 2019

.. rubric:: All Improvements



* Support for 3CB - You can now play as the British Armed Forces
* ADV - ACE Medical support
* Players save on disconnect
* Commander can pass command to someone by resigning while looking at them
* Vehicles are teleported along with players when outside member leash range
* The Heal and Repair box now removes vehicles and players from the wanted list
* The Heal and Repair box now has a 30 second cooldown timer. No more spam-healing.
* PvP players can get into the passenger seats of vehicles (i.e - they can be taken captive)
* Undercover is much more likely to be broken by outposts at higher war levels
* Arsenal categorization is significantly improved. Fewer items will be wrongly in the 'Bipod' section.
* HEMTT Cargo and HEMTT Flatbed added to the list of trucks in Vanilla.
* Placing vehicles from the garage is more reliable
* Building fortifications UI improvements
* Ammo is now accessible when X magazines is reached, rather than 500 rounds
* Notification when a player is given temporary membership
* Notifications removed when a player joins BLUFOR/OPFOR
* Translated version is backwards compatible with original Antistasi 1.4
* Add a light to the flag
* Improved vehicle placement and building system
* roadsDB.sqf added for Chernarus

.. rubric:: Fixes

* Vanilla police replaced with RHS police where appropriate
* Players no longer start with guns appropriate to their role (No more free guns)
* Bodies now vanish when players disconnect
* Apex Jeeps replaced with Offroads (to remove dependency on DLC)
* Civilans now correctly increase Occupant aggression if shot in limbs
* Players are no longer rewarded for killing civilians in singleplayer
* Players no longer have rifleman radios during WW2
* German radios no longer vanish during WW2
* Dogs can no longer detect you from the other side of the world (100m reduced to 20m)
* Player loadouts are removed for players that disconnect while unconscious or downed
* Only rebels can save - no more BLUFOR loadouts sneaking onto the rebel side
* Supply missions no longer claim you can sell supplies.
* Marker text and colours should update more reliably when changing side
* Roadblocks no longer spawn two flags
* Times on missions should no longer be missing 0s (13:07, rather than 13:7)
* Petros no longer has 'Build HQ on him' when he dies.
* Sleeping bag is less likely to clip into the ground (still happens rarely)
* Vehicles are much less likely to fly off into the sky while you're placing them.
* Many, many fixes for personal saving. It's now more reliable than ever.
* Undercover no longer works in airports (no stealing helicopters early-game)
* Another fix for commander getting stuck on none
* Objects placed near HQ like bunkers no longer wander off when you reload
* Fixes box/flag/map not moving when placed
* Killing guard dogs no longer counts as killing a surrendered soldier.
* Frequencies of SR and LR don't change when you enter the Arsenal
* Petros gets respawned automatically if he for some reason vanishes
* Fixed commander not being reassigned
* Shooting from vehicles should now always break undercover if in range of a city or enemy
* Undercover Friendly NPCs should drive on roads always
* Mission convoys should bug out less (Still not perfect)
* Civilians no longer shout orders to each other
* ACE removed from mod blacklist in singleplayer
* Object moving in the HQ should bug out less
* Player saves no longer carry over from previous campaigns
* Camping light no longer loses actions (replaced with sleeping bag)
* Static weapons always spawn the correct bags, in more sensible places
* Non-commander admins can give temp membership
* Arsenal sorting now works, alphabetically and by count
* Arsenal bug where items temporarily stop being unlimited
* Arsenal items go more-reliably into the correct tabs.
* Various arsenal duplication bugs
* Groups will no-longer hit the limit (fixing several other issues)
* Curator modules added to all maps
* Fix IFA Detection in WW2
* Several exploits
* Several runtime errors
* Probably more fixes we've missed.
* meter veh civiles IFA y rehacer lo relativo a JNL <-- I don't know where that comes from and where that belongs [Bob Murphy - 04.01.2020]




|

-----

|




Version 1.4.0
===============

.. note::
   25th October 0018

.. rubric:: Changes


* Rework of the spawning scripts, less CPU and bandwith compsuming.
* Liberated prisoners will be deleted after 100 seconds to save performance (those units have no combat capabilities at all).
* Local AI number will be limited on sides up to a 70% of the Max AI parameter, so there will be allways room for their enemy AI.
* Major garrisons will spawn at least a whole group (if they have troops) and the rest of the groups can be bypassed of spawning if the AI limit has been reached.
* Some improvements in attack drills for AI
* Attack AI will react better to tank and airplane presence (hide in bluidings if they or the nearby friendlies have no AA/AT capabilities).
* Corrected (�at last!) bug on binoculars in Arsenal menu and some mod integrations with Arsenal and unlocking system, ALL thanks to SkaceKamen!!! Thanks a lot!
* Fixed RHS / Arsenal crash upon respawn bug. Thanks to Jeroen not!!!!
* Solved bug in flanking procedures thanks to Alex Triada!
* Better behaviour for AI using land transports.
* Fixed: Threat evaluation analisys were done non mod-edition-faction independent.
* Fixed Air QRF sent from outposts in some cases.
* Major attacks and QRFs will at least send a whole squad if applicable, and they won't send squads with less than 4 units anymore.
* Engineer mine replacement script improved and less risky for AI thanks to wriley!!!
* More automated, mod independent weapon detection for ammobox loot. If there is an enemy in the field with that weapon, it is possible to find it in an ammobox.
* Improved a bit specop group compositions.
* Improved RHS integration with PvP element for soldier loadout (with the exception of the UAV operators which are still vanilla as RHS lacks of proper classnames).
* Fixed bug on JiP commander assignation.
* Solved bug in Destroy Heli missions.
* Added RHS SPG9 as AT gun for rebel RHSGREF config, thanks to Mocksybren!!




|

-----

|




Version 1.3.5
===============

.. note::
   14th October 0018

.. rubric:: Changes


* NEW FEATURE: SP init options ported from MP: Difficulty settings affect several params, and Game Mode behaves the same. Want to fight only Redfor? Now you can!
* Garrison mortars will be manned again.
* AutoLoot will bypass the check for unlocked weapons on the bodies, so the AI will do a brainless loot anyway.
* Removed debug message on flare script.
* Seaports now spawn the right classnames in Reb vs Inv game mode.
* Major attacks should spawn allways with vehicles.
* Better and automated flashlight, optic and pointer detection, mod independent. RHS AI will spawn with more proper pointers / flashlights, and all the sights are included in ammoboxes.
* Corrected major bug on enemy AI init which caused several malfunctions.
* Stanadarised for everything the minimum requirements for unlocking (default 25).
* Added some useful info in the Game Options menu.
* Solved AI refund on persistent save.
* Fixed major attacks not happening in early stages of the game.
* Fixed major attacks not stopping even when the attack was succesful or failed in the tasks menu.
* Fixed bug on AI building assault.
* Fixed error on qrf when the AI sends more than 1 vehicle and there are no more vehicles to send.




|

-----

|




Version 1.3.4
===============

.. note::
   21st September 0018

.. rubric:: Changes


* Corrected reinf bug when the AI lacks of air transports to send big groups.
* Convoy delay re enabled.
* Converted the whole function structure in a more optimised way, thanks and all credits to blkanaki!!!
* Solved garrison having militia deleted from the variable upon spawn when static weapons were present.
* IFA: Enemy QRF will be allways land units, with the exception of bombstrikes.
* AI will have as target on major attacks allways the nearest enemy position from the evaluated base, even when it has no enemy zones in the surroundings, so AI will be more agressive again.
* IFA: Distance for land attacks has been increased.
* Fast Travel now has a counter thanks to john681611. Thanks man!
* By popular demand: Limited Fast Travel will be switchable in the MP lobby. Default value is Yes.
* IFA: Adapted roadblocks.
* Corrected garrison bug when the garrison lacked of SL or Medic classnames.
* Solved bug on basic mandatory vehicle availability check.




|

-----

|




Version 1.3.3
===============

.. note::
   5th September 0018

.. rubric:: Changes


* IMPORTANT: Removed and unauthorised ACE medical in SP to avoid the "I cannot respawn" false bug report flood.
* Vehicles can be garaged in any rebel garrison.
* Non members with membership enabled cannot use the garage.
* Re enabled FT in MP for players with Airbases as destination.
* IFA & ACE: Increased integration with explosive cables and spare MG barrels.
* Re enabled Radio Jam script from rebel12340 adapted to Antistasi (second try).
* Hopefully solved the IFA templates with DLV classnames.
* NAPALM shouldnt damage HQ assets.
* Fixed bug which prevented to garage any vehicle.
* Garrison modification on unit kill will be only done if the garrison is still on the side of the killed unit, which will save on performance and bandwith.
* Fixed garrison add on spawned zones.
* Fire of built roadblocks delayed so the builder doesent get hurt.
* Fixed major bug which stopped economics and major attacks on some templates (specially IFA)




|

-----

|




Version 1.3.2
===============

.. note::
   4th September 0018

.. rubric:: Changes


* NEW FEATURE: Total rework of economics for AI so there are now real economics (like old 1.8) but instead of money they will need time to replentish and maximum assets will depend on zone ownership. Example: Max Tanks for a faction is 1xAirbases belonging to them + you will never see more than that in the field.
* Convoys wont spawn having a distance minor than the spawn distance setting from origin to destination.
* Garrisons created "on the fly" won't get deleted when the player commander disconnects.
* Applied garrison reorganisation to non rebel faction garrisons.
* Removed Airbase requirement in order to retrieve helis from garage.
* Re enabled Fast Travel for player groups in MP only when the destination is HQ.
* Static AA and ATs will be subject to availability for AI.
* Static weapons placed in building roofs wont spawn if the building is destroyed.
* Fixed relentless major attacks in some cases.




|

-----

|




Version 1.3.1
===============

.. note::
   2nd September 0018

.. rubric:: Changes


* IFA: Replaced winter wehrmacht by Afrikakorps for Tier 2 troops. Requires mission restart to see them.
* IFA: Disabled mortar squad recruitment until I find a solution.
* IFA: Fixed ammobox load on trucks and replaced by vanilla boxes, as they are barely visible.
* IFA: AI wont spawn with flamethrowers.
* IFA: AT Men will spawn with AT rifles until some decent AT weapon has been unlocked.
* IFA: Doubled sidemission timer for most of them.
* Enabled redress scripts on more islands than Tanoa.
* Fixed player unable to access Y menu after trying to recruit a squad without funds.
* Corrected typo on game mode menu.
* Changed numpad arrows by normal arrows for the garage / buy menu.
* Removed exploit on player FT with HC squads.
* Minimum timer for traitor missions set in 30 minutes.
* Fixed bug on CSAT punishments, all cities were targets instead of those who have high support levels.
* CSAT wont punish cities influenced by them.




|

-----

|




Version 1.3.0
===============

.. note::
   16th August 2018

.. rubric:: Changes


* NEW IMPORTANT FEATURE IN MP: GAME MODE. In the lobby you may set 4 options: All vs All, Rebels vs All and other two on which rebels only fight one chosen faction (invaders or government).
* NEW VERSION: WWII Has arrived to Antistasi. In Armja Krajova polish resistance fight against Germans and Soviets. Required mods are CUP Maps and IFA.
* NEW FEATURE: Total rework on UI for construction, garage and buy vehicle options.
* NEW FEATURE: Squad Vehicle Stats button replaced by "Squad SITREP" on which player will receive a lot of useful information about his AI squads.
* NEW FEATURE: AI uses flares when there is no NV in the scene, to assault enemies on search for them.
* RHS: Added M1 Garand and Grease gun to rebels default loadout.
* Removed MP exploits on buying, login,logout.
* Fixed bug on hide in building AI script.
* FT on vehicles will be a bit safer.
* Disabled Fast Travel in MP for players (yes for AI groups).
* Hopefully solved garage exploits.
* Clarification message when a player fails to garage an air vehicle far from airbases and HQ.
* Tweaked the non member distance params and default values.
* Towing a vehicle on undercover will make the player lose the status.
* AI limiter will count AI with simulation disabled in order to decide to spawn an AI or not. This will improve performance in major attacks.
* Outposts wont send land attacks from other islands in Tanoa.
* Removed aggro checks for AI deciding to send a major attack against rebels. They will be more likely targeted.
* Aggro checks will affect vehicle type sent against rebels (you are not a big threat, I will send a cheap transport, you are athreat, Tanks).
* Major attacks will be allways performed by the server no matter if there are HCs in.
* Capped soldier count in major attacks.
* Cleared forest will be reset when the HQ has been moved.
* Fixed land attacks in Tanoa.
* Corrected faction init bug on roadblocks.
* Fixed some desynching on MP players init.
* AI static defenses wont despawn when being attacked by another AI.
* Lesser garrison requirements on outposts to send major attacks.
* Solved bug on enemy side detection script.
* On combined major attacks, artillery may spawn in the origin of the land attack.
* Corrected some rare desynch cases on which a QRF is sent to recapture departing from the target zone.
* Corrected bug on saved vehicles not moving.
* Squad mount / dismount button now supports selection of more than one squad.
* Fixed rebel HE airstrikes.
* The NV for the enemy specops is managed independently of the modset / edition.
* Vehicle dialogs will show vehicle names related to the modset.
* Removed a lot of vanilla action references and Warlords texts.
* Adapted some (not all) flag textures to each mod.
* Optimised "enemy nearby" checks and more user friendly to avoid UI wates of time.
* Removed the conditions for a wave to be considered with enough assets and men.
* Road patrols wont spawn if the possible destinations are less than 4 instead of 1.
* Squad Leader skill bonuses apply to classnames, not to group leaders.
* Garrison compositions will attempt to add a SL and a Medic to each garrison squad.
* Better integration of mods + AI smoke usage.
* Intesified usage of outposts as QRF departure points.
* Intensified usage of CAS bombruns against enemies in the field instead of sending squads.
* Criteria to avoid friendly fire in CAS and mortar bombing is different among sides of AI (NATO cares about civvies and injured friendly, CSAT not).
* Fxied AI sending QRF against mortars.
* Corrected small differences of tooltip cost and real cost of some squads.
* Airstrikes against static weapons may consist in NAPALM.
* NAPALM damage loop a bit more spaced in time (more chances of survive if you move quickly)
* Slight less chance for a mortar to get zeroed.




|

-----

|




Version 1.2.5 Holliday update!
================================

.. note::
   30th July 2018

.. rubric:: Changes

* Seaport boat garrisons and patrols are subject to boat availability.
* Fixed teammate disband.




|

-----

|




Version 1.2.4
===============

.. note::
   29th July 2018

.. rubric:: Changes

* HR of AI squadmates is properly refunded when saving.
* Enemy small vehicle patrols wont have only rebel HQ as reference but the whole frontier in SP and player presence in MP to simulate the whole island is being patrolled.
* Better priorisation of targets for major attacks, less random, more sense.
* Removed debug message when AI captures an airbase.
* Hopefully solved all the remaining HQ assets issues.
* Fixed bug when AI tries to hide in a building.
* Reduced a lot the max distance between departure and targets for both land and air attacks (10Kmts and 3 Kmts).
* Changed the position of the NATO Carrier in Altis.




|

-----

|




Version 1.2.3
===============

.. note::
   28th July 2018

.. rubric:: Changes

* NEW FEATURE: MP param to monitor non member distance to the closest member or HQ. After some timeout they will be teleported. This can be customizable in the MP lobby but it is activated by default. The aim of this feature is to avoid randomers in open dedis make spawn senseless zones and not be collaborative with other players.
* Extended AutoRearm to HC squads. If they are "easy" and not fighting, they will search for better weapons, vests etc.. same as AI squadmates when ordered.
* Fixed the detection of players that have been recently rebels and they are joining a pvp faction.
* Players have to be in the HQ to garage vehicles (to store air vehicles, the HQ still has to be placed very close to an airbase flag).
* Major attack task names adapted to your mods.
* PvP player will have cars instead of quadbikes to request and spawning will be safer.
* Solved some localization issues with city setup parameters.
* Airstrike plane will be of proper side in Altis Greenfor version.
* Improved stability when players add garrisons on spawned zones.
* Small workaround for buliding HQ in MP issues.
* Fixed heavy bug on enhaced AI which made them maneuvre much less.
* Re enabled supply box spawn in high war level.
* When a headless clint disconnects, an alarm will appear constantly instead of finishing the mission.




|

-----

|




Version 1.2.2
===============

.. note::
   28th July 2018

.. rubric:: Changes

* Re enabled Headless Clients.
* Commander auto assign on JiP fixed when there are PvP players present.
* Fixed "Move this Asset" and HQ garrisons on load.
* Changed major attack AI decisions according to the new mechanic of auto conquer resources and factories when capturing an airbase. Also CSAT will prioritise more enemy outpost assault.
* Reduced spawning requisites for a wave to be counted in major attacks.




|

-----

|




Version 1.2.1
===============

.. note::
   27th July 2018

.. rubric:: Changes

* When rebels lose territory, there is a small chance depending on WL to be attacked on their HQ.
* Corrected bug in ambient civilians.
* Solved init bug on new dedis when the admin does not touch the parameters.
* Solved statics not saving in MP dedi.




|

-----

|




Version 1.2.0
===============

.. note::
   13th July 2018

.. rubric:: Changes

* IMPORTANT: Added enhaced AI features for the HC infantry squads (under testing).
* IMPORTANT: Added CSAT as PvP faction.
* IMPORTANT: Added more rebel squad recruitment option types.
* IMPORTANT: When AI takes an AI airbase, they will auto take all the nearby resources and factories belonging to the looser.
* Corrected PvP looting.
* Re added rebreathers in enemy seaport ammoboxes.
* Rebels will allways have an update of AI attack destination on major attacks, that update will be quicker if enemy comms are intercepted.
* Solved some locality issues with MP params for HCs.
* MP hosters will have their personal stats loaded.
* MP hosters will be able to add members.
* Armed civilians in CSAT punishments will allways be rebel side.
* In Altis BLUFOR added the right UAV terminal for the arsenal.
* HQ assets will be invulnerable again.
* Carriers wont launch coquering QRFs.
* Corrected server flood when road patrols didnt found where to patrol.
* Workarounded when mission init thinks the player is in the wrong side.
* No assassination missions in case NATO does not have any airbase in the island.
* Convoys can now depart from outposts, more convoy options!
* Extended auto conquer of surrounding zones for battles between AI to captured outposts.
* Solved bug when MP player dismiss AI and has another player in the group.
* Enemy creates now have proper UAV and terminals depending on yur Antistasi faction.
* In vanilla MP rebels start with just SMGs and pistols, not AKs.
* Applied a difficulty coefficient for very populated servers.
* PvP slots wont be available for players that have been playing rebels in the last hour.
* Added a reserved slot for members parameter to be able to book slots for members, up to 100% slots (member only session).
* Fixed server autosave option.
* Built a workaround for strange cases on which players were detected as PvP when they werent.
* Doubled HC slots and increased playable slots for rebels.
* AI won't count as civilians unconscious units while deciding to shoot arty rounds or NAPALM strikes.
* Hopefully solved all the issues related with membership and hosted server environment.
* Fixed: teamkilling option was not working when killing unonscious friendlies.
* Added a message when a rebel player assembles a static weapon which confirms if the weapon will be used or not.
* Bomb run number will be saved and loaded properly.
* HQ asset position and direction is now persistent saved.
* Bulletproofed a bit HQ flag position in case the selected position makes the flag dissapear, so the players will have a chance of repositioning the HQ in a more suitable place.
* Corrected rare bug on QRFs when only tanks where available to retake a zone.
* Players wont be able to garage AI manned vehicles.
* Spotted vehicles marker colors should be ok now.
* Improved infoshare between enhaced AI groups (they will know a bit more if them if some other group has spotted it).
* Removed the "contact informer" mid step, as it seems not fun at all...
* Mil buildings are not used to spawn ambient civvies.
* Aggro implications when conquering / loosing certain territory types.




|

-----

|




Version 1.1.5
===============

.. note::
   6th July 2018

.. rubric:: Changes

* ALTIS BLUFOR VERSION IS OUT ON STEAM: Play against a mix of militia SDK + AAF in Altis (or RHS alike config).
* NEW FEATURE: Battle accelerator for battles very remote to players.
* Fixed the convoys in all the islands.
* Fixed player markers on PvP players.
* PvP players won't be able to loot anything which is not a corpse.
* Fixed init bug in MP starting a new game, but asking to load the old session and JiPing.
* NATO wont attack CSAT on WL 1.
* Removed small error on statistics bar calls.
* AI medics now carry 11 FA kits no matter what mod you use.
* Reverted SP player overriding fatal wound mechanics as it caused major bugs.
* AI wont use smoke in CQB.
* Assassination missions wont auto spawn.
* Unconscious PvP players wont be able to be commanders.
* Players shouldnt be initialised before extremely slow servers.
* In hosted, AI which belongs to the hoster wont provide double refund on personal and faction money on save.
* Optimised a bit mousewheel actions on HQ assets.
* Corrected errors on SP briefing.
* AI will allways paradrop when attacking airbases.
* Solved Move Assets bug.
* Solved Stavros city bug.
* Hopefully destroyed buildings will appear destroyed for everyone.
* Several english mispelling errors corrected thanks to the Github supporting community.
* Reverted error which made tier 1 and 2 NATO have Rambo skills.
* Tier 2 NATO (if exist) instead of lowering the aggro when releasing prisoners, they will join you like CSAT.




|

-----

|




Version 1.1.4
===============

.. note::
   21st June 2018

.. rubric:: Changes

* Solved bug when server is initialised by non members.
* Solved bug on new match which prevented to be asked for placement selection.
* Solved bug on build minefield scripts + PvP players won't see the markers.
* Ammobox won't be random replentished on each persistent load.
* Blacklisted target areas will work in HCs.
* Garrisons wont spawn far patrols if they are not at top numbers.
* Major attacks will be more combined as the AI will make a more intensive use of nearby outposts if possible.
* Solved PvP RHS NATO players loadout.
* SP player wont receive fatal wounds.
* Militia is cheaper again.
* SP players will be considered as medic and engineer.
* Enemy city patrols and surrounding patrols wont spawn if the city has an enemy zone inside the city or patrol zone.
* Workarounded some weird bug on task updating in JIP MP.




|

-----

|




Version 1.1.3
===============

.. note::
   14th June 2018

.. rubric:: Changes

* Reworked a bit RT influence, different results from 4 possible status (from destroyed, no influence to no one, to CSAT, negative influence for everyone).
* IMPORTANT: Availability of transports enabled, except the most basic ones on each faction.
* Disabled saving capability in MP until the server has init totally.
* Solved crashes on non JIP players dedi.
* Players will be asked to load their personal stats anytime in MP and teleport to HQ.
* Headgear and NV will be added to the ammocrate when the player dissmiss a unit.
* Increased city support gain on each kill.
* More chances to avoid AI taking objectives too sparse.
* When AI takes an AI zone, the nearby controls will belong to the conqueror.
* Land vehicles wont be constantly teleporting to roads when no player is near.




|

-----

|




Version 1.1.2
===============

.. note::
   9th June 2018

.. rubric:: Changes

* NEW FEATURE: Any kind of destroyed building is persistent saved.
* More save fixes and debug checks on the Save feature.
* Bugfix and rework of the vehicle markers script.
* No loss of advanced towing when the removeAllActions command has been used on the player.




|

-----

|




Version 1.1.1
===============

.. note::
   9th June 2018

.. rubric:: Changes

* Several persistent save bugfixes.
* Re enabled civilians being of the side which owns the city because setFriend command is not reliable during mission.
* Re enabled vehicle markers report as the watchpost became uselees without them.




|

-----

|




Version 1.1.0
===============

.. note::
   3rd June 2018

.. rubric:: Changes

* NEW FEATURE: Major assault AI overhaul. Now AI sent on major attacks will perform the following:
* Mortar assemble and mortar support.
* StaticMG assemble / dissassemble.
* More proactive and specialised backup requests of whatever (mortar, airstrikes, qrfs).
* Flanking while supressing or covering the flankers.
* Building assaults.
* Fortify in buildings.
* NEW FEATURE: MP lobby mission parameters with long waited customization settings. Default values are for open dedis in mind, can be only modified by server admin.
* Increased variety for squad compositions with static weapons, engineers, AA / AT men etc (RHS limited to classnames).
* Corrected bug in roadpatrols.
* AI will prioritise available armed helis in case of a support QRF.
* AI wont send QRFs to recap AI airports or airport surroundings.
* Same with reinforcements.
* Solved AI QRFs collide on spawn when several of them have been called.
* Tanks and APC crewmen have mine detection disabled, mines should be much more useful.
* Bulletproofed vehicle and unit init to avoid rare malfunctions.
* Solved bug on paratroopers reinf patrol.
* Medics wont teleport inmediately to heal players in SP and they wont do it if enemies are very close.
* Raised default mission distance to 4Kmts
* Reviving AI belonging to players will report why they cannot revive.
* Removed loading screen in Arsenal to avoid crashes.
* Armed civs on CSAT Punishments will be civilian side and CSAT will attack any civilian anyway but they wont attack players in NATO controlled zones.
* Solved revive enemy bug not making them to surrender.
* CSAT wont have piety with unconscious enemies and will kill them if possible.
* Bleadout by NATO vs CSAT battles wont affect prestige / aggro.
* Medics will loot FA kits up to 10, and pick all the dead body have up to that number.
* All faction uniforms available in arsenal and automated to each mod (including tier 2 troops).
* Informer missions timer raised to 30 mins.
* Informers wont spawn in blacklisted buildings.
* Bank robbery hint spam removed.




|

-----

|




Version 1.0.8
===============

.. note::
   1st June 2018

.. rubric:: Changes

* Solved several undercover MP issues.
* Re enabled player markers in MP.
* Planes on QRF and reinforcements wont try to land.
* Conquering by kills is easier.
* Bunkers shouldnt move on persistent save.




|

-----

|




Version 1.0.7
===============

.. note::
   30th May 2018

.. rubric:: Changes

* Reverted Jeroen's modification because of bugs until we find a solution.
* No area check for undercover AI
* Teleport AI to unconscious only in SP.
* Road patrols may be generated in Outposts.
* Bledout enemy AI will affect prestige etc. only if killed by Greenfor.
* Solved when an AI is ordered with Action menu 6 to revive and gets unresponsive for revive.
* Hopefully solved some MP animation fails.




|

-----

|




Version 1.0.6
===============

.. note::
   28th May 2018

.. rubric:: Changes

* Jeroen Arsenal fix some leeks which allowed players select whatever equipment. Thanks to Jeroen
* APCs and Tanks will pop smoke only once when damaged. Removed damage processess when killed.
* On load, building destruction wont be smulated to avoid collateral damages and unnecesary anims.
* Removed some missed time delay to recover enemy AI after being revived by AI.
* Improved handle damage checks while AI is controlled.
* Fixed: when player respawns player is flagged as unconscious.
* Re enabled AI teleport to player when they cannot reach the player while unconscious because of AI pathfinding.




|

-----

|




Version 1.0.5
===============

.. note::
   22nd May 2018

.. rubric:: Changes

* IMPORTANT: Conquer QRFs can be dispatched on AI vs AI factions. Instead of only send major attacks to eachother, we may find several qrfs dispatched on the same time, taking advantage of weaker garrisons.
* IMPORTANT: CSAT intervention now starts with WL 2.
* IMPORTANT: Petros / Maru is now invulnerable to player fire + punishments have been removed. In case he is killed by any source which is not direct AI fire, petros will respawn without consequence.
* Reinforcements now may reach with fastrope or paradrop.
* Corrected wrong call on fastrope script on QRF.
* Debugged (not solved) some error in garrison update.
* Corrected small bug on QRF when the vehicle is a truck and only one soldier spawned.
* Idle status of an airbase or outpost now depends on several factors and may be busy for some tasks and not for some other. Map info will report the minimum requirements.
* PvP players wont count on the "enemy nearby" checks for recruiting etc.
* Corrected small bug in QRF which prevented some actions.
* AI wont decide to send reinforcements to areas under attack.
* Ai wont pick unlocked things when looting.
* Increased much more enemy distance for AI to decide get to cover instead of return fire.
* Revive is far more reliable, more BIS alike.
* Fatal wounds now depend on body too, not only head.
* Minor body parts can have "unlimited damage".
* AI will cancel revive procedures if they get damage in the process.
* Some nicer icons here & there.
* Revive won't be possible in water.
* All basic faction vests unlocked by default.
* Statistics get updated on persistent load.
* Safer fastroping positions for AI attackers.
* Arty wont spawn in carriers.
* Supply missions are lost when the box is lost.
* Bulletproofed "transfer to ammobox" script to avoid some errors.




|

-----

|




Version 1.0.4
===============

.. note::
   21st May 2018

.. rubric:: Changes

* Fixed bugs that made convoy missions not launch.
* Convoys in Altis work much better now, not with the cohesion from Tanoa but with more chances of arrival.
* Land forces sent from long distances too
* Implemented a side check if vehicles are stuck on a bridge, in those cases, with no player present, the vehicle will unstuck.
* Corrected small bug on FIA AT troops init.
* Rework Commander dialog to allow commander rennounce.
* Now really added additional RHS vest.
* Increased a bit enemy distance for AI to decide get to cover instead of return fire.
* Reduced minimum garrisons on small zones to 1.
* Persistent save on destroyed mil buildings is back again.
* Choppers will land in safer distances.
* CAS Air is back on major attacks to airports.
* Friendly AAF spawned during daytime wont have NV




|

-----

|




Version 1.0.3
===============

.. note::
   20th May 2018

.. rubric:: Changes

* IMPORTANT: Early stages AI skill will be lowered, as there was some wrong calculation which made training beyond 5 skill level making AI Rambos.
* Reverted no busy status because of QRF sent in airports, outposts will require more time to recover.
* Reduced reviving times.
* Improved visual aspect for undercover AI.
* AI will prioritise outposts and seaports in order to decide to reinforce a garrison.
* Added some delay on AI heal procedures to avoid flood in case of massive damages.
* Temp inmune AI on spawn to avoid malfunctions.
* Killing an AI teammate wont make everyone hate you.
* Refugees and other non ambient civilians shouldnt despawn in dedicated servers.
* Custom assets and skillsets for faction SPECOPS / FIA substitutes also apply for mod units.
* Added additional light vest with RHS GREF.
* Fixed: OPFOR and GREENFOR are enemies again.
* On major attacks, planes wont form part of the vehicle pool (apart from CAS). On minor, will depend on what's the threat (only AA cratfs were spawned before).
* Armed cars and money vans shouldnt have broken wheels by accident now.
* Convoys wont be send with origin and destination of different side.
* Altis should have better weather now.
* Right Stavros group ID in Altis.
* Enemy does not wait to lose a jungle / forest / hill to build minefields in it.
* PvP players will be able to Fast Travel to their respawn point.
* Last? Attempt to fix broken BIS task functions with JiP players.




|

-----

|




Version 1.0.2
===============

.. note::
   16th May 2018

.. rubric:: Changes

* IMPORTANT: Reviving takes time, depending on the injuries received. Still has some glitches but gameplay improvement wotrth it.
* Ambushed AI will react faster, trying to take cover when engaged, take deffensive positions, evaluate the situation and react.
* Unconscious teammates wont be loaded in trucks if there is some AI or player reviving.
* Teamkilled players disguised as enemies wont cause punishment to the killer.
* HQ AI garrison are rambos, the top killers, Petros / MAru personnal guard.
* Raised alot bleedout time in MP.
* Removed feature when player bleedsout and AI don't reach him, as they seem very realiable in pathfinding.
* Corrected small bug on PvP briefing.
* Corrected big bug in RB / Forest patrols in MP.
* Re enabled Land QRFs.
* Removed tanoan civvies in Altis.
* Time to recover from revive on enemy AI is equal to friendly AI.
* Removed Tanoa civ car from RHS template.
* When an AI gets severe damage but not unconscious, will try to get to cover instead of just dropping smoke.
* MP client persistent load should be fixed.
* Removed time to recover for enemy AI after revive.
* Hopefully resolved some spawn in destination attack bug.
* Reworked "being carried" and "carried" status to avoid some bugs.
* Lowered a bit NATO skill.




|

-----

|




Version 1.0.1
===============

.. note::
   14th May 2018

.. rubric:: Changes

* Player won't be able to garage an air vehicle without being near an airport.
* PvP players will be able to "steal" unarmed vehicles from their faction airbases and outposts.
* More intense suppressive fire use on AI.
* AI Supressed status checks to perform some actions.
* Fixed radio tower duplicity on headless clients.
* Player arty markers shouldnt be visible for other factions or JIP players.
* Altis civ car available to buy is now a non APEX car.
* Airports wont have "busy" status if they send a QRF, yes for outposts.
* Server members (or everyone if the feature is disabled) wont have group / locked restrictions when boarding a vehicle.
* Changed PvP NATO Sniper by NATO MG role.
* Non server members wont be able to know HR and Airstrikes.
* NATO PvP players with RHS will have proper loadout.
* Corrected bug on initialRifles variable in MP.
* Reinforcements will be executed by HCs.
* Fixed locality issues with ace items variables so problems in Arsenal should be solved. Those variables are required to fix ACE bugs and config fails which conflict with BIS functions.
* Altis vanilla weapons found in anmoboxes are more basic vanilla.
* Drone backpacks as possible loot are now greenfor to avoid friendly AI shoot at them.
* Removed the unlimited wave when CSAT attacks and has only one airport.
* More major attack waves depending on faction, destination and War Level.
* Removed convoy creation when major attacks are small.
* Reinforcements now are dispatched in helis for remote places.
* Checks for enemy presence will ignore dead, captured, uncosncious etc. enemies.
* ACE assets added to PvP player loadouts depending on ACE config.




|

-----

|




Version 1.0.0
===============

.. note::
   23rd April 2018

.. rubric:: Changes

* NEW FEATURE: When a garrison is under attack, all players will receive a notification about it with relevant info. PvP too. PvP mission experience should change A LOT.
* NEW FEATURE: As visual aid, SDK markers for SDK players display the total garrison in map
* IMPORTANT: Added CSAT & NATO carriers to ensure faction presence during the whole match.
* IMPORTANT: Doubled HR gain on every tick.
* IMPORTANT: Seaports owned by SDK will boost support gain on cities with SDK support.
* IMPORTANT: Removed notification map markers on contact as they seem very unrealistic and the HC module does the trick. Only remain under certain circumstances.
* IMPORTANT: Improved code structure to make easier ports to another islands :)
* IMPORTANT: Titan and any kind of guided missile weapon wont be unlockable, Militia will no longer spawn with AA (at least in vanilla).
* IMPORTANT: Undercover lose condition from roadblocks applied to airports and outposts.
* "Take the Flag" action will require to decimate the zone.
* Corrected bug on garrison modification when AI dies.
* Optimised code for reaction when AI loses a teammate.
* Higher chance for AI to surrender.
* AI may send BIG QRFs under certain circunstances (MP-Only).
* Time for next tick will be persistent saved.
* Fixed bug which made transported units to bleedout.
* Corrected bug on Add vehicle to squad option.
* Optimised road searching with DRY techniques.
* AI wont send tanks to places without good roads nearby.
* Better AI behaviour while in APCs
* Better AI spacing for disembarking in major attacks.
* APCs use again their smokelaunchers when AI disembarks.
* NATO will ignore collateral damage when deciding to send a CAS bomb run.
* Corrected rare locality issues when a player captures a flag in MP.
* No more Logistic missions in destroyed cities.
* Caped maximum refugees to spawn no matter how big is the house.
* Players wont be able to use Y menu when unconscious.
* More awareness of air enemies to AA / vehicle AI.
* Fixed: AI places mines in jungles.
* Reduced a lot required time to recover helis and planes for AI.
* Removed requirement for being in the same island in logistics missions.
* Added some dynamic "bad to chose as destination" for land vehicles zone detection.
* Adapted faction texts to the Mod is used (AFRF instead of CSAT etc).
* Now FIA squads may be composed by NATO static MG components
* Added a new outpost near Rochelle.
* When dismissing a Mortar / MG group refund is correct even if the AI has the gun packed.
* Fixed server deleting defending civs on csat punishments.
* Refugees wont spawn in containers.
* If some military building is detected, it will get populated with MGs and other.
* Static MGs in airports now got manned.
* Better positioning of statics in airports.
* Raised a bit convoy distance.
* In SP civs stop spawning if the AI limit is reached.
* Waved major attacks wont count as wave when the number of spawned units is low.
* Radio comm interception wont benefit PvP players.
* Heal and repair wont heal unconscious units while being transported.
* RHS arty now works.
* More complete RHS integration.
* Removed exploit on player loadout + MP + persistent save.
* Added JNL to surrendered units ammoboxes.
* Gendarmes will use their primary weapon by default.
* Re enabled control of POWs.
* Raised a lot radius for AI decide attack from Airbases and Outposos.
* Raised minimum garrison squads to 2.
* ACE eraplugs for ACE PvP players.
* Skip Time works again with PvP players present.




|

-----

|




Version 0.12.2 ALPHA
======================

.. note::
   14th April 2018

.. rubric:: Changes

* NEW FEATURE: Now you may transport your wounded teammate to some truck / offroad to be healed by friendly medics or at HQ.
* More bulletproofing of garrisonUpdate.sqf
* Heal and Repair will affect unconscious units.
* Mounting a vehicle while carryng a teammate wont have weird effects.
* Being carried in a vehicle will delay the time to get bledout.
* Simplified to DRY coding ability to fight and ability con conquer / defend, with greater performance checks.
* NATO wont attack cities under SDK influence.
* SDK wont gain influence when the RT is on CSAT hands.




|

-----

|




Version 0.12.1 ALPHA
======================

.. note::
   12th April 2018

.. rubric:: Changes

* Added new Tanks DLC SDK Armed cars (AT and LMG).
* Purchased vehicles will have players name in the plate.
* Bulletproofed garrison update scripts to avoid fatal errors.
* STatic weapons shouldnt spawn fallen, thanks to Sparker.
* CAS Planes wont spawn on QRF and some major attacks (yes for bomb runs).
* Better spawn points for SDK vehicle squads.
* Reduced a bit distance checks for garage, player recruit and vehicle purchase.
* Added LoW DLC civ van as possible spawn.
* Stronger Radio Tower effect on Civ Support on each tick.




|

-----

|




Version 0.12.0 ALPHA
======================

.. note::
   5th April 2018

.. rubric:: Changes

* IMPORTANT: Added dynamic headless client resource assignation. Antistasi will try to balance the AI load on HC platforms so the idle-est one will spawn AI.
* IMPORTANT: Added unlimited Headless Client support, default mission has 3 HCs but you may just edit the mission and add as many HCs as you have.
* FFAA: Added FFAA mod compatibility. Spanish soldiers will replace FIA units.
* Corrected: No more conquest missions in forests.
* Improved helmet detection no matter the mod you use and affecting undercover (if it has some armor, you will lose undercover status).
* SDK AI will spawn with random helmets under certain skill levels.
* Corrected bugs in reinforcements script.
* Corrected bug in Destroy mission request.
* Scripted some timeout to avoid some vehicle smoke parties.
* Reenabled QRF when players are far from original bases.
* Paperboxes and some ACE stuff wont get persistent saved when near HQ
* Fixed SDK roadblocks / watchposts on persistent load.
* Paratroopers shouldnt paradrop in water.
* No more QRF paratroopers without parachute :)




|

-----

|




Version 0.11.3 ALPHA
======================

.. note::
   26th March 2018

.. rubric:: Changes

* Workers wont get deleted on dedicated servers without HCs.
* Reverted some autoload features to only official servers. Autosave will be enabled in dedicated servers.
* Bulletproofed killzone variables to avoid bugs.
* QRFs with conquer missions wont send bombruns.
* Smaller save file.
* Reduced a bit number of driving civilians.
* Garrison states on zones under attack now get saved.




|

-----

|




Version 0.11.2 ALPHA
======================

.. note::
   20th March 2018

.. rubric:: Changes

* IMPORTANT: Civ Spawn rework. Civvies everywhere! Now the Setting Civ Percentage means max amount of civilians. Plase NOTE: Civs are executed on clients in MP.
* IMPORTANT: Added Jeroen Logistics to enemy garrison ammoboxes. No more transfers to trucks.
* Re enabled NATO Y menu for ACE users.
* Lots of Altis integrations thanks to Stef!
* Total rework of menus.
* ACRE fix for Arsenal.
* Integrated Jeroen Logistics and changed Supply Truck Missions.
* Fixed RHS Civ Boat error.
* Several Arsenal and ACE improvements.
* Integrated Towing in script version by Seth Duda. Thanks!
* NATO no longer thinks they are in a frontline with neighbour NATO
* Fixed bunkers + AT defenses, which are back.
* Players gear is persistent saved in detail, no more "leave it in the ammobox before saving"
* Fixed armed civ spawning in water on CSAT punishments.
* Removed all the exclusive official servers stuff to give the features to everyone.
* Faster reinforcements.
* Removed thermal googles of the NV unlocking scripts. SDK AI will spawn with random googles when unlocked.




|

-----

|




Version 0.11.1 ALPHA
======================

.. note::
   6th March 2018

.. rubric:: Changes

* IMPORTANT: Undercover lose on roadblocks is affected by aggro. With low level, the soldiers wont recognise you and will allow you to pass.
* Optimised a bit actions appearing on flags upon capture.
* Chances of surrender appear when an enemy becomes unconscious and not only when killed or bleadout.
* Fixed bug that prevented QRF on mortar fire abuse.
* Imported from Altis the garbage cleaner (much faster)
* Improved a lot performance in zone ownership checks.
* Solved bug on SDK flags and JIP.
* Solved marker visibility on JIP and build HQ option.
* Corrected some small UPSMon bug.
* AI will be more aggressive when attacking and assaulting garrisons.




|

-----

|




Version 0.11.0 ALPHA
======================

.. note::
   25th February 2018

.. rubric:: Changes

* NEW FEATURE: Construct things. At last! Requires an engineer in your squad (or being player engineer). Trench classnames depend on the surroundings (urban, forest, field) and bunkers can be built for a price and in controlled zones. Bunkers wont despawn.
* Players can buy civilian boats in HQ.
* Added a few checks to avoid AI get stuck in the carry animation.
* Moved the "Building Options" from Y menu to "Manage Garrisons" HQ Flag Option.
* Solved bug on persistent save.
* Removed eternal loop on situational music script.
* Removed infinite loop for statistics. This author owes the whole community several billions of GHzs :)
* Parked civ cars wont never spawn in players nose.
* NATO Repair trucks should spawn in better places.
* Changes on taks structure to avoid JIP issues (we pray).
* Solved bug which spawned tons of static weapons when the AI gunner was unconscious.
* Purchased boats will spawn in the closest possible shore point.
* Limited Aggro levels according to War Level.
* POWs wont have rifles on liberation.
* Removed small bug on garrison window.
* Halved distance checks to select a base as attack departure.
* Map position wont be reset when re-selecting options.
* Increased chance of enemies spawning with NV when it is unlocked.
* Raised a bit convoy speed.
* Solved the "unconscious train" bug on vanilla revive.
* Heavy economic (only) penalties on Maru's death.
* HC groups get removed from the HC bar when they are assigned to a garrison.




|

-----

|




Version 0.10.4 ALPHA
======================

.. note::
   20th February 2018

.. rubric:: Changes

* New Feature: Replaced Sentry squads with MG static squads. Managed by HC module, they will mount an MG when they reach their destination.
* New feature: SDK Roadblocks can be managed as garrisons, have cache of units and get persistent saved.
* New feature: hiring an specialist without having it's weapon unlocked will make spawn the class with proper skills, but with one unlocked rifle.
* Disabled the remove outpost button as remove garrison options does the trick.
* Fixed some wheeled vehicles pathfinding which were broken.
* War Level gets updated on city joning / leaving SDK
* More civvies spawn as default.
* Removed XLA compatibility as it is useless now.
* Mines shouldnt be unlockable.
* Solved some exploits on save + arsenal.
* Idle / busy status on outposts is now saved.
* Integrated minefield building system with Jeroen Arsenal.
* Reworked mortar squads and arty option, now you can combine more than one mortar squads for better effetc. Mortar squad are just another squad, when they reach their destination, they will assemble their mortar and the commander can issue orders.
* At last: Ammo missions show exactly where is the truck.
* Brute coded Informer and Traitor spawning to avoid some bug.
* Lower cost for ARs, GLs and AT soldiers. Higher for Militia.




|

-----

|




Version 0.10.3 ALPHA
======================

.. note::
   14th February 2018

.. rubric:: Changes

* NEW FEATURE: Player will be able to assign to garrison squadmates and HC controlled squads.
* Increased A LOT, A REAL LOT convoy cohesion. Convoy experience is much better right now. Ai behaviour improved too.
* Civ convoy trucks should behave as before.
* Troop transports number of units will depend on War Level
* Added lots of tooltips in the custom menus.
* Longer times to recover idle status for bases and outposts.
* Doubled War Level gains on conquests.
* AT men wont spawn with AA if AA unlocked.
* Big increase of distance to consider a convoy reached.
* Corrected small bug in money convoys when destination was not a city.




|

-----

|




Version 0.10.2 ALPHA
======================

.. note::
   13th February 2018

.. rubric:: Changes

* Major improvements on departure, drills, waypoints and procedures on AI attacks.
* Reverted no NATO attack on cities on early game.
* Cars and Trucks driven by AI will tend to stick on roads much more often.
* Surrendered troops ammoboxes shouldnt explode / burn.


Version 0.10.1 HOTFIX 11/02/2018 ALPHA

* Changes on attack waypoints werent applied by a mistake.




|

-----

|




Version 0.10.1 ALPHA
======================

.. note::
   11th February 2018

.. rubric:: Changes

* Enabled AI control on mortar squads.
* No more NATO assaults on cities until some War Level is reached.
* Truck troops wont disembark on main roads far away from their destination.
* Corrected small bug on airbase / outpost garrison change when an attack is sent.
* Increased ACE integration: city support and QRFs related to AI kills will be included.




|

-----

|




Version 0.10.0 ALPHA
======================

.. note::
   8th February 2018

.. rubric:: Changes

* IMPORTANT: Enemy QRF and major attacks affect garrison in departure zone. Hold an attack and decimate outpost / airport garrison.
* NV is unlockable again.
* When AI is supressing, they will receive vocal orders which player will be able to hear.
* AutoRearm now allows AI to pick vests from corpses if they find a better one.
* IMPORTANT: Removed AI Mortar truck but a cheaper and more reliable mortar team with a quadbike.
* IMPORTANT: We should see much more helis landing, instead of paradroping soldiers.
* Transport helis gun crews should be more aggressive.
* Garrison mortars now get deleted when removed garrisons.
* Less civ car spawning explosions.
* Outposts can have "busy" status.
* Enemy garrison status gets persistent saved (very tacky way, some more sphisticated is under study).
* Corrected bug in unlcocked assets for AI dress.
* Map Info now shows if Outposts are Idle or Busy.




|

-----

|




Version 0.9.8 ALPHA
=====================

.. note::
   25th January 2018

.. rubric:: Changes

* More usage of predefined positions on airports, so they become more challenging.
* More reliable enemy dead because of bleadout effects.
* Improved fastrope AI behaviour.
* Made distance for Fast Travel of 500 mts independent of fog status as it was not reliable and allowed to FT under fire easily.
* ACE: Added a few items.
* ACE: Solved ACE BUG, NOT MINE so medical items werent appearing in the proper section.




|

-----

|




Version 0.9.7 ALPHA
=====================

.. note::
   25th January 2018

.. rubric:: Changes

* HOTFIX: Jeroen Arsenal now working as host MP.




|

-----

|




Version 0.9.6 ALPHA
=====================

.. note::
   25th January 2018

.. rubric:: Changes

* IMPORTANT: Small QRFs may be launched from nearby outposts.
* IMPORTANT: Removed FPS limiter feature, as it was inconsistent and unreliable. Instead of that, Commanders will be able to set the aproximated max amount of AI he wants in the map. Careful with that, use it wisely.
* Roadblock and forest patrols conquer mechanics changed so some roadblocks and forests can be permanently destroyed with the advantage they get saved by the persistent saves system, only those who depend on a main zone will be reinitialised if the zone still belongs to the enemy.
* Corrected: cleared forests will get eventually filled with AP mines.
* SDK mortars now have some chance when firing of being assaulted / bombarded by enemy units in the vincity, and not only for receiving express QRFs or airbombs.
* Reworked a bit disembark procedures with hope no more very far away disembarks happen.
* Unconscious enemies should die easier.
* Civilian cars shouldnt kill your teammates.




|

-----

|




Version 0.9.5 ALPHA
=====================

.. note::
   21st January 2018

.. rubric:: Changes

* Traitor mission guards type depend on War Level.
* Corrected BIG bug in AI recruiting and weapon check.
* Arsenal updates more often.
* IMPORTANT: CSAT waits for advanced game to appear in the main island.
* Uncosncious units are not counted for conquering checks :)
* Removed membership requirements for accesing the ammobox
* When a human tries to revive, FA kits of the healed unit are takin in count.
* Shortened a lot distances for AI to decide to send a LAND QRF




|

-----

|




Version 0.9.4 ALPHA
=====================

.. note::
   22nd August 2017

.. rubric:: Changes

* NEW FEATURE: Added JAS. The finest Inventory system around the scene, built in by Jeroen Not (Thanks!!!) for Antistasi and one of the things makes Antistasi special :)
* NEW FEATURE: FPS monitor will dynamically adapt spawn distances smoothly to avoid serious drops. More Antistasi For All!!!
* NEW FEATURE: AI may carry static weapons in their backpacks, if in danger, they may decide to assemble them and use.
* IMPORTANT: FPS Monitor will run on server or garrison HC if one exists.
* Added some bulletproof to avoid a bug which prevents AI from taking territory when they attack.
* Attacks should be more smarter now.
* Bugfixed some errors on QRF script.
* Added something to avoid "insta death" on player.
* Unconscious units in vehicles should disembark.
* Refugees, traitors etc. shouldnt spawn in some blacklisted buildings (containers)




|

-----

|




Version 0.9.3 ALPHA
=====================

.. note::
   23rd June 2017

.. rubric:: Changes

* Hotfixed some garrisons not spawning.
* While BIS does not fix HC Bar squad order options, squads will spawn in Aware stance.
* changeX a inArea el undercover y revisar a qu� bando van los controlsX conquereds




|

-----

|




Version 0.9.2 ALPHA
=====================

.. note::
   23rd June 2017

.. rubric:: Changes

* Optimised mortar positioning routines.
* Optimised fog checks.
* Corrected: When CSAT unlimiuted attacks reached timout they were constantly spawing and loosing.
* FPS checks won't be done for player recruiting squads




|

-----

|




Version 0.9.1 ALPHA
=====================

.. note::
   18th June 2017

.. rubric:: Changes

* Hotfixed timeout for friendly AI bleedout.
* When a HC disconnects, mission finishes to avoid malfunctions. A finer solution is WiP but wont be 100% perfect.
* Map will be forced to be open when Maru dies and the commander has to select a new HQ position.
* Re enabled vehicle dismount on unconscious as engine is not reliable on that.
* Fixed: Medics will be able to heal fatal wounds again.
* Fixed: R key shouldnt make respawn out of unconscious state, never.
* Fixed wrong message when player was unconscious.
* Fixed error on road finding function.




|

-----

|




Version 0.9.0 ALPHA
=====================

.. note::
   16th June 2017

.. rubric:: Changes

* NEW FEATURE: Real Garrisons Cache. Garrisons are now composed of combinations of types of soldiers and it works on cache mode (you kill an AT man, go to base, go back, that AT man no longer spawns). AI decides dynamically and with real units and vehicles to send reinforcements, if they reach their destination, they are added to the garrison.
* NEW FEATURE: Killzone avoidance. AI will think twice to send reinforcements, QRFs, convoys etc. to some places which may have been proven as killzones.
* NEW FEATURE: Air battles. AI will make use of Jets or any Plane with AA capabilities to fight other Air units.
* IMPORTANT: OLDER SAVES WONT BE COMPATIBLE. YOU WILL HAVE TO RESTART.
* IMPORTANT: PLayers wont be able to capture Airports until SDK reches War Level 3
* Fast Travel in MP allowed in groups of humans. Only leaders will make AI FT, the other humans will FT alone.
* Owning airports will give some bomb run points from time to time.
* Reinforcements Convoy bonuses re enabled. Now they reinforce the garrison with whatever reaches the place.
* Reduced number of default AI troops in resources.
* Corrected issues on patrol spawning.
* Corrected: AI trucks were full no matter FPS in case of major attacks.
* AI trucks were having Getout waypoints in wrong places.
* Corrected bug on squad recruit.
* Corrected bug on major attacks which spawned only arty under certain conditions
* AI will risk to heal players, but only players.
* Corrected heavy bug on changing spawn distance settings.
* RHS: Corrected flashlights on russians.
* RHS: Corrected all arty modules.
* AirStrike planes now make Garrisons spawn.
* Faster attack despawn.
* RHS: Removed remaining vanilla NATO APC
* Corrected several bugs on QRF functions, no QRF was spawning or departing.
* Improved major attacks.
* Improved vectors for paradrop depending on type of vehicle.
* Revive for AI disabled when source damage is other AI faction.
* QRF composition adapted to their objective and whats on the field.
* convoys are snesible to killzones, and none will be a convoy destination.
* No busy bases because they sent an air QRF
* Distances for despawn vehicles are now calculated in 2D mode.
* Removed pilots from airports (they added little ambience, and more lag)
* Corrected carry bug on MP, players couldnt get healed after carried.
* Re-enabled Fastrope and disembarks on airport attacks.
* Less stuck parachuted AIs
* Unconscious units in water die very fast.
* With one HC, AI load will be shared with the server, instead of everything going to the HC.




|

-----

|




Version 0.8.2 ALPHA
=====================

.. note::
   8th June 2017

.. rubric:: Changes

* IMPORTANT: Made the whole spawning process on groups fps dependant. Groups will spawn with a minimum of one unit.
* RHS GREF: Added some default grenades, SMGs and vest. Players lose their vanilla vest on connection.
* TFAR: Default greenfor radio unlocked.
* XLA Fixed Arsenal: Integrated & Recommended
* Re enabled asset move.
* Spawn distances corrected when FPS monitor changes them automatically.
* RHS: Enabled Build Minefield function




|

-----

|




Version 0.8.1 ALPHA
=====================

.. note::
   5th June 2017

.. rubric:: Changes

* Fixed bug on dedi server when buying a civilian truck.
* Spawn distance parameters correctly updated on persistent save.




|

-----

|




Version 0.8.0 ALPHA
=====================

.. note::
   4th June 2017

.. rubric:: Changes

* NEW FEATURE: Spawning system reworked, AI will spawn AI again under some limited conditions. More reliable, smoother game and more realistic. Under heavy testing, please report if you find any frozen soldier.
* NEW FEATURE: Revive greatly reworked. Carry injured, AI compatible. Less insta kills.
* NEW FEATURE: Revive extended to all the factions.
* NEW FEATURE: Full RHS integration. I recommend the whole USAF,AFRF and GREF set. But all of them are optional. GREF is integrated with weapons and vehicles + FIA side is changed by Chdk units.
* Easier conditions for spawning an enemy convoy.
* Shorter range of attack of each airport.
* Name of the soldier to be revived is shown in the action menu.
* No damage animations for buildings on Pers. Load.
* Bulletproofed a bit garrison variables in order to ensure everything runs well.
* Undercover looters may lose undercover.
* Corrected small bug on QRF scipt related to aisstrikes which caused some QRFs dont work again.
* Corrected small error on convoy success
* Fast Travel will spawn more early the destination zone.
* Supply missions with informer will spawn Vans in proper roads.
* No more CSAT Punish and simultaneous Major Attacks.
* More chances AI call a QRF.
* AI dying becaouse of bleedout time will affect prestige, garrisons etc.
* Raised bonuses and maluses for city support when a CSAT Punish finishes.
* Mortars shouldnt fire at flying units
* Some corrections on AI threat eval procedures
* Corrected small bugs on NV Goggles unlock.
* More carried units on big transport vehicles .




|

-----

|




Version 0.7.2 ALPHA
=====================

.. note::
   23rd May 2017

.. rubric:: Changes

* NEW FEATURE: "I hate the fog" action on HQ lamp. It will remove the fog, that simple.
* Fog checks are back and improved! AI will make decisions depending on fog status on target positions.
* No more need to kill the driver to steal a civilian transport, now a few shots to the vehicle will scare him and make him dismount.
* Tanoaised breifing thanks part to those who helped on this edition.




|

-----

|




Version 0.7.1 ALPHA
=====================

.. note::
   22nd May 2017

.. rubric:: Changes

* Improved garrison system, better, faster, smoother.
* Corrected bugs on ACRE support.
* Corrected a few bugs on AI attacking procedures.
* AI should get less stuck unloading weapons on AutoLoot.




|

-----

|




Version 0.7.0 ALPHA
=====================

.. note::
   11th May 2017

.. rubric:: Changes

* NEW FEATURE: Major attacks now may consist on several waves, converting them in authentic battles. The number of waves depends on several factors.
* NEW FEATURE: Added ACRE compatibility. Radios are unlocked by default.
* NEW FEATURE: War Level. Represents how much the war is evolved depending on SDK progression. It affects several things. Most of them before this were depending on SDK Skill which made players not upgrade skill to find the game easier. War Level limits a lot of options.
* IMPORTANT: Arsenal weapon unlock will now count total ammount of weapons per category, and unlock a random one from the ammoboxes (the more of the same type, the more chances to unlock that weapon).
* QRFs will be sent even in CSAT vs NATO situations.
* Tweaked a bit handle damage for AI and saved some performance on the helmet removal scripts.
* Corrected bug on air bomb runs.
* AI wont use smoke when fighting AI (NATO vs CSAT).
* Major AI vs AI attacks will spawn nearby defensive territories such as roadblocks etc. More war.
* Civs in vehicles won't go to be supplied.
* Reverted fog decisions: BIt is impossible ATM to know how much fog is in a zone.
* Corrected stone age bug: Heal and Repair could repair destroyed vehicles.
* When AI takes AI airport, some surrounding territory will pass to attackers territory automatically.
* AI won't attack AI territories if they have an enemy airport nearby.
* Tweaked: SDK will know attack destination depending on RT owned. No matter destination's owner.
* Raised a bit chance success on radio detection and made it war level dependant.
* FIA or NATO garrisons will spawn depending on war level + if the zone is hot.
* Weapons looted by POWs go to the ammobox if not unlocked.
* Small QRF waves re enabled again
* Reinforcement groups wont count as refundable on Persistent Save.
* Corrected error on conquering checks upon QRF.
* Small UAVs will despawn properly.
* Corrected bug in add garrison scripts.
* Some nice info about how many items you have in the ammobox for the unlocking count.
* Corrected: Reive telling the player there is no AI to revive when the AI is able to heal but busy. Once it's idle if matches the conditions will try to heal the player.
* Deleting a watchpost wont refund a roadblock
* Increased a lot time required to renceive assets for NATO and CSAT
* NATO big assets wont spawn on early stages.
* AI won't likely attack more airbases if they have still without control big part of their islands.
* Weather and fog persistent saved.
* Airports only spawn available vehicles.
* Corrected heavy bug on AI vehicle availability so it was not working at all.
* Added some control so fog wont reach a totally insane number. Still WiP.
* SDK AT men may spawn with other unlocked launchers.
* More aggressive NATO if they are corenered with one Airport.




|

-----

|




Version 0.6.3 ALPHA
=====================

.. note::
   5th May 2017


.. rubric:: Changes


* NEW FEATURE: Autoloot. If you order Auto Rearm a man inside a vehicle, instead of picking new weapons he will scavenge corpses for weapons and place them in his vehicle until he finds nothing more. After that he will pick his old weapon.
* NEW FEATURE: Fatal Wounds. Wounds in the head can be only healed by medics. Helmets prevent those, until you lose them..
* Increased timing between major attacks.
* Reduced NATO aggro increase on each kill.
* Increased damage tolerance when unconscious so players will find less "insta death" situations.
* Civvies should be impossible to kill by AI running through them.
* Chances of receiving a counter battery action will depend on how static the battery has been.
* No more teleport to unconscious player. If AI due to pathfinding issues does not reach the player, he will be healed anyway.
* Reduced enemy distance check on destination when fastraveling in MP.
* No air attacks, big or small under heavy fog.
* Autorearm for AI now orders them to pick FA Kits and backpacks if needed.
* Corrected AI looting AT rockets when autorearm is on.
* Improved and bugfixed a bit AutoRearm code.
* No sniper groups spawn with dense fog.
* Fog affects Fast Travel enemy distance checks.
* SDK will know after some time where the attack is going if they are targeted.




|

-----

|




Version 0.6.2 ALPHA
=====================

.. note::
   4th May 2017

.. rubric:: Changes

* Non TFAR players won't lose Radio on Pers. Load if Radios are unlocked.
* Corrected bug on QRF for CSAT
* AI will allways search for main roads to unload vehicles on attacks.
* No need to destroy the UAV to consider jungles as cleansed of SpecOp patrols.
* Garrisons in cities now spawn correctly.
* Land AI Road patrols will have allways a good road segment as destination.
* Added negative bonuses for time to recover NATO vehicles when they are destroyed.




|

-----

|




Version 0.6.1 ALPHA
=====================

.. note::
   3rd May 2017

.. rubric:: Changes

* HOTFIX: SDK Garrisonws were not spawning.
* Civ "patrol" cars won't go allways to city centres.




|

-----

|




Version 0.6.0 ALPHA
=====================

.. note::
   3rd May 2017

.. rubric:: Changes

* NEW FEATURE: SDK Cities are now garrisoneable, NATO will attack them. This will add an uncommon theatre of war in Antistasi.
* IMPORTANT: As this is an Alpha I decided to "free" the mission to any open coop server, in its current state of development mission is playable and I don't have all the time I need to work on it.
* No idle for airports when they send a QRF.
* Raised a lot money gain in SP on each kill in early stages.
* Bonused SP Deliver the Truck influence in early stages.
* Corrected bug spawning NATO arty on major attacks.
* CSAT wont send supply convoys to cities.
* Increased skill on Gendarmes and FIA




|

-----

|




Version 0.5.2 BETA
====================

.. note::
   26th September 2016

.. rubric:: Changes

* Enemy AI Skill will have some limit on how good is doing Syndikat and not depending on Sydikat skill level.
* When Maru dies no unlocked mags will be locked.
* SDK players cannot FT to CSAT places.
* Only Syndikat players won't be attacked by AI when unconscious.
* MP Syndikat HQ AI garrisons are Rambo elite Maru's guard.
* Reworked NATO players options. With Y key they will be able to Fast Travel or get a Quadbike for their own use.
* Near garrisons are now removed properly.
* Tailored briefing for non Syndikat players.
* When CSAT attacks, timer for next counterattack will be much lower.




|

-----

|




Version 0.5.1 BETA
====================

.. note::
   26th September 2016

.. rubric:: Changes

* Tweaked Arsenal: Now requirements are constant, not affected by factories.
* Added a message on mission init so newcomers have an introduction to the persistent save system.
* Added some delay to the prisoner rescued count in case player comes back to HQ with Fast Travel
* Corrected small bug on convoy missions.
* Added all possible vanilla backpacks, vests, optics etc.
* If selected weapon to add to militia is the default one, then no weapon replacement procedure is done.
* AI will use suppresive fire when doing retreating maneuvres.
* Reduced enemy required distance to make AI surrender.
* Corrected lots of issues with JIP and mousewheel actions.
* Major land attacks will have the units more coordinated.
* Y key re enabled on init.
* More tweaks on revive. Unconscious units won't die because of small damage while unconscious.
* Tweaked skillsets for AI squad leaders.
* Tweaked spotting skills for AI during night.
* Logistic Missions Ammotrucks no longer spawn in small roads.
* Tweaked and improved undercover for AI.
* Corrected aggro gains when cities change sides.
* Removing a Watchpost wont refund a roadblock.
* Convoys behave much better (not thanks to BIS latest update)
* Optimised ammobox loadouts to spawn only locked assets and more weapon numbers.




|

-----

|




Version 0.5.0 BETA
====================

.. note::
   18th September 2016

.. rubric:: Changes

* NEW FEATURE: Tiered missions. As you progress in game some missions will require a contact in some city which will provide relevant info. Tier 2 missions will be harder and with some additional difficulties. Bonuses and penalties will be higher too. Those informants are treacherous, they may report you too...




|

-----

|




Version 0.4.6 BETA
====================

.. note::
   18th September 2016

.. rubric:: Changes

* Added markers on HQ placement selection for visual aid.
* Tweaks and bugfixes on revive.
* Heavy increase radius for air assaults.
* AI will target SDK zones from any airport no matter if it's in the same island or not.
* Higher defenses on CSAT Airports.
* SDK Watchpost and roadblocks wont make SpecOps spawn in jungles.
* Taken airports won't be busy for one hour.
* Attacking airports will become busy only after their attack has finished.
* Corrected info markers script.
* Maru's reinforcements will be on foot to avoid issues with Tanoa roads.
* Faster Convoys.




|

-----

|




Version 0.4.5 BETA
====================

.. note::
   16th September 2016

.. rubric:: Changes

* Attacking AI will be a bit more effective.
* Removed LMG of default unlocked pool, changed by a cheap Sting but compatible with flashlights.
* Removed Altis FIA uniforms on Arsenal.
* Added Gendarmes vests as unlockable in Arsenal.
* SDK AI will have smoke grenades if any of them has been unlocked.
* Gendarmes will have better loadout as long as you progress in game.
* Corrected bug on CSAT punish which collpases the game.
* Redress for some SDK models.
* Mags correctly removed when AI spawns with random rifle.
* Removed all the playable slots in SP
* Made NV use depend on game progress, only specops and squad leaders will have mandatory NV. More flashlights, darker nights, more fun!
* AI will consider hot zone any with relevant enemie zones around




|

-----

|




Version 0.4.4 BETA
====================

.. note::
   13th September 2016

.. rubric:: Changes

* Optimised AI where to attack procedures. No more 99% chance the target will be the central airport.
* Corrected bug in Outpost garrisons.
* Corrected small bug on rangefinder unlocking.
* Fixed small bug on jungle minefields.
* Garrisons on zones under a major attack won't get saved to avoid exploits.
* Corrected bug on spawning SDK city garrisons.
* Added other types of possible AI squads to spawn.
* Added some texture to the map board.




|

-----

|




Version 0.4.3 BETA
====================

.. note::
   13th September 2016

.. rubric:: Changes

* Killed a few more suspects of the lockup server bug.




|

-----

|




Version 0.4.2 BETA
====================

.. note::
   12th September 2016

.. rubric:: Changes

* Removed small bug to remove some mousewheel actions from the player
* Corrected bug on AI attack target scripts.
* Corrected bugs on refugees mission.
* Assassination missions are now in the right distance.
* Map info now shows correct info on influence.
* SDK deaths affect NATO/CSAT aggro.
* Garrisons get right updated when AI takes AI zones.
* Optimised sea spawn points and air land points to get rid of BIS_fnc_findSafePos
* Lesser unlocking requirements.
* Bulletproffed vehicle availability functions.
* Convoys can be FIA now.
* Roadpatrols can be Gendarmes and FIA.
* AI wont spawn with AK12
* AI wont autorearm with basic stuff
* Bulletproofed a bit more undercover for AI.
* More tweaks on revive AI.
* Corrected vehicle availability check procedures.
* Less chance for NATO to build a major attack on airports.




|

-----

|




Version 0.4.1 BETA
====================

.. note::
   8th September 2016

.. rubric:: Changes

* IMPORTANT: REINFORCEMENT CONVOYS. AI will use them to boost their garrison reinforcements when needed.
* Halved auto reinforcements on each tick.
* Evil warlords may sell those supply trucks instead of making the delivery and fail the mission in change of some decent money.
* Our beloved workers are back, careful with mortars!
* Some chance AI rebuilds a resource on each tick.
* Replaced our mean old campfire by a modern camp lamp, which you can turn on and off.
* Lights off when a city or it's nearby RT are destroyed.
* Severe tweak of AI skills, as SDK was supposed to be equal than NATO/CSAT.
* Corrected Interrogate script bug.
* Corrected server init bug which made initialisation 2 minutes longer in MP
* Disabled introshot as it is causing some issues.




|

-----

|




Version 0.4.0 BETA
====================

.. note::
   3rd September 2016

.. rubric:: Changes

* Land vehicles will try to use main roads!!!
* Fixed skill for SDK nor getting saved and loaded.
* Fixed bug on artillery in CSAT pubishments.
* More dense carpet bombing.
* Civilian boats spawn in coastal cities shores. They are undercover vehicles with no zone limits.
* Added Tanoan models to possible spawned civs.
* SpecOps missions out of Outposts.
* Less time to recover planes for AI.
* Hunted some "AAF" here and there.
* AI will attack airports even without planes if their enemy has no AA available.
* Garrison status affects AI where to attack decission making.
* Rescue sidemissions on low NATO Aggro will spawn Gendarmes.
* AI skill adjusted for FIA and Gendarmes.
* Tweaks and bugfixes on revive scripts.
* Ensured a bit more AI carwheels are preserved if not fired by enemies.
* Corrected small bug in conquest roadblock missions.
* Reduced a lot minimum distance to send a Convoy.
* Expanded zone type destination on convoys.
* Added a lot of vehicles to sell.




|

-----

|




Version 0.3.3
===============

.. note::
   1st September 2016

.. rubric:: Changes

* IMPORTANT: In SP. 50 seconds timeout to get healed by AI for player, after that, if AI is stuck and trying to heal, player will be conscious again, but with heavy damage.
* Corrected error when AI embarked a garrison vehicle
* Players won't see attacking AI despawning.
* AI uses real arty on major attacks.
* Fixed money add on kills.
* Removed the gamey message of money earnt on each kill
* No more conquest missions in specop patrolled jungles.
* Kill SpecOps missions moved to the jungle.
* Tweaked a bit the spawn point from Ovau Airbase so maybe convoys will run better.
* Added small drones to SpecOp patrols in jungles.
* Attempt to avoid the recurrent bug on undercover AI losing weapons when lose undercover.
* Defend Maru missions properly ported from Altis, they depart for an Airbase.
* Attempt to find alternative to BIS_fnc_findSafePos for having suitable land positions for attacking helis.
* Removed NATO Tanoa UAV as attack heli because it does not attack infantry.
* Reworked task system in Convoy missions.
* Almost 100% of the sidemission actions will give task or notification for NATO players.
* Removed the overpowered AK12 from default unlocked stuff. It may appear in NATO/CSAT boxes.
* Resources added as possible targets of conquest missions.
* Corrected name of SDK Outposts / Roadblocks on Load.
* Outposts can be FIA now.




|

-----

|




Version 0.3.2
===============

.. note::
   30th August 2016

.. rubric:: Changes

* The ULTIMATE measures to improve FPS. If a player has issues, change config or... buy a new PC.
* Really improved performance on distance spawn check script.
* Airstrikes won't be performed if enemy has no planes available.
* When multiple Airstrikes are done, only the first will try to destroy the zone assets, the following will aim to damage troops etc..
* Some tasks / notifications added to NATO players.
* Reduced a bit distance checkings for HQ placement selection.
* CSAT zones will make you lose Undercover.
* When in a civ heli undercover, instead of roadblocks and outposts, Airbases will have a no-fly area that will make player lose Undercover.
* AA tanks don't despawn inmediately.
* Bomb Run planes won't get despawned inmediately when shot down if players are there.
* More clever AI major attacks, AI will share better the info.
* Collision lights of some planes turned off while flying.
* Paratroopers are now doing real jumps instead of fake ones, and use sterable chutes.
* Parked helis won't pop smoke when AI embarks/disembarks.
* Airbase vehicles won't despawn when AI board them.




|

-----

|




Version 0.3.1
===============

.. note::
   28th August 2016

.. rubric:: Changes

* Greatly improved spawning garrisons with all the cache related.
* Tasks on enemy or friendly major attacks no matter if you are the target or not.
* Tweaked a lot spawning numbers on AI major attacks.
* Tweaked a lot simulation enablement on several situations to improve FPS.
* Assigned cargo units of attacking transports wont make spawn anything (the crew does).
* SDK HQ won't be counted to spawn Specop patrols in jungles.
* Limited napalm strikes to one each time to save fps.
* Removed Bobcat from NATO APC vehicle pool as it has no passenger seats.
* More reliable convoys.
* More consistent convoys.




|

-----

|




Version 0.3.0
===============

.. note::
   28th August 2016

.. rubric:: Changes

* IMPORTANT: jungles are no longer a sure safe position. SpecOp patrols cover the area if AI feels there is insurgency nearby. If SDK kills all the patrols, they will respawn in the same way roadblocks do. Sometimes, AI will decide to reinforce the area with mines.
* Traits on engineers and medics applied to SDK AI too.
* Dead AI teammates will get the "Revive" action deleted.
* Refugees Evac: On NATO cities a Police car will spawn nearby to help the player on his search.
* Convoys wont spawn during major attacks.
* AI wont attack refugees when delivered at HQ.
* Crew of downed AI Air vehicles will auto-die to reduce spawned units in the field.
* Counter for major attacks will never be less than zero.
* Added a lot predefined placed roadblocks.
* Fixed delay when Petros was killed.
* Few pesky "FIA" here and there.
* Some anti lag measures when AI attacks an Airbase.


Version 0.1.2.4
=================

.. note::
   27th August 2016

.. rubric:: Changes

* IMPORTANT: Loosing condition: 1/3 of the total population is massacred by CSAT. Number will be shown on "Map Info".
* IMPORTANT: R key to respawn.
* IMPORTANT: Win conditions: more then half of the population supports SDK and SDK owns all the airports.
* Improved AI vehicle unstuck functions.
* "FIA" replaced by "SDK" in a few texts.
* Changed model for SDK crewmans (FIA model, as BIS does not give us a proper unarmed SDK soldier)
* Arty/Bomb run markers are now local for the SDK Commander.
* MAP info will report enemy garrison status.
* AI will try to avoid NAPALM.
* Changed default unlocked backpack.
* Randomised grunts rifles.
* Added Tanoa NATO drones as attack helis
* Added backpacks to the possible AI ammocrate loadout.
* Added temporal inmunity for Maru just in case he dies because of NAPALM.
* Changed speed waypoint params for Convoys by suggestion of one player. Under testing.
* Airstrikes in QRF were accidentally half removed.
* Unconscious units will disembark from vehicles before reaching unconscious state.
* AIs from sidemissions won't make anything spawn.
* Fixed when commander disconnects and despawns his AI + vehicles despite he's got players in his group.


Version 0.1.2.3 BETA
======================

.. note::
   26th August 2016

.. rubric:: Changes

* Tweaked here and there Undercover and Revive to prevent some bugs MP related.
* Medics are now truly medics.
* Added ragdolling and nice effects for uncosnscious state.
* Added 30 secs respawn delay.
* When players respawn they will remain in control of their IEDs planted before dying.
* Tweaked bonuses when central airport is attacked.
* Corrected clear forest in MP.
* Engineers will be able to disarm bombs.
* Ammo and repair trucks will spawn on near roads on their respective missions.
* Deads by NAPALM burn a bit like campfires for some time.
* NATO WONT send a QRF to defend a city under attack if it's SDK.




|

-----

|




Version 0.1.2 BETA
====================

.. note::
   24th April 2016

.. rubric:: Changes

* NEW FEATURE: Commanders can clear the nearby forest in order to have more space for their vehicles. Persistent Save integrated.
* Evac Refugees can happen in NATO cities with substantial differences between NATO and CSAT mission types.
* So, removed the +1 HR bonus.
* Corrected heavy bugs on CSAT punishments.
* CSAT Punish defending civvies number spawned independenty of the spawn rate.
* Map info shows "NONE" when city is supported by a radio tower in a CSAT outpost.
* Corrected: Lose Undercover if you kill an enemy running through him with a vehicle.
* Corrected major bug in Traitor missions.
* City support changes on each kill no matter if it's SDK or not.
* Solved undercover issues when players FFV.
* Changed the name of "Airports" to "Airbases".
* NATO Garrisons increased a bit if they are guarding a RT.
* Tweaked bonuses for defeating a CSAT attack depending on several params.
* NATO players will receive major attacks tasks.
* Earplugs script added to NATO players.
* NAPALM destroys forests.
* Units respawn in their proper respawn point once they finish their punishment.
* Corrected RT Rebuild bug.
* Prestige values saved correctly.




|

-----

|




Version 0.1.1 BETA
====================

.. note::
   24th April 2016

.. rubric:: Changes

* Fixed Persistent Save: It wont corrupt Altis saves.
* Corrected Maru respawning as Petros.
* Corrected punishment if SDK player kills a NATO player.
* Added an additional radio tower.
* Small bugfixes on fastrope.
* Flashlights should be used by SDK units (if no NV).
* Added unlocked optics for any SDK rifle users (no marksmen)
* Added Titan AA for militia if unlocked and skillcheck is ok.
* Added NV if unlocked too.
* Dogs dont make you lose Undercover if you are in a vehicle.
* SDK players no longer see NATO players markers.
* Engineer players can now repair vehicles.
* Officer players can now hack UAVs.
* NATO rebuilds towers again.
* Corrected refugees missions: they will only spawn on destroyed cities.
* Small +1 HR bonus on each Tax Report.
* Safer Convoy spawn.
* Fixed NATO player taxis.
* Added cleanser and punishment functions for NATO taxis.
* Added disconnected and connected functions for NATO players.
* NATO players no longer see SDK markers.
* NATO players receive notifications on certain SDK actions (supplies delivered on cities etc.).
* Markers update correctly on Pers. Save.
* Increased a bit the distance to land for helis as they are crashing a lot with trees.
* AI won't attack other islands targets except Airports on major attacks.
* CSAT Starts controlling the whole NW island.
* Fixed bug on initial HQ placement.
* Greatly improved safety and speed on despawning procedures.
* Halved Quadbike cost.
* Gendarmes and FIA will use flashlights.




|

-----

|




Version 0.1.0 BETA
====================

.. note::
   24th April 2016

.. rubric:: Changes

* Initial release