// CSWR v6.0
// File: your_mission\CSWRandomizr\fn_CSWR_management.sqf
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)

if (!isServer) exitWith {};

// PARAMETERS OF EDITOR'S OPTIONS:
// Debug:
    CSWR_isOnDebugGlobal  = true;    // true = shows basic debug information for the Mission Editor / false = turn it off. Default: false.
    CSWR_isOnDebugOccupy  = false;   // true = shows deeper Occupy-markers debug info / false = turn it off. Default: false.
    CSWR_isOnDebugWatch   = false;   // true = shows deeper Watch-markers debug info / false = turn it off. Default: false.
    CSWR_isOnDebugHold    = false;   // true = shows deeper Hold-markers debug info / false = turn it off. Default: false.
    CSWR_isOnDebugHeli    = false;   // true = shows deeper AI Helicopters piloting debug info / false = turn it off. Default: false.
    CSWR_isOnDebugPara    = false;   // true = shows deeper Paradrop debug info / false = turn it off. Default: false.
    CSWR_isOnDebugBooking = false;   // true = shows deeper markers booking debug info / false = turn it off. Default: false.
// Factions:
    CSWR_isOnBLU = true;   // true = if you wanna spawn BluFor/West through CSWR / false = don't spawn this side.
    CSWR_isOnOPF = false;   // true = if you wanna spawn OpFor/East through CSWR / false = don't spawn this side.
    CSWR_isOnIND = false;  // true = if you wanna spawn Indepdentent/Resistence through CSWR / false = don't spawn this side.
    CSWR_isOnCIV = false;  // true = if you wanna spawn Civilians through CSWR / false = don't spawn this side.
// Loadout global:
    CSWR_isBackpackForAllByFoot = false;  // true = all units by foot (including CIV) will get it / false = only units originally with backpacks. Default: false.
    CSWR_isVestForAll           = false;  // true = all units (including CIV) will get it / false = only units originally with vests. Default: false.
// Loadout by side:
    // Blu
        CSWR_canNvgInfantryBLU   = false;   // true = BLU infantry/armoured will receive NightVision / false = BLU infantry NVG will be removed.
        CSWR_canNvgParatroopsBLU = true;    // true = BLU paratroops will receive NightVision / false = BLU paratroops NVG will be removed.
        CSWR_canNvgSnipersBLU    = true;    // true = BLU snipers will receive NightVision / false = BLU snipers NVG will be removed.
        CSWR_nvgDeviceBLU        = "NVGoggles";  // Set the NightVision classname for BlU army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightBLU    = true;    // true = BLU units with no NVG will get flashlights for their primary weapons / false = no flashlights.
        CSWR_flashlightDeviceBLU = "acc_flashlight";  // Set the flashlight classname for BlU army. Empty ("") means no changes in original soldier loadout.
    // Opf
        CSWR_canNvgInfantryOPF   = false;   // true = OPF infantry/armoured will receive NightVision / false = OPF infantry NVG will be removed.
        CSWR_canNvgParatroopsOPF = true;    // true = OPF paratroops will receive NightVision / false = OPF paratroops NVG will be removed.
        CSWR_canNvgSnipersOPF    = true;    // true = OPF snipers will receive NightVision / false = OPF snipers NVG will be removed.
        CSWR_nvgDeviceOPF        = "NVGoggles_OPFOR";  // Set the NightVision classname for OPF army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightOPF    = true;    // true = OPF units with no NVG will get flashlights for their primary weapons / false = no flashlights.
        CSWR_flashlightDeviceOPF = "acc_flashlight";  // Set the flashlight classname for OPF army. Empty ("") means no changes in original soldier loadout.
    // Ind
        CSWR_canNvgInfantryIND   = false;   // true = IND infantry/armoured will receive NightVision / false = IND infantry NVG will be removed.
        CSWR_canNvgParatroopsIND = true;    // true = IND paratroops will receive NightVision / false = IND paratroops NVG will be removed.
        CSWR_canNvgSnipersIND    = true;    // true = IND snipers will receive NightVision / false = IND snipers NVG will be removed.
        CSWR_nvgDeviceIND        = "NVGoggles_INDEP";  // Set the NightVision classname for IND army. Empty ("") means no changes in original soldier loadout.
        CSWR_canFlashlightIND    = true;    // true = IND units with no NVG will get flashlights for their primary weapons / false = no flashlights.
        CSWR_flashlightDeviceIND = "acc_flashlight";  // Set the flashlight classname for IND army. Empty ("") means no changes in original soldier loadout.
    // civ
        CSWR_canNvgCIV    = false;          // true = CIV people will receive NightVision / false = CIV people NVG will be removed.
        CSWR_nvgDeviceCIV = "NVGoggles";    // Set the NightVision classname for CIV people. Empty ("") means no changes in original people outfit.
// Voices by side:
    //CSWR_voiceBLU = "";      // WIP.
    //CSWR_voiceOPF = "";      // WIP.
    //CSWR_voiceIND = "";      // WIP.
    //CSWR_voiceCIV = "";      // WIP.
// Global vehicles:
    CSWR_isHoldVehLightsOff   = false;  // true = vehicles on hold-move will turn its lights off / false = The AI behavior decides. Default: false.
    //CSWR_isUnlimitedFuel      = false;  // WIP
    //CSWR_isUnlimitedAmmo      = false;  // WIP
    CSWR_isHeliSpwningInAir   = false;  // true = helicopter will spawn already in air / false = they spawn on the ground level. Default: false.
    CSWR_shouldAddHelipadSpwn = false;  // true = add a visible helipad in each heli spawnpoint / false = a invisible helipad is added. Default: false.
    CSWR_isElectroWarForBLU   = true;   // true = vehicles of BLU will use Electronic Warfare Resources / false = they don't. Default: true.
    CSWR_isElectroWarForOPF   = true;   // true = vehicles of OPF will use Electronic Warfare Resources / false = they don't. Default: true.
    CSWR_isElectroWarForIND   = true;   // true = vehicles of IND will use Electronic Warfare Resources / false = they don't. Default: true.
