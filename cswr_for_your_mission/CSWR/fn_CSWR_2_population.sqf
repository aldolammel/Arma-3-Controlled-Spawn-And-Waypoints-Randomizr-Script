// CSWR: AUTOMATIZING THE WAR v7.2
// File: your_mission\CSWR\fn_CSWR_2_population.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)

if ( !isServer || !CSWR_isOn ) exitWith {};

[] spawn {
    // CSWR CORE > DONT TOUCH > Wait if needed:
    private _t = time + CSWR_wait;
    waitUntil { sleep 0.2; time > _t };
    // CSWR CORE > DONT TOUCH > Object declarations:
    private _form_BLU_1=""; private _form_OPF_1=""; private _form_IND_1=""; private _form_CIV_1=""; private _form_BLU_2=""; private _form_OPF_2=""; private _form_IND_2=""; private _form_CIV_2=""; private _form_BLU_3=""; private _form_OPF_3=""; private _form_IND_3=""; private _be_SAFE="BE_SAFE"; private _be_AWARE="BE_AWARE"; private _be_COMBAT="BE_COMBAT"; private _be_STEALTH="BE_STEALTH"; private _be_CHAOS="BE_CHAOS"; private _move_ANY="MOVE_ANY"; private _move_PUBLIC="MOVE_PUBLIC"; private _move_RESTRICTED="MOVE_RESTRICTED"; private _move_WATCH="MOVE_WATCH"; private _move_OCCUPY="MOVE_OCCUPY"; private _move_HOLD="MOVE_HOLD"; private _move_EXTRACTION="MOVE_EXTRACTION"; private _move_TRANSPORT="MOVE_TRANSPORT";


    // ..............................................................................................................................


    if ( CSWR_isOnBLU && CSWR_spwnsAllBLU isNotEqualTo [] ) then {

        // DEFINING SIDE: BLUFOR
        // Define the number of soldiers (and their weapons) and vehicles of BluFor side.

            // Vehicles
            CSWR_vehicle_BLU_ground_light    = "B_LSV_01_armed_F";
            CSWR_vehicle_BLU_ground_medium   = "B_APC_Wheeled_01_cannon_F";
            CSWR_vehicle_BLU_ground_heavy    = "B_MBT_01_TUSK_F";
            CSWR_vehicle_BLU_ground_custom_1 = "";
            CSWR_vehicle_BLU_ground_custom_2 = "";
            CSWR_vehicle_BLU_ground_custom_3 = "";
            CSWR_vehicle_BLU_nautic_light    = "";
            CSWR_vehicle_BLU_nautic_medium   = "B_Boat_Armed_01_minigun_F";
            CSWR_vehicle_BLU_nautic_heavy    = "";
            CSWR_vehicle_BLU_heli_light      = "B_Heli_Light_01_dynamicLoadout_F";  // low altitudes.
            CSWR_vehicle_BLU_heli_medium     = "B_Heli_Transport_01_F";  // medium altitudes.
            CSWR_vehicle_BLU_heli_heavy      = "B_Heli_Attack_01_dynamicLoadout_F";  // high altitudes.

            // People groups
            CSWR_people_BLU_light    = ["B_Soldier_TL_F", "B_Soldier_F"];
            CSWR_people_BLU_medium   = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F"];
            CSWR_people_BLU_heavy    = ["B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_soldier_AR_F", "B_soldier_M_F", "B_medic_F"];
            CSWR_people_BLU_custom_1 = [];
            CSWR_people_BLU_custom_2 = [];
            CSWR_people_BLU_custom_3 = [];
            CSWR_people_BLU_sniper   = ["B_ghillie_ard_F", "B_sniper_F"];  // Max 2 units.

            // Groups formation
            // Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND".
            _form_BLU_1 = "COLUMN";
            _form_BLU_2 = "FILE";
            _form_BLU_3 = "DIAMOND";

            // CSWR CORE > DONT TOUCH > Public variables:
            publicVariable "CSWR_vehicle_BLU_ground_light"; publicVariable "CSWR_vehicle_BLU_ground_medium"; publicVariable "CSWR_vehicle_BLU_ground_heavy"; publicVariable "CSWR_vehicle_BLU_ground_custom_1"; publicVariable "CSWR_vehicle_BLU_ground_custom_2"; publicVariable "CSWR_vehicle_BLU_ground_custom_3"; publicVariable "CSWR_vehicle_BLU_nautic_light"; publicVariable "CSWR_vehicle_BLU_nautic_medium"; publicVariable "CSWR_vehicle_BLU_nautic_heavy"; publicVariable "CSWR_vehicle_BLU_heli_light"; publicVariable "CSWR_vehicle_BLU_heli_medium"; publicVariable "CSWR_vehicle_BLU_heli_heavy"; publicVariable "CSWR_people_BLU_light"; publicVariable "CSWR_people_BLU_medium"; publicVariable "CSWR_people_BLU_heavy"; publicVariable "CSWR_people_BLU_custom_1"; publicVariable "CSWR_people_BLU_custom_2"; publicVariable "CSWR_people_BLU_custom_3"; publicVariable "CSWR_people_BLU_sniper";

        // SPAWNING: BLUFOR
        // Define each group and their features and destination.

            // Vehicles
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForVehicleBLU, CSWR_spawnsForHelicopterBLU, CSWR_spawnsParadropBLU]; Vehicle type; Initial crew behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD, _move_EXTRACTION, _move_TRANSPORT]; [Spawn delay: timer, trigger activation, target status] ];

            [BLUFOR, [CSWR_spawnsForVehicleBLU, "A"], CSWR_vehicle_BLU_ground_medium, _be_COMBAT, [_move_RESTRICTED, "A"], []] call THY_fnc_CSWR_add_vehicle;
            [BLUFOR, [CSWR_spawnsForVehicleBLU, "A"], CSWR_vehicle_BLU_ground_heavy, _be_SAFE, [_move_RESTRICTED, "A"], []] call THY_fnc_CSWR_add_vehicle;


            // People groups
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForPeopleBLU, CSWR_spawnsParadropBLU]; Group type; Group formation: _form_BLU_1, _form_BLU_2; Initial group behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD]; [Spawn delay: timer, trigger activation, target status] ];

            [BLUFOR, [CSWR_spawnsForPeopleBLU, "A"], CSWR_people_BLU_light, _form_BLU_1, _be_SAFE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [BLUFOR, [CSWR_spawnsForPeopleBLU, "A"], CSWR_people_BLU_medium, _form_BLU_1, _be_AWARE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [BLUFOR, [CSWR_spawnsForPeopleBLU, "A"], CSWR_people_BLU_heavy, _form_BLU_1, _be_COMBAT, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            

    }; // blufor ends.


    // ..............................................................................................................................


    if ( CSWR_isOnOPF && CSWR_spwnsAllOPF isNotEqualTo [] ) then {

        // DEFINING SIDE: OPFOR
        // Define the number of soldiers (and their weapons) and vehicles of OpFor side.

            // Vehicles
            CSWR_vehicle_OPF_ground_light    = "O_MRAP_02_hmg_F";
            CSWR_vehicle_OPF_ground_medium   = "O_APC_Tracked_02_cannon_F";
            CSWR_vehicle_OPF_ground_heavy    = "O_MBT_02_cannon_F";
            CSWR_vehicle_OPF_ground_custom_1 = "";
            CSWR_vehicle_OPF_ground_custom_2 = "";
            CSWR_vehicle_OPF_ground_custom_3 = "";
            CSWR_vehicle_OPF_nautic_light    = "";
            CSWR_vehicle_OPF_nautic_medium   = "O_Boat_Armed_01_hmg_F";
            CSWR_vehicle_OPF_nautic_heavy    = "";
            CSWR_vehicle_OPF_heli_light      = "O_Heli_Light_02_dynamicLoadout_F";  // low altitudes.
            CSWR_vehicle_OPF_heli_medium     = "O_Heli_Transport_04_covered_F";  // medium altitudes.
            CSWR_vehicle_OPF_heli_heavy      = "O_Heli_Attack_02_dynamicLoadout_F";  // high altitudes.

            // People groups
            CSWR_people_OPF_light    = ["O_Soldier_TL_F", "O_Soldier_F"];
            CSWR_people_OPF_medium   = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F"];
            CSWR_people_OPF_heavy    = ["O_Soldier_TL_F", "O_Soldier_F", "O_Soldier_A_F", "O_soldier_AR_F", "O_soldier_M_F", "O_R_medic_F"];
            CSWR_people_OPF_custom_1 = [];
            CSWR_people_OPF_custom_2 = [];
            CSWR_people_OPF_custom_3 = [];
            CSWR_people_OPF_sniper   = ["O_ghillie_ard_F", "O_sniper_F"];  // Max 2 units.

            // Groups formation
            // Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND".
            _form_OPF_1 = "WEDGE";
            _form_OPF_2 = "FILE";
            _form_OPF_3 = "DIAMOND";

            // CSWR CORE > DONT TOUCH > Public variables:
            publicVariable "CSWR_vehicle_OPF_ground_light"; publicVariable "CSWR_vehicle_OPF_ground_medium"; publicVariable "CSWR_vehicle_OPF_ground_heavy"; publicVariable "CSWR_vehicle_OPF_ground_custom_1"; publicVariable "CSWR_vehicle_OPF_ground_custom_2"; publicVariable "CSWR_vehicle_OPF_ground_custom_3"; publicVariable "CSWR_vehicle_OPF_nautic_light"; publicVariable "CSWR_vehicle_OPF_nautic_medium"; publicVariable "CSWR_vehicle_OPF_nautic_heavy"; publicVariable "CSWR_vehicle_OPF_heli_light"; publicVariable "CSWR_vehicle_OPF_heli_medium"; publicVariable "CSWR_vehicle_OPF_heli_heavy"; publicVariable "CSWR_people_OPF_light"; publicVariable "CSWR_people_OPF_medium"; publicVariable "CSWR_people_OPF_heavy"; publicVariable "CSWR_people_OPF_custom_1"; publicVariable "CSWR_people_OPF_custom_2"; publicVariable "CSWR_people_OPF_custom_3"; publicVariable "CSWR_people_OPF_sniper";

        // SPAWNING: OPFOR
        // Define each group and their features and destination.

            // Vehicles
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForVehicleOPF, CSWR_spawnsForHelicopterOPF, CSWR_spawnsParadropOPF]; Vehicle type; Initial crew behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD, _move_EXTRACTION, _move_TRANSPORT]; [Spawn delay: timer, trigger activation, target status] ];

            [OPFOR, [CSWR_spawnsForVehicleOPF, "A"], CSWR_vehicle_OPF_ground_medium, _be_COMBAT, [_move_ANY, ""], []] call THY_fnc_CSWR_add_vehicle;
            [OPFOR, [CSWR_spawnsForVehicleOPF, "A"], CSWR_vehicle_OPF_ground_heavy, _be_SAFE, [_move_RESTRICTED, "A"], []] call THY_fnc_CSWR_add_vehicle;


            // People groups
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForPeopleOPF, CSWR_spawnsParadropOPF]; Group type; Group formation: _form_OPF_1, _form_OPF_2; Initial group behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD]; [Spawn delay: timer, trigger activation, target status] ];

            [OPFOR, [CSWR_spawnsForPeopleOPF, "A"], CSWR_people_OPF_light, _form_OPF_1, _be_COMBAT, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [OPFOR, [CSWR_spawnsForPeopleOPF, "A"], CSWR_people_OPF_medium, _form_OPF_1, _be_AWARE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [OPFOR, [CSWR_spawnsForPeopleOPF, "A"], CSWR_people_OPF_heavy, _form_OPF_1, _be_SAFE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;


    }; // opfor ends.


    // ..............................................................................................................................


    if ( CSWR_isOnIND && CSWR_spwnsAllIND isNotEqualTo [] ) then {

        // DEFINING SIDE: INDEPENDENT
        // Define the number of soldiers (and their weapons) and vehicles of Independent side.

            // Vehicles
            CSWR_vehicle_IND_ground_light    = "I_G_Offroad_01_armed_F";
            CSWR_vehicle_IND_ground_medium   = "I_APC_Wheeled_03_cannon_F";
            CSWR_vehicle_IND_ground_heavy    = "I_MBT_03_cannon_F";
            CSWR_vehicle_IND_ground_custom_1 = "";
            CSWR_vehicle_IND_ground_custom_2 = "";
            CSWR_vehicle_IND_ground_custom_3 = "";
            CSWR_vehicle_IND_nautic_light    = "";
            CSWR_vehicle_IND_nautic_medium   = "I_Boat_Armed_01_minigun_F";
            CSWR_vehicle_IND_nautic_heavy    = "";
            CSWR_vehicle_IND_heli_light      = "I_Heli_light_03_dynamicLoadout_F";  // low altitudes.
            CSWR_vehicle_IND_heli_medium     = "I_Heli_Transport_02_F";  // medium altitudes.
            CSWR_vehicle_IND_heli_heavy      = "I_Heli_light_03_dynamicLoadout_F";  // high altitudes.

            // People groups
            CSWR_people_IND_light    = ["I_Soldier_TL_F", "I_soldier_F"];
            CSWR_people_IND_medium   = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_E_Soldier_AR_F"];
            CSWR_people_IND_heavy    = ["I_Soldier_TL_F", "I_soldier_F", "I_Soldier_A_F", "I_E_Soldier_AR_F", "I_Soldier_M_F", "I_medic_F"];
            CSWR_people_IND_custom_1 = [];
            CSWR_people_IND_custom_2 = [];
            CSWR_people_IND_custom_3 = [];
            CSWR_people_IND_sniper   = ["I_ghillie_ard_F", "I_Sniper_F"];  // Max 2 units.

            // Groups formation
            // Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND".
            _form_IND_1 = "WEDGE";
            _form_IND_2 = "FILE";
            _form_IND_3 = "DIAMOND";

            // CSWR CORE > DONT TOUCH > Public variables:
            publicVariable "CSWR_vehicle_IND_ground_light"; publicVariable "CSWR_vehicle_IND_ground_medium"; publicVariable "CSWR_vehicle_IND_ground_heavy"; publicVariable "CSWR_vehicle_IND_ground_custom_1"; publicVariable "CSWR_vehicle_IND_ground_custom_2"; publicVariable "CSWR_vehicle_IND_ground_custom_3"; publicVariable "CSWR_vehicle_IND_nautic_light"; publicVariable "CSWR_vehicle_IND_nautic_medium"; publicVariable "CSWR_vehicle_IND_nautic_heavy"; publicVariable "CSWR_vehicle_IND_heli_light"; publicVariable "CSWR_vehicle_IND_heli_medium"; publicVariable "CSWR_vehicle_IND_heli_heavy"; publicVariable "CSWR_people_IND_light"; publicVariable "CSWR_people_IND_medium"; publicVariable "CSWR_people_IND_heavy"; publicVariable "CSWR_people_IND_custom_1"; publicVariable "CSWR_people_IND_custom_2"; publicVariable "CSWR_people_IND_custom_3"; publicVariable "CSWR_people_IND_sniper";

        // SPAWNING: INDEPENDENT
        // Define each group and their features and destination.

            // Vehicles
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForVehicleIND, CSWR_spawnsForHelicopterIND, CSWR_spawnsParadropIND]; Vehicle type; Initial crew behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_HOLD, _move_EXTRACTION, _move_TRANSPORT]; [Spawn delay: timer, trigger activation, target status] ];

            [INDEPENDENT, [CSWR_spawnsForVehicleIND, "A"], CSWR_vehicle_IND_ground_medium, _be_AWARE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_vehicle;
            [INDEPENDENT, [CSWR_spawnsForVehicleIND, "A"], CSWR_vehicle_IND_ground_heavy, _be_SAFE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_vehicle;


            // People groups
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForPeopleIND, CSWR_spawnsParadropIND]; Group type; Group formation: _form_IND_1, _form_IND_2; Initial group behavior: _be_SAFE, _be_AWARE, _be_COMBAT, _be_STEALTH, _be_CHAOS; [Destination: _move_ANY, _move_PUBLIC, _move_RESTRICTED, _move_OCCUPY, _move_WATCH, _move_HOLD]; [Spawn delay: timer, trigger activation, target status] ];

            [INDEPENDENT, [CSWR_spawnsForPeopleIND, "A"], CSWR_people_IND_light, _form_IND_1, _be_AWARE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [INDEPENDENT, [CSWR_spawnsForPeopleIND, "A"], CSWR_people_IND_medium, _form_IND_1, _be_SAFE, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;
            [INDEPENDENT, [CSWR_spawnsForPeopleIND, "A"], CSWR_people_IND_heavy, _form_IND_1, _be_COMBAT, [_move_ANY, ""], []] call THY_fnc_CSWR_add_people;


    }; // ind ends.


    // ..............................................................................................................................


    if ( CSWR_isOnCIV && CSWR_spwnsAllCIV isNotEqualTo [] ) then {

        // DEFINING SIDE: CIVILIAN
        // Define the number of people and vehicles of Civilian side.

            // Vehicles
            CSWR_vehicle_CIV_ground_light    = "C_Hatchback_01_F";
            CSWR_vehicle_CIV_ground_medium   = "C_Offroad_01_repair_F";
            CSWR_vehicle_CIV_ground_heavy    = "C_Van_01_transport_F";
            CSWR_vehicle_CIV_ground_custom_1 = "";
            CSWR_vehicle_CIV_ground_custom_2 = "";
            CSWR_vehicle_CIV_ground_custom_3 = "";
            CSWR_vehicle_CIV_nautic_light    = "C_Scooter_Transport_01_F";
            CSWR_vehicle_CIV_nautic_medium   = "C_Boat_Civil_01_F";
            CSWR_vehicle_CIV_nautic_heavy    = "";
            CSWR_vehicle_CIV_heli_light      = "C_Heli_Light_01_civil_F";  // low altitudes.
            CSWR_vehicle_CIV_heli_medium     = "";  // medium altitudes.
            CSWR_vehicle_CIV_heli_heavy      = "C_IDAP_Heli_Transport_02_F";  // high altitudes.

            // People groups
            CSWR_people_CIV_light    = ["C_man_polo_1_F"];
            CSWR_people_CIV_medium   = ["C_man_polo_1_F", "C_man_polo_2_F"];
            CSWR_people_CIV_heavy    = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F"];
            CSWR_people_CIV_custom_1 = [];
            CSWR_people_CIV_custom_2 = [];
            CSWR_people_CIV_custom_3 = [];

            // Groups formation
            // Options: "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND".
            _form_CIV_1 = "DIAMOND";
            _form_CIV_2 = "FILE";

            // CSWR CORE > DONT TOUCH > Public variables:
            publicVariable "CSWR_vehicle_CIV_ground_light"; publicVariable "CSWR_vehicle_CIV_ground_medium"; publicVariable "CSWR_vehicle_CIV_ground_heavy"; publicVariable "CSWR_vehicle_CIV_ground_custom_1"; publicVariable "CSWR_vehicle_CIV_ground_custom_2"; publicVariable "CSWR_vehicle_CIV_ground_custom_3"; publicVariable "CSWR_vehicle_CIV_nautic_light"; publicVariable "CSWR_vehicle_CIV_nautic_medium"; publicVariable "CSWR_vehicle_CIV_nautic_heavy"; publicVariable "CSWR_vehicle_CIV_heli_light"; publicVariable "CSWR_vehicle_CIV_heli_medium"; publicVariable "CSWR_vehicle_CIV_heli_heavy"; publicVariable "CSWR_people_CIV_light"; publicVariable "CSWR_people_CIV_medium"; publicVariable "CSWR_people_CIV_heavy"; publicVariable "CSWR_people_CIV_custom_1"; publicVariable "CSWR_people_CIV_custom_2"; publicVariable "CSWR_people_CIV_custom_3";

        // SPAWNING: CIVILIAN
        // Define each group and their features and destination.

            // Vehicles
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForVehicleCIV, CSWR_spawnsForHelicopterCIV]; Vehicle type; Initial crew behavior: _be_SAFE, _be_AWARE, _be_CHAOS; [Destination: _move_PUBLIC, _move_HOLD, _move_EXTRACTION, _move_TRANSPORT]; [Spawn delay: timer, trigger activation, target status] ];

            [CIVILIAN, [CSWR_spawnsForVehicleCIV, "A"], CSWR_vehicle_CIV_ground_light, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_vehicle;
            [CIVILIAN, [CSWR_spawnsForVehicleCIV, "A"], CSWR_vehicle_CIV_ground_medium, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_vehicle;
            [CIVILIAN, [CSWR_spawnsForVehicleCIV, "A"], CSWR_vehicle_CIV_ground_heavy, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_vehicle;
            

            // People groups
            // Guideline for you: [ Side; [Spawns: CSWR_spawnsForPeopleCIV, CSWR_spawnsParadropCIV]; Group type; Group formation: _form_CIV_1, _form_CIV_2; Initial group behavior: _be_SAFE, _be_AWARE, _be_CHAOS; [Destination: _move_PUBLIC, _move_OCCUPY, _move_HOLD]; [Spawn delay: timer, trigger activation, target status] ];

            [CIVILIAN, [CSWR_spawnsForPeopleCIV, "A"], CSWR_people_CIV_light, _form_CIV_1, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_people;
            [CIVILIAN, [CSWR_spawnsForPeopleCIV, "A"], CSWR_people_CIV_light, _form_CIV_1, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_people;
            [CIVILIAN, [CSWR_spawnsForPeopleCIV, "A"], CSWR_people_CIV_light, _form_CIV_1, _be_SAFE, [_move_PUBLIC, "A"], []] call THY_fnc_CSWR_add_people;
            

    }; // civ ends.

};  // spawn ends.
// Return:
true;
