/* 
//---------------------



	CSWR: CONTROLLED SPAWN AND WAYPOINTS RANDOMIZR (Version 1.5.5)
	by thy (@aldolammel)
	
	Github: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script
	Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2740912514
	Discussion: https://forums.bohemia.net/forums/topic/237504-release-controlled-spawn-and-waypoints-randomizr/
	
	
	
//---------------------


	## FACTION SPAWNS:

	Manually define which marks the faction can use as a spawn point.
	You can create a lot of spawn points for one or more factions.
	Once the spawn points are created, the script will spawn the groups 
	randomly through the faction spawns. There is no re-spawn. 
	Death is death. 


	## DESTINATION / WAYPOINTS:

	Manually define which marks will be used as waypoints. There are
	2 types of destinations: those that can be visited by everyone;
	and those that only a specific faction can go to. Once the destinations  
	are created, the script will take care of taking (or not) the groups 
	there, randomly. You will use these commands below to set
	the waypoint of each group:  									

		CSWR_fnc_wpGoToAnywhere ....... go to anywhere / no rules.
		CSWR_fnc_wpGoToDestShared ..... go to where anyone may go (mainly civilian). 
		CSWR_fnc_wpGoToDestBlu ........ go to blufor special destination.
		CSWR_fnc_wpGoToDestOp ......... go to opfor special destination.
		CSWR_fnc_wpGoToDestInd ........ go to independent special destination.


	## GROUP MEMBERS:

	Manually set the number of soldiers, who they are, who belongs in each
	squad, even vehicles. There are 3 infantry and 3 vehicle templates to
	customize: light squad; regular squad; heavy squad; light vehicle; regular 
	vehicle; and heavy vehicle. 

	## STRATEGY: 

	Manually define how many groups, what type of groups, if they will spawn chill
	or already aware, running etc. It's does important you as editor set the movements
	through the field each group can consider randomly.



//---------------------
*/

private ["_noSpawnCollision","_bluSquadLight","_bluSquadRegular","_bluSquadHeavy","_bluVehLight","_bluVehRegular","_bluVehHeavy","_opSquadLight","_opSquadRegular","_opSquadHeavy","_opVehLight","_opVehRegular","_opVehHeavy","_indSquadLight","_indSquadRegular","_indSquadHeavy","_indVehLight","_indVehRegular","_indVehHeavy","_civAlone","_civCouple","_civGang","_civVehLight","_civVehRegular","_civVehHeavy","_bluGroup","_bluVehSpawn","_bluVehPos","_bluVeh","_opGroup","_opVehSpawn","_opVehPos","_opVeh","_indGroup","_indVehSpawn","_indVehPos","_indVeh","_civGroup","_civVehSpawn","_civVehPos","_civVeh"];
	
// if is not dedicated or hosted server, get out!
if (!isServer) exitWith {};

