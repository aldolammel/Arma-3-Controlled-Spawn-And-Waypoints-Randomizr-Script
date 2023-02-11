// CSWR v3.2
// File: your_mission\CSWRandomizr\fn_CSWR_population.sqf
// by thy (@aldolammel)

if (!isServer) exitWith {};

[] spawn {
	// CSWR CORE > DONT TOUCH > Wait if needed:
	waitUntil { time >= CSWR_wait };
	// CSWR CORE > DONT TOUCH > Object declarations:
	private ["_spawnsBLU", "_spawnsOPF", "_spawnsIND", "_spawnsCIV", "_vehLightBLU", "_vehRegularBLU", "_vehHeavyBLU", "_squadLightBLU", "_squadRegularBLU", "_squadHeavyBLU", "_squadCustomOneBLU", "_squadCustomTwoBLU", "_squadCustomThreeBLU", "_vehLightOPF", "_vehRegularOPF", "_vehHeavyOPF", "_squadLightOPF", "_squadRegularOPF", "_squadHeavyOPF", "_squadCustomOneOPF", "_squadCustomTwoOPF", "_squadCustomThreeOPF", "_vehLightIND", "_vehRegularIND", "_vehHeavyIND", "_squadLightIND", "_squadRegularIND", "_squadHeavyIND", "_squadCustomOneIND", "_squadCustomTwoIND", "_squadCustomThreeIND", "_vehLightCIV", "_vehRegularCIV", "_vehHeavyCIV", "_aloneCIV", "_coupleCIV", "_gangCIV", "_customOneCIV", "_customTwoCIV", "_customThreeCIV"];
	// CSWR CORE > DONT TOUCH > Initial values:
	_spawnsBLU=[]; _spawnsOPF=[]; _spawnsIND=[]; _spawnsCIV=[]; _vehLightBLU=[]; _vehRegularBLU=[]; _vehHeavyBLU=[]; _squadLightBLU=[]; _squadRegularBLU=[]; _squadHeavyBLU=[]; _squadCustomOneBLU=[]; _squadCustomTwoBLU=[]; _squadCustomThreeBLU=[]; _vehLightOPF=[]; _vehRegularOPF=[]; _vehHeavyOPF=[]; _squadLightOPF=[]; _squadRegularOPF=[]; _squadHeavyOPF=[]; _squadCustomOneOPF=[]; _squadCustomTwoOPF=[]; _squadCustomThreeOPF=[]; _vehLightIND=[]; _vehRegularIND=[]; _vehHeavyIND=[]; _squadLightIND=[]; _squadRegularIND=[]; _squadHeavyIND=[]; _squadCustomOneIND=[]; _squadCustomTwoIND=[]; _squadCustomThreeIND=[]; _vehLightCIV=[]; _vehRegularCIV=[]; _vehHeavyCIV=[]; _aloneCIV=[]; _coupleCIV=[]; _gangCIV=[]; _customOneCIV=[]; _customTwoCIV=[]; _customThreeCIV=[];
	// CSWR CORE > DONT TOUCH > Check the spawns options:
	if (CSWR_isOnBLU) then { _spawnsBLU = ["BLU", CSWR_spawnsBLU] call THY_fnc_CSWR_is_there_spawn }; if (CSWR_isOnOPF) then { _spawnsOPF = ["OPF", CSWR_spawnsOPF] call THY_fnc_CSWR_is_there_spawn }; if (CSWR_isOnIND) then { _spawnsIND = ["IND", CSWR_spawnsIND] call THY_fnc_CSWR_is_there_spawn }; if (CSWR_isOnCIV) then { _spawnsCIV = ["CIV", CSWR_spawnsCIV] call THY_fnc_CSWR_is_there_spawn };
	

	// ..............................................................................................................................


	if ((count _spawnsBLU) > 0) then {
		
		// DEFINING GROUPS: BLUFOR:
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			_vehLightBLU   = "B_G_Offroad_01_armed_F";
			_vehRegularBLU = "B_MRAP_01_hmg_F";
			_vehHeavyBLU   = "B_MBT_01_TUSK_F";

			// Soldiers
			_squadLightBLU   = ["B_Soldier_TL_F", "B_Soldier_F"];
			_squadRegularBLU = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F"];
			_squadHeavyBLU   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F", "B_soldier_M_F", "B_soldier_AT_F"];
			_squadCustomOneBLU   = [];
			_squadCustomTwoBLU   = [];
			_squadCustomThreeBLU = [];

		// SPAWNING GROUPS: BLUFOR:
		// Define each group and their features and destination.
		
			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[BLUFOR, _spawnsBLU, _vehLightBLU, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[BLUFOR, _spawnsBLU, _vehRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[BLUFOR, _spawnsBLU, _vehHeavyBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[BLUFOR, _spawnsBLU, _vehHeavyBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			
			
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's 'squad type', initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[BLUFOR, _spawnsBLU, _squadLightBLU, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadRegularBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[BLUFOR, _spawnsBLU, _squadLightBLU, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;

	}; // blufor ends.


	// ..............................................................................................................................


	if ((count _spawnsOPF) > 0) then {

		// DEFINING GROUPS: OPFOR:
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			_vehLightOPF   = "O_G_Offroad_01_armed_F";
			_vehRegularOPF = "O_MRAP_02_hmg_F";
			_vehHeavyOPF   = "O_MBT_02_cannon_F";
			
			// Soldiers
			_squadLightOPF   = ["O_Soldier_TL_F", "O_Soldier_F"];
			_squadRegularOPF = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F"];
			_squadHeavyOPF   = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F", "O_soldier_M_F", "O_soldier_AT_F"];
			_squadCustomOneOPF   = [];
			_squadCustomTwoOPF   = [];
			_squadCustomThreeOPF = [];

		// SPAWNING GROUPS: OPFOR:
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[OPFOR, _spawnsOPF, _vehLightOPF, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[OPFOR, _spawnsOPF, _vehRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[OPFOR, _spawnsOPF, _vehHeavyOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[OPFOR, _spawnsOPF, _vehHeavyOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;

			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad type, initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[OPFOR, _spawnsOPF, _squadLightOPF, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadLightOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadRegularOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadHeavyOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadHeavyOPF, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadHeavyOPF, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[OPFOR, _spawnsOPF, _squadHeavyOPF, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;
			
	}; // opfor ends.


	// ..............................................................................................................................


	if ((count _spawnsIND) > 0) then {

		// DEFINING GROUPS: INDEPENDENT:
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			_vehLightIND   = "I_G_Offroad_01_armed_F";
			_vehRegularIND = "I_MRAP_03_hmg_F";
			_vehHeavyIND   = "I_MBT_03_cannon_F";
			
			// Soldiers
			_squadLightIND	 = ["I_Soldier_TL_F", "I_soldier_F"];
			_squadRegularIND = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F"];
			_squadHeavyIND	 = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F", "I_Soldier_M_F", "I_Soldier_AT_F"];
			_squadCustomOneIND   = [];
			_squadCustomTwoIND   = [];
			_squadCustomThreeIND = [];
		
		// SPAWNING GROUPS: INDEPENDENT:
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[INDEPENDENT, _spawnsIND, _vehLightIND, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, _spawnsIND, _vehRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, _spawnsIND, _vehHeavyIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			[INDEPENDENT, _spawnsIND, _vehHeavyIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_vehicle;
			
			// Soldiers Groups
			// [ faction, faction's spawnpoints, faction's squad type, initial squad behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), squad destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[INDEPENDENT, _spawnsIND, _squadLightIND, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "CHAOS", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "COMBAT", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "STEALTH", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadLightIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadRegularIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadHeavyIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadHeavyIND, "SAFE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadHeavyIND, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;
			[INDEPENDENT, _spawnsIND, _squadHeavyIND, "AWARE", "ANYWHERE"] call THY_fnc_CSWR_people;
			
	}; // ind ends.


	// ..............................................................................................................................


	if ((count _spawnsCIV) > 0) then {

		// DEFINING GROUPS: CIVILIAN
		// Define the number of soldiers and who is who in each type of group.

			// Vehicles
			_vehLightCIV   = "C_Hatchback_01_F";
			_vehRegularCIV = "C_Offroad_01_repair_F";
			_vehHeavyCIV   = "C_Van_01_transport_F";
			
			// People
			_aloneCIV  = ["C_man_polo_1_F"];
			_coupleCIV = ["C_man_polo_1_F", "C_man_polo_2_F"];
			_gangCIV   = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
			_customOneCIV   = [];
			_customTwoCIV   = [];
			_customThreeCIV = [];
		
		// SPAWNING GROUPS: CIVILIAN
		// Define each group and their features and destination.

			// Vehicles Groups
			// [ faction, faction's spawnpoints, faction's vehicle size, initial crew behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), vehicle destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
							
			[CIVILIAN, _spawnsCIV, _vehLightCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehLightCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehLightCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehLightCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehRegularCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehRegularCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehHeavyCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			[CIVILIAN, _spawnsCIV, _vehHeavyCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_vehicle;
			
			// People Groups
			// [ faction, faction's spawnpoints, faction's group size, initial group behaviour ("SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"), group destination ("ANYWHERE", "PUBLIC", "ONLY_BLU", "ONLY_OPF", "ONLY_IND") ]
			
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _aloneCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _coupleCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			[CIVILIAN, _spawnsCIV, _gangCIV, "SAFE", "PUBLIC"] call THY_fnc_CSWR_people;
			
	}; // civ ends.
};  // spawn ends.
// Return:
true;
