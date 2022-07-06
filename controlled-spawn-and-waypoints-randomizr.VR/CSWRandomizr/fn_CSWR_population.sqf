// File: your_mission\CSWRandomizr\fn_CSWR_population.sqf
// Documentation: https://docs.google.com/document/d/1uFOSXVuf2w_BZxTRIbmuRTrcf5b07Nu2SEGSfdDlXfI/edit?usp=sharing
// by thy (@aldolammel)

if (!isServer) exitWith {};


// EDITOR'S OPTIONS:

	CSWR_debug = true;                // true = xxxxxxxxxxxxxxx (available only on hosted server player) / false = xxxxxxxxxxxxxxxxxxxxxxxx.
	CSWR_spawnBlu = true;                // true = xxxxxxxxxxxxxxxxxxx / false = xxxxxxxxxxxxxxxxxxxxxxxx.
	CSWR_spawnOp  = true;                // true = xxxxxxxxxxxxxxxxxxx / false = xxxxxxxxxxxxxxxxxxxxxxxx.
	CSWR_spawnInd = true;                // true = xxxxxxxxxxxxxxxxxxx / false = xxxxxxxxxxxxxxxxxxxxxxxx.
	CSWR_spawnCiv = true;                // true = xxxxxxxxxxxxxxxxxxx / false = xxxxxxxxxxxxxxxxxxxxxxxx.


// ..............................................................................................................................


[] spawn {

	if (CSWR_spawnBlu) then {
		
		// GROUP MEMBERS: BLUFOR
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _bluVehLight   = ["B_Quadbike_01_F"];
			private _bluVehRegular = ["B_MRAP_01_hmg_F"];
			private _bluVehHeavy   = ["B_MBT_01_TUSK_F"];
			
			// Soldiers
			private _bluSquadLight   = ["B_Soldier_TL_F", "B_Soldier_F"];
			private _bluSquadRegular = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_F", "B_soldier_AR_F"];
			private _bluSquadHeavy   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_F", "B_soldier_AR_F", "B_soldier_M_F", "B_soldier_AT_F"];

		// AMOUNT OF GROUPS: BLUFOR 
		// Define each group and their features and destination.
		
			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle, crew behaviour at the start, crew combat mode at the start, crew speed at the start, vehicle waypoints ]
			
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
				
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, squad behaviour at the start, squad combat mode at the start, squad speed at the start, squad waypoints ]
			
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
		
		
	}; // blufor ends.


	// ..............................................................................................................................


	if (CSWR_spawnOp) then {

		// GROUP MEMBERS: OPFOR 
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _opVehLight   = ["O_Quadbike_01_F"];
			private _opVehRegular = ["O_MRAP_02_hmg_F"];
			private _opVehHeavy   = ["O_MBT_02_cannon_F"];
			
			// Soldiers
			private _opSquadLight   = ["O_Soldier_TL_F", "O_Soldier_F"];
			private _opSquadRegular	= ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_F", "O_soldier_AR_F"];
			private _opSquadHeavy   = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_F", "O_soldier_AR_F", "O_soldier_M_F", "O_soldier_AT_F"];

		// AMOUNT OF GROUPS: OPFOR
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle, crew behaviour at the start, crew combat mode at the start, crew speed at the start, vehicle waypoints ]
			
			[OPFOR, CSWR_opSpawnPoints, _opVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;

			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, squad behaviour at the start, squad combat mode at the start, squad speed at the start, squad waypoints ]
			
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			
			
	}; // opfor ends.
	
	
	// ..............................................................................................................................

	
	if (CSWR_spawnInd) then {

		// GROUP MEMBERS: INDEPENDENT 
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _indVehLight   = ["I_Quadbike_01_F"];
			private _indVehRegular = ["I_MRAP_03_hmg_F"];
			private _indVehHeavy   = ["I_MBT_03_cannon_F"];
			
			// Soldiers
			private _indSquadLight	 = ["I_Soldier_TL_F", "I_soldier_F"];
			private _indSquadRegular = ["I_Soldier_TL_F", "I_soldier_F", "I_soldier_F", "I_Soldier_AR_F"];
			private _indSquadHeavy	 = ["I_Soldier_TL_F", "I_soldier_F", "I_soldier_F", "I_Soldier_AR_F", "I_Soldier_M_F", "I_Soldier_AT_F"];
		
		// AMOUNT OF GROUPS: INDEPENDENT
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle, crew behaviour at the start, crew combat mode at the start, crew speed at the start, vehicle waypoints ]
			
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehLight, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehRegular, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehHeavy, "SAFE", "YELLOW", "LIMITED", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, squad behaviour at the start, squad combat mode at the start, squad speed at the start, squad waypoints ]
			
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", "YELLOW", "NORMAL", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			
			
	}; // ind ends.
	
	
	// ..............................................................................................................................

	
	if (CSWR_spawnCiv) then {
	
		// GROUP MEMBERS: CIVILIAN
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _civVehLight   = ["C_Hatchback_01_F"];
			private _civVehRegular = ["C_Offroad_01_repair_F"];
			private _civVehHeavy   = ["C_Van_01_transport_F"];
			
			// People
			private _civAlone  = ["C_man_polo_1_F"];
			private _civCouple = ["C_man_polo_1_F", "C_man_polo_2_F"];
			private _civGang   = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
		
		// AMOUNT OF GROUPS: CIVILIAN
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle, crew behaviour at the start, crew combat mode at the start, crew speed at the start, vehicle waypoints ]
							
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehRegular, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehRegular, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehHeavy, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehHeavy, "SAFE", "RED", "LIMITED", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			
			// People Groups
			// [ faction, faction's spawnpoints, faction's group size, group behaviour at the start, group combat mode at the start, group speed at the start, group waypoints ]
			
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", "RED", "NORMAL", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
				
				
	}; // civ ends.	
};	// spawn ends.	