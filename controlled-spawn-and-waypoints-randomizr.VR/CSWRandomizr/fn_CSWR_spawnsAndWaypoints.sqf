// CSWR v3.0
// File: your_mission\CSWRandomizr\fn_CSWR_spawnsAndWaypoints.sqf
// by thy (@aldolammel)

if (!isServer) exitWith {};

// PARAMETERS OF EDITOR'S OPTIONS:
CSWR_isOnDebug = true;              // true = shows some infos to Mission Editor (available only on hosted server player) / false = turn it off. Detault: false.
CSWR_isOnBLU = true;                 // true = if you wanna spawn BluFor/West through CSWR / false = no spawn.
CSWR_isOnOPF = true;                // true = if you wanna spawn OpFor/East through CSWR / false = no spawn.
CSWR_isOnIND = true;                 // true = if you wanna spawn Indepdentent/Resistence through CSWR / false = no spawn.
CSWR_isOnCIV = true;                 // true = if you wanna spawn Civilians through CSWR / false = no spawn.
CSWR_isBackpackForAll = true;       // true = if editor sets a custom backpack, all units will get it / false = only units originally with backpack will get it. Detault: false.
CSWR_isVestForAll = true;           // true = if editor sets a custom vest, all units will get it / false = only units originally with vest will get it. Detault: false.
CSWR_isUnlimitedFuel = false;        // WIP
CSWR_isUnlimitedAmmo = false;        // WIP
CSWR_isEditableByZeus = true;        // true = CSWR units and CSWR vehicles can be manipulated when Zeus is available / false = no editable. Detault: true.
CSWR_wait = 15;                       // If you need to make CSWR waits for other scripts load first, set a delay in seconds. Default: 0.


// SPAWNPOINTS:
// Define where each faction in-game will spawn randomly.
// For new spawnpoints, add a new "select marker" on Eden, set its name and add the new marker down below:

	// BluFor spawns:
	CSWR_spawnsBLU = 
	[
		"spwn_blu_1",
		"spwn_blu_2",
		"spwn_blu_3"
		//"spwn_blu_4",
		//"spwn_blu_5",
		//"spwn_blu_6",
		//"spwn_blu_7",
		//"spwn_blu_8",
		//"spwn_blu_9",
		//"spwn_blu_10"
	]; 
	
	// OpFor spawns:
	CSWR_spawnsOPF = 
	[
		"spwn_opf_1",
		"spwn_opf_2",
		"spwn_opf_3"
		//"spwn_opf_4",
		//"spwn_opf_5",
		//"spwn_opf_6",
		//"spwn_opf_7",
		//"spwn_opf_8",
		//"spwn_opf_9",
		//"spwn_opf_10"
	]; 
	
	// Independent spawns:
	CSWR_spawnsIND = 
	[
		"spwn_ind_1",
		"spwn_ind_2",
		"spwn_ind_3"
		//"spwn_ind_4",
		//"spwn_ind_5",
		//"spwn_ind_6",
		//"spwn_ind_7",
		//"spwn_ind_8",
		//"spwn_ind_9",
		//"spwn_ind_10"
	];
	
	// Civilian spawns:
	CSWR_spawnsCIV = 
	[
		"spwn_civ_1",
		"spwn_civ_2",
		"spwn_civ_3"
		//"spwn_civ_4",
		//"spwn_civ_5",
		//"spwn_civ_6",
		//"spwn_civ_7",
		//"spwn_civ_8",
		//"spwn_civ_9",
		//"spwn_civ_10"
	];


// DESTINATION: FOR ANYONE
// Define where anyone (including civilian and soldiers) in-game will move randomly.
// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:

	CSWR_destPUBLIC = 
	[
		"dest_public_1",
		"dest_public_2",
		"dest_public_3",
		"dest_public_4",
		"dest_public_5",
		"dest_public_6",
		"dest_public_7",
		"dest_public_8",
		"dest_public_9",
		"dest_public_10"
	]; 


// DESTINATION: FOR SOLDIERS
// Define where each faction in-game will move randomly.
// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:

	// BluFor destination:
	CSWR_destOnlyBLU = 
	[
		//"dest_blu_1",
		//"dest_blu_2",
		//"dest_blu_3",
		//"dest_blu_4",
		//"dest_blu_5",
		//"dest_blu_6",
		//"dest_blu_7",
		//"dest_blu_8",
		//"dest_blu_9",
		//"dest_blu_10"
	];

	
	// OpFor destination:
	CSWR_destOnlyOPF = 
	[
		//"dest_opf_1",
		//"dest_opf_2",
		//"dest_opf_3",
		//"dest_opf_4",
		//"dest_opf_5",
		//"dest_opf_6",
		//"dest_opf_7",
		//"dest_opf_8",
		//"dest_opf_9",
		//"dest_opf_10"
	];

	// Independent destination:
	CSWR_destOnlyIND = 
	[
		//"dest_ind_1",
		//"dest_ind_2",
		//"dest_ind_3",
		//"dest_ind_4",
		//"dest_ind_5",
		//"dest_ind_6",
		//"dest_ind_7",
		//"dest_ind_8",
		//"dest_ind_9",
		//"dest_ind_10"
	];


// TAKE A BREAK BEFORE NEXT DESTINATION:
// Define how long the group can wait randomly before to move forward to the next destination:

	CSWR_destTakeabreak = [5, 30, 60];  // in seconds: [min, average, max]



// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------

	CSWR_spawnsAll = CSWR_spawnsBLU + CSWR_spawnsOPF + CSWR_spawnsIND + CSWR_spawnsCIV;
	CSWR_destANYWHERE = CSWR_destPUBLIC + CSWR_destOnlyBLU + CSWR_destOnlyOPF + CSWR_destOnlyIND;
	// Global object declarations:
	publicVariable "CSWR_isOnDebug"; publicVariable "CSWR_isOnBLU"; publicVariable "CSWR_isOnOPF"; publicVariable "CSWR_isOnIND"; publicVariable "CSWR_isOnCIV"; publicVariable "CSWR_isBackpackForAll"; publicVariable "CSWR_isVestForAll"; publicVariable "CSWR_isUnlimitedFuel"; publicVariable "CSWR_isUnlimitedAmmo"; publicVariable "CSWR_isEditableByZeus"; publicVariable "CSWR_waitUntil"; publicVariable "CSWR_spawnsBLU"; publicVariable "CSWR_spawnsOPF"; publicVariable "CSWR_spawnsIND"; publicVariable "CSWR_spawnsCIV"; publicVariable "CSWR_destOnlyBLU"; publicVariable "CSWR_destOnlyOPF"; publicVariable "CSWR_destOnlyIND"; publicVariable "CSWR_destPUBLIC"; publicVariable "CSWR_destTakeabreak"; publicVariable "CSWR_spawnsAll"; publicVariable "CSWR_destANYWHERE";
// When the mission starts:
[] spawn {
	// Local object declarations:
	private ["_txtDebugHeader"];
	// Debug txts:
	_txtDebugHeader = "CSWR DEBUG >";
	// Errors handling:
	if ( CSWR_wait < 1 ) then { CSWR_wait = 1 };  // Important to hold some functions and make their warning (if has) to show only in-game for mission editor.
	if ( CSWR_isOnDebug AND (CSWR_wait > 1) ) then { systemChat format ["%1 Don't forget the CSWR is configurated to delay %2 seconds before to starts its tasks.", _txtDebugHeader, CSWR_wait] };
	// Debug spawnpoints stylish:
	if ( CSWR_isOnDebug ) then {
		{ _x setMarkerColor "colorBLUFOR" } forEach (CSWR_spawnsBLU + CSWR_destOnlyBLU);
		{ _x setMarkerColor "colorOPFOR" } forEach (CSWR_spawnsOPF + CSWR_destOnlyOPF);
		{ _x setMarkerColor "colorIndependent" } forEach (CSWR_spawnsIND + CSWR_destOnlyIND);
		{ _x setMarkerColor "colorCivilian" } forEach (CSWR_spawnsCIV + CSWR_destPUBLIC);
	// Otherwise, hiding the spawn and destination markers:
	} else { {_x setMarkerAlpha 0} forEach (CSWR_spawnsAll + CSWR_destANYWHERE) };
	// Delete the useless spawn markers only, preserving the destines:
	if ( !CSWR_isOnBLU ) then { { deleteMarker _x } forEach CSWR_spawnsBLU };
	if ( !CSWR_isOnOPF ) then { { deleteMarker _x } forEach CSWR_spawnsOPF };
	if ( !CSWR_isOnIND ) then { { deleteMarker _x } forEach CSWR_spawnsIND };
	if ( !CSWR_isOnCIV ) then { { deleteMarker _x } forEach CSWR_spawnsCIV };
	// Debug monitor looping:
	while { CSWR_isOnDebug } do { call THY_fnc_CSWR_debug };
};
// Return:
true;
