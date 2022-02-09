# Arma 3, Controlled Spawn and Waypoints Randomizr v.1.2

A simple and controlled spawn and waypoints solution where groups of units and vehicles will be randomized through marks in your mission. 

**Faction Spawns:** 
- Manually define which marks the faction can use as spawn points.
- You can create unlimited spawn points for one or more factions.
- Once the spawn points are created, the script will spawn the groups randomly through the faction spawns.
- There is no AI re-spawn. Death is death.

**Destination:**
- Manually define which marks will be used as group destinations.
- You can create unlimited destination points for one or more factions.
- Once the destination points are created, the script will consider (or not) them randomly when the groups are moving.
- There are 2 types of destinations: those that can be visited by everyone; and those that only a specific faction can go to.

**Moving:**
- From destination to the next one, only one waypoint per group will be created automatically, so each group moving will head straight on. 
- There are 3 types of group movement: groups that go randomly and only to their faction's destinations; groups that go randomly and only to destinations shared with other factions; and groups that go randomly to any configured destination, ignoring rules.
- By default, groups will move forever from spawn to waypoints and, from there, to the next one, randomly waiting (you set the timeframe) to heading toward.

**Groups:**
- Manually set the number of soldiers and vehicles per faction group type.
- There are 3 infantry and 3 vehicle templates for you to customize: light squad; normal squad; heavy squad; light vehicle; normal vehicle; and heavy vehicle.

**Strategy:**
- Manually define how many groups, what type of groups, and how the random moves of each group in the faction will be. 

# Ideas and fix?
https://forums.bohemia.net/forums/topic/237504-release-controlled-spawn-and-waypoints-randomizr/

Cheers, thy.

# Changelog

**v1.2 Feb, 9th 2022**
- Zeus now can see all units and vehicle spawned of the script;
- Fix the missing global and private variables declaration;
