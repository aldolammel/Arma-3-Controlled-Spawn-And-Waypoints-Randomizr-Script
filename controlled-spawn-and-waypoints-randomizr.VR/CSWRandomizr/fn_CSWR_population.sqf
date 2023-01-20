// CSWR v2.8
// File: your_mission\CSWRandomizr\fn_CSWR_population.sqf
// Documentation: https://docs.google.com/document/d/1uFOSXVuf2w_BZxTRIbmuRTrcf5b07Nu2SEGSfdDlXfI/edit?usp=sharing
// by thy (@aldolammel)

if (!isServer) exitWith {};


[] spawn {

	if (CSWR_spawnBlu) then {
		
		// DEFINING GROUPS: BLUFOR
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _bluVehLight   = ["B_G_Offroad_01_armed_F"];
			private _bluVehRegular = ["B_MRAP_01_hmg_F"];
			private _bluVehHeavy   = ["B_MBT_01_TUSK_F"];
			
			// Soldiers
			private _bluSquadLight   = ["B_Soldier_TL_F", "B_Soldier_F"];
			private _bluSquadRegular = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F"];
			private _bluSquadHeavy   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F", "B_soldier_M_F", "B_soldier_AT_F"];

		// SPAWNING GROUPS: BLUFOR 
		// Define each group and their features and destination.
		
			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle waypoints ]
			
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehLight, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[BLUFOR, CSWR_bluSpawnPoints, _bluVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			
			
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad waypoints ]
			
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[BLUFOR, CSWR_bluSpawnPoints, _bluSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
		
		
	}; // blufor ends.


	// ..............................................................................................................................


	if (CSWR_spawnOp) then {

		// DEFINING GROUPS: OPFOR 
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _opVehLight   = ["O_G_Offroad_01_armed_F"];
			private _opVehRegular = ["O_MRAP_02_hmg_F"];
			private _opVehHeavy   = ["O_MBT_02_cannon_F"];
			
			// Soldiers
			private _opSquadLight   = ["O_Soldier_TL_F", "O_Soldier_F"];
			private _opSquadRegular	= ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F"];
			private _opSquadHeavy   = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F", "O_soldier_M_F", "O_soldier_AT_F"];

		// SPAWNING GROUPS: OPFOR
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle waypoints ]
			
			[OPFOR, CSWR_opSpawnPoints, _opVehLight, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[OPFOR, CSWR_opSpawnPoints, _opVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;

			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad waypoints ]
			
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[OPFOR, CSWR_opSpawnPoints, _opSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			
			
	}; // opfor ends.
	
	
	// ..............................................................................................................................

	
	if (CSWR_spawnInd) then {

		// DEFINING GROUPS: INDEPENDENT 
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _indVehLight   = ["I_G_Offroad_01_armed_F"];
			private _indVehRegular = ["I_MRAP_03_hmg_F"];
			private _indVehHeavy   = ["I_MBT_03_cannon_F"];
			
			// Soldiers
			private _indSquadLight	 = ["I_Soldier_TL_F", "I_soldier_F"];
			private _indSquadRegular = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F"];
			private _indSquadHeavy	 = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F", "I_Soldier_M_F", "I_Soldier_AT_F"];
		
		// SPAWNING GROUPS: INDEPENDENT
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle waypoints ]
			
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehLight, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, CSWR_indSpawnPoints, _indVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_vehicle;
			
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad size, initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad waypoints ]
			
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "CHAOS", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "COMBAT", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "STEALTH", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadLight, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadRegular, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "SAFE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			[INDEPENDENT, CSWR_indSpawnPoints, _indSquadHeavy, "AWARE", THY_fnc_CSWR_wpGoToAnywhere] call THY_fnc_CSWR_people;
			
			
	}; // ind ends.
	
	
	// ..............................................................................................................................

	
	if (CSWR_spawnCiv) then {
	
		// DEFINING GROUPS: CIVILIAN
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			private _civVehLight   = ["C_Hatchback_01_F"];
			private _civVehRegular = ["C_Offroad_01_repair_F"];
			private _civVehHeavy   = ["C_Van_01_transport_F"];
			
			// People
			private _civAlone  = ["C_man_polo_1_F"];
			private _civCouple = ["C_man_polo_1_F", "C_man_polo_2_F"];
			private _civGang   = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
		
		// SPAWNING GROUPS: CIVILIAN
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle waypoints ]
							
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehLight, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehRegular, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehRegular, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, CSWR_civSpawnPoints, _civVehHeavy, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_vehicle;
			
			// People Groups
			// [ faction, faction's spawnpoints, faction's group size, initial group behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), group waypoints ]
			
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civAlone, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civCouple, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			[CIVILIAN, CSWR_civSpawnPoints, _civGang, "SAFE", THY_fnc_CSWR_wpGoToDestShared] call THY_fnc_CSWR_people;
			
			
	}; // civ ends.
};	// spawn ends.
