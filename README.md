# Arma 3 / CSWR: Controlled Spawn & Waypoints Randomizr v3.2
>*Dependencies: none.*

CSWR is a simple and limited script that spawns AI units once right before the mission starts and makes those units move randomly to waypoints forever in life, where spawn points and waypoints are pre-defined by Mission Editor through Eden marker's positions. CSWR is able to spawn also ground vehicles with their crewmen, and accept pretty well unit loadout customization.
CSWR doesn't change any original AI behavior after the spawn*.

(*) Except in the case of vehicles with turrets, the CSWR forces its gunners to stay in the turrets, shooting to death, without ever disembarking.

## HOW TO INSTALL / DOCUMENTATION

video demo: https://www.youtube.com/watch?v=rpzIr0r03ZQ

Doc: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/controlled-spawn-and-waypoints-randomizr.VR/CSWRandomizr/_CSWR_Script_Documentation.pdf

__

## SCRIPT DETAILS

- No dependencies from other mods or scripts;
- Manually define which marks the faction can use as spawn points;
- You might create unlimited spawn points for one or more factions;
- Once the spawn points are created, the script will spawn the groups randomly through the faction spawns;
- There is no re-spawn. Death is death for those units; 
- Vehicles with turrets spawned by CSWR, when damaged, their gunners never leave the vehicle, doing the last standing in combat until death;
- Manually define which markers will be used as destinations (waypoints);
- There are 2 types of destinations: those that can be visited by everyone; and those that only a specific faction can go to;
- Once the destinations are created, the script will take care of taking (or not) the groups there, randomly;
- Manually set the number of soldiers, who they are, their loadouts, who belongs in each squad type, and even ground vehicles;
- There are 6 infantry and 6 vehicle templates to customize for each faction; 
- Define easily how many AI groups are in-game, what squad types are, and their initial behavior: safe, aware, stealth, combat, chaos;
- All vehicles and units spawned by CSWR can be (ON/OFF) editable by Zeus;
- Set if the script should wait for another script load first on the server;
- Debugging: friendly error handling;
- Debugging: hint monitor to control some numbers;
- Debugging: full documentation available.

__

## IDEA AND FIX?

Discussion and known issues: https://forums.bohemia.net/forums/topic/237504-release-controlled-spawn-and-waypoints-randomizr/

__

## CHANGELONG

**Feb, 12th 2023 | v3.2**
- Improvement > If the mission editor sets spawnpoint markers or destination markers out of the map, they get a warning and the marker is ignored;
- Added > Included more options to customization vehicle composition (from 3 types to 6);

**Feb, 9th 2023 | v3.0**
- Added > Added an option that the mission editor sets a timer before the CSWR starts to run;
- Added > Included more options to customization infantry composition (from 3 templates to 6);
- Fixed > A huge server performance killer has been fixed (script was running on background without spawnpoints on map);
- Fixed > Spawnpoint markers are not visible anymore when debug mode if off;
- Improvement > Added a massive, friendly and automatic errors handling to CSWR, helping a lot the mission editor;
- Improvement > Lot of code reviewing;
- Documentation has been updated.

**Jan, 20th 2023 | v2.8**
- Improvement > You can define through fn_CSWR_loadout.sqf file a custom helmet for infantry and other only for heavy armored crewmen;
- Documentation has been updated.

**Oct, 18th 2022 | v2.7**
- Fixed > Crewmen were not getting customized loadout;
- Improvement > fn_CSWR_debug.sqf file has been merged with fn_CSWR_spawnsAndWaypoints.sqf one;
- Improvement > Now, mission editor has a specific file to customize their AI units: fn_CSWR_loadout.sqf;
- Improvement > Loadout function is much more reliable to custom;
- Documentation has been updated.

**Oct, 14th 2022 | v2.6**
- New > Now you also can customize the vest and backpack of each faction spawned through the CSWR Script;
- New > Vehicles with turrets spawned by CSWR, when damaged, its gunners never leave the vehicle, staying in combat until the death;
- New > All units and vehicles spawned by CSWR now are editable by Zeus in-game when Zeus is allowed in the mission;
- Documentation has been updated.

**Aug, 10th 2022 | v2.5**
- Now it's possible to customize the loadout for each spawned faction;
- Documentation has been updated.

**Jul, 14th 2022 | v2.1**
- Added "Stealth" as an option for spawned units/vehicles;
- Improved the vehicle creation, now each vehicle has its electronics/signals configured when available;
- Improved the Editor option to turn On and Off a faction;
- Documentation has been updated;

**Jul, 8th 2022 | v2**
- Fixed vehicles spawn problems when a lot of them;
- Fixed infantry could not walk properly if in "safe" behavior;
- A bunch of performance improvements;
- Documentation has been included;
- initServer.sqf has been removed.

**Feb, 22nd 2022 | v1.5.5**

- Fixed for dedicated servers: now the script is called through description.ext function and not more initServer.sqf execVN;
- Improved: automatic setMarkerAlpha for destination and spawn point markers;
- Adjustment: function names.
- Removed "waitUntil" for player.

**Feb, 10th 2022 | v1.2.1**

- Zeus now can see all units and vehicle spawned of the script;
- Fix the missing global and private variables declaration;
- Map changed from VR to Stratis for honest testing results.

**Feb, 3rd 2022 | v1.0**

- Hello world.
