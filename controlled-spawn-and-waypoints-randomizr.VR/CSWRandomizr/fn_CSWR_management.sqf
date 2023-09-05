// CSWR v4.5
// File: your_mission\CSWRandomizr\fn_CSWR_management.sqf
// by thy (@aldolammel)

if (!isServer) exitWith {};

// PARAMETERS OF EDITOR'S OPTIONS:
// Debug:
	CSWR_isOnDebugGlobal = true;     // true = shows basic debug informations only for mission editor / false = turn it off. Default: false.
	CSWR_isOnDebugOccupy = false;     // true = if debug global true, it shows deeper Occupy-markers debug info / false = turn it off. Default: false.
	CSWR_isOnDebugWatch = false;     // true = if debug global true, it shows deeper Watch-markers debug info / false = turn it off. Default: false.
	CSWR_isOnDebugHold = false;     // true = if debug global true, it shows deeper Hold-markers debug info / false = turn it off. Default: false.
// Factions:
	CSWR_isOnBLU = true;     // true = if you wanna spawn BluFor/West through CSWR / false = no spawn.
	CSWR_isOnOPF = true;    // true = if you wanna spawn OpFor/East through CSWR / false = no spawn.
	CSWR_isOnIND = true;    // true = if you wanna spawn Indepdentent/Resistence through CSWR / false = no spawn.
	CSWR_isOnCIV = false;    // true = if you wanna spawn Civilians through CSWR / false = no spawn.
