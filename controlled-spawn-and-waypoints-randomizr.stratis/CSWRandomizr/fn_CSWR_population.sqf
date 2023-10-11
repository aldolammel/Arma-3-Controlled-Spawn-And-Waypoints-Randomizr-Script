// CSWR v5.5
// File: your_mission\CSWRandomizr\fn_CSWR_population.sqf
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)

if (!isServer) exitWith {};

[] spawn {
	
	// CSWR CORE > DONT TOUCH > Wait if needed:
	private _time = time + CSWR_wait;
	waitUntil { time > _time };
	// CSWR CORE > DONT TOUCH > Object declarations:
	private ["_form_BLU_1", "_form_OPF_1", "_form_IND_1", "_form_CIV_1", "_form_BLU_2", "_form_OPF_2", "_form_IND_2", "_form_CIV_2", "_be_SAFE", "_be_AWARE", "_be_COMBAT", "_be_STEALTH", "_be_CHAOS", "_move_ANY", "_move_PUBLIC", "_move_RESTRICTED", "_move_WATCH", "_move_OCCUPY", "_move_HOLD"];
	// CSWR CORE > DONT TOUCH > Initial values:
	_form_BLU_1=""; _form_OPF_1=""; _form_IND_1=""; _form_CIV_1=""; _form_BLU_2=""; _form_OPF_2=""; _form_IND_2=""; _form_CIV_2=""; _be_SAFE = "BE_SAFE"; _be_AWARE = "BE_AWARE"; _be_COMBAT = "BE_COMBAT"; _be_STEALTH = "BE_STEALTH"; _be_CHAOS = "BE_CHAOS"; _move_ANY = "MOVE_ANY"; _move_PUBLIC = "MOVE_PUBLIC"; _move_RESTRICTED = "MOVE_RESTRICTED"; _move_WATCH = "MOVE_WATCH"; _move_OCCUPY = "MOVE_OCCUPY"; _move_HOLD = "MOVE_HOLD";
	

	// ..............................................................................................................................


	if ( CSWR_isOnBLU && count CSWR_spwnsAllBLU > 0 ) then {
		
		// DEFINING FACTION GROUPS: BLUFOR
		// Define the number of soldiers and vehicles of BluFor side.

			// Vehicles
			CSWR_vehicle_BLU_light      = "B_MRAP_01_hmg_F";
			CSWR_vehicle_BLU_medium     = "B_APC_Wheeled_01_cannon_F";
			CSWR_vehicle_BLU_heavy      = "B_MBT_01_TUSK_F";
			CSWR_vehicle_BLU_custom_1   = "";
			CSWR_vehicle_BLU_custom_2   = "";
			CSWR_vehicle_BLU_custom_3   = "";
			CSWR_vehicle_BLU_heli_light = "B_Heli_Light_01_dynamicLoadout_F";  // low altitudes.
			CSWR_vehicle_BLU_heli_heavy = "B_Heli_Attack_01_dynamicLoadout_F";  // high altitudes.

			// Soldiers groups
			CSWR_group_BLU_light    = ["B_Soldier_TL_F", "B_Soldier_F"];
			CSWR_group_BLU_medium   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F"];
			CSWR_group_BLU_heavy    = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F", "B_soldier_M_F", "B_soldier_AT_F"];
			CSWR_group_BLU_custom_1 = [];
			CSWR_group_BLU_custom_2 = [];
			CSWR_group_BLU_custom_3 = [];
			CSWR_group_BLU_sniper   = ["B_ghillie_ard_F", "B_sniper_F"];  // Max 2 units.

			// Groups formation
			// Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"
			_form_BLU_1 = "COLUMN";
			_form_BLU_2 = "FILE";

			// CSWR CORE > DONT TOUCH > Public variables:
			publicVariable "CSWR_vehicle_BLU_light"; publicVariable "CSWR_vehicle_BLU_medium"; publicVariable "CSWR_vehicle_BLU_heavy"; publicVariable "CSWR_vehicle_BLU_custom_1"; publicVariable "CSWR_vehicle_BLU_custom_2"; publicVariable "CSWR_vehicle_BLU_custom_3"; publicVariable "CSWR_vehicle_BLU_heli_light"; publicVariable "CSWR_vehicle_BLU_heli_heavy"; publicVariable "CSWR_group_BLU_light"; publicVariable "CSWR_group_BLU_medium"; publicVariable "CSWR_group_BLU_heavy"; publicVariable "CSWR_group_BLU_custom_1"; publicVariable "CSWR_group_BLU_custom_2"; publicVariable "CSWR_group_BLU_custom_3"; publicVariable "CSWR_group_BLU_sniper";
			
		// SPAWNING GROUPS: BLUFOR
		// Define each group and their features and destination.
		
			// Vehicles
			// [ owner, spawns (CSWR_spwnsBLU, CSWR_spwnsVehBLU, CSWR_spwnsHeliBLU, CSWR_spwnsParadropBLU), vehicle type, initial crew behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]

			[BLUFOR, CSWR_spwnsBLU, CSWR_vehicle_BLU_light, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsBLU, CSWR_vehicle_BLU_medium, _be_SAFE, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsVehBLU, CSWR_vehicle_BLU_heavy, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsVehBLU, CSWR_vehicle_BLU_heavy, _be_SAFE, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsParadropBLU, CSWR_vehicle_BLU_heavy, _be_COMBAT, _move_HOLD, [10, trigger_1]] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsHeliBLU, CSWR_vehicle_BLU_heli_light, _be_AWARE, _move_ANY, [1]] call THY_fnc_CSWR_add_vehicle;
			[BLUFOR, CSWR_spwnsHeliBLU, CSWR_vehicle_BLU_heli_heavy, _be_COMBAT, _move_ANY, [10]] call THY_fnc_CSWR_add_vehicle;
	
			// Soldier groups
			// [ owner, spawns (CSWR_spwnsBLU, CSWR_spwnsVehBLU, CSWR_spwnsParadropBLU), team type, team formation (_form_BLU_1, _form_BLU_2), initial team behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_sniper, _form_BLU_1, _be_COMBAT, _move_WATCH, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_2, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_2, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_COMBAT, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_COMBAT, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_1, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_light, _form_BLU_2, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsParadropBLU, CSWR_group_BLU_sniper, _form_BLU_1, _be_COMBAT, _move_WATCH, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsParadropBLU, CSWR_group_BLU_medium, _form_BLU_2, _be_COMBAT, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_medium, _form_BLU_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_heavy, _form_BLU_1, _be_SAFE, _move_ANY, [target_2, trigger_2]] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsBLU, CSWR_group_BLU_heavy, _form_BLU_1, _be_SAFE, _move_ANY, [target_1, target_2]] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsParadropBLU, CSWR_group_BLU_heavy, _form_BLU_1, _be_COMBAT, _move_ANY, [5]] call THY_fnc_CSWR_add_group;
			[BLUFOR, CSWR_spwnsParadropBLU, CSWR_group_BLU_heavy, _form_BLU_1, _be_COMBAT, _move_ANY, [5]] call THY_fnc_CSWR_add_group;
			
	}; // blufor ends.


	// ..............................................................................................................................


	if ( CSWR_isOnOPF && count CSWR_spwnsAllOPF > 0 ) then {

		// DEFINING FACTION GROUPS: OPFOR
		// Define the number of soldiers and vehicles of OpFor side.

			// Vehicles
			CSWR_vehicle_OPF_light      = "O_MRAP_02_hmg_F";
			CSWR_vehicle_OPF_medium     = "O_APC_Tracked_02_cannon_F";
			CSWR_vehicle_OPF_heavy      = "O_MBT_02_cannon_F";
			CSWR_vehicle_OPF_custom_1   = "";
			CSWR_vehicle_OPF_custom_2   = "";
			CSWR_vehicle_OPF_custom_3   = "";
			CSWR_vehicle_OPF_heli_light = "O_Heli_Light_02_dynamicLoadout_F";  // low altitudes.
			CSWR_vehicle_OPF_heli_heavy = "O_Heli_Attack_02_dynamicLoadout_F";  // high altitudes.
			
			// Soldiers groups
			CSWR_group_OPF_light    = ["O_Soldier_TL_F", "O_Soldier_F"];
			CSWR_group_OPF_medium   = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F"];
			CSWR_group_OPF_heavy    = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F", "O_soldier_M_F", "O_soldier_AT_F"];
			CSWR_group_OPF_custom_1 = [];
			CSWR_group_OPF_custom_2 = [];
			CSWR_group_OPF_custom_3 = [];
			CSWR_group_OPF_sniper   = ["O_ghillie_ard_F", "O_sniper_F"];  // Max 2 units.

			// Groups formation
			// Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"
			_form_OPF_1 = "WEDGE";
			_form_OPF_2 = "FILE";

			// CSWR CORE > DONT TOUCH > Public variables:
			publicVariable "CSWR_vehicle_OPF_light"; publicVariable "CSWR_vehicle_OPF_medium"; publicVariable "CSWR_vehicle_OPF_heavy"; publicVariable "CSWR_vehicle_OPF_custom_1"; publicVariable "CSWR_vehicle_OPF_custom_2"; publicVariable "CSWR_vehicle_OPF_custom_3"; publicVariable "CSWR_vehicle_OPF_heli_light"; publicVariable "CSWR_vehicle_OPF_heli_heavy"; publicVariable "CSWR_group_OPF_light"; publicVariable "CSWR_group_OPF_medium"; publicVariable "CSWR_group_OPF_heavy"; publicVariable "CSWR_group_OPF_custom_1"; publicVariable "CSWR_group_OPF_custom_2"; publicVariable "CSWR_group_OPF_custom_3"; publicVariable "CSWR_group_OPF_sniper";

		// SPAWNING GROUPS: OPFOR
		// Define each group and their features and destination.

			// Vehicles
			// [ owner, spawns (CSWR_spwnsOPF, CSWR_spwnsVehOPF, CSWR_spwnsHeliOPF, CSWR_spwnsParadropOPF), vehicle type, initial crew behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[OPFOR, CSWR_spwnsOPF, CSWR_vehicle_OPF_light, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsOPF, CSWR_vehicle_OPF_light, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsOPF, CSWR_vehicle_OPF_medium, _be_SAFE, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsOPF, CSWR_vehicle_OPF_heavy, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsOPF, CSWR_vehicle_OPF_heavy, _be_COMBAT, _move_HOLD, [7, trigger_2]] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsHeliOPF, CSWR_vehicle_OPF_heli_light, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[OPFOR, CSWR_spwnsHeliOPF, CSWR_vehicle_OPF_heli_heavy, _be_AWARE, _move_ANY, [7]] call THY_fnc_CSWR_add_vehicle;

			// Soldier groups
			// [ owner, spawns (CSWR_spwnsOPF, CSWR_spwnsVehOPF, CSWR_spwnsParadropOPF), team type, team formation (_form_OPF_1, _form_OPF_2), initial team behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_sniper, _form_OPF_1, _be_COMBAT, _move_WATCH, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_CHAOS, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_COMBAT, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_STEALTH, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_STEALTH, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_AWARE, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_light, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_AWARE, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_medium, _form_OPF_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_heavy, _form_OPF_1, _be_SAFE, _move_ANY, [trigger_2]] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_heavy, _form_OPF_1, _be_SAFE, _move_ANY, [target_2]] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_heavy, _form_OPF_1, _be_COMBAT, _move_ANY, [2]] call THY_fnc_CSWR_add_group;
			[OPFOR, CSWR_spwnsOPF, CSWR_group_OPF_heavy, _form_OPF_1, _be_COMBAT, _move_ANY, [5]] call THY_fnc_CSWR_add_group;
			
	}; // opfor ends.


	// ..............................................................................................................................


	if ( CSWR_isOnIND && count CSWR_spwnsAllIND > 0 ) then {

		// DEFINING FACTION GROUPS: INDEPENDENT
		// Define the number of soldiers and vehicles of Independent side.

			// Vehicles
			CSWR_vehicle_IND_light      = "I_G_Offroad_01_armed_F";
			CSWR_vehicle_IND_medium     = "I_MRAP_03_hmg_F";
			CSWR_vehicle_IND_heavy      = "I_MBT_03_cannon_F";
			CSWR_vehicle_IND_custom_1   = "";
			CSWR_vehicle_IND_custom_2   = "";
			CSWR_vehicle_IND_custom_3   = "";
			CSWR_vehicle_IND_heli_light = "I_Heli_light_03_dynamicLoadout_F";  // low altitudes.
			CSWR_vehicle_IND_heli_heavy = "I_Heli_light_03_dynamicLoadout_F";  // high altitudes.
			
			// Soldiers groups
			CSWR_group_IND_light	= ["I_Soldier_TL_F", "I_soldier_F"];
			CSWR_group_IND_medium   = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F"];
			CSWR_group_IND_heavy	= ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_Soldier_AR_F", "I_Soldier_M_F", "I_Soldier_AT_F"];
			CSWR_group_IND_custom_1 = [];
			CSWR_group_IND_custom_2 = [];
			CSWR_group_IND_custom_3 = [];
			CSWR_group_IND_sniper   = ["I_ghillie_ard_F", "I_Sniper_F"];  // Max 2 units.

			// Groups formation
			// Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"
			_form_IND_1 = "WEDGE";
			_form_IND_2 = "FILE";

			// CSWR CORE > DONT TOUCH > Public variables:
			publicVariable "CSWR_vehicle_IND_light"; publicVariable "CSWR_vehicle_IND_medium"; publicVariable "CSWR_vehicle_IND_heavy"; publicVariable "CSWR_vehicle_IND_custom_1"; publicVariable "CSWR_vehicle_IND_custom_2"; publicVariable "CSWR_vehicle_IND_custom_3"; publicVariable "CSWR_vehicle_IND_heli_light"; publicVariable "CSWR_vehicle_IND_heli_heavy"; publicVariable "CSWR_group_IND_light"; publicVariable "CSWR_group_IND_medium"; publicVariable "CSWR_group_IND_heavy"; publicVariable "CSWR_group_IND_custom_1"; publicVariable "CSWR_group_IND_custom_2"; publicVariable "CSWR_group_IND_custom_3"; publicVariable "CSWR_group_IND_sniper";

		// SPAWNING GROUPS: INDEPENDENT
		// Define each group and their features and destination.

			// Vehicles
			// [ owner, spawns (CSWR_spwnsIND, CSWR_spwnsVehIND, CSWR_spwnsHeliIND, CSWR_spwnsParadropIND), vehicle type, initial crew behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[INDEPENDENT, CSWR_spwnsVehIND, CSWR_vehicle_IND_light, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsVehIND, CSWR_vehicle_IND_light, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsVehIND, CSWR_vehicle_IND_medium, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsVehIND, CSWR_vehicle_IND_heavy, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsVehIND, CSWR_vehicle_IND_heavy, _be_COMBAT, _move_HOLD, []] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsHeliIND, CSWR_vehicle_IND_heli_light, _be_COMBAT, _move_ANY, [1]] call THY_fnc_CSWR_add_vehicle;
			[INDEPENDENT, CSWR_spwnsHeliIND, CSWR_vehicle_IND_heli_heavy, _be_COMBAT, _move_ANY, [2]] call THY_fnc_CSWR_add_vehicle;
			
			// Soldier groups
			// [ owner, spawns (CSWR_spwnsIND, CSWR_spwnsVehIND, CSWR_spwnsParadropIND), team type, team formation (_form_IND_1, _form_IND_2), initial team behavior (_be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS), destination (_move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_sniper, _form_IND_1, _be_COMBAT, _move_WATCH, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_HOLD, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_AWARE, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_light, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_AWARE, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_medium, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_heavy, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_heavy, _form_IND_1, _be_SAFE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_heavy, _form_IND_1, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			[INDEPENDENT, CSWR_spwnsIND, CSWR_group_IND_heavy, _form_IND_1, _be_AWARE, _move_ANY, []] call THY_fnc_CSWR_add_group;
			
	}; // ind ends.


	// ..............................................................................................................................


	if ( CSWR_isOnCIV && count CSWR_spwnsAllCIV > 0 ) then {

		// DEFINING FACTION GROUPS: CIVILIAN
		// Define the number of people and vehicles of Civilian side.

			// Vehicles
			CSWR_vehicle_CIV_light      = "C_Hatchback_01_F";
			CSWR_vehicle_CIV_medium     = "C_Offroad_01_repair_F";
			CSWR_vehicle_CIV_heavy      = "C_Van_01_transport_F";
			CSWR_vehicle_CIV_custom_1   = "";
			CSWR_vehicle_CIV_custom_2   = "";
			CSWR_vehicle_CIV_custom_3   = "";
			CSWR_vehicle_CIV_heli_light = "C_Heli_Light_01_civil_F";  // low altitudes.
			CSWR_vehicle_CIV_heli_heavy = "";  // high altitudes.
			
			// People groups
			CSWR_group_CIV_lone     = ["C_man_polo_1_F"];
			CSWR_group_CIV_couple   = ["C_man_polo_1_F", "C_man_polo_2_F"];
			CSWR_group_CIV_gang     = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
			CSWR_group_CIV_custom_1 = [];
			CSWR_group_CIV_custom_2 = [];
			CSWR_group_CIV_custom_3 = [];

			// Groups formation
			// Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"
			_form_CIV_1 = "DIAMOND";
			_form_CIV_2 = "FILE";

			// CSWR CORE > DONT TOUCH > Public variables:
			publicVariable "CSWR_vehicle_CIV_light"; publicVariable "CSWR_vehicle_CIV_medium"; publicVariable "CSWR_vehicle_CIV_heavy"; publicVariable "CSWR_vehicle_CIV_custom_1"; publicVariable "CSWR_vehicle_CIV_custom_2"; publicVariable "CSWR_vehicle_CIV_custom_3"; publicVariable "CSWR_vehicle_CIV_heli_light"; publicVariable "CSWR_vehicle_CIV_heli_heavy"; publicVariable "CSWR_group_CIV_lone"; publicVariable "CSWR_group_CIV_couple"; publicVariable "CSWR_group_CIV_gang"; publicVariable "CSWR_group_CIV_custom_1"; publicVariable "CSWR_group_CIV_custom_2"; publicVariable "CSWR_group_CIV_custom_3";
		
		// SPAWNING GROUPS: CIVILIAN
		// Define each group and their features and destination.

			// Vehicles
			// [ owner, spawns (CSWR_spwnsCIV, CSWR_spwnsVehCIV, CSWR_spwnsHeliCIV), vehicle type, initial crew behavior (_be_SAFE, _be_AWARE, _be_CHAOS), destination (_move_PUBLIC, _move_RESTRICTED, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[CIVILIAN, CSWR_spwnsCIV, CSWR_vehicle_CIV_light, _be_CHAOS, _move_PUBLIC, []] call THY_fnc_CSWR_add_vehicle;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_vehicle_CIV_medium, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_vehicle;
			[CIVILIAN, CSWR_spwnsVehCIV, CSWR_vehicle_CIV_heavy, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_vehicle;
			[CIVILIAN, CSWR_spwnsHeliCIV, CSWR_vehicle_CIV_heli_light, _be_AWARE, _move_PUBLIC, []] call THY_fnc_CSWR_add_vehicle;
			
			// People groups
			// [ owner, spawns (CSWR_spwnsCIV, CSWR_spwnsVehCIV, CSWR_spwnsParadropCIV), team type, team formation (_form_CIV_1, _form_CIV_2), initial team behavior (_be_SAFE, _be_AWARE, _be_CHAOS), destination (_move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_HOLD), spawn delay (in minutes, or a list of triggers or targets. Check the documentation) ]
			
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_AWARE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_lone, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_couple, _form_CIV_1, _be_SAFE, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_couple, _form_CIV_1, _be_CHAOS, _move_OCCUPY, []] call THY_fnc_CSWR_add_group;
			[CIVILIAN, CSWR_spwnsCIV, CSWR_group_CIV_gang, _form_CIV_2, _be_CHAOS, _move_PUBLIC, []] call THY_fnc_CSWR_add_group;
 
	}; // civ ends.

};  // spawn ends.
// Return:
true;