// Others:
    CSWR_isEditableByZeus    = true;  // true = CSWR units and CSWR vehicles can be manipulated when Zeus is available / false = no editable. Default: true.
    //CSWR_reportToRadioAllies = false;   // WIP - true = player's allies units report important things on radio-chat to the leaders / false = silence. Default: false.
	CSWR_spwnHeliOnShipFloor = 25;  // If needed, set how many meters above the sea leval is the ship floor where the spawn of helicopters will be.
// Server:
    CSWR_serverMaxFPS = 50.0;  // Be advised: extremely recommended do not change this value. Default; 50.0
    CSWR_serverMinFPS = 20.0;  // Be advised: extremely recommended do not change this value. Default: 20.0
    //CSWR_aiAmoutLimit = 500;   // WIP - Define how much CSWR Ai will be the limit to run simultaneously. Default: 500
	CSWR_wait = 1;  // If you need to make CSWR waits more for other scripts load first, set a delay in seconds. Default: 1.

    // MOVEMENT ADVANCED SETTINGS:
    // Time:
        CSWR_destCommonTakeabreak = [0, 30, 60];         // In seconds, how long each group can stay on its Move-markers. Default: 0 sec, 30 sec, 60 sec.
        CSWR_destOccupyTakeabreak = [600, 1200, 2400];    // In seconds, how long each group can stay on its Occupy-markers. Default: 10min (600), 20min (1200), 40min (2400).
        CSWR_destHoldTakeabreak   = [1800, 3600, 7200];  // In seconds, how long each group can stay on its Hold-markers. Default: 30min (1800), 1h (3600), 2h (7200).
        CSWR_heliTakeoffDelay     = [10, 30, 60];        // In seconds, how long each helicopter can stay before takeoff. Default: 10 sec, 30 sec, 60 sec.
    // Ranges:
        CSWR_watchMarkerRange  = 1000;  // In meters, size of marker range used to find buildings to watch/sniper group. Default: 1000.
        CSWR_occupyMarkerRange = 200;   // In meters, size of marker range used to find buildings to occupy. Default: 200.
    // Altitudes:
        CSWR_spwnsParaUnitAlt = 1000;  // In meters, the initial unit paradrop altitude. Default: 1000.
        CSWR_spwnsParaVehAlt  = 300;   // In meters, the initial vehicle paradrop altitude. Default: 300.
        CSWR_heliLightAlt     = 150;  // In meters, cruising altitude for helicopters of light class. Default: 150.
        CSWR_heliHeavyAlt     = 300;  // In meters, cruising altitude for helicopters of heavy class. Default: 300.
    // Exceptions management:
        // What specific building positions must be ignored for all sides. Use getPosATL ([ [x1,y1,z1], [x2,y2,z2] ]) to exclude the position:
        CSWR_occupyIgnoredPositions = [  ];
        // What building classnames must be ignored for all sides:
        CSWR_occupyIgnoredBuildings = ["Land_Pier_F", "Land_Pier_small_F", "Land_Lighhouse_small_F", "Land_PowerPoleWooden_L_F", "Land_LampStreet_small_F", "Land_dp_smallTank_F", "Land_LampHalogen_F", "Land_LampDecor_F", "Land_FuelStation_Feed_F", "Land_spp_Transformer_F", "Land_FuelStation_Build_F", "Land_Addon_01_F", "Land_u_Addon_01_V1_F", "Land_Addon_03_F", "Land_Shed_Big_F", "Land_Shed_03_F", "Land_Shed_05_F", "Land_Track_01_bridge_F", "Land_SCF_01_storageBin_small_F", "Land_SCF_01_storageBin_medium_F", "Land_StorageTank_01_small_F", "Land_StorageTank_01_large_F", "Land_Shop_City_04_F", "Land_Shop_City_05_F", "Land_Shop_City_06_F", "Land_Shop_City_07_F", "Land_Shop_Town_02_F", "Land_Shop_Town_05_F", "Land_FireEscape_01_tall_F", "Land_FireEscape_01_short_F", "Land_Offices_01_V1_F", "Land_MultistoryBuilding_03_F", "Land_MultistoryBuilding_04_F", "Land_Hotel_02_F", "Land_House_Big_05_F", "Land_Workshop_04_F", "Land_Church_01_F", "Land_Church_01_V2_F", "Land_Church_02_F", "Land_ContainerLine_01_F", "Land_ContainerLine_02_F", "Land_ContainerLine_03_F", "Land_Warehouse_02_F", "Land_Warehouse_01_F", "Land_Tents_Refugee_Red_lxWS", "Land_Tents_Refugee_Green_lxWS", "Land_Tents_Refugee_Orange_lxWS", "Land_Tents_Refugee_lxWS", "Land_Tents_Refugee_Pattern_lxWS", "Land_Tents_Refugee_Blue_lxWS", "Land_Tents_Refugee_Dirty_lxWS", "Land_Tents_Refugee_DBrown_lxWS"];
        // What ruins should be considered for occupy-movement (Important: if the ruin has no spots in its 3D, CSWR won't include it as option):
        CSWR_occupyAcceptableRuins = ["Land_HouseRuin_Big_01_F", "Land_HouseRuin_Big_01_half_F", "Land_HouseRuin_Big_02_half_F", "Land_HouseRuin_Big_02_F", "Land_HouseRuin_Big_04_F", "Land_OrthodoxChurch_03_ruins_F", "Land_ControlTower_01_ruins_F", "Land_ChurchRuin_01_F", "Land_Shop_Town_01_ruins_F", "Land_House_Big_01_V1_ruins_F", "Land_BellTower_02_V2_ruins_F", "Land_HouseRuin_Small_02_F", "Land_HouseRuin_Small_04_F", "Land_HouseRuin_Big_03_half_F", "Land_HouseRuin_Big_03_F", "Land_House_Small_01_b_brown_ruins_F", "Land_House_Small_01_b_yellow_ruins_F", "Land_Barn_01_grey_ruins_F", "Land_Barn_01_brown_ruins_F", "Land_Shop_02_b_yellow_ruins_F", "Land_House_Big_02_b_brown_ruins_F", "Land_House_Big_02_b_pink_ruins_F", "Land_House_Big_02_b_blue_ruins_F", "Land_House_Big_01_b_blue_ruins_F", "Land_House_Big_01_b_brown_ruins_F", "Land_House_Big_01_b_pink_ruins_F"];
        // WIP : What goggles are acceptable for parachuters inherit from infantry if the editor doesn't set a specific one to parachuters:
        CSWR_paraAcceptableGoggles = ["G_Balaclava_combat", "G_Balaclava_lowprofile", "G_Lowprofile", "G_Combat", "G_Goggles_VR", "G_Combat_Goggles_tna_F", "G_Balaclava_TI_G_blk_F", "G_Balaclava_TI_G_tna_F", "G_AirPurifyingRespirator_02_black_F", "G_AirPurifyingRespirator_02_olive_F", "G_AirPurifyingRespirator_02_sand_F", "G_AirPurifyingRespirator_01_F", "G_RegulatorMask_F", "G_EyeProtectors_F", "UK3CB_Glasses", "rhs_ess_black", "rhsusf_shemagh_gogg_grn", "rhsusf_shemagh2_gogg_grn", "rhsusf_shemagh_gogg_od", "rhsusf_shemagh2_gogg_od", "rhsusf_shemagh_gogg_tan", "rhsusf_shemagh2_gogg_tan", "rhsusf_shemagh_gogg_white", "rhsusf_shemagh2_gogg_white", "rhsusf_oakley_goggles_blk", "rhsusf_oakley_goggles_clr", "rhsusf_oakley_goggles_ylw"];
        // What uniforms/outfits civilians can use it editors use the random selection (only A3 original content already included):
        CSWR_civOutfits = ["U_C_Poor_1", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_salmon", "U_Competitor", "U_C_HunterBody_grn", "U_Marshal", "U_Rangemaster", "U_I_C_Soldier_Bandit_5_F", "U_I_C_Soldier_Bandit_4_F", "U_C_Man_casual_3_F", "U_C_Man_casual_1_F", "U_C_Man_casual_5_F", "U_C_man_sport_3_F", "U_C_Uniform_Farmer_01_F", "U_I_L_Uniform_01_tshirt_black_F", "U_C_Uniform_Scientist_02_formal_F", "U_C_ConstructionCoverall_Red_F", "U_C_ArtTShirt_01_v2_F", "U_C_FormalSuit_01_gray_F", "U_C_ArtTShirt_01_v6_F"];


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------
// When the mission starts:
[] spawn {
	// Local object declarations:
	private ["_helipad", "_genericNVG", "_genericFlashlight", "_txt1", "_txt2", "_txt3", "_txt4", "_txt5", "_txt6", "_txt7", "_txt8"];
	// Debug txts:
	CSWR_txtDebugHeader = "CSWR DEBUG >";
	CSWR_txtWarnHeader  = "CSWR WARNING >";
	// Initial values:
	CSWR_bookedLocWatch    = [[],[],[],[]];     // [[blu],[opf],[ind],[civ]]
	CSWR_bookedLocHold     = [[],[],[],[]];     // [[blu],[opf],[ind],[civ]]
	CSWR_bookedLocSpwnVeh  = [[],[],[],[]];  // [[blu],[opf],[ind],[civ]]
	CSWR_bookedLocSpwnHeli = [[],[],[],[]];  // [[blu],[opf],[ind],[civ]]
	CSWR_spwnDelayQueueAmount = 0;  // debug proposes.
	_helipad = "";
	// Declarations:
	CSWR_prefix         = "CSWR";  // CAUTION: NEVER include/insert the CSWR_spacer character as part of the CSWR_prefix too.
	CSWR_spacer         = "_";  // CAUTION: try do not change it!
	CSWR_vehGroundHeavy = ["Tank", "TrackedAPC", "WheeledAPC"];
	_genericNVG         = "NVGoggles";
	_genericFlashlight  = "acc_flashlight";
	_txt1="For good combat experince, don't use"; _txt2="value less than"; _txt3="out of debug mode. Minimal value"; _txt4="GEAR > NIGHTVISION > You turned the NVG usage 'true' for"; _txt5="side, but in parallel you're trying to force removal of"; _txt6="NVG's. Fix it in 'fn_CSWR_management.sqf' file. Generic NVG was applied."; _txt7="GEAR > FLASHLIGHT > You turned the Flashlight usage 'true' for"; _txt8="FLASHLIGHTS. Fix it in 'fn_CSWR_management.sqf' file. Generic Flashlight was applied.";

	// Main markers validation:
	CSWR_confirmedMarkers = [CSWR_prefix, CSWR_spacer] call THY_fnc_CSWR_marker_scanner;
	// Errors handling:
	if ( CSWR_wait < 1 ) then { CSWR_wait = 1 };  // Important to hold some functions and make their warning (if has) to show only in-game for mission editor.
	if CSWR_isOnDebugGlobal then {
		if ( CSWR_wait >= 5 ) then { systemChat format ["%1 Don't forget the CSWR is configurated to delay %2 seconds before to starts its tasks.", CSWR_txtDebugHeader, CSWR_wait] };
	} else {
		if ( CSWR_destOccupyTakeabreak # 0 < 300 OR CSWR_destOccupyTakeabreak # 1 < 600 OR CSWR_destOccupyTakeabreak # 2 < 1200 ) then { CSWR_destOccupyTakeabreak=[600,1200,2400]; systemChat format ["%1 OCCUPY > %5 'CSWR_destOccupyTakeabreak' %6 [%2 secs, %3 secs, %4 secs] %7s have been applied.", CSWR_txtWarnHeader, CSWR_destOccupyTakeabreak # 0, CSWR_destOccupyTakeabreak # 1, CSWR_destOccupyTakeabreak # 2, _txt1, _txt2, _txt3] };
		if ( CSWR_destHoldTakeabreak # 0 < 900 OR CSWR_destHoldTakeabreak # 1 < 1800 OR CSWR_destHoldTakeabreak # 2 < 3600 ) then { CSWR_destHoldTakeabreak=[1800,3600,7200]; systemChat format ["%1 HOLD > %5 'CSWR_destHoldTakeabreak' %6 [%2 secs, %3 secs, %4 secs] %7s have been applied.", CSWR_txtWarnHeader, CSWR_destHoldTakeabreak # 0, CSWR_destHoldTakeabreak # 1, CSWR_destHoldTakeabreak # 2, _txt1, _txt2, _txt3] };
		if ( CSWR_watchMarkerRange < 100 ) then { CSWR_watchMarkerRange=100; systemChat format ["%1 WATCH > %3 'CSWR_watchMarkerRange' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_watchMarkerRange, _txt1, _txt2, _txt3] };
		if ( CSWR_occupyMarkerRange < 100 ) then { CSWR_occupyMarkerRange=100; systemChat format ["%1 OCCUPY > %3 'CSWR_occupyMarkerRange' %4 %2 %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_occupyMarkerRange, _txt1, _txt2, _txt3] };
		if ( CSWR_spwnsParaUnitAlt < 500 ) then { CSWR_spwnsParaUnitAlt=500; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParaUnitAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParaUnitAlt, _txt1, _txt2, _txt3] };
		if ( CSWR_spwnsParaVehAlt < 200 ) then { CSWR_spwnsParaVehAlt=200; systemChat format ["%1 PARADROP > %3 'CSWR_spwnsParaVehAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_spwnsParaVehAlt, _txt1, _txt2, _txt3] };
		if (CSWR_heliLightAlt < 100 ) then { CSWR_heliLightAlt=100; systemChat format ["%1 HELICOPTER > %3 'CSWR_heliLightAlt' %4 %2 meters %5 (%2) has been applied.", CSWR_txtWarnHeader, CSWR_heliLightAlt, _txt1, _txt2, _txt3] };
		if (CSWR_heliHeavyAlt < CSWR_heliLightAlt+100 ) then { CSWR_heliHeavyAlt=CSWR_heliLightAlt+100; systemChat format ["%1 HELICOPTER > %3 'CSWR_heliHeavyAlt' %4 100 meters of altitude higher than 'CSWR_heliLightAlt' %5 (%2) for this case has been applied.", CSWR_txtWarnHeader, CSWR_heliHeavyAlt, _txt1, _txt2, _txt3] };
	};
	// Some classname validations:
	if CSWR_isOnBLU then {
		if ( CSWR_canNvgInfantryBLU || CSWR_canNvgParatroopsBLU || CSWR_canNvgSnipersBLU ) then { if ( CSWR_nvgDeviceBLU isEqualTo "" || CSWR_nvgDeviceBLU == "REMOVED" ) then { systemChat format ["%1 %2 BLU %3 BLU %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceBLU = _genericNVG } else { ["BLU", "CfgWeapons", "NightVision", "CSWR_nvgDeviceBLU", [CSWR_nvgDeviceBLU]] call THY_fnc_CSWR_is_valid_classname } };
		if CSWR_canFlashlightBLU then { if ( CSWR_flashlightDeviceBLU isEqualTo "" || CSWR_flashlightDeviceBLU == "REMOVED" ) then { systemChat format ["%1 %2 BLU %3 BLU %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceBLU = _genericFlashlight } else { ["BLU", "CfgWeapons", "Flashlight", "CSWR_flashlightDeviceBLU", [CSWR_flashlightDeviceBLU]] call THY_fnc_CSWR_is_valid_classname } };
	};
	if CSWR_isOnOPF then {
		if ( CSWR_canNvgInfantryOPF || CSWR_canNvgParatroopsOPF || CSWR_canNvgSnipersOPF ) then { if ( CSWR_nvgDeviceOPF isEqualTo "" || CSWR_nvgDeviceOPF == "REMOVED" ) then { systemChat format ["%1 %2 OPF %3 OPF %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceOPF = _genericNVG } else { ["OPF", "CfgWeapons", "NightVision", "CSWR_nvgDeviceOPF", [CSWR_nvgDeviceOPF]] call THY_fnc_CSWR_is_valid_classname } };
		if CSWR_canFlashlightOPF then { if ( CSWR_flashlightDeviceOPF isEqualTo "" || CSWR_flashlightDeviceOPF == "REMOVED" ) then { systemChat format ["%1 %2 OPF %3 OPF %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceOPF = _genericFlashlight } else { ["OPF", "CfgWeapons", "Flashlight", "CSWR_flashlightDeviceOPF", [CSWR_flashlightDeviceOPF]] call THY_fnc_CSWR_is_valid_classname } };
	};
	if CSWR_isOnIND then {
		if ( CSWR_canNvgInfantryIND || CSWR_canNvgParatroopsIND || CSWR_canNvgSnipersIND ) then { if ( CSWR_nvgDeviceIND isEqualTo "" || CSWR_nvgDeviceIND == "REMOVED" ) then { systemChat format ["%1 %2 IND %3 IND %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceIND = _genericNVG } else { ["IND", "CfgWeapons", "NightVision", "CSWR_nvgDeviceIND", [CSWR_nvgDeviceIND]] call THY_fnc_CSWR_is_valid_classname } };
		if CSWR_canFlashlightIND then { if ( CSWR_flashlightDeviceIND isEqualTo "" || CSWR_flashlightDeviceIND == "REMOVED" ) then { systemChat format ["%1 %2 IND %3 IND %4", CSWR_txtWarnHeader, _txt7, _txt5, _txt8]; CSWR_flashlightDeviceIND = _genericFlashlight } else { ["IND", "CfgWeapons", "Flashlight", "CSWR_flashlightDeviceIND", [CSWR_flashlightDeviceIND]] call THY_fnc_CSWR_is_valid_classname } };
	};
	if ( CSWR_isOnCIV && CSWR_canNvgCIV ) then {
		if ( CSWR_nvgDeviceCIV isEqualTo "" || CSWR_nvgDeviceCIV == "REMOVED" ) then { systemChat format ["%1 %2 CIV %3 CIV %4", CSWR_txtWarnHeader, _txt4, _txt5, _txt6]; CSWR_nvgDeviceCIV = _genericNVG } else { ["CIV", "CfgWeapons", "NightVision", "CSWR_nvgDeviceCIV", [CSWR_nvgDeviceCIV]] call THY_fnc_CSWR_is_valid_classname };
	};
	
	
	// SPAWNPOINTS:
	// Where each side in-game will spawn randomly and what group's type is allowed to do that.
	/*
	Structure of spawn arrays: CSWR_confirmedMarkers
	[0 spawn types
		[0 blu
			[0 CSWR_spwnsBLU],
			[1 CSWR_spwnsVehBLU],
			[2 CSWR_spwnsHeliBLU],
			[3 CSWR_spwnsParaBLU]
		],
		[1 opf
			[0 CSWR_spwnsOPF],
			[1 CSWR_spwnsVehOPF],
			[2 CSWR_spwnsHeliOPF],
			[3 CSWR_spwnsParaOPF]
		],
		[2 ind
			[0 CSWR_spwnsIND],
			[1 CSWR_spwnsVehIND],
			[2 CSWR_spwnsHeliIND],
			[3 CSWR_spwnsParaIND]
		],
		[3 civ
			[0 CSWR_spwnsCIV],
			[1 CSWR_spwnsVehCIV],
			[2 CSWR_spwnsHeliCIV],
			[3 CSWR_spwnsParaCIV]
		]
	],
	[1 destination types
		...
	];
	*/
	// BluFor spawns:
	CSWR_spwnsBLU     = ((CSWR_confirmedMarkers # 0) # 0) # 0;
	CSWR_spwnsVehBLU  = ((CSWR_confirmedMarkers # 0) # 0) # 1;
	CSWR_spwnsHeliBLU = ((CSWR_confirmedMarkers # 0) # 0) # 2;
	CSWR_spwnsParaBLU = ((CSWR_confirmedMarkers # 0) # 0) # 3;
	CSWR_spwnsAllBLU  = CSWR_spwnsBLU + CSWR_spwnsVehBLU + CSWR_spwnsHeliBLU + CSWR_spwnsParaBLU;
	CSWR_groupTypesForSpwnsBLU     = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsVehBLU  = ["vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsHeliBLU = ["heliL", "heliH"];
	CSWR_groupTypesForSpwnsParaBLU = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	// OpFor spawns:
	CSWR_spwnsOPF     = ((CSWR_confirmedMarkers # 0) # 1) # 0;
	CSWR_spwnsVehOPF  = ((CSWR_confirmedMarkers # 0) # 1) # 1;
	CSWR_spwnsHeliOPF = ((CSWR_confirmedMarkers # 0) # 1) # 2;
	CSWR_spwnsParaOPF = ((CSWR_confirmedMarkers # 0) # 1) # 3;
	CSWR_spwnsAllOPF  = CSWR_spwnsOPF + CSWR_spwnsVehOPF + CSWR_spwnsHeliOPF + CSWR_spwnsParaOPF;
	CSWR_groupTypesForSpwnsOPF     = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsVehOPF  = ["vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsHeliOPF = ["heliL", "heliH"];
	CSWR_groupTypesForSpwnsParaOPF = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	// Independent spawns:
	CSWR_spwnsIND     = ((CSWR_confirmedMarkers # 0) # 2) # 0;
	CSWR_spwnsVehIND  = ((CSWR_confirmedMarkers # 0) # 2) # 1;
	CSWR_spwnsHeliIND = ((CSWR_confirmedMarkers # 0) # 2) # 2;
	CSWR_spwnsParaIND = ((CSWR_confirmedMarkers # 0) # 2) # 3;
	CSWR_spwnsAllIND  = CSWR_spwnsIND + CSWR_spwnsVehIND + CSWR_spwnsHeliIND + CSWR_spwnsParaIND;
	CSWR_groupTypesForSpwnsIND     = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsVehIND  = ["vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsHeliIND = ["heliL", "heliH"];
	CSWR_groupTypesForSpwnsParaIND = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS", "vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	// Civilian spawns:
	CSWR_spwnsCIV     = ((CSWR_confirmedMarkers # 0) # 3) # 0;
	CSWR_spwnsVehCIV  = ((CSWR_confirmedMarkers # 0) # 3) # 1;
	CSWR_spwnsHeliCIV = ((CSWR_confirmedMarkers # 0) # 3) # 2;
	CSWR_spwnsParaCIV = ((CSWR_confirmedMarkers # 0) # 3) # 3;
	CSWR_spwnsAllCIV  = CSWR_spwnsCIV + CSWR_spwnsVehCIV + CSWR_spwnsHeliCIV + CSWR_spwnsParaCIV;
	CSWR_groupTypesForSpwnsCIV     = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "vehL", "vehM", "vehC1", "vehH", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsVehCIV  = ["vehL", "vehM", "vehH", "vehC1", "vehC2", "vehC3"];
	CSWR_groupTypesForSpwnsHeliCIV = ["heliL", "heliH"];
	CSWR_groupTypesForSpwnsParaCIV = ["teamL", "teamM", "teamH", "teamC1", "teamC2", "teamC3", "teamS"];
	// All spawns:
	CSWR_spwnsAll = CSWR_spwnsAllBLU + CSWR_spwnsAllOPF + CSWR_spwnsAllIND + CSWR_spwnsAllCIV;
	// Spawn special actions > building helipad:
	if CSWR_shouldAddHelipadSpwn then { _helipad = "Land_HelipadSquare_F" } else { _helipad = "Land_HelipadEmpty_F" };
	{ _helipad createVehicle markerPos _x } forEach CSWR_spwnsHeliBLU + CSWR_spwnsHeliOPF + CSWR_spwnsHeliIND + CSWR_spwnsHeliCIV;


	// DESTINATION:
	// Where each side in-game will move randomly.
	/*
	Structure of destination arrays: CSWR_confirmedMarkers
	[0 spawn types
		...
	],
	[1 destination types
		[0 blu
			[0 CSWR_destBLU],
			[1 CSWR_destWatchBLU],
			[2 CSWR_destOccupyBLU],
			[3 CSWR_destHoldBLU]
		],
		[1 opf
			[0 CSWR_destOPF],
			[1 CSWR_destWatchOPF],
			[2 CSWR_destOccupyOPF],
			[3 CSWR_destHoldOPF]
		],
		[2 ind
			[0 CSWR_destIND],
			[1 CSWR_destWatchIND],
			[2 CSWR_destOccupyIND],
			[3 CSWR_destHoldIND]
		],
		[3 civ
			[0 CSWR_destCIV],
			[1 CSWR_destWatchCIV],
			[2 CSWR_destOccupyCIV],
			[3 CSWR_destHoldCIV]
		],
		[4 public
			[0 CSWR_destsPUBLIC]
		]
	];
	*/
	// Only BluFor destinations:
	CSWR_destBLU       = ((CSWR_confirmedMarkers # 1) # 0) # 0;
	CSWR_destWatchBLU  = ((CSWR_confirmedMarkers # 1) # 0) # 1;
	CSWR_destOccupyBLU = ((CSWR_confirmedMarkers # 1) # 0) # 2;
	CSWR_destHoldBLU   = ((CSWR_confirmedMarkers # 1) # 0) # 3;
	CSWR_destsAllBLU   = CSWR_destBLU + CSWR_destWatchBLU + CSWR_destOccupyBLU + CSWR_destHoldBLU;  // NEVER include PUBLICs in this calc!
	// Only OpFor destinations:
	CSWR_destOPF       = ((CSWR_confirmedMarkers # 1) # 1) # 0;
	CSWR_destWatchOPF  = ((CSWR_confirmedMarkers # 1) # 1) # 1;
	CSWR_destOccupyOPF = ((CSWR_confirmedMarkers # 1) # 1) # 2;
	CSWR_destHoldOPF   = ((CSWR_confirmedMarkers # 1) # 1) # 3;
	CSWR_destsAllOPF   = CSWR_destOPF + CSWR_destWatchOPF + CSWR_destOccupyOPF + CSWR_destHoldOPF;  // NEVER include PUBLICs in this calc!
	// Only Independent destinations:
	CSWR_destIND       = ((CSWR_confirmedMarkers # 1) # 2) # 0;
	CSWR_destWatchIND  = ((CSWR_confirmedMarkers # 1) # 2) # 1;
	CSWR_destOccupyIND = ((CSWR_confirmedMarkers # 1) # 2) # 2;
	CSWR_destHoldIND   = ((CSWR_confirmedMarkers # 1) # 2) # 3;
	CSWR_destsAllIND   = CSWR_destIND + CSWR_destWatchIND + CSWR_destOccupyIND + CSWR_destHoldIND;  // NEVER include PUBLICs in this calc!
	// Only Civilians destinations:
	CSWR_destCIV       = ((CSWR_confirmedMarkers # 1) # 3) # 0;  // CIV has no restricted-move, actually. Reserved space only.
	CSWR_destWatchCIV  = ((CSWR_confirmedMarkers # 1) # 3) # 1;  // CIV has no watch-move, actually. Reserved space only.
	CSWR_destOccupyCIV = ((CSWR_confirmedMarkers # 1) # 3) # 2;
	CSWR_destHoldCIV   = ((CSWR_confirmedMarkers # 1) # 3) # 3;
	CSWR_destsAllCIV   = CSWR_destCIV + CSWR_destWatchCIV + CSWR_destOccupyCIV + CSWR_destHoldCIV;  // NEVER include PUBLICs in this calc!
	// Civilian and soldier destinations:
	CSWR_destsPUBLIC   = ((CSWR_confirmedMarkers # 1) # 4) # 0;
	// Specialized destinations:
	CSWR_destsSpecial = CSWR_destWatchBLU + CSWR_destWatchOPF + CSWR_destWatchIND + CSWR_destWatchCIV +        // watch
						CSWR_destOccupyBLU + CSWR_destOccupyOPF + CSWR_destOccupyIND + CSWR_destOccupyCIV +    // occupy
						CSWR_destHoldBLU + CSWR_destHoldOPF + CSWR_destHoldIND + CSWR_destHoldCIV;             // hold
	// All destinations, except the specialized/special ones:
	CSWR_destsANYWHERE  = CSWR_destsPUBLIC + CSWR_destBLU + CSWR_destOPF + CSWR_destIND + CSWR_destCIV;
	// Occupy-move validations:
	CSWR_bldgsAvailableBLU = [CSWR_isOnBLU, CSWR_destOccupyBLU, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_side;
	CSWR_bldgsAvailableOPF = [CSWR_isOnOPF, CSWR_destOccupyOPF, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_side;
	CSWR_bldgsAvailableIND = [CSWR_isOnIND, CSWR_destOccupyIND, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_side;
	CSWR_bldgsAvailableCIV = [CSWR_isOnCIV, CSWR_destOccupyCIV, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_side;
	// Hold-move ground cleaner:
	if CSWR_isOnBLU then { [CSWR_destHoldBLU] call THY_fnc_CSWR_HOLD_ground_cleaner };
	if CSWR_isOnOPF then { [CSWR_destHoldOPF] call THY_fnc_CSWR_HOLD_ground_cleaner };
	if CSWR_isOnIND then { [CSWR_destHoldIND] call THY_fnc_CSWR_HOLD_ground_cleaner };
	if CSWR_isOnCIV then { [CSWR_destHoldCIV] call THY_fnc_CSWR_HOLD_ground_cleaner };
	// Debug markers stylish:
	if CSWR_isOnDebugGlobal then {
		// Visibility and colors:
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorBLUFOR"      } forEach CSWR_spwnsAllBLU + CSWR_destsAllBLU;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorOPFOR"       } forEach CSWR_spwnsAllOPF + CSWR_destsAllOPF;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorIndependent" } forEach CSWR_spwnsAllIND + CSWR_destsAllIND;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorCivilian"    } forEach CSWR_spwnsAllCIV + CSWR_destsAllCIV;
		{ _x setMarkerAlpha 1; _x setMarkerColor "colorUNKNOWN"     } forEach CSWR_destsPUBLIC;
		// Shapes:
		{ _x setMarkerType "mil_destroy";        _x setMarkerAlpha 0.5 } forEach CSWR_destWatchBLU + CSWR_destWatchOPF + CSWR_destWatchIND + CSWR_destWatchCIV;
		{ _x setMarkerType "mil_start_noShadow"; _x setMarkerAlpha 0.5 } forEach CSWR_destHoldBLU + CSWR_destHoldOPF + CSWR_destHoldIND + CSWR_destHoldCIV;
	// Otherwise, hiding the spawn and destination markers:
	} else { {_x setMarkerAlpha 0} forEach CSWR_spwnsAll + CSWR_destsANYWHERE + CSWR_destsSpecial };
	// Delete the useless spawn markers only, preserving the destinations:
	if !CSWR_isOnBLU then { { deleteMarker _x } forEach CSWR_spwnsAllBLU + CSWR_destsAllBLU };
	if !CSWR_isOnOPF then { { deleteMarker _x } forEach CSWR_spwnsAllOPF + CSWR_destsAllOPF };
	if !CSWR_isOnIND then { { deleteMarker _x } forEach CSWR_spwnsAllIND + CSWR_destsAllIND };
	if !CSWR_isOnCIV then { { deleteMarker _x } forEach CSWR_spwnsAllCIV + CSWR_destsAllCIV };
	// Destroying useless things:
	CSWR_spwnsAll     = nil;
	CSWR_destsSpecial = nil;
	// Minimal amount of each type of destination by side for a correctly script execution:
	CSWR_minDestAny        = 2;
	CSWR_minDestRestricted = 2; 
	CSWR_minDestWatch      = 1; 
	CSWR_minDestOccupy     = 1; 
	CSWR_minDestHold       = 2; 
	CSWR_minDestPublic     = 2;
	// Global object declarations:
	publicVariable "CSWR_isOnDebugGlobal";
	publicVariable "CSWR_isOnDebugOccupy";
	publicVariable "CSWR_isOnDebugWatch";
	publicVariable "CSWR_isOnDebugHeli";
	publicVariable "CSWR_isOnDebugPara";
	publicVariable "CSWR_isOnDebugBooking";
	publicVariable "CSWR_isOnDebugHold";
	publicVariable "CSWR_isOnBLU";
	publicVariable "CSWR_isOnOPF";
	publicVariable "CSWR_isOnIND";
	publicVariable "CSWR_isOnCIV";
	publicVariable "CSWR_isBackpackForAllByFoot";
	publicVariable "CSWR_isVestForAll";
	publicVariable "CSWR_canNvgInfantryBLU";
	publicVariable "CSWR_canNvgParatroopsBLU";
	publicVariable "CSWR_canNvgSnipersBLU";
	publicVariable "CSWR_nvgDeviceBLU";
	publicVariable "CSWR_canFlashlightBLU";
	publicVariable "CSWR_flashlightDeviceBLU";
	publicVariable "CSWR_canNvgInfantryOPF";
	publicVariable "CSWR_canNvgParatroopsOPF";
	publicVariable "CSWR_canNvgSnipersOPF";
	publicVariable "CSWR_nvgDeviceOPF";
	publicVariable "CSWR_canFlashlightOPF";
	publicVariable "CSWR_flashlightDeviceOPF";
	publicVariable "CSWR_canNvgInfantryIND";
	publicVariable "CSWR_canNvgParatroopsIND";
	publicVariable "CSWR_canNvgSnipersIND";
	publicVariable "CSWR_nvgDeviceIND";
	publicVariable "CSWR_canFlashlightIND";
	publicVariable "CSWR_flashlightDeviceIND";
	publicVariable "CSWR_canNvgCIV";
	publicVariable "CSWR_nvgDeviceCIV";
	/* publicVariable "CSWR_voiceBLU";
	publicVariable "CSWR_voiceOPF";
	publicVariable "CSWR_voiceIND";
	publicVariable "CSWR_voiceCIV"; */
	publicVariable "CSWR_isHoldVehLightsOff";
	/* publicVariable "CSWR_isUnlimitedFuel";
	publicVariable "CSWR_isUnlimitedAmmo"; */
	publicVariable "CSWR_isHeliSpwningInAir";
	publicVariable "CSWR_shouldAddHelipadSpwn";
	publicVariable "CSWR_isElectroWarForBLU";
	publicVariable "CSWR_isElectroWarForOPF";
	publicVariable "CSWR_isElectroWarForIND";
	//publicVariable "CSWR_reportToRadioAllies";
	publicVariable "CSWR_spwnHeliOnShipFloor";
	publicVariable "CSWR_serverMaxFPS";
	publicVariable "CSWR_serverMinFPS";
	//publicVariable "CSWR_aiAmoutLimit";
	publicVariable "CSWR_isEditableByZeus";
	publicVariable "CSWR_destCommonTakeabreak";
	publicVariable "CSWR_destOccupyTakeabreak";
	publicVariable "CSWR_destHoldTakeabreak";
	publicVariable "CSWR_heliTakeoffDelay";
	publicVariable "CSWR_watchMarkerRange";
	publicVariable "CSWR_occupyMarkerRange";
	publicVariable "CSWR_spwnsParaUnitAlt";
	publicVariable "CSWR_spwnsParaVehAlt";
	publicVariable "CSWR_heliLightAlt";
	publicVariable "CSWR_heliHeavyAlt";
	publicVariable "CSWR_occupyIgnoredBuildings";
	publicVariable "CSWR_occupyIgnoredPositions";
	publicVariable "CSWR_occupyAcceptableRuins";
	publicVariable "CSWR_paraAcceptableGoggles";
	publicVariable "CSWR_civOutfits";
	publicVariable "CSWR_wait";
	publicVariable "CSWR_txtDebugHeader";
	publicVariable "CSWR_txtWarnHeader";
	publicVariable "CSWR_bookedLocWatch";
	publicVariable "CSWR_bookedLocHold";
	publicVariable "CSWR_bookedLocSpwnVeh";
	publicVariable "CSWR_bookedLocSpwnHeli";
	publicVariable "CSWR_spwnDelayQueueAmount";
	publicVariable "CSWR_prefix";
	publicVariable "CSWR_spacer";
	publicVariable "CSWR_vehGroundHeavy";
	publicVariable "CSWR_confirmedMarkers";
	publicVariable "CSWR_spwnsBLU";
	publicVariable "CSWR_spwnsVehBLU";
	publicVariable "CSWR_spwnsHeliBLU";
	publicVariable "CSWR_spwnsAllBLU";
	publicVariable "CSWR_groupTypesForSpwnsBLU";
	publicVariable "CSWR_groupTypesForSpwnsVehBLU";
	publicVariable "CSWR_groupTypesForSpwnsHeliBLU";
	publicVariable "CSWR_groupTypesForSpwnsParaBLU";
	publicVariable "CSWR_spwnsOPF";
	publicVariable "CSWR_spwnsVehOPF";
	publicVariable "CSWR_spwnsHeliOPF";
	publicVariable "CSWR_spwnsAllOPF";
	publicVariable "CSWR_groupTypesForSpwnsOPF";
	publicVariable "CSWR_groupTypesForSpwnsVehOPF";
	publicVariable "CSWR_groupTypesForSpwnsHeliOPF";
	publicVariable "CSWR_groupTypesForSpwnsParaOPF";
	publicVariable "CSWR_spwnsIND";
	publicVariable "CSWR_spwnsVehIND";
	publicVariable "CSWR_spwnsHeliIND";
	publicVariable "CSWR_spwnsAllIND";
	publicVariable "CSWR_groupTypesForSpwnsIND";
	publicVariable "CSWR_groupTypesForSpwnsVehIND";
	publicVariable "CSWR_groupTypesForSpwnsHeliIND";
	publicVariable "CSWR_groupTypesForSpwnsParaIND";
	publicVariable "CSWR_spwnsCIV"; 
	publicVariable "CSWR_spwnsVehCIV";
	publicVariable "CSWR_spwnsHeliCIV";
	publicVariable "CSWR_spwnsAllCIV";
	publicVariable "CSWR_groupTypesForSpwnsCIV";
	publicVariable "CSWR_groupTypesForSpwnsVehCIV";
	publicVariable "CSWR_groupTypesForSpwnsHeliCIV";
	publicVariable "CSWR_groupTypesForSpwnsParaCIV";
	publicVariable "CSWR_spwnsAll";
	publicVariable "CSWR_destBLU";
	publicVariable "CSWR_destWatchBLU"; 
	publicVariable "CSWR_destOccupyBLU";
	publicVariable "CSWR_destHoldBLU";
	publicVariable "CSWR_destsAllBLU"; 
	publicVariable "CSWR_destOPF"; 
	publicVariable "CSWR_destWatchOPF"; 
	publicVariable "CSWR_destOccupyOPF";
	publicVariable "CSWR_destHoldOPF";
	publicVariable "CSWR_destsAllOPF"; 
	publicVariable "CSWR_destIND"; 
	publicVariable "CSWR_destWatchIND";
	publicVariable "CSWR_destOccupyIND";
	publicVariable "CSWR_destHoldIND"; 
	publicVariable "CSWR_destsAllIND"; 
	publicVariable "CSWR_destCIV";
	publicVariable "CSWR_destWatchCIV";
	publicVariable "CSWR_destOccupyCIV";
	publicVariable "CSWR_destHoldCIV";
	publicVariable "CSWR_destsAllCIV";
	publicVariable "CSWR_destsPUBLIC"; 
	publicVariable "CSWR_destsSpecial"; 
	publicVariable "CSWR_destsANYWHERE"; 
	publicVariable "CSWR_bldgsAvailableBLU"; 
	publicVariable "CSWR_bldgsAvailableOPF"; 
	publicVariable "CSWR_bldgsAvailableIND"; 
	publicVariable "CSWR_bldgsAvailableCIV"; 
	publicVariable "CSWR_minDestAny";
	publicVariable "CSWR_minDestRestricted"; 
	publicVariable "CSWR_minDestWatch"; 
	publicVariable "CSWR_minDestOccupy"; 
	publicVariable "CSWR_minDestHold"; 
	publicVariable "CSWR_minDestPublic";
	// Debug messages:
	if CSWR_isOnDebugGlobal then {
		// If the specific side is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnBLU AND count CSWR_spwnsAllBLU > 0 ) then {
			// If one of each side destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destBLU >= CSWR_minDestRestricted OR count CSWR_destWatchBLU >= CSWR_minDestWatch OR count CSWR_destOccupyBLU >= CSWR_minDestOccupy OR count CSWR_destHoldBLU >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 SIDE BLU > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllBLU, count CSWR_destsAllBLU, count CSWR_destsPUBLIC];
			};
		};
		// If the specific side is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnOPF AND count CSWR_spwnsAllOPF > 0 ) then {
			// If one of each side destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destOPF >= CSWR_minDestRestricted OR count CSWR_destWatchOPF >= CSWR_minDestWatch OR count CSWR_destOccupyOPF >= CSWR_minDestOccupy OR count CSWR_destHoldOPF >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 SIDE OPF > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllOPF, count CSWR_destsAllOPF, count CSWR_destsPUBLIC];
			};
		};
		// If the specific side is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnIND AND count CSWR_spwnsAllIND > 0 ) then {
			// If one of each side destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destIND >= CSWR_minDestRestricted OR count CSWR_destWatchIND >= CSWR_minDestWatch OR count CSWR_destOccupyIND >= CSWR_minDestOccupy OR count CSWR_destHoldIND >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 SIDE IND > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllIND, count CSWR_destsAllIND, count CSWR_destsPUBLIC];
			};
		};
		// If the specific side is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnCIV AND count CSWR_spwnsAllCIV > 0 ) then {
			// If one of each side destination type has at least 2 destination points, show the debug message:
			if ( /* count CSWR_destCIV >= CSWR_minDestRestricted OR count CSWR_destWatchCIV >= CSWR_minDestWatch OR */ count CSWR_destOccupyCIV >= CSWR_minDestOccupy OR count CSWR_destHoldCIV >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 SIDE CIV > Got %2 spawn(s), %3 side destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllCIV, count CSWR_destsAllCIV, count CSWR_destsPUBLIC];
			};
		};
	};
	// Debug monitor looping:
	while { CSWR_isOnDebugGlobal } do { call THY_fnc_CSWR_debug };
};
// Return:
true;