// Others:
	CSWR_isBackpackForAll = false;    // true = if editor sets a custom backpack, all units will get it / false = only units originally with backpack will get it. Default: false.
	CSWR_isVestForAll = false;        // true = if editor sets a custom vest, almost all units will get it / false = only units originally with vest will get it. Default: false.
	CSWR_isHoldVehLightsOff = false;   // true = all vehicles on hold-movement will turn its lights off / false = only vehicles with stealth behavior will turn lights off. Default: false.
	CSWR_isUnlimitedFuel = false;     // WIP
	CSWR_isUnlimitedAmmo = false;     // WIP
	CSWR_isEditableByZeus = true;     // true = CSWR units and CSWR vehicles can be manipulated when Zeus is available / false = no editable. Default: true.
	CSWR_wait = 1;                    // If you need to make CSWR waits more for other scripts load first, set a delay in seconds. Default: 1.

	// MOVEMENT ADVANCED SETTINGS:
	// Time:
		CSWR_destCommonTakeabreak = [5, 30, 60];  // In seconds, how long each group can stay on its Move-markers. Default: 5 sec, 30 sec, 60 sec
		CSWR_destOccupyTakeabreak = [300, 600, 1200];  // In seconds, how long each group can stay on its Occupy-markers. Default: 5min (300), 10min (600), 20min (1200)
		CSWR_destHoldTakeabreak   = [1800, 3600, 7200];   // In seconds, how long each group can stay on its Hold-markers. Default: 30min (1800), 1h (3600), 2h (7200)
	// Ranges:
		CSWR_watchMarkerRange = 1000;  // In meters, size of marker range used to find buildings to watch/sniper group. Default: 500.
		CSWR_occupyMarkerRange = 200;  // In meters, size of marker range used to find buildings to occupy. Default: 200.
		
	// Exceptions management:
		// What specific building positions must be ignored for all factions. Use getPosATL ([ [x1,y1,z1], [x2,y2,z2] ]) to exclude the position:
		CSWR_occupyIgnoredPositions = [  ];
		// What building classnames must be ignored for all factions:
		CSWR_occupyIgnoredBuildings = ["Land_Pier_F", "Land_Pier_small_F", "Land_Lighhouse_small_F", "Land_PowerPoleWooden_L_F", "Land_LampStreet_small_F", "Land_dp_smallTank_F", "Land_LampHalogen_F", "Land_LampDecor_F", "Land_FuelStation_Feed_F", "Land_spp_Transformer_F", "Land_FuelStation_Build_F", "Land_Addon_01_F", "Land_u_Addon_01_V1_F", "Land_Addon_03_F", "Land_Shed_Big_F", "Land_Shed_03_F", "Land_Shed_05_F", "Land_Track_01_bridge_F", "Land_SCF_01_storageBin_small_F", "Land_SCF_01_storageBin_medium_F", "Land_StorageTank_01_small_F", "Land_StorageTank_01_large_F", "Land_Shop_City_04_F", "Land_Shop_City_05_F", "Land_Shop_City_06_F", "Land_Shop_City_07_F", "Land_Shop_Town_02_F", "Land_Shop_Town_05_F", "Land_FireEscape_01_tall_F", "Land_FireEscape_01_short_F", "Land_Offices_01_V1_F", "Land_MultistoryBuilding_03_F", "Land_MultistoryBuilding_04_F", "Land_Hotel_02_F", "Land_House_Big_05_F", "Land_Workshop_04_F", "Land_Church_01_F", "Land_Church_01_V2_F", "Land_Church_02_F", "Land_ContainerLine_01_F", "Land_ContainerLine_02_F", "Land_ContainerLine_03_F", "Land_Warehouse_02_F", "Land_Warehouse_01_F", "Land_Tents_Refugee_Red_lxWS", "Land_Tents_Refugee_Green_lxWS", "Land_Tents_Refugee_Orange_lxWS", "Land_Tents_Refugee_lxWS", "Land_Tents_Refugee_Pattern_lxWS", "Land_Tents_Refugee_Blue_lxWS", "Land_Tents_Refugee_Dirty_lxWS", "Land_Tents_Refugee_DBrown_lxWS"];
		// What ruins should be considered for occupy-movement (Important: if the ruin has no spots in its 3D, CSWR won't include it as option):
		CSWR_occupyAcceptableRuins = ["Land_HouseRuin_Big_01_F", "Land_HouseRuin_Big_01_half_F", "Land_HouseRuin_Big_02_half_F", "Land_HouseRuin_Big_02_F", "Land_HouseRuin_Big_04_F", "Land_OrthodoxChurch_03_ruins_F", "Land_ControlTower_01_ruins_F", "Land_ChurchRuin_01_F", "Land_Shop_Town_01_ruins_F", "Land_House_Big_01_V1_ruins_F", "Land_BellTower_02_V2_ruins_F", "Land_HouseRuin_Small_02_F", "Land_HouseRuin_Small_04_F", "Land_HouseRuin_Big_03_half_F", "Land_HouseRuin_Big_03_F", "Land_House_Small_01_b_brown_ruins_F", "Land_House_Small_01_b_yellow_ruins_F", "Land_Barn_01_grey_ruins_F", "Land_Barn_01_brown_ruins_F", "Land_Shop_02_b_yellow_ruins_F", "Land_House_Big_02_b_brown_ruins_F", "Land_House_Big_02_b_pink_ruins_F", "Land_House_Big_02_b_blue_ruins_F", "Land_House_Big_01_b_blue_ruins_F", "Land_House_Big_01_b_brown_ruins_F", "Land_House_Big_01_b_pink_ruins_F"];


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------
// When the mission starts:
[] spawn {
	// Local object declarations:
	//private [];
	// Debug txts:
	CSWR_txtDebugHeader = "CSWR DEBUG >";
	CSWR_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	CSWR_watchReservedLocation = [[],[],[]];  // [[blu],[opf],[ind]]
	CSWR_holdReservedLocation = [[],[],[],[]];  // [[blu],[opf],[ind],[civ]]
	CSWR_spwnDelayQueueAmount = 0;
	// Declarations:
	CSWR_prefix = "CSWR";  // CAUTION: NEVER include/insert the CSWR_spacer character as part of the CSWR_prefix too.
	CSWR_spacer = "_";  // CAUTION: try do not change it!
	// Main markers validation:
	CSWR_confirmedMarkers = [CSWR_prefix, CSWR_spacer] call THY_fnc_CSWR_marker_scanner;
	// Errors handling:
	if ( CSWR_wait < 1 ) then { CSWR_wait = 1 };  // Important to hold some functions and make their warning (if has) to show only in-game for mission editor.
	if CSWR_isOnDebugGlobal then {
		if ( CSWR_wait >= 5 ) then { systemChat format ["%1 Don't forget the CSWR is configurated to delay %2 seconds before to starts its tasks.", CSWR_txtDebugHeader, CSWR_wait] };
	};
	if ( !CSWR_isOnDebugGlobal ) then {
		if ( CSWR_destOccupyTakeabreak # 0 < 300 OR CSWR_destOccupyTakeabreak # 1 < 300 OR CSWR_destOccupyTakeabreak # 2 < 300 ) then { systemChat format ["%1 OCCUPY > For good combat experince, don't use 'CSWR_destOccupyTakeabreak' values less than 5min (300secs) out of debug mode. Default values have been restored.", CSWR_txtWarningHeader]; CSWR_destOccupyTakeabreak=[300,600,1200] };
		if ( CSWR_destHoldTakeabreak # 0 < 300 OR CSWR_destHoldTakeabreak # 1 < 300 OR CSWR_destHoldTakeabreak # 2 < 300 ) then { systemChat format ["%1 HOLD > For good combat experince, don't use 'CSWR_destHoldTakeabreak' values less than 5min (300secs) out of debug mode. Default values have been restored.", CSWR_txtWarningHeader]; CSWR_destHoldTakeabreak=[1800,7200,10800] };
		if ( CSWR_watchMarkerRange < 100 ) then { systemChat format ["%1 WATCH > For good combat experince, don't use 'CSWR_watchMarkerRange' value less than 100 meters out of debug mode. Default value has been restored.", CSWR_txtWarningHeader]; CSWR_watchMarkerRange=500 };
		if ( CSWR_occupyMarkerRange < 100 ) then { systemChat format ["%1 OCCUPY > For good combat experince, don't use 'CSWR_occupyMarkerRange' value less than 100 meters out of debug mode. Default value has been restored.", CSWR_txtWarningHeader]; CSWR_occupyMarkerRange=200 };
	};
	
	// SPAWNPOINTS:
	// Where each faction in-game will spawn randomly.
	// [ [ [ [spwblu],[spwbluV] ], [ [spwopf],[spwopfV] ], [ [spwind],[spwindV] ], [ [spwciv],[spwcivV] ] ], [dests] ];
	// BluFor spawns:
	CSWR_spwnsBLU     = ((CSWR_confirmedMarkers # 0) # 0) # 0;
	CSWR_spwnsVehBLU  = ((CSWR_confirmedMarkers # 0) # 0) # 1;
	CSWR_spwnsAllBLU  = CSWR_spwnsBLU + CSWR_spwnsVehBLU;
	// OpFor spawns:
	CSWR_spwnsOPF     = ((CSWR_confirmedMarkers # 0) # 1) # 0;
	CSWR_spwnsVehOPF  = ((CSWR_confirmedMarkers # 0) # 1) # 1;
	CSWR_spwnsAllOPF  = CSWR_spwnsOPF + CSWR_spwnsVehOPF;
	// Independent spawns:
	CSWR_spwnsIND     = ((CSWR_confirmedMarkers # 0) # 2) # 0;
	CSWR_spwnsVehIND  = ((CSWR_confirmedMarkers # 0) # 2) # 1;
	CSWR_spwnsAllIND  = CSWR_spwnsIND + CSWR_spwnsVehIND;
	// Civilian spawns:
	CSWR_spwnsCIV     = ((CSWR_confirmedMarkers # 0) # 3) # 0;
	CSWR_spwnsVehCIV  = ((CSWR_confirmedMarkers # 0) # 3) # 1;
	CSWR_spwnsAllCIV  = CSWR_spwnsCIV + CSWR_spwnsVehCIV;
	// All spawns:
	CSWR_spwnsAll     = CSWR_spwnsAllBLU + CSWR_spwnsAllOPF + CSWR_spwnsAllIND + CSWR_spwnsAllCIV;

	// DESTINATION POINTS:
	// Where each faction in-game will move randomly.
	// [ [spw], [ [ [moveBlu],[watchBlu],[occupyBlu],[holdBlu] ], [ [moveOpf],[watchOpf],[occupyOpf],[holdOpf] ], [ [moveInd],[watchInd],[occupyInd],[holdInd] ], [ [moveCiv],[watchCiv],[occupyCiv],[holdCiv] ], [ [movePublic] ] ] ];
	// Only BluFor destinations:
	CSWR_destsBLU         = ((CSWR_confirmedMarkers # 1) # 0) # 0;
	CSWR_destsWatchBLU    = ((CSWR_confirmedMarkers # 1) # 0) # 1;
	CSWR_destsOccupyBLU   = ((CSWR_confirmedMarkers # 1) # 0) # 2;
	CSWR_destsHoldBLU     = ((CSWR_confirmedMarkers # 1) # 0) # 3;
	CSWR_destsAllBLU      =  CSWR_destsBLU + CSWR_destsWatchBLU + CSWR_destsOccupyBLU + CSWR_destsHoldBLU;  // NEVER include PUBLICs in this calc!
	// Only OpFor destinations:
	CSWR_destsOPF         = ((CSWR_confirmedMarkers # 1) # 1) # 0;
	CSWR_destsWatchOPF    = ((CSWR_confirmedMarkers # 1) # 1) # 1;
	CSWR_destsOccupyOPF   = ((CSWR_confirmedMarkers # 1) # 1) # 2;
	CSWR_destsHoldOPF     = ((CSWR_confirmedMarkers # 1) # 1) # 3;
	CSWR_destsAllOPF      =  CSWR_destsOPF + CSWR_destsWatchOPF + CSWR_destsOccupyOPF + CSWR_destsHoldOPF;  // NEVER include PUBLICs in this calc!
	// Only Independent destinations:
	CSWR_destsIND         = ((CSWR_confirmedMarkers # 1) # 2) # 0;
	CSWR_destsWatchIND    = ((CSWR_confirmedMarkers # 1) # 2) # 1;
	CSWR_destsOccupyIND   = ((CSWR_confirmedMarkers # 1) # 2) # 2;
	CSWR_destsHoldIND     = ((CSWR_confirmedMarkers # 1) # 2) # 3;
	CSWR_destsAllIND      =  CSWR_destsIND + CSWR_destsWatchIND + CSWR_destsOccupyIND + CSWR_destsHoldIND;  // NEVER include PUBLICs in this calc!
	// Only Civilians destinations:
	CSWR_destsCIV         = ((CSWR_confirmedMarkers # 1) # 3) # 0;
	CSWR_destsWatchCIV    = ((CSWR_confirmedMarkers # 1) # 3) # 1;
	CSWR_destsOccupyCIV   = ((CSWR_confirmedMarkers # 1) # 3) # 2;
	CSWR_destsHoldCIV     = ((CSWR_confirmedMarkers # 1) # 3) # 3;
	CSWR_destsAllCIV      =  CSWR_destsCIV + CSWR_destsWatchCIV + CSWR_destsOccupyCIV + CSWR_destsHoldCIV;  // NEVER include PUBLICs in this calc!
	// Civilian and soldier destinations:
	CSWR_destsPUBLIC       = ((CSWR_confirmedMarkers # 1) # 4) # 0;
	// Specialized destinations:
	CSWR_destsSpecial     = CSWR_destsWatchBLU + CSWR_destsWatchOPF + CSWR_destsWatchIND + CSWR_destsWatchCIV + 
							CSWR_destsOccupyBLU + CSWR_destsOccupyOPF + CSWR_destsOccupyIND + CSWR_destsOccupyCIV + 
							CSWR_destsHoldBLU + CSWR_destsHoldOPF + CSWR_destsHoldIND + CSWR_destsHoldCIV;
	// All destinations, except the specialized/special ones:
	CSWR_destsANYWHERE    = CSWR_destsPUBLIC + CSWR_destsBLU + CSWR_destsOPF + CSWR_destsIND + CSWR_destsCIV;
	// Occupy validations:
	CSWR_bldgsAvailableBLU = [CSWR_isOnBLU, CSWR_destsOccupyBLU, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_faction;
	CSWR_bldgsAvailableOPF = [CSWR_isOnOPF, CSWR_destsOccupyOPF, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_faction;
	CSWR_bldgsAvailableIND = [CSWR_isOnIND, CSWR_destsOccupyIND, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_faction;
	CSWR_bldgsAvailableCIV = [CSWR_isOnCIV, CSWR_destsOccupyCIV, CSWR_occupyMarkerRange, CSWR_occupyIgnoredBuildings, CSWR_occupyIgnoredPositions] call THY_fnc_CSWR_OCCUPY_find_buildings_by_faction;
	// Debug markers stylish:
	if CSWR_isOnDebugGlobal then {
		{ _x setMarkerColor "colorBLUFOR"      } forEach CSWR_spwnsAllBLU + CSWR_destsAllBLU;
		{ _x setMarkerColor "colorOPFOR"       } forEach CSWR_spwnsAllOPF + CSWR_destsAllOPF;
		{ _x setMarkerColor "colorIndependent" } forEach CSWR_spwnsAllIND + CSWR_destsAllIND;
		{ _x setMarkerColor "colorCivilian"    } forEach CSWR_spwnsAllCIV + CSWR_destsAllCIV;
		{ _x setMarkerColor "colorUNKNOWN"     } forEach CSWR_destsPUBLIC;
	// Otherwise, hiding the spawn and destination markers:
	} else { {_x setMarkerAlpha 0} forEach CSWR_spwnsAll + CSWR_destsANYWHERE + CSWR_destsSpecial };
	// Delete the useless spawn markers only, preserving the destines:
	if ( !CSWR_isOnBLU ) then { { deleteMarker _x } forEach CSWR_spwnsAllBLU + CSWR_destsAllBLU };
	if ( !CSWR_isOnOPF ) then { { deleteMarker _x } forEach CSWR_spwnsAllOPF + CSWR_destsAllOPF };
	if ( !CSWR_isOnIND ) then { { deleteMarker _x } forEach CSWR_spwnsAllIND + CSWR_destsAllIND };
	if ( !CSWR_isOnCIV ) then { { deleteMarker _x } forEach CSWR_spwnsAllCIV + CSWR_destsAllCIV };
	// Destroying useless things:
	CSWR_spwnsAll = nil;
	CSWR_destsSpecial = nil;
	// Minimal amount of each type of destination by faction for a correctly script execution:
	CSWR_minDestAny = 2;
	CSWR_minDestRestricted = 2; 
	CSWR_minDestWatch = 1; 
	CSWR_minDestOccupy = 1; 
	CSWR_minDestHold = 2; 
	CSWR_minDestPublic = 2;
	// Global object declarations:
	publicVariable "CSWR_isOnDebugGlobal";
	publicVariable "CSWR_isOnDebugOccupy";
	publicVariable "CSWR_isOnDebugWatch";
	publicVariable "CSWR_isOnDebugHold";
	publicVariable "CSWR_isOnBLU";
	publicVariable "CSWR_isOnOPF";
	publicVariable "CSWR_isOnIND";
	publicVariable "CSWR_isOnCIV";
	publicVariable "CSWR_isBackpackForAll";
	publicVariable "CSWR_isVestForAll";
	publicVariable "CSWR_isHoldVehLightsOff";
	publicVariable "CSWR_isUnlimitedFuel";
	publicVariable "CSWR_isUnlimitedAmmo";
	publicVariable "CSWR_isEditableByZeus";
	publicVariable "CSWR_destCommonTakeabreak";
	publicVariable "CSWR_destOccupyTakeabreak";
	publicVariable "CSWR_destHoldTakeabreak"; 
	publicVariable "CSWR_watchMarkerRange";
	publicVariable "CSWR_occupyMarkerRange";
	publicVariable "CSWR_occupyIgnoredBuildings";
	publicVariable "CSWR_occupyIgnoredPositions";
	publicVariable "CSWR_occupyAcceptableRuins";
	publicVariable "CSWR_wait";
	publicVariable "CSWR_txtDebugHeader";
	publicVariable "CSWR_txtWarningHeader";
	publicVariable "CSWR_watchReservedLocation";
	publicVariable "CSWR_holdReservedLocation";
	publicVariable "CSWR_spwnDelayQueueAmount";
	publicVariable "CSWR_prefix";
	publicVariable "CSWR_spacer";
	publicVariable "CSWR_confirmedMarkers";
	publicVariable "CSWR_spwnsBLU";
	publicVariable "CSWR_spwnsVehBLU";
	publicVariable "CSWR_spwnsAllBLU";
	publicVariable "CSWR_spwnsOPF";
	publicVariable "CSWR_spwnsVehOPF";
	publicVariable "CSWR_spwnsAllOPF";
	publicVariable "CSWR_spwnsIND";
	publicVariable "CSWR_spwnsVehIND";
	publicVariable "CSWR_spwnsAllIND";
	publicVariable "CSWR_spwnsCIV"; 
	publicVariable "CSWR_spwnsVehCIV";
	publicVariable "CSWR_spwnsAllCIV";
	publicVariable "CSWR_spwnsAll";
	publicVariable "CSWR_destsBLU";
	publicVariable "CSWR_destsWatchBLU"; 
	publicVariable "CSWR_destsOccupyBLU";
	publicVariable "CSWR_destsHoldBLU";
	publicVariable "CSWR_destsAllBLU"; 
	publicVariable "CSWR_destsOPF"; 
	publicVariable "CSWR_destsWatchOPF"; 
	publicVariable "CSWR_destsOccupyOPF";
	publicVariable "CSWR_destsHoldOPF";
	publicVariable "CSWR_destsAllOPF"; 
	publicVariable "CSWR_destsIND"; 
	publicVariable "CSWR_destsWatchIND";
	publicVariable "CSWR_destsOccupyIND";
	publicVariable "CSWR_destsHoldIND"; 
	publicVariable "CSWR_destsAllIND"; 
	publicVariable "CSWR_destsCIV";
	publicVariable "CSWR_destsWatchCIV";
	publicVariable "CSWR_destsOccupyCIV";
	publicVariable "CSWR_destsHoldCIV";
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
		// If the specific faction is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnBLU AND count CSWR_spwnsAllBLU > 0 ) then {
			// If one of each faction destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destsBLU >= CSWR_minDestRestricted OR count CSWR_destsWatchBLU >= CSWR_minDestWatch OR count CSWR_destsOccupyBLU >= CSWR_minDestOccupy OR count CSWR_destsHoldBLU >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 FACTION BLU > Got %2 spawn(s), %3 faction destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllBLU, count CSWR_destsAllBLU, count CSWR_destsPUBLIC];
			};
		};
		// If the specific faction is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnOPF AND count CSWR_spwnsAllOPF > 0 ) then {
			// If one of each faction destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destsOPF >= CSWR_minDestRestricted OR count CSWR_destsWatchOPF >= CSWR_minDestWatch OR count CSWR_destsOccupyOPF >= CSWR_minDestOccupy OR count CSWR_destsHoldOPF >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 FACTION OPF > Got %2 spawn(s), %3 faction destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllOPF, count CSWR_destsAllOPF, count CSWR_destsPUBLIC];
			};
		};
		// If the specific faction is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnIND AND count CSWR_spwnsAllIND > 0 ) then {
			// If one of each faction destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destsIND >= CSWR_minDestRestricted OR count CSWR_destsWatchIND >= CSWR_minDestWatch OR count CSWR_destsOccupyIND >= CSWR_minDestOccupy OR count CSWR_destsHoldIND >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 FACTION IND > Got %2 spawn(s), %3 faction destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllIND, count CSWR_destsAllIND, count CSWR_destsPUBLIC];
			};
		};
		// If the specific faction is ON and has at least 1 spawnpoint, keep going:
		if ( CSWR_isOnCIV AND count CSWR_spwnsAllCIV > 0 ) then {
			// If one of each faction destination type has at least 2 destination points, show the debug message:
			if ( count CSWR_destsCIV >= CSWR_minDestRestricted OR count CSWR_destsWatchCIV >= CSWR_minDestWatch OR count CSWR_destsOccupyCIV >= CSWR_minDestOccupy OR count CSWR_destsHoldCIV >= CSWR_minDestHold OR count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				systemChat format ["%1 FACTION CIV > Got %2 spawn(s), %3 faction destination(s), %4 public destination(s).", CSWR_txtDebugHeader, count CSWR_spwnsAllCIV, count CSWR_destsAllCIV, count CSWR_destsPUBLIC];
			};
		};
	};
	// Debug monitor looping:
	while { CSWR_isOnDebugGlobal } do { call THY_fnc_CSWR_debug };
};
// Return:
true;
