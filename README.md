# Arma 3 > CSWR: Controlled Spawn & Waypoints Randomizr v2
>*Dependencies: none.*

A simple and controlled spawn and waypoints solution where groups of units and vehicles will be randomized through marks in your mission. 

**How to install / Documentation**
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

## Xxxxxxxxxx

**Faction Spawns:** 
- Manually define which marks the faction can use as a spawn point.
- You can create a lot of spawn points for one or more factions.
- Once the spawn points are created, the script will spawn the groups randomly through the faction spawns.
- There is no re-spawn. Death is death. 

**Destination / Waypoints:**
- Manually define which marks will be used as waypoints.
- There are 2 types of destinations: those that can be visited by everyone; and those that only a specific faction can go to.
- Once the destinations are created, the script will take care of taking (or not) the groups there, randomly.

**Group Members:**
- Manually set the number of soldiers, who they are, who belongs in each squad, even vehicles.
- There are 3 infantry and 3 vehicle templates to customize: light squad; regular squad; heavy squad; light vehicle; regular vehicle; and heavy vehicle. 

**Strategy:**
- Manually define how many groups, what type of groups, if they will spawn chill or already aware, running etc.
- It does important you as editor set the movements through the field each group can consider randomly. 

## Ideas and fix?
https://forums.bohemia.net/forums/topic/237504-release-controlled-spawn-and-waypoints-randomizr/

## Changelog

**Jul, 6th 2022 | v2**
- A bunch of performance improvements;

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
