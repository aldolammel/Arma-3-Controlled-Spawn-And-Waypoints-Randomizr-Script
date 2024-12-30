// CSWR v7.0
// File: your_mission\CSWRandomizr\fn_CSWR_management.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)

if !isServer exitWith {};

// PARAMETERS OF EDITOR'S OPTIONS:
CSWR_isOn = true;                        // Turn on or off the entire script without to touch your description.ext / Default: true;

// Debug:
    CSWR_isOnDebug = true;               // true = shows basic debug information for the Mission Editor / false = turn it off / Default: false;
        CSWR_isOnDebugOccupy  = true;   // true = shows deeper Occupy-markers debug info / false = turn it off / Default: false;
        CSWR_isOnDebugWatch   = true;   // true = shows deeper Watch-markers debug info / false = turn it off / Default: false;
        CSWR_isOnDebugHold    = true;   // true = shows deeper Hold-markers debug info / false = turn it off / Default: false;
        CSWR_isOnDebugHeli    = false;   // true = shows deeper AI Helicopters piloting debug info / false = turn it off / Default: false;
        CSWR_isOnDebugNautic  = true;   // true = shows deeper Nautical debug info / false = turn it off / Default: false;
        CSWR_isOnDebugPara    = false;   // true = shows deeper Paradrop debug info / false = turn it off / Default: false;
        CSWR_isOnDebugBooking = false;   // true = shows deeper markers booking debug info / false = turn it off / Default: false;
        CSWR_isOnDebugSectors = true;   // true = shows deeper info about sectors when it's used / false = turn it off / Default: false;

// Sides:
    CSWR_isOnBLU = true;   // true = spawn BluFor/West through CSWR / false = don't spawn this side.
    CSWR_isOnOPF = false;  // true = spawn OpFor/East through CSWR / false = don't spawn this side.
    CSWR_isOnIND = false;  // true = spawn Indepdentent/Resistence through CSWR / false = don't spawn this side.
    CSWR_isOnCIV = false;  // true = spawn Civilian through CSWR / false = don't spawn this side.

// For all sides:
    CSWR_isBackpackForAllByFoot = false;  // true = all units by foot (including CIV) will get it / false = only units originally with backpacks / Default: false;
    CSWR_isVestForAll           = false;  // true = all units (including CIV) will get it / false = only units originally with vests / Default: false;

// Settings by Side:
    // Blu
        CSWR_facesFromRegionBLU  = "";       // Options: "Asia", "Africa", "Europe", "EastEurope", "MidEast", "NorthAmerica", "SouthAmerica" / Empty ("") no changes / Default: "";
        CSWR_languageBLU         = "";       // Options: "UsEnglish", "GbEnglish", "French", "Polish", "Russian", "Chinese", "Iranian" / Empty ("") auto selected by region / Default: "";
        CSWR_canNvgInfantryBLU   = false;    // true = BLU infantry (including light vehicle crew) receives NightVision / false = BLU infantry NVG will be removed.
        CSWR_canNvgMarinesBLU    = true;    // true = BLU marines receive NightVision / false = BLU marines NVG will be removed.
        CSWR_canNvgParatroopsBLU = false;    // true = BLU paratroops receive NightVision / false = BLU paratroops NVG will be removed.
        CSWR_canNvgSnipersBLU    = false;    // true = BLU snipers receive NightVision / false = Snipers NVG are removed (no matter if infantry, marine or paratroop).
        CSWR_nvgDeviceBLU        = "NVGoggles_INDEP";  // Set the NightVision classname for BlU army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightBLU    = true;    // true = BLU units with no NVG get flashlights for their primary weapons / false = no flashlights.
        CSWR_isForcedFlashlBLU   = false;   // true = try to force all BLU stays with flashlight always On / false = Arma decides / Default: false;
        CSWR_flashlightDeviceBLU = "acc_flashlight";  // Set the flashlight classname for BlU army. Empty ("") means no changes in original soldier loadout.
        CSWR_watcherAccuranceBLU = "V";     // Group's accurance executing Watch-Destination: "R" for Recruit, "V" for Veteran, "E" for Expert.
        CSWR_isElectroWarForBLU  = true;    // true = vehicles of BLU will use Electronic Warfare Resources / false = they don't / Default: true;
    // Opf
        CSWR_facesFromRegionOPF  = "";       // Options: "Asia", "Africa", "Europe", "EastEurope", "MidEast", "NorthAmerica", "SouthAmerica" / Empty ("") no changes / Default: "";
        CSWR_languageOPF         = "";       // Options: "UsEnglish", "GbEnglish", "French", "Polish", "Russian", "Chinese", "Iranian" / Empty ("") auto selected by region / Default: "";
        CSWR_canNvgInfantryOPF   = false;    // true = OPF infantry (including light vehicle crew) receives NightVision / false = OPF infantry NVG will be removed.
        CSWR_canNvgMarinesOPF    = true;    // true = OPF marines receive NightVision / false = OPF marines NVG will be removed.
        CSWR_canNvgParatroopsOPF = false;    // true = OPF paratroops receive NightVision / false = OPF paratroops NVG will be removed.
        CSWR_canNvgSnipersOPF    = false;    // true = OPF snipers receive NightVision / false = Snipers NVG are removed (no matter if infantry, marine or paratroop).
        CSWR_nvgDeviceOPF        = "NVGogglesB_grn_F";  // Set the NightVision classname for OPF army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightOPF    = true;    // true = OPF units with no NVG get flashlights for their primary weapons / false = no flashlights.
        CSWR_isForcedFlashlOPF   = false;   // true = try to force all OPF stays with flashlight always On / false = Arma decides / Default: false;
        CSWR_flashlightDeviceOPF = "acc_flashlight";  // Set the flashlight classname for OPF army. Empty ("") means no changes in original soldier loadout.
        CSWR_watcherAccuranceOPF = "V";     // Group's accurance executing Watch-Destination: "R" for Recruit, "V" for Veteran, "E" for Expert.
        CSWR_isElectroWarForOPF  = true;    // true = vehicles of OPF will use Electronic Warfare Resources / false = they don't / Default: true;
    // Ind
        CSWR_facesFromRegionIND  = "";      // Options: "Asia", "Africa", "Europe", "EastEurope", "MidEast", "NorthAmerica", "SouthAmerica" / Empty ("") no changes / Default: "";
        CSWR_languageIND         = "";      // Options: "UsEnglish", "GbEnglish", "French", "Polish", "Russian", "Chinese", "Iranian" / Empty ("") auto selected by region / Default: "";
        CSWR_canNvgInfantryIND   = false;   // true = IND infantry (including light vehicle crew) receives NightVision / false = IND infantry NVG will be removed.
        CSWR_canNvgMarinesIND    = true;   // true = IND marines receive NightVision / false = IND marines NVG will be removed.
        CSWR_canNvgParatroopsIND = false;   // true = IND paratroops receive NightVision / false = IND paratroops NVG will be removed.
        CSWR_canNvgSnipersIND    = false;   // true = IND snipers receive NightVision / false = Snipers NVG are removed (no matter if infantry, marine or paratroop).
        CSWR_nvgDeviceIND        = "NVGoggles_INDEP";  // Set the NightVision classname for IND army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightIND    = true;    // true = IND units with no NVG get flashlights for their primary weapons / false = no flashlights.
        CSWR_isForcedFlashlIND   = false;   // true = try to force all IND stays with flashlight always On / false = Arma decides / Default: false;
        CSWR_flashlightDeviceIND = "acc_flashlight";  // Set the flashlight classname for IND army. Empty ("") means no changes in original soldier loadout.
        CSWR_watcherAccuranceIND = "V";     // Group's accurance executing Watch-Destination: "R" for Recruit, "V" for Veteran, "E" for Expert.
        CSWR_isElectroWarForIND  = true;    // true = vehicles of IND will use Electronic Warfare Resources / false = they don't / Default: true;
    // Civ
        CSWR_facesFromRegionCIV = "";           // Options: "Asia", "Africa", "Europe", "EastEurope", "MidEast", "NorthAmerica", "SouthAmerica" / Empty ("") no changes / Default: "";
        CSWR_languageCIV        = "";           // Options: "UsEnglish", "GbEnglish", "French", "Polish", "Russian", "Chinese", "Iranian" / Empty ("") auto selected by region / Default: "";
        CSWR_canNvgCIV          = false;        // true = CIV people receive NightVision / false = CIV people NVG will be removed.
        CSWR_nvgDeviceCIV       = "NVGoggles";  // Set the NightVision classname for CIV people. Empty ("") means no changes in original people outfit.

// Global Helicopters settings:
    CSWR_isHeliSpwningInAir   = false;  // true = helicopter will spawn already in air / false = they spawn landed (unless the spawn is in water) / Default: false;
    CSWR_shouldAddHelipadSpwn = false;  // true = add a visible helipad in each heli spawnpoint / false = a invisible helipad is added / Default: false;
    CSWR_heliTakeOffDelay     = [30, 45, 60];  // In seconds, how long each helicopter can stay before takeoff / Default: [30, 45, 60];
    CSWR_heliLightAlt         = 300;   // In meters, cruising altitude for helicopters of light class / Minimal: 150 / Default: 300;
    CSWR_heliHeavyAlt         = 600;   // In meters, cruising altitude for helicopters of heavy class / Minimal: 150 more than light class / Default: 600;

// Global Paradrop settings:
    CSWR_spwnsParadropUnitAlt   = 1000;  // In meters, the initial unit paradrop altitude / Default: 1000;
    CSWR_spwnsParadropVehAlt    = 600;   // In meters, the initial vehicle paradrop altitude / Default: 600;
    CSWR_spwnsParadropSpreading = 500;   // In meters, the spreading distance between paradrop units and vehicles / Minimal: 200 / Default: 500;
    CSWR_spwnsParadropWaiting   = 8;     // In minutes, time that each paratroop leader waits a member regroup right after the landing / Minimal 5 / Default: 8;

// Global Destination settings:
    // Move:
        CSWR_destCommonTakeabreak = [0, 30, 60];  // In seconds, how long each group can stay on its Move-markers / Default: [0, 30, 60];
    // Hold:
        CSWR_destHoldTakeabreak = [1800, 3600, 7200];  // In seconds, how long each group can stay on its Hold-markers / Default: [1800, 3600, 7200]; (30min, 1h, 2h)
        CSWR_isHoldVehLightsOff = false;               // true = vehicles on hold-position turn lights off / false = Arma decides / Default: false;
    // Watch:
        CSWR_watchMkrRange = 600;  // In meters, size of marker range used to find buildings to watch/sniper group / Default: 600;
    // Occupy:
        CSWR_destOccupyTakeabreak = [600, 1200, 2400];  // In seconds, how long each group can stay on its Occupy-markers / Default: [600, 1200, 2400]; (10min, 20min, 40min)
        CSWR_occupyMkrRange       = 200;                // In meters, size of marker range used to find buildings to occupy / Default: 200;