[] spawn
{

	// FACTION SPAWNS
	// Define where each faction in-game will spawn randomly.
	// For new spawnpoints, add a new "empty marker" on Eden, set its name and add the new marker down below:

		CSWR_bluSpawnPoints   = // BluFor spawnpoints
		[
			"bluSpwn01",
			"bluSpwn02",
			"bluSpwn03"
		]; 
		
		CSWR_opSpawnPoints    = // OpFor spawnpoints
		[
			"opSpwn01",
			"opSpwn02",
			"opSpwn03"
		]; 
		
		CSWR_indSpawnPoints   = // Independent spawnpoints
		[
			"indSpwn01",
			"indSpwn02",
			"indSpwn03"
		];
		
		CSWR_civSpawnPoints   = // Civilian spawnpoints
		[
			"civSpwn01",
			"civSpwn02",
			"civSpwn03"
		];
		
		
	// ................................................................................................................................................
	

	// DESTINATION: SHARED
	// Define where anyone (including civilian) in-game will move randomly.
	// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:
		
		CSWR_destinationShared = 
		[
			"destShared01",
			"destShared02",
			"destShared03",
			"destShared04",
			"destShared05",
			"destShared06",
			"destShared07",
			"destShared08",
			"destShared09",
			"destShared10"
		]; 

	// DESTINATION: FACTION
	// Define where each faction in-game will move randomly.
	// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:
		
		CSWR_destinationBlu = // BluFor destination:
		[
			//"destBlu01",
			//"destBlu02"
		];
		
		CSWR_destinationOp = // OpFor destination:
		[
			//"destOp01",
			//"destOp02"
		];
		
		CSWR_destinationInd = // Independent destination:
		[
			//"destInd01",
			//"destInd02"
		];
		
	
	// WAYPOINTS TIMEOUT
	// Define how long the group can wait randomly to move forward after reach a destination:
		CSWR_wpTimeOut = [5, 30, 60]; // in seconds: [min, average, max].


	// ................................................................................................................................................
	
	// CSWR CORE / TRY TO CHANGE NOTHING IN THIS SECTION:
	
		_noSpawnCollision = [30, 100]; // [radius, maxDistance]
		
		CSWR_allSpawnPoints = CSWR_bluSpawnPoints + CSWR_opSpawnPoints + CSWR_indSpawnPoints + CSWR_civSpawnPoints;
		
			{ _x setMarkerAlpha 0 } forEach CSWR_allSpawnPoints; // hiding the spawn markers.
		
		CSWR_destinationAnywhere = CSWR_destinationShared + CSWR_destinationBlu + CSWR_destinationOp + CSWR_destinationInd;
		
			{ _x setMarkerAlpha 0 } forEach CSWR_destinationAnywhere; // hiding the destination markers.
		
			CSWR_fnc_wpGoToAnywhere =
			{ 
				private ["_where","_wp"];
				params ["_grp"];
				
				_where = getMarkerPos (selectRandom CSWR_destinationAnywhere);
				_wp = _grp addWaypoint [_where, 0]; 
				_wp setWaypointTimeout CSWR_wpTimeOut;  
				_wp setWaypointStatements ["true", "[group this] spawn CSWR_fnc_wpGoToAnywhere"];
			};
			
			CSWR_fnc_wpGoToDestShared = 
			{ 
				private ["_where","_wp"];
				params ["_grp"];
				
				_where = getMarkerPos (selectRandom CSWR_destinationShared);
				_wp = _grp addWaypoint [_where, 0];
				_wp setWaypointTimeout CSWR_wpTimeOut; 
				_wp setWaypointStatements ["true", "[group this] spawn CSWR_fnc_wpGoToDestShared"];
			};
			
			CSWR_fnc_wpGoToDestBlu = 
			{ 
				private ["_where","_wp"];
				params ["_grp"];
				
				_where = getMarkerPos (selectRandom CSWR_destinationBlu);
				_wp = _grp addWaypoint [_where, 0]; 
				_wp setWaypointTimeout CSWR_wpTimeOut;
				_wp setWaypointStatements ["true", "[group this] spawn CSWR_fnc_wpGoToDestBlu"];
			};
			
			CSWR_fnc_wpGoToDestOp = 
			{ 
				private ["_where","_wp"];
				params ["_grp"];
				
				_where = getMarkerPos (selectRandom CSWR_destinationOp);
				_wp = _grp addWaypoint [_where, 0]; 
				_wp setWaypointTimeout CSWR_wpTimeOut; 
				_wp setWaypointStatements ["true", "[group this] spawn CSWR_fnc_wpGoToDestOp"];
			};
			
			CSWR_fnc_wpGoToDestInd = 
			{	
				private ["_where","_wp"];
				params ["_grp"];
				
				_where = getMarkerPos (selectRandom CSWR_destinationInd);
				_wp = _grp addWaypoint [_where, 0]; 
				_wp setWaypointTimeout CSWR_wpTimeOut; 
				_wp setWaypointStatements ["true", "[group this] spawn CSWR_fnc_wpGoToDestInd"];
			};
		

	// ................................................................................................................................................
	

	// GROUP MEMBERS: BLUFOR
	// Define the number of soldiers and who is who in each type of group.
	
		// Soldiers
			_bluSquadLight	 = ["B_Soldier_TL_F", "B_Soldier_F"];
			_bluSquadRegular = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_F", "B_soldier_AR_F"];
			_bluSquadHeavy   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_F", "B_soldier_AR_F", "B_soldier_M_F", "B_soldier_AT_F"];
			
		// Vehicles
			_bluVehLight     = ["B_Quadbike_01_F"];
			_bluVehRegular   = ["B_MRAP_01_hmg_F"];
			_bluVehHeavy     = ["B_MBT_01_TUSK_F"];


	// GROUP MEMBERS: OPFOR
	// Define the number of soldiers and who is who in each type of group.
	
		// Soldiers
			_opSquadLight	= ["O_Soldier_TL_F", "O_Soldier_F"];
			_opSquadRegular	= ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_F", "O_soldier_AR_F"];
			_opSquadHeavy	= ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_F", "O_soldier_AR_F", "O_soldier_M_F", "O_soldier_AT_F"];
			
		// Vehicles
			_opVehLight		= ["O_Quadbike_01_F"];
			_opVehRegular	= ["O_MRAP_02_hmg_F"];
			_opVehHeavy		= ["O_MBT_02_cannon_F"];
			

	// GROUP MEMBERS: INDEPENDENT
	// Define the number of soldiers and who is who in each type of group.
	
		// Soldiers
			_indSquadLight	 = ["I_Soldier_TL_F", "I_soldier_F"];
			_indSquadRegular = ["I_Soldier_TL_F", "I_soldier_F", "I_soldier_F", "I_Soldier_AR_F"];
			_indSquadHeavy	 = ["I_Soldier_TL_F", "I_soldier_F", "I_soldier_F", "I_Soldier_AR_F", "I_Soldier_M_F", "I_Soldier_AT_F"];
			
		// Vehicles
			_indVehLight     = ["I_Quadbike_01_F"];
			_indVehRegular   = ["I_MRAP_03_hmg_F"];
			_indVehHeavy     = ["I_MBT_03_cannon_F"];
			

	// GROUP MEMBERS: CIVILIAN
	// Define the number of soldiers and who is who in each type of group.
	
		// People
			_civAlone      = ["C_man_polo_1_F"];
			_civCouple     = ["C_man_polo_1_F", "C_man_polo_2_F"];
			_civGang       = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
			
		// Vehicles
			_civVehLight   = ["C_Hatchback_01_F"];
			_civVehRegular = ["C_Offroad_01_repair_F"];
			_civVehHeavy   = ["C_Van_01_transport_F"];

		
		
	// ................................................................................................................................................


	// STRATEGY: BLUFOR 
	// Define each group and their features and destination.
	// More behavior options: https://community.bistudio.com/wiki/setBehaviourStrong
	// More combat mode options: https://community.bistudio.com/wiki/setCombatMode
	// More speed mode options: https://community.bistudio.com/wiki/setSpeedMode

		// Only vehicles Blufor /////////////////////
		
			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_bluVehSpawn = getMarkerPos (selectRandom CSWR_bluSpawnPoints);
			_bluVehPos = _bluVehSpawn findEmptyPosition _noSpawnCollision;
			_bluVeh = [_bluVehPos, BLUFOR, _bluVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
			_bluVeh setBehaviour "SAFE";
			_bluVeh setCombatMode "YELLOW";
			_bluVeh setSpeedMode "LIMITED";
			[_bluVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

		
		// Only groups of soldiers Blufor /////////////////////
		
			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;
			
			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;
			
			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;
			
			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_bluGroup = [getMarkerPos (selectRandom CSWR_bluSpawnPoints), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
			_bluGroup setBehaviourStrong "SAFE";
			_bluGroup setCombatMode "YELLOW";
			_bluGroup setSpeedMode "NORMAL";
			[_bluGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;



	// ................................................................................................................................................


	// STRATEGY: OPFOR
	// Define each group and their features and destination.
	// More behavior options: https://community.bistudio.com/wiki/setBehaviourStrong
	// More combat mode options: https://community.bistudio.com/wiki/setCombatMode
	// More speed mode options: https://community.bistudio.com/wiki/setSpeedMode

		// Only vehicles Opfor /////////////////////
		
			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_opVehSpawn = getMarkerPos (selectRandom CSWR_opSpawnPoints);
			_opVehPos = _opVehSpawn findEmptyPosition _noSpawnCollision;
			_opVeh = [_opVehPos, OPFOR, _opVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opVeh setBehaviour "SAFE";
			_opVeh setCombatMode "YELLOW";
			_opVeh setSpeedMode "LIMITED";
			[_opVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
	
	
		// Only groups of soldiers OpFor /////////////////////
		
			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;
			
			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;
			
			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_opGroup = [getMarkerPos (selectRandom CSWR_opSpawnPoints), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_opGroup setBehaviourStrong "SAFE";
			_opGroup setCombatMode "YELLOW";
			_opGroup setSpeedMode "NORMAL";
			[_opGroup] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 1;
			
								

			
	// ................................................................................................................................................


	// STRATEGY: INDEPENDENT
	// Define each group and their features and destination.
	// More behavior options: https://community.bistudio.com/wiki/setBehaviourStrong
	// More combat mode options: https://community.bistudio.com/wiki/setCombatMode
	// More speed mode options: https://community.bistudio.com/wiki/setSpeedMode

		// Only vehicles Independent /////////////////////
		
			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
			
			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;

			_indVehSpawn = getMarkerPos (selectRandom CSWR_indSpawnPoints);
			_indVehPos = _indVehSpawn findEmptyPosition _noSpawnCollision;
			_indVeh = [_indVehPos, INDEPENDENT, _indVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indVeh setBehaviour "SAFE";
			_indVeh setCombatMode "YELLOW";
			_indVeh setSpeedMode "LIMITED";
			[_indVeh] spawn CSWR_fnc_wpGoToAnywhere;
			sleep 2;
		
		// Only groups of soldiers Independent /////////////////////
		
			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;
			
			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;
			
			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere;  
			sleep 1;

			_indGroup = [getMarkerPos (selectRandom CSWR_indSpawnPoints), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_indGroup setBehaviourStrong "SAFE";
			_indGroup setCombatMode "YELLOW";
			_indGroup setSpeedMode "NORMAL";
			[_indGroup] spawn CSWR_fnc_wpGoToAnywhere; 
			sleep 1;




	// ................................................................................................................................................


	// STRATEGY: CIVILIAN
	// Define each group and their features and destination.
	// More behavior options: https://community.bistudio.com/wiki/setBehaviourStrong
	// More combat mode options: https://community.bistudio.com/wiki/setCombatMode
	// More speed mode options: https://community.bistudio.com/wiki/setSpeedMode

		// Only vehicles Civilian /////////////////////
						
			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;
			
			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;

			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;
			
			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;
			
			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;

			_civVehSpawn = getMarkerPos (selectRandom CSWR_civSpawnPoints);
			_civVehPos = _civVehSpawn findEmptyPosition _noSpawnCollision;
			_civVeh = [_civVehPos, CIVILIAN, _civVehHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civVeh setBehaviour "SAFE";
			_civVeh setCombatMode "RED";
			_civVeh setSpeedMode "LIMITED";
			[_civVeh] spawn CSWR_fnc_wpGoToDestShared;
			sleep 2;
		
		// Only groups of Civilian /////////////////////
		
			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;
			
			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;
			
			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared;  
			sleep 1;

			_civGroup = [getMarkerPos (selectRandom CSWR_civSpawnPoints), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
			_civGroup setBehaviourStrong "SAFE";
			_civGroup setCombatMode "RED";
			_civGroup setSpeedMode "NORMAL";
			[_civGroup] spawn CSWR_fnc_wpGoToDestShared; 
			sleep 1;

	// ................................................................................................................................................

};	// spawn ends.