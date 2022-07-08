// File: your_mission\CSWRandomizr\fn_CSWR_spawnsAndWaypoints.sqf
// Documentation: https://docs.google.com/document/d/1uFOSXVuf2w_BZxTRIbmuRTrcf5b07Nu2SEGSfdDlXfI/edit?usp=sharing
// by thy (@aldolammel)

if (!isServer) exitWith {};

// FACTION SPAWNPOINTS:
// Define where each faction in-game will spawn randomly.
// For new spawnpoints, add a new "empty marker" on Eden, set its name and add the new marker down below:

	// BluFor spawnpoints:
	CSWR_bluSpawnPoints = 
	[
		"bluSpwn01",
		"bluSpwn02",
		"bluSpwn03"
	]; 

	// OpFor spawnpoints:
	CSWR_opSpawnPoints = 
	[
		"opSpwn01",
		"opSpwn02",
		"opSpwn03"
	]; 

	// Independent spawnpoints:
	CSWR_indSpawnPoints = 
	[
		"indSpwn01",
		"indSpwn02",
		"indSpwn03"
	];

	// Civilian spawnpoints:
	CSWR_civSpawnPoints = 
	[
		"civSpwn01",
		"civSpwn02",
		"civSpwn03"
	];


// WAYPOINTS: SHARED
// Define where anyone (including civilian) in-game will move randomly.
// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:

	CSWR_destinationShared = 
	[
		"destShared01",
		"destShared02",
		"destShared03",
		"destShared04",
		"destShared05",
		"destShared06",
		"destShared07",
		"destShared08",
		"destShared09",
		"destShared10"
	]; 

// WAYPOINTS: BY FACTION
// Define where each faction in-game will move randomly.
// For new destination, add a new "empty marker" on Eden, set its name and add the new marker down below:

	// BluFor destination:
	CSWR_destinationBlu = 
	[
		//"destBlu01",
		//"destBlu02"
	];
	
	// OpFor destination:
	CSWR_destinationOp = 
	[
		//"destOp01",
		//"destOp02"
	];

	// Independent destination:
	CSWR_destinationInd = 
	[
		//"destInd01",
		//"destInd02"
	];


// WAYPOINTS TIMEOUT
// Define how long the group can wait randomly to move forward after reach a destination:

	CSWR_wpTimeOut = [5, 30, 60];  // in seconds: [min, average, max]



// CSWR CORE / TRY TO CHANGE NOTHING:
[] spawn
{
	CSWR_allSpawnPoints = CSWR_bluSpawnPoints + CSWR_opSpawnPoints + CSWR_indSpawnPoints + CSWR_civSpawnPoints;
	{ _x setMarkerAlpha 0 } forEach CSWR_allSpawnPoints; // hiding the spawn markers.
	CSWR_destinationAnywhere = CSWR_destinationShared + CSWR_destinationBlu + CSWR_destinationOp + CSWR_destinationInd;
	{ _x setMarkerAlpha 0 } forEach CSWR_destinationAnywhere; // hiding the destination markers.
};