//---------------------
/* 


	CONTROLLED SPAWN AND WAYPOINTS RANDOMIZR (Version 1.2)
	by thy (@aldolammel)
	
	Github: https://github.com/aldolammel/Arma-3-Controlled-Waypoints-Randomizr-Script
	Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2740912514
	Discussion: https://forums.bohemia.net/forums/topic/237504-release-controlled-spawn-and-waypoints-randomizr/
	
	
	
*/
//---------------------

publicVariable "goToDestinBlu", "goToDestinOp", "goToDestinInd", "goToDestinCiv", "goToSharedDestin", "goToAnywhere";
private ["_bluAllSpawns","_opAllSpawns","_indAllSpawns","_civAllSpawns","_where","_wp","_bluSquadLight","_bluSquadRegular","_bluSquadHeavy","_bluVehLight","_bluVehRegular","_bluVehHeavy","_opSquadLight","_opSquadRegular","_opSquadHeavy","_opVehLight","_opVehRegular","_opVehHeavy","_indSquadLight","_indSquadRegular","_indSquadHeavy","_indVehLight","_indVehRegular","_indVehHeavy","_civAlone","_civCouple","_civGang","_civVehLight","_civVehRegular","_civVehHeavy","_bluGroup","_bluVehSpawn","_bluVehPos","_bluVeh","_opGroup","_opVehSpawn","_opVehPos","_opVeh","_indGroup","_indVehSpawn","_indVehPos","_indVeh","_civGroup","_civVehSpawn","_civVehPos","_civVeh"];


//
// 
// 		Faction Spawns:				Manually define which marks the faction can use as a spawn point.  
// 									You can create unlimited spawn points for one or more factions.
// 									Once the spawn points are created, the script will spawn the groups 
// 									randomly through the faction spawns.
//
// 		Destination: 				Manually define which marks will be used as waypoints. There are
// 							 		2 types of destinations: those that can be visited by everyone;
// 									and those that only a specific faction can go to. Once the destinations  
// 									are created, the script will take care of taking (or not) the groups 
//									there, randomly.  									
//
// 		Moving:			 			There are 3 types of group movement: groups that go randomly and 
//									only to their faction's destinations; groups that go randomly and only  
// 									to destinations shared with other factions; and groups that go 
// 									randomly to any configured destination, ignoring rules. 
// 
// 		Groups: 			 		Manually set the number of soldiers and vehicles per faction group type.
// 									There are 3 infantry and 3 vehicle templates for you to customize:
// 									light squad; normal squad; heavy squad; light vehicle; normal vehicle;
// 									and heavy vehicle. There is no re-spawn. Death is death. 
//
// 		Strategy: 					Manually define how many groups, what type of groups, and how the random 
// 									moves of each group in the faction will be.  
//
//


// FACTION SPAWNS
// Spawnpoints for each faction. Only the specific faction can spawn.
	_bluAllSpawns   = ["bluSpawn01","bluSpawn02","bluSpawn03","bluSpawn04"]; 
	_opAllSpawns    = ["opSpawn01","opSpawn02","opSpawn03","opSpawn04"]; 
	_indAllSpawns   = ["indSpawn01","indSpawn02","indSpawn03","indSpawn04"];
	_civAllSpawns   = ["civSpawn01","civSpawn02","civSpawn03","civSpawn04"];

// ................................................................................................................................................

// DESTINATION: FACTION
// Random waypoints where only the specific faction can go.
	goToDestinBlu   = ["destinBlu01","destinBlu02"];
	goToDestinOp    = ["destinOp01","destinOp02"];
	goToDestinInd   = ["destinInd01","destinInd02"];
	goToDestinCiv   = ["destinCiv01","destinCiv02"];

// DESTINATION: SHARED
// Random waypoints where any faction can go.
	goToSharedDestin = ["destinShared01","destinShared02","destinShared03","destinShared04"];

// consider to go to both shared destinations and those of all factions.
	goToAnywhere = goToSharedDestin + goToDestinBlu + goToDestinOp + goToDestinInd + goToDestinCiv;

// ................................................................................................................................................

// MOVING: FOREVER AND TO ANYWHERE
// The group will move continuously and to all destinations, including (attention!) to Factions destination.
	fnc_goToAnywhere = { //anyone can use
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToAnywhere);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60]; 
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToAnywhere"];	
	};

// MOVING: FOREVER AND ONLY TO SHARED
// The group will move continuously, considering only shared destinations.
	fnc_goToSharedDestin = { //anyone can use, specially Civilian.
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToSharedDestin);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60];
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToSharedDestin"];
	};

// MOVING: FOREVER AND ONLY TO FACTION
// The group will move continuously, considering only their faction destinations.
	fnc_goToFactionDestinBlu = { // only Blufor
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToDestinBlu);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60];
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToFactionDestinBlu"];
	};
	fnc_goToFactionDestinOp = { // only Opfor
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToDestinOp);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60]; 
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToFactionDestinOp"];
	};
	fnc_goToFactionDestinInd = { // only Independent
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToDestinInd);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60]; 
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToFactionDestinInd"];
	};
	fnc_goToFactionDestinCiv = { // only Civilian
		params ["_grp"];
		_where = getmarkerpos (selectRandom goToDestinCiv);
		_wp = _grp addWaypoint [_where, 0]; 
		_wp setWaypointTimeout [5, 30, 60]; 
		_wp setWaypointStatements ["true", "[group this] spawn fnc_goToFactionDestinCiv"];
	};


// ................................................................................................................................................

// GROUPS: BLUFOR
// Number of soldiers and type of faction squads.
	// Soldiers
	_bluSquadLight	 = ["B_Soldier_TL_F", "B_soldier_AR_F"];
	_bluSquadRegular = ["B_Soldier_TL_F", "B_soldier_AR_F", "B_soldier_AR_F", "B_soldier_AR_F"];
	_bluSquadHeavy   = ["B_Soldier_TL_F", "B_soldier_AR_F", "B_soldier_AR_F", "B_soldier_AR_F", "B_soldier_AR_F", "B_soldier_AR_F"];
	// Vehicles
	_bluVehLight     = ["B_Quadbike_01_F"];
	_bluVehRegular   = ["B_MRAP_01_hmg_F"];
	_bluVehHeavy     = ["B_MBT_01_TUSK_F"];

// GROUPS: OPFOR
// Number of soldiers and type of faction squads.
	// Soldiers
	_opSquadLight	= ["O_Soldier_TL_F", "O_soldier_AR_F"];
	_opSquadRegular	= ["O_Soldier_TL_F", "O_soldier_AR_F", "O_soldier_AR_F", "O_soldier_AR_F"];
	_opSquadHeavy	= ["O_Soldier_TL_F", "O_soldier_AR_F", "O_soldier_AR_F", "O_soldier_AR_F", "O_soldier_AR_F", "O_soldier_AR_F"];
	// Vehicles
	_opVehLight		= ["O_Quadbike_01_F"];
	_opVehRegular	= ["O_MRAP_02_hmg_F"];
	_opVehHeavy		= ["O_MBT_02_cannon_F"];

// GROUPS: INDEPENDENT
// Number of soldiers and type of faction squads.
	// Soldiers
	_indSquadLight	 = ["I_Soldier_TL_F", "I_Soldier_AR_F"];
	_indSquadRegular = ["I_Soldier_TL_F", "I_Soldier_AR_F", "I_Soldier_AR_F", "I_Soldier_AR_F"];
	_indSquadHeavy	 = ["I_Soldier_TL_F", "I_Soldier_AR_F", "I_Soldier_AR_F", "I_Soldier_AR_F", "I_Soldier_AR_F", "I_Soldier_AR_F"];
	// Vehicles
	_indVehLight     = ["I_Quadbike_01_F"];
	_indVehRegular   = ["I_MRAP_03_hmg_F"];
	_indVehHeavy     = ["I_MBT_03_cannon_F"];

// GROUPS: CIVILIAN
// Number of people and type of their groups.
	// People
	_civAlone        = ["C_man_polo_1_F"];
	_civCouple       = ["C_man_polo_1_F", "C_man_polo_2_F"];
	_civGang         = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_1_F"];
	// Vehicles
	_civVehLight     = ["C_Offroad_01_repair_F"];
	_civVehRegular   = ["C_Offroad_01_repair_F"];
	_civVehHeavy     = ["C_Offroad_01_repair_F"];

	
	
// ................................................................................................................................................


// STRATEGY: BLUFOR 
// Setting the group numbers and their gears and destination.

	// Soldiers Blufor
	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere;
	sleep 0.1;

	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_bluGroup = [getmarkerpos (selectRandom _bluAllSpawns), BLUFOR, _bluSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	[_bluGroup] spawn fnc_goToAnywhere;
	sleep 0.1;

					// Vehicles Blufor
					_bluVehSpawn 	= getmarkerpos (selectRandom _bluAllSpawns);
					_bluVehPos 		= _bluVehSpawn findEmptyPosition [4,50];
					_bluVeh 		= [_bluVehPos, BLUFOR, _bluVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_bluVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;

					_bluVehSpawn 	= getmarkerpos (selectRandom _bluAllSpawns);
					_bluVehPos 		= _bluVehSpawn findEmptyPosition [4,50];
					_bluVeh 		= [_bluVehPos, BLUFOR, _bluVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_bluVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;



// ................................................................................................................................................


// STRATEGY: OPFOR
// Setting the group numbers and their gears and destination.

	// Soldiers Opfor
	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere;
	sleep 0.1;

	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere;
	sleep 0.1;

	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_opGroup = [getmarkerpos (selectRandom _opAllSpawns), OPFOR, _opSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_opGroup] spawn fnc_goToAnywhere;
	sleep 0.1;
		
					// Vehicles Opfor
					_opVehSpawn 	= getmarkerpos (selectRandom _opAllSpawns);
					_opVehPos 		= _opVehSpawn findEmptyPosition [4,50];
					_opVeh 			= [_opVehPos, OPFOR, _opVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_opVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;

					_opVehSpawn 	= getmarkerpos (selectRandom _opAllSpawns);
					_opVehPos 		= _opVehSpawn findEmptyPosition [4,50];
					_opVeh 			= [_opVehPos, OPFOR, _opVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_opVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;
							

		
// ................................................................................................................................................


// STRATEGY: INDEPENDENT
// Setting the group numbers and their gears and destination.

	// Soldiers Independent
	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere;  
	sleep 0.1;

	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere;  
	sleep 0.1;

	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;

	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere;  
	sleep 0.1;

	_indGroup = [getmarkerpos (selectRandom _indAllSpawns), INDEPENDENT, _indSquadHeavy,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_indGroup] spawn fnc_goToAnywhere; 
	sleep 0.1;


					// Vehicles Independent
					_indVehSpawn 	= getmarkerpos (selectRandom _indAllSpawns);
					_indVehPos 		= _indVehSpawn findEmptyPosition [4,50];
					_indVeh 		= [_indVehPos, INDEPENDENT, _indVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_indVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;

					_indVehSpawn 	= getmarkerpos (selectRandom _indAllSpawns);
					_indVehPos 		= _indVehSpawn findEmptyPosition [4,50];
					_indVeh 		= [_indVehPos, INDEPENDENT, _indVehRegular,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_indVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;



// ................................................................................................................................................


// STRATEGY: CIVILIAN
// Setting the group numbers and their destination.

	// People Civilian 
	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin;  
	sleep 0.1;

	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civAlone,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin;  
	sleep 0.1;

	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin;  
	sleep 0.1;

	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civCouple,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin; 
	sleep 0.1;

	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin;  
	sleep 0.1;

	_civGroup = [getmarkerpos (selectRandom _civAllSpawns), CIVILIAN, _civGang,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
	[_civGroup] spawn fnc_goToSharedDestin; 
	sleep 0.1;

					// Vehicles Civilian
					_civVehSpawn 	= getmarkerpos (selectRandom _civAllSpawns);
					_civVehPos 		= _civVehSpawn findEmptyPosition [4,50];
					_civVeh 		= [_civVehPos, CIVILIAN, _civVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_civVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;

					_civVehSpawn 	= getmarkerpos (selectRandom _civAllSpawns);
					_civVehPos 		= _civVehSpawn findEmptyPosition [4,50];
					_civVeh 		= [_civVehPos, CIVILIAN, _civVehLight,[],[],[],[],[],180] call BIS_fnc_spawnGroup;   
					[_civVeh] spawn fnc_goToSharedDestin;
					sleep 0.2;