// Others:
    CSWR_isEditableByZeus = true;         // true = CSWR units and CSWR vehicles can be manipulated when Zeus is available / false = no editable / Default: true;
    //CSWR_reportToRadioAllies = false;   // WIP - true = player's allies units report important things on radio-chat to the leaders / false = silence / Default: false;
    //CSWR_spwnHeliOnShipFloor = 25;      // REWORKING - If needed, set how many meters above the sea leval is the ship floor where the spawn of helicopters will be.

// Server:
    CSWR_serverMaxFPS = 50.0;     // Be advised: extremely recommended do not change this value / Default; 50.0;
    CSWR_serverMinFPS = 20.0;     // Be advised: extremely recommended do not change this value / Default: 20.0;
    CSWR_wait = 1;                // If you need to make CSWR waits more for other scripts load first, set a delay in seconds / Default: 1;

    // ADVANCED SETTINGS:
        // What specific building positions must be ignored for all sides. Use getPosATL ([ [x1,y1,z1], [x2,y2,z2] ]) to exclude the position:
        CSWR_occupyIgnoredPositions = [  ];
        // What building classnames must be ignored for all sides (because are bugged or not offer some level of cover for units inside):
        // Important: this is case-sensitive, so be carefull with any typo!
        CSWR_occupyIgnoredBuildings = ["Land_Radar_01_cooler_F","Land_Pier_F","Land_Pier_small_F","Land_Lighhouse_small_F","Land_PowerPoleWooden_L_F","Land_LampStreet_small_F","Land_dp_smallTank_F","Land_LampHalogen_F","Land_LampDecor_F","Land_FuelStation_Feed_F","Land_spp_Transformer_F","Land_FuelStation_Build_F","Land_Addon_01_F","Land_u_Addon_01_V1_F","Land_Addon_03_F","Land_Shed_Big_F","Land_Shed_03_F","Land_Shed_05_F","Land_Track_01_bridge_F","Land_SCF_01_storageBin_small_F","Land_SCF_01_storageBin_medium_F","Land_StorageTank_01_small_F","Land_StorageTank_01_large_F","Land_Shop_City_04_F","Land_Shop_City_05_F","Land_Shop_City_06_F","Land_Shop_City_07_F","Land_Shop_Town_02_F","Land_Shop_Town_05_F","Land_FireEscape_01_tall_F","Land_FireEscape_01_short_F","Land_Offices_01_V1_F","Land_MultistoryBuilding_03_F","Land_MultistoryBuilding_04_F","Land_Hotel_02_F","Land_House_Big_05_F","Land_Workshop_04_F","Land_Church_01_F","Land_Church_01_V2_F","Land_Church_02_F","Land_ContainerLine_01_F","Land_ContainerLine_02_F","Land_ContainerLine_03_F","Land_Warehouse_02_F","Land_Warehouse_01_F","Land_Tents_Refugee_Red_lxWS","Land_Tents_Refugee_Green_lxWS","Land_Tents_Refugee_Orange_lxWS","Land_Tents_Refugee_lxWS","Land_Tents_Refugee_Pattern_lxWS","Land_Tents_Refugee_Blue_lxWS","Land_Tents_Refugee_Dirty_lxWS","Land_Tents_Refugee_DBrown_lxWS","Land_House_L_8_ruins_EP1_lxWS","Land_House_L_7_ruins_EP1_lxWS","Land_A_Mosque_small_2_ruins_EP1_lxWS","Land_House_L_1_ruins_EP1_lxWS","Land_House_L_9_ruins_EP1_lxWS","Land_House_K_1_ruins_EP1_lxWS","Land_House_L_3_ruins_EP1_lxWS","Land_tent_desert_03_lxws","Land_tent_desert_02_lxws","Land_tent_desert_01_lxws","Land_u_Shed_Ind_F","Land_House_Small_03_ruins_F","Land_spp_Transformer_ruins_F","Land_Addon_01_V1_ruins_F","Land_GH_Gazebo_ruins_F","Land_Shop_Town_02_ruins_F","Land_Radar_Small_ruins_F","Land_Windmill01_ruins_F","Land_Airport_01_hangar_F","Land_GarageShelter_01_ruins_F","Land_Chapel_V1_ruins_F","Land_SCF_01_feeder_lxWS","Land_Cargo_Patrol_V2_ruins_F","land_gm_euro_barracks_02_rubble","land_gm_euro_office_02_rubble","land_gm_euro_church_01_rubble","land_gm_euro_factory_01_01_rubble","land_gm_euro_farmhouse_03_rubble","land_gm_euro_farmhouse_01_rubble","land_gm_euro_house_04_e_rubble","land_gm_euro_factory_02_rubble","land_gm_euro_house_01_w_rubble","land_gm_euro_shop_02_e_rubble","land_gm_euro_mine_01_rubble","land_gm_euro_house_07_w_rubble","land_gm_euro_house_03_w_rubble"];
        // What ruins should be considered for occupy-movement (Important: if the ruin has no spots in its 3D, CSWR won't include it as option):
        // Important: this is case-sensitive, so be carefull with any typo!
        CSWR_occupyAcceptableRuins = ["Land_HouseRuin_Big_01_F","Land_HouseRuin_Big_01_half_F","Land_HouseRuin_Big_02_half_F","Land_HouseRuin_Big_02_F","Land_HouseRuin_Big_04_F","Land_OrthodoxChurch_03_ruins_F","Land_ControlTower_01_ruins_F","Land_ChurchRuin_01_F","Land_Shop_Town_01_ruins_F","Land_House_Big_01_V1_ruins_F","Land_BellTower_02_V2_ruins_F","Land_HouseRuin_Small_02_F","Land_HouseRuin_Small_04_F","Land_HouseRuin_Big_03_half_F","Land_HouseRuin_Big_03_F","Land_House_Small_01_b_brown_ruins_F","Land_House_Small_01_b_yellow_ruins_F","Land_Barn_01_grey_ruins_F","Land_Barn_01_brown_ruins_F","Land_Shop_02_b_yellow_ruins_F","Land_Shop_02_b_pink_ruins_F","Land_House_Big_02_b_brown_ruins_F","Land_House_Big_02_b_pink_ruins_F","Land_House_Big_02_b_blue_ruins_F","Land_House_Big_01_b_blue_ruins_F","Land_House_Big_01_b_brown_ruins_F","Land_House_Big_01_b_pink_ruins_F","Land_House_C_11_ruins_EP1_lxWS","Land_House_C_12_ruins_EP1_lxWS","Land_House_C_5_ruins_EP1_lxWS","Land_Factory_Main_ruins_F","Land_WIP_ruins_F","Land_Barracks_ruins_F","Land_House_Big_02_V1_ruins_F","Land_Cargo_HQ_V3_derelict_F","Land_Airport_Tower_ruins_F","Land_Stone_Shed_01_b_white_ruins_F","Land_House_Small_03_V1_ruins_F","land_gm_euro_house_05_e_rubble","land_gm_euro_house_08_e_rubble","land_gm_euro_house_12_w_rubble","land_gm_euro_church_02_rubble","land_gm_euro_house_02_e_rubble","land_gm_euro_house_13_e_rubble","land_gm_euro_office_03_rubble","land_gm_euro_house_09_w_rubble","land_gm_euro_house_02_w_rubble","land_gm_euro_house_12_e_rubble","land_gm_euro_pub_02_rubble","land_gm_euro_shed_04_rubble","land_gm_euro_house_08_w_rubble","land_gm_euro_office_01_rubble","land_gm_euro_house_06_e_rubble","land_gm_euro_house_11_w_rubble","land_gm_euro_house_13_w_rubble","land_gm_euro_house_10_e_rubble"];
        // Buildings that watcher groups can use when they are in urban position:
        // Important: this is case-sensitive, so be carefull with any typo!
        CSWR_acceptableTowersForWatch = ["Land_Cargo_Tower_V1_No1_F","Land_ControlTower_01_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V4_F","Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V3_ruins_F","Land_Cargo_Tower_V1_ruins_F","Land_Cargo_Tower_V2_ruins_F","Land_ControlTower_01_F","Land_Airport_01_controlTower_F","Land_GuardTower_01_F","Land_Airport_02_controlTower_F","Land_Airport_Tower_F","Land_ControlTower_02_F","Land_LightHouse_F","Land_Lighthouse_03_green_F","Land_Lighthouse_03_red_F","Land_Church_04_lightblue_F","Land_Church_04_lightblue_damaged_F","Land_Church_04_white_red_F","Land_Church_04_white_red_damaged_F","Land_Church_04_lightyellow_F","Land_Church_04_lightyellow_damaged_F","Land_Church_04_white_F","Land_Church_04_white_damaged_F","Land_Church_04_yellow_F","Land_Church_04_yellow_damaged_F","Land_Church_04_red_F","Land_Church_04_red_damaged_F","Land_cmp_Tower_F","Land_dp_smallTank_old_F","Land_SCF_01_chimney_F","Land_SCF_01_storageBin_big_F","Land_SCF_01_storageBin_small_F","Land_SCF_01_storageBin_medium_F","Land_Castle_01_tower_F","Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V4_F"];
        // What uniforms/outfits civilians can use if the editor uses "RANDOM" at fn_CSWR_loadout.sqf file. This is great when the editor wants take some control what kind of clothes civilians can use:
        // Important: this is case-sensitive, so be carefull with any typo!
        CSWR_civOutfits = ["U_C_Poor_1","U_C_Poloshirt_burgundy","U_C_Poloshirt_salmon","U_Competitor","U_C_HunterBody_grn","U_Marshal","U_Rangemaster","U_I_C_Soldier_Bandit_5_F","U_I_C_Soldier_Bandit_4_F","U_C_Man_casual_3_F","U_C_Man_casual_1_F","U_C_Man_casual_5_F","U_C_man_sport_3_F","U_C_Uniform_Farmer_01_F","U_I_L_Uniform_01_tshirt_black_F","U_C_Uniform_Scientist_02_formal_F","U_C_ConstructionCoverall_Red_F","U_C_ArtTShirt_01_v2_F","U_C_FormalSuit_01_gray_F","U_C_ArtTShirt_01_v6_F"];
		// These uniforms are for divers, and they shouldn't be given to other units via loadout editing. If you wish to use divers, use them via Population file, without having to edit their loadouts. Otherwise, units receiving these uniforms won't be able to exit the water properly:
		// Important: this is case-sensitive, so be carefull with any typo!
		CSWR_forbiddenMarineUniforms = ["U_B_Wetsuit","U_O_Wetsuit","U_I_Wetsuit","U_B_survival_uniform","EF_U_B_MarineCombatUniform_Diver_Des","EF_U_B_MarineCombatUniform_Diver_Wdl"];
		// Faces by region:
		// Important: this is case-sensitive, so be carefull with any typo!
		CSWR_facesAfrica = ["AfricanHead_01","AfricanHead_02","AfricanHead_03","AfricanHead_01_sick","AfricanHead_02_sick","AfricanHead_03_sick","CamoHead_African_01_F","CamoHead_African_02_F","CamoHead_African_03_F","TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_03","TanoanHead_A3_04","TanoanHead_A3_05","TanoanHead_A3_06","TanoanHead_A3_07","TanoanHead_A3_08","TanoanBossHead","TanoanHead_A3_01_sick","TanoanHead_A3_02_sick","TanoanHead_A3_03_sick","TanoanHead_A3_04_sick","TanoanHead_A3_05_sick","TanoanHead_A3_06_sick","TanoanHead_A3_07_sick","TanoanHead_A3_08_sick","TanoanHead_A3_09","TanoanBossHead_sick"];
		CSWR_facesAmericaNorth = ["WhiteHead_01","WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15","WhiteHead_16","WhiteHead_18","WhiteHead_19","WhiteHead_21","WhiteHead_22_a","WhiteHead_22_l","WhiteHead_22_sa","CamoHead_White_01_F","CamoHead_White_02_F","CamoHead_White_03_F","CamoHead_White_04_F","CamoHead_White_05_F","CamoHead_White_06_F","CamoHead_White_07_F","CamoHead_White_08_F","CamoHead_White_09_F","CamoHead_White_10_F","CamoHead_White_11_F","CamoHead_White_12_F","CamoHead_White_13_F","CamoHead_White_14_F","CamoHead_White_15_F","CamoHead_White_16_F","CamoHead_White_18_F","CamoHead_White_19_F","CamoHead_White_21_F","WhiteHead_23","WhiteHead_25","WhiteHead_26","WhiteHead_27","WhiteHead_28","WhiteHead_29","WhiteHead_30","WhiteHead_31","WhiteHead_32","WhiteHead_16_sick","WhiteHead_18_sick","WhiteHead_19_sick","WhiteHead_21_sick","AfricanHead_01","AfricanHead_02","AfricanHead_03","AfricanHead_01_sick","AfricanHead_02_sick","AfricanHead_03_sick","CamoHead_African_01_F","CamoHead_African_02_F","CamoHead_African_03_F","TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_03","TanoanHead_A3_04"];
		CSWR_facesAmericaSouth = ["WhiteHead_05","CamoHead_White_05_F","WhiteHead_11","CamoHead_White_11_F","WhiteHead_15","CamoHead_White_15_F","WhiteHead_16","WhiteHead_16_sick","CamoHead_White_16_F","WhiteHead_17","WhiteHead_17_sick","CamoHead_White_17_F","WhiteHead_22_a","TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_03","TanoanHead_A3_04","TanoanHead_A3_05","TanoanHead_A3_06","TanoanHead_A3_07","TanoanHead_A3_08","TanoanBossHead","TanoanHead_A3_01_sick","TanoanHead_A3_02_sick","TanoanHead_A3_03_sick","TanoanHead_A3_04_sick","TanoanHead_A3_05_sick","TanoanHead_A3_06_sick","TanoanHead_A3_07_sick","TanoanHead_A3_08_sick","TanoanHead_A3_09","TanoanBossHead_sick","WhiteHead_10","WhiteHead_14","CamoHead_White_14_F","CamoHead_Persian_01_F"];
		CSWR_facesAsia = ["AsianHead_A3_01","AsianHead_A3_02","AsianHead_A3_03","CamoHead_Asian_01_F","CamoHead_Asian_02_F","CamoHead_Asian_03_F","AsianHead_A3_04","AsianHead_A3_05","AsianHead_A3_06","AsianHead_A3_07","AsianHead_A3_01_sick","AsianHead_A3_02_sick","AsianHead_A3_03_sick","AsianHead_A3_04_sick","AsianHead_A3_05_sick","AsianHead_A3_06_sick","AsianHead_A3_07_sick"];
		CSWR_facesEurope = ["WhiteHead_06","CamoHead_White_06_F","WhiteHead_07","CamoHead_White_07_F","WhiteHead_08","CamoHead_White_08_F","WhiteHead_09","CamoHead_White_09_F","WhiteHead_11","CamoHead_White_11_F","WhiteHead_14","CamoHead_White_14_F","WhiteHead_15","CamoHead_White_15_F","WhiteHead_16","WhiteHead_16_sick","CamoHead_White_16_F","WhiteHead_17","WhiteHead_17_sick","CamoHead_White_17_F","WhiteHead_18","WhiteHead_18_sick","CamoHead_White_18_F","WhiteHead_19","WhiteHead_19_sick","CamoHead_White_19_F","WhiteHead_20","WhiteHead_20_sick","CamoHead_White_20_F","WhiteHead_22_sa","GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09","GreekHead_A3_10_a","GreekHead_A3_10_l","GreekHead_A3_10_sa","CamoHead_Greek_01_F","CamoHead_Greek_02_F","CamoHead_Greek_03_F","CamoHead_Greek_04_F","CamoHead_Greek_05_F","CamoHead_Greek_06_F","CamoHead_Greek_07_F","CamoHead_Greek_08_F","CamoHead_Greek_09_F","GreekHead_A3_11","GreekHead_A3_12","GreekHead_A3_13","GreekHead_A3_14","GreekHead_A3_01_sick","GreekHead_A3_02_sick","GreekHead_A3_03_sick","GreekHead_A3_04_sick","AfricanHead_01","AfricanHead_02"];
		CSWR_facesEuropeEast = ["WhiteHead_15","CamoHead_White_15_F","LivonianHead_1","LivonianHead_2","LivonianHead_3","LivonianHead_4","LivonianHead_5","LivonianHead_6","LivonianHead_7","LivonianHead_8","LivonianHead_9","LivonianHead_10","RussianHead_1","RussianHead_2","RussianHead_3","RussianHead_4","RussianHead_5","WhiteHead_24"];
		CSWR_facesMidEast = ["PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_04_a","PersianHead_A3_04_l","PersianHead_A3_04_sa","PersianHead_A3_01_sick","PersianHead_A3_02_sick","PersianHead_A3_03_sick","CamoHead_Persian_01_F","CamoHead_Persian_02_F","CamoHead_Persian_03_F"];
		// Languages:
		// Important: this is case-sensitive, so be carefull with any typo!
		CSWR_langChinese   = ["Male01CHI","Male02CHI","Male03CHI"];
		CSWR_langIranian   = ["Male01PER","Male02PER","Male03PER"];
		CSWR_langFrench    = ["Male01FRE","Male02FRE","Male03FRE","Male01ENGFRE","Male02ENGFRE"];
		CSWR_langGbEnglish = ["Male01ENGB","Male02ENGB","Male03ENGB","Male04ENGB","Male05ENGB"];
		CSWR_langPolish    = ["Male01POL","Male02POL","Male03POL"];
		CSWR_langRussian   = ["Male01RUS","Male02RUS","Male03RUS"];
		CSWR_langUsEnglish = ["Male01ENG","Male02ENG","Male03ENG","Male04ENG","Male05ENG","Male06ENG","Male07ENG","Male08ENG","Male09ENG","Male10ENG","Male11ENG","Male12ENG"];




















// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------
// When the mission starts:
[] spawn {
	// Local object declarations:
	private ["_helipad","_debugMkrWatch","_debugOccupyInters","_genericNVG","_genericFlashlight","_expOpts","_txt1","_txt2","_txt3","_txt4","_txt5","_txt6","_txt7","_txt8","_txt9","_confirmedMkrs","_allDestRestrictBLU","_allDestWatchBLU","_allDestOccupyBLU","_allDestHoldBLU","_allDestRestrictOPF","_allDestWatchOPF","_allDestOccupyOPF","_allDestHoldOPF","_allDestRestrictIND","_allDestWatchIND","_allDestOccupyIND","_allDestHoldIND","_allDestRestrictCIV","_allDestWatchCIV","_allDestOccupyCIV","_allDestHoldCIV","_allDestsBLU","_allDestsOPF","_allDestsIND","_allDestsCIV","_allDestPUBLIC","_spwnsAll","_allDestsSpecial"];
	
	// Initial values:
	CSWR_bookedLocHold     = [[],[],[],[]];  // [[blu],[opf],[ind],[civ]]
	CSWR_bookedLocSpwnVeh  = [[],[],[],[]];
	CSWR_bookedLocSpwnHeli = [[],[],[],[]];
	CSWR_spwnDelayQueueAmount = 0;  // debug proposes.
	_helipad=""; _hasRtbHeliBLU=[]; _hasRtbHeliOPF=[]; _hasRtbHeliIND=[]; _debugMkrWatch=""; _debugOccupyInters = [];
	// Declarations:
	CSWR_txtDebugHeader     = toUpper "CSWR DEBUG >";
	CSWR_txtWarnHeader      = toUpper "CSWR WARNING >";
	CSWR_prefix             = toUpper "CSWR";  // CAUTION: NEVER include/insert the CSWR_spacer character as part of the CSWR_prefix too.
	CSWR_spacer             = toUpper "_";  // CAUTION: try do not change it!
	CSWR_watchMkrRangeStart = 200;
	CSWR_vehGroundHeavy     = ["Tank","TrackedAPC","WheeledAPC"];
	_genericNVG             = "NVGoggles";
	_genericFlashlight      = "acc_flashlight";
	_expOpts                = ["R","V","E"];
	// Global escape:
	if !CSWR_isOn exitWith {publicVariable "CSWR_isOn"; publicVariable "CSWR_isOnDebug"; if CSWR_isOnDebug then {systemChat format ["%1 The %2 script was turned off manually through 'fn_CSWR_management.sqf' file.", CSWR_txtDebugHeader, CSWR_prefix]}};
	// Debug txts:
	_txt1="For good combat experince, don't use"; _txt2="value less than"; _txt3="out of debug mode. Minimal value"; _txt4="GEAR > NIGHTVISION > You turned the NVG usage 'true' for"; _txt5="side, but in parallel you're trying to force removal of"; _txt6="NVG's. Fix it in 'fn_CSWR_management.sqf' file. Generic NVG was applied."; _txt7="GEAR > FLASHLIGHT > You turned the Flashlight usage 'true' for"; _txt8="FLASHLIGHTS. Fix it in 'fn_CSWR_management.sqf' file. Generic Flashlight was applied."; _txt9="CANNOT be empty in 'fn_CSWR_management.sqf' file. Default value has been restored temporarily";
	// Main markers validation:
	if !(CSWR_spacer in ["_", "-"]) exitWith { CSWR_isOn = false; publicVariable "CSWR_isOn"; publicVariable "CSWR_isOnDebug"; systemChat format ["%1 You have changed the 'CSWR_spacer' and will broken some CSWR logic that I couldn't turn around yet. Please, consider to use one of these as spacer: _ or -", CSWR_txtWarnHeader]; systemChat format ["%1 The %2 stopped automatically!", CSWR_txtWarnHeader, CSWR_prefix]};
	_confirmedMkrs = [CSWR_prefix, CSWR_spacer] call THY_fnc_CSWR_marker_scanner;
	// Escape > If no confirmed markers, abort:
	if ( count _confirmedMkrs isEqualTo 0 ) exitWith {
		// Redefining the CSWR state:
		CSWR_isOn = false;
		// Update globals (CAUTION, it's needed in case CSWR is turned off automatically):
		publicVariable "CSWR_isOn"; publicVariable "CSWR_isOnDebug";
		// Warning message:
		systemChat format ["%1 The %2 stopped automatically!", CSWR_txtWarnHeader, CSWR_prefix];
	};
	// Errors handling:
	if ( CSWR_wait < 1 ) then { CSWR_wait = 1 };  // Important to hold some functions and make their warning (if has) to show only in-game for mission editor.
	if CSWR_isOnDebug then {
		if ( CSWR_wait >= 5 ) then { systemChat format ["%1 Don't forget the CSWR is configurated to delay %2 seconds before to starts its tasks.", CSWR_txtDebugHeader, CSWR_wait] };
		_debugOccupyInters = CSWR_occupyIgnoredBuildings arrayIntersect CSWR_occupyAcceptableRuins;
		if ( count _debugOccupyInters > 0 ) then {
			systemChat format ["%1 OCCUPY > The follow asset's listed as 'Ignored Buildings' and 'Acceptable Ruins' at the same time in 'fn_CSWR_management.sqf'. Fix them: %2", CSWR_txtWarnHeader, str _debugOccupyInters] };
			{ CSWR_occupyAcceptableRuins deleteAt (CSWR_occupyAcceptableRuins find _x) } forEach _debugOccupyInters;
	} else {
		if ( CSWR_destOccupyTakeabreak # 0 < 300 || CSWR_destOccupyTakeabreak # 1 < 600 || CSWR_destOccupyTakeabreak # 2 < 1200 ) then { CSWR_destOccupyTakeabreak=[600,1200,2400]; systemChat format ["%1 OCCUPY > %5 'CSWR_destOccupyTakeabreak' %6 [%2 secs, %3 secs, %4 secs] %7s have been applied.", CSWR_txtWarnHeader, CSWR_destOccupyTakeabreak # 0, CSWR_destOccupyTakeabreak # 1, CSWR_destOccupyTakeabreak # 2, _txt1, _txt2, _txt3] }; if ( CSWR_destHoldTakeabreak # 0 < 900 || CSWR_destHoldTakeabreak # 1 < 1800 || CSWR_destHoldTakeabreak # 2 < 3600 ) then { CSWR_destHoldTakeabreak=[1800,3600,7200]; systemChat format ["%1 HOLD > %5 'CSWR_destHoldTakeabreak' %6 [%2 secs, %3 secs, %4 secs] %7s have been applied.", CSWR_txtWarnHeader, CSWR_destHoldTakeabreak # 0, CSWR_destHoldTakeabreak # 1, CSWR_destHoldTakeabreak # 2, _txt1, _txt2, _txt3] }; if ( CSWR_watchMkrRange < (CSWR_watchMkrRangeStart + 50) ) then { CSWR_watchMkrRange=(CSWR_watchMkrRangeStart + 50); systemChat format ["%1 WATCH > %3 'CSWR_watchMkrRange' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_watchMkrRange, _txt1, _txt2, _txt3] };
		if ( CSWR_watchMkrRange > 900 ) then { CSWR_watchMkrRange=900; systemChat format ["%1 WATCH > %3 'CSWR_watchMkrRange' bigger than %2 meters out of debug mode. %2 has been applied.", CSWR_txtWarnHeader, CSWR_watchMkrRange, _txt1] }; if ( CSWR_occupyMkrRange < 100 ) then { CSWR_occupyMkrRange=100; systemChat format ["%1 OCCUPY > %3 'CSWR_occupyMkrRange' %4 %2 %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_occupyMkrRange, _txt1, _txt2, _txt3] }; if ( CSWR_spwnsParadropUnitAlt < 500 ) then { CSWR_spwnsParadropUnitAlt=500; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParadropUnitAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParadropUnitAlt, _txt1, _txt2, _txt3] }; if ( CSWR_spwnsParadropWaiting < 5 || CSWR_spwnsParadropWaiting > 60 ) then { CSWR_spwnsParadropWaiting=5; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParadropWaiting' %4 %2 minutes %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParadropWaiting, _txt1, _txt2, _txt3] }; if ( CSWR_spwnsParadropVehAlt < 200 ) then { CSWR_spwnsParadropVehAlt=200; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParadropVehAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParadropVehAlt, _txt1, _txt2, _txt3] }; if ( CSWR_spwnsParadropSpreading < 200 ) then { CSWR_spwnsParadropSpreading=200; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParadropSpreading' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParadropSpreading, _txt1, _txt2, _txt3] }; if (CSWR_heliLightAlt < 150 ) then { CSWR_heliLightAlt=150; systemChat format ["%1 HELICOPTER > %3 'CSWR_heliLightAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_heliLightAlt, _txt1, _txt2, _txt3] }; if (CSWR_heliHeavyAlt < CSWR_heliLightAlt+150 ) then { CSWR_heliHeavyAlt=CSWR_heliLightAlt+150; systemChat format ["%1 HELICOPTER > %3 'CSWR_heliHeavyAlt' %4 100 meters of altitude higher than 'CSWR_heliLightAlt' %5 (%2) for this case has been applied.", CSWR_txtWarnHeader, CSWR_heliHeavyAlt, _txt1, _txt2, _txt3] };
	};
	if CSWR_isOnBLU then {
		if ( CSWR_canNvgInfantryBLU || CSWR_canNvgParatroopsBLU || CSWR_canNvgSnipersBLU ) then { if ( CSWR_nvgDeviceBLU isEqualTo "" || CSWR_nvgDeviceBLU == "REMOVED" ) then { systemChat format ["%1 %2 BLU %3 BLU %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceBLU = _genericNVG } else { ["BLU","CfgWeapons","NightVision","CSWR_nvgDeviceBLU", [CSWR_nvgDeviceBLU]] call THY_fnc_CSWR_is_valid_classname } }; if CSWR_canFlashlightBLU then { if ( CSWR_flashlightDeviceBLU isEqualTo "" || CSWR_flashlightDeviceBLU == "REMOVED" ) then { systemChat format ["%1 %2 BLU %3 BLU %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceBLU = _genericFlashlight } else { ["BLU","CfgWeapons","Flashlight","CSWR_flashlightDeviceBLU", [CSWR_flashlightDeviceBLU]] call THY_fnc_CSWR_is_valid_classname } };
		if ( CSWR_watcherAccuranceBLU isEqualTo "" ) then { systemChat format ["%1 WATCH > 'CSWR_watcherAccuranceBLU' %2.", CSWR_txtWarnHeader, _txt9]; CSWR_watcherAccuranceBLU="V"};
		CSWR_facesFromRegionBLU = toUpper CSWR_facesFromRegionBLU;  // Don't change the position of it coz it's still a string, not array yet.
		CSWR_languageBLU = toUpper CSWR_languageBLU;
		switch CSWR_languageBLU do {
			case "CHINESE":   { CSWR_languageBLU = CSWR_langChinese };
			case "IRANIAN":   { CSWR_languageBLU = CSWR_langIranian };
			case "FRENCH":    { CSWR_languageBLU = CSWR_langFrench };
			case "GBENGLISH": { CSWR_languageBLU = CSWR_langGbEnglish };
			case "POLISH":    { CSWR_languageBLU = CSWR_langPolish };
			case "RUSSIAN":   { CSWR_languageBLU = CSWR_langRussian };
			case "USENGLISH": { CSWR_languageBLU = CSWR_langUsEnglish };
			default { CSWR_languageBLU = ["BLU", CSWR_languageBLU, CSWR_facesFromRegionBLU] call THY_fnc_CSWR_language_default };
		};
		switch CSWR_facesFromRegionBLU do {
			case "ASIA":         { CSWR_facesFromRegionBLU = CSWR_facesAsia };
			case "AFRICA":       { CSWR_facesFromRegionBLU = CSWR_facesAfrica };
			case "EUROPE":       { CSWR_facesFromRegionBLU = CSWR_facesEurope };
			case "EASTEUROPE":   { CSWR_facesFromRegionBLU = CSWR_facesEuropeEast };
			case "MIDEAST":      { CSWR_facesFromRegionBLU = CSWR_facesMidEast };
			case "NORTHAMERICA": { CSWR_facesFromRegionBLU = CSWR_facesAmericaNorth };
			case "SOUTHAMERICA": { CSWR_facesFromRegionBLU = CSWR_facesAmericaSouth };
			default {
				if ( CSWR_facesFromRegionBLU isNotEqualTo "" ) then {
					systemChat format ["%1 REGION FACES > The %2 side's using a UNKNOWN region ('%3'). Fix it using one of those options in 'fn_CSWR_management.sqf' file.",
					CSWR_txtWarnHeader, "BLU", CSWR_facesFromRegionBLU];
				};
				CSWR_facesFromRegionBLU = [];
			};
		};
	};
	if CSWR_isOnOPF then {
		if ( CSWR_canNvgInfantryOPF || CSWR_canNvgParatroopsOPF || CSWR_canNvgSnipersOPF ) then { if ( CSWR_nvgDeviceOPF isEqualTo "" || CSWR_nvgDeviceOPF == "REMOVED" ) then { systemChat format ["%1 %2 OPF %3 OPF %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceOPF = _genericNVG } else { ["OPF","CfgWeapons","NightVision","CSWR_nvgDeviceOPF", [CSWR_nvgDeviceOPF]] call THY_fnc_CSWR_is_valid_classname } };
		if CSWR_canFlashlightOPF then { if ( CSWR_flashlightDeviceOPF isEqualTo "" || CSWR_flashlightDeviceOPF == "REMOVED" ) then { systemChat format ["%1 %2 OPF %3 OPF %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceOPF = _genericFlashlight } else { ["OPF","CfgWeapons","Flashlight","CSWR_flashlightDeviceOPF", [CSWR_flashlightDeviceOPF]] call THY_fnc_CSWR_is_valid_classname } };
		if ( CSWR_watcherAccuranceOPF isEqualTo "" ) then { systemChat format ["%1 WATCH > 'CSWR_watcherAccuranceOPF' %2.", CSWR_txtWarnHeader, _txt9]; CSWR_watcherAccuranceOPF="V"};
		CSWR_facesFromRegionOPF = toUpper CSWR_facesFromRegionOPF;  // Don't change the position of it coz it's still a string, not array yet.
		CSWR_languageOPF = toUpper CSWR_languageOPF;
		switch CSWR_languageOPF do {
			case "CHINESE":   { CSWR_languageOPF = CSWR_langChinese };
			case "IRANIAN":   { CSWR_languageOPF = CSWR_langIranian };
			case "FRENCH":    { CSWR_languageOPF = CSWR_langFrench };
			case "GBENGLISH": { CSWR_languageOPF = CSWR_langGbEnglish };
			case "POLISH":    { CSWR_languageOPF = CSWR_langPolish };
			case "RUSSIAN":   { CSWR_languageOPF = CSWR_langRussian };
			case "USENGLISH": { CSWR_languageOPF = CSWR_langUsEnglish };
			default { CSWR_languageOPF = ["OPF", CSWR_languageOPF, CSWR_facesFromRegionOPF] call THY_fnc_CSWR_language_default };
		};
		switch CSWR_facesFromRegionOPF do {
			case "ASIA":         { CSWR_facesFromRegionOPF = CSWR_facesAsia };
			case "AFRICA":       { CSWR_facesFromRegionOPF = CSWR_facesAfrica };
			case "EUROPE":       { CSWR_facesFromRegionOPF = CSWR_facesEurope };
			case "EASTEUROPE":   { CSWR_facesFromRegionOPF = CSWR_facesEuropeEast };
			case "MIDEAST":      { CSWR_facesFromRegionOPF = CSWR_facesMidEast };
			case "NORTHAMERICA": { CSWR_facesFromRegionOPF = CSWR_facesAmericaNorth };
			case "SOUTHAMERICA": { CSWR_facesFromRegionOPF = CSWR_facesAmericaSouth };
			default {
				if ( CSWR_facesFromRegionOPF isNotEqualTo "" ) then {
					systemChat format ["%1 REGION FACES > The %2 side's using a UNKNOWN region ('%3'). Fix it using one of those options in 'fn_CSWR_management.sqf' file.",
					CSWR_txtWarnHeader, "OPF", CSWR_facesFromRegionOPF];
				};
				CSWR_facesFromRegionOPF = [];
			};
		};
	};
	if CSWR_isOnIND then {
		if ( CSWR_canNvgInfantryIND || CSWR_canNvgParatroopsIND || CSWR_canNvgSnipersIND ) then { if ( CSWR_nvgDeviceIND isEqualTo "" || CSWR_nvgDeviceIND == "REMOVED" ) then { systemChat format ["%1 %2 IND %3 IND %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceIND = _genericNVG } else { ["IND","CfgWeapons","NightVision","CSWR_nvgDeviceIND", [CSWR_nvgDeviceIND]] call THY_fnc_CSWR_is_valid_classname } };
		if CSWR_canFlashlightIND then { if ( CSWR_flashlightDeviceIND isEqualTo "" || CSWR_flashlightDeviceIND == "REMOVED" ) then { systemChat format ["%1 %2 IND %3 IND %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceIND = _genericFlashlight } else { ["IND","CfgWeapons","Flashlight","CSWR_flashlightDeviceIND", [CSWR_flashlightDeviceIND]] call THY_fnc_CSWR_is_valid_classname } };
		if ( CSWR_watcherAccuranceIND isEqualTo "" ) then { systemChat format ["%1 WATCH > 'CSWR_watcherAccuranceIND' %2.", CSWR_txtWarnHeader, _txt9]; CSWR_watcherAccuranceIND="V"};
		CSWR_facesFromRegionIND = toUpper CSWR_facesFromRegionIND;  // Don't change the position of it coz it's still a string, not array yet.
		CSWR_languageIND = toUpper CSWR_languageIND;
		switch CSWR_languageIND do {
			case "CHINESE":   { CSWR_languageIND = CSWR_langChinese };
			case "IRANIAN":   { CSWR_languageIND = CSWR_langIranian };
			case "FRENCH":    { CSWR_languageIND = CSWR_langFrench };
			case "GBENGLISH": { CSWR_languageIND = CSWR_langGbEnglish };
			case "POLISH":    { CSWR_languageIND = CSWR_langPolish };
			case "RUSSIAN":   { CSWR_languageIND = CSWR_langRussian };
			case "USENGLISH": { CSWR_languageIND = CSWR_langUsEnglish };
			default { CSWR_languageIND = ["IND", CSWR_languageIND, CSWR_facesFromRegionIND] call THY_fnc_CSWR_language_default };
		};
		switch CSWR_facesFromRegionIND do {
			case "ASIA":         { CSWR_facesFromRegionIND = CSWR_facesAsia };
			case "AFRICA":       { CSWR_facesFromRegionIND = CSWR_facesAfrica };
			case "EUROPE":       { CSWR_facesFromRegionIND = CSWR_facesEurope };
			case "EASTEUROPE":   { CSWR_facesFromRegionIND = CSWR_facesEuropeEast };
			case "MIDEAST":      { CSWR_facesFromRegionIND = CSWR_facesMidEast };
			case "NORTHAMERICA": { CSWR_facesFromRegionIND = CSWR_facesAmericaNorth };
			case "SOUTHAMERICA": { CSWR_facesFromRegionIND = CSWR_facesAmericaSouth };
			default {
				if ( CSWR_facesFromRegionIND isNotEqualTo "" ) then {
					systemChat format ["%1 REGION FACES > The %2 side's using a UNKNOWN region ('%3'). Fix it using one of those options in 'fn_CSWR_management.sqf' file.",
					CSWR_txtWarnHeader, "IND", CSWR_facesFromRegionIND];
				};
				CSWR_facesFromRegionIND = [];
			};
		};
	};
	if CSWR_isOnCIV then {
		if CSWR_canNvgCIV then { if ( CSWR_nvgDeviceCIV isEqualTo "" || CSWR_nvgDeviceCIV == "REMOVED" ) then { systemChat format ["%1 %2 CIV %3 CIV %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceCIV = _genericNVG } else { ["CIV","CfgWeapons","NightVision","CSWR_nvgDeviceCIV", [CSWR_nvgDeviceCIV]] call THY_fnc_CSWR_is_valid_classname }};
		CSWR_facesFromRegionCIV = toUpper CSWR_facesFromRegionCIV;  // Don't change the position of it coz it's still a string, not array yet.
		CSWR_languageCIV = toUpper CSWR_languageCIV;
		switch CSWR_languageCIV do {
			case "CHINESE":   { CSWR_languageCIV = CSWR_langChinese };
			case "IRANIAN":   { CSWR_languageCIV = CSWR_langIranian };
			case "FRENCH":    { CSWR_languageCIV = CSWR_langFrench };
			case "GBENGLISH": { CSWR_languageCIV = CSWR_langGbEnglish };
			case "POLISH":    { CSWR_languageCIV = CSWR_langPolish };
			case "RUSSIAN":   { CSWR_languageCIV = CSWR_langRussian };
			case "USENGLISH": { CSWR_languageCIV = CSWR_langUsEnglish };
			default { CSWR_languageCIV = ["CIV", CSWR_languageCIV, CSWR_facesFromRegionCIV] call THY_fnc_CSWR_language_default };
		};
		switch CSWR_facesFromRegionCIV do {
			case "ASIA":         { CSWR_facesFromRegionCIV = CSWR_facesAsia };
			case "AFRICA":       { CSWR_facesFromRegionCIV = CSWR_facesAfrica };
			case "EUROPE":       { CSWR_facesFromRegionCIV = CSWR_facesEurope };
			case "EASTEUROPE":   { CSWR_facesFromRegionCIV = CSWR_facesEuropeEast };
			case "MIDEAST":      { CSWR_facesFromRegionCIV = CSWR_facesMidEast };
			case "NORTHAMERICA": { CSWR_facesFromRegionCIV = CSWR_facesAmericaNorth };
			case "SOUTHAMERICA": { CSWR_facesFromRegionCIV = CSWR_facesAmericaSouth };
			default {
				if ( CSWR_facesFromRegionCIV isNotEqualTo "" ) then {
					systemChat format ["%1 REGION FACES > The %2 side's using a UNKNOWN region ('%3'). Fix it using one of those options in 'fn_CSWR_management.sqf' file.",
					CSWR_txtWarnHeader, "CIV", CSWR_facesFromRegionCIV];
				};
				CSWR_facesFromRegionCIV = [];
			};
		};
	};
	if ( !(toUpper CSWR_watcherAccuranceBLU in _expOpts) || !(toUpper CSWR_watcherAccuranceOPF in _expOpts) || !(toUpper CSWR_watcherAccuranceIND in _expOpts) ) then {
		systemChat format ["%1 WATCH > 'CSWR_watcherAccuranceBLU' or 'CSWR_watcherAccuranceOPF' or 'CSWR_watcherAccuranceIND' in 'fn_CSWR_management.sqf' file accepts only these letters: %2. Default values have been restored temporarily.", CSWR_txtWarnHeader, str _expOpts]; CSWR_watcherAccuranceBLU="V"; CSWR_watcherAccuranceOPF="V"; CSWR_watcherAccuranceIND="V";
	};
	//CSWR_spwnHeliOnShipFloor = abs CSWR_spwnHeliOnShipFloor;
	
	// SPAWNPOINTS:
	// Where each side in-game will spawn randomly and what group's type is allowed to do that.
	/*
	Structure of spawn arrays: _confirmedMkrs
	[0 spawn types
		[0 blu
			[0 CSWR_spawnsForPeopleBLU
				[0 CSWR_spwnsLandBLU],
				[1 CSWR_spwnsWaterBLU]
			],
			[1 CSWR_spawnsForVehicleBLU
				[0 CSWR_spwnsVehLandBLU],
				[1 CSWR_spwnsVehWaterBLU]
			],
			[2 CSWR_spawnsForHelicopterBLU
				[0 CSWR_spwnsHeliLandBLU],
				[1 CSWR_spwnsHeliWaterBLU]
			],
			[3 CSWR_spawnsParadropBLU
				[0 CSWR_spwnsParaAirBLU],
				[1 CSWR_spwnsParaUselessBLU]
			]
		],
		[1 opf
			[0 CSWR_spawnsForPeopleOPF
				[0 CSWR_spwnsLandOPF],
				[1 CSWR_spwnsWaterOPF]
			],
			[1 CSWR_spawnsForVehicleOPF
				[0 CSWR_spwnsVehLandOPF],
				[1 CSWR_spwnsVehWaterOPF]
			],
			[2 CSWR_spawnsForHelicopterOPF
				[0 CSWR_spwnsHeliLandOPF],
				[1 CSWR_spwnsHeliWaterOPF]
			],
			[3 CSWR_spawnsParadropOPF
				[0 CSWR_spwnsParaAirOPF],
				[1 CSWR_spwnsParaUselessOPF]
			]
		],
		[2 ind
			[0 CSWR_spawnsForPeopleIND
				[0 CSWR_spwnsLandIND],
				[1 CSWR_spwnsWaterIND]
			],
			[1 CSWR_spawnsForVehicleIND
				[0 CSWR_spwnsVehLandIND],
				[1 CSWR_spwnsVehWaterIND]
			],
			[2 CSWR_spawnsForHelicopterIND
				[0 CSWR_spwnsHeliLandIND],
				[1 CSWR_spwnsHeliWaterIND]
			],
			[3 CSWR_spawnsParadropIND
				[0 CSWR_spwnsParaAirIND],
				[1 CSWR_spwnsParaUselessIND]
			]
		],
		[3 civ
			[0 CSWR_spawnsForPeopleCIV
				[0 CSWR_spwnsLandCIV],
				[1 CSWR_spwnsWaterCIV]
			],
			[1 CSWR_spawnsForVehicleCIV
				[0 CSWR_spwnsVehLandCIV],
				[1 CSWR_spwnsVehWaterCIV]
			],
			[2 CSWR_spawnsForHelicopterCIV
				[0 CSWR_spwnsHeliLandCIV],
				[1 CSWR_spwnsHeliWaterCIV]
			],
			[3 CSWR_spawnsParadropCIV
				[0 CSWR_spwnsParaAirCIV],
				[1 CSWR_spwnsParaUselessCIV]
			]
		]
	],
	[1 destination types
		...
	];
	*/
	// BluFor spawns:
	CSWR_spawnsForPeopleBLU     = ((_confirmedMkrs # 0) # 0) # 0;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsLandBLU           = CSWR_spawnsForPeopleBLU # 0;
	CSWR_spwnsWaterBLU          = CSWR_spawnsForPeopleBLU # 1;
	CSWR_spawnsForVehicleBLU    = ((_confirmedMkrs # 0) # 0) # 1;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsVehLandBLU        = CSWR_spawnsForVehicleBLU # 0;
	CSWR_spwnsVehWaterBLU       = CSWR_spawnsForVehicleBLU # 1;
	CSWR_spawnsForHelicopterBLU = ((_confirmedMkrs # 0) # 0) # 2;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsHeliLandBLU       = CSWR_spawnsForHelicopterBLU # 0;
	CSWR_spwnsHeliWaterBLU      = CSWR_spawnsForHelicopterBLU # 1;
	CSWR_spawnsParadropBLU      = ((_confirmedMkrs # 0) # 0) # 3;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsParaAirBLU        = CSWR_spawnsParadropBLU # 0;
	//CSWR_spwnsParaUselessBLU  = CSWR_spawnsParadropBLU # 1;
	CSWR_spwnsAllBLU = CSWR_spwnsLandBLU + CSWR_spwnsWaterBLU + CSWR_spwnsVehLandBLU + CSWR_spwnsVehWaterBLU + CSWR_spwnsHeliLandBLU + CSWR_spwnsHeliWaterBLU + CSWR_spwnsParaAirBLU;  // Used in fn_CSWR_population.sqf

	// OpFor spawns:
	CSWR_spawnsForPeopleOPF     = ((_confirmedMkrs # 0) # 1) # 0;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsLandOPF           = CSWR_spawnsForPeopleOPF # 0;
	CSWR_spwnsWaterOPF          = CSWR_spawnsForPeopleOPF # 1;
	CSWR_spawnsForVehicleOPF    = ((_confirmedMkrs # 0) # 1) # 1;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsVehLandOPF        = CSWR_spawnsForVehicleOPF # 0;
	CSWR_spwnsVehWaterOPF       = CSWR_spawnsForVehicleOPF # 1;
	CSWR_spawnsForHelicopterOPF = ((_confirmedMkrs # 0) # 1) # 2;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsHeliLandOPF       = CSWR_spawnsForHelicopterOPF # 0;
	CSWR_spwnsHeliWaterOPF      = CSWR_spawnsForHelicopterOPF # 1;
	CSWR_spawnsParadropOPF      = ((_confirmedMkrs # 0) # 1) # 3;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsParaAirOPF        = CSWR_spawnsParadropOPF # 0;
	//CSWR_spwnsParaUselessOPF  = CSWR_spawnsParadropOPF # 1;
	CSWR_spwnsAllOPF = CSWR_spwnsLandOPF + CSWR_spwnsWaterOPF + CSWR_spwnsVehLandOPF + CSWR_spwnsVehWaterOPF + CSWR_spwnsHeliLandOPF + CSWR_spwnsHeliWaterOPF + CSWR_spwnsParaAirOPF;  // Used in fn_CSWR_population.sqf
	
	// Independent spawns:
	CSWR_spawnsForPeopleIND     = ((_confirmedMkrs # 0) # 2) # 0;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsLandIND           = CSWR_spawnsForPeopleIND # 0;
	CSWR_spwnsWaterIND          = CSWR_spawnsForPeopleIND # 1;
	CSWR_spawnsForVehicleIND    = ((_confirmedMkrs # 0) # 2) # 1;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsVehLandIND        = CSWR_spawnsForVehicleIND # 0;
	CSWR_spwnsVehWaterIND       = CSWR_spawnsForVehicleIND # 1;
	CSWR_spawnsForHelicopterIND = ((_confirmedMkrs # 0) # 2) # 2;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsHeliLandIND       = CSWR_spawnsForHelicopterIND # 0;
	CSWR_spwnsHeliWaterIND      = CSWR_spawnsForHelicopterIND # 1;
	CSWR_spawnsParadropIND      = ((_confirmedMkrs # 0) # 2) # 3;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsParaAirIND        = CSWR_spawnsParadropIND # 0;
	//CSWR_spwnsParaUselessIND  = CSWR_spawnsParadropIND # 1;
	CSWR_spwnsAllIND = CSWR_spwnsLandIND + CSWR_spwnsWaterIND + CSWR_spwnsVehLandIND + CSWR_spwnsVehWaterIND + CSWR_spwnsHeliLandIND + CSWR_spwnsHeliWaterIND + CSWR_spwnsParaAirIND;  // Used in fn_CSWR_population.sqf
	
	// Civilian spawns:
	CSWR_spawnsForPeopleCIV     = ((_confirmedMkrs # 0) # 3) # 0;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsLandCIV           = CSWR_spawnsForPeopleCIV # 0;
	CSWR_spwnsWaterCIV          = CSWR_spawnsForPeopleCIV # 1;
	CSWR_spawnsForVehicleCIV    = ((_confirmedMkrs # 0) # 3) # 1;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsVehLandCIV        = CSWR_spawnsForVehicleCIV # 0;
	CSWR_spwnsVehWaterCIV       = CSWR_spawnsForVehicleCIV # 1;
	CSWR_spawnsForHelicopterCIV = ((_confirmedMkrs # 0) # 3) # 2;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsHeliLandCIV       = CSWR_spawnsForHelicopterCIV # 0;
	CSWR_spwnsHeliWaterCIV      = CSWR_spawnsForHelicopterCIV # 1;
	CSWR_spawnsParadropCIV      = ((_confirmedMkrs # 0) # 3) # 3;  // Used in fn_CSWR_population.sqf
	CSWR_spwnsParaAirCIV        = CSWR_spawnsParadropCIV # 0;
	//CSWR_spwnsParaUselessCIV  = CSWR_spawnsParadropCIV # 1;
	CSWR_spwnsAllCIV = CSWR_spwnsLandCIV + CSWR_spwnsWaterCIV + CSWR_spwnsVehLandCIV + CSWR_spwnsVehWaterCIV + CSWR_spwnsHeliLandCIV + CSWR_spwnsHeliWaterCIV + CSWR_spwnsParaAirCIV;  // Used in fn_CSWR_population.sqf
	// All spawns:
	_spwnsAll = CSWR_spwnsAllBLU + CSWR_spwnsAllOPF + CSWR_spwnsAllIND + CSWR_spwnsAllCIV;
	// Group-types allowed to spawn through each Spawn-type:
	CSWR_groupTypesForSpwns            = ["teamL","teamM","teamH","teamC1","teamC2","teamC3","teamS"];
	CSWR_groupTypesForSpwnsVehGround   = ["vehL","vehM","vehH","vehC1","vehC2","vehC3"];
	CSWR_groupTypesForSpwnsVehNautical = ["nauL","nauM","nauH"];
	CSWR_groupTypesForSpwnsVehAirHeli  = ["heliL","heliH"];
	CSWR_groupTypesForSpwnsPara        = CSWR_groupTypesForSpwns + CSWR_groupTypesForSpwnsVehGround;
	// Spawn special actions > building helipad:
	if CSWR_shouldAddHelipadSpwn then { _helipad="Land_HelipadSquare_F" } else { _helipad="Land_HelipadEmpty_F" };
	{ _helipad createVehicle (markerPos _x) } forEach CSWR_spwnsHeliLandBLU + CSWR_spwnsHeliLandOPF + CSWR_spwnsHeliLandIND + CSWR_spwnsHeliLandCIV;
	// Check the availability of the RTB service:
	CSWR_hasRtbHeli = [CSWR_spwnsHeliLandBLU isNotEqualTo [], CSWR_spwnsHeliLandOPF isNotEqualTo [], CSWR_spwnsHeliLandIND isNotEqualTo [], false];  // [blu,opf,ind,civ]  // CIV doesn't use this.
	
	// DESTINATION:
	// Where each side in-game will move randomly.
	/*
	Structure of destination arrays: _confirmedMkrs
	[0 spawn types
		...
	],
	[1 destination types
		[0 blu
			[0 CSWR_destRestrictBLU
				[0 Land],
				[1 Water]
			],
			[1 CSWR_destWatchBLU
				[0 Land],
				[1 Water]            // USELESS!
			],
			[2 CSWR_destOccupyBLU
				[0 Land],
				[1 Water]            // USELESS!
			],
			[3 CSWR_destHoldBLU
				[0 Land],
				[1 Water]            // USELESS!
			]
		],
		[1 opf
			[0 CSWR_destRestrictOPF
				[0 Land],
				[1 Water]
			],
			[1 CSWR_destWatchOPF
				[0 Land],
				[1 Water]            // USELESS!
			],
			[2 CSWR_destOccupyOPF
				[0 Land],
				[1 Water]            // USELESS!
			],
			[3 CSWR_destHoldOPF
				[0 Land],
				[1 Water]            // USELESS!
			]
		],
		[2 ind
			[0 CSWR_destRestrictIND
				[0 Land],
				[1 Water]
			],
			[1 CSWR_destWatchIND
				[0 Land],
				[1 Water]            // USELESS!
			],
			[2 CSWR_destOccupyIND
				[0 Land],
				[1 Water]            // USELESS!
			],
			[3 CSWR_destHoldIND
				[0 Land],
				[1 Water]            // USELESS!
			]
		],
		[3 civ
			[0 CSWR_destRestrictCIV                         // USELESS!
				[0 Land],
				[1 Water]       // USELESS!
			],
			[1 CSWR_destWatchCIV       // USELESS!
				[0 Land],
				[1 Water]            // USELESS!
			],
			[2 CSWR_destOccupyCIV
				[0 Land],
				[1 Water]            // USELESS!
			],
			[3 CSWR_destHoldCIV
				[0 Land],
				[1 Water]            // USELESS!
			]
		],
		[4 public
			[0 CSWR_destsPUBLIC
				[0 Land],
				[1 Water]
			]
		]
	];
	*/
	// BluFor destinations:
	CSWR_destRestrictBLU = ((_confirmedMkrs # 1) # 0) # 0;
	CSWR_destWatchBLU    = ((_confirmedMkrs # 1) # 0) # 1;
	CSWR_destOccupyBLU   = ((_confirmedMkrs # 1) # 0) # 2;
	CSWR_destHoldBLU     = ((_confirmedMkrs # 1) # 0) # 3;
	_allDestRestrictBLU  = (CSWR_destRestrictBLU # 0) + (CSWR_destRestrictBLU # 1);
	_allDestWatchBLU     = (CSWR_destWatchBLU # 0) + (CSWR_destWatchBLU # 1);
	_allDestOccupyBLU    = (CSWR_destOccupyBLU # 0) + (CSWR_destOccupyBLU # 1);
	_allDestHoldBLU      = (CSWR_destHoldBLU # 0) + (CSWR_destHoldBLU # 1);
	_allDestsBLU         = _allDestRestrictBLU + _allDestWatchBLU + _allDestOccupyBLU + _allDestHoldBLU;  // NEVER include PUBLICs in this calc!
	
	// OpFor destinations:
	CSWR_destRestrictOPF = ((_confirmedMkrs # 1) # 1) # 0;
	CSWR_destWatchOPF    = ((_confirmedMkrs # 1) # 1) # 1;
	CSWR_destOccupyOPF   = ((_confirmedMkrs # 1) # 1) # 2;
	CSWR_destHoldOPF     = ((_confirmedMkrs # 1) # 1) # 3;
	_allDestRestrictOPF  = (CSWR_destRestrictOPF # 0) + (CSWR_destRestrictOPF # 1);
	_allDestWatchOPF     = (CSWR_destWatchOPF # 0) + (CSWR_destWatchOPF # 1);
	_allDestOccupyOPF    = (CSWR_destOccupyOPF # 0) + (CSWR_destOccupyOPF # 1);
	_allDestHoldOPF      = (CSWR_destHoldOPF # 0) + (CSWR_destHoldOPF # 1);
	_allDestsOPF         = _allDestRestrictOPF + _allDestWatchOPF + _allDestOccupyOPF + _allDestHoldOPF;  // NEVER include PUBLICs in this calc!
	
	// Independent destinations:
	CSWR_destRestrictIND = ((_confirmedMkrs # 1) # 2) # 0;
	CSWR_destWatchIND    = ((_confirmedMkrs # 1) # 2) # 1;
	CSWR_destOccupyIND   = ((_confirmedMkrs # 1) # 2) # 2;
	CSWR_destHoldIND     = ((_confirmedMkrs # 1) # 2) # 3;
	_allDestRestrictIND  = (CSWR_destRestrictIND # 0) + (CSWR_destRestrictIND # 1);
	_allDestWatchIND     = (CSWR_destWatchIND # 0) + (CSWR_destWatchIND # 1);
	_allDestOccupyIND    = (CSWR_destOccupyIND # 0) + (CSWR_destOccupyIND # 1);
	_allDestHoldIND      = (CSWR_destHoldIND # 0) + (CSWR_destHoldIND # 1);
	_allDestsIND         = _allDestRestrictIND + _allDestWatchIND + _allDestOccupyIND + _allDestHoldIND;  // NEVER include PUBLICs in this calc!
	
	// Civilian destinations:
	CSWR_destRestrictCIV = ((_confirmedMkrs # 1) # 3) # 0;  // CIV has no restricted-move, actually. Reserved space only.
	CSWR_destWatchCIV    = ((_confirmedMkrs # 1) # 3) # 1;  // CIV has no watch-move, actually. Reserved space only.
	CSWR_destOccupyCIV   = ((_confirmedMkrs # 1) # 3) # 2;
	CSWR_destHoldCIV     = ((_confirmedMkrs # 1) # 3) # 3;
	_allDestRestrictCIV  = (CSWR_destRestrictCIV # 0) + (CSWR_destRestrictCIV # 1);  // CIV has no restricted-move.
	_allDestWatchCIV     = (CSWR_destWatchCIV # 0) + (CSWR_destWatchCIV # 1);  // CIV has no watch-move.
	_allDestOccupyCIV    = (CSWR_destOccupyCIV # 0) + (CSWR_destOccupyCIV # 1);
	_allDestHoldCIV      = (CSWR_destHoldCIV # 0) + (CSWR_destHoldCIV # 1);
	_allDestsCIV         = _allDestRestrictCIV + _allDestWatchCIV + _allDestOccupyCIV + _allDestHoldCIV;  // NEVER include PUBLICs in this calc!
	// Civilian and soldier destinations:
	CSWR_destsPUBLIC     = ((_confirmedMkrs # 1) # 4) # 0;
	_allDestPUBLIC       = (CSWR_destsPUBLIC # 0) + (CSWR_destsPUBLIC # 1);
	// Specialized destinations:
	_allDestsSpecial = _allDestWatchBLU  + _allDestWatchOPF  + _allDestWatchIND  + _allDestWatchCIV  +    // watch
	                   _allDestOccupyBLU + _allDestOccupyOPF + _allDestOccupyIND + _allDestOccupyCIV +    // occupy
	                   _allDestHoldBLU   + _allDestHoldOPF   + _allDestHoldIND   + _allDestHoldCIV;       // hold
	// All common moves to be used when is applied "_move_ANY" (never including specialized/special destinations):
	CSWR_destsANYWHERE = [[/*land*/],[/*water*/]];
	(CSWR_destsANYWHERE # 0) append (CSWR_destsPUBLIC # 0);
	(CSWR_destsANYWHERE # 1) append (CSWR_destsPUBLIC # 1);
	if CSWR_isOnBLU then { (CSWR_destsANYWHERE # 0) append (CSWR_destRestrictBLU # 0); (CSWR_destsANYWHERE # 1) append (CSWR_destRestrictBLU # 1) };
	if CSWR_isOnOPF then { (CSWR_destsANYWHERE # 0) append (CSWR_destRestrictOPF # 0); (CSWR_destsANYWHERE # 1) append (CSWR_destRestrictOPF # 1) };
	if CSWR_isOnIND then { (CSWR_destsANYWHERE # 0) append (CSWR_destRestrictIND # 0); (CSWR_destsANYWHERE # 1) append (CSWR_destRestrictIND # 1) };
	//if CSWR_isOnCIV then { (CSWR_destsANYWHERE # 0) append (CSWR_destRestrictCIV # 0); (CSWR_destsANYWHERE # 1) append (CSWR_destRestrictCIV # 1) };  // Useless, CIV uses only PUBLIC, not RESTRICT.
	// Hold-move ground cleaner:
	if CSWR_isOnBLU then { [CSWR_destHoldBLU # 0] call THY_fnc_CSWR_HOLD_ground_cleaner };
	if CSWR_isOnOPF then { [CSWR_destHoldOPF # 0] call THY_fnc_CSWR_HOLD_ground_cleaner };
	if CSWR_isOnIND then { [CSWR_destHoldIND # 0] call THY_fnc_CSWR_HOLD_ground_cleaner };
	//if CSWR_isOnCIV then { [CSWR_destHoldCIV # 0] call THY_fnc_CSWR_HOLD_ground_cleaner };  // Not needed for CIV.
	// Debug markers stylish:
	if CSWR_isOnDebug then {
		// Visibility and colors:
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorBLUFOR"      } forEach CSWR_spwnsAllBLU + _allDestsBLU;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorOPFOR"       } forEach CSWR_spwnsAllOPF + _allDestsOPF;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorIndependent" } forEach CSWR_spwnsAllIND + _allDestsIND;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorCivilian"    } forEach CSWR_spwnsAllCIV + _allDestsCIV;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorUNKNOWN"     } forEach _allDestPUBLIC;
		// Shapes:
		{ _x setMarkerType "mil_destroy";        _x setMarkerAlpha 0.5 } forEach _allDestWatchBLU + _allDestWatchOPF + _allDestWatchIND + _allDestWatchCIV;
		{ _x setMarkerType "mil_start_noShadow"; _x setMarkerAlpha 0.5 } forEach _allDestHoldBLU  + _allDestHoldOPF  + _allDestHoldIND  + _allDestHoldCIV;
		// For Occupy:
		if CSWR_isOnDebugOccupy then {
			{ _x setMarkerShape "ELLIPSE"; _x setMarkerBrush "Border"; _x setMarkerAlpha 0.8; _x setMarkerSize [CSWR_occupyMkrRange, CSWR_occupyMkrRange] } forEach _allDestOccupyBLU + _allDestOccupyOPF + _allDestOccupyIND + _allDestOccupyCIV;
		};
		// For Watch:
		if CSWR_isOnDebugWatch then {
			// Creation additional markers for debug purposes:
			for "_i" from 1 to 2 do {
				if CSWR_isOnBLU then {
					{
						_debugMkrWatch = createMarker ["debug_" + _x + str _i, markerPos _x];
						_debugMkrWatch setMarkerShape "ELLIPSE";
						_debugMkrWatch setMarkerBrush "Border";
						_debugMkrWatch setMarkerAlpha 0.8;
						_debugMkrWatch setMarkerColor "colorBLUFOR";
						if ( _i isEqualTo 1 ) then { _debugMkrWatch setMarkerSize [CSWR_watchMkrRangeStart, CSWR_watchMkrRangeStart] } else { _debugMkrWatch setMarkerSize [CSWR_watchMkrRange, CSWR_watchMkrRange] };
					} forEach _allDestWatchBLU;
				};
				if CSWR_isOnOPF then {
					{
						_debugMkrWatch = createMarker ["debug_" + _x + str _i, markerPos _x];
						_debugMkrWatch setMarkerShape "ELLIPSE";
						_debugMkrWatch setMarkerBrush "Border";
						_debugMkrWatch setMarkerAlpha 0.8;
						_debugMkrWatch setMarkerColor "colorOPFOR";
						if ( _i isEqualTo 1 ) then { _debugMkrWatch setMarkerSize [CSWR_watchMkrRangeStart, CSWR_watchMkrRangeStart] } else { _debugMkrWatch setMarkerSize [CSWR_watchMkrRange, CSWR_watchMkrRange] };
					} forEach _allDestWatchOPF;
				};
				if CSWR_isOnIND then {
					{
						_debugMkrWatch = createMarker ["debug_" + _x + str _i, markerPos _x];
						_debugMkrWatch setMarkerShape "ELLIPSE";
						_debugMkrWatch setMarkerBrush "Border";
						_debugMkrWatch setMarkerAlpha 0.8;
						_debugMkrWatch setMarkerColor "colorIndependent";
						if ( _i isEqualTo 1 ) then { _debugMkrWatch setMarkerSize [CSWR_watchMkrRangeStart, CSWR_watchMkrRangeStart] } else { _debugMkrWatch setMarkerSize [CSWR_watchMkrRange, CSWR_watchMkrRange] };
					} forEach _allDestWatchIND;
				};
			};  // for-loop ends.
		};
	// Otherwise, hiding the spawn and destination markers:
	} else { {_x setMarkerAlpha 0} forEach _spwnsAll + _allDestsSpecial + (CSWR_destsANYWHERE # 0) + (CSWR_destsANYWHERE # 1) };
	// Delete the useless CSWR markers dropped on Eden:
	if !CSWR_isOnBLU then { { deleteMarker _x } forEachReversed (CSWR_spwnsAllBLU + _allDestsBLU) };
	if !CSWR_isOnOPF then { { deleteMarker _x } forEachReversed (CSWR_spwnsAllOPF + _allDestsOPF) };
	if !CSWR_isOnIND then { { deleteMarker _x } forEachReversed (CSWR_spwnsAllIND + _allDestsIND) };
	if !CSWR_isOnCIV then { { deleteMarker _x } forEachReversed (CSWR_spwnsAllCIV + _allDestsCIV) };
	// Destroying useless things:
	_spwnsAll        = nil;
	_allDestsSpecial = nil;
	// Global object declarations:
	publicVariable "CSWR_isOn"; publicVariable "CSWR_isOnDebug"; publicVariable "CSWR_isOnDebugOccupy"; publicVariable "CSWR_isOnDebugWatch"; publicVariable "CSWR_isOnDebugHeli"; publicVariable "CSWR_isOnDebugNautic"; publicVariable "CSWR_isOnDebugPara"; publicVariable "CSWR_isOnDebugBooking"; publicVariable "CSWR_isOnDebugSectors"; publicVariable "CSWR_isOnDebugHold"; publicVariable "CSWR_isOnBLU"; publicVariable "CSWR_isOnOPF"; publicVariable "CSWR_isOnIND"; publicVariable "CSWR_isOnCIV"; publicVariable "CSWR_isBackpackForAllByFoot"; publicVariable "CSWR_isVestForAll"; publicVariable "CSWR_facesFromRegionBLU"; publicVariable "CSWR_languageBLU"; publicVariable "CSWR_canNvgInfantryBLU"; publicVariable "CSWR_canNvgMarinesBLU"; publicVariable "CSWR_canNvgParatroopsBLU"; publicVariable "CSWR_canNvgSnipersBLU"; publicVariable "CSWR_nvgDeviceBLU"; publicVariable "CSWR_canFlashlightBLU"; publicVariable "CSWR_isForcedFlashlBLU"; publicVariable "CSWR_flashlightDeviceBLU"; publicVariable "CSWR_watcherAccuranceBLU"; publicVariable "CSWR_facesFromRegionOPF"; publicVariable "CSWR_languageOPF"; publicVariable "CSWR_canNvgInfantryOPF"; publicVariable "CSWR_canNvgMarinesOPF"; publicVariable "CSWR_canNvgParatroopsOPF"; publicVariable "CSWR_canNvgSnipersOPF"; publicVariable "CSWR_nvgDeviceOPF"; publicVariable "CSWR_canFlashlightOPF"; publicVariable "CSWR_isForcedFlashlOPF"; publicVariable "CSWR_flashlightDeviceOPF"; publicVariable "CSWR_watcherAccuranceOPF"; publicVariable "CSWR_facesFromRegionIND"; publicVariable "CSWR_languageIND"; publicVariable "CSWR_canNvgInfantryIND"; publicVariable "CSWR_canNvgMarinesIND"; publicVariable "CSWR_canNvgParatroopsIND"; publicVariable "CSWR_canNvgSnipersIND"; publicVariable "CSWR_nvgDeviceIND"; publicVariable "CSWR_canFlashlightIND"; publicVariable "CSWR_isForcedFlashlIND"; publicVariable "CSWR_flashlightDeviceIND"; publicVariable "CSWR_watcherAccuranceIND"; publicVariable "CSWR_facesFromRegionCIV"; publicVariable "CSWR_languageCIV"; publicVariable "CSWR_canNvgCIV"; publicVariable "CSWR_nvgDeviceCIV"; publicVariable "CSWR_isHoldVehLightsOff"; publicVariable "CSWR_isHeliSpwningInAir"; publicVariable "CSWR_groupTypesForSpwns"; publicVariable "CSWR_groupTypesForSpwnsVehGround"; publicVariable "CSWR_groupTypesForSpwnsVehNautical"; publicVariable "CSWR_groupTypesForSpwnsVehAirHeli"; publicVariable "CSWR_groupTypesForSpwnsPara"; publicVariable "CSWR_shouldAddHelipadSpwn"; publicVariable "CSWR_hasRtbHeli"; publicVariable "CSWR_isElectroWarForBLU"; publicVariable "CSWR_isElectroWarForOPF"; publicVariable "CSWR_isElectroWarForIND"; /* publicVariable "CSWR_reportToRadioAllies"; */ /* publicVariable "CSWR_spwnHeliOnShipFloor"; */ publicVariable "CSWR_serverMaxFPS"; publicVariable "CSWR_serverMinFPS"; publicVariable "CSWR_isEditableByZeus"; publicVariable "CSWR_destCommonTakeabreak"; publicVariable "CSWR_destOccupyTakeabreak"; publicVariable "CSWR_destHoldTakeabreak"; publicVariable "CSWR_heliTakeOffDelay"; publicVariable "CSWR_watchMkrRange"; publicVariable "CSWR_occupyMkrRange"; publicVariable "CSWR_spwnsParadropUnitAlt"; publicVariable "CSWR_spwnsParadropVehAlt"; publicVariable "CSWR_spwnsParadropSpreading"; publicVariable "CSWR_spwnsParadropWaiting"; publicVariable "CSWR_acceptableTowersForWatch"; publicVariable "CSWR_civOutfits"; publicVariable "CSWR_forbiddenMarineUniforms"; publicVariable "CSWR_facesAfrica"; publicVariable "CSWR_facesAsia"; publicVariable "CSWR_facesEurope"; publicVariable "CSWR_facesEuropeEast"; publicVariable "CSWR_facesMidEast"; publicVariable "CSWR_facesAmericaNorth"; publicVariable "CSWR_facesAmericaSouth"; publicVariable "CSWR_langChinese"; publicVariable "CSWR_langIranian"; publicVariable "CSWR_langFrench"; publicVariable "CSWR_langGbEnglish"; publicVariable "CSWR_langPolish"; publicVariable "CSWR_langRussian"; publicVariable "CSWR_langUsEnglish"; publicVariable "CSWR_wait"; publicVariable "CSWR_txtDebugHeader"; publicVariable "CSWR_txtWarnHeader"; publicVariable "CSWR_bookedLocHold"; publicVariable "CSWR_bookedLocSpwnVeh"; publicVariable "CSWR_bookedLocSpwnHeli"; publicVariable "CSWR_spwnDelayQueueAmount"; publicVariable "CSWR_prefix"; publicVariable "CSWR_spacer"; publicVariable "CSWR_watchMkrRangeStart"; publicVariable "CSWR_vehGroundHeavy"; publicVariable "CSWR_spwnsLandBLU"; publicVariable "CSWR_spwnsWaterBLU"; publicVariable "CSWR_spwnsVehLandBLU"; publicVariable "CSWR_spwnsVehWaterBLU"; publicVariable "CSWR_spwnsHeliLandBLU"; publicVariable "CSWR_spwnsHeliWaterBLU"; publicVariable "CSWR_spwnsParaAirBLU"; /* publicVariable "CSWR_spwnsParaUselessBLU"; */ publicVariable "CSWR_spwnsAllBLU"; publicVariable "CSWR_spwnsLandOPF"; publicVariable "CSWR_spwnsWaterOPF"; publicVariable "CSWR_spwnsVehLandOPF"; publicVariable "CSWR_spwnsVehWaterOPF"; publicVariable "CSWR_spwnsHeliLandOPF"; publicVariable "CSWR_spwnsHeliWaterOPF"; publicVariable "CSWR_spwnsParaAirOPF"; /* publicVariable "CSWR_spwnsParaUselessOPF"; */ publicVariable "CSWR_spwnsAllOPF"; publicVariable "CSWR_spwnsLandIND"; publicVariable "CSWR_spwnsWaterIND"; publicVariable "CSWR_spwnsVehLandIND"; publicVariable "CSWR_spwnsVehWaterIND"; publicVariable "CSWR_spwnsHeliLandIND"; publicVariable "CSWR_spwnsHeliWaterIND"; publicVariable "CSWR_spwnsParaAirIND"; /* publicVariable "CSWR_spwnsParaUselessIND"; */ publicVariable "CSWR_spwnsAllIND"; publicVariable "CSWR_spwnsLandCIV"; publicVariable "CSWR_spwnsWaterCIV"; publicVariable "CSWR_spwnsVehLandCIV"; publicVariable "CSWR_spwnsVehWaterCIV"; publicVariable "CSWR_spwnsHeliLandCIV"; publicVariable "CSWR_spwnsHeliWaterCIV"; publicVariable "CSWR_spwnsParaAirCIV"; /* publicVariable "CSWR_spwnsParaUselessCIV"; */ publicVariable "CSWR_spwnsAllCIV"; publicVariable "CSWR_destRestrictBLU"; publicVariable "CSWR_destWatchBLU"; publicVariable "CSWR_destOccupyBLU"; publicVariable "CSWR_destHoldBLU"; publicVariable "CSWR_destWatchOPF"; publicVariable "CSWR_destOccupyOPF"; publicVariable "CSWR_destHoldOPF"; publicVariable "CSWR_destWatchIND"; publicVariable "CSWR_destOccupyIND"; publicVariable "CSWR_destHoldIND"; publicVariable "CSWR_destWatchCIV"; publicVariable "CSWR_destOccupyCIV"; publicVariable "CSWR_destHoldCIV"; publicVariable "CSWR_destsPUBLIC"; publicVariable "CSWR_destsANYWHERE";
	// Debug:
	if CSWR_isOnDebug then {
		// If the specific side is ON and has at least 1 spawnpoint:
		if ( CSWR_isOnBLU && count CSWR_spwnsAllBLU > 0 ) then {
			// Message:
			systemChat format ["%1 SIDE BLU > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).",
			CSWR_txtDebugHeader, count CSWR_spwnsAllBLU, count _allDestsBLU, count _allDestPUBLIC];
		};
		// If the specific side is ON and has at least 1 spawnpoint:
		if ( CSWR_isOnOPF && count CSWR_spwnsAllOPF > 0 ) then {
			// Message:
			systemChat format ["%1 SIDE OPF > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).",
			CSWR_txtDebugHeader, count CSWR_spwnsAllOPF, count _allDestsOPF, count _allDestPUBLIC];
		};
		// If the specific side is ON and has at least 1 spawnpoint:
		if ( CSWR_isOnIND && count CSWR_spwnsAllIND > 0 ) then {
			// Message:
			systemChat format ["%1 SIDE IND > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).",
			CSWR_txtDebugHeader, count CSWR_spwnsAllIND, count _allDestsIND, count _allDestPUBLIC];
		};
		// If the specific side is ON and has at least 1 spawnpoint:
		if ( CSWR_isOnCIV && count CSWR_spwnsAllCIV > 0 ) then {
			// Message:
			systemChat format ["%1 SIDE CIV > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).",
			CSWR_txtDebugHeader, count CSWR_spwnsAllCIV, count _allDestsCIV, count _allDestPUBLIC];
		};
	};
	// Debug monitor looping:
	while { CSWR_isOnDebug } do { call THY_fnc_CSWR_debug };
};
// Return:
true;
