// CSWR: AUTOMATIZING THE WAR v7.2
// File: your_mission\CSWR\fn_CSWR_globalFunctions.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------
// It runs on server and client machines.
if !CSWR_isOn exitWith {};

// STRUCTURE OF A FUNCTION BY THY:
/* THY_fnc_CSWR_name_of_the_function = {
	// This function <doc string>.
	// Returns nothing <or varname + type> <or Returns nothing, but open a new thread.>

	params ["", "", "", ""];
	private ["", "", ""];

	// Escape:
		// reserved space.
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Main functionality:
	// code

	// Return:
	true;
}; */


THY_fnc_CSWR_marker_name_splitter = {
	// This function splits the marker's name by the _spacer to check if the name has the basic structure for further validations.
	// Returns _mkrNameStructure: array. If the right number of elements (sections) after split, it returns the array with content, but if not valid, array returns empty.

	params ["_mkrName", "_spacer", "_prefix"];
	private ["_mkrNameStructure", "_spacerAmount"];

	// spliting the object name to check its structure:
	_mkrNameStructure = _mkrName splitString _spacer;  // should result, e.g. ["CSWR","SPAWN","BLU","A","1"]
	// if the _spacer is NOT been used correctly:
	if ( count _mkrNameStructure isNotEqualTo 5 ) then {
		// Warning:
		systemChat format ["%1 MARKER '%2' > This marker name's structure look's NOT CORRECT! CSWR markers must have their structure names like '%3%4SPAWN%4BLU%4sectorletter%4anynumber' or '%3%4MOVE%4BLU%4sectorletter%4anynumber' for example. The marker has been ignored.",
		CSWR_txtWarnHeader, _mkrName, _prefix, _spacer];
		// Update to return as failed:
		_mkrNameStructure = [];
	};
	// Return:
	_mkrNameStructure;
};


THY_fnc_CSWR_is_marker_position_valid = {
	// This function checks if the marker (spawn or destination) exists and if it's inside map borders.
	// Return _isValid: bool.

	params ["_mkr"];
	private ["_isValid", "_mkrPos", "_mkrPosA", "_mkrPosB", "_txt1"];

	// Initial values:
	_isValid = false;
	_mkrPos  = [];
	_mkrPosA = nil;
	_mkrPosB = nil;
	// Debug texts:
	_txt1 = format ["MARKER '%1' > This is in an invalid position and will be ignored until its position is within the map borders.", toUpper _mkr];

	// If the marker has a color, it's because the marker exists LOL:
	if ( (getMarkerColor _mkr) isNotEqualTo "" ) then {
		_mkrPos  = markerPos _mkr;
		_mkrPosA = _mkrPos # 0;
		_mkrPosB = _mkrPos # 1;
		// Check if the marker is out of the map edges:
		if ( (_mkrPosA >= 0) && (_mkrPosB >= 0) && (_mkrPosA <= worldSize) && (_mkrPosB <= worldSize) ) then {
			// Update to return:
			_isValid = true;
		// Otherwise, if not on map area:
		} else {
			// Warning:
			systemChat format ["%1 %2", CSWR_txtWarnHeader, _txt1];
		};
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_marker_name_section_type = {
	// This function checks only the second section (mandatory) of the marker's name, validating if the section is a valid type of marker (spawn or destination). Full marker name, e.g.: cswr_spawn_blu_a_1
	// Returns _mkrType: when valid, returns the type as string, but if invalid, empty string ("").

	params ["_mkrNameStructure", "_mkr"];
	private ["_mkrType", "_spwnTypes", "_destTypes", "_allTypesAvailable", "_mkrTypeToCheck"];

	// Initial values:
	_mkrType = "";
	// Escape: 
	if ( count _mkrNameStructure isNotEqualTo 5 ) exitWith { _mkrType };
	// Declarations:
	_spwnTypes = ["SPAWN", "SPAWNVEH", "SPAWNHELI", "SPAWNPARADROP"];
	_destTypes = ["MOVE", "WATCH", "OCCUPY", "HOLD"];
	_allTypesAvailable = _spwnTypes + _destTypes;
	_mkrTypeToCheck = _mkrNameStructure # 1;  // ["CSWR", "SPAWN", "BLU", "C", "1"] then it should be one of _allTypesAvailable.
	// Valid:
	if ( _mkrTypeToCheck in _allTypesAvailable ) then {
		// Update to return:
		_mkrType = _mkrTypeToCheck;
	// Not valid:
	} else {
		// Warning:
		if ( _mkrTypeToCheck isEqualTo "EXTRACTION" || _mkrTypeToCheck isEqualTo "TRANSPORT" ) then {
			systemChat format ["%1 DESTINATION > %2 > EXTRACTION and TRANSPORT are DESTINATIONS that DON'T NEED markers on the map. Just use '_move_EXTRACTION' or '_move_TRANSPORT' in Population file assigned for Helicopters, and the CSWR knows what to do!",
			CSWR_txtWarnHeader, _mkr];
		} else {
			systemChat format ["%1 MARKER '%2' > The MARKER TYPE on the marker's name looks wrong. There's NO any '%3' type available for Spawn or Destination markers. The marker-types available are these ones for you fix it on Eden: %4.", 
			CSWR_txtWarnHeader, _mkr, _mkrTypeToCheck, _allTypesAvailable];
		};
	}; 
	// Return:
	_mkrType;
};


THY_fnc_CSWR_marker_shape = {
	// This function checks the marker shape.
	// Returns _isValidShape: bool.

	params ["_what", "_mkr"];
	private ["_isValidShape", "_mkrType"];

	// Initial values:
	_isValidShape = false;
	// Declarations:
	_mkrType = getMarkerType _mkr;
	// Main functionality:
	switch _what do {
		case 1: {  // Spawn marker
			// Important: DONT use isEqualTo here. It needs to be case-insensitivy!
			if ( _mkrType == "Select" ) then { _isValidShape = true } else {
				// Warning:
				systemChat format ["%1 MARKER > The %2 '%3' marker DOESN'T HAVE the correct shape. For any Spawn, use 'Select' marker! This marker was ignored.",
				CSWR_txtWarnHeader, _mkrType, _mkr];
			};
		};
		case 2: {  // Destination marker
			// Important: DONT use isEqualTo here. It needs to be case-insensitivy!
			if ( _mkrType == "Empty" ) then { _isValidShape = true } else {
				// Warning:
				systemChat format ["%1 MARKER > The %2 '%3' marker DOESN'T HAVE the correct shape. For any Destination, use 'Empty' marker! This marker was ignored.",
				CSWR_txtWarnHeader, _mkrType, _mkr];
			};
		};
	};
	// Return:
	_isValidShape;
};


THY_fnc_CSWR_marker_name_section_owner = {
	// This function checks only the third section (mandatory) of the marker's name, validating who is the marker's owner.
	// Returns _mkrTag: when valid, marker-owner returns as string. When invalid, empty string ("").

	params ["_what", "_mkrNameStructure", "_mkr"];
	private ["_mkrTag", "_tagsAvailable", "_mkrTypeToCheck", "_mkrTagToCheck"];

	// Initial values:
	_mkrTag        = "";
	_tagsAvailable = [];
	// Declarations:
	_mkrTypeToCheck = _mkrNameStructure # 1;  // e.g: it'll take 'move' from 'cswr_move_blu_a_1'
	_mkrTagToCheck  = _mkrNameStructure # 2;  // e.g: it'll take 'blu' from 'cswr_spawn_blu_a_1'
	// Main functionality:
	switch _what do {
		case 1: {  // Spawn marker
			// If it's about owners for spawnpoints:
			_tagsAvailable = ["BLU", "OPF", "IND", "CIV"];
		};
		case 2: {  // Destination marker
			// If it's about owners for move destinations:
			if ( _mkrTypeToCheck isEqualTo "MOVE" ) then {
				// Move destinations are NOT available for civilian side:
				_tagsAvailable = ["BLU", "OPF", "IND", "PUBLIC"];
			// Otherwise:
			} else {
				// If watch-move:
				if ( _mkrTypeToCheck isEqualTo "WATCH" ) then {
					// Not available for civilian side:
					_tagsAvailable = ["BLU", "OPF", "IND"];
				// Otherwise:
				} else {
					// Available for all sides:
					_tagsAvailable = ["BLU", "OPF", "IND", "CIV"];
				};
			};
		};
	};
	// If the owner is valid:
	if ( _mkrTagToCheck in _tagsAvailable ) then {
		// Updating to return:
		_mkrTag = _mkrTagToCheck;
	// If NOT valid, warning message:
	} else {
		systemChat format ["%1 MARKER '%2' > The OWNER on the marker's name looks wrong. There's NO '%3' option available if it's a '%4' marker. While this marker is ignored, here's the owner options for you fix it on Eden: %5",
		CSWR_txtWarnHeader, _mkr, _mkrTagToCheck, _mkrTypeToCheck, _tagsAvailable];
	};
	// Return:
	_mkrTag;
};


THY_fnc_CSWR_marker_name_section_sector = {
	// This function checks only the sector section (mandatory since v7) of the marker's name, validating if the sector-letter is valid. Structure with sector e.g: cswr_spawn_blu_A_1
	// Returns _mkrSector: when it exists, sector section is a letter and return as string. When invalid, empty string ("") is returned.

	params ["_mkrNameStructure", "_mkr"];
	private ["_mkrSector", "_sectorsAvailable", "_mkrSectorToCheck"];

	// Initial values:
	_mkrSector = "";
	// Declarations:
	_sectorsAvailable = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
	_mkrSectorToCheck = _mkrNameStructure # 3;  // e.g: cswr_move_blu_A_1
	// If the sector is valid:
	if ( _mkrSectorToCheck in _sectorsAvailable ) then {  // "in" is case-sensitive!
		// Updating to return:
		_mkrSector = _mkrSectorToCheck;
	// If NOT valid:
	} else {
		// Warning:
		systemChat format ["%1 MARKER '%2' > The SECTOR on the marker's name looks wrong. There's NO '%3' option available as SECTOR letter. While this marker is ignored, here's the sector letter options for you fix it on Eden: %4.",
		CSWR_txtWarnHeader, _mkr, _mkrSectorToCheck, _sectorsAvailable];
	}; 
	// Return:
	_mkrSector;
};


THY_fnc_CSWR_marker_name_section_number = {
	// This function checks the last section (mandatory) of the marker's name, validating if the section is numeric;
	// Returns _isNum: bool.

	params ["_mkrNameStructure", "_mkr", "_prefix", "_spacer"];
	private ["_isNum", "_itShouldBeNum"];

	// Initial values:
	_isNum = false;
	// Result will be a number extracted from string OR ZERO if inside the string has no numbers:
	_itShouldBeNum = parseNumber (_mkrNameStructure # 4);  // cswr_spawn_blu_a_1
	// If is number (and the result is not a zero), it's true:
	if ( _itShouldBeNum isNotEqualTo 0 ) then {
		_isNum = true;
	// If is NOT a number (will be zero):
	} else {
		// Warning:
		systemChat format ["%1 MARKER '%2' > Where is the number in the final of the marker's name? CSWR markers must have their structure names like '%3%4SPAWN%4BLU%4sectorletter%4anynumber' or '%3%4MOVE%4PUBLIC%4sectorletter%4anynumber' for example.",
		CSWR_txtWarnHeader, _mkr, _prefix, _spacer];
	};
	// Return:
	_isNum;
};


THY_fnc_CSWR_marker_scanner = {
	// This function searches and appends in a list all markers confirmed as real. The searching take place once right at the mission begins through fn_CSWR_1_management.sqf file, and it classify the markers if they are spawns or destinations markers, just like if they are on land or in water.
	// Return: _confirmedMkrs: array.

	params ["_prefix", "_spacer"];
	private ["_spwnsBLU", "_spwnsVehBLU", "_spwnsHeliBLU", "_spwnsParaBLU", "_spwnsOPF", "_spwnsVehOPF", "_spwnsHeliOPF", "_spwnsParaOPF", "_spwnsIND", "_spwnsVehIND", "_spwnsHeliIND", "_spwnsParaIND", "_spwnsCIV", "_spwnsVehCIV", "_spwnsHeliCIV", "_spwnsParaCIV", "_destMoveBLU", "_destWatchBLU", "_destOccupyBLU", "_destHoldBLU", "_destMoveOPF", "_destWatchOPF", "_destOccupyOPF", "_destHoldOPF", "_destMoveIND", "_destWatchIND", "_destOccupyIND", "_destHoldIND", "_destMoveCIV", "_destWatchCIV", "_destOccupyCIV", "_destHoldCIV", "_destMovePUBLIC", "_confirmedMkrs", "_spwns", "_spwnsVeh", "_spwnsHeli", "_spwnsPara", "_isValid", "_mkr", "_mkrType", "_isValidShape", "_tag", "_sector", "_isNum", "_mkrNameStructure", "_possibleMkrs"];

	// Initial values > Spawns:
	_spwnsBLU       = [[/*land*/],[/*water*/]]; _spwnsVehBLU  = [[],[]]; _spwnsHeliBLU  = [[],[]];  _spwnsParaBLU = [[],[]];
	_spwnsOPF       = [[/*land*/],[/*water*/]]; _spwnsVehOPF  = [[],[]]; _spwnsHeliOPF  = [[],[]];  _spwnsParaOPF = [[],[]];
	_spwnsIND       = [[/*land*/],[/*water*/]]; _spwnsVehIND  = [[],[]]; _spwnsHeliIND  = [[],[]];  _spwnsParaIND = [[],[]];
	_spwnsCIV       = [[/*land*/],[/*water*/]]; _spwnsVehCIV  = [[],[]]; _spwnsHeliCIV  = [[],[]];  _spwnsParaCIV = [[],[]];
	// Initial values > Destinations:
	_destMoveBLU    = [[/*land*/],[/*water*/]]; _destWatchBLU = [[],[]]; _destOccupyBLU = [[],[]]; _destHoldBLU = [[],[]];
	_destMoveOPF    = [[/*land*/],[/*water*/]]; _destWatchOPF = [[],[]]; _destOccupyOPF = [[],[]]; _destHoldOPF = [[],[]];
	_destMoveIND    = [[/*land*/],[/*water*/]]; _destWatchIND = [[],[]]; _destOccupyIND = [[],[]]; _destHoldIND = [[],[]];
	_destMoveCIV    = [[/*land*/],[/*water*/]]; _destWatchCIV = [[],[]]; _destOccupyCIV = [[],[]]; _destHoldCIV = [[],[]];
	_destMovePUBLIC = [[/*land*/],[/*water*/]];
	// Prepare to return:
	_confirmedMkrs  = [
		// Spawns:
		[
			[_spwnsBLU, _spwnsVehBLU, _spwnsHeliBLU, _spwnsParaBLU],
			[_spwnsOPF, _spwnsVehOPF, _spwnsHeliOPF, _spwnsParaOPF],
			[_spwnsIND, _spwnsVehIND, _spwnsHeliIND, _spwnsParaIND],
			[_spwnsCIV, _spwnsVehCIV, _spwnsHeliCIV, _spwnsParaCIV]
		],
		// Destinations:
		[
			[_destMoveBLU, _destWatchBLU, _destOccupyBLU, _destHoldBLU],
			[_destMoveOPF, _destWatchOPF, _destOccupyOPF, _destHoldOPF],
			[_destMoveIND, _destWatchIND, _destOccupyIND, _destHoldIND],
			[_destMoveCIV, _destWatchCIV, _destOccupyCIV, _destHoldCIV],
			[_destMovePUBLIC]
		]
	];
	_spwns            = 0;
	_spwnsVeh         = 0;
	_spwnsHeli        = 0;
	_spwnsPara        = 0;
	_isValid          = false;
	_mkr              = "";
	_mkrType          = "";
	_isValidShape     = false;
	_tag              = "";
	_sector           = "";
	_isNum            = false;
	_mkrNameStructure = [];
	
	// STEP 1/3 > FINDING CSWR MARKERS -------------------------------------------------------------------------------
	// Find all markers designated for CSWR based on their variable-name prefix:
	_possibleMkrs = allMapMarkers select { toUpper _x find (_prefix + _spacer) isNotEqualTo -1 };
	// Debug:
	if CSWR_isOnDebug then { systemChat format ["%1 Valid markers found: %2 of %3 dropped on the map.", CSWR_txtDebugHeader, count _possibleMkrs, count allMapMarkers] };
	// Escape > If no _possibleMkrs found:
	if ( _possibleMkrs isEqualTo [] ) exitWith {
		// Warning:
		systemChat format ["%1 This mission still HAS NO possible CSWR MARKERS to be loaded. CSWR markers must have their structure names like '%2%3SPAWN%3BLU%3anynumber' or '%2%3MOVE%3PUBLIC%3anynumber' or '%2%3SPAWN%3OPF%3anynumber' or '%2%3MOVE%3IND%3anynumber' for example.",
		CSWR_txtWarnHeader, _prefix, _spacer];
		// Returning:
		_confirmedMkrs;
	};
	// Validating each marker position:
	{  // forEachReversed _possibleMkrs:
		_isValid = [_x] call THY_fnc_CSWR_is_marker_position_valid;
		// If something wrong, remove the marker from the map and from the list:
		if !_isValid then { deleteMarker _x; _possibleMkrs deleteAt _forEachIndex };
	} forEachReversed _possibleMkrs;

	// STEP 2/3 > ORGANIZING WHAT WAS FOUND --------------------------------------------------------------------------
	// Defining what is marker for spawns and what is for destinations:
	{  // forEachReversed _possibleMkrs:
		_mkr = toUpper _x;
		// check if the marker name has _spacer character enough in its string composition:
		_mkrNameStructure = [_mkr, _spacer, _prefix] call THY_fnc_CSWR_marker_name_splitter;
		// Escape > if invalid structure, delete marker, delete from the list and skip to the next one:
		if ( _mkrNameStructure isEqualTo [] || (_mkrNameStructure # 0) isNotEqualTo _prefix ) then { deleteMarker _mkr; _possibleMkrs deleteAt _forEachIndex; continue };
		// check what marker-type is each one:
		_mkrType = [_mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_type;
		// Escape > if invalid type, delete marker, delete from the list and skip to the next one:
		if ( _mkrType isEqualTo "" ) then { deleteMarker _mkr; _possibleMkrs deleteAt _forEachIndex; continue };
		// Checking the marker shape:
		switch _mkrType do {
			// Spawn markers:
			case "SPAWN":         { _isValidShape = [1, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [1, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_spawn_blu_a_1
			case "SPAWNVEH":      { _isValidShape = [1, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [1, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_spawnveh_blu_a_1
			case "SPAWNHELI":     { _isValidShape = [1, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [1, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_spawnheli_blu_a_1
			case "SPAWNPARADROP": { _isValidShape = [1, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [1, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_spawnparadrop_blu_a_1
			// Destination markers:
			case "MOVE":          { _isValidShape = [2, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [2, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_move_blu_a_1
			case "WATCH":         { _isValidShape = [2, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [2, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_watch_blu_a_1
			case "OCCUPY":        { _isValidShape = [2, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [2, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_occupy_blu_a_1
			case "HOLD":          { _isValidShape = [2, _mkr] call THY_fnc_CSWR_marker_shape; _tag = [2, _mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_owner };  // cswr_hold_blu_a_1
			//case "EXTRACTION":   {  };  // cswr_extraction_blu_a_1 (NOT USED!)
			//case "TRANSPORT":   {  };  // cswr_transport_blu_a_1 (NOT USED!)
			//default             { /* Not necessary because the errors handling are inside the previously functions inside this current function */ };
		};
		// Escape:
		if ( !_isValidShape || _tag isEqualTo "" ) then { deleteMarker _mkr; _possibleMkrs deleteAt _forEachIndex; continue };
		// Check if there is the sector letter:
		_sector = [_mkrNameStructure, _mkr] call THY_fnc_CSWR_marker_name_section_sector;
		// Escape:
		if ( _sector isEqualTo "" ) then { deleteMarker _mkr; _possibleMkrs deleteAt _forEachIndex; continue };
		// Check if the last section of the area marker name is numeric:
		_isNum = [_mkrNameStructure, _mkr, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
		// Escape:
		if !_isNum then { deleteMarker _mkr; _possibleMkrs deleteAt _forEachIndex; continue };
		// If all validations alright:
		switch _mkrType do {
			case "SPAWN": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Infantry Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsBLU # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Marines Spawn %2", _tag, _sector]);
						};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Infantry Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsOPF # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Marines Spawn %2", _tag, _sector]);
						};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Infantry Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsIND # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Marines Spawn %2", _tag, _sector]);
						};
					};
					case "CIV": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 People Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsCIV # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 People Spawn %2 (in water)", _tag, _sector]);
						};
					};
				};
			};
			case "SPAWNVEH": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsVehBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Ground Vehicle Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsVehBLU # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Vehicle Spawn %2", _tag, _sector]);
						};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsVehOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Ground Vehicle Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsVehOPF # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Vehicle Spawn %2", _tag, _sector]);
						};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsVehIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Ground Vehicle Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsVehIND # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Vehicle Spawn %2", _tag, _sector]);
						};
					};
					case "CIV": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsVehCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Ground Vehicle Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsVehCIV # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Vehicle Spawn %2", _tag, _sector]);
						};
					};
				};
			};
			case "SPAWNHELI": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsHeliBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsHeliBLU # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2 (hovering)", _tag, _sector]);
						};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsHeliOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsHeliOPF # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2 (hovering)", _tag, _sector]);
						};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsHeliIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsHeliIND # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2 (hovering)", _tag, _sector]);
						};
					};
					case "CIV": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsHeliCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2", _tag, _sector]);
						// On water:
						} else {
							(_spwnsHeliCIV # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Helicopter Spawn %2 (hovering)", _tag, _sector]);
						};
					};
				};
			};
			case "SPAWNPARADROP": {
				switch _tag do {
					case "BLU": {
						// On air over the land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsParaBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Paradrop Spawn %2", _tag, _sector]);
						// Over the water:
						} else {
							systemChat format ["%1 SPAWN > PARADROP CANNOT be in sky over the sea/water. Check the '%2' marker on Eden.",
							CSWR_txtWarnHeader, _mkr];
						};
					};
					case "OPF": {
						// On air over the land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsParaOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Paradrop Spawn %2", _tag, _sector]);
						// Over the water:
						} else {
							systemChat format ["%1 SPAWN > PARADROP CANNOT be in sky over the sea/water. Check the '%2' marker on Eden.",
							CSWR_txtWarnHeader, _mkr];
						};
					};
					case "IND": {
						// On air over the land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsParaIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Paradrop Spawn %2", _tag, _sector]);
						// Over the water:
						} else {
							systemChat format ["%1 SPAWN > PARADROP CANNOT be in sky over the sea/water. Check the '%2' marker on Eden.",
							CSWR_txtWarnHeader, _mkr];
						};
					};
					case "CIV": {
						// On air over the land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_spwnsParaCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Paradrop Spawn %2", _tag, _sector]);
						// Over the water:
						} else {
							systemChat format ["%1 SPAWN > PARADROP CANNOT be in sky over the sea/water. Check the '%2' marker on Eden.",
							CSWR_txtWarnHeader, _mkr];
						};
					};
				};
			};
			case "MOVE": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destMoveBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Move %2", _tag, _sector]);
						// On water:
						} else {
							(_destMoveBLU # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Move %2", _tag, _sector]);
						};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destMoveOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Move %2", _tag, _sector]);
						// On water:
						} else {
							(_destMoveOPF # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Move %2", _tag, _sector]);
						};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destMoveIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Move %2", _tag, _sector]);
						// On water:
						} else {
							(_destMoveIND # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Move %2", _tag, _sector]);
						};
					};
					//case "CIV":  {};  // CIV cannot use restricted destinations.
					case "PUBLIC": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destMovePUBLIC # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Move %2", _tag, _sector]);
						// On water:
						} else {
							(_destMovePUBLIC # 1) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Nautical Move %2", _tag, _sector]);
						};
					};
				};
			};
			case "WATCH": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destWatchBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Watch %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destWatchOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Watch %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destWatchIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Watch %2", _tag, _sector]);
						// useless:
						} else {};
					};
					//case "CIV": {};  // CIV cannot use watch destinations.
				};
			};
			case "OCCUPY": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destOccupyBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Occupy %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destOccupyOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Occupy %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destOccupyIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Occupy %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "CIV": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destOccupyCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Occupy %2", _tag, _sector]);
						// useless:
						} else {};
					};
				};
			};
			case "HOLD": {
				switch _tag do {
					case "BLU": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destHoldBLU # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Hold %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "OPF": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destHoldOPF # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Hold %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "IND": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destHoldIND # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Hold %2", _tag, _sector]);
						// useless:
						} else {};
					};
					case "CIV": {
						// On land:
						if ( !(surfaceIsWater (markerPos _mkr)) ) then {
							(_destHoldCIV # 0) pushBack _mkr;
							_mkr setMarkerText (format [" %1 Hold %2", _tag, _sector]);
						// useless:
						} else {};
					};
				};
			};
			//case "EXTRACTION": {};  // NOT USED!
			//case "TRANSPORT": {};  // NOT USED!
		};
	} forEachReversed _possibleMkrs;
	// Destroying unnecessary things:
	//_possibleMkrs = nil;
	
	// STEP 3/3 > PREPARING TO RETURN --------------------------------------------------------------------------------
	// Updating the general list to return:
	_confirmedMkrs = [
		// Spawns:
		[
			[_spwnsBLU, _spwnsVehBLU, _spwnsHeliBLU, _spwnsParaBLU],
			[_spwnsOPF, _spwnsVehOPF, _spwnsHeliOPF, _spwnsParaOPF],
			[_spwnsIND, _spwnsVehIND, _spwnsHeliIND, _spwnsParaIND],
			[_spwnsCIV, _spwnsVehCIV, _spwnsHeliCIV, _spwnsParaCIV]
		],
		// Destinations:
		[
			[_destMoveBLU, _destWatchBLU, _destOccupyBLU, _destHoldBLU],
			[_destMoveOPF, _destWatchOPF, _destOccupyOPF, _destHoldOPF],
			[_destMoveIND, _destWatchIND, _destOccupyIND, _destHoldIND],
			[_destMoveCIV, _destWatchCIV, _destOccupyCIV, _destHoldCIV],
			[_destMovePUBLIC]
		]
	];
	// By enable side, check if there is, at least, one spawn marker available:
	if CSWR_isOnBLU then {
		// Defining amount of spawns of side:
		_spwns     = count ((((_confirmedMkrs # 0) # 0) # 0) # 0) + count ((((_confirmedMkrs # 0) # 0) # 0) # 1);
		_spwnsVeh  = count ((((_confirmedMkrs # 0) # 0) # 1) # 0) + count ((((_confirmedMkrs # 0) # 0) # 1) # 1);
		_spwnsHeli = count ((((_confirmedMkrs # 0) # 0) # 2) # 0) + count ((((_confirmedMkrs # 0) # 0) # 2) # 1);
		_spwnsPara = count ((((_confirmedMkrs # 0) # 0) # 3) # 0) + count ((((_confirmedMkrs # 0) # 0) # 3) # 1);
		if ( (_spwns + _spwnsVeh + _spwnsHeli + _spwnsPara) isEqualTo 0 ) then {
			// Warning:
			systemChat format ["%1 SPAWN > NO BLU SPAWN FOUND. Check the documentation or turn 'CSWR_isOnBLU' to 'false' in 'fn_CSWR_1_management.sqf' file!", CSWR_txtWarnHeader];  // dont use _tag here!
		};
	};
	if CSWR_isOnOPF then {
		// Defining amount of spawns of side:
		_spwns     = count ((((_confirmedMkrs # 0) # 1) # 0) # 0) + count ((((_confirmedMkrs # 0) # 1) # 0) # 1);
		_spwnsVeh  = count ((((_confirmedMkrs # 0) # 1) # 1) # 0) + count ((((_confirmedMkrs # 0) # 1) # 1) # 1);
		_spwnsHeli = count ((((_confirmedMkrs # 0) # 1) # 2) # 0) + count ((((_confirmedMkrs # 0) # 1) # 2) # 1);
		_spwnsPara = count ((((_confirmedMkrs # 0) # 1) # 3) # 0) + count ((((_confirmedMkrs # 0) # 1) # 3) # 1);
		if ( (_spwns + _spwnsVeh + _spwnsHeli + _spwnsPara) isEqualTo 0 ) then {
			// Warning:
			systemChat format ["%1 SPAWN > NO OPF SPAWN FOUND. Check the documentation or turn 'CSWR_isOnOPF' to 'false' in 'fn_CSWR_1_management.sqf' file!", CSWR_txtWarnHeader];
		};
	};
	if CSWR_isOnIND then {
		// Defining amount of spawns of side:
		_spwns     = count ((((_confirmedMkrs # 0) # 2) # 0) # 0) + count ((((_confirmedMkrs # 0) # 2) # 0) # 1);
		_spwnsVeh  = count ((((_confirmedMkrs # 0) # 2) # 1) # 0) + count ((((_confirmedMkrs # 0) # 2) # 1) # 1);
		_spwnsHeli = count ((((_confirmedMkrs # 0) # 2) # 2) # 0) + count ((((_confirmedMkrs # 0) # 2) # 2) # 1);
		_spwnsPara = count ((((_confirmedMkrs # 0) # 2) # 3) # 0) + count ((((_confirmedMkrs # 0) # 2) # 3) # 1);
		if ( (_spwns + _spwnsVeh + _spwnsHeli + _spwnsPara) isEqualTo 0 ) then {
			// Warning:
			systemChat format ["%1 SPAWN > NO IND SPAWN FOUND. Check the documentation or turn 'CSWR_isOnIND' to 'false' in 'fn_CSWR_1_management.sqf' file!", CSWR_txtWarnHeader];
		};
	};
	if CSWR_isOnCIV then {
		// Defining amount of spawns of side:
		_spwns     = count ((((_confirmedMkrs # 0) # 3) # 0) # 0) + count ((((_confirmedMkrs # 0) # 3) # 0) # 1);
		_spwnsVeh  = count ((((_confirmedMkrs # 0) # 3) # 1) # 0) + count ((((_confirmedMkrs # 0) # 3) # 1) # 1);
		_spwnsHeli = count ((((_confirmedMkrs # 0) # 3) # 2) # 0) + count ((((_confirmedMkrs # 0) # 3) # 2) # 1);
		_spwnsPara = count ((((_confirmedMkrs # 0) # 3) # 3) # 0) + count ((((_confirmedMkrs # 0) # 3) # 3) # 1);
		if ( (_spwns + _spwnsVeh + _spwnsHeli + _spwnsPara) isEqualTo 0 ) then {
			// Warning:
			systemChat format ["%1 SPAWN > NO CIV SPAWN FOUND. Check the documentation or turn 'CSWR_isOnCIV' to 'false' in 'fn_CSWR_1_management.sqf' file!", CSWR_txtWarnHeader];
		};
	};
	// Return:
	_confirmedMkrs;
};


THY_fnc_VO_is_amphibious = {
	// This function comes from my script VO (Vehicles Overhauling) where is returned whether the vehicle has the ability to float as an amphibious vehicle (APC, for example).
	// Returns _canFloat.

	params ["_classname"];
	private ["_floatVal", "_canFloat"];

	_floatVal = -1;
	_floatVal = getNumber (configFile >> "CfgVehicles" >> _classname >> "canFloat");
	_canFloat = (_floatVal > 0);
	// Debug:
	if ( CSWR_isOnDebug && CSWR_isOnDebugNautic ) then {
		if _canFloat then {
			["%1 SPAWN > NAUTICAL > The vehicle '%2' CAN FLOAT. Good!",
			CSWR_txtDebugHeader, _classname] call BIS_fnc_error;
		} else {
			// Warning:
			["%1 SPAWN > NAUTICAL > The vehicle '%2' CANNOT FLOAT to be used in nautical spawn.",
			CSWR_txtDebugHeader, _classname] call BIS_fnc_error;
		};
		sleep 1;
	};
	// Return:
	_canFloat
};


THY_fnc_CSWR_marker_booking = {
	// This function makes the booking (only for ground and air vehicles) of a marker, regarless if a destination or spawn-point.
	// Param > _mkrType > string: which type of spawn-point (for infantry, for vehicle, for heli) or type of destination marker ( watch, hold, occupy, etc).
	// Param > _markers > array: all markers must be checked.
	// Param > _attemptLimit > number: limit of times the function will try to find a free marker.
	// Returns _bookingData. Array [string, array, bool].

	params ["_mkrType", "_mkrPos", "_tag", "_markers", "_attemptLimit", "_cooldown"];
	private ["_mkr", "_isBooked", "_bookingData", "_bookedLoc", "_isError", "_ctr"];

	// Escape - part 1/2:
		// reserved space.
	// Initial values:
	_mkr         = "";
	_mkrPos      = [];
	_isBooked    = false;
	_bookingData = [_mkr, _mkrPos, _isBooked];
	_bookedLoc   = [];
	_isError     = false;
	// Declarations:
	_ctr = 0;
	switch _mkrType do {
		// Destinations:
		case "BOOKING_HOLD":      { _bookedLoc = CSWR_bookedLocHold };  // [[blu],[opf],[ind],[civ]]
		// Spawns:
		case "BOOKING_SPAWNVEH":  { _bookedLoc = CSWR_bookedLocSpwnVeh };  // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNHELI": { _bookedLoc = CSWR_bookedLocSpwnHeli };
		// Others:
		default {
			systemChat format ["%1 There is no '%2' in 'THY_fnc_CSWR_marker_booking' function.",
			CSWR_txtWarnHeader, _mkrType]; 
			_isError = true;
		};
	};
	// Escape - part 2/2:
	if _isError exitWith { _bookingData /* Returning */ };
	// Looping for select the marker:
	while { _ctr <= _attemptLimit } do {
		// Pick a marker (it looks not the best performance way to pick one but this way successfully will break the bias of the markers ordering in array):
		_mkr = selectRandom _markers;
		// For each case, check which booked-list the marker should be included:
		switch _tag do {
			// If _mkr is NOT in the booked-list yet, include it:
			case "BLU": { if ( !(_mkr in (_bookedLoc # 0)) ) then { (_bookedLoc # 0) pushBack _mkr; _isBooked = true } };
			case "OPF": { if ( !(_mkr in (_bookedLoc # 1)) ) then { (_bookedLoc # 1) pushBack _mkr; _isBooked = true } };
			case "IND": { if ( !(_mkr in (_bookedLoc # 2)) ) then { (_bookedLoc # 2) pushBack _mkr; _isBooked = true } };
			case "CIV": { if ( !(_mkr in (_bookedLoc # 3)) ) then { (_bookedLoc # 3) pushBack _mkr; _isBooked = true } };
		};
		// if booked, update the public variable and take the marker position:
		if _isBooked then {
			switch _mkrType do {
				// Destinations:
				case "BOOKING_HOLD":      { CSWR_bookedLocHold     = _bookedLoc; publicVariable "CSWR_bookedLocHold";     _mkrPos = [(markerPos _mkr) # 0, (markerPos _mkr) # 1, 0] };
				// Spawns:
				case "BOOKING_SPAWNVEH":  { CSWR_bookedLocSpwnVeh  = _bookedLoc; publicVariable "CSWR_bookedLocSpwnVeh";  _mkrPos = [(markerPos _mkr) # 0, (markerPos _mkr) # 1, 0] };
				case "BOOKING_SPAWNHELI": { CSWR_bookedLocSpwnHeli = _bookedLoc; publicVariable "CSWR_bookedLocSpwnHeli"; _mkrPos = [(markerPos _mkr) # 0, (markerPos _mkr) # 1, 0] };
			};
			// Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugBooking ) then {
				systemChat format ["%1 %2 > %3 '%4' marker was booked.",
				CSWR_txtDebugHeader, _mkrType, _tag, _mkr]; sleep 1;
			};
			// Stop the looping;
			break;
		// Otherwise:
		} else {
			// clean the _mkr to prevent fake booking in case of the while-loop reachs the attempt limit:
			switch _mkrType do {
				// Destinations:
				case "BOOKING_HOLD":      { /* _mkr = ""  // About this code: if nothing is booked, keep the last for at least it works with some marker */ };
				// Spawns:
				case "BOOKING_SPAWNVEH":  { _mkr = "" };
				case "BOOKING_SPAWNHELI": { _mkr = "" };
			};
		};
		// Counter to prevent crazy loops:
		_ctr = _ctr + 1;
		// Important: if it's vehicles using the function right after spawn, be fast to avoid explosions:
		sleep _cooldown;
	};  // While-loop ends.
	// Prepare to return:
	_bookingData = [_mkr, _mkrPos, _isBooked];
	// Return:
	_bookingData;
};


THY_fnc_CSWR_marker_bookingUndo = {
	// This function undo the booking of a marker (destination or spawn-point) when it becomes available.
	// Returns nothing.

	params ["_mkrType", "_tag", "_mkr", "_isBooked"];
	private ["_bookedLoc", "_bookedAmount", "_isError"];

	// Escape - part 1/2:
	if !_isBooked exitWith {};
	// Initial values:
	_bookedLoc    = [];
	_isError      = false;
	_bookedAmount = 0;  // debug purposes.
	// All cases where booking can be applied:
	switch _mkrType do {
		// Destinations:
		case "BOOKING_HOLD":      { _bookedLoc = CSWR_bookedLocHold };  // [[blu],[opf],[ind],[civ]]
		// Spawns:
		case "BOOKING_SPAWNVEH":  { _bookedLoc = CSWR_bookedLocSpwnVeh };  // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNHELI": { _bookedLoc = CSWR_bookedLocSpwnHeli };
		default {
			systemChat format ["%1 There is no '%2' in 'THY_fnc_CSWR_marker_bookingUndo' function.",
			CSWR_txtWarnHeader, _mkrType]; _isError = true;
		};
	};
	// Escape - part 2/2:
	if _isError exitWith {};
	// For each case, remove the current hold-marker as reserved from the reservation list:
	switch _tag do {
		case "BLU": { (_bookedLoc # 0) deleteAt ((_bookedLoc # 0) find _mkr); _bookedAmount = count (_bookedLoc # 0) };
		case "OPF": { (_bookedLoc # 1) deleteAt ((_bookedLoc # 1) find _mkr); _bookedAmount = count (_bookedLoc # 1) };
		case "IND": { (_bookedLoc # 2) deleteAt ((_bookedLoc # 2) find _mkr); _bookedAmount = count (_bookedLoc # 2) };
		case "CIV": { (_bookedLoc # 3) deleteAt ((_bookedLoc # 3) find _mkr); _bookedAmount = count (_bookedLoc # 3) };
	};
	// After that, update the public variable with the new reservation:
	switch _mkrType do {
		// Destinations:
		case "BOOKING_HOLD":      { CSWR_bookedLocHold     = _bookedLoc; publicVariable "CSWR_bookedLocHold" };
		// Spawns:
		case "BOOKING_SPAWNVEH":  { CSWR_bookedLocSpwnVeh  = _bookedLoc; publicVariable "CSWR_bookedLocSpwnVeh" };
		case "BOOKING_SPAWNHELI": { CSWR_bookedLocSpwnHeli = _bookedLoc; publicVariable "CSWR_bookedLocSpwnHeli" };
	};
	// Debug:
	if ( CSWR_isOnDebug && _mkrType isEqualTo "BOOKING_HOLD" ) then {
		// Hold message 1:
		systemChat format ["%1 HOLD > A %2 tracked vehicle's changing position...",
		CSWR_txtDebugHeader, _tag];
		// Hold message 2:
		if CSWR_isOnDebugHold then {
			["%1 HOLD > %2 > Now, %3 tracked vehicle(s) in perfect HOLDING.",
			CSWR_txtDebugHeader, _tag, _bookedAmount] call BIS_fnc_error;
		};
		// Breather:
		sleep 1;
	};
	// Return:
	true;
};


THY_fnc_CSWR_convertion_side_to_tag = {
	// This function converts the side name to the owner tag for further validations.
	// Returns _tag: string of side abbreviation.

	params ["_side"];
	private ["_tag"];

	// Initial values:
	_tag = "";
	// Main validation:
	switch _side do {
		case BLUFOR:      { _tag = "BLU" };
		case OPFOR:       { _tag = "OPF" };
		case INDEPENDENT: { _tag = "IND" };
		case CIVILIAN:    { _tag = "CIV" };
		default { /* Debug message is not needed here coz the error handling is make in THY_fnc_CSWR_add_people and THY_fnc_CSWR_add_vehicle functions */ };
	};
	// Return:
	_tag;
};


THY_fnc_CSWR_is_valid_classname = {
	// This function checks if the classnames entered are valid.
	// Return _isValid: bool.
	// Param > _what: name of what kind of classname(s) is/are been checked.
	// Param > _var: name of the classname(s) variable to be checked.
	// Param > _classnames: can receive string or array with strings.
	// Param > _cfgClass: can receive Arma-CfgClasses or just leave empty ("") for non-Arma-CfgClasses.
	/*                CfgVehicles:
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_EAST  (vehicles, units, and objs like trailer for vehicles [mobile radar station, etc] )
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_WEST  (vehicles, units, and objs like trailer for vehicles [mobile radar station, etc] )
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_GUER  (vehicles, units, and objs like trailer for vehicles [mobile radar station, etc] )
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_CIV
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_Structures
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_Ruins_%26_Wrecks
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_Equipment  (Backpacks)
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_EMPTY  (objects)
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_VR_Objects
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_Animals
	                         https://community.bistudio.com/wiki/Arma_3:_CfgVehicles_Other
	                  CfgWeapons:
	                         https://community.bistudio.com/wiki/Arma_3:_CfgWeapons_Weapons
	                         https://community.bistudio.com/wiki/Arma_3:_CfgWeapons_Vehicle_Weapons
	                         https://community.bistudio.com/wiki/Arma_3:_CfgWeapons_Items
	                         https://community.bistudio.com/wiki/Arma_3:_CfgWeapons_Equipment  (uniforms, vests, helmets)
	                  CfgMagazines:
	                         https://community.bistudio.com/wiki/Arma_3:_CfgMagazines
	                  CfgGlasses:
	                         Wiki not found. (balaclavas, glasses, goggles, facewears)
	
	Source: https://community.bistudio.com/wiki/BIS_fnc_exportCfgVehiclesAssetDB
	*/

	params ["_tag", "_cfgClass", "_what", "_var", "_classnames"];
	private ["_isValid"];

	// Initial values:
	_isValid = true;
	// Errors handling > If _classnames receive something that's not an array, convert it to an array:
	if ( typeName _classnames isNotEqualTo "ARRAY" ) then { _classnames = [_classnames] };
	_what = toUpper _what;
	// Escape > If array empty:
	if ( _classnames isEqualTo [] ) exitWith {
		// Prepare to return:
		_isValid = false;
		// Warning:
		systemChat format ["%1 %2 > The variable '%3' looks EMPTY. Fix it to avoid errors.",
		CSWR_txtWarnHeader, _tag, _var]; sleep 5;
		// Return:
		_isValid;
	};
	// Escape > If array with no string content:
	{  // forEach _classnames:
		if ( typeName _x isNotEqualTo "STRING" ) then { 
			// Update the validation flag:
			_isValid = false;
			// Warning:
			systemChat format ["%1 %2 > One or more items of '%3' are NOT string types. Fix it to avoid errors.",
			CSWR_txtWarnHeader, _tag, _var]; sleep 5;
			breakTo "earlyreturn";
		};
	} forEach _classnames;
	// Escape > if editor's using 'RANDOM' for uniform, it's ok, just leave as valid:
	if ( _what isEqualTo "UNIFORM" && (_classnames # 0) isEqualTo "RANDOM" ) exitWith { _isValid;  /* Returning true */ };  // DONT check the side of the uniform. It's done in loadout functions.
	// If the _cfgClass spelled is known:
	if ( _cfgClass isNotEqualTo "" && _cfgClass in ["CfgVehicles", "CfgWeapons", "CfgMagazines", "CfgGlasses"] ) then {
		{  // forEach _classnames:
			// If the classname is not empty string ("") and not a string called "REMOVE", keep going with the validation:
			// Important: this is important to LOADOUT Customization settings in CSWR Script.
			if ( _x isNotEqualTo "" && _x isNotEqualTo "REMOVED" ) then {
				// Checking if the each classname (_x) exists. If not, abort:
				if ( !(isClass (configFile >> _cfgClass >> _x)) ) then {
					// Update the validation flag:
					_isValid = false;
					// Warning:
					systemChat format ["%1 GROUP or VEHICLE > %2 '%3' is NOT a VALID %4 CLASSNAME. Check if it's spelled correct or, if it's from a mod, the mod is loaded on server. FIX IT!",
					CSWR_txtWarnHeader, _tag, _x, _what]; sleep 5;
					breakTo "earlyreturn";
				};
			};
		} forEach _classnames;
	// Otherwise, _cfgClass spelled is UNknown:
	} else {
		// Update the validation flag:
		_isValid = false;
		// if _cfgClass is NOT empty, but doesn't belong some Arma Official cfgClass:
		if ( _cfgClass isNotEqualTo "" ) then {
			// Warning:
			systemChat format ["%1 THY_fnc_CSWR_is_valid_classname > _cfgClass ('%2') declaration is not known. Check if CfgClass you're using doesn't come from a not loaded mod.",
			CSWR_txtWarnHeader, _cfgClass]; sleep 5;
		// If _cfgClass empty:
		} else {
			// Warning:
			systemChat format ["%1 THY_fnc_CSWR_is_valid_classname > _cfgClass declaration is empty.",
			CSWR_txtWarnHeader, _cfgClass]; sleep 5;
		};
	};
	// Return:
	scopeName "earlyreturn";
	_isValid;
};


THY_fnc_CSWR_is_valid_classnames_type = {
	// This function checks if each classname in an array is one of the classname types allowed.
	// Returns _isValid. Bool.

	params ["_tag", "_classnames", "_grpClass", "_isVeh"];
	private ["_isValid", "_allowedTypes", "_classnameType", "_classnamesOk", "_delta", "_allowedType", "_txt1"];

	// Initial values:
	_isValid       = true;
	_allowedTypes  = [];
	_classnameType = [];
	_classnamesOk  = [];
	_delta         = 0;
	// Declarations:
	switch _grpClass do {
		case 0: { _allowedTypes = ["Man"] };  // People/soldiers/Units
		case 1: { _allowedTypes = ["Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC"] };  // Ground vehicle (including amphibious)
		case 2: { _allowedTypes = ["Ship"] };  // Nautical vehicle
		case 3: { _allowedTypes = ["Helicopter"] };  // Helicopter
	};
	// Escape:
	if ( _classnames isEqualTo [] ) exitWith { _isValid = false; _isValid /* Returning... */ };
	// Debut texts:
	_txt1 = "Fix it in 'fn_CSWR_2_population.sqf' file";
	{  // forEach _allowedTypes:
		_allowedType = _x;
		{  // forEach _classnames:
			// if group members:
			if !_isVeh then {
				// If the classname is an abled type, include this valid classname in another array:
				if ( _x isKindOf _allowedType ) then { _classnamesOk pushBack _x };
			// otherwise, if vehicle:
			} else {
				// Using this method for vehicles to prevent the insertion of nautical vehicles or planes, etc:
				_classnameType = (_x call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
				// If the classname is an abled type, include this valid classname in another array:
				if ( _classnameType in _allowedType ) then { _classnamesOk pushBack _x };
			};
		} forEach _classnames;
		// CPU breather:
		sleep 0.1;
	} forEach _allowedTypes;
	// If there's difference between the size of both arrays, it's coz some classname is NOT an allowed type:
	if ( count _classnames isNotEqualTo count _classnamesOk ) then {
		// Update the validation flag:
		_isValid = false;
		// if group (array of units):
		if !_isVeh then {
			// Declarations:
			_delta = (count _classnames) - (count _classnamesOk);
			// Warning:
			if ( _delta isEqualTo 1 ) then {
				// singular message:
				systemChat format ["%1 GROUP > %3 classname used to build a %2 GROUP is NOT a UNIT CLASSNAME, then the entire group CANNOT be spawned. %4.",
				CSWR_txtWarnHeader, _tag, _delta, _txt1];
				// Reading breather:
				sleep 10;
			} else {
				// plural message:
				systemChat format ["%1 GROUP > %3 classnames used to build a %2 GROUP are NOT UNIT CLASSNAMES, then the group CANNOT be spawned. %4.",
				CSWR_txtWarnHeader, _tag, _delta, _txt1];
				// Reading breather:
				sleep 10;
			};
		// if vehicle (string):
		} else {
			// Warning:
			systemChat format ["%1 VEHICLE > The classname used to build a %2 %3 is NOT a %3 CLASSNAME, then it CANNOT be spawned. %4.",
			CSWR_txtWarnHeader,
			_tag,
			if (_grpClass isEqualTo 1) then {"GROUND VEHICLE"} else {if (_grpClass isEqualTo 3) then {"HELICOPTER"} else {"NAUTICAL VEHICLE"}},
			_txt1];
			// Breather:
			sleep 10;
		};
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_is_valid_behavior = {
	// This function just validates if there is a valid behavior to the units for further validations.
	// Return _return: bool.

	params ["_tag", "_isVeh", "_behavior"];
	private ["_return"];

	// Initial value:
	_return = [_behavior, false];  // [behavior original typing, isValid];
	// Errors handling:
	if ( typeName _behavior isEqualTo "STRING" ) then { _behavior = toUpper _behavior };
	// If the configured behavior is known:
	if ( _behavior in ["BE_SAFE", "BE_AWARE", "BE_COMBAT", "BE_STEALTH", "BE_CHAOS"] ) then { 
		// Preparing to successfully return:
		_return = [_behavior, true];
	// Otherwise:
	} else {
		// Warning:
		systemChat format ["%1 %2 > One or more %3s HAS NO BEHAVIOR properly configured in 'fn_CSWR_2_population.sqf' file. Check the documentation. For script integrity, the %3 WON'T BE CREATED.",
		CSWR_txtWarnHeader, _tag, if _isVeh then {"vehicle"} else {"group"}]; sleep 5;
	};
	// Return:
	_return;
};


THY_fnc_CSWR_is_valid_formation = {
	// This function just validates if there is a valid formation to the group for further validations.
	// Return _return: bool.

	params ["_tag", "_isVeh", "_form"];
	private ["_return"];

	// Initial value:
	_return = [_form, false];  // [formation original typing, isValid];
	
	// Escape:
	if _isVeh exitWith { _return /* Returning... */ };
	// Errors handling:
	if ( typeName _form isEqualTo "STRING" ) then { _form = toUpper _form };
	// Declarations:
		// Reserved space.
	// Debug texts:
		// reserved space.
	// If the configured formation is valid: https://community.bistudio.com/wiki/formation
	if ( _form in ["COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"] ) then { 
		// Preparing to successfully return:
		_return = [_form, true];
	// Otherwise:
	} else {
		// Warning:
		systemChat format ["%1 GROUP > One or more %2 groups HAS NO FORMATION properly configured in 'fn_CSWR_2_population.sqf' file. Check the documentation. For script integrity, the group WON'T BE CREATED.",
		CSWR_txtWarnHeader, _tag]; sleep 5;
	};
	// Return:
	_return;
};


THY_fnc_CSWR_is_playerNear = {
	// This function searches for humam players around a specific unit (_unitTarget).
	// Returns _isPlayerNear: bool.

	params ["_unitTarget", "_kindOfPlayer", "_distLimiterPlayer"];
	private ["_isPlayerNear", "_playersAlive"];

	// Initial values:
	_isPlayerNear = false;
	_playersAlive = [];
	// If the function must scan only for friendly players, do it:
	if ( _kindOfPlayer isEqualTo "friendlyPlayers" ) then {
		// WIP - actually a friendly side is not been considered here yet. Check the command when working on: BIS_fnc_friendlySides
		_playersAlive = allPlayers - entities "HeadlessClient_F" select { alive _x && (side _x) isEqualTo (side _unitTarget) };
	// Otherwise:
	} else {
		// If the function must scan all players, do it:
		if ( _kindOfPlayer isEqualTo "allPlayers" ) then {
			_playersAlive = allPlayers - entities "HeadlessClient_F" select { alive _x };
		};
	};
	// Check if some player is near to the unit-target:
	{ if ( _x distance _unitTarget < _distLimiterPlayer ) then { _isPlayerNear = true; break } } forEach _playersAlive;
	// Return:
	_isPlayerNear;
};


THY_fnc_CSWR_is_spawn_paradrop = {
	// This function checks if the spawn-points are paradrop type, and it updates the _spwnPos with the right drop altitude.
	// Returns _return. Array: [bool, [y,x,z]].

	params ["_spwns", "_spwnPos", "_isVeh", "_isAmphib", "_forbidden"];
	private ["_return", "_isPara"];

	// Initial values:
	_isPara = false;
	_return = [_isPara, _spwnPos];
	// Escape > if a forbidden vehicle/group is here, abort:
	if ( _forbidden # 0 || _forbidden # 1 /* _forbidden findIf { _x isEqualTo true } > -1 */ ) exitWith { _return };
	// If _spwns are the side paradrop spawns, keep going:
	if ( _spwns in [
		CSWR_spawnsParadropBLU # 0, /* CSWR_spawnsParadropBLU # 1, */
		CSWR_spawnsParadropOPF # 0, /* CSWR_spawnsParadropOPF # 1, */
		CSWR_spawnsParadropIND # 0, /* CSWR_spawnsParadropIND # 1, */
		CSWR_spawnsParadropCIV # 0  /* CSWR_spawnsParadropCIV # 1, */
		] ) then {
		// Update the validation flag:
		_isPara = true;
		// Update the altitude of _spwnPos:
		// For People:
		if !_isVeh then {
			_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropUnitAlt];
		} else {
			// For Regular Ground Vehicle:
			if !_isAmphib then {
				_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropVehAlt];
			// For Amphibious Vehicle:
			} else {
				// This fix an issue with amphibious position during paradrop (PositionAGL if watercraft or amphibious):
				_spwnPos = [
					(_spwnPos # 0) + random [-CSWR_spwnsParadropSpreading, 0, CSWR_spwnsParadropSpreading],
					(_spwnPos # 1) + random [-CSWR_spwnsParadropSpreading, 0, CSWR_spwnsParadropSpreading],
					abs CSWR_spwnsParadropVehAlt
				];
			};
		};
	};
	// Prepare to return:
	_return = [_isPara, _spwnPos];
	// Return:
	_return;
};


THY_fnc_CSWR_grp_data = {
	// This function returns a "dictionary" (manual 'hashMap') with group's features to be used for other functions later, and check basic rules about some group-types.
	// Important 1: When this func runs, the group doesn't exist yet.
	// Important 2: where each group-type can spawn is defined in fn_CSWR_1_management.sqf and its spawn rules are in THY_fnc_CSWR_spawn_type_checker just like the destination rules are in THY_fnc_CSWR_destination_type_checker.
	// Returns _grpData array. If it returns empty, it's because the group is invalid and can't be spawned.

	params["_side", "_tag", "_grpClassnames", "_destType", "_behavior", "_form"];
	private["_teamLight", "_teamMedium", "_teamHeavy", "_teamCustom1", "_teamCustom2", "_teamCustom3", "_teamSniper", "_vehLight", "_vehMedium", "_vehHeavy", "_vehCustom1", "_vehCustom2", "_vehCustom3", "_nauLight", "_nauMedium", "_nauHeavy", "_heliLight", "_heliMedium", "_heliHeavy", "_isError", "_grpData", "_grpType"];

	// Initial values:
	_teamLight=[]; _teamMedium=[]; _teamHeavy=[]; _teamCustom1=[]; _teamCustom2=[]; _teamCustom3=[]; _teamSniper=[];  // people groups;
	_vehLight=[]; _vehMedium=[]; _vehHeavy=[]; _vehCustom1=[]; _vehCustom2=[]; _vehCustom3=[]; _nauLight=[]; _nauMedium=[]; _nauHeavy=[]; _heliLight=[]; _heliMedium=[]; _heliHeavy=[];  // vehicle groups;
	_isError = false;
	_grpData = [];
	
	// STEP 1/3 > BUILDING THE GROUP DICTIONARY ----------------------------------------------------------------------
	// It'll be used a lot for further validations.
	switch _side do {
		case BLUFOR: {
			// People group:
			_teamLight   = CSWR_people_BLU_light;
			_teamMedium  = CSWR_people_BLU_medium;
			_teamHeavy   = CSWR_people_BLU_heavy;
			_teamCustom1 = CSWR_people_BLU_custom_1;
			_teamCustom2 = CSWR_people_BLU_custom_2;
			_teamCustom3 = CSWR_people_BLU_custom_3;
			_teamSniper  = CSWR_people_BLU_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_BLU_ground_light];
			_vehMedium  = [CSWR_vehicle_BLU_ground_medium];
			_vehHeavy   = [CSWR_vehicle_BLU_ground_heavy];
			_vehCustom1 = [CSWR_vehicle_BLU_ground_custom_1];
			_vehCustom2 = [CSWR_vehicle_BLU_ground_custom_2];
			_vehCustom3 = [CSWR_vehicle_BLU_ground_custom_3];
			_nauLight   = [CSWR_vehicle_BLU_nautic_light];
			_nauMedium  = [CSWR_vehicle_BLU_nautic_medium];
			_nauHeavy   = [CSWR_vehicle_BLU_nautic_heavy];
			_heliLight  = [CSWR_vehicle_BLU_heli_light];
			_heliMedium = [CSWR_vehicle_BLU_heli_medium];
			_heliHeavy  = [CSWR_vehicle_BLU_heli_heavy];
		};
		case OPFOR: {
			// People group:
			_teamLight   = CSWR_people_OPF_light;
			_teamMedium  = CSWR_people_OPF_medium;
			_teamHeavy   = CSWR_people_OPF_heavy;
			_teamCustom1 = CSWR_people_OPF_custom_1;
			_teamCustom2 = CSWR_people_OPF_custom_2;
			_teamCustom3 = CSWR_people_OPF_custom_3;
			_teamSniper  = CSWR_people_OPF_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_OPF_ground_light];
			_vehMedium  = [CSWR_vehicle_OPF_ground_medium];
			_vehHeavy   = [CSWR_vehicle_OPF_ground_heavy];
			_vehCustom1 = [CSWR_vehicle_OPF_ground_custom_1];
			_vehCustom2 = [CSWR_vehicle_OPF_ground_custom_2];
			_vehCustom3 = [CSWR_vehicle_OPF_ground_custom_3];
			_nauLight   = [CSWR_vehicle_OPF_nautic_light];
			_nauMedium  = [CSWR_vehicle_OPF_nautic_medium];
			_nauHeavy   = [CSWR_vehicle_OPF_nautic_heavy];
			_heliLight  = [CSWR_vehicle_OPF_heli_light];
			_heliMedium = [CSWR_vehicle_OPF_heli_medium];
			_heliHeavy  = [CSWR_vehicle_OPF_heli_heavy];
		};
		case INDEPENDENT: {
			// People group:
			_teamLight   = CSWR_people_IND_light;
			_teamMedium  = CSWR_people_IND_medium;
			_teamHeavy   = CSWR_people_IND_heavy;
			_teamCustom1 = CSWR_people_IND_custom_1;
			_teamCustom2 = CSWR_people_IND_custom_2;
			_teamCustom3 = CSWR_people_IND_custom_3;
			_teamSniper  = CSWR_people_IND_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_IND_ground_light];
			_vehMedium  = [CSWR_vehicle_IND_ground_medium];
			_vehHeavy   = [CSWR_vehicle_IND_ground_heavy];
			_vehCustom1 = [CSWR_vehicle_IND_ground_custom_1];
			_vehCustom2 = [CSWR_vehicle_IND_ground_custom_2];
			_vehCustom3 = [CSWR_vehicle_IND_ground_custom_3];
			_nauLight   = [CSWR_vehicle_IND_nautic_light];
			_nauMedium  = [CSWR_vehicle_IND_nautic_medium];
			_nauHeavy   = [CSWR_vehicle_IND_nautic_heavy];
			_heliLight  = [CSWR_vehicle_IND_heli_light];
			_heliMedium = [CSWR_vehicle_IND_heli_medium];
			_heliHeavy  = [CSWR_vehicle_IND_heli_heavy];
		};
		case CIVILIAN: {
			// People group:
			_teamLight   = CSWR_people_CIV_light;
			_teamMedium  = CSWR_people_CIV_medium;
			_teamHeavy   = CSWR_people_CIV_heavy;
			_teamCustom1 = CSWR_people_CIV_custom_1;
			_teamCustom2 = CSWR_people_CIV_custom_2;
			_teamCustom3 = CSWR_people_CIV_custom_3;
			_teamSniper  = [];  // Civilian has no sniper group.
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_CIV_ground_light];
			_vehMedium  = [CSWR_vehicle_CIV_ground_medium];
			_vehHeavy   = [CSWR_vehicle_CIV_ground_heavy];
			_vehCustom1 = [CSWR_vehicle_CIV_ground_custom_1];
			_vehCustom2 = [CSWR_vehicle_CIV_ground_custom_2];
			_vehCustom3 = [CSWR_vehicle_CIV_ground_custom_3];
			_nauLight   = [CSWR_vehicle_CIV_nautic_light];
			_nauMedium  = [CSWR_vehicle_CIV_nautic_medium];
			_nauHeavy   = [CSWR_vehicle_CIV_nautic_heavy];
			_heliLight  = [CSWR_vehicle_CIV_heli_light];
			_heliMedium = [CSWR_vehicle_CIV_heli_medium];
			_heliHeavy  = [CSWR_vehicle_CIV_heli_heavy];
		};
		default { systemChat format ["%1 SIDE > There is no side called '%2'. There are only 'BLUFOR', 'OPFOR', 'INDEPENDENT' and 'CIVILIAN'. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _side]; _isError = true };
	};
	// Escape:
	if _isError exitWith { _grpData /* Returning */ };
	// Group information > basic:
	// _grpData is [ group side (side variable), group side tag (str), group id (obj), group type (str), group classnames ([strs]), group class (int), group behavior (str), group formation (str), destination type (str) ]
	_grpData = [_side, _tag, grpNull, "", [], nil, _behavior, _form, _destType];
	// Group information > specificity:
	switch _grpClassnames do {
		// People group:            (_grpType)                  (_grpClassnames)             (_grpClass)
		case _teamLight:   { _grpData set [3, "teamL"];  _grpData set [4, _teamLight];   _grpData set [5, 0] };
		case _teamMedium:  { _grpData set [3, "teamM"];  _grpData set [4, _teamMedium];  _grpData set [5, 0] };
		case _teamHeavy:   { _grpData set [3, "teamH"];  _grpData set [4, _teamHeavy];   _grpData set [5, 0] };
		case _teamCustom1: { _grpData set [3, "teamC1"]; _grpData set [4, _teamCustom1]; _grpData set [5, 0] };
		case _teamCustom2: { _grpData set [3, "teamC2"]; _grpData set [4, _teamCustom2]; _grpData set [5, 0] };
		case _teamCustom3: { _grpData set [3, "teamC3"]; _grpData set [4, _teamCustom3]; _grpData set [5, 0] };
		case _teamSniper:  { _grpData set [3, "teamS"];  _grpData set [4, _teamSniper];  _grpData set [5, 0] };
		// Vehicle > Ground:
		case _vehLight:    { _grpData set [3, "vehL"];   _grpData set [4, _vehLight];    _grpData set [5, 1] };
		case _vehMedium:   { _grpData set [3, "vehM"];   _grpData set [4, _vehMedium];   _grpData set [5, 1] };
		case _vehHeavy:    { _grpData set [3, "vehH"];   _grpData set [4, _vehHeavy];    _grpData set [5, 1] };
		case _vehCustom1:  { _grpData set [3, "vehC1"];  _grpData set [4, _vehCustom1];  _grpData set [5, 1] };
		case _vehCustom2:  { _grpData set [3, "vehC2"];  _grpData set [4, _vehCustom2];  _grpData set [5, 1] };
		case _vehCustom3:  { _grpData set [3, "vehC3"];  _grpData set [4, _vehCustom3];  _grpData set [5, 1] };
		// Vehicle > Nautical:
		case _nauLight:    { _grpData set [3, "nauL"];   _grpData set [4, _nauLight];    _grpData set [5, 2] };
		case _nauMedium:   { _grpData set [3, "nauM"];   _grpData set [4, _nauMedium];   _grpData set [5, 2] };
		case _nauHeavy:    { _grpData set [3, "nauH"];   _grpData set [4, _nauHeavy];    _grpData set [5, 2] };
		// Vehicle > Air:
		case _heliLight:   { _grpData set [3, "heliL"];  _grpData set [4, _heliLight];   _grpData set [5, 3] };
		case _heliMedium:  { _grpData set [3, "heliM"];  _grpData set [4, _heliMedium];  _grpData set [5, 3] };
		case _heliHeavy:   { _grpData set [3, "heliH"];  _grpData set [4, _heliHeavy];   _grpData set [5, 3] };

		// Important: Despite for vehicles is easy to know if they are part of marines ("nau..."), for people it's not coz what defines whether units are marines is their spawn-point
		// and here CSWR still doesn't know where the group will spawn. The same occurs with paratroopers. That's why both features are not stored in _grpData.
	};
	
	// STEP 2/3 > CHECK GROUP-TYPE CLASSNAMES QUALITY ----------------------------------------------------------------
	// Escape > It warning the editor if they register a helicopter classname in a group of soldier classnames, for example:
	if !([_tag, _grpClassnames, _grpData # 5, (_grpData # 5) isNotEqualTo 0] call THY_fnc_CSWR_is_valid_classnames_type) exitWith {
		// Prepare to return:
		_grpData = [];
		// Return:
		_grpData;
	};
	
	// STEP 3/3 > GROUP-TYPE AND GROUP-CLASS RULES -------------------------------------------------------------------
	// If a group-type (people and vehicle) needs to respect some rule about itself, put here down below!
	// Escape > The sniper team has more units than the limit, abort:
	if ( (_grpData # 3) isEqualTo "teamS" && (count _grpClassnames) > 2 ) then {
		// Warning:
		systemChat format ["%1 DESTINATION > WATCH > %2 SNIPER group CANNOT have more than 2 units! The group WON'T SPAWN! Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag]; sleep 5;
		// Prepare to return:
		_grpData = [];
	};
	// Return:
	_grpData;
};


THY_fnc_CSWR_grp_form = {
	// This function applies a formation to the group. Before, the formation has been validated through another function: THY_fnc_CSWR_is_valid_formation.
	// Returns nothing.

	params ["_grpData"];
	private ["_grp", "_form"];

	// Declarations:
	_grp  = _grpData # 2;
	_form = _grpData # 7;
	// Escape:
	if ( _form isEqualTo "" ) exitWith {};
	// Custom formation:
	_grp setFormation _form;
	// Breather for the group execute the new formation:
	sleep 3;
	// Return:
	true;
};


THY_fnc_CSWR_grp_join_to_survive = {
	// This function tries to find options for a crew with no vehicle and, if something is found, it drives the group to join in another group.
	// Returns nothing.
	
	params ["_tag", "_grpSurvivors", "_toJoin", "_dis", "_tryLimit", "_hasPunish", "_isNauSurvivors", "_shouldIncludePlayers"];
	private ["_grps", "_arrayOne", "_arrayTwo", "_freeSeats", "_grpRescuers", "_t", "_veh", "_unitsToCheck", "_wait"];

	// Escape:
	if ( isNull _grpSurvivors || !alive (leader _grpSurvivors) ) exitWith {};
	// Initial values:
	_grps        = [];
	_arrayOne    = [];
	_arrayTwo    = [];
	_freeSeats   = 0;
	_grpRescuers = grpNull;
	_t           = nil;
	_veh         = objNull;
	// Declarations:
	_unitsToCheck = if !_shouldIncludePlayers then { allUnits - allPlayers } else { allUnits };
	_wait         = 10;
	// Delete their waypoint(s):
	for "_i" from ((count waypoints _grpSurvivors) - 1) to 1 step -1 do { deleteWaypoint [_grpSurvivors, _i]; sleep 0.2 };  // waypoints get immediately re-indexed when one gets deleted, delete them from last to first. Never delete index 0. Deleting index 0 causes oddities in group movement during the game logic. Index 0 of a unit is its spawn point or current point, so delete it brings weird movements or waypoint loses (by Larrow).  // Nov/2024, forEachReversed fixes that too!
	// Trying to find some help:
	while { !isNull _grpSurvivors && _tryLimit > 0 } do {
		// Declarations:
		_grps = _unitsToCheck select {
			// Any ally, except helicopters and units swimming:
			side _x isEqualTo (side (leader _grpSurvivors)) &&
			_x isNotEqualTo (leader _grpSurvivors) &&
			_x distance (leader _grpSurvivors) <= _dis &&
			_x isEqualTo (leader (group _x)) &&
			alive _x &&
			!(vehicle _x isKindOf "helicopter");
		};
		// Select the target to look for:
		switch _toJoin do {
			case 0: {};  // Rescuers can be: any ally available in _grps!
			// Rescuers can be: only groups by foot!
			case 1: { _grps = _grps select { isNull objectParent _x } };
			// Rescuers can be: only vehicles available in _grps!
			case 2: { _grps = _grps select { !isNull objectParent _x } };
			// Rescuers can be: groups by foot but only on land + nautical vehicles (including amphibious vehicles but only when in water)!
			case 3: { 
				_arrayOne = _grps select { isNull objectParent _x && !surfaceIsWater getPosASLW _x };
				_arrayTwo = _grps select { !isNull objectParent _x && surfaceIsWater getPosASLW _x };
				_grps     = _arrayOne + _arrayTwo;
			};
		};
		// Breather:
		sleep 1;
		// If one or more groups have been found to join:
		if ( _grps isNotEqualTo [] ) then {
			// If a rescuer vehicle is an option, and the closest one is exactly a vehile:
			if ( _toJoin in [0, 2, 3] && !isNull objectParent (_grps # 0) ) then {
				// Check available seats:
				_freeSeats = vehicle leader (_grps # 0) emptyPositions "";  // returns a number of all ("") positions free.
				// If has NO the minimum seats available:
				if ( _freeSeats < 2 ) then {
					// If the second closest rescuer (if it exists) is by foot, so delete the index 0 (vehicle register) and keep going, otherwise finish the search:
					if ( isNil { isNull objectParent (_grps # 1) } ) then { _grps deleteAt 0 } else { _tryLimit = 0; break };
				};
			};
			// Internal declarations:
			_grpRescuers = group (_grps # 0);
			_t  = time + 300;  // 5min
			// Make the rescuers wait the survivors without loose their waypoint:
			doStop units _grpRescuers;
			// Debug:
			if CSWR_isOnDebug then {
				["%1 SURVIVORS > %2 survivors crew found %3 rescuers: %4 %5",
				CSWR_txtDebugHeader,
				_tag,
				count _grps,
				_grps,
				if (!isNull objectParent (_grps # 0)) then {format ["| Coming = vehicle with %1 free seats.", _freeSeats]} else {""}] call BIS_fnc_error; sleep 1;
			};
			// Body pos:
			if ( _tag isNotEqualTo "CIV" ) then {
				// Rescuer leader body pos to wait survivors:
				if ( isNull objectParent leader _grpRescuers) then { leader _grpRescuers setUnitPos "MIDDLE" };
			};
			// For Non-Nautical survivors + Nautical survivors if rescuers by foot:
			if ( !_isNauSurvivors || { _isNauSurvivors && isNull objectParent leader _grpRescuers } ) then {
				// Restore survivor leader body pos:
				leader _grpSurvivors setUnitPos "UP";
				// Forcing the AI to go faster but still in combat if needed:
				[_grpSurvivors, "BE_CHAOS", false, false] call THY_fnc_CSWR_grp_behavior;
				[_grpSurvivors, "BE_CHAOS", false, false] call THY_fnc_CSWR_unit_behavior;
				// Go to the rescuer leader pos:
				units _grpSurvivors doMove getPosATL (leader _grpRescuers);
			// For Nautical survivors for rescuers by boat:
			} else {
				[_grpSurvivors, "BE_COMBAT", false, false] call THY_fnc_CSWR_grp_behavior;
				[_grpSurvivors, "BE_COMBAT", false, false] call THY_fnc_CSWR_unit_behavior;
				_grpSurvivors setFormation "VEE";  // Force all members of a huge group leave the water, but still leader almost in water to be pick up by vehicle if the case!
				// Critical: it below doesn't work well enough. For nautical vehicles, it's better the survivors wait for than rescuers be super close:
				//units _grpSurvivors doMove getPosASLW (leader _grpRescuers);
			};
			// If rescuers by vehicle, make the their vehicle gets closer too:
			// Critical: it's mandatory if you wanna make nautical rescue works!
			if ( !isNull objectParent leader _grpRescuers ) then {
				if _isNauSurvivors then { _wait = 5 };  // Critical! Never bigger than 5! 
				units _grpRescuers doMove (getPosATL (leader _grpSurvivors));  // WIP: if the rescuer vehicle is in HOLD destination???
			};
			// Wait until the survivors get closer the rescuers:
			waitUntil {
				// Breather for the next loop check:
				sleep _wait;
				// Conditions to break the loop:
				isNull _grpSurvivors || isNull _grpRescuers || leader _grpSurvivors distance leader _grpRescuers < 50 || time > _t;
			};
			// For Non-Nautical survivors + Nautical survivors if rescuers by foot:
			// Updating the rescue leader pos in case the rescuer change too much their pos!
			if ( !_isNauSurvivors || { _isNauSurvivors && isNull objectParent leader _grpRescuers } ) then {
				units _grpSurvivors doMove getPosATL (leader _grpRescuers);
			} else {
				// Critical: it below doesn't work well enough. For nautical vehicles, it's better the survivors wait for than rescuers be super close:
				//units _grpSurvivors doMove getPosASLW (leader _grpRescuers);
			};
			// Wait until the survivors arrival:
			waitUntil {
				// Breather for the next loop check:
				sleep _wait;
				// Conditions to break the loop:
				isNull _grpSurvivors || isNull _grpRescuers || leader _grpSurvivors distance leader _grpRescuers < 40;
			};
			// Both leaders are alive:
			if ( alive leader _grpSurvivors && alive leader _grpRescuers ) then {
				// They are close enough:
				if ( leader _grpSurvivors distance leader _grpRescuers <= 40 ) then {
					// Rescuer leader has a vehicle:
					if ( !isNull objectParent leader _grpRescuers ) then {
						// Move to the nautical/amphibious vehicle  pos:
						if _isNauSurvivors then { 
							leader _grpSurvivors setUnitPos "UP";
							units _grpSurvivors doMove getPosASLW (leader _grpRescuers);
						};
						// Teleport the survivors to the free vehicle seats:
						_veh = vehicle leader _grpRescuers;
						{ _x moveInAny _veh; sleep 1 } forEach units _grpSurvivors;
						// Survivors still out of vehicle must be deleted:
						{ if ( isNull objectParent _x ) then { sleep 1; deleteVehicle _x } } forEach units _grpSurvivors;
						// Forcing the vehicle to go to its planned waypoint position:
						// Critical: without this, amphibious vehicle doesn't leave the rescue position, staying stuck over there - WEIRD BEHAVIOR)!
						if ( waypoints _grpRescuers isNotEqualTo [] ) then { driver (vehicle leader _grpRescuers) doMove (waypointPosition [_grpRescuers, 1]) };
					};
					// Make the crew join in the first found ally group:
					(units _grpSurvivors) joinSilent _grpRescuers;
					// Debug:
					if CSWR_isOnDebug then {
						systemChat format ["%1 SURVIVORS > A %2 crew SURVIVED their vehicle lost and successfully JOINED in a rescuer group.",
						CSWR_txtDebugHeader, _tag]; sleep 1;
					};
				// Something went wrong:
				} else { _tryLimit = 0/*; break */ };
			};
			// Restore the rescuer leader body pos if they are not in a vehicle:
			if ( isNull objectParent leader _grpRescuers ) then { leader _grpRescuers setUnitPos "UP" };
			// Restore the rescuer group default behavior:
			units _grpRescuers doFollow leader _grpRescuers;
		} else {
			// Control:
			_tryLimit = _tryLimit - 1;
			// Large cooldown before the next try:
			sleep 60;
		};
	};  // While-loop ends.
	// Otherwise, if there's NO hope:
	if ( !isNull _grpSurvivors ) then {
		// Debug:
		if CSWR_isOnDebug then {
			["%1 SURVIVORS > A %2 has finished their search for rescuers and FAILED.",
			CSWR_txtDebugHeader, _tag] call BIS_fnc_error; sleep 1;
		};
		// Action:
		if ( _tryLimit isEqualTo 0 && _hasPunish ) then {
			{ _x setDamage 1 } forEach units _grpSurvivors;
		} else {
			// Tweak the behavior to last standing:
			[_grpSurvivors, "BE_AWARE", false, false] call THY_fnc_CSWR_grp_behavior;
			[_grpSurvivors, "BE_AWARE", false, false] call THY_fnc_CSWR_unit_behavior;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_grp_behavior = {
	// This function defines the group behavior only. This always will run first than THY_fnc_CSWR_unit_behavior.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.

	params ["_grp", "_behavior", "_isVeh", ["_isHunting", false]];
	//private [""];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
	if ( side _grp isEqualTo CIVILIAN && _behavior in ["BE_COMBAT", "BE_STEALTH"] ) then {
		// warning message:
		systemChat format ["%1 > A CIV group/vehicle tries to set its behavior as '%2', and civilians can behave only as '_be_SAFE', '_be_AWARE', and '_be_CHAOS'. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _behavior]; sleep 3;
		// Fixing:
		_behavior = "BE_AWARE";
	};
	// Declarations:
	if _isHunting then { _behavior = "BE_CHAOS" };
	switch _behavior do {
		case "BE_SAFE": {
			_grp setBehaviourStrong "SAFE";  // calm.
			_grp setSpeedMode "LIMITED";  // walk, wait for the group members.
		};
		case "BE_AWARE": {
			_grp setBehaviourStrong "AWARE";  // consern.
			_grp setSpeedMode "LIMITED";  // walk, but guns ready, wait for the group members.
		};
		case "BE_COMBAT": {
			// If crew group:
			if _isVeh then {
				_grp setBehaviourStrong "COMBAT";  // much higher combat performance than Aware.
				_grp setSpeedMode "NORMAL";  // full speed, maintain formation.
			// If infantry group:
			} else {
				_grp setBehaviourStrong "AWARE";  // guns ready. Dont set "COMBAT" here coz the bevarior will make the group to prone and stuff over and over again.
				_grp setSpeedMode "NORMAL";  // full speed, maintain formation.
			};
		};
		case "BE_STEALTH": {
			_grp setBehaviourStrong "STEALTH";  // will cause a group to behave in a very cautious manner. 
			_grp setSpeedMode "NORMAL";  // full speed, maintain formation.
		};
		case "BE_CHAOS": {
			// If crew group:
			if _isVeh then {
				_grp setBehaviourStrong "COMBAT";
			// If infantry group:
			} else {
				_grp setBehaviourStrong "AWARE";  // Dont set "COMBAT" here coz the bevarior will make the group to prone and stuff over and over again.
			};
			_grp setCombatMode "RED";  // Mandatory if the waypoint is "SAD" type (for helicopters/air crew). Never remove it!
			_grp setSpeedMode "FULL";  // do not wait for any other units in formation.
		};
		default { systemChat format ["%1 %2 > THERE IS NO behavior called '%3'. Check the documentation and fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, side (leader _grp), _behavior] };
	};
	// CPU breather
	sleep 0.1;
	// Return:
	true;
};


THY_fnc_CSWR_unit_behavior = {
	// This function defines the unit behavior inside their group. This always will run right after the THY_fnc_CSWR_grp_behavior.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.

	params ["_grp", "_behavior", "_isVeh", ["_isHunting", false]];
	//private [""];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	if (side _grp isEqualTo CIVILIAN && _behavior in ["BE_COMBAT", "BE_STEALTH"] ) exitWith {};  // the warning message is in THY_fnc_CSWR_grp_behavior already ;)
	// Declarations:
	if _isHunting then { _behavior = "BE_CHAOS" };
	{  // forEach units _grp;:
		switch _behavior do {
			case "BE_SAFE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				weaponLowered _x;  // stay the gun low.
			};
			case "BE_AWARE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
			};
			case "BE_COMBAT": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
			};
			case "BE_STEALTH": {
				_x setUnitCombatMode "WHITE";  // Hold Fire, Engage.
			};
			case "BE_CHAOS": {
				_x setUnitCombatMode "RED";  // Fire at will, engage at will/loose formation. Mandatory for helicopter/air-crew using 'SAD' waypoint type.
			};
		};
		// CPU breather:
		sleep 0.1;
	} forEach units _grp;
	// Return:
	true;
};


THY_fnc_CSWR_unit_skills = {
	// This function defines the unit skills inside their Group Type.
	// Check this out: https://community.bistudio.com/wiki/Arma_3:_AI_Skill#Sub-Skills
	// Info: 0.6
	// Returns nothing.

	params ["_grpType", "_grp", "_destType", "_tag"];
	private ["_exp", "_expValue"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_exp      = "";
	_expValue = nil;
	// Declarations:
	switch _tag do {
		case "BLU": { _exp = toUpper CSWR_watcherAccuranceBLU };
		case "OPF": { _exp = toUpper CSWR_watcherAccuranceOPF };
		case "IND": { _exp = toUpper CSWR_watcherAccuranceIND };
		//case "CIV": {};  // CIV doesn't use Watch-destinations.
	};
	switch _exp do {
		case "R": { _expValue = 0.65 };
		case "V": { _expValue = 0.80 };
		case "E": { _expValue = 0.95 };
	};
	{  // forEach units _grp:
		// If member of Light group:
		if ( _grpType isEqualTo "teamL" ) then {
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 0.7];
			};
		};
		// If member of Medium group:
		if ( _grpType isEqualTo "teamM" ) then {
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 0.8];
			};
		};
		// If member of Heavy group:
		if ( _grpType isEqualTo "teamH" ) then {
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 0.9];
			};
			_x setSkill ["courage", 0.8];
		};
		// If member of Custom 1 group:
			//if ( _grpType isEqualTo "teamC1" ) then {   };
		// If member of Custom 2 group:
			//if ( _grpType isEqualTo "teamC2" ) then {   };
		// If member of Custom 3 group:
			//if ( _grpType isEqualTo "teamC3" ) then {   };
		// If member of Sniper group:
		if ( _grpType isEqualTo "teamS" ) then {
			// skills:
			if ( _x isEqualTo leader _grp ) then {  // leader is the main gunner.
				_x setSkill ["commanding", 0.85];
				_x setSkill ["aimingSpeed", 0.85];
				
			} else {  // The other member is the spotter.
				_x setSkill ["commanding", 0.70];
				_x setSkill ["aimingSpeed", 0.75];
			};
			_x setSkill ["general", 0.75];
			//_x setSkill ["endurance", 0.85];  // disabled in Arma 3
			_x setSkill ["courage", 0.75];
			_x setSkill ["spotDistance", 0.80];
			_x setSkill ["spotTime", 0.70];
			_x setSkill ["aimingShake", _expValue];
			_x setSkill ["aimingAccuracy", _expValue];
			_x setSkill ["reloadSpeed", 0.75];  // a bit faster than when watching.
		};
		// Updating the settings if Sniper group in watch strategy:
		if ( _grpType isEqualTo "teamS" && _destType isEqualTo "MOVE_WATCH" ) then {
			// skills:
			if ( _x isEqualTo leader _grp ) then {  // leader is the main gunner.
				_x setSkill ["commanding", 1];
				_x setSkill ["aimingSpeed", 1];
				
			} else {  // The other member is the spotter.
				_x setSkill ["commanding", 0.85];
				_x setSkill ["aimingSpeed", 0.9];
			};
			_x setSkill ["general", 0.9];
			//_x setSkill ["endurance", 1];  // disabled in Arma 3
			_x setSkill ["courage", 0.85];
			_x setSkill ["spotDistance", 1];
			_x setSkill ["spotTime", 1];
			_x setSkill ["aimingShake", _expValue];
			_x setSkill ["aimingAccuracy", _expValue];
			_x setSkill ["reloadSpeed", 0.85];
		};
		// If crewman of Vehicle Light:
			//if ( _grpType isEqualTo "vehL" ) then {   };
		// If crewman of Vehicle Medium:
			//if ( _grpType isEqualTo "vehM" ) then {   };
		// If crewman of Vehicle Heavy:
			//if ( _grpType isEqualTo "vehH" ) then {   };
		// If crewman of Vehicle Custom 1:
			//if ( _grpType isEqualTo "vehC1" ) then {   };
		// If crewman of Vehicle Custom 2:
			//if ( _grpType isEqualTo "vehC2" ) then {   };
		// If crewman of Vehicle Custom 3:
			//if ( _grpType isEqualTo "vehC3" ) then {   };
		// If crewman of Nautical Light:
			//if ( _grpType isEqualTo "nauL" ) then {   };
		// If crewman of Nautical Medium:
			//if ( _grpType isEqualTo "nauM" ) then {   };
		// If crewman of Nautical Heavy:
			//if ( _grpType isEqualTo "nauH" ) then {   };
		// If crewman of Heli Light:
		if ( _grpType isEqualTo "heliL" ) then {
			// skills:
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 0.90];
			};
			_x setSkill ["spotDistance", 1];  // as Heli Light is closer from the ground (flyInHeight), it's easier to spot the enemy than Heli Heavy.
			_x setSkill ["courage", 0.9];
		};
		// If crewman of Heli Medium:
		if ( _grpType isEqualTo "heliM" ) then {
			// skills:
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 0.95];
			};
			/* if ( _x isEqualTo gunner (vehicle _x) ) then {
				// reserved space.
			} else {
				// reserved space.
			}; */
			_x setSkill ["spotDistance", 0.95];  // as Heli Medium is further from the ground (flyInHeight), it's harder to spot the enemy than Heli Light
			_x setSkill ["courage", 0.9];
		};
		// If crewman of Heli Heavy:
		if ( _grpType isEqualTo "heliH" ) then {
			// skills:
			if ( _x isEqualTo leader _grp ) then {
				_x setSkill ["commanding", 1];
			};
			/* if ( _x isEqualTo gunner (vehicle _x) ) then {
				// reserved space.
			} else {
				// reserved space.
			}; */
			_x setSkill ["spotDistance", 0.90];  // as Heli Heavy is further from the ground (flyInHeight), it's harder to spot the enemy than Heli Light
			_x setSkill ["courage", 0.9];
		};
		// CPU breather
		sleep 0.1;

	} forEach units _grp;
	// Return:
	true;
};


THY_fnc_CSWR_veh_electronic_warfare = {
	// This function sets the electronic warfare resources for vehicles.
	// Returns nothing.

	params ["_tag", "_veh", "_isAirCrew"];
	private ["_isOn"];

	// Initial values:
	_isOn = true;
	// Declarations:
	switch _tag do {
		case "BLU": { _isOn = CSWR_isElectroWarForBLU };
		case "OPF": { _isOn = CSWR_isElectroWarForOPF };
		case "IND": { _isOn = CSWR_isElectroWarForIND };
		case "CIV": { /* this side has no this option */ };
	};
	// Main functionality:
	_veh setVehicleReportOwnPosition _isOn;
	if _isAirCrew then { _veh setVehicleReceiveRemoteTargets true } else { _veh setVehicleReceiveRemoteTargets _isOn };
	_veh setVehicleReportRemoteTargets _isOn;
	// Return:
	true;
};


THY_fnc_CSWR_veh_paradrop = {
	// This function creates the paradrop system for one vehicle, including multiples parachutes attached on it.
	// This is based on the original KK_fnc_paraDrop (http://killzonekid.com/arma-scripting-tutorials-epic-armour-drop/) with some improvements and tweaks about parachute tilts.
	// Returns nothing.

	params ["_tag", "_veh", "_grp"];
	private ["_colorChute", "_vehTypesHeavy", "_vehTypesMedium", "_vehType", "_massCenter", "_mainChute", "_allChutes", "_velocity"];

	// Escape part 1/2:
	_colorChute = "";
	// Declarations:
	_vehTypesHeavy  = ["Tank"];
	_vehTypesMedium = ["WheeledAPC", "TrackedAPC"];
	_vehType        = (_veh call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
	_massCenter     = getCenterOfMass _veh;
	switch _tag do {
		case "BLU": { _colorChute = "B_Parachute_02_F" };
		case "OPF": { _colorChute = "O_Parachute_02_F" };
		case "IND": { _colorChute = "I_Parachute_02_F" };
		//case "CIV": {  CIV has no paradrop for vehicles, nor parachute with specific color };
	};
	// Debug:
	if ( CSWR_isOnDebug && CSWR_isOnDebugPara ) then {
		["%1 PARADROP > %2 '%3' vehicle is a '%4' type.",
		CSWR_txtDebugHeader, _tag, _veh, _vehType] call BIS_fnc_error;
	};
	// Creating the main vehicle parachute:
	_mainChute = createVehicle [_colorChute, _massCenter, [], 0, "FLY"];
	_mainChute setDir (getDir _veh);  // always before the setPos to avoid odd behaviors about collisions (killzone_kid tip).
	_mainChute setPos (getPos _veh);  // getPos was designed to take the altitude pos obj from the surface below it.
	_veh attachTo [_mainChute, [0,2,0]];
	// Additionals if probably a heavy vehicle:
	_allChutes = [_mainChute];
	if ( _vehType in _vehTypesHeavy ) then {
		{  // Multiple parachutes for vehicle:
			_i = createVehicle [_colorChute, _massCenter, [], 0, "FLY"];
			_allChutes pushBack _i;
			_i attachTo [_mainChute, _massCenter];
			_i setVectorUp _x;
		} count [ [0.5,0.4,0.6], [-0.5,0.4,0.6], [0.5,-0.4,0.6], [-0.5,-0.4,0.6] ];
	// Otherwise:
	} else {
		// Additionals if probably a medium vehicle:
		if ( _vehType in _vehTypesMedium ) then {
			{  // Multiple parachutes for vehicle:
				_i = createVehicle [_colorChute, _massCenter, [], 0, "FLY"];
				_allChutes pushBack _i;
				_i attachTo [_mainChute, _massCenter];
				_i setVectorUp _x;
			} count [ [0.5,0.2,0.9], [-0.5,0.2,0.9] ];
		};
	};
	// Force the crewmen to hold-fire if they see an enemy (hehehe):
	{ _x disableAI "all" } forEach units _grp;
	// Waiting the vechile get closer to the ground (or water):
	while { (getPosATL _veh) # 2 >= 4 && (getPosASLW _veh) # 2 >= 1 && alive _veh } do {
		_mainChute setVelocity [0, 0, (velocity _mainChute) # 2];
		_mainChute setVectorUp [0, 0, 1];  // CRITICAL: Tweaked the parachute position each new check, otherwise sometimes the parachut tilts, making the vehicle crash.
		sleep 0.5;
	};
	// Adjust to vehicle velocity after the parachutes detachment:
	_velocity = velocity _veh;  // [x,y,z]
	detach _veh;
	_veh setVelocity _velocity;
	// Detachment of parachutes from the vehicle:
	playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _veh];
	{ detach _x; _x disableCollisionWith _veh } forEach _allChutes;
	// Restore the crewmen capability to engage:
	{ _x enableAI "all" } forEach units _grp;
	// Animations breather:
	sleep 5;
	// Delete the parachutes:
	{ if ( !isNull _x ) then { deleteVehicle _x } } forEach _allChutes;
	// Return:
	true;
};


THY_fnc_CSWR_gear_container_transfer = {
	// This function scans the unit's container (uniform, backpack, vest) to know the current container content and transfer that to the new one.
	// Returns nothing.

	params ["_containerType", "_unit", "_newContainer"];
	private ["_content"];

	// Initial values:
	_content = [];
	// Save all container original content:
	switch _containerType do {
		case "uniform": {
			// Old uniform content:
			_content = uniformItems _unit;
			// Remove the old uniform:
			removeUniform _unit;
			// Replace for the new uniform:
			_unit forceAddUniform _newContainer;
			// if there is one or more items from old uniform, repack them to the new one:
			if ( _content isNotEqualTo [] ) then { { _unit addItemToUniform _x } forEach _content };
		};
		case "backpack": {
			// Old backpack content:
			_content = backpackItems _unit;
			// Remove the old backpack:
			removeBackpack _unit;
			// Replace for the new backpack:
			_unit addBackpack _newContainer;
			// if there is one or more items from old backpack, repack them to the new one:
			if ( _content isNotEqualTo [] ) then { { _unit addItemToBackpack _x } forEach _content };
		};
		case "vest": {
			// Old vest content:
			_content = vestItems _unit;
			// Remove the old vest:
			removeVest _unit;
			// Replace for the new vest:
			_unit addVest _newContainer;
			// if there is one or more items from old vest, repack them to the new one:
			if ( _content isNotEqualTo [] ) then { { _unit addItemToVest _x } forEach _content };
		};
	};
	// CPU breather:
	sleep 0.1;
	// Return:
	_content;
};


THY_fnc_CSWR_gear_NVG_and_flashlight = {
	// This function undestands if the unit should have a nightview OR use flashlight OR none.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_tag", "_unit", "_canNvg"];
	private ["_newNvg", "_canFlashlight", "_newFlashlight", "_isFlashlightForced", "_oldNvg"];
	
	// Initial values:
	_newNvg             = "";
	_canFlashlight      = false;
	_newFlashlight      = "";
	_isFlashlightForced = false;
	// Declarations:
	_oldNvg = hmd _unit;  // if empty, returns "".
	switch _tag do {
		case "BLU": { _newNvg = CSWR_nvgDeviceBLU; _canFlashlight = CSWR_canFlashlightBLU; _newFlashlight = CSWR_flashlightDeviceBLU; _isFlashlightForced = CSWR_isForcedFlashlBLU };
		case "OPF": { _newNvg = CSWR_nvgDeviceOPF; _canFlashlight = CSWR_canFlashlightOPF; _newFlashlight = CSWR_flashlightDeviceOPF; _isFlashlightForced = CSWR_isForcedFlashlOPF };
		case "IND": { _newNvg = CSWR_nvgDeviceIND; _canFlashlight = CSWR_canFlashlightIND; _newFlashlight = CSWR_flashlightDeviceIND; _isFlashlightForced = CSWR_isForcedFlashlIND };
		case "CIV": { _newNvg = CSWR_nvgDeviceCIV };  // Civ doesn't use flashlight on guns.
	};
	// Remove any possible gear from the unit reached here:
	_unit unlinkItem _oldNvg;
	_unit removeItem _oldNvg;
	// Must use night vision goggles:
	if _canNvg then {
		// Important: not create a validation to check if the newGear is equal to oldGear to check if the change is needed coz the editor probably wants to change the NVG model.
		// Add the new gear:
		_unit linkItem _newNvg;
	// Otherwise, check if can use flashlight:
	} else {
		// Must use flashlight:
		if ( _canFlashlight && _tag isNotEqualTo "CIV" ) then {
			// Avoids a duplication at least if the gear is the same classname:
			_unit removePrimaryWeaponItem _newFlashlight;
			// Add the gear:
			_unit addPrimaryWeaponItem _newFlashlight;
			// Setting the flashlight:
			if !_isFlashlightForced then { _unit enableGunLights "Auto" } else { _unit enableGunLights "ForceOn" };  // CSWR doesn't apply it in group coz first the script want to known if the side is using NVG.
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_facewear = {
	// This function replace the old unit's facewear (goggles, glasses, balaclava, mask) for the new one.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear"];

	// Escape > Air Crew never has its goggles customized:
	if (_grpType in ["heliL", "heliM", "heliH"]) exitWith {};
	// Declarations:
	_oldGear = goggles _unit;  // if empty, returns "".
	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {
		// If the usage is mandatory:
		if _isMandatory then {
			// if there's a new gear, and that's NOT the same of the unit original one:
			if ( _newGear isNotEqualTo _oldGear ) then {
				// Remove any possible gear:
				removeGoggles _unit;
				// Add the new gear:
				_unit addGoggles _newGear;
			};
		// Otherwise, not mandatory:
		} else {
			// if there's a new gear, and that's NOT the same of the current:
			if ( _newGear isNotEqualTo "" /* && _oldGear isNotEqualTo "" */ && _newGear isNotEqualTo _oldGear ) then {
				// Remove any possible gear:
				removeGoggles _unit;
				// Add the new gear:
				_unit addGoggles _newGear;
			};
		};
	// Otherwise:
	} else {
		// Remove the gear:
		removeGoggles _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_helmet = {
	// This function replace the old unit's helmet for the new one.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear"];

	// Escape > Air Crew never has its helmet customized:
	if (_grpType in ["heliL", "heliM", "heliH"]) exitWith {};
	// Declarations:
	_oldGear = headgear _unit;  // if empty, returns "".
	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {
		// If the usage is mandatory:
		if _isMandatory then {
			// if there's a new gear, and that's NOT the same of the unit original one:
			if ( _newGear isNotEqualTo _oldGear ) then { 
				// Remove any possible gear:
				removeHeadgear _unit;
				// Add the new gear:
				_unit addHeadgear _newGear;
			};
		// Otherwise, not mandatory:
		} else {
			// if there's a new gear, and that's NOT the same of the current:
			if ( _newGear isNotEqualTo "" /* && _oldGear isNotEqualTo "" */ && _newGear isNotEqualTo _oldGear ) then { 
				// Remove any possible gear:
				removeHeadgear _unit;
				// Add the new gear:
				_unit addHeadgear _newGear;
			};
		};
	// Otherwise, force removal:
	} else {
		// Remove the gear:
		removeHeadgear _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_uniform = {
	// This function add to the new uniform all the old unit's uniform original content.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear"];

	// Declarations:
	_oldGear = uniform _unit;  // if empty, returns "".
	// Editor wants to randomize the uniforms:
	if ( _newGear isEqualTo "RANDOM" ) then {
		switch _tag do {
			// Transfer the old gear content to the new one:
			case "BLU": {
				if ( CSWR_bluUniformsToRandom isNotEqualTo [] ) then {
					["uniform", _unit, selectRandom CSWR_bluUniformsToRandom] call THY_fnc_CSWR_gear_container_transfer;
				} else {
					// Warning:
					systemChat format ["%1 LOADOUT > You're trying to randomize the %2 UNIFORMS but 'CSWR_bluUniformsToRandom' in Management file is empty. Fix it!",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			case "OPF": {
				if ( CSWR_opfUniformsToRandom isNotEqualTo [] ) then {
					["uniform", _unit, selectRandom CSWR_opfUniformsToRandom] call THY_fnc_CSWR_gear_container_transfer;
				} else {
					// Warning:
					systemChat format ["%1 LOADOUT > You're trying to randomize the %2 UNIFORMS but 'CSWR_opfUniformsToRandom' in Management file is empty. Fix it!",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			case "IND": {
				if ( CSWR_indUniformsToRandom isNotEqualTo [] ) then {
					["uniform", _unit, selectRandom CSWR_indUniformsToRandom] call THY_fnc_CSWR_gear_container_transfer;
				} else {
					// Warning:
					systemChat format ["%1 LOADOUT > You're trying to randomize the %2 UNIFORMS but 'CSWR_indUniformsToRandom' in Management file is empty. Fix it!",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			case "CIV": {
				if ( CSWR_civUniformsToRandom isNotEqualTo [] ) then {
					["uniform", _unit, selectRandom CSWR_civUniformsToRandom] call THY_fnc_CSWR_gear_container_transfer;
				} else {
					// Warning:
					systemChat format ["%1 LOADOUT > You're trying to randomize the %2 UNIFORMS but 'CSWR_civUniformsToRandom' in Management file is empty. Fix it!",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
		};
	} else {
		// If editor is NOT trying to remove the gear by force:
		if ( _newGear isNotEqualTo "REMOVED" ) then {
			// If the usage is mandatory:
			if _isMandatory then {
				// If there's a new gear:
				if (_newGear isNotEqualTo "" ) then {
					// New gear is NOT the same of the current gear:
					if ( _newGear isNotEqualTo _oldGear ) then {
						// Transfer the old gear content to the new one:
						["uniform", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
					};
				// Otherwise, if editor hasn't a new gear declared:
				} else {
					// Check if the unit has no gear yet (inherited a possible editor's choice from other lower group class):
					if ( _oldGear isEqualTo "" ) then {
						// Add the generic gear:
						_unit forceAddUniform (selectRandom CSWR_civUniformsToRandom);
						// Warning:
						systemChat format ["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using UNIFORM but in 'fn_CSWR_3_loadout.sqf' you didn't set a UNIFORM for them or, at least, for the group class they inherit the UNIFORM. For script integrity, CSWR sets a generic one.",
						CSWR_txtWarnHeader, _tag, group _unit, _grpType]; sleep 5;
					};
				};
			// Otherwise, not mandatory:
			} else {
				// Important: if those units that originally has no outfit (bizare) will be forced to take one if there's an option, differently other containers (backpack and vest) behaviors!
				// if there's a new gear, the unit has a current gear, and the new gear is NOT the same of the current:
				if ( _newGear isNotEqualTo "" && _newGear isNotEqualTo _oldGear ) then {
					// Transfer the old gear content to the new one:
					["uniform", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			};
		// Otherwise, force removal:
		} else {
			// Remove the gear:
			removeUniform _unit;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_vest = {
	// This function add to the new vest all the old unit's vest original content.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear", "_genericGear"];

	// Declarations:
	_oldGear = vest _unit;  // if empty, returns "".
	_genericGear = "V_Chestrig_blk";
	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {
		// If the usage is mandatory:
		if _isMandatory then {
			// If there's a new gear:
			if (_newGear isNotEqualTo "" ) then {
				// New gear is NOT the same of the current gear:
				if ( _newGear isNotEqualTo _oldGear ) then {
					// Transfer the old gear content to the new one:
					["vest", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			// Otherwise, if editor hasn't a new gear declared:
			} else {
				// Check if the unit has no gear yet (inherited a possible editor's choice from other lower group class):
				if ( _oldGear isEqualTo "" ) then {
					// Add the generic gear:
					_unit addVest _genericGear;
					// Warning:
					systemChat format ["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using VEST but in 'fn_CSWR_3_loadout.sqf' you didn't set a VEST for them or, at least, for the group class they inherit the VEST. For script integrity, CSWR sets a generic one.",
					CSWR_txtWarnHeader, _tag, group _unit, _grpType]; sleep 5;
				};
			};
		// Otherwise, not mandatory:
		} else {
			// if there's a current gear:
			if ( _oldGear isNotEqualTo "" ) then {
				// if there's an editor's choice and this choice is NOT the same of the current gear:
				if ( _newGear isNotEqualTo "" && _newGear isNotEqualTo _oldGear ) then {
					// Transfer the old gear content to the new one:
					["vest", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			// Otherwise, if there's NO current gear:
			} else {
				// If civilian, and there's an editor choice:
				// Important: only for civilians, it doesn't matter if the unit has a current gear to get the new one. All civilian will receive the new gear if there's an editor choice.
				if ( _tag isEqualTo "CIV" && _newGear isNotEqualTo "" ) then {
					// Transfer the old gear content to the new one:
					["vest", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			};
		};
	// Otherwise, force removal:
	} else {
		// Remove the gear:
		removeVest _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_backpack = {
	// This function add to the new backpack to the unit without loose the original backpack content.
	// Important: don't apply rules for roles here. Use the role function to do that!
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear", "_genericGear"];

	// Escape > Infantry (ANY) Crew never get backpack (not including passagers):
	if ( !isNull (objectParent _unit) && { _unit isEqualTo driver (vehicle _unit) || _unit isEqualTo gunner (vehicle _unit) || _unit isEqualTo commander (vehicle _unit) } ) exitWith {};
		// Escape > Infantry Heavy Crew never get backpack (not including passagers):
		//if ( _grpSpec in ["specHeavyCrew", "specParaHeavyCrew", "specMarineHeavyCrew"] ) exitWith {};
	// Declarations:
	_oldGear = backpack _unit;  // if empty, returns "".
	_genericGear = "B_Carryall_blk";
	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroops".
		// If the usage is mandatory:
		if _isMandatory then {
			// Any crew unit never take a backpack:
				// There is already a escape in this function.
			// If there's a new gear:
			if (_newGear isNotEqualTo "" ) then {
				// New gear is NOT the same of the current gear:
				if ( _newGear isNotEqualTo _oldGear ) then {
					// Transfer the old gear content to the new one:
					["backpack", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			// Otherwise, if editor hasn't a new gear declared:
			} else {
				// Check if the unit has no gear yet (inherited a possible editor's choice from other lower group class):
				if ( _oldGear isEqualTo "" ) then {
					// Add the generic gear:
					_unit addBackpack _genericGear;
					// Warning:
					systemChat format ["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using BACKPACK but in 'fn_CSWR_3_loadout.sqf' you didn't set a BACKPACK for them or, at least, for the group class they inherit the BACKPACK. For script integrity, CSWR sets a generic one.",
					CSWR_txtWarnHeader, _tag, group _unit, _grpType]; sleep 5;
				};
			};
		// Otherwise, not mandatory:
		} else {
			// if there's a current gear:
			if ( _oldGear isNotEqualTo "" ) then {
				// if there's an editor's choice and this choice is NOT the same of the current gear:
				if ( _newGear isNotEqualTo "" && _newGear isNotEqualTo _oldGear ) then {
					// Transfer the old gear content to the new one:
					["backpack", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			// Otherwise, if there's NO current gear:
			} else {
				// If civilian, and there's an editor choice:
				// Important: only for civilians, it doesn't matter if the unit has a current gear to get the new one. All civilian will receive the new gear if there's an editor choice.
				if ( _tag isEqualTo "CIV" && _newGear isNotEqualTo "" ) then {
					// Transfer the old gear content to the new one:
					["backpack", _unit, _newGear] call THY_fnc_CSWR_gear_container_transfer;
				};
			};
		};
	// Otherwise, force removal:
	} else {
		// Remove the gear:
		removeBackpack _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_weaponry_sniper = {
	// This function replaces the old sniper rifle setup for a new one.
	// Returns nothing.

	params ["_tag", "_unit", "_newRifle", "_newMag", "_newOptics", "_newRail", "_newMuzzle", "_newBipod", ["_magAmount", 6]];
	private ["_oldRif", "_oldAccess", "_oldMag"];

	// Escape > if unit has no primary weapon yet (to inherit), and editor doesn't declared a new one, abort:
	if ( primaryWeapon _unit isEqualTo "" && _newRifle isEqualTo "" ) exitWith {};
	// Escape > if unit has no primary ammo yet (to inherit), and editor doesn't declared a new one, abort:
	if ( primaryWeaponMagazine _unit isEqualTo "" && _newMag isEqualTo "" ) exitWith {};
	// Declarations:
	_oldRif    = primaryWeapon _unit;
	_oldAccess = _unit weaponAccessories _oldRif;  // [silencer, laserpointer/flashlight, optics, bipod] like ["","acc_pointer_IR","optic_Aco",""]
	_oldMag    = primaryWeaponMagazine _unit;  // old mag loaded on rifle.
		//_oldMags = getArray (configFile >> "CfgWeapons" >> _oldRif >> "magazines");  // collect all types of magazines from primary weapon.
	// Magazine:
	// Important: crucial to be first validation.
	if ( _newMag isNotEqualTo "" ) then {
		// Removing all old rifle magazines from the loadout:
		_unit removeMagazines (_oldMag # 0); 
		// Include new magazines in loadout containers (the old ones only will be removed if the rifle was replaced):
		_unit addMagazines [_newMag, _magAmount];
	};
	// Rifle:
	if ( _newRifle isNotEqualTo "" ) then {
		// removes primary weapon:
		_unit removeWeapon _oldRif;
		// Add the new rifle (without magazines and acessories):
		_unit addWeapon _newRifle;
		// Use the new rifle since mission starts:
		_unit selectWeapon _newRifle;
	};
	// Reload the weapon:
	// If there's a new mag:
	if ( _newMag isNotEqualTo "" ) then {
		// There is no way the unit has no rifle so just add the new mag on the rifle loader:
		_unit addPrimaryWeaponItem _newMag;
	// Otherwise:
	} else {
		// If there's NO new mag but the rifle is new:
		if ( _newRifle isNotEqualTo "" ) then {
			// Add the old/current mag in the new rifle:
			_unit addPrimaryWeaponItem _oldMag;
		};
	};
	// WIP - Check the mag compability with rifle:
		// If not compatibl  warning message:
		// ["%1 LOADOUT > %2 Sniper groups got rifle and its ammo compability issues. Check it out in 'fn_CSWR_3_loadout.sqf' file.",
		// CSWR_txtWarnHeader, _tag] call BIS_fnc_error; sleep 5;
	// Muzzle:
	if ( _newMuzzle isNotEqualTo "REMOVED" ) then {
		// If there's a new accessory:
		if ( _newMuzzle isNotEqualTo "" ) then {
			// removes old accessory if there is one:
			_unit removePrimaryWeaponItem (_oldAccess # 0);
			// adds the new one:
			_unit addPrimaryWeaponItem _newMuzzle;
		};
	} else {
		// removes current accessory if there is one:
		_unit removePrimaryWeaponItem (_oldAccess # 0);
	};
	// Rail:
	if ( _newRail isNotEqualTo "REMOVED" ) then {
		// If there's a new accessory:
		if ( _newRail isNotEqualTo "" ) then {
			// removes old accessory if there is one:
			_unit removePrimaryWeaponItem (_oldAccess # 1);
			// adds the new one:
			_unit addPrimaryWeaponItem _newRail;
		};
	} else {
		// removes current accessory if there is one:
		_unit removePrimaryWeaponItem (_oldAccess # 1);
	};
	// Optics:
	if ( _newOptics isNotEqualTo "REMOVED" ) then {
		// If there's a new accessory:
		if ( _newOptics isNotEqualTo "" ) then {
			// removes old accessory if there is one:
			_unit removePrimaryWeaponItem (_oldAccess # 2);
			// adds the new one:
			_unit addPrimaryWeaponItem _newOptics;
		};
	} else {
		// removes current accessory if there is one:
		_unit removePrimaryWeaponItem (_oldAccess # 2);
	};
	// Bipod:
	if ( _newBipod isNotEqualTo "REMOVED" ) then {
		// If there's a new accessory:
		if ( _newBipod isNotEqualTo "" ) then {
			// removes old accessory if there is one:
			_unit removePrimaryWeaponItem (_oldAccess # 3);
			// adds the new one:
			_unit addPrimaryWeaponItem _newBipod;
		};
	} else {
		// removes current accessory if there is one:
		_unit removePrimaryWeaponItem (_oldAccess # 3);
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_infantry_basicGrp = {
	// This function organizes the basic of all infantry classes unit loadout, including: heavy crew, sniper groups, and paratroopers. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_newBackpack", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_canNvg"/*, "_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_isValidBackpackClass" */];

	// Initial values:
	_canNvg = false;
	// _isValidUniformClasses = true;
	// _isValidVestClasses    = true;
	// _isValidHelmetClasses  = true;
	// _isValidGogglesClass   = true;
	// _isValidBackpackClass  = true;

	// Declarations:
	switch _tag do {
		case "BLU": { _canNvg = CSWR_canNvgInfantryBLU };
		case "OPF": { _canNvg = CSWR_canNvgInfantryOPF };
		case "IND": { _canNvg = CSWR_canNvgInfantryIND };
		case "CIV": { _canNvg = CSWR_canNvgCIV };
	};
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		/* _isValidUniformClasses = */ [_tag, "CfgWeapons",  "UNIFORM",  "_newUniform",  [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidVestClasses    = */ [_tag, "CfgWeapons",  "VEST",     "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidHelmetClasses  = */ [_tag, "CfgWeapons",  "HELMET",   "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidGogglesClass   = */ [_tag, "CfgGlasses",  "GOGGLES",  "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidBackpackClass  = */ [_tag, "CfgVehicles", "BACKPACK", "_newBackpack", [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
	};
	
	// Uniform:
	[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
	// Helmet / Headgear:
	[_newHelmet, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_helmet;
	// Goggles / Facewear:
	[_newGoggles, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_facewear;
	// Vest / Balistic protection:
	// If NOT civilian:
	if ( _tag isNotEqualTo "CIV" ) then {
		[_newVest, _unit, _grpType, _grpSpec, _tag, CSWR_isVestForAll] call THY_fnc_CSWR_gear_vest;
	// Otherwise:
	} else {
		[_newVest, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_vest;
	};

	// Backpack:
	// if the unit HASN'T parachuters speciality or it's NOT heavy crew:
	if ( !(_grpSpec in ["specPara", "specParaHeavyCrew", "specHeavyCrew", "specMarineHeavyCrew"]) ) then {
		// If NOT civilian:
		if ( _tag isNotEqualTo "CIV" ) then {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, CSWR_isBackpackForAllByFoot] call THY_fnc_CSWR_gear_backpack;
		// Otherwise:
		} else {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_backpack;
		};
		// Skip if snipers coz they have their own loadout function later:
		if ( _grpType isNotEqualTo "teamS" ) then {
			// NightVision:
			[_tag, _unit, _canNvg] call THY_fnc_CSWR_gear_NVG_and_flashlight;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_marines = {
	// This function organizes the unit loadout of any group with marine specialty (spawning in water). The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_newBackpack", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_canNvg"/*, "_isValidUniformClasses", "_isValidVestClasses", "_isValidBackpackClass", "_isValidHelmetClasses", "_isValidGogglesClass" */];

	// Escape > if the unit doesn't have marine speciality, abort:
	if !( _grpSpec in ["specMarine", "specMarineHeavyCrew"] ) exitWith {};
	// Escape > if it's a forbidden uniform for marines, abort:
	if ( _newUniform in CSWR_forbiddenMarineUniforms ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > You're using a FORBIDDEN UNIFORM for %2 MARINES (those infantry spawning in water). The '%3' uniform bugs units that are NOT originally divers. Use the unit-divers classname in 'Population' file instead of to edit a non-diver unit through 'loadout' file.",
		CSWR_txtWarnHeader, _tag, _newUniform]; sleep 10;
	};
	// Initial values:
	_canNvg = false;
	// _isValidUniformClasses = true;
	// _isValidVestClasses    = true;
	// _isValidBackpackClass  = true;
	// _isValidHelmetClasses  = true;
	// _isValidGogglesClass   = true;

	// Declarations:
	switch _tag do {
		case "BLU": { _canNvg = CSWR_canNvgMarinesBLU };
		case "OPF": { _canNvg = CSWR_canNvgMarinesOPF };
		case "IND": { _canNvg = CSWR_canNvgMarinesIND };
		case "CIV": { _canNvg = CSWR_canNvgCIV        };
	};
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		/* _isValidUniformClasses = */ [_tag, "CfgWeapons",  "UNIFORM",  "_newUniform",   [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidVestClasses    = */ [_tag, "CfgWeapons",  "VEST",     "_newVest",      [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidBackpackClass  = */ [_tag, "CfgVehicles", "BACKPACK", "_newBackpack",  [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidHelmetClasses  = */ [_tag, "CfgWeapons",  "HELMET",   "_newHelmet",    [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidGogglesClass   = */ [_tag, "CfgGlasses",  "GOGGLES",  "_newGoggles",   [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
	};
	// if marines without Heavy Vehicle:
	if ( _grpSpec isEqualTo "specMarine" ) then {
		// Goggles / Facewear:
		[_newGoggles, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_facewear;
		// Backpack:
		// if there's NO editor's choice, the unit only takes backpack if the original unit classname has a backpack:
		if ( _newBackpack isEqualTo "" ) then {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, CSWR_isBackpackForAllByFoot] call THY_fnc_CSWR_gear_backpack;
		// Otherwise, if there's an editor's choice, regardless the original unit classname has or not a backpack, the unit will take one:
		} else {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_backpack;
		};
		// Vest / Ballistic protection:
		[_newVest, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_vest;
		// Helmet:
		[_newHelmet, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_helmet;
		// Skip if snipers coz they have their own loadout function later:
		if ( _grpType isNotEqualTo "teamS" ) then {
			// NightVision:
			[_tag, _unit, _canNvg] call THY_fnc_CSWR_gear_NVG_and_flashlight;
		};
	};
	// Uniform
	[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
	// Return:
	true;
};


THY_fnc_CSWR_loadout_paratroops = {
	// This function organizes the unit loadout of any group with parachuting specialty (spawing in paradrop). The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_canNvg",/* "_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", */ "_genericChute"];

	// Escape > if the unit doesn't have some parachute speciality, abort:
	if ( !(_grpSpec in ["specPara", "specParaHeavyCrew"]) ) exitWith {};
	// Escape > If editor's trying to remove a mandatory gear, or no new gear was declared and the unit has NO an old gear to inherit:
	if ( _newVest isEqualTo "REMOVED" || {_newVest isEqualTo "" && vest _unit isEqualTo ""} ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > A %2 PARATROOP group member was deleted coz a mandatory gear (VEST): 1) vest was REMOVED; or 2) vest WASN'T DECLARED in their loadout, nor in Infantry loadout; or even 3) the original unit has no vest. Check the %2 section in 'fn_CSWR_3_loadout.sqf' file.",
		CSWR_txtWarnHeader, _tag];
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	// Initial values:
	_canNvg = false;
	// _isValidUniformClasses = true;
	// _isValidVestClasses    = true;
	// _isValidHelmetClasses  = true;
	// _isValidGogglesClass   = true;

	// Declarations:
	_genericChute = "B_Parachute";
	switch _tag do {
		case "BLU": { _canNvg = CSWR_canNvgParatroopsBLU };
		case "OPF": { _canNvg = CSWR_canNvgParatroopsOPF };
		case "IND": { _canNvg = CSWR_canNvgParatroopsIND };
		case "CIV": { _canNvg = CSWR_canNvgCIV };
	};
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		/* _isValidUniformClasses = */ [_tag, "CfgWeapons", "UNIFORM", "_newUniform", [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidVestClasses    = */ [_tag, "CfgWeapons", "VEST",    "_newVest",    [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidHelmetClasses  = */ [_tag, "CfgWeapons", "HELMET",  "_newHelmet",  [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidGogglesClass   = */ [_tag, "CfgGlasses", "GOGGLES", "_newGoggles", [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
	};
	// if parachuter is open-chest free fall (NOT including e.g. specParaHeavyCrew):
	if ( _grpSpec isEqualTo "specPara" ) then {
	// Important: avoid to use "isNull (objectParent _unit)" because for Arma 3 parachute is vehicle when opened.
		// Backpack (Parachute):
		// Important: mandatory for parachuter, but ignored by soldiers inside vehicles (like crew and its passagers).
		[_genericChute, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_backpack;
		// Goggles / Facewear:
		// Important: mandatory for parachuter not inside a vehicle.
		[_newGoggles, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_facewear;
		// Vest / Ballistic protection:
		// Important: mandatory for parachuter without vehicle, it doesn't matter what was set in CSWR_isVestForAll.
		[_newVest, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_vest;
		// Helmet:
		[_newHelmet, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_helmet;
		// Skip if snipers coz they have their own loadout function later:
		if ( _grpType isNotEqualTo "teamS" ) then {
			// NightVision:
			[_tag, _unit, _canNvg] call THY_fnc_CSWR_gear_NVG_and_flashlight;
		};
	};
	// Uniform
	// Important: parachuters and any crew executing paradrop can has the same specific uniform.
	[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
	// Return:
	true;
};


THY_fnc_CSWR_loadout_heavyCrew = {
	// This function organizes exclusively the infantry heavy crew unit loadout. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newHelmet", "_newGoggles", "_newVest", "_unit", "_grpType", "_grpSpec", "_tag"];
	private [/* "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", */ "_veh"];

	// Escape > If the unit speciality is NOT any kind of heavy crew, or if it's a civilian, abort:
	if ( !(_grpSpec in ["specHeavyCrew", "specParaHeavyCrew", "specMarineHeavyCrew"]) || _tag isEqualTo "CIV" ) exitWith {};
	// Initial values:
	// _isValidVestClasses    = true;
	// _isValidHelmetClasses  = true;
	// _isValidGogglesClass   = true;

	// Declarations:
	_veh = vehicle _unit;
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		/* _isValidVestClasses    = */ [_tag, "CfgWeapons", "VEST",    "_newVest",    [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidHelmetClasses  = */ [_tag, "CfgWeapons", "HELMET",  "_newHelmet",  [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidGogglesClass   = */ [_tag, "CfgGlasses", "GOGGLES", "_newGoggles", [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
	};
	// if the unit is crew and not passager:
	if ( _unit isEqualTo driver _veh || _unit isEqualTo gunner _veh || _unit isEqualTo commander _veh ) then {
		// Helmet:
		[_newHelmet, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_helmet;
		// Goggles / Facewear:
		[_newGoggles, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_facewear;
		// Vest / Balistic protection:
		[_newVest, _unit, _grpType, _grpSpec, _tag, CSWR_isVestForAll] call THY_fnc_CSWR_gear_vest;
		// NightVision:
		// Important: Heavy Crew cannot have NVG, but the function need to be called to remove any NVG in crewmen loadout and add (if allowed) gun flashlights:
		[_tag, _unit, false] call THY_fnc_CSWR_gear_NVG_and_flashlight;
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_infantry_sniperGrp = {
	// This function organizes exclusively the infantry sniper group unit loadout. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_newBackpack", "_newRifle", "_newMag", "_newOptics", "_newRail", "_newMuzzle", "_newBipod", "_newBinoc", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_canNvg", /*"_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_isValidBackpackClass", "_isValidRifleClass", "_isValidMagClass", "_isValidOpticsClass", "_isValidRailClass", "_isValidMuzzleClass", "_isValidBipodClass", "_isValidBinocClass", */"_genericPistol", "_genericPistolAmmo"];

	// Escape > If unit is NOT member of sniper group, abort:
	if ( _grpType isNotEqualTo "teamS" ) exitWith {};
	// Escape > If editor's trying to remove a mandatory gear, or no new gear was declared and the unit has NO an old gear to inherit:
	if ( _newMag isEqualTo "REMOVED" || {_newMag isEqualTo "" && primaryWeaponMagazine _unit isEqualTo ""} ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (PRIMARY AMMO) WAS REMOVED or it WASN'T DECLARED in its loadout or in its inherited loadout. Check the %2 section in 'fn_CSWR_3_loadout.sqf' file.",
		CSWR_txtWarnHeader, _tag];
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newRifle isEqualTo "REMOVED" || {_newRifle isEqualTo "" && primaryWeapon _unit isEqualTo ""} ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (PRIMARY WEAPON) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no primary weapon. Check the %2 section in 'fn_CSWR_3_loadout.sqf' file.",
		CSWR_txtWarnHeader, _tag];
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newVest isEqualTo "REMOVED" || {_newVest isEqualTo "" && vest _unit isEqualTo ""} ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (VEST) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no vest. Check the %2 section in 'fn_CSWR_3_loadout.sqf' file.",
		CSWR_txtWarnHeader, _tag];
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newBinoc isEqualTo "REMOVED" || {_newBinoc isEqualTo "" && binocular _unit isEqualTo ""} ) exitWith {
		// Warning:
		systemChat format ["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (BINOCULARS) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no binoculars. Check the %2 section in 'fn_CSWR_3_loadout.sqf' file.",
		CSWR_txtWarnHeader, _tag];
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	// Initial values:
	_canNvg = false;
	// _isValidUniformClasses = true;
	// _isValidVestClasses    = true;
	// _isValidHelmetClasses  = true;
	// _isValidGogglesClass   = true;
	// _isValidBackpackClass  = true;
	// _isValidRifleClass     = true;
	// _isValidMagClass       = true;
	// _isValidOpticsClass    = true;
	// _isValidRailClass      = true;
	// _isValidMuzzleClass    = true;
	// _isValidBipodClass     = true;
	// _isValidBinocClass     = true;

	// Declarations:
	_genericPistol     = "hgun_P07_F";
	_genericPistolAmmo = "16Rnd_9x21_Mag";
	switch _tag do {
		case "BLU": { _canNvg = CSWR_canNvgSnipersBLU };
		case "OPF": { _canNvg = CSWR_canNvgSnipersOPF };
		case "IND": { _canNvg = CSWR_canNvgSnipersIND };
		//case "CIV": { _canNvg = CSWR_canNvgCIV };  // There's no this group-type for Civilian.
	};
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		/* _isValidUniformClasses = */ [_tag, "CfgWeapons",   "UNIFORM",           "_newUniform",  [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidVestClasses    = */ [_tag, "CfgWeapons",   "VEST",              "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidHelmetClasses  = */ [_tag, "CfgWeapons",   "HELMET",            "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidGogglesClass   = */ [_tag, "CfgGlasses",   "GOGGLES",           "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidBackpackClass  = */ [_tag, "CfgVehicles",  "BACKPACK",          "_newBackpack", [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidRifleClass     = */ [_tag, "CfgWeapons",   "RIFLE",             "_newRifle",    [_newRifle]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidMagClass       = */ [_tag, "CfgMagazines", "RIFLE MAGAZINE",    "_newMag",      [_newMag]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidMuzzleClass    = */ [_tag, "CfgWeapons",   "MUZZLE/SUPPRESSOR", "_newMuzzle",   [_newMuzzle]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidOpticsClass    = */ [_tag, "CfgWeapons",   "OPTICS",            "_newOptics",   [_newOptics]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidRailClass      = */ [_tag, "CfgWeapons",   "RAIL",              "_newRail",     [_newRail]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidBipodClass     = */ [_tag, "CfgWeapons",   "BIPOD",             "_newBipod",    [_newBipod]] call THY_fnc_CSWR_is_valid_classname;
		/* _isValidBinocClass     = */ [_tag, "CfgWeapons",   "BINOCULARS",        "_newBinoc",    [_newBinoc]] call THY_fnc_CSWR_is_valid_classname;
	};
	// If the sniper group member is NOT a paratrooper (coz they must inherit some paratrooper gears):
	if !(_grpSpec in ["specMarine", "specPara"]) then {
		// Helmet / Headgear:
		[_newHelmet, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_helmet;
		// Goggles / Facewear:
		[_newGoggles, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_facewear;
		// Backpack:
		// if there's NO editor's choice, the unit only takes backpack if the original unit classname has a backpack:
		if ( _newBackpack isEqualTo "" ) then {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, CSWR_isBackpackForAllByFoot] call THY_fnc_CSWR_gear_backpack;
		// Otherwise, if there's an editor's choice, regardless the original unit classname has or not a backpack, the unit will take one:
		} else {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_backpack;
		};
		// Uniform:
		[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
		// Vest / Ballistic protection:
		// Important: mandatory for sniper group members, it doesn't matter what was set in CSWR_isVestForAll.
		[_newVest, _unit, _grpType, _grpSpec, _tag, true] call THY_fnc_CSWR_gear_vest;
	};
	// NightVision:
	[_tag, _unit, _canNvg] call THY_fnc_CSWR_gear_NVG_and_flashlight;
	// Rifle setup:
	[_tag, _unit, _newRifle, _newMag, _newOptics, _newRail, _newMuzzle, _newBipod] call THY_fnc_CSWR_weaponry_sniper;
	// Binoculars:
	// If there's an editor's choice, and the new gear is NOT equal the current one:
	if ( _newBinoc isNotEqualTo "" && _newBinoc isNotEqualTo (binocular _unit) ) then {
		// Remove the old one if it exists:
		_unit removeWeapon (binocular _unit);
		// New binoculars replacement:
		_unit addWeapon _newBinoc;
	};
	// Pistol:
	// If there's NO pistol (mandatory for sniper group):
	if ( handgunWeapon _unit isEqualTo "" ) then {
		// Add a generic pistol:
		_unit addWeapon _genericPistol;
		// Add at least one magazine:
		_unit addHandgunItem _genericPistolAmmo;
	};
	// Return:
	true;
};


THY_fnc_CSWR_language_default = {
	// This function selects the default language by side identity. Custom language is checked through THY_fnc_CSWR_identity_selector function.
	// Important: it's called just if the custom language is empty or unknown. Empty means the editor wants to use the default CSWR language once the CSWR knows the _region. If no _region either, no default language though.
	// Returns _lang: converted from string to array;

	params ["_tag", "_lang", "_region"];
	//private [""];

	// Escape > If unknown language, abort:
	// Important: keep this escape first!!!
	if ( _lang isNotEqualTo "" ) exitWith {
		// Warning:
		if CSWR_isOnDebug then {
			systemChat format ["%1 LANGUAGE > For %2, you're using a unknown language ('%3'). Fix it, using one of those listed as options in 'fn_CSWR_1_management.sqf' file.",
			CSWR_txtWarnHeader, _tag, _lang];
		};
		// Prepare to return:
		_lang = [];
		// Return:
		_lang
	};
	// Declarations:
	switch _region do {
		case "AFRICA":       { _lang = CSWR_langFrench };
		case "ASIA":         { _lang = CSWR_langChinese };
		case "EUROPE":       { _lang = CSWR_langGbEnglish + CSWR_langFrench };
		case "EASTEUROPE":   { _lang = CSWR_langPolish + CSWR_langRussian };
		case "MIDEAST":      { _lang = CSWR_langIranian };
		case "NORTHAMERICA": { _lang = CSWR_langUsEnglish };
		case "SOUTHAMERICA": { _lang = CSWR_langFrench };  // ( Unfortunately French is the only Romance language available )
		default              { _lang = [] };
	};
	// Return:
	_lang;
};


THY_fnc_CSWR_identity_selector = {
	// This function applies the side identity/ethnicity (face and language).
	// Returns nothing.

	params ["_tag", "_grp"];
	private ["_faces", "_lang"];

	// Initial values:
	_faces = "";
	_lang  = "";
	_array = [];
	// Declarations:
	switch _tag do {
		case "BLU": { _faces = CSWR_facesFromRegionBLU; _lang = CSWR_languageBLU };
		case "OPF": { _faces = CSWR_facesFromRegionOPF; _lang = CSWR_languageOPF };
		case "IND": { _faces = CSWR_facesFromRegionIND; _lang = CSWR_languageIND };
		// For Civilian, it's removing all camo face paint automatically:
		case "CIV": { _faces = CSWR_facesFromRegionCIV select { _array = _x splitString "_"; (_array # 0) isNotEqualTo "CamoHead" }; _lang = CSWR_languageCIV };
	};
	// Applying custom faces and language:
	if ( _faces isNotEqualTo [] ) then { { _x setFace (selectRandom _faces) } forEach units _grp };
	if ( _lang isNotEqualTo [] ) then { { _x setSpeaker (selectRandom _lang) } forEach units _grp };
	// Return:
	true;
};


THY_fnc_CSWR_grp_callSign_selector = {
	// This function gives a CallSign for specific teams that need to, for example, use CommandChats or radio.
	// Returns nothing.

	params ["_grp", "_destType", "_isAirCrew", "_isTransp"];
	private ["_n"];

	// Escape:
	if !_isTransp exitWith { true };
	// Declarations:
	_n = round random 99;
	if ( _isAirCrew && _destType isEqualTo "MOVE_TRANSPORT" ) then { _grp setGroupId [format ["Air Transport Team %1", _n]] };
	if ( _isAirCrew && _destType isEqualTo "MOVE_EXTRACTION" ) then { _grp setGroupId [ format ["Air Extraction Team %1", _n]] };
	// Return:
	true;
};


THY_fnc_CSWR_loadout_selector = {
	// This function understands who is the group, their context, and what the main ROLE the group will perform in order to select the right loadout must be applied for each group member. Once the function calls the THY_fnc_CSWR_3_loadout.sqf, that file first will apply for everyone the infantry loadout, and then the others loadouts declared over it if the group features demand. In this way, CSWR can guarantee the mechanics of equipment inheritance for different types and specializations of groups.
	// Returns nothing.

	params ["_tag", "_grp", "_grpType", "_veh", "_isVeh", "_isAirCrew", "_isNauCrew", "_isMarine", "_isPara"];
	private ["_vehType", "_wait"];

	// Initial values:
	_vehType = [];
	// Declarations:
	_wait = 0.3;
	if _isVeh then { _vehType = (_veh call BIS_fnc_objectType) # 1 };  //  Check the vehicle type, returning like ['vehicle','Tank']

	// ROLE > INFANTRY -------------------------------------------------------------------------------------
	if ( !_isAirCrew && !_isNauCrew && !_isMarine && !_isPara ) then {
		// By foot and not-heavy-ground-vehicle:
		if !(_vehType in CSWR_vehGroundHeavy) then {
			{ [_tag, _x, _grpType, ""] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;
		} else {
			// heavy Ground vehicle:
			{ [_tag, _x, _grpType, "specHeavyCrew"] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;
		};
	} else {
		// ROLE > MARINE -----------------------------------------------------------------------------------
		if ( !_isPara && _isMarine ) then {
			// By foot and nautical and not-heavy-ground-vehicle with amphibious ability:
			if !(_vehType in CSWR_vehGroundHeavy) then {
				{ [_tag, _x, _grpType, "specMarine"] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;
			// Marines with heavy ground vehicle with amphibious ability:
			} else {
				{ [_tag, _x, _grpType, "specMarineHeavyCrew"] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;
			};
		} else {
			// ROLE > PARATROOP --------------------------------------------------------------------------
			// By foot and by not-ground-heavy-vehicle in paradrop:
			if !(_vehType in CSWR_vehGroundHeavy) then {
				{ [_tag, _x, _grpType, "specPara"] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;
			// Heavy Ground Vehicle in paradrop:
			} else {
				{ [_tag, _x, _grpType, "specParaHeavyCrew"] call THY_fnc_CSWR_3_loadout; sleep _wait } forEach units _grp;	
			};
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_base_service_station = {
	// It's a new thread!
	// This function provides rearming, refueling and repairing for AI vehicles, and health for crewmen.
	// Returns nothing, but open a new thread.

	params ["_hasServiceRTB", "_spwns", "_tag", "_grpType", "_grp", "_veh", "_isAmphib", "_isAirCrew", "_isNauCrew", "_destType", "_destSector", "_behavior"];
	private ["_t", "_wait"];

	// Escape:
	if ( isNull _grp || !alive _veh ) exitWith {};
	// Initial values:
	_t = 0;
	// Declarations:
	_wait = 30;
	// Main functionality:
	_veh engineOn false;
	sleep _wait;
	// Crew health:
		if ( !alive _veh) exitWith {};  // escape.
		{ _x setDamage 0 } forEach (units _grp select { alive _x });
		sleep _wait;
	// Repairing:
		if ( !alive _veh || !alive driver _veh ) exitWith {};  // escape.
		_veh setDamage 0;
		playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_repair.wss", _veh];
		sleep _wait;
	// Refueling:
		if ( !alive _veh || !alive driver _veh ) exitWith {};  // escape.
		[_veh, 1] remoteExec ["setFuel", _veh];  // as 'setFuel' is a LA, and some player can be inside the veh (perhaps never but...), send the command to current PC that has the veh owership.
		playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _veh];
		sleep _wait;
	// Rearming:
		if ( !alive _veh || !alive driver _veh ) exitWith {};  // escape.
		[_veh, 1] remoteExec ["setVehicleAmmo", _veh];  // as 'setVehicleAmmo' is a LA, and some player can be inside the veh (perhaps never but...), send the command to current PC that has the veh owership.
		playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh];
		sleep _wait;
	// Preparing to return to the battle:
	_veh engineOn true;
	sleep _wait;
	// If helicopter:
	if _isAirCrew then {
		// Dramatization breather:
		_t = time + (selectRandom CSWR_heliTakeOffDelay); waitUntil { sleep 10; time > _t };
		// Debug:
		if CSWR_isOnDebug then { systemChat format ["%1 HELICOPTER > After maintenance services, %2 '%3' helicopter's BACK TO DUTY!",
		CSWR_txtDebugHeader, _tag, _grp] };
	// Otherwise:
	} else {
		// Reserved space.
	};
	// Return to duty (open a new thread):
	["", _spwns, _destType, _destSector, _tag, _grpType, _grp, _behavior, true, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, grpNull] spawn THY_fnc_CSWR_go;
	// Return:
	true;
};


THY_fnc_CSWR_spawn_type_checker = {
	// This function checks deeper each spawn-points that couldn't be checked by THY_fnc_CSWR_add_validation function. This function here flags the group-type is allowed to spawn through a specific spawn-point-type.
	// Important: where each group-type can spawn is defined in fn_CSWR_1_management.sqf and which classname represents which group-type is in THY_fnc_CSWR_grp_data.
	// Returns _isValid. Bool.

	params ["_tag", "_spwns", "_grpType", "_isPeople", "_isVeh", "_isAmphib", "_isNauCrew", "_isAirCrew"];
	private ["_isValid", "_allowed"];

	// Initial values:
	_isValid = false;
	_allowed = [];
	
	// STEP 1/2 > CHECKING THE SPAWN RULES ---------------------------------------------------------------------------
	// Select which group-types are allowed to spawn in the selected spawn-points-type!
	switch _spwns do {
		// Blu > Spawn for people
		case CSWR_spawnsForPeopleBLU: {
			// Escape > if non-people-group, abort:
			if !_isPeople exitWith {
				if ( !_isNauCrew && !_isAirCrew ) then {
					systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					if _isAirCrew then {
						systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
						CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				};
			};
			// For People:
			_allowed = CSWR_grpTypesForSpwns;
		};
		// Blu > Spawn for vehicle
		case CSWR_spawnsForVehicleBLU: {
			// Escape > if not-ground-or-nautical-vehicle, abort:
			if ( _isPeople || _isAirCrew ) exitWith {
				if _isPeople then {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag];
				} else {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag];
				};
				sleep 5;
			};
			// For Regular ground vehicle:
			if ( !_isAmphib && !_isNauCrew ) then { _allowed = CSWR_grpTypesForSpwnsVehGround;
			// For Amphibious vehicle:
			} else { if _isAmphib then { _allowed = CSWR_grpTypesForSpwnsVehGround + CSWR_grpTypesForSpwnsVehNautical;
			// For Nautical vehicle:
			} else { _allowed = CSWR_grpTypesForSpwnsVehNautical }};
		};
		// Blu > Spawn for helicopter
		case CSWR_spawnsForHelicopterBLU: {
			// Escape > if non-helicopter, abort:
			if !_isAirCrew exitWith {
				if !_isPeople then {
					if !_isNauCrew then {
						systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				} else {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			// For Helicopter:
			_allowed = CSWR_grpTypesForSpwnsVehAirHeli;
		};
		// Blu > Spawn paradrop
		case CSWR_spawnsParadropBLU: {
			// Escape > if air vehicle or nautical one, abort:
			if ( _isAirCrew || _isNauCrew ) exitWith {
				if _isAirCrew then {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
				};
			};
			// For people and ground vehicle:
			_allowed = CSWR_grpTypesForSpwnsPara;
		};
		// ---------------------------------------------------------------------------------------------------------------
		// Opf > Spawn for people
		case CSWR_spawnsForPeopleOPF: {
			// Escape > if non-people-group, abort:
			if !_isPeople exitWith {
				if ( !_isNauCrew && !_isAirCrew ) then {
					systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					if _isAirCrew then {
						systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
						CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				};
			};
			// For People:
			_allowed = CSWR_grpTypesForSpwns;
		};
		// Opf > Spawn for vehicle
		case CSWR_spawnsForVehicleOPF: {
			// Escape > if not-ground-or-nautical-vehicle, abort:
			if ( _isPeople || _isAirCrew ) exitWith {
				if _isPeople then {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag];
				} else {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag];
				};
				sleep 5;
			};
			// For Regular ground vehicle:
			if ( !_isAmphib && !_isNauCrew ) then { _allowed = CSWR_grpTypesForSpwnsVehGround;
			// For Amphibious vehicle:
			} else { if _isAmphib then { _allowed = CSWR_grpTypesForSpwnsVehGround + CSWR_grpTypesForSpwnsVehNautical;
			// For Nautical vehicle:
			} else { _allowed = CSWR_grpTypesForSpwnsVehNautical }};
		};
		// Opf > Spawn for helicopter
		case CSWR_spawnsForHelicopterOPF: {
			// Escape > if non-helicopter, abort:
			if !_isAirCrew exitWith {
				if !_isPeople then {
					if !_isNauCrew then {
						systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				} else {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			// For Helicopter:
			_allowed = CSWR_grpTypesForSpwnsVehAirHeli;
		};
		// Opf > Spawn paradrop
		case CSWR_spawnsParadropOPF: {
			// Escape > if air vehicle or nautical one, abort:
			if ( _isAirCrew || _isNauCrew ) exitWith {
				if _isAirCrew then {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
				};
			};
			// For people and ground vehicle:
			_allowed = CSWR_grpTypesForSpwnsPara;
		};
		// ---------------------------------------------------------------------------------------------------------------
		// Ind > Spawn for people
		case CSWR_spawnsForPeopleIND: {
			// Escape > if non-people-group, abort:
			if !_isPeople exitWith {
				if ( !_isNauCrew && !_isAirCrew ) then {
					systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					if _isAirCrew then {
						systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
						CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				};
			};
			// For People:
			_allowed = CSWR_grpTypesForSpwns;
		};
		// Ind > Spawn for vehicle
		case CSWR_spawnsForVehicleIND: {
			// Escape > if not-ground-or-nautical-vehicle, abort:
			if ( _isPeople || _isAirCrew ) exitWith {
				if _isPeople then {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag];
				} else {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag];
				};
				sleep 5;
			};
			// For Regular ground vehicle:
			if ( !_isAmphib && !_isNauCrew ) then { _allowed = CSWR_grpTypesForSpwnsVehGround;
			// For Amphibious vehicle:
			} else { if _isAmphib then { _allowed = CSWR_grpTypesForSpwnsVehGround + CSWR_grpTypesForSpwnsVehNautical;
			// For Nautical vehicle:
			} else { _allowed = CSWR_grpTypesForSpwnsVehNautical }};
		};
		// Ind > Spawn for helicopter
		case CSWR_spawnsForHelicopterIND: {
			// Escape > if non-helicopter, abort:
			if !_isAirCrew exitWith {
				if !_isPeople then {
					if !_isNauCrew then {
						systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				} else {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			// For Helicopter:
			_allowed = CSWR_grpTypesForSpwnsVehAirHeli;
		};
		// Ind > Spawn paradrop
		case CSWR_spawnsParadropIND: {
			// Escape > if air vehicle or nautical one, abort:
			if ( _isAirCrew || _isNauCrew ) exitWith {
				if _isAirCrew then {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
				};
			};
			// For people and ground vehicle:
			_allowed = CSWR_grpTypesForSpwnsPara;
		};
		// ---------------------------------------------------------------------------------------------------------------
		// Civ > Spawn for people
		case CSWR_spawnsForPeopleCIV: {
			// Escape > if non-people-group, abort:
			if !_isPeople exitWith {
				if ( !_isNauCrew && !_isAirCrew ) then {
					systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				} else {
					if _isAirCrew then {
						systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
						CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				};
			};
			// For People:
			_allowed = CSWR_grpTypesForSpwns;
		};
		// Civ > Spawn for vehicle
		case CSWR_spawnsForVehicleCIV: {
			// Escape > if not-ground-or-nautical-vehicle, abort:
			if ( _isPeople || _isAirCrew ) exitWith {
				if _isPeople then {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag];
				} else {
					systemChat format ["%1 %2 SPAWN > HELICOPTERS need a specific spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForHelicopter%2' in spawn column of those %2 helicopter rows.",
					CSWR_txtWarnHeader, _tag];
				};
				sleep 5;
			};
			// For Regular ground vehicle:
			if ( !_isAmphib && !_isNauCrew ) then { _allowed = CSWR_grpTypesForSpwnsVehGround;
			// For Amphibious vehicle:
			} else { if _isAmphib then { _allowed = CSWR_grpTypesForSpwnsVehGround + CSWR_grpTypesForSpwnsVehNautical;
			// For Nautical vehicle:
			} else { _allowed = CSWR_grpTypesForSpwnsVehNautical }};
		};
		// Civ > Spawn for helicopter
		case CSWR_spawnsForHelicopterCIV: {
			// Escape > if non-helicopter, abort:
			if !_isAirCrew exitWith {
				if !_isPeople then {
					if !_isNauCrew then {
						systemChat format ["%1 %2 SPAWN > GROUND VEHICLES need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForVehicle%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 vehicle rows.",
						CSWR_txtWarnHeader, _tag]; sleep 5;
					} else {
						systemChat format ["%1 %2 SPAWN > NAUTICAL VEHICLES need a specific spawn-type. In fn_CSWR_2_population.sqf, use only 'CSWR_spawnsForVehicle%2' in spawn column of those %2 nautical vehicle rows. Make sure some '%3%4SPAWNVEH%4%2%4sectorletter%4anynumber' are in water.",
					CSWR_txtWarnHeader, _tag, CSWR_prefix, CSWR_spacer]; sleep 10;
					};
				} else {
					systemChat format ["%1 %2 SPAWN > Groups of PEOPLE ON FOOT need a different spawn-type. In fn_CSWR_2_population.sqf, use 'CSWR_spawnsForPeople%2' or 'CSWR_spawnsParadrop%2' in spawn column of those %2 people rows.",
					CSWR_txtWarnHeader, _tag]; sleep 5;
				};
			};
			// For Helicopter:
			_allowed = CSWR_grpTypesForSpwnsVehAirHeli;
		};
		// Civ > Spawn paradrop
		case CSWR_spawnsParadropCIV: {
			// Important: CIV vehicles are forbidden to execute paradrop:
			// Escape > if vehicle, abort:
			if _isVeh exitWith {
				systemChat format ["%1 %2 SPAWN > CIVILIAN VEHICLES are FORBIDDEN to use 'CSWR_spawnsParadrop%2'. Civilian people can, but vehicles. Fix it in 'fn_CSWR_2_population.sqf' file.",
				CSWR_txtWarnHeader, _tag]; sleep 5;
			};
			// For people and ground vehicle:
			_allowed = CSWR_grpTypesForSpwnsPara;
		};
	};
	
	// STEP 2/2 > FINAL CHECK ----------------------------------------------------------------------------------------
	// Check if the selected group-type is allowed to spawn there!
	if ( _grpType in _allowed ) then { _isValid = true };

	// Return:
	_isValid;
};


THY_fnc_CSWR_destination_type_checker = {
	// This function checks deeper each destination that couldn't be checked by THY_fnc_CSWR_add_validation function. This function here compares which group-type and group-class is trying to execute each destination-type and, of course, if these destinations are respecting the minimum amount to be used.
	// Returns _isValid: bool.

	params ["_tag", "_destType", "_destSector", "_grpType", "_isPeople", "_isVeh", "_isAmphib", "_isNauCrew", "_isAirCrew"];
	private ["_isValid", "_destsLand", "_destsWater", "_minAmount", "_caller", "_txt1", "_txt2"];

	// Initial values:
	_isValid    = true;
	_destsLand  = [];
	_destsWater = [];
	_minAmount  = nil;
	// Declarations:
	_caller = if _isPeople then {"group"} else {"vehicle"};
	// Debug texts:
	_txt1 = format ["A %1 %2 won't be created coz the DESTINATION TYPE '%3' HAS NO", _tag, _caller, _destType];
	_txt2 = "or more destination markers dropped on the map. Be aware: destination markers on land and in water need its the minimum amount separately with you are using both";
	
	// STEP 1/2 > WHAT IS FORBIDDEN FOR EACH GROUP-TYPE AND GROUP-CLASS ----------------------------------------------
	// Only those main rules regarding what a group-type (sniper or light squad or heavy vehicle) and group-class (it's vehicle or not, it's amphibious or not) CANNOT execute for destination!
	// Escape > If non-sniper-group requesting to execute WATCH, abort:
	if ( _grpType isNotEqualTo "teamS" && _destType isEqualTo "MOVE_WATCH" ) exitWith {
		// Prepare to return:
		_isValid = false;
		// Warning:
		systemChat format ["%1 DESTINATION > Only SNIPER GROUPS can use '_move_WATCH' in 'fn_CSWR_2_population.sqf' file. In the problematic %2 row in there, find the group-type column, and replace that you got for 'CSWR_people_%2_sniper' if you really wanna use watch-destinations.",
		CSWR_txtWarnHeader, _tag]; sleep 10;
		// Return:
		_isValid
	};
	// Escape > If helicopter trying to execute a specialized destination, abort:
	if ( _isAirCrew && _destType in ["MOVE_WATCH", "MOVE_HOLD", "MOVE_OCCUPY"] ) exitWith {
		// Prepare to return:
		_isValid = false;
		// Warning:
		systemChat format ["%1 DESTINATION > %2 HELICOPTER CANNOT execute '%3'! The vehicle WON'T SPAWN! Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _destType];
		sleep 5;
		// Return:
		_isValid
	};
	// Escape > If neutical vehicle trying to execute a specialized destination, abort:
	if ( _isNauCrew && _destType in ["MOVE_WATCH", "MOVE_HOLD", "MOVE_OCCUPY"] ) exitWith {
		// Prepare to return:
		_isValid = false;
		// Warning:
		systemChat format ["%1 DESTINATION > %2 NAUTICAL vehicles CANNOT execute '%3'! The vehicle WON'T SPAWN! Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _destType];
		sleep 5;
		// Return:
		_isValid
	};
	
	// STEP 2/2 > CHECKING THE DESTIONATION MARKERS FOR EACH CASE ----------------------------------------------------
	// A fine-tuning to make sure the group or vehicle can use with quality the existent markers.
	// Important: unlike spawn-points, for destinations the amphibious vehicles don't use nautical moves. This restriction is to prevent those vehicles to leave land in order to jump in water and disengaging accidentally!
	switch _destType do {
		case "MOVE_ANY": {
			// Definitions:
			_minAmount = 2;
			// For People:
			if _isPeople then {
				// only land:
				if (count (CSWR_destsANYWHERE # 0) < _minAmount) then { _isValid = false };
			} else {
				// For Regular Ground Vehicle or Amphibious one:
				if ( !_isNauCrew && !_isAirCrew ) then {
					// only land:
					if (count (CSWR_destsANYWHERE # 0) < _minAmount) then { _isValid = false };
				} else {
					// For Helicopter:
					if _isAirCrew then {
						// land and water:
						if (count ((CSWR_destsANYWHERE # 0) + (CSWR_destsANYWHERE # 1)) < _minAmount) then { _isValid = false };
					// For Nautical vehicle:
					} else {
						 // only water:
						if (count (CSWR_destsANYWHERE # 1) < _minAmount) then { _isValid = false };
					};
				};
			};
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				if ( !_isNauCrew && !_isAmphib ) then {
					systemChat format ["%1 DESTINATION > %2 %3 %4.",
					CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				} else {
					if _isAmphib then {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (ON LAND) dropped on the map. Despite AMPHIBIOUS vehicles can spawn in water, their destinations need to be ON LAND.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					} else {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (IN WATER) dropped on the map.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					};
				};
				sleep 10;
			};
		};
		case "MOVE_PUBLIC": {
			// Definitions:
			_minAmount  = 2;
			_destsLand  = (CSWR_destsPUBLIC # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// For People:
			if _isPeople then {
				// only land:
				if (count _destsLand < _minAmount) then { _isValid = false };
			} else {
				// For Regular Ground Vehicle or Amphibious one:
				if ( !_isNauCrew && !_isAirCrew ) then {
					// only land:
					if (count _destsLand < _minAmount) then { _isValid = false };
				} else {
					_destsWater = (CSWR_destsPUBLIC # 1) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
					// For Helicopter:
					if _isAirCrew then {
						// land and water:
						if (count (_destsLand + _destsWater) < _minAmount) then { _isValid = false };
					// For Nautical vehicle:
					} else {
						 // only water:
						if (count _destsWater < _minAmount) then { _isValid = false };
					};
				};
			};
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				if ( !_isNauCrew && !_isAmphib ) then {
					systemChat format ["%1 DESTINATION > %2 %3 %4.",
					CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				} else {
					if _isAmphib then {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (ON LAND) dropped on the map. Despite AMPHIBIOUS vehicles can spawn in water, their destinations need to be ON LAND.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					} else {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (IN WATER) dropped on the map.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					};
				};
				sleep 10;
			};
		};
		case "MOVE_RESTRICTED": {
			// Definitions:
			_minAmount = 2;
			switch _tag do {
				case "BLU":   { _destsLand  = (CSWR_destRestrictBLU # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "OPF":   { _destsLand  = (CSWR_destRestrictOPF # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "IND":   { _destsLand  = (CSWR_destRestrictIND # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				//case "CIV": { _destsLand  = (CSWR_destRestrictCIV # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };  // CIV cannot use this kind of destinations.
			};
			// For People:
			if _isPeople then {
				// only land:
				if (count _destsLand < _minAmount) then { _isValid = false };
			} else {
				// For Regular Ground Vehicle or Amphibious one:
				if ( !_isNauCrew && !_isAirCrew ) then {
					// only land:
					if (count _destsLand < _minAmount) then { _isValid = false };
				} else {
					switch _tag do {
						case "BLU":   { _destsWater = (CSWR_destRestrictBLU # 1) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
						case "OPF":   { _destsWater = (CSWR_destRestrictOPF # 1) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
						case "IND":   { _destsWater = (CSWR_destRestrictIND # 1) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
						//case "CIV": { _destsWater = (CSWR_destRestrictCIV # 1) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };  // CIV cannot use this kind of destinations.
					};
					// For Helicopter:
					if _isAirCrew then {
						// land and water:
						if (count (_destsLand + _destsWater) < _minAmount) then { _isValid = false };
					// For Nautical vehicle:
					} else {
						 // only water:
						if (count _destsWater < _minAmount) then { _isValid = false };
					};
				};
			};
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				if ( !_isNauCrew && !_isAmphib ) then {
					systemChat format ["%1 DESTINATION > %2 %3 %4.",
					CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				} else {
					if _isAmphib then {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (ON LAND) dropped on the map. Despite AMPHIBIOUS vehicles can spawn in water, their destinations need to be ON LAND.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					} else {
						systemChat format ["%1 DESTINATION > %2 %3 or more destination markers (IN WATER) dropped on the map.",
						CSWR_txtWarnHeader, _txt1, _minAmount];
					};
				};
				sleep 10;
			};
		};
		case "MOVE_WATCH": { 
			// Definitions:
			_minAmount = 1;
			switch _tag do {
				case "BLU":   { _destsLand  = (CSWR_destWatchBLU # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "OPF":   { _destsLand  = (CSWR_destWatchOPF # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "IND":   { _destsLand  = (CSWR_destWatchIND # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				//case "CIV": { _destsLand  = (CSWR_destWatchCIV # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };  // CIV cannot use this kind of destinations.
			};
			// For People:
			// only land:
			if (count _destsLand < _minAmount) then { _isValid = false };
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				systemChat format ["%1 DESTINATION > %2 %3 %4.",
				CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				sleep 10;
			};
		};
		case "MOVE_OCCUPY": {
			// Definitions:
			_minAmount = 1;
			switch _tag do {
				case "BLU": { _destsLand  = (CSWR_destOccupyBLU # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "OPF": { _destsLand  = (CSWR_destOccupyOPF # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "IND": { _destsLand  = (CSWR_destOccupyIND # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "CIV": { _destsLand  = (CSWR_destOccupyCIV # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
			};
			// For People:
			// only land:
			if (count _destsLand < _minAmount) then { _isValid = false };
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				systemChat format ["%1 DESTINATION > %2 %3 %4.",
				CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				sleep 10;
			};
		};
		case "MOVE_HOLD": {
			// Definitions:
			_minAmount = 2;
			switch _tag do {
				case "BLU": { _destsLand = (CSWR_destHoldBLU # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "OPF": { _destsLand = (CSWR_destHoldOPF # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "IND": { _destsLand = (CSWR_destHoldIND # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
				case "CIV": { _destsLand = (CSWR_destHoldCIV # 0) select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 } };
			};
			// For everyone, unless helicopter:
			// only land:
			if (count _destsLand < _minAmount) then { _isValid = false };
			// Escape message:
			if !_isValid exitWith {
				// Warning:
				systemChat format ["%1 DESTINATION > %2 %3 %4.",
				CSWR_txtWarnHeader, _txt1, _minAmount, _txt2];
				sleep 10;
			};
		};
		case "MOVE_EXTRACTION": {};  // NOT USED WITH MARKERS! DON'T remove this to avoid the message below be shown.
		case "MOVE_TRANSPORT": {};  // NOT USED WITH MARKERS! DON'T remove this to avoid the message below be shown.
		default {
			// If the declarated destination type in fn_CSWR_population file IS NOT recognized:
			// Prepare to return:
			_isValid = false;
			// Warning:
			systemChat format ["%1 DESTINATION > One or more %2 %3s HAS NO DESTINATION properly configured in 'fn_CSWR_2_population.sqf' file. For script integrity, the %3 won't be created.",
			CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		};
	};  // switch ends.
	// Return:
	_isValid;
};


THY_fnc_CSWR_spawn_antiBlocker = {
	// This function detects what is over each vehicle spawn-point that increase the risk of unwanted explosions, and then delete the blocker object, considering an object list of exceptions.
	// Returns nothing.

	params ["_tag", "_spwn", "_grp", "_veh", "_spwnPos", "_safeDis"];
	private ["_plrsAndHeadless", "_player", "_units"];

	// Initial values:
	_plrsAndHeadless = [];
	_player          = objNull;
	_units           = [];
	_playerGrpUnits  = [];
	_unitsVehs       = [];
	_objsNeverDel    = [];
	// When the vehicle get distance from spawn or be destroyed (or for some reason the group leaves the vehicle and get distance by foot), stop the looping:
	waitUntil { sleep 5; isNull _grp || !alive _veh || (_veh distance _spwnPos) > _safeDis || (leader _grp distance _spwnPos) > _safeDis };
	// over the spawn-point, if the vehicle has been destroyed, or the crew has been killed, or the crew rampout leaving the vehicle, it deletes the wreck/vehicle and everything around it to avoid explosions:
	if ( !alive _veh || !alive leader _grp || isNull objectParent (leader _grp) ) then {
		// Checking if there's player AI units/vehicles around and ignore them:
		// Important: dont check for units side. Some mission have impredictable stories/lores/scenarios like civilian spawning along independent!
		_plrsAndHeadless = allPlayers select { _x isEqualTo leader (group _x) };
		{ _player = _x; _units = allUnits select { _x in (units (group _player)) }; _playerGrpUnits append _units } forEach _plrsAndHeadless;
		// Checking if player group units are in vehicles:
		{ if ( !isNull objectParent _x ) then { _unitsVehs pushBackUnique (vehicle _x) } } forEach _playerGrpUnits;
		// Check if there's a custom helipad:
		_objsNeverDel = _spwnPos nearObjects ["Helipad_Base_F", _safeDis];  // For more types but slower: nearestObjects [_spwnPos, ["Helipad_Base_F", "..."], _safeDis];
		// Delete everything in spawn position, except players, AI from player groups, and vehicles with AI or players from player groups:
		{ deleteVehicleCrew _x; deleteVehicle _x; sleep 0.25 } forEach (((_spwnPos nearObjects _safeDis) + (units _grp)) - (_playerGrpUnits + _unitsVehs + _objsNeverDel));
		// Debug:
		if CSWR_isOnDebug then {
			systemChat format ["%1 BOOKING > A %2 vehicle (or its wreck) HAS BEEN DELETED over a spawn-point to preserve the spawn integrity.",
			CSWR_txtDebugHeader, _tag, _spwn];
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_spawn_and_go = {
	// It's a new thread!
	// This function has 2 main features: 1) it schedules the group/vehicle spawn (now or later), and 2) send the group/vehicle to execute its first move.
	// Returns nothing, but open a new thread.

	params ["_spwnsData", "_spwnDelayMethods", "_grpData", "_isVeh", "_behavior", "_destsData"];
	private ["_isAmphib", "_isNauCrew", "_isAirCrew", "_hasServiceRTB", "_isTransp", "_canSpwn", "_serverBreath", "_spwn", "_spwnPosChecker", "_isPara", "_spwnPos", "_isMarine", "_unit", "_bookingData", "_isBooked", "_tryLimit", "_veh", "_isEmergencyHover", "_blockers", "_t", "_emergencyPos", "_grpCaller", "_isPeople", "_spwns", "_spwnsSector", "_destType", "_destSector", "_side", "_tag", "_grp", "_grpType", "_grpClassnames", "_grpClass", "_grpSize", "_safeDis", "_caller", "_txt1", "_txt2", "_txt3", "_isValidSpwnHere", "_isValidDest"];

	// Initial values:
	_isAmphib         = false;
	_isNauCrew        = false;
	_isAirCrew        = false;
	_hasServiceRTB    = false;
	_isTransp         = false;
	_canSpwn          = true;
	_serverBreath     = 0;
	_spwn             = "";
	_spwnPosChecker   = [];
	_isPara           = false;
	_spwnPos          = [];
	_isMarine         = false;
	_unit             = objNull;
	_bookingData      = [];
	_isBooked         = false;
	_tryLimit         = 5;
	_veh              = objNull;
	_isEmergencyHover = false;
	_blockers         = [];
	_t                = 0;
	_emergencyPos     = [];
	_grpCaller        = grpNull;
	// Declarations:
	_isPeople      = !_isVeh;
	_spwns         = _spwnsData # 0;
	_spwnsSector   = _spwnsData # 1;
	_destType      = _destsData # 0;
	_destSector    = _destsData # 1;
	_side          = _grpData # 0;
	_tag           = _grpData # 1;
	_grp           = _grpData # 2;
	_grpType       = _grpData # 3;
	_grpClassnames = _grpData # 4;
	_grpClass      = _grpData # 5;
	_grpSize       = count _grpClassnames;  // debug proposes.
	_safeDis       = 20;
	_caller        = if _isPeople then {"group"} else {"vehicle"};
	switch _grpClass do {
		// People group-types:
		case 0: { /* Reminder: _isPeople exists and already defined */ };
		// Vehicle group-types:
		case 1: { if ( [_grpClassnames # 0] call THY_fnc_VO_is_amphibious ) then { _isAmphib = true } };  // Amphibious
		case 2: { _isNauCrew = true };  // Nautical
		case 3: {  // Helicopter
			_isAirCrew = true;
			if ( !(_destType in ["MOVE_EXTRACTION", "MOVE_TRANSPORT"]) ) then {
				switch _tag do {
					case "BLU": { _hasServiceRTB = CSWR_hasRtbHeli # 0 };
					case "OPF": { _hasServiceRTB = CSWR_hasRtbHeli # 1 };
					case "IND": { _hasServiceRTB = CSWR_hasRtbHeli # 2 };
					case "CIV": { _hasServiceRTB = CSWR_hasRtbHeli # 3 };
				};
			} else {
				_isTransp = true;
			};
		};
	};
	// Debug texts:
	_txt1 = format ["A %1 %2 has an error in 'fn_CSWR_2_population.sqf' file.", _tag, _caller];
	_txt2 = format ["For script integrity, the %1 WON'T SPAWN!", _caller];
	_txt3 = format ["%1 %2 %3 will spawn LATER.", _grpSize, _tag, if _isVeh then {"vehicle"} else {"group units"}];

	// STEP 1/5 > SPAWN VALIDATIONS ----------------------------------------------------------------------------------
	// It checks whether the group is technically allowed to spawn what the editor wants they spawn!
	_isValidSpwnHere = [_tag, _spwns, _grpType, _isPeople, _isVeh, _isAmphib, _isNauCrew, _isAirCrew] call THY_fnc_CSWR_spawn_type_checker;
	// Escape > Spawn-type invalid for this group/vehicle:
	if !_isValidSpwnHere exitWith { true };

	// STEP 2/5 > DESTINATION VALIDATIONS ----------------------------------------------------------------------------
	_isValidDest = [_tag, _destType, _destSector, _grpType, _isPeople, _isVeh, _isAmphib, _isNauCrew, _isAirCrew] call THY_fnc_CSWR_destination_type_checker;
	// Escape > Destinations invalid for this group/vehicle:
	if !_isValidDest exitWith { true };

	// STEP 3/5 > SPAWN-DELAY ----------------------------------------------------------------------------------------
	// It checks if the _spwnDelayMethods content is correctly filled and which delay method is to be used for group/vehicle:
	if ( typeName _spwnDelayMethods isEqualTo "ARRAY" ) then {
		// If _spwnDelayMethods is not empty, it's coz the group needs Spawn Delay:
		if ( _spwnDelayMethods isNotEqualTo [] ) then {
			// Escape > If the object doesn't exist:
			// IMPORTANT: this (isNil "_x") doesn't work properly coz if trigger_name doesn't exist in editor map, still the name will be in memory and there A3 won't recognized its existence, printing out "Undentified variable error". Also the systemChat will be shown to the editor (good). The solution would be change the variable method in Population.sqf to string but str is not a good choice for editors (causing much more typos). So keep like this (with error on screen if it happens) but here's the fix: https://forums.bohemia.net/forums/topic/203108-isnil-foreach/?tab=comments#comment-3536853
			{
				if ( isNil "_x" ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpwn = false;
					// Warning:
					systemChat format ["%1 SPAWN DELAY > %2 Make sure you SPELLED the trigger or target name(s) CORRECTLY. %3",
					CSWR_txtWarnHeader, _txt1, _txt2]; 
					sleep 5;
				};
			} forEach _spwnDelayMethods;
			// If the object doesn't exist, the spawn isn't available, so there's no reason the keep the validation process running:
			if !_canSpwn exitWith {};
			// Escape > If there is more than 1 timer, abort the spawn:
			{  // forEach _spwnDelayMethods:
				if ( { typeName _x isEqualTo "SCALAR" } count _spwnDelayMethods > 1 ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpwn = false;
					// Warning:
					systemChat format ["%1 SPAWN DELAY > %2 It's NOT allowed a group with more than 1 TIMER. %3",
					CSWR_txtWarnHeader, _txt1, _txt2]; sleep 5;
				};
			} forEach _spwnDelayMethods;
			// If the object doesn't exist, the spawn isn't available, so there's no reason the keep the validation process running:
			if !_canSpwn exitWith {};
			// Errors handling > If the method is Timer:
			{
				if ( typeName _x isEqualTo "SCALAR" ) then {
					// If the Timer value is 0 (invalid), delete it from the array and keep going the validation:
					// Important: editors during the mission edition will use "0" in array istead of leave that empty.
					if ( _x isEqualTo 0 || _x < 0 ) then { _spwnDelayMethods deleteAt _forEachIndex };
				};
			} forEachReversed _spwnDelayMethods;
			// Escape:
			if ( _spwnDelayMethods isEqualTo [] ) exitWith {};
			// Escape > If some spawn delay method is in a wrong format, abort the spawn:
			{  // forEach _spwnDelayMethods:
				if ( !(typeName _x in ["OBJECT", "SCALAR", "STRING"]) ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpwn = false;
					// Warning:
					systemChat format ["%1 SPAWN DELAY > %2 Make sure you're using a timer (number representing minutes), or triggers (without quotes), or object targets (without quotes), or boolean flags (WITH quotes). E.g: [5] or [trigger_1] or [target_1] or [''my_bool_1''] or a mixed like [5, trigger_1, ''bool_1''].",
					CSWR_txtWarnHeader, _txt1]; sleep 10;
				};
			} forEach _spwnDelayMethods;
			// If everything is fine, Spawn Delay:
			if _canSpwn then {
				// Debug:
				if CSWR_isOnDebug then {
					// Debug monitor > How many units will spawn soon:
					CSWR_spwnDelayQueue = CSWR_spwnDelayQueue + _grpSize;
					publicVariable "CSWR_spwnDelayQueue";
					// Debug:
					systemChat format ["%1 SPAWN DELAY > %2%3",
					CSWR_txtDebugHeader, _txt3, selectRandom ["", ".."]]; sleep 0.25;
				};
				// Verify all Spawn Delay methods the group will use:
				[_tag, _spwnDelayMethods, _isVeh, _grpSize] call THY_fnc_CSWR_spawn_delay;
			};
		};
	// Otherwise, if the _spwnDelayMethods is NOT an array:
	} else {
		// Flag to abort the group/vehicle spawn:
		_canSpwn = false;
		// Warning:
		systemChat format ["%1 SPAWN DELAY > %2 %3",
		CSWR_txtWarnHeader, _txt1, _txt2]; sleep 5;
	};
	
	// STEP 4/5 > TRANSPORT SUPPORT ----------------------------------------------------------------------------------
	// If so, it means the side has a new support resource available for side's players:
	if _isTransp then {
		// For Transport:
		if ( _destType isEqualTo "MOVE_TRANSPORT") then {
			_grpCaller = [_side, _tag, "AIR TRANSPORT", "CSWR_suprtTranspAirData", "suprtTranspAir"] call THY_fnc_CSWR_TRANSPORT_booking_and_wait;
		// For Transport Extraction:
		} else {
			_grpCaller = [_side, _tag, "AIR EXTRACTION", "CSWR_suprtExtractAirData", "suprtExtractAir"] call THY_fnc_CSWR_TRANSPORT_booking_and_wait;;
		};
		// If caller group doesn't exist anymore:
		if ( !alive leader _grpCaller ) exitWith {
			if CSWR_isOnDebug then {
				systemChat format ["%1 SUPPORT RESOURCE > Unexpected error with the var '_grpCaller'. The vehicle WON'T spawn!",
				CSWR_txtWarnHeader];
			};
		};
	};

	// STEP 5/5 > SPAWNING -------------------------------------------------------------------------------------------
	// If the group/vehicle reaches this, pretty sure it will be spawned, unless the spawn is blocked too long.
	if _canSpwn then {
		// For people:
		if !_isVeh then {
			// Spawns on land, in water and air (paradrop):
			_spwns = (_spwns # 0) + (_spwns # 1);
		} else {
			// For regular ground vehicles:
			if ( !_isAirCrew && !_isNauCrew && !_isAmphib ) then {
				// Only spawns on land and air (paradrop):
				_spwns = (_spwns # 0);
			} else {
				// For ground vehicles with amphibious hability:
				if ( !_isAirCrew && !_isNauCrew ) then {
					// Spawns on land, in water and air (paradrop):
					_spwns = (_spwns # 0) + (_spwns # 1);
				} else {
					// For helicopter:
					if _isAirCrew then {
						// For Helicopters NOT executing extraction:
						if ( _destType isNotEqualTo "MOVE_EXTRACTION" ) then {
							// Spawns on land and in water (flying):
							_spwns = (_spwns # 0) + (_spwns # 1);
						// For Helicopters executing Extraction:
						} else {
							// Spawns on land only:
							_spwns = _spwns # 0;
						};
					// For nautical vehicle:
					} else {
						// Only spawns in water:
						_spwns = (_spwns # 1);
					};
				};
			};
		};

		// Select only those with the right sector letter:
		_spwns = (_spwns select { _x find (CSWR_spacer + _spwnsSector + CSWR_spacer) isNotEqualTo -1 });
		// Escape:
		if ( _spwns isEqualTo [] ) exitWith {
			// Warning:
			systemChat format ["%1 SPAWN > In 'fn_CSWR_2_population.sqf' file, at least one %2 %3 row is using a SECTOR (%4) that WASN'T FOUND any spawn-marker using it on Eden. This %3 WON'T be created!",
			CSWR_txtWarnHeader, _tag, _caller, _spwnsSector]; sleep 5;
		};
		// Checks current server performance:
		_serverBreath = ((abs(CSWR_serverMaxFPS-diag_fps) / (CSWR_serverMaxFPS-CSWR_serverMinFPS)) ^ 2) * 2;  // ((abs(FPSMAX-diag_fps)/(FPSMAX-FPSLIMIT))^2)*MAXDELAY;
		// Select a spawn:
		_spwn = selectRandom _spwns;
		// Check if they will be paradrop (group and vehicle), regarding the answer, it returns the spawn position (_spwnPos):
		_spwnPosChecker = [_spwns, markerPos _spwn, _isVeh, _isAmphib, [_isAirCrew, _isNauCrew]] call THY_fnc_CSWR_is_spawn_paradrop;
		_isPara         = _spwnPosChecker # 0;
		_spwnPos        = _spwnPosChecker # 1;
		// Check if the group (except helicopter crew) should receive marine loadout:
		if ( !_isAirCrew && surfaceIsWater _spwnPos ) then { _isMarine = true };

		// NO SPAWN BOOKING NEEDED:
		// For people:
		if !_isVeh then {
			// Important: booking is NOT need for groups;
			// Create the group id:
			_grp = createGroup _side;
			{  // forEach _grpClassnames:
				// Creating a unit:
				_unit = _grp createUnit [_x, _spwnPos, [], if !_isPara then {20} else {CSWR_spwnsParadropSpreading}, "NONE"];
				// If the unit classname is NOT from the right side, convert the unit though:
				if ( side _unit isNotEqualTo _side) then { [_unit] joinSilent _grp };
				// Dynamic breather:
				uiSleep _serverBreath;
			} forEach _grpClassnames;
		
		// For Vehicle:
		} else {
			// SPAWN BOOKING IS NEEDED:
			// Important: the booking for vehicle is to avoid explosions if many vehicles spawn with a too short time frame between each other!
			while { !_isPara } do {
				// For Ground or Nautical Vehicle:
				if !_isAirCrew then {
					_bookingData = ["BOOKING_SPAWNVEH", _spwnPos, _tag, _spwns, 10, 5] call THY_fnc_CSWR_marker_booking;
				} else {
					// For Air Vehicle:
					_bookingData = ["BOOKING_SPAWNHELI", _spwnPos, _tag, _spwns, 10, 20] call THY_fnc_CSWR_marker_booking;
				};
				// Marker to spawn:
				_spwn     = _bookingData # 0;
				// Spawn position:
				_spwnPos  = _bookingData # 1;  // [x,y,z]
				// Booked status:
				_isBooked = _bookingData # 2;
				// For booked vehicles:
				if _isBooked then {
					// Stop the loop:
					break;
				// For vehicle that failed to booking a spawn:
				} else {
					// Protecting the server performance:
					_tryLimit = _tryLimit - 1;
					// Debug:
					if CSWR_isOnDebug then {
						if ( _tryLimit > 0 ) then {
							// If ground vehicle:
							if ( !_isAirCrew && !_isNauCrew ) then {
								["%1 GROUND VEHICLE > A %2 vehicle selected a spawn-point already booked for another vehicle. This vehicle has %3 tries left...",
								CSWR_txtDebugHeader, _tag, _tryLimit] call BIS_fnc_error;
							// Otherwise:
							} else {
								// If helicopter:
								if !_isNauCrew then {
									["%1 HELICOPTER > A %2 helicopter selected a spawn-point already booked for another helicopter. This vehicle has %3 tries left...",
									CSWR_txtDebugHeader, _tag, _tryLimit] call BIS_fnc_error;
								// If nautical:
								} else {
									["%1 NAUTICAL VEHICLE > A %2 nautical vehicle selected a spawn-point already booked for another nautical. This vehicle has %3 tries left...",
									CSWR_txtDebugHeader, _tag, _tryLimit] call BIS_fnc_error;
								};
							};
						} else {
							systemChat format [
								"%1 VEHICLE > A %2 vehicle tried to spawn over and over again but it looks all spawn-points are busy or with vehicle(s) too close the spawns. This vehicle WON'T try to spawn again to save server performance.",
								CSWR_txtDebugHeader, _tag];
								sleep 1;
						};
					};
					if ( _tryLimit isEqualTo 0 ) then { breakTo "earlyend" };
					// CPU breather to prevent crazy loopings:
					sleep 10;
				};
			};  // While-loop ends.

			// NO SPAWN BOOKING NEEDED:
			// SPAWNING REGULAR GROUND VEHICLE AND ITS CREW:
			if ( !_isAirCrew && !_isNauCrew && !_isAmphib ) then {
				// Regular ground vehicle spawns on the ground:
				if !_isPara then {
					// Find an empty place near to the ground spawn-point:
					_spwnPos = _spwnPos findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valeus might result in vehicle explosions.
					// Escape > if no safe spot to deploy:
					if ( _spwnPos isEqualTo [] ) exitWith {
						// Debug:
						if CSWR_isOnDebug then {
							systemChat format ["%1 %2 SPAWN > A GROUND VEHICLE won't be spawned because WASN'T found any safe ground in spawn-point position or around to deploy.",
							CSWR_txtDebugHeader, _tag];
							sleep 1;
						};
						breakTo "earlyend";
					};
					// Creating the vehicle on the ground:
					_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], 0, "NONE"];
				// Ground vehicle spawns on the air (paradrop):
				} else {
					// Creating the vehicle in the air:
					_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], CSWR_spwnsParadropSpreading * 2, "NONE"];  // CRITICAL: "* 2" is needed to fix a bug where the vehs gather in mid-air, causing parachute collisions!
				};
				// Not a good performance solution at all (by GOM, 2014 July):
					// Horrible for server performance: BIS_fnc_spawnVehicle;  // https://community.bistudio.com/wiki/BIS_fnc_spawnVehicle
				// Only ground vehicle config:
				_veh allowCrewInImmobile [true, false]  // [brokenWheels, upsideDown]  / Gunners will try to not leave their vehicle.
			// Otherwise:
			} else {
				// SPAWNING AMPHIBIOUS GROUND VEHICLE AND ITS CREW:
				if ( !_isAirCrew && !_isNauCrew ) then {
					// Creating the vehicle on the water:
					_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], 0, "NONE"];
					// Only amphibious vehicle config:
					_veh allowCrewInImmobile [true, false]  // [brokenWheels, upsideDown]  / Gunners will try to not leave their vehicle.
				} else {
					// SPAWNING THE HELICOPTER AND ITS CREW:
					if _isAirCrew then {
						// If helicopter should spawn landed, check first if its spawn in on land and, if not, make the helicopter spawning hovering:
						if !CSWR_isHeliSpwningInAir then {
							// Spawn is in water:
							if ( (surfaceIsWater _spwnPos) ) then { _isEmergencyHover = true };
						};
						// if heli will spawn landed, this looping manages if has no blockers over the booked helipad:
						while { !CSWR_isHeliSpwningInAir && !_isEmergencyHover } do {
							// Check if something relevant is blocking the _spwn position:
							_blockers = _spwnPos nearEntities [["Helicopter", "Plane", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "UAV"], 20];
							// If there's NO blockers:
							if ( _blockers isEqualTo [] ) then { break };
							// Debug messages:
							if CSWR_isOnDebug then {
								systemChat format ["%1 HELICOPTER > A %2 helicopter's waiting its HELIPAD (%3) to be clear. Next try soon...",
								CSWR_txtDebugHeader, _tag, _spwn];
								if ( CSWR_isOnDebugHeli || CSWR_isOnDebugSupport ) then { { systemChat format ["HELIPAD BLOCKER:   %1", typeOf _x] } forEach _blockers };
							};
							// Breather for the next loop check:
							sleep 20;  // IMPORTANT: leave this command in the final of this scope/loop, never in the beginning.
						};  // While loop ends.
						// Spawn in the air:
						if ( CSWR_isHeliSpwningInAir || _isEmergencyHover ) then {
							// Create the vehicle and its crew:
							_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], 0, "FLY"];
						// Spawn landed:
						} else {
							// Create the vehicle and its crew:
							_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], 0, "NONE"];
							_veh engineOn true;
						};
						// Only helicopter config > Features:
						if ( _grpType isEqualTo "heliL" ) then { _veh flyInHeight CSWR_heliLightAlt };
						if ( _grpType isEqualTo "heliM" ) then { _veh flyInHeight CSWR_heliMediumAlt };
						if ( _grpType isEqualTo "heliH" ) then { _veh flyInHeight CSWR_heliHeavyAlt };
					// Otherwise:
					} else {
						// SPAWNING THE NAUTICAL VEHICLE AND ITS CREW:
						// Creating the vehicle on the water:
						_veh = createVehicle [_grpClassnames # 0, _spwnPos, [], 0, "NONE"];
						// Only nautical vehicle config:
							// Reserved space.
					};
				};
			};
			// Only vehicle config > Setting the vehicle direction:
			_veh setDir (markerDir _spwn);
			if (CSWR_removeItemsCargo # 0) then { clearWeaponCargo _veh };
			if (CSWR_removeItemsCargo # 1) then { clearMagazineCargo _veh };
			if (CSWR_removeItemsCargo # 2) then { clearItemCargo _veh };
			if (CSWR_removeItemsCargo # 3) then { clearBackpackCargo _veh };
			// Creating the group and its ground vehicle crew:
			_grp = _side createVehicleCrew _veh;  // CRITICAL: never remove _side to avoid inconscistences when mission editor to use vehicles from another side.
			// Only vehicle config:
			_veh setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners will try to not leave their vehicle.
			[_tag, _veh, _isAirCrew] call THY_fnc_CSWR_veh_electronic_warfare;
			// Additional CPU Breather for all vehicles:
			uiSleep _serverBreath;
		};

		// RIGHT AFTER THE SPAWN:
		// Update the _grpData:
		_grpData set [2, _grp];
		// Group/Vehicle config > Server performance:
		_grp deleteGroupWhenEmpty true;
		// Identity selector:
		[_tag, _grp] call THY_fnc_CSWR_identity_selector;
		// Group name selector:
		[_grp, _destType, _isAirCrew, _isTransp] call THY_fnc_CSWR_grp_callSign_selector;
		// Loadout selector:
		[_tag, _grp, _grpType, _veh, _isVeh, _isAirCrew, _isNauCrew, _isMarine, _isPara] call THY_fnc_CSWR_loadout_selector;
		// Group/Vehicle config > Units skills:
		[_grpType, _grp, _destType, _tag] call THY_fnc_CSWR_unit_skills;
		// Only group config > Formation:
		if !_isVeh then { [_grpData] call THY_fnc_CSWR_grp_form };
		// Group/Vehicle config > Adding to ZEUS:
		if ( CSWR_isEditableByZeus || CSWR_isOnDebug ) then {
			{  // forEach allCurators:
				// Unit(s):
				_x addCuratorEditableObjects [units _grp, true];
				// Vehicle itself:
				if _isVeh then { _x addCuratorEditableObjects [[vehicle (leader _grp)], true] };
				// Breather:
				sleep 1;
			} forEach allCurators;
		};
		// Only helicopter config > Takeoff delay:
		if ( _isAirCrew && !CSWR_isHeliSpwningInAir && !_isEmergencyHover ) then {
			// If combat one:
			if !_isTransp then {
				// Defining the preparing time:
				_t = time + (selectRandom CSWR_heliTakeOffDelay);
				if ( CSWR_isOnDebug && CSWR_isOnDebugHeli ) then {
					["%1 HELICOPTER > A %2 helicopter PREPARING to take off soon...",
					CSWR_txtDebugHeader, _tag] call BIS_fnc_error };
				// Preparing time to take off:
				waitUntil { sleep 5; !alive _veh || time > _t };
			// Transport support:
			// Important: for a best gameplay experience, better do not include cooldown for transport support take off.
			} else {
				// Escape > If air support vehicle explodes, remove player group from those using this support resource, and abort:
				if ( !alive _veh || !alive driver _veh ) exitWith {
					// Remove the player's group from the support list:
					if ( _destType isEqualTo "MOVE_EXTRACTION" ) then { [_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo };
					if ( _destType isEqualTo "MOVE_TRANSPORT" ) then { [_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo };
					// Return:
					true;
				};
			};
			// Debug:
			if ( CSWR_isOnDebug && alive _veh ) then { systemChat format ["%1 %2 '%3' helicopter is TAKING OFF!", CSWR_txtDebugHeader, _tag, _grp] };
		};
		// If Spawn was a Paradrop:
		if _isPara then {
			// For People:
			if !_isVeh then {
				// Timeout:
				_t = time + 180;  // 3 minutes. If leader fell over a rock or building higher than 10m so timeout is needed to avoid infinite loop.
				// Wait the leader touch the ground or water:
				// CRITICAL: about terrain, don't set less than 10m coz if leader fell over a rock, they are NOT touching the ground for Arma!
				waitUntil { sleep 10; (getPosATL (leader _grp)) # 2 < 10 || (getPosASLW (leader _grp)) # 2 < 1 || !alive leader _grp || time > _t };
				// Time for the leader arrive on the ground (coz the '10'm gap):
				sleep 8;
				[_tag, leader _grp, 100, 1] call THY_fnc_CSWR_makes_unit_touch_the_ground;
				// As civilian gets panic after landing (crouched), this will restart their leader body animation, making them get "UP" again:
				if ( _tag isEqualTo "CIV" ) then { leader _grp switchMove "" };
				// If the group has more than one unit alive:
				if ( {alive _x} count (units _grp) > 1 ) then {
					// Regroup with leader:
					{  // forEach units _grp:
						// If a group member gets unconscious:
						if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then { 
							// Kills the unit:
							_x setDamage 1;
							// Debug:
							if ( CSWR_isOnDebug && CSWR_isOnDebugPara ) then {
								systemChat format ["%1 PARADROP > A %2 '%3' member gets unconscious. CSWR kills the unit to preverse the group plans.",
								CSWR_txtDebugHeader, _tag, _grp];
							};
						};
						// if leader:
						if ( _x isEqualTo (leader _grp) ) then {
							// If not civilian leader, it sets a military body position to wait group members:
							if ( _tag isNotEqualTo "CIV" ) then { _x setUnitPos "MIDDLE" };  // in water this is ignored.
						// Otherwise, if another group member:
						} else {
							// Timeout:
							_t = time + 180;  // 3 minutes. If unit fell over a rock or building higher than 10m so timeout is needed to avoid infinite loop.
							// Wait the member touch the ground or water:
							// CRITICAL: about terrain, don't set less than 10m coz if member fell over a rock, they are NOT touching the ground for Arma!
							waitUntil { sleep 3;  (getPosATL _x) # 2 < 10 || (getPosASLW _x) # 2 < 1 || !alive _x || time > _t };
							// Time for the leader arrive on the ground (coz the '10'm gap):
							sleep 5;
							[_tag, leader _grp, 50, 1] call THY_fnc_CSWR_makes_unit_touch_the_ground;
							// If civilian and not the leader:
							if ( _tag isEqualTo "CIV" && _x isNotEqualTo (leader _grp) ) then { 
								// As civilian gets panic after landing (crouched), this will restart their body animation, making them get "UP" again:
								_x switchMove "";
							};
							// Regroup at leader position if they are on land:
							if !(surfaceIsWater (getPos (leader _grp))) then { _x doFollow (leader _grp) };
						};
					} forEach units _grp;
					// If leader on land:
					if !(surfaceIsWater (getPos (leader _grp))) then {
						// Wait the group members regroup for the first mission move after paradrop landing:
						[_tag, _grp, 30, getPos (leader _grp)] call THY_fnc_CSWR_leader_waiting_grp_mates;
					// If leader in water:
					} else {
						// Find a dry land near:
						_emergencyPos = getPos (leader _grp) findEmptyPosition [10, CSWR_spwnsParadropSpreading / 1.8];
						// Leader has been found a dry land:
						if ( _emergencyPos isNotEqualTo [] ) then {
							// Teleport to there:
							leader _grp setPosATL _emergencyPos;
							sleep 1;
							leader _grp doMove (getPosATL leader _grp);
							// Wait the group members regroup for the first mission move after paradrop landing:
							[_tag, _grp, 30, _emergencyPos] call THY_fnc_CSWR_leader_waiting_grp_mates;
						// No dry land found:
						} else {
							// To avoid problematic behavior with new leader if also in water, selecting all units in water or dead yet (any reason) to delete them:
							{ deleteVehicle _x; sleep 1 } forEach ((units _grp) select { surfaceIsWater (getPos _x) || !alive _x});
							// Debug:
							if ( CSWR_isOnDebug && CSWR_isOnDebugPara ) then {
								systemChat format ["%1 PARADROP > One or more %2 '%3' members were deleted coz they were into the water with the original group leader that couldn't find a safe land to regroup.",
								CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
							};
							// Wait the group members regroup for the first mission move after paradrop landing:
							[_tag, _grp, 30, getPos (leader _grp)] call THY_fnc_CSWR_leader_waiting_grp_mates;
						};
					};
				};
			// For Vehicle:
			} else {
				// Paradrop things:
				[_tag, _veh, _grp] call THY_fnc_CSWR_veh_paradrop;
				// Time before the vehicle start to move right after the paradrop landing:
				sleep 5;
			};
		};

		// WAYPOINTS SECTION:
		// Group/Vehicle config > Destination (open a new thread):
		[_spwn, _spwns, _destType, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, _grpCaller] spawn THY_fnc_CSWR_go;

		// UNDO THE BOOKING:
		// For vehicle:
		if _isVeh then {
			// Anti-spawn-blocker for vehicles:
			[_tag, _spwn, _grp, _veh, _spwnPos, _safeDis] call THY_fnc_CSWR_spawn_antiBlocker;
			// If ground or nautical vehicle:
			if !_isAirCrew then {
				// Undo the booking:
				["BOOKING_SPAWNVEH", _tag, _spwn, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
				// Debug:
				if ( CSWR_isOnDebug && CSWR_isOnDebugBooking ) then {
					systemChat format ["%1 BOOKING_SPAWNVEH > %2 '%3' marker is free.",
					CSWR_txtDebugHeader, _tag, _spwn]; sleep 1;
				};
			// Otherwise:
			} else {
				// If helicopter:
				["BOOKING_SPAWNHELI", _tag, _spwn, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
				if ( CSWR_isOnDebug && CSWR_isOnDebugBooking ) then {
					systemChat format ["%1 BOOKING_SPAWNHELI > %2 '%3' marker is free.",
					CSWR_txtDebugHeader, _tag, _spwn]; sleep 1;
				};
			};
		};
	};
	// Return:
	scopeName "earlyend";
	true;
};


THY_fnc_CSWR_spawn_delay = {
	// This function verify what method of Spawn Delay the group/vehicle will execute.
	// Returns nothing.

	params ["_tag", "_spwnDelayMethods", "_isVeh", "_grpSize"];
	private ["_isReadyToSpwn", "_t", "_ctr", "_wait", "_caller", "_txt1"];

	// Initial values:
	_isReadyToSpwn = false;
	// Declarations:
	_t          = time;
	_ctr        = _t;
	_wait       = 10;  // CAUTION: this number is used to calcs the TIMER too.
	_caller     = if _isVeh then {"vehicle"} else {"group"};
	// Debug texts:
	_txt1 = format ["A %1 %2 was granted TO SPAWN", _tag, _caller];
	// Spawn Delay conditions > Stay checking if the group ISN'T ready to spawn:
	while { !_isReadyToSpwn } do {
		// Breather:
		uiSleep _wait;
		{  // forEach _spwnDelayMethods:
			// TIMER DELAY:
			// If Spawn Delay has a timer, check if it's a number:
			if ( typeName _x isEqualTo "SCALAR" ) then {
				// Counter increase:
				_ctr = _ctr + _wait;
				// Timer checker:
				if ( _ctr >= _t + ((abs _x) * 60) ) exitWith {
					// Function completed:
					_isReadyToSpwn = true;
					// Debug:
					if CSWR_isOnDebug then {
						systemChat format ["%1 SPAWN DELAY > %2 by TIMER (it was %3 minutes).",
						CSWR_txtDebugHeader, _txt1, _x]; sleep 1;
					};
				};
			// otherwise:
			} else {
				// BOOLEAN FLAG DELAY:
				if ( typeName _x isEqualTo "STRING" ) then {
					// If true, break the looping and spawn:
					if (missionNamespace getVariable [_x, false]) exitWith {  // if nothing declared, default value is false!
						// Function completed:
						_isReadyToSpwn = true;
						// Debug:
						if CSWR_isOnDebug then {
							systemChat format ["%1 SPAWN DELAY > %2 by BOOLEAN FLAG (''%3'' turned TRUE).",
							CSWR_txtDebugHeader, _txt1, _x]; sleep 1;
						};
					};
				// Otherwise:
				} else {
					// TRIGGER DELAY:
					// If Spawn Delay has a trigger, check if it's a trigger object:
					if ( _x isKindOf "EmptyDetector" ) then { 
						// If the trigger has been activated:
						if ( triggerActivated _x ) exitWith {
							// Function completed:
							_isReadyToSpwn = true; 
							// Debug:
							if CSWR_isOnDebug then {
								systemChat format ["%1 SPAWN DELAY > %2 by TRIGGER activation (%3).",
								CSWR_txtDebugHeader, _txt1, _x]; sleep 1;
							};
						};
					// Otherwise:
					} else {
						// TARGET DELAY:
						// If the target has been killed/destroyed:
						if ( !alive _x ) exitWith {
							// Function completed:
							_isReadyToSpwn = true;
							// Debug:
							if CSWR_isOnDebug then {
								systemChat format ["%1 SPAWN DELAY > %2 by TARGET elimination/destruction (%3).",
								CSWR_txtDebugHeader, _txt1, _x]; sleep 1;
							};
						};
					};
				};
			};
		} forEach _spwnDelayMethods;
	};  // while loop ends;
	// Debug:
	if CSWR_isOnDebug then {
		// Debug monitor > How many units will spawn soon:
		CSWR_spwnDelayQueue = CSWR_spwnDelayQueue - _grpSize;
		publicVariable "CSWR_spwnDelayQueue";
	};
	// Return:
	true;
};


THY_fnc_CSWR_add_validation = {
	// This function validate most of the parameters in THY_fnc_CSWR_add_people and THY_fnc_CSWR_add_vehicle. Deeper validations for spawns (THY_fnc_CSWR_spawn_type_checker) and destinations (THY_fnc_CSWR_destination_type_checker) happen later when CSWR would have more information.
	// Returns _isInvalid: bool.

	params ["_isVeh", "_tag", "_spwnsData", "_callerClass", "_destsData"];
	private ["_isInvalid", "_mkrOwner", "_spwns", "_spwnsSector", "_destType", "_destSector", "_caller"];

	// Escape:
		// reserved space.
	// Initial values:
	_isInvalid = false;
	_mkrOwner  = "";
	// Declarations:
	_spwns       = _spwnsData # 0;
	_spwnsSector = _spwnsData # 1;
	_destType    = _destsData # 0;
	_destSector  = _destsData # 1;
	_caller   = if !_isVeh then { "group" } else { "vehicle" };
	// Debug texts:
		// reserved space.
	// Main functionality:
	// Escape > If some issue with the side declaration, abort:
	if ( _tag isEqualTo "" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > One or more %2s have a typo/mispelling in the name of the side they belong to. Check the 'fn_CSWR_2_population.sqf' file and fix it. The %2 WON'T be created.",
		CSWR_txtWarnHeader, _caller]; sleep 10;
		// Return:
		true;
	};
	/*
	SPAWN STRUCTURE --------------------------------------------------------------------------------------------------
	_spwnsData = [CSWR_spawnsForPeopleBLU, "A"]
		[0 CSWR_spawnsForPeopleBLU
			[0 Land markers],
			[1 Water markers]
		]
	*/
	// Escape > If _spwnsData is not array, abort:
	if ( typeName _spwnsData isNotEqualTo "ARRAY" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > One or more %2 %3 rows have no '[ ]' in spawn-points-type column. Fix it in 'fn_CSWR_2_population.sqf' file, e.g: [CSWR_spawnsForPeople%2, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		// Return:
		true;
	};
	// Escape > If there's NO spawn-points-type, abort:
	if ( isNil { typeName _spwns isEqualTo "ARRAY" } || _spwnsData isEqualTo [] ) exitWith {  // WIP not sure if the logic is right, but somehow it works.
		// Warning:
		systemChat format ["%1 SPAWN > One or more %2 %3 rows got an invalid type of spawn-points or the spawn-points-type column has its '[ ]' empty. Fix it in fn_CSWR_2_population.sqf file, e.g: [CSWR_spawnsForPeople%2, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > if first element is a string, abort:
	if ( typeName _spwns isEqualTo "STRING" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > Looks you didn't type the %2 spawn-point-type in its column, only the sector. Use that inside the '[ ]' like this for example: [CSWR_spawnsForPeople%2, ''A''] in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag]; sleep 5;
		// Return:
		true;
	};
	// Escape > first element is not array, abort:
	if ( typeName (_spwns # 0) isNotEqualTo "ARRAY" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > Looks you declared the %2 spawn-points without '[ ]' in spawn-points-type column in 'fn_CSWR_2_population.sqf' file at least in one of the %2 %3 rows creation.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		// Return:
		true;
	};
	// Escape > If the sum of land and water markers is empty, abort:
	if ( ((_spwns # 0)+(_spwns # 1)) isEqualTo [] ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > There IS NO %2 SPAWNPOINT to create a %2 %3. On EDEN markers, if you're trying to spawn a group, use marker's variable-name like '%4%5SPAWN%5%2%5sectorletter%5anynumber'. If you wanna spawn a ground or nautical vehicle, use '%4%5SPAWNVEH%5%2%5sectorletter%5anynumber'. Or, a HELICOPTER, '%4%5SPAWNHELI%5%2%5sectorletter%5anynumber'.",
		CSWR_txtWarnHeader, _tag, _caller, CSWR_prefix, CSWR_spacer]; sleep 10;
		// Return:
		true;
	};
	// Escape > test if there is at least one marker string-name in land-markers array OR in water-markers array. If not, abort:
	if ( typeName ((_spwns # 0) # 0) isNotEqualTo "STRING" || typeName ((_spwns # 1) # 0) isNotEqualTo "STRING" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > Somehow, %2 there's NO VALID spawn-point on land, nor spawn-point in water. Check the 'fn_CSWR_2_population.sqf' file and make sure you're using the structure like this: [CSWR_spawnsForPeople%2, ''A''] for example.",
		CSWR_txtWarnHeader, _tag]; sleep 10;
		// Return:
		true;
	};
	// Escape > If the side tag is not found in the first spawn-marker inside the sum of non and sectorized markers, abort to avoid a side spawning through spawnpoint from another side:
	_mkrOwner = (((((_spwns # 0)+(_spwns # 1)) # 0) splitString CSWR_spacer) # 2);  // splitString results e.g: ["CSWR","SPAWN","BLU","1"]
	if ( _mkrOwner isNotEqualTo _tag ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > NOT ALLOWED to spawn a %2 %3 in %4 spawn-points. Check your 'fn_CSWR_2_population.sqf' file and make sure all %2 and %4 %3 rows have their spawn-points correctly assigned for their sides.", 
		CSWR_txtWarnHeader, _tag, _caller, _mkrOwner]; sleep 5;
		// Return:
		true;
	};
	// Escape > If spawn sector is not a string, abort:
	if ( isNil { typeName _spwnsSector isEqualTo "STRING" } ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > Spawn-sector's missing in some %2 %3 row in 'fn_CSWR_population' file! Sector in Population file must be a letter between QUOTES, e.g: [%4%2, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader,
		_tag,
		_caller,
		if !_isVeh then {"CSWR_spawnsForPeople"} else {"CSWR_spawnsForVehicle"}]; sleep 5;
		// Return:
		true;
	};
	// Escape > If the spawn sector letter has more than one character, abort:
	if ( _spwnsSector isNotEqualTo "" && count _spwnsSector isNotEqualTo 1 ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > At least one %2 %3 has an invalid spawn-SECTOR. Sectorization accepts only ONE LETTER, like this: [CSWR_spawnsForPeople%2, ''A'']. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		// Return:
		true;
	};
	// Escape > If exist spawn-points on Eden, but no declared sector in fn_CSWR_2_population.sqf file:
	if ( (((_spwns # 0) # 0) + ((_spwns # 1) # 0)) isNotEqualTo [] && _spwnsSector isEqualTo "" ) exitWith {
		// Warning:
		systemChat format ["%1 SPAWN > Looks you have correctly spawn-points on Eden but forgot to declarate their sector letter in 'fn_CSWR_2_population.sqf'. To fix, add the sector letter in each row that is missing.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		// Return:
		true;
	};
	// If group:
	if !_isVeh then {
		// If editor is using a vehicle caller and not a group instead:
		if ( typeName _callerClass isEqualTo "STRING" ) exitWith {
			// Warning:
			if ( _tag isNotEqualTo "CIV" ) then {
				systemChat format ["%1 GROUP > At least one of %2 group rows in 'fn_CSWR_2_population.sqf' file you're requesting a VEHICLE and NOT a group of soldiers as expected. Remember to use for each %2 group row ONLY 'CSWR_group_%2_light', 'CSWR_group_%2_medium', 'CSWR_group_%2_heavy', 'CSWR_group_%2_custom_1', or 'CSWR_group_%2_sniper'.",
				CSWR_txtWarnHeader, _tag];
			} else {
				systemChat format ["%1 GROUP > At least one of %2 group rows in 'fn_CSWR_2_population.sqf' file you're requesting a VEHICLE and NOT a group of people as expected. Remember to use for each %2 group row ONLY 'CSWR_group_%2_light', 'CSWR_group_%2_medium', 'CSWR_group_%2_heavy', or 'CSWR_group_%2_custom_1'.",
				CSWR_txtWarnHeader, _tag];
			};
			 sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
		// If has something declared as unit classname, but the first element is not string, abort:
		if ( _callerClass isNotEqualTo [] && typeName (_callerClass # 0) isNotEqualTo "STRING" ) exitWith {
			// Warning:
			systemChat format ["%1 GROUP > At least one of the %2 groups looks the classname(s) is/are NOT declared between quotes in 'fn_CSWR_2_population.sqf' file. Right way e.g: ['X_classname_one', 'X_classname_two'].",
			CSWR_txtWarnHeader, _tag]; sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
		// If the group is empty, abort:
		if ( _callerClass isEqualTo [] ) exitWith {
			// Warning:
			systemChat format ["%1 GROUP > At least one %2 group type configured in 'fn_CSWR_2_population.sqf' file HAS NO classname(s) declared for CSWR script gets to know which unit(s) should be created. Fix it!", 
			CSWR_txtWarnHeader, _tag]; sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
	// If vehicle:
	} else {
		// If editor is using a group caller and not a vehicle instead:
		if ( typeName _callerClass isEqualTo "ARRAY" ) exitWith {
			// Warning:
			systemChat format ["%1 VEHICLE > At least one of %2 vehicle rows in 'fn_CSWR_2_population.sqf' file you're requesting a GROUP and NOT a vehicle as expected. Remember to use for each %2 vehicle row ONLY 'CSWR_vehicle_%2_light', 'CSWR_vehicle_%2_medium', 'CSWR_vehicle_%2_heavy', or 'CSWR_vehicle_%2_custom_1', for example.",
			CSWR_txtWarnHeader, _tag];
			 sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
		// If has something declared as vehicle classname, but is not string, abort:
		if ( _callerClass isNotEqualTo "" && typeName _callerClass isNotEqualTo "STRING" ) exitWith {
			// Warning:
			systemChat format ["%1 VEHICLE > At least one of the %2 vehicles looks the classname is NOT declared between quotes in 'fn_CSWR_2_population.sqf' file. Right way is using QUOTES, e.g: ''X_classname_one''.",
			CSWR_txtWarnHeader, _tag]; sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
		// If the vehicle variable is empty, abort:
		if ( _callerClass isEqualTo "" ) exitWith {
			// Warning:
			systemChat format ["%1 VEHICLE > At least one %2 vehicle-type configured in 'fn_CSWR_2_population.sqf' file HAS NO classname declared for CSWR gets to know which vehicle should be created. Fix it, adding a vehicle classname between double-quotes!",
			CSWR_txtWarnHeader, _tag]; sleep 10;
			// Prepare to return:
			_isInvalid = true;
		};
		// Checking the spawn over the Extraction destination influencies:
		if ( _destType isEqualTo "MOVE_EXTRACTION" ) then {
			// If there's NO at least one Spawn for helicopter on land, and the destination type is Extraction move, abort:
			// Important: it doesn't prevent the helicopter to spawn in water if the editor sets on the land and water. So this "water" checks need to happen furthur during the spawn process!
			if ( isNil { !((_spwns # 0) # 0 in (CSWR_spwnsHeliLandBLU + CSWR_spwnsHeliLandOPF + CSWR_spwnsHeliLandIND + CSWR_spwnsHeliLandCIV)) } ) exitWith {  // isNill coz maybe the array is empty and would bring an error.
				// Warning:
				systemChat format ["%1 SPAWN > At least one %2 vehicle is trying to use %3, but the spawn-point type used is NOT for helicopter OR there's NO spawn markers on dry land. When the destination is EXTRACTION, the helicopter SPAWN need to be ON DRY LAND. Check your 'fn_CSWR_2_population.sqf' file and EDEN spawn-markers.",
				CSWR_txtWarnHeader, _tag, _destType]; sleep 10;
				// Prepare to return:
				_isInvalid = true;
			};
		};
	};
	// Escape > Returning if one conditional right above flags _isInvalid as true:
	if _isInvalid exitWith { _isInvalid };
	/*
	DESTINATION STRUCTURE --------------------------------------------------------------------------------------------
	_destsData = [string, "A"]
	*/
	// Escape > If _destsData is not array, abort:
	if ( typeName _destsData isNotEqualTo "ARRAY" ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > One or more %2 %3 rows have no '[ ]' in destination-type column. Fix it in 'fn_CSWR_2_population.sqf' file directly in the destination column of each issued row, e.g: [_move_ANY] or [_move_RESTRICT, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > If there is NO destination, abort:
	if ( count _destsData < 2 ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > One or more %2 %3 rows got an invalid type of destination or the destination-type column has its '[ ]' empty. Fix it in fn_CSWR_2_population.sqf file, e.g: [_move_ANY] or [_move_RESTRICT, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > If _destsData first element is not a string, abort:
	if ( typeName _destType isNotEqualTo "STRING" ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > There IS NO DESTINATION to send a %2 %3. In 'fn_CSWR_2_population.sqf' check if (e.g.) [_move_ANY] or [_move_PUBLIC, ''A''] or [_move_RESTRICTED, ''A''] is configured.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 5;
		// Return:
		true;
	};
	// Escape > If destination sector is not a string, abort:
	if ( isNil { typeName _destSector isEqualTo "STRING" } ) exitWith {  // WIP not sure if the logic is right, but somehow it works.
		// Warning:
		systemChat format ["%1 DESTINATION > Destination SECTOR must be a letter between QUOTES. Fix it in fn_CSWR_2_population.sqf file, e.g: [_move_ANY, ''A'']. The %2 %3 won't be created.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > If the destination-sector letter has more than one character, abort:
	if ( _destSector isNotEqualTo "" && count _destSector > 1 ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > At least one %2 %3 has an invalid destination-SECTOR. Sectorization accepts only ONE LETTER, like this: [_move_RESTRICT, ''A'']. Remember: [_move_ANY] doesn't accept sector-letters. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > If it's NOT one of the exceptions, and has NO destination-sector declared, abort:
	if ( !(_destType in ["MOVE_ANY", "MOVE_EXTRACTION", "MOVE_TRANSPORT"]) && _destSector isEqualTo "" ) exitWith {
		// Warning:
		if (_tag isNotEqualTo "CIV") then {
			systemChat format ["%1 DESTINATION > At least one %2 %3 row is trying to use a destionation WITHOUT a SECTOR. Only '_move_ANY' and '_move_EXTRACTION' don't required sectors. Fix it in 'fn_CSWR_2_population.sqf' file using, for example, [_move_RESTRICT, ''A''] or [_move_PUBLIC, ''A''] or [_move_ANY].",
			CSWR_txtWarnHeader, _tag, _caller];
		} else {
			systemChat format ["%1 DESTINATION > At least one %2 %3 row is trying to use a destionation WITHOUT a SECTOR. Only '_move_ANY' and '_move_EXTRACTION' don't required sectors. Fix it in 'fn_CSWR_2_population.sqf' file using, for example, [_move_PUBLIC, ''A''] or [_move_ANY].",
			CSWR_txtWarnHeader, _tag, _caller];
		};
		sleep 10;
		// Return:
		true;
	};
	// Escape > If it's one of those destinations that don't require sector but has sector declared, abort:
	if ( _destType in ["MOVE_ANY", "MOVE_EXTRACTION", "MOVE_TRANSPORT"] && _destSector isNotEqualTo "" ) exitWith {
		// Warning:
		if ( _destType isEqualTo "MOVE_ANY" ) then {
			systemChat format ["%1 DESTINATION > A %2 %3 is trying to sectorize (%4) a '_move_ANY' in 'fn_CSWR_2_population.sqf' file, and it's forbidden coz '_move_ANY' can send assigned groups and vehicles to any COMMON destinations as PUBLIC and RESTRICTED ones dropped on the map, no matter what sector they are. Remember: '_move_ANY' doesn't include specialized destination as WATCH, HOLD and OCCUPY.",
			CSWR_txtWarnHeader, _tag, _caller, _destSector]; sleep 10;
		} else {
			systemChat format ["%1 DESTINATION > A %2 %3 is trying to sectorize (%4) a '_move_EXTRACTION' in 'fn_CSWR_2_population.sqf' file, and it's forbidden coz EXTRACTION destination goes anywhere the player is, and return to the base automatically, making it doesn't need any marker on Eden or sector in Population file.",
			CSWR_txtWarnHeader, _tag, _caller, _destSector]; sleep 10;
		};
		// Return:
		true;
	};
	// Escape > If civilian side is trying to use one or more forbidden moves for civilian side, abort:
	if ( _tag isEqualTo "CIV" && _destType in ["MOVE_ANY", "MOVE_RESTRICTED", "MOVE_WATCH"] ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > In 'fn_CSWR_2_population.sqf' file, you're trying to use '%3' with a %2 %4. Civilians CAN use '_move_PUBLIC' (people and vehicles), and '_move_OCCUPY' (only people), and '_move_HOLD' (people and vehicles) for example. Fix it.",
		CSWR_txtWarnHeader, _tag, _destType, _caller]; sleep 10;
		// Return:
		true;
	};
	// Escape > If any vehicle is trying to execute the specialized destination OCCUPY, abort:
	if ( _isVeh && _destType isEqualTo "MOVE_OCCUPY" ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > At least one %2 vehicle is trying to use %3. Only people can execute a '_move_OCCUPY'. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _destType]; sleep 5;
		// Return:
		true;
	};
	// Escape > If Extraction and Transport moves are not used by helicopter, abort:
	if ( _destType in ["MOVE_EXTRACTION", "MOVE_TRANSPORT"] && !_isVeh ) exitWith {
		// Warning:
		systemChat format ["%1 DESTINATION > At least one %2 group is trying to use %3. Only HELICOPTERS can execute a '_move_TRANSPORT' and '_move_EXTRACTION'. Fix it in 'fn_CSWR_2_population.sqf' file.",
		CSWR_txtWarnHeader, _tag, _destType]; sleep 5;
		// Return:
		true;
	};
	// Return:
	_isInvalid;
};


THY_fnc_CSWR_add_people = {
	// This function checks if it really is a group-type (on foot) for Arma 3, and does a quick detail validations before next steps with much deeper validations.
	// Returns nothing, but open a new thread.
	
	params ["_side", ["_spwnsData", [[], ""]], ["_grpClassnames", []], ["_form", ""], ["_behavior", ""], ["_destsData", ["", ""]], ["_spwnDelayMethods", []]];
	private ["_tag", "_isValidClasses", "_validBehavior", "_validForm", "_grpData"];
	
	// Error handling:
	if ( count _destsData < 2 ) then { _destsData set [1, ""]};
	// Declarations:
	// Important: dont declare _spwnsData or _destsData selections before the Escapes coz during Escape tests easily the declarations will print out errors that will stop the creation of other vehicles.
	_tag = [_side] call THY_fnc_CSWR_convertion_side_to_tag;
	// Validations:
	if ( [false, _tag, _spwnsData, _grpClassnames, _destsData] call THY_fnc_CSWR_add_validation ) exitWith {};
	_spwnsData         = [_spwnsData # 0, toUpper (_spwnsData # 1)];  // sector-letter tweaked.
	_destsData         = [toUpper (_destsData # 0), toUpper (_destsData # 1)];  // destination-type and sector-letter both case-sensitive tweaked.
	_isValidClasses    = [_tag, "CfgVehicles", "UNIT", "_grpClassnames", _grpClassnames] call THY_fnc_CSWR_is_valid_classname;
	_validBehavior     = [_tag, false, _behavior] call THY_fnc_CSWR_is_valid_behavior;      // [behavior name fixed, isValid]
	_validForm         = [_tag, false, _form] call THY_fnc_CSWR_is_valid_formation;         // [formation name fixed, isValid]
	// Escape:
	if ( !_isValidClasses || !(_validBehavior # 1) || !(_validForm # 1) ) exitWith {};
	// Built the group information for further validations:
	_grpData = [_side, _tag, _grpClassnames, _destsData # 0, _validBehavior # 0, _validForm # 0] call THY_fnc_CSWR_grp_data;
	// Escape:
	if ( _grpData isEqualTo [] ) exitWith {};
	/*
	Structure of _spwnsData = e.g. [CSWR_spawnsForPeopleBLU, "A"]
	[0 CSWR_spawnsForPeopleBLU
		[0 land],
		[1 water]
	]
	*/
	// Spawn Schedule (open a new thread):
	[_spwnsData, _spwnDelayMethods, _grpData, false, _validBehavior # 0, _destsData] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breather:
	sleep 1;
	// Return:
	true;
};


THY_fnc_CSWR_add_vehicle = {
	// This function checks what vehicle type this is for Arma 3, and does a quick detail validations before next steps with much deeper validations.
	// Returns nothing, but open a new thread.
	
	params ["_side", ["_spwnsData", [[], ""]], ["_vehClass", ""], ["_behavior", ""], ["_destsData", ["", ""]], ["_spwnDelayMethods", []]];
	private ["_tag", "_isValidClasses", "_validBehavior", "_grpData"];
	
	// Error handling:
	if ( count _destsData < 2 ) then { _destsData set [1, ""]};
	// Declarations:
	// Important: dont declare _spwnsData or _destsData selections before the Escapes coz during Escape tests easily the declarations will print out errors that will stop the creation of other vehicles.
	_tag = [_side] call THY_fnc_CSWR_convertion_side_to_tag;
	// Validations:
	if ( [true, _tag, _spwnsData, _vehClass, _destsData] call THY_fnc_CSWR_add_validation ) exitWith {};
	_spwnsData         = [_spwnsData # 0, toUpper (_spwnsData # 1)];  // sector-letter tweaked.
	_destsData         = [toUpper (_destsData # 0), toUpper (_destsData # 1)];  // destination-type and sector-letter both case-sensitive tweaked.
	_isValidClasses    = [_tag, "CfgVehicles", "VEHICLE", "_vehClass", [_vehClass]] call THY_fnc_CSWR_is_valid_classname;
	_validBehavior     = [_tag, true, _behavior] call THY_fnc_CSWR_is_valid_behavior;      // [behavior name fixed, isValid]
	// Escape:
	if ( !_isValidClasses || !(_validBehavior # 1) ) exitWith {};
	// Built the vehicle information for further validations:
	_grpData = [_side, _tag, [_vehClass], _destsData # 0, _validBehavior # 0, ""] call THY_fnc_CSWR_grp_data;
	// Escape:
	if ( _grpData isEqualTo [] ) exitWith {};
	/* 
	Structure of _spwnsData = e.g. [CSWR_spawnsForVehicleOPF, "B"]
	[0 CSWR_spawnsForVehicleOPF
		[0 land],
		[1 water]
	]
	*/
	// Spawn Schedule (open a new thread):
	[_spwnsData, _spwnDelayMethods, _grpData, true, _validBehavior # 0, _destsData] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breather:
	sleep 5;  // Critical for paradrop of amphibious vehicles!
	// Return:
	true;
};


THY_fnc_CSWR_leader_waiting_grp_mates = {
	// This function only makes the current group leader waits for the rest of the group to be ready to move.
	// Returns true if ready to go.

	params ["_tag", "_grp", "_dis", "_meetingPos", ["_tryCooldown", 20], ["_autoRescueFromWater", true]];
	private ["_try", "_form"];

	// Escape > if the group doesn't exist anymore, or just one guy, abort:
	if ( {alive _x} count (units _grp) < 2 ) exitWith { true };
	// Declarations:
	_try  = round ((CSWR_spwnsParadropWaiting * 60) / _tryCooldown);
	_form = formation _grp;
	// Stop the leader:
	doStop (leader _grp);  // if it's a new leader that, before, received order to regroup with old leader, this one would run to the old leader pos (maybe in water), so it's needed!
	// Forcing the group to execute a new formation:
	_grp setBehaviourStrong "AWARE";  // "'SAFE' or 'CARELESS' behavior ignores set formation. It'll be restored to the original behavior (editor's choice) when the group receives its move mission later!
	_grp setFormation "DIAMOND";  // Important: in rough terrains and urban areas, it makes difference to minimize the chances of units get stuck into rocks and walls during formation in waiting time!
	// Ask to regroup:
	{ _x doFollow (leader _grp) } forEach (units _grp);
	// Wait the group members regroup for the first mission move after paradrop landing:
	waitUntil {
		// If the new leader is NOT in _meetingPos:
		if ( (leader _grp distance2D _meetingPos) > 10 ) then {
			// Case original leader died in pos, but new leader is far:
			// if new leader is on land:
			if ( !(surfaceIsWater (getPos (leader _grp))) ) then {
				leader _grp doMove _meetingPos;
			// But if in water:
			} else {
				leader _grp setPosATL _meetingPos;
			};
		// Leader in position:
		} else {
			// Leader waiting like a boss:
			if ( _tag isNotEqualTo "CIV" && unitReady (leader _grp) ) then { leader _grp setUnitPos "MIDDLE" };
			// CRUCIAL: if _autoRescue false, unfortunately is possible one or more units in water get stuck even with their leaders asking to leave the water. Looks A3 issue!
			if _autoRescueFromWater then {
				((units _grp select { alive _x && surfaceIsWater (getPos _x) && _x distance2D (leader _grp) > _dis }) # 0) setPosATL (getPosATL (leader _grp));
			};
			// If waiting tolerance exceeded, teleport those issued units to leader pos:
			if ( _try isEqualTo 0 ) then {
				// Debug:
				if ( CSWR_isOnDebug && CSWR_isOnDebugPara ) then {
					["%1 PARADROP > A %2 paratroop-leader waited ~%3 minutes for %4 units to regroup, but they couldn't, so they'll be teleported to leader pos now...",
					CSWR_txtDebugHeader, _tag, CSWR_spwnsParadropWaiting, count (units _grp select { alive _x && _x distance2D (leader _grp) > _dis })] call BIS_fnc_error;
				};
				// Teleporting:
				{
					doStop _x;
					_x setPosATL (getPosATL (leader _grp));
					sleep 1;
					_x doFollow (leader _grp);
				} forEach (units _grp select { alive _x && _x distance2D (leader _grp) > _dis }) };
			// Waiting tries:
			_try = _try - 1;
		};
		// Breath:
		sleep _tryCooldown;
		// Break the waiting if:
		(({ alive _x } count (units _grp)) isEqualTo ({ _x distance (leader _grp) < _dis } count (units _grp))) || isNull _grp /* || !alive (leader _grp) */;
	};
	// If a new leader came during the waitUntil and they have the entire group running to the old leader (dead) pos, it prevents new leader to go to the old leader pos before starts mission:
	doStop leader _grp; leader _grp doMove (getPosATL leader _grp);
	// Restore the leader body position if they get "MIDDLE":
	if ( _tag isNotEqualTo "CIV" ) then { leader _grp setUnitPos "UP" };
	// Restore original formation:
	_grp setFormation _form;
	// Return:
	true;
};


THY_fnc_CSWR_makes_unit_touch_the_ground = {
	// This function find a safe ground spot for a unit over a rock or other object that keeps them not touching the ground.
	// Returns _isTouchGround true if the unit is teleported to a safe ground spot.

	params ["_tag", "_unit", "_searchRange", "_methodFail"];
	private ["_isTouchGround", "_pos"];

	// Escape:
	if ( surfaceIsWater (getPos _unit) ) exitWith { false };
	// Initial values:
	_isTouchGround = false;
	_pos           = [];
	// If unit's over a rock (this sh*t is not ground for Arma), teleport them to the ground around:
	if ( (getPosATL _unit) # 2 > 0.2 ) then {
		_pos = getPosATL _unit findEmptyPosition [10, _searchRange];
		// Safe spot was found:
		if ( _pos isNotEqualTo [] ) then {
			_unit setPosATL _pos;
			_isTouchGround = true;
		// NO safe spot:
		} else {
			switch _methodFail do {
				case 1: { _unit setDamage 1 };  // Kill!
				case 2: { deleteVehicle _unit };  // Delete!
			};
			// Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugPara ) then {
				systemChat format ["%1 PARADROP > A member of %2 '%3' gets stuck in a rock or something else. CSWR removes the unit to preverse the group plans.",
				CSWR_txtDebugHeader, _tag, group _unit];
			};
		};
	};
	// Return:
	_isTouchGround;
};


THY_fnc_CSWR_go = {
	// It's a new thread!
	// After the group/vehicle spawn, this function selects the destination-type (and its markers on map) that group/vehicle will execute in a row and forever.
	// This function runs only once by group/vehicle, except when a vehicle requests a RTB function.
	// Returns nothing, but open a new thread.

	params["_spwn", "_spwns", "_destType", "_destSector", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isAmphib", "_isAirCrew", "_isNauCrew", "_hasServiceRTB", "_grpCaller"];
	private["_dests"];

	// Escape > if the people group doesn't exist anymore, abort:
	if ( !_isVeh && !alive (leader _grp) ) exitWith { true };
	// Escape > if the vehicle doesn't exist anymore, abort:
	if ( _isVeh && !alive (vehicle leader _grp) ) exitWith {
		// If the vehicle is destroyed as soon it spawns, it make sure the player's group will receive a new support if available:
		if ( _destType isEqualTo "MOVE_EXTRACTION" ) then { [_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo };
		if ( _destType isEqualTo "MOVE_TRANSPORT" ) then { [_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo };
		// Return:
		true;
	};
	// Initial values:
	_dests = [];
	// Main functionality:
	switch _destType do {
		case "MOVE_ANY": {
			// For People, Amphibious vehicle, and Regular Ground Vehicle:
			if ( !_isAirCrew && !_isNauCrew ) then {
				_dests = (CSWR_destsANYWHERE # 0);  // Only land
			} else {
				// For Helicopter:
				if _isAirCrew then {
					_dests = ((CSWR_destsANYWHERE # 0) + (CSWR_destsANYWHERE # 1));  // Land and water
				// For Nautical vehicle:
				} else {
					_dests = (CSWR_destsANYWHERE # 1);  // Only water
				};
			};
			// Start the move looping (new thread):
			[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, false] spawn THY_fnc_CSWR_go_ANYWHERE;
		};
		case "MOVE_PUBLIC": {
			// For People, Amphibious vehicle, and Regular Ground Vehicle:
			if ( !_isAirCrew && !_isNauCrew ) then {
				_dests = (CSWR_destsPUBLIC # 0);  // Only land
			} else {
				// For Helicopter:
				if _isAirCrew then {
					_dests = ((CSWR_destsPUBLIC # 0) + (CSWR_destsPUBLIC # 1));  // Land and water
				// For Nautical vehicle:
				} else {
					_dests = (CSWR_destsPUBLIC # 1);  // Only water
				};
			};
			// Looks for only for right letter in sectorized ones:
			_dests = _dests select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// Start the move looping (new thread):
			[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, false] spawn THY_fnc_CSWR_go_dest_PUBLIC;
		};
		case "MOVE_RESTRICTED": {
			// For People, Amphibious vehicle, and Regular Ground Vehicle:
			if ( !_isAirCrew && !_isNauCrew ) then {
				switch _tag do {
					case "BLU":   { _dests = CSWR_destRestrictBLU # 0 };  // Only land
					case "OPF":   { _dests = CSWR_destRestrictOPF # 0 };
					case "IND":   { _dests = CSWR_destRestrictIND # 0 };
					//case "CIV": { _dests = CSWR_destRestrictCIV # 0 };  // CIV cannot use this kind of destination.
				};
			} else {
				// For Helicopter:
				if _isAirCrew then {
					switch _tag do {
						case "BLU":   { _dests = ((CSWR_destRestrictBLU # 0) + (CSWR_destRestrictBLU # 1)) };  // Land and water
						case "OPF":   { _dests = ((CSWR_destRestrictOPF # 0) + (CSWR_destRestrictOPF # 1)) };
						case "IND":   { _dests = ((CSWR_destRestrictIND # 0) + (CSWR_destRestrictIND # 1)) };
						//case "CIV": { _dests = ((CSWR_destRestrictCIV # 0) + (CSWR_destRestrictCIV # 1)) };  // CIV cannot use this kind of destination.
					};
				// For Nautical vehicle:
				} else {
					switch _tag do {
						case "BLU":   { _dests = CSWR_destRestrictBLU # 1 };  // Only Water
						case "OPF":   { _dests = CSWR_destRestrictOPF # 1 };
						case "IND":   { _dests = CSWR_destRestrictIND # 1 };
						//case "CIV": { _dests = CSWR_destRestrictCIV # 1 };  // CIV cannot use this kind of destination.
					};
				};
			};
			// Looks for only for right letter in sectorized ones:
			_dests = _dests select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// Start the move looping (new thread):
			[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, false] spawn THY_fnc_CSWR_go_dest_RESTRICTED;
		};
		case "MOVE_WATCH": {
			// Which side is consulting:
			switch _tag do {
				case "BLU":   { _dests = CSWR_destWatchBLU # 0 };  // Only land
				case "OPF":   { _dests = CSWR_destWatchOPF # 0 };
				case "IND":   { _dests = CSWR_destWatchIND # 0 };
				//case "CIV": { _dests = CSWR_destWatchCIV # 0 };  // CIV cannot use this kind of destination.
			};
			// Looks for only for right letter in sectorized ones:
			_dests = _dests select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// Start the move (this is not a looping) (new thread):
			[_dests, _tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_WATCH;
		};
		case "MOVE_OCCUPY": {
			// Which side is consulting:
			switch _tag do {
				case "BLU": { _dests = CSWR_destOccupyBLU # 0 };  // Only land
				case "OPF": { _dests = CSWR_destOccupyOPF # 0 };
				case "IND": { _dests = CSWR_destOccupyIND # 0 };
				case "CIV": { _dests = CSWR_destOccupyCIV # 0 };
			};
			// Looks for only for right letter in sectorized ones:
			_dests = _dests select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// Start the move looping (new thread):
			[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
		};
		case "MOVE_HOLD": {
			// Which side is consulting:
			switch _tag do {
				case "BLU": { _dests = CSWR_destHoldBLU # 0 };  // Only land
				case "OPF": { _dests = CSWR_destHoldOPF # 0 };
				case "IND": { _dests = CSWR_destHoldIND # 0 };
				case "CIV": { _dests = CSWR_destHoldCIV # 0 };
			};
			// Looks for only for right letter in sectorized ones:
			_dests = _dests select { _x find (CSWR_spacer + _destSector + CSWR_spacer) isNotEqualTo -1 };
			// Start the move looping (new thread):
			[_dests, _tag, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD;
		};
		case "MOVE_EXTRACTION": {
			// Start the move (new thread):
			[_tag, _spwn, _grpCaller, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_EXTRACTION;
		};
		case "MOVE_TRANSPORT": {
			// Start the move (new thread):
			[_tag, _spwn, _grpCaller, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_TRANSPORT;
		};
		// And if something wrong:
		default { systemChat format ["%1 %2 '%3' group has an UNKNOWN DESTINATION. Check the 'fn_CSWR_2_population.sqf' file.", CSWR_txtWarnHeader, _tag, _grp]; sleep 5 };
	};
	// Debug:
	if ( CSWR_isOnDebug && CSWR_isOnDebugSectors && !(_destType in ["MOVE_EXTRACTION", "MOVE_TRANSPORT"]) ) then {
		// Message:
		["%1 DESTINATION > %2 %3 %4 | %5 = %6.",
		CSWR_txtDebugHeader,
		_tag,
		if !_isVeh then {"group"} else {if (!_isAmphib && !_isAirCrew && !_isNauCrew) then {"Ground vehicle"} else {if _isAmphib then {"Amphibious vehicle"} else {if _isAirCrew then {"Helicopter"} else {"Nautical vehicle"}}}},
		_grp,
		if (_destSector isNotEqualTo "") then {format ["Sector-%1", _destSector]} else {"'_move_ANY' applied"},
		str _dests] call BIS_fnc_error;
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_altitude = {
	// This function checks the altitude of the waypoint.
	// Returns _areaToPass. Array.

	params ["_tag", "_grp", "_grpType", "_areaToPass", "_isAirCrew", "_isHunting", "_isRTB"];
	//private [""];

	// Escape > If damaged or wounded or not helicopter:
	if ( _isRTB || !_isAirCrew ) exitWith { _areaToPass /* Returning */ };
	// If helicopter:
	// If everything is alright wih helicopter, go to right altitude:
	if !_isHunting then {
		// If helicopter, set the new waypoint altitude (z axis):
		if ( _grpType isEqualTo "heliL" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliLightAlt] };
		if ( _grpType isEqualTo "heliM" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliMediumAlt] };
		if ( _grpType isEqualTo "heliH" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliHeavyAlt] };
	};
	// Return:
	_areaToPass;
};


THY_fnc_CSWR_go_next_condition = {
	// This function checks if the group or vehicle have been reached the condition for the next waypoint.
	// Returns _isRTB. Bool.

	params ["_tag", "_grp", "_isVeh", /* "_isAmphib", */ "_isAirCrew", "_isNauCrew", "_isHunting", "_hasServiceRTB"];
	private ["_isRTB", "_t", "_veh", "_driver", "_gunner"];

	// Initial values:
	_isRTB    = false;
	_t     = 0;
	_veh      = objNull;
	_driver   = objNull;
	_gunner   = objNull;
	// For People:
	if !_isVeh then {
		// waiting the group gets close enough of the waypoint position:
		waitUntil {
			// Breather for the next loop check:
			sleep 20;
			// Conditions to break the loop:
			isNull _grp ||
			!alive (leader _grp) ||
			(waypointType [_grp, currentWaypoint _grp]) isEqualTo "";
		};
		// After the arrival, cooldown:
		_t = if ( (waypointType [_grp, currentWaypoint _grp]) isNotEqualTo "" ) then { time + (selectRandom CSWR_destCommonTakeabreak) } else { 0 };
		waitUntil {
			// Breather for the next loop check:
			sleep 10;
			// Conditions to break the loop:
			isNull _grp || !alive (leader _grp) || time > _t;
		};
	// For Vehicle:
	} else {
		// Internal declarations:
		_veh = vehicle (leader _grp);
		// For Regular Ground Vehicle and Amphibious:
		if ( !_isAirCrew && !_isNauCrew ) then {
			// waiting the vehicle gets close enough of the waypoint position:
			waitUntil {
				// Breather for the next loop check:
				sleep 10;
				// Conditions to break the loop:
				isNull _grp || !alive (leader _grp) || !alive _veh || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "";
			};
			// After the arrival, cooldown:
			_t = if ( (waypointType [_grp, currentWaypoint _grp]) isNotEqualTo "" ) then { time + (selectRandom CSWR_destCommonTakeabreak) } else { 0 };
			waitUntil {
				// Breather for the next loop check:
				sleep 10;
				// Conditions to break the loop:
				isNull _grp || !alive (leader _grp) || !alive _veh || time > _t;
			};
		} else {
			// For Helicopter:
			if _isAirCrew then {
				// Internal declarations:
				_driver = driver _veh;
				_gunner = gunner _veh;
				// Waiting to the next waypoint:
				waitUntil {
					// Breather for the next loop check:
					sleep 10;
					// Debug message > If helicopter is flighting (over x meters high):
					if ( CSWR_isOnDebug && CSWR_isOnDebugHeli && ((getPosATL _veh) # 2) > 5 ) then {
						["%1 HELICOPTER > %2 '%3' > Pilot wounds: %4/1  |  Gunner wounds: %5/1  |  Heli damages: %6/1  |  Heli fuel: %7/0  |  Hunting: %8  |  RTB available: %9",
						CSWR_txtDebugHeader, _tag, _grp, damage _driver, damage _gunner, damage _veh, fuel _veh, _isHunting, if _hasServiceRTB then {"YES"} else {"NO"}] call BIS_fnc_error;
					};
					// Conditions to break the loop:
					isNull _grp ||
					{ _hasServiceRTB && { damage _veh > 0.4 || fuel _veh < 0.3 || damage _driver > 0.1 } } ||
					(waypointType [_grp, currentWaypoint _grp]) isEqualTo "";
				};
				// After the arrival, check if RTB is available and if it's needed:
				if ( _hasServiceRTB && alive (leader _grp) && { damage _veh > 0.4 ||  fuel _veh < 0.3 || damage _driver > 0.1 } ) then { _isRTB = true };
			// For Nautical:
			} else {
				// waiting the vehicle gets close enough of the waypoint position:
				waitUntil {
					// Breather for the next loop check:
					sleep 10;
					// Conditions to break the loop:
					isNull _grp || isNull objectParent leader _grp || !alive (leader _grp) || !alive _veh || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "";
				};
				// Check if nautical crew in water:
				[_tag, _grp] call THY_fnc_CSWR_is_nauticalCrew_in_water;
				// After the arrival, cooldown:
				_t = if ( (waypointType [_grp, currentWaypoint _grp]) isNotEqualTo "" ) then { time + (selectRandom CSWR_destCommonTakeabreak) } else { 0 };
				waitUntil {
					// Breather for the next loop check:
					sleep 10; 
					// Conditions to break the loop:
					isNull _grp || isNull objectParent leader _grp || !alive (leader _grp) || !alive _veh || time > _t;
				};
				// Check if nautical crew in water:
				[_tag, _grp] call THY_fnc_CSWR_is_nauticalCrew_in_water;
			};
		};
	};
	// Return:
	_isRTB;
};


THY_fnc_CSWR_is_nauticalCrew_in_water = {
	// This function makes the nautical crew first leave the water to, next, try the function THY_fnc_CSWR_grp_join_to_survive.
	// Returns bool: true if group leader in water.

	params ["_tag", "_grp"];
	private ["_wp", "_emergencyPos"];

	// Escape > if leader still in nautical vehicle, abort:
	if ( isNull _grp || !isNull objectParent (leader _grp) ) exitWith { false };
	// Initial values:
	_wp = [];
	// Declarations:
	_emergencyPos = getPosASLW (leader _grp) findEmptyPosition [10, 500];
	// Marines found a land:
	if ( _emergencyPos isNotEqualTo [] ) then {
		// Forcing the dumb AI to leave the water asap:
		_grp setBehaviour "CARELESS";
		// Creating the waypoint:
		_wp = _grp addWaypoint [ _emergencyPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointCombatMode "GREEN";  // Hold fire, keep formation.
		_grp setCurrentWaypoint _wp;
		// waiting the group to swim until the land:
		waitUntil {
			// Breather for the next loop check:
			sleep 30;
			// Conditions to break the loop:
			isNull _grp || !alive (leader _grp) || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "";
		};
		// Military body pos:
		if ( _tag isNotEqualTo "CIV" ) then { leader _grp setUnitPos "MIDDLE" };
		// Crew with no vehicle should join in a infantry group:
		[_tag, _grp, 3, 600, 10, true, true, false] call THY_fnc_CSWR_grp_join_to_survive;
	// There is no hope:
	} else {
		// Kill marines:
		{ if (isNull objectParent _x) then { _x setDamage 1 } } forEach units _grp;
		// Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugNautic ) then {
			["%1 NAUTICAL > %2 %3 marines were automatically killed coz they fell in water middle of nowhere!",
			CSWR_txtDebugHeader, _tag, _grp ] call BIS_fnc_error; sleep 1;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_RTB = {
	// This function checks where are the side service stations for vehicles.
	// Returns nothing, but open a new thread.

	params ["_hasServiceRTB", "_spwns", "_tag", "_grpType", "_grp", /* "_isAmphib", */ "_isAirCrew", /* "_isNauCrew", */ "_destType", "_destSector", "_behavior"];
	private ["_wp", "_side", "_veh", "_distToLanding", "_closestStnPos"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
	_wp = [];
	_distToLanding = 300;  // critical!
	// Declarations:
	_side          = side (leader _grp);
	_veh           = vehicle (leader _grp);
	switch _grpType do {
		case "heliL": { _distToLanding = CSWR_heliLightAlt + 50 };
		case "heliM": { _distToLanding = CSWR_heliMediumAlt + 50 };
		case "heliH": { _distToLanding = CSWR_heliHeavyAlt + 50 };
	};
	_closestStnPos = [_side, /* _spwns, _grpType, */ _veh] call THY_fnc_CSWR_go_RTB_closest_station;
	// Escape:
	if ( isNull _grp || !alive _veh || !alive leader _grp || _closestStnPos isEqualTo [] ) exitWith {
		// Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugHeli && _closestStnPos isEqualTo [] ) then {
			systemChat format ["%1 HELICOPTER > A %2 helicopter COULDN'T execute the RTB (to rearm, refuel, repair, and heal) coz %2 has NO LAND helicopter SPAWN-POINTS available. It's out of combat.",
			CSWR_txtWarnHeader, _tag];
		};
	};
	// Forcing to return and not re-engage (only gunners if available):
	driver _veh setCombatBehaviour "CARELESS";
	// Creating the waypoint to the _closestStnPos:
	_wp = _grp addWaypoint [_closestStnPos, 0];
	_wp setWaypointCombatMode "GREEN";  // Hold fire, disengage, don't fire unless fired upon. Keep in formation.
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Debug:
	if ( CSWR_isOnDebug && alive _veh ) then {
		systemChat format ["%1 HELICOPTER > %2 '%3' returning to base (the closest side helipad, including invisible ones)!",
		CSWR_txtDebugHeader, _tag, _grp];
	};
	// If already in base:
	waitUntil {
		// If helicopter:
		if _isAirCrew then {
			// Breather for the next loop check:
			sleep 10;
			// Allows the group move to the next waypoint:
			isNull _grp || !alive _veh || _veh distance _closestStnPos < _distToLanding;
		// Otherwise:
		} else {
			// Reserved space for other types of vehicles.
		};
	};
	// If helicopter, execute the landing:
	if _isAirCrew then { [_hasServiceRTB, _spwns, _tag, _grpType, _grp, _veh, _isAirCrew, _destType, _destSector, _behavior] spawn THY_fnc_CSWR_go_RTB_heli_landing };
	// Return:
	true;
};


THY_fnc_CSWR_go_RTB_closest_station = {
	// This function verifies which service station for vehicles is nearest to the group.
	// Returns _closestStnPos. Array of a marker position: [x,y,0]. If something wrong, it returns an empty array.

	params["_side", /* "_sideStns", "_grpType", */ "_veh"];
	private["_validStns", "_closestStnPos", "_shortestDist", "_currentDist"];

	// Initial values:
	_validStns     = [];
	_closestStnPos = [];
	_shortestDist  = 0;
	_currentDist   = [];
	// Declarations:
	switch _side do {
		// For Helicopter:
		case BLUFOR:      { _validStns = CSWR_spwnsHeliLandBLU };
		case OPFOR:       { _validStns = CSWR_spwnsHeliLandOPF };
		case INDEPENDENT: { _validStns = CSWR_spwnsHeliLandIND };
		case CIVILIAN:    { _validStns = CSWR_spwnsHeliLandCIV };
	};
	// Escape:
	if ( _validStns isEqualTo [] || !alive _veh || !alive leader (group _veh) ) exitWith { _closestStnPos };  // Impossible doesn't exist any station for service coz if none this function wouldn't be called.
	// If only one station (spare solution):
	_closestStnPos = markerPos (_validStns # 0);
	// If more than 1 station:
	if ( count _validStns > 1 ) then {
		// Declarations:
		_shortestDist = _closestStnPos distanceSqr _veh;
		{  // forEach _validStns:
			_currentDist = (markerPos _x) distanceSqr _veh;
			// Check which _closestStnPos is closer:
			if ( _currentDist < _shortestDist ) then { 
				// New shortest distance:
				_shortestDist = _currentDist;
				// Position of the new closest station:
				_closestStnPos = markerPos _x;
			};
		} forEach _validStns;
	};
	// Return:
	_closestStnPos;
};


THY_fnc_CSWR_go_RTB_heli_landing = {
	// It's a new thread!
	// This function makes the helicopter to land in a safe place.
	// Returns nothing, but open a new thread.

	params ["_hasServiceRTB", "_spwns", "_tag", "_grpType", "_grp", "_veh", "_isAirCrew", "_destType", "_destSector", "_behavior"];
	//private [""];
	// Escape:
	if ( isNull _grp || !alive _veh ) exitWith {};
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Landing:
	_veh land "LAND";  // Important: helicopter will land in the closest real helipad available (Arma 3 native behavior).
	// Debug:
	if ( CSWR_isOnDebug && CSWR_isOnDebugHeli ) then { systemChat format ["%1 HELICOPTER > %2 '%3' landing...", CSWR_txtDebugHeader, _tag, _grp] };
	// Wait 'til the heli touch the ground;
	waitUntil {
		// Large breather to the next loop check:
		sleep 30;
		// Check the helicopter touch the ground:
		((getPosATL _veh) # 2) < 0.2 || !alive _veh || isNull _grp;
	};
	// Helicopter needs service:
	[_hasServiceRTB, _spwns, _tag, _grpType, _grp, _veh, false, _isAirCrew, false, _destType, _destSector, _behavior] spawn THY_fnc_CSWR_base_service_station;
	// Return:
	true;
};


THY_fnc_CSWR_go_ANYWHERE = {
	// It's a new thread!
	// This function sets the group/vehicle to move to any destination (sum of almost all other preset destinations), including exclusive enemy side destinations but excluding the
	// specialized (watch, hold, occupy) ones. It's a recursive loop.
	// Everything about setWaypointType: https://community.bistudio.com/wiki/Waypoints
	// Returns nothing, but open a new thread.

	params ["_spwns", "_dests", "_destSector", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isAmphib", "_isAirCrew", "_isNauCrew", "_hasServiceRTB", "_isRTB"];
	private ["_isHunting", "_areaToPass", "_wp"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Error handling:
	if ( _tag isEqualTo "CIV" ) exitWith {
		{ deleteVehicle _x } forEach units _grp;
		// Warning:
		systemChat format ["%1 MOVE ANYWHERE > Civilians CANNOT use '_move_ANY'. Please, fix it in 'fn_CSWR_2_population.sqf' file. For script integrity, the civilian group was deleted.",
		CSWR_txtWarnHeader]; sleep 5;
	};
	// Initial values:
	_isHunting = false;
	// Randomizes to where the group/vehicle goes into the specific destination-type:
	_areaToPass = markerPos (selectRandom _dests);
	// For Helicopter:
	if _isAirCrew then {
		// Declarations:
		_isHunting = selectRandom [true, false, false];  // 33% vs 66%
		// Check the waypoint altitude:
		_areaToPass = [_tag, _grp, _grpType, _areaToPass, _isAirCrew, _isHunting, _isRTB] call THY_fnc_CSWR_go_altitude;
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0];
	// Waypoint type:
	_wp setWaypointType "MOVE";
	// For People:
	if !_isVeh then {
		_wp setWaypointCompletionRadius (selectRandom [0,10,20,40]);
	} else {
		// For Regular Ground Vehicle and Amphibious:
		if ( !_isAirCrew && !_isNauCrew ) then {
			_wp setWaypointCompletionRadius (selectRandom [10,20,40]);
		} else {
			// For Helicopter:
			if _isAirCrew then {
				if !_isHunting then {
					_wp setWaypointCompletionRadius (selectRandom [100,200,300,400]);
				} else {
					// Update the _wp type:
					_wp setWaypointType "SAD";  // SAD = Seek And Destroy.
				};
			// For Nautical Vehicle:
			} else {
				_wp setWaypointCompletionRadius (selectRandom [10,20,30,40,50]);
			};
		};
	};
	// Making the waypoint guide the group/vehicle right now:
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destination:
	_isRTB = [_tag, _grp, _isVeh, /* _isAmphib, */ _isAirCrew, _isNauCrew, _isHunting, _hasServiceRTB] call THY_fnc_CSWR_go_next_condition;
	// Escape > Return to base (open a new thread):
	if _isRTB exitWith { [_hasServiceRTB, _spwns, _tag, _grpType, _grp, /* _isAmphib, */ _isAirCrew, /* _isNauCrew, */ "MOVE_ANY", _destSector, _behavior] spawn THY_fnc_CSWR_go_RTB; true /* Returning, ending this current thread */ };
	// Restart the movement:
	[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, _isRTB] spawn THY_fnc_CSWR_go_ANYWHERE;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_PUBLIC = {
	// It's a new thread!
	// This function sets the group/vehicle to move through PUBLIC destinations where civilians and soldiers can go, excluding the specialized (watch, hold, occupy) ones and
	// the waypoints restricted by other sides. It's a recursive loop.
	// Everything about setWaypointType: https://community.bistudio.com/wiki/Waypoints
	// Returns nothing, but open a new thread.
	
	params ["_spwns", "_dests", "_destSector", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isAmphib", "_isAirCrew", "_isNauCrew", "_hasServiceRTB", "_isRTB"];
	private ["_isHunting", "_areaToPass", "_wp"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
	_isHunting = false;
	// Randomizes to where the group/vehicle goes into the specific destination-type:
	_areaToPass = markerPos (selectRandom _dests);
	// For Helicopter:
	if _isAirCrew then {
		// Declarations:
		if ( _tag isNotEqualTo "CIV" ) then { _isHunting = selectRandom [true, false, false] };  // 33% vs 66%
		// Check the waypoint altitude:
		_areaToPass = [_tag, _grp, _grpType, _areaToPass, _isAirCrew, _isHunting, _isRTB] call THY_fnc_CSWR_go_altitude;
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0];
	// Waypoint type:
	_wp setWaypointType "MOVE";
	// For People:
	if !_isVeh then {
		_wp setWaypointCompletionRadius (selectRandom [0,10,20,40]);
	} else {
		// For Regular Ground Vehicle and Amphibious:
		if ( !_isAirCrew && !_isNauCrew ) then {
			_wp setWaypointCompletionRadius (selectRandom [10,20,40]);
		} else {
			// For Helicopter:
			if _isAirCrew then {
				if !_isHunting then {
					_wp setWaypointCompletionRadius (selectRandom [100,200,300,400]);
				} else {
					// Update the _wp type:
					_wp setWaypointType "SAD";  // SAD = Seek And Destroy.
				};
			// For Nautical Vehicle:
			} else {
				_wp setWaypointCompletionRadius (selectRandom [10,20,30,40,50]);
			};
		};
	};
	// Making the waypoint guide the group/vehicle right now:
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destination:
	_isRTB = [_tag, _grp, _isVeh, /* _isAmphib, */ _isAirCrew, _isNauCrew, _isHunting, _hasServiceRTB] call THY_fnc_CSWR_go_next_condition;
	// Escape > Return to base (open a new thread):
	if _isRTB exitWith { [_hasServiceRTB, _spwns, _tag, _grpType, _grp, /* _isAmphib, */ _isAirCrew, /* _isNauCrew, */ "MOVE_PUBLIC", _destSector, _behavior] spawn THY_fnc_CSWR_go_RTB; true /* Returning, ending this current thread */ };
	// Restart the movement:
	[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, _isRTB] spawn THY_fnc_CSWR_go_dest_PUBLIC;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_RESTRICTED = {
	// It's a new thread!
	// This function sets the group/vehicle to move only through the exclusive side destinations, excluding public and specialized ones (watch, hold, occupy). It's a recursive loop.
	// Everything about setWaypointType: https://community.bistudio.com/wiki/Waypoints
	// Returns nothing, but open a new thread.
	
	params ["_spwns", "_dests", "_destSector", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isAmphib", "_isAirCrew", "_isNauCrew", "_hasServiceRTB", "_isRTB"];
	private ["_isHunting", "_areaToPass", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Error handling:
	if ( _tag isEqualTo "CIV" ) exitWith {
		// Warning:
		systemChat format ["%1 MOVE RESTRICTED > Civilians CANNOT use '_move_RESTRICTED'. A perfect choice for Civilians is '_move_PUBLIC', so fix it in 'fn_CSWR_2_population.sqf' file. And on Eden, make sure you have some '%2%3move%3public%3sectorletter%3anyNumber' markers available too. For now, this group was deleted.",
		CSWR_txtWarnHeader, CSWR_prefix, CSWR_spacer];
		// Delete:
		{ deleteVehicle _x } forEach units _grp; sleep 10;
	};
	// Initial values:
	_isHunting = false;
	// Randomizes to where the group/vehicle goes into the specific destination-type:
	_areaToPass = markerPos (selectRandom _dests);
	// For Helicopter:
	if _isAirCrew then { 
		// Declarations:
		_isHunting = selectRandom [true, false, false];  // 33% vs 66%
		// Check the waypoint altitude:
		_areaToPass = [_tag, _grp, _grpType, _areaToPass, _isAirCrew, _isHunting, _isRTB] call THY_fnc_CSWR_go_altitude;
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh, _isHunting] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0];
	// Waypoint type:
	_wp setWaypointType "MOVE";
	// For People:
	if !_isVeh then {
		_wp setWaypointCompletionRadius (selectRandom [0,10,20,40]);
	} else {
		// For Regular Ground Vehicle and Amphibious:
		if ( !_isAirCrew && !_isNauCrew ) then {
			_wp setWaypointCompletionRadius (selectRandom [10,20,40]);
		} else {
			// For Helicopter:
			if _isAirCrew then {
				if !_isHunting then {
					_wp setWaypointCompletionRadius (selectRandom [100,200,300,400]);
				} else {
					// Update the _wp type:
					_wp setWaypointType "SAD";  // SAD = Seek And Destroy.
				};
			// For Nautical Vehicle:
			} else {
				_wp setWaypointCompletionRadius (selectRandom [10,20,30,40,50]);
			};
		};
	};
	// Making the waypoint guide the group/vehicle right now:
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destination:
	_isRTB = [_tag, _grp, _isVeh, /* _isAmphib, */ _isAirCrew, _isNauCrew, _isHunting, _hasServiceRTB] call THY_fnc_CSWR_go_next_condition;
	// Escape > Return to base (open a new thread):
	if _isRTB exitWith { [_hasServiceRTB, _spwns, _tag, _grpType, _grp, /* _isAmphib, */ _isAirCrew, /* _isNauCrew, */ "MOVE_RESTRICTED", _destSector, _behavior] spawn THY_fnc_CSWR_go_RTB; true /* Returning, ending this current thread */ };
	// Restart the movement:
	[_spwns, _dests, _destSector, _tag, _grpType, _grp, _behavior, _isVeh, _isAmphib, _isAirCrew, _isNauCrew, _hasServiceRTB, _isRTB] spawn THY_fnc_CSWR_go_dest_RESTRICTED;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_WATCH = {
	// It's a new thread!
	// This function sets the group to move only through the high natural spots destinations and stay there for as long the mission runs, watching around quiet, perfect for snipers and marksmen groups. It's NOT a looping.
	// Returns nothing, but open a new thread.
	
	params ["_dests", "_tag", "_grpType", "_grp", "_behavior"];
	private ["_posWatcherATLAGL", "_posWatcherASL", "_objWatcher", "_mkrDebug", "_isGoodHeight", "_visual", "_bldg", "_spots", "_unit", "_isWildPos", "_tol", "_ctr", "_timeout", "_isCanceled", "_minHeight", "_mkr", "_grpId", "_posTargetAGL", "_posTargetASL", "_objTarget", "_tries", "_tryLimiter", "_disLimiterFromBldg", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith { true /* Return */ };
	// Error handling > If it's not a Sniper group:
	if ( _grpType isNotEqualTo "teamS" ) exitWith {
		// Deleting the units:
		{ deleteVehicle _x } forEach units _grp;
		// Warning:
		systemChat format ["%1 WATCH > A non-sniper-group tried to use the '_move_WATCH'. Please, fix it in 'fn_CSWR_2_population.sqf' file. For script integrity, the group was deleted.",
		CSWR_txtWarnHeader]; sleep 5;
		// Return:
		true;
	};
	// Error handling > If it's a civilian:
	if ( _tag isEqualTo "CIV" ) exitWith {
		// Deleting the units:
		{ deleteVehicle _x } forEach units _grp;
		// Warning:
		systemChat format ["%1 WATCH > Civilians CANNOT use Watch-Destinations. Please, fix it in 'fn_CSWR_2_population.sqf' file. For script integrity, the civilian group was deleted.",
		CSWR_txtWarnHeader]; sleep 5;
		// Return:
		true;
	};
	// Error handling > If sniper group got a vehicle:
	if ( !isNull (objectParent (leader _grp)) ) exitWith {
		// Warning:
		systemChat format ["%1 WATCH > Vehicles CANNOT use Watch-Destinations. Please, fix it! For script integrity, the vehicle and its crew were deleted.",
		CSWR_txtWarnHeader];
		// Deleting the vehicle:
		deleteVehicle vehicle (leader _grp);
		// Deleting the units:
		{ deleteVehicle _x } forEach units _grp;
		sleep 5;
		// Return:
		true;
	};
	// Initial values:
	_posWatcherATLAGL = [];
	_posWatcherASL = [];
	_objWatcher    = objNull;
	_mkrDebug      = "";  // Debug purposes.
	_isGoodHeight  = false;
	_visual        = 0;
	_bldg          = objNull;
	_spots         = [];
	_unit          = objNull;
	_isWildPos     = true;
	_tol           = 0;
	_ctr           = 0;
	_timeout       = 0;
	_isCanceled    = false;
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, false] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, false] call THY_fnc_CSWR_unit_behavior;
	// Declarations:
	_minHeight    = 20;  // over the target heigh.
	_mkr          = selectRandom _dests;
	_grpId        = netId _grp;  // string, Debug purposes.
	_posTargetAGL = markerPos _mkr;  // returns a AGL pos, so [x, y, 0], z is always 0
	_posTargetASL = AGLToASL _posTargetAGL;  // needed to create a simpleObject.
	_posTargetASL set [2, (_posTargetASL # 2) + 1];  // CRITICAL: Rising Z a bit from the ground, advising from BI forum's mentors.
	// Creating a generic asset on the map to provide a visual watching zone:
	_objTarget  = createSimpleObject ["Sign_Arrow_Large_F", _posTargetASL, true];  // false = global / true = local.
	// Hide the target if debug mode is OFF:
	if ( !CSWR_isOnDebug || !CSWR_isOnDebugWatch ) then { hideObjectGlobal _objTarget };  // Important: don't delete it becouse the setDir for gunner will be necessary.
	_tries              = 0;
	_tryLimiter         = 400;  // default 400 / Important: more than 400 to a deep search in rough terrain coz 300 doesn't work well in that case.
	_disLimiterFromBldg = 20;
	
	// STEP 1/2 > SEARCHING ------------------------------------------------------------------------------------------
	// Searching the watcher-group spot with good visibility to the position to overwatch:
	while { alive (leader _grp) && _tries <= _tryLimiter } do {
		// Watch Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
			// Message:
			["%1 WATCH > %2 '%3' Searching (nº %4/%5) a wild spot around the target zone '%6'...",
			CSWR_txtDebugHeader, _tag, _grp, _tries, _tryLimiter, _mkr] call BIS_fnc_error;
		};
		// Tries amount control:
		_tries = _tries + 1;
		// Try a random empty spot:
		_posWatcherATLAGL = [_posTargetAGL, CSWR_watchMkrRangeStart, CSWR_watchMkrRange, 3, 0, 0.8, 0] call BIS_fnc_findSafePos;  // returns 2D pos: [x,y]
		// Adding Z as 0 to make it a real ATL/AGL:
		_posWatcherATLAGL set [2, 0];
		// Converting to ASL:
		_posWatcherASL = ATLToASL _posWatcherATLAGL;
		// Rising only the ASL Z a bit from the ground to simulate exactly the unit eyes pos when laid down over there:
		_posWatcherASL set [2, (_posWatcherASL # 2) + 0.3];  // CRITICAL!
		// Escape > if there's road around the watcher spot, forget and search again:
		if ( count (_posWatcherATLAGL nearRoads 20) isNotEqualTo 0 ) then { sleep 0.33; continue };
		// Creating a generic asset on the map to provide the unit point-of-view to the watching zone:
		_objWatcher = createSimpleObject ["Sign_Arrow_Direction_F", _posWatcherASL, true];  // false = global / true = local.
		// Check if the selected spot is enough higher than the zone to watch:
		_isGoodHeight = getTerrainHeightASL _posWatcherASL > (getTerrainHeightASL _posTargetASL) + _minHeight;
		// Escape > If the spot's not high enough, jump to the next random spot:
		if !_isGoodHeight then { sleep 0.33; deleteVehicle _objWatcher; continue };
		// Escape > If between the spot pos and the target zone is blocked by terrain itself, abort:
		if ( terrainIntersectASL [_posWatcherASL, _posTargetASL] ) then { sleep 0.33; deleteVehicle _objWatcher; continue };
		// Watch Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then { 
			// Puts the arrow (obj-watcher) to point exactly to the obj-target direction:
			_objWatcher setDir (_objWatcher getDir _objTarget);
			// Show me all locations found on the map with visible markers:
			_mkrDebug = createMarker [("debug_" + _tag + _grpId + str _tries), _posWatcherATLAGL];
			_mkrDebug setMarkerType "hd_dot";
			_mkrDebug setMarkerAlpha 0.5;
			_mkrDebug setMarkerColor "ColorBlack";
			_mkrDebug setMarkerText "No visual";
		};
		// Check the visibility of 2 objects (0 = not visible, 0.2 = barely visible, 0.7 = visible, 1 = fully visible):
		_visual = [objNull, "VIEW"] checkVisibility [_posWatcherASL, _posTargetASL];  // CRITICAL: dont use "FIRE" to avoid vision blocked by plants/bushes.
		// Watch Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch && _visual > 0.2 ) then {
			switch _tag do {
				case "BLU": { _mkrDebug setMarkerColor "colorBLUFOR" };
				case "OPF": { _mkrDebug setMarkerColor "colorOPFOR" };
				case "IND": { _mkrDebug setMarkerColor "colorIndependent" };
				//case "CIV": {}; // not appliable here!
			};
			_mkrDebug setMarkerText format ["Visual %2/1", _tag, (str _visual) select [0,4]];
			_mkrDebug setMarkerAlpha 1;
		};
		// If the spot has enough visibility of the target zone:
		if ( _visual >= 0.7 ) then {
			// Debug:
			if CSWR_isOnDebug then {
				// Message:
				systemChat format ["%1 WATCH > %2 %3 moving to a wild spot with visual %4/1.",
				CSWR_txtDebugHeader, _tag, _grp, (str _visual) select [0,4]];
			};
			// If debug is OFF:
			if ( !CSWR_isOnDebug || !CSWR_isOnDebugWatch ) then {
				// Hide the marker obj in watcher positions:
				hideObjectGlobal _objWatcher;
			};
			// Stop the searching:
			break;
		};
		// Breather:
		sleep 0.33;
	};  // While-loop ends.
	// If the group didn't find a good spot in the terrain:
	if ( _tries > _tryLimiter ) then {
		// Search for an acceptable building for watcher groups:
		_bldg = [_mkr, _grp, _tag, _posTargetASL] call THY_fnc_CSWR_WATCH_find_towers;
		// Declarating whether the unit position will be in the wild:
		_isWildPos = isNull _bldg;
		// If a building was found, update the group final position:
		if !_isWildPos then { _posWatcherATLAGL = getPosATL _bldg };
	};
	// Escape > if already tried spots in nature and urban, and nothing was found, abort:
	if ( _tries > _tryLimiter && isNull _bldg ) exitWith {
		// Delete the watcher group:
		{ deleteVehicle _x } forEach units _grp;
		// Warning:
		systemChat format ["%1 WATCH > The '%2' marker looks bad positioned for this kind of terrain. CONSIDER repositioning '%2' marker, or increase a bit 'CSWR_watchMkrRange' in 'fn_CSWR_1_management.sqf' file, or include one or more of those 'CSWR_acceptableTowersForWatch' assets around the watch-marker on Eden, respecting the range between %4m (min) and %5m (max). The group has been deleted.",
		CSWR_txtWarnHeader, _mkr, _tag, CSWR_watchMkrRangeStart, CSWR_watchMkrRange]; sleep 5;
		// Return:
		true;
	};
	
	// STEP 2/2 > GOING ----------------------------------------------------------------------------------------------
	// Creating the waypoint to set the watching position:
	_wp = _grp addWaypoint [ _posWatcherATLAGL, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "FULL";  // Important: because sometimes members get stuck in the map and badly prevent the leader to reach the watch position.
	_wp setWaypointCombatMode "GREEN";  // Important: forcing this for units when out of their watch location // hold fire, kill only if own position spotted.
	_grp setCurrentWaypoint _wp;
	// Dont speak anymore:
	{ _x setSpeaker "NoVoice" } forEach units _grp;
	// Wait the group gets closer, or doesn't exist anymore, or loses its waypoint:
	waitUntil {sleep 5; isNull _grp || leader _grp distance _posWatcherATLAGL < 100 || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
	// Escape > group doesn't exist anymore:
	if ( isNull _grp ) exitWith {
		// Watch Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
			// Message:
			systemChat format ["%1 WATCH > A few moments earlier, a %2 watcher group HAS BEEN KILLED (or deleted) BEFORE to reach 100m close to set their watching.",
			CSWR_txtDebugHeader, _tag];
		};
		// Return:
		true;
	};
	// Escape > check if the waypoint was lost (sometimes bugs or misclick by zeus can delete the waypoint):
	if ( (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" ) exitWith {
		// Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
			systemChat format ["%1 WATCH > %2 '%3' group lost the waypoint for unknown reason. New search soon.",
			CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
		};
		// Small cooldown to prevent crazy loopings:
		sleep 2;
		// Restart the first WATCH step:
		[_dests, _tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_WATCH;
		// Return:
		true;
	};
	// Straight on to the position:
	_grp setSpeedMode "FULL";  // Important: because sometimes members get stuck in the map and badly prevent the leader to reach the watch position.
	// From here, keep stealth to make sure the spot is clear:
	_grp setBehaviourStrong "COMBAT";  // Every unit in the group, and the group itself.
	// If the fire position is in the nature:
	if _isWildPos then {
		// Get prone:
		{ _x setUnitPos "DOWN" } forEach units _grp;
		// Wait the sniper group arrival in the area for to stay watching the marker direction:
		waitUntil { sleep 5; isNull _grp || leader _grp distance _posWatcherATLAGL < 3 || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
	// If in urban position:
	} else {
		// Wait the sniper group arrival in the area for to stay watching the marker direction:
		waitUntil { sleep 5; isNull _grp || leader _grp distance _posWatcherATLAGL < _disLimiterFromBldg || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
	};
	// Escape:
	if ( isNull _grp ) exitWith { true /* Return */ };
	// Make the arrival smooth:
	sleep 1;
	// If watcher group is going to a spot in the wild:
	if _isWildPos then {
		// Force the leader to stay exactly where is the obj marker (sometimes, in rough terrains, there is an unknown misposition between waypoint and obj marker):
		leader _grp setPosASL (getPosASL _objWatcher);
	// If watcher group is going to urban enviroment:
	} else {
		// Before to get in, check again (WIP) to see if the best spots keeps available:
		_spots = [_bldg, _objTarget] call THY_fnc_CSWR_WATCH_spots_selector;
		// If there are spots enough for the current group size:
		if ( count _spots >= {alive _x} count (units _grp) ) then {
			// Repeat the action for the number of times of the group members amount:
			for "_i" from 0 to ({alive _x} count (units _grp) - 1) do {
				// Internal declarations:
				_unit = (units _grp) # _i;
				// If it's the leader:
				if ( _unit isEqualTo (leader _grp) ) then {
					// Wait until the leader to be near enough to the building:
					waitUntil { sleep 5; isNull _grp || !alive _unit || incapacitatedState _unit isEqualTo "UNCONSCIOUS" || _unit distance _posWatcherATLAGL < _disLimiterFromBldg };
					// if the unit is NOT awake:
					if ( incapacitatedState _unit isEqualTo "UNCONSCIOUS" ) then {
						// Kill the unit to renew the group leadership:
						_unit setDamage 1;
					};
					// Leader opens all doors and windows of the building:
					for "_i" from 1 to (getNumber (configFile >> "CfgVehicles" >> typeOf _bldg >> "numberofdoors")) do {
						_bldg animate [ format ["door_%1_rot", _i], 1 ]; // 1 = Open
					};
				// If it's a ordinary member:
				} else {
					// Internal declarations:
					_tol     = 60;
					_timeout = time + _tol;
					// Wait the unit to be near enough to the building (or the timeout's gone, so in this case the unit will forced to be teleported):
					waitUntil {
						// Looping breather:
						sleep 5;
						// if the leader is already inside the building in position, and the unit WAS NOT FORCED ONCE yet to go there, do it:
						if ( !(leader _grp checkAIFeature "PATH") && _ctr isEqualTo 0 ) then {
							// Move to the building:
							_unit doMove _posWatcherATLAGL;
							// Updating the counter:
							_ctr = _ctr + 1;
						};
						// Countdown:
						_tol = _tol - 5;
						// Watch Debug:
						if ( CSWR_isOnDebug && CSWR_isOnDebugWatch && _tol > 0 && _tol <= 40 ) then {
							// Message:
							systemChat format ["%1 WATCH > %2 '%3' mate has %4s before to be forced to get in the building.",
							CSWR_txtDebugHeader, _tag, _grp, _tol];
						};
						// Conditions:
						isNull _grp || !alive _unit || incapacitatedState _unit isEqualTo "UNCONSCIOUS" || _unit distance _posWatcherATLAGL < _disLimiterFromBldg || time > _timeout };
					// if the unit is NOT awake:
					if ( incapacitatedState _unit isEqualTo "UNCONSCIOUS" ) then {
						// Kill the unit to sniper goes on:
						_unit setDamage 1;
					};
				};
				// Escape:
				if ( isNull _grp ) exitWith { true /* Return */ };
				// Force the unit to stop:
				doStop _unit;
				// wait a bit until the unit stops completely:
				sleep 1;
				// Teleport the unit to their spot inside the building:
				_unit setPosATL (_spots # _i # 2);
				// Reset the unit body movement:
				_unit setDir (_unit getDir _objTarget);  // not need remoteexec here coz this unit is always local for server.
				// Stay in position:
				_unit disableAI "PATH";
				// Force to get up:
				_unit setUnitPos "UP";
			};
		// Otherwise, if there is NO enough spots for the current group size:
		} else {
			// Watch Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
				// Message:
				systemChat format ["%1 WATCH > The building (%2) of %3 '%4' group has NO SPOTS available anymore. New search soon.",
				CSWR_txtDebugHeader, typeOf _bldg, _tag, _grp]; sleep 1;
			};
			// Restart the first WATCH step:
			[_dests, _tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_WATCH;
			// Update the flag:
			_isCanceled = true;
		};
	};
	// Escape:
	if _isCanceled exitWith { true /* Returning */ };
	// Go to the next WATCH stage:
	[_grp, _posTargetAGL, _objTarget, _tag, _isWildPos] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_spots_selector = {
	// This function counts how much spots are available in a specific building. Before this fnc to be called, CSWR made sure the building brings spot(s).
	// Returns _spots: list of positions.

	params ["_bldg", "_objTarget"];
	private ["_spots"];

	// Escape:
		// reserved space.
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Listing all spots found (sorted in reverse):
	/*
		// My Solution (slower):
		_spots = [_bldg] call BIS_fnc_buildingPositions;
		// Take each spot ([x,y,z]) and its Z axis and sort them by highest to lower (watcher group will occupy always the highest position in a building):
		_spots = [_spots, [], {_x # 2}, "DESCEND"] call BIS_fnc_sortBy;
		// Select only the spots of the building end closer to the object-target:
		_spots = _spots select { _x distance _objTarget < (_bldg distance _objTarget) };
	*/

	// Pirremgi solution (faster):
		// buildingPos -1 means to bring all building positions.
		// Explanation below about that '1/': That's because I'm using the same sort command for highest spot, and not for the nearest 2D distance. '1/x' is higher when x has a shorter distance, and reciprocally. The two levels (Z, then 1/ (2D distance)) are consistent with descending sort.
		_spots = (_bldg buildingPos -1) apply { [_x # 2, 1 / (_x distance2D _objTarget), _x] };  // [spot height, spot distance to the target, spot position]
		_spots sort false;  // false = descending sorted.

	// WIP - Check if there is someone in the position before send the _spots as available spots.
	// Return:
	_spots;
};


THY_fnc_CSWR_WATCH_check_building_before_to_go = {
	// This function selects a random option from CSWR_acceptableTowersForWatch already found around the selected marker, and make sure that selected building has spots with no walls between the sniper position inside and the target-zone.
	// Return _bldg: object.

	params ["_bldg", "_bldgsByMkr", "_objTarget", "_grp"];
	private ["_spots", "_ctr"];

	// Escape:
		// reserved space.
	// Initial values:
	_spots = [];
	_ctr   = 0;
	// Declarations:
		// reserved space.
	// Check until the building is defined with no more than 10 tries:
	while { isNull _bldg && _ctr <= 10 } do {
		// Counting the try:
		_ctr = _ctr + 1;
		// Pick up one building randomly:
		_bldg = selectRandom _bldgsByMkr;
		// Check the quality of each building spots:
		// Important: without this check, the group take a risk to arrive in the building and to notice that the highest building positions has no clear visual to the target.
		_spots = [_bldg, _objTarget] call THY_fnc_CSWR_WATCH_spots_selector;
		// If the building has enough spots for the whole watcher-group, stop the loop:
		if ( count _spots >= {alive _x} count (units _grp) ) then { break } else { _bldg = objNull };
		// CPU Breather in cause new loop:
		sleep 3;
	};  // While-loop ends.
	// Return:
	_bldg;
};


THY_fnc_CSWR_WATCH_find_towers = {
	// This function checks what buildings are available around a specific watch-marker range and selects one of them to be used for the watcher-group. Similar function: THY_fnc_CSWR_OCCUPY_find_buildings_by_grp.
	// Return _bldg: object.

	params ["_mkr", "_grp", "_tag", "_posTargetASL"];
	private ["_bldg", "_bldgsByMkr"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_bldg = objNull;
	// Declarations:
		// Reserved space;
	
	// STEP 1/2: find the buildings ----------------------------------------------------------------------------------
	_bldgsByMkr = nearestObjects [[markerPos _mkr # 0, markerPos _mkr # 1, 0], ["HOUSE", "BUILDING"], CSWR_watchMkrRange] select {
		// If the building is one of the acceptable ones:
		typeOf _x in CSWR_acceptableTowersForWatch &&
		// and the building is not so close to the target:
		_x distance2D (markerPos _mkr) >= CSWR_watchMkrRangeStart &&
		// and the building is not invisible:
		!isObjectHidden _x &&
		// and the building ground is higher than the target ground (Xm artificially lower):
		getTerrainHeightASL (getPosASL _x) > (getTerrainHeightASL _posTargetASL) - 2 &&
		// and the building has enough internal spots to the watcher group:
		count ([_x] call BIS_fnc_buildingPositions) >= {alive _x} count (units _grp);
	};
	// Escape > No building was found, abort:
	If ( _bldgsByMkr isEqualTo [] ) exitWith { _bldg /* Returning */ };
	
	// STEP 2/2: check the spot quality ------------------------------------------------------------------------------
	_bldg = [_bldg, _bldgsByMkr, _objTarget, _grp] call THY_fnc_CSWR_WATCH_check_building_before_to_go;
	// Debug:
	if CSWR_isOnDebug then {
		// If a building was found:
		if ( !isNull _bldg ) then {
			// Message:
			systemChat format ["%1 WATCH > %2 '%3' going to 1 of %4 building(s) found.",
			CSWR_txtDebugHeader, _tag, _grp, count _bldgsByMkr];
			// Watch debug only:
			if CSWR_isOnDebugWatch then {
				// Message:
				systemChat format ["> Chosen building: %1 / Loc: %2",
				typeOf _bldg, getPosATL _bldg];
			};
			// Reading breather:
			sleep 2;
		// Otherwise, if no building met the features needed:
		} else {
			// Watch debug only:
			if CSWR_isOnDebugWatch then {
				// Message:
				systemChat format ["%1 WATCH > %2 '%3' didn't find any building with spot not blocked by walls.",
				CSWR_txtDebugHeader, _tag, _grp, count _bldgsByMkr]; sleep 1;
			};
		};
	};
	// Return:
	_bldg;
};


THY_fnc_CSWR_WATCH_doWatching = {
	// It's a new thread!
	// This function organizes the sniper/marksman group during the overwatching. It's a recursive loop.
	// Returns nothing, but open a new thread.

	params ["_grp", "_posTargetAGL", "_objTarget", "_tag", "_isWildPos"];
	private ["_targets", "_dangerClose"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_targets = [];
	// Declarations:
	_dangerClose = 50;  // used to spotter controls the threats around the group position, and for god's sniper eyes in the target zone.
	
	// STEP 1/4: RESETING --------------------------------------------------------------------------------------------
	{
		// If in the nature:
		if _isWildPos then {
			_x enableAI "PATH";
			_x setUnitPos "DOWN";
			_x doFollow (leader _grp);
		// If in a building:
		} else {
			_x setUnitPos "UP";
		};
	} forEach units _grp;  // reset the movement.
	
	// Force awareness on group and its units:
	_grp setBehaviourStrong "AWARE";
	{  // forEach units _grp:
		// If member is the SNIPER:
		if ( _x isEqualTo (leader _grp) ) then {
			// Force the unit to stay straight to the target zone:
			_x setDir (_x getDir _posTargetAGL);
			// Better formation for sniper group during overwatch:
			_grp setFormation "DIAMOND";
			// Fixing the formation direction:
			_grp setFormDir (getDir _x);
			// Forcing this approach:
			_x setUnitCombatMode "YELLOW";  // fire at will, keep formation.
			// Leader uses rifle:
			_x selectWeapon (primaryWeapon _x);
			// Animation breather:
			sleep 2;
			// Stay focus on the target-area:
			_x doWatch _posTargetAGL;
		// If member is the SPOTTER:
		} else {
			// Wait the spotter get their position or just stop to move:
			waitUntil { sleep 3; speed _x isEqualTo 0 || !alive _x };
			// Force the unit to stay straight to the target zone:
			_x setDir (_x getDir _objTarget);
			// Forcing this approach:
			_x setUnitCombatMode "GREEN";  // Hold fire.
			// Spotter uses binoculars:
			_x selectWeapon (binocular _x);
			// Animation breather:
			sleep 2;
			// Stay focus on the target-area:
			_x doWatch _posTargetAGL;
		};
		// Make it smooth:
		sleep 0.5;
		// Stay in position:
		_x disableAI "PATH";
		// Watch Debug:
		if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
			// Message:
			["%1 WATCH > %2 '%3' unit RESETED: isLeader '%8' / behaviour '%5' / unitCombatMode '%4' / elevation %6m / pos fixed '%7' / skill overall: %9/1 / Distance target zone: %11m / hasTarget '%10'",
			CSWR_txtDebugHeader,
			_tag, 
			str _x, 
			unitCombatMode _x, 
			behaviour _x, 
			round (getTerrainHeightASL (getPosASL _x)), 
			!(_x checkAIFeature "PATH"), 
			(_x isEqualTo (leader _grp)), 
			(str (_x skillFinal "general")) select [0,4], 
			!isNull (getAttackTarget _x), 
			round (_x distance _posTargetAGL)] call BIS_fnc_error; sleep 1;
		};
	} forEach units _grp;
	
	// STEP 2/4: SEEKING TARGETS -------------------------------------------------------------------------------------
	// Debug:
	if CSWR_isOnDebug then {
		if _isWildPos then {
			// Wild position message:
			systemChat format ["%1 WATCH > %2 watch-leader in WILD pos and '%3'!",
			CSWR_txtDebugHeader, _tag, behaviour (leader _grp)];
		} else {
			// Urban position message:
			systemChat format ["%1 WATCH > %2 watch-leader in URBAN pos and '%3'!",
			CSWR_txtDebugHeader, _tag, behaviour (leader _grp)];
		};
		// Reading breather:
		sleep 1;
	};
	// Seek looping:
	while { behaviour (leader _grp) isNotEqualTo "COMBAT" } do {
		{  // forEach units _grp:
			// Watch Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
				// Message:
				["%1 WATCH > %2 '%3' unit: isLeader '%7' / behaviour '%5' / unitCombatMode '%4' / pos fixed '%6' / skill overall: %8/1 / Distance target zone: %10m / hasTarget '%9'",
				CSWR_txtDebugHeader, 
				_tag, 
				str _x, 
				unitCombatMode _x, 
				behaviour _x, 
				!(_x checkAIFeature "PATH"), 
				(_x isEqualTo (leader _grp)), 
				(str (_x skillFinal "general")) select [0,4], 
				!isNull (getAttackTarget _x), 
				round (_x distance _posTargetAGL)] call BIS_fnc_error;
				// Reading breather:
				sleep 1;
			};
			// Forcing the leader/Gunner:
			if ( _x isEqualTo (leader _grp) ) then {
				// leader behavior aware if they're feel safe:
				if ( behaviour _x isEqualTo "SAFE" ) then { _x setCombatBehaviour "AWARE" };
				// If a spotter is leader after leader death in aware stage:
				_x setUnitCombatMode "YELLOW";
				// If enemy around the target zone, watch-gunner will see:
				_targets = (_posTargetAGL nearEntities ["Man", _dangerClose]) select {
					// If it's a person:
					_x isKindOf "CAManBase" &&
					// If it's alive:
					alive _x &&
					// If it's NOT unconscious:
					incapacitatedState _x isNotEqualTo "UNCONSCIOUS" &&
					// If it's not the same side of the watcher group:
					side _x isNotEqualTo (side _grp) &&
					// If it's NOT civilian:
					side _x isNotEqualTo CIVILIAN;
				};
				// If there's target in target zone, and (watch group has a second operative member, or the watch-gunner has no a current target):
				if ( _targets isNotEqualTo [] && { count ((units _grp) select { alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" }) > 1 || isNull (getAttackTarget (leader _grp)) } ) then {
					// Watch-gunner will see a target:
					(leader _grp) lookAt (selectRandom _targets);
				};
			// If spotter:
			} else {
				// Check if spotter needs to help with fire:
				[_grp, _x, _dangerClose] call THY_fnc_CSWR_WATCH_spotter_fire_support;
			};
			// CPU breather:
			sleep 3;
		} forEach units _grp;
		// CPU breather before restart the SEEKING loop:
		sleep 2;
	};  // While-loop ONE ends.
	
	// STEP 3/4: ENGAGING --------------------------------------------------------------------------------------------
	// Debug:
	if CSWR_isOnDebug then {
		systemChat format ["%1 WATCH > %2 watcher-lead in position and '%3'!",
		CSWR_txtDebugHeader, _tag, behaviour (leader _grp)]; sleep 1;
	};
	// Combat looping:
	while { behaviour (leader _grp) isEqualTo "COMBAT" } do {
		{  // forEach units _grp;:
			// Error handling:
			if ( !alive _x || incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then { break };
			// Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugWatch ) then {
				["%1 WATCH > %2 '%3' unit: isLeader '%7' / behaviour '%5' / unitCombatMode '%4' / pos fixed '%6' / skill overall: %8/1 / Distance target zone: %10m / hasTarget '%9'",
				CSWR_txtDebugHeader, 
				_tag, 
				str _x, 
				unitCombatMode _x, 
				behaviour _x, 
				!(_x checkAIFeature "PATH"), 
				(_x isEqualTo (leader _grp)), 
				(str (_x skillFinal "general")) select [0,4], 
				!isNull (getAttackTarget _x), 
				round (_x distance _posTargetAGL)] call BIS_fnc_error; sleep 1;
			};
			// If enemy revealed is too close, unit can move again:
			if ( !isNull (getAttackTarget _x) && _x distance (getAttackTarget _x) < _dangerClose ) then { _x doFollow (leader _grp) };
			// Remember the leader (or new leader):
			if ( _x isEqualTo (leader _grp) ) then {
				_x setUnitCombatMode "YELLOW";
			// If spotter:
			} else {
				// Check if spotter needs to help with fire:
				[_grp, _x, _dangerClose] call THY_fnc_CSWR_WATCH_spotter_fire_support;
			};
			// Remind all:
			if _isWildPos then { _x setUnitPos "DOWN" };
			// CPU breather:
			sleep 1;
		} forEach units _grp;
		// CPU breather before restart the COMBAT loop:
		sleep 2;
	};  // While-loop TWO ends.
	
	// STEP 4/4: RESTART FROM STEP 1 ---------------------------------------------------------------------------------
	[_grp, _posTargetAGL, _objTarget, _tag, _isWildPos] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_spotter_fire_support = {
	// This function verifies if the unit members of sniper group must provide fire support for the group leader.
	// Returns nothing.

	params ["_grp", "_unit", "_dangerClose"];

	// Escape > if the unit is the leader (main gunner), abort:
	if ( _unit isEqualTo (leader _grp) ) exitWith {};
	// Escape > if spotter has a target, and target is too close the spotter group, abort:
	if ( !isNull (getAttackTarget _unit) && _unit distance (getAttackTarget _unit) < _dangerClose ) exitWith {
		// Spotter get combat mode:
		_unit setCombatBehaviour "COMBAT";
		// Spotter can fire at will:
		_unit setUnitCombatMode "YELLOW";
		// Even if injured, spotter take their primary weapon:
		_unit selectWeapon (primaryWeapon _unit);
	};

	// IN COMBAT:
	if ( incapacitatedState (leader _grp) isNotEqualTo "UNCONSCIOUS" && { behaviour (leader _grp) isEqualTo "COMBAT" || !isNull (getAttackTarget (leader _grp)) } ) then {
		// if spotter not injured:
		if ( lifeState _unit isNotEqualTo "INJURED" ) then {
			// Spotter stay aware:
			_unit setCombatBehaviour "AWARE";
			// Spotter NEVER will fire:
			_unit setUnitCombatMode "BLUE";  // If set "GREEN", sometimes the spotter will engage, even when long ranges if the target supress back.
			// Spotter uses only binoculars:
			_unit selectWeapon (binocular _unit);
		
		// if spotter injured:
		} else {
			// Spotter get combat mode:
			_unit setCombatBehaviour "COMBAT";
			// Spotter can fire at will:
			_unit setUnitCombatMode "YELLOW";
			// Even if injured, spotter take their primary weapon:
			_unit selectWeapon (primaryWeapon _unit);
		};

	// STANDBY:
	} else {
		// if leader is NOT unconscious, regardless the spotter get injured:
		if ( incapacitatedState (leader _grp) isNotEqualTo "UNCONSCIOUS" ) then {
			// Spotter stay aware:
			_unit setCombatBehaviour "AWARE";
			// If leader is NOT injured:
			if ( lifeState (leader _grp) isNotEqualTo "INJURED" ) then {
				// Spotter NEVER will fire:
				_unit setUnitCombatMode "BLUE";
			// If leader wounded:
			} else {
				// Spotter Hold fire, but fire if enemy knows the position:
				_unit setUnitCombatMode "GREEN";
			};
			// Spotter uses only binoculars:
			_unit selectWeapon (binocular _unit);
			// If spotter has a target, this target is not so close (because if so, spotter jump in action), and watcher leader doesn't:
			if ( !isNull (getAttackTarget _unit) && _unit distance (getAttackTarget _unit) >= _dangerClose && isNull (getAttackTarget (leader _grp)) ) then {
				// Gunner must engage the threat spotted by spotter:
				(leader _grp) doTarget (getAttackTarget _unit);
			};
		// if leader is unconscious:
		} else {
			// Spotter get combat mode:
			_unit setCombatBehaviour "COMBAT";
			// Spotter can fire at will:
			_unit setUnitCombatMode "YELLOW";
			// Even if injured, spotter take their primary weapon:
			_unit selectWeapon (primaryWeapon _unit);
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_OCCUPY = {
	// It's a new thread!
	// This function sets the group to move and occupy buildings in a certain marker range. It's a recursive loop.
	// Returns nothing, but open a new thread.
	
	params ["_dests", "_tag", "_grp", "_behavior"];
	private ["_bldgPos", "_wp", "_leadStuckCtr", "_getOutPos", "_disLimiterFromBldg", "_disLimiterFrndPlayer", "_disLimiterEnemy", "_wait", "_bldg"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Error handling > Vehicle cannot provide occupy:
	if ( !isNull (objectParent (leader _grp)) ) exitWith {
		// Warning:
		systemChat format ["%1 OCCUPY > A %2 vehicle was trying to OCCUPY a building, and vehicles cannot do this. Fix it in 'fn_CSWR_2_population.sqf' file. For script integrity, The vehicle and its crew were deleted!",
		CSWR_txtWarnHeader, _tag];
		// Deleting the vehicle:
		deleteVehicle vehicle (leader _grp);
		// Deleting the group:
		{ deleteVehicle _x } forEach units _grp;
		sleep 5;
	};
	// Error handling > No more than X units:
	if ( {alive _x} count (units _grp) > 6 ) exitWith {
		// Warning:
		systemChat format ["%1 OCCUPY > %2 '%3' group current size (%4) is too big for occupy movement integrity. Use groups composed from 1 to 6 units. For now, the group has been deleted.",
		CSWR_txtWarnHeader, _tag, _grp, {alive _x} count (units _grp)];
		// Deleting the group:
		{ deleteVehicle _x } forEach units _grp;
		sleep 5;
	};
	// Initial values:
	_bldgPos      = [];
	_wp           = [];
	_leadStuckCtr = 0;
	_getOutPos    = [];
	// Declarations:
	_disLimiterFromBldg   = 20;  // Distance to activate occupy functions validations to group leader. CRITICAL: less than 20 no occupy happens in some towers.
	_disLimiterFrndPlayer = 40;  // Distance to desactivate the AI teleport when player is around.
	_disLimiterEnemy      = 200;  // Distance to desactivate the AI teleport when enemies (including player) are around.
	_wait                 = 10;  // Avoid crazy loopings in entery occupy functions. Be careful.
	// Forcing unit basic setup to start the Occupy movement to prevent anomalies:
	{  // forEach of units _grp:
		_x enableAI "PATH";
		_x doFollow (leader _grp);
		sleep 0.25;
	} forEach units _grp;
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, false] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, false] call THY_fnc_CSWR_unit_behavior;
	// Selecting one building from probably many others found in that range:
	_bldg = [_dests, _grp, {alive _x} count (units _grp), _tag] call THY_fnc_CSWR_OCCUPY_find_buildings_by_grp;  // return object.

	// If there's a building:
	if ( !isNull _bldg ) then {
		// Building position:
		_bldgPos = getPosATL _bldg;
		// Delete old waypoints to prevent anomalies:
		//for "_i" from (count waypoints _grp - 1) to 1 step -1 do { deleteWaypoint [_grp, _i] };  // waypoints get immediately re-indexed when one gets deleted, delete them from last to first. Never delete index 0. Deleting index 0 causes oddities in group movement during the game logic. Index 0 of a unit is its spawn point or current point, so delete it brings weird movements or waypoint loses (by Larrow).
		// Go to the specific building:
		_wp = _grp addWaypoint [_bldgPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCombatMode "YELLOW";  // Open fire, but keep formation, trying to avoid those units stay far away from the group leader.
		//_wp setWaypointSpeed "NORMAL";  // (aug/2023 = v4.0.2 = fixed the bug where this line was replacing the original group speed defined in fn_CSWR_population file.
		_grp setCurrentWaypoint _wp;
		// Meanwhile the group leader is alive or their group exists:
		while { alive (leader _grp) || !isNull _grp } do {
			// if the leader is NOT awake:
			if ( incapacitatedState (leader _grp) isEqualTo "UNCONSCIOUS" ) then {
				// Kill the AI leader to renew the group leadership:
				(leader _grp) setDamage 1;
				// Stop the while-looping:
				break;
			};
			// If the leader notice (distance) the building doesn't exist anymore:
			if ( (leader _grp) distance _bldgPos < 80 ) then {  // distance should use building position because, in case the building doesnt exist, distance not works with objNull but works with position.
				// If destroyed but not part of the exception building list:
				if ( !alive _bldg && !(typeOf _bldg in CSWR_occupyAcceptableRuins) ) then {
					// Debug:
					if CSWR_isOnDebug then {
						systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.",
						CSWR_txtDebugHeader, _tag, _grp];
					};
					// Small cooldown to prevent crazy loopings:
					sleep 1;
					// Restart the first OCCUPY step:
					[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
					// Stop the while-looping:
					break;
				};
			};
			// if group leader is close enough to the chosen building:
			if ( (leader _grp) distance _bldgPos < _disLimiterFromBldg ) then {
				// When there, execute the occupy function:
				[_bldg, _bldgPos, _dests, _grp, _tag, _behavior, _disLimiterFromBldg, _disLimiterEnemy, _disLimiterFrndPlayer, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetIn;
				// Stop the while-looping:
				break;
			};
			// Check if the waypoint was lost (sometimes bugs or misclick by zeus can delete the waypoint):
			if ( (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" ) then {
				// Debug:
				if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
					systemChat format ["%1 OCCUPY > %2 '%3' group lost the waypoint for unknown reason. New search soon.",
					CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
				};
				// Small cooldown to prevent crazy loopings:
				sleep 2;
				// Restart the first OCCUPY step:
				[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
				// Stop the while-looping:
				break;
			};
			// Check if the leader is alive, is not stuck in their way to the building and not injured, not engaging, they're awake, give a timeout to restart the whole function again:
			if ( alive (leader _grp) && unitReady (leader _grp) && lifeState (leader _grp) isNotEqualTo "INJURED" && incapacitatedState (leader _grp) isNotEqualTo "SHOOTING" && incapacitatedState (leader _grp) isEqualTo "UNCONSCIOUS" ) then {
				_leadStuckCtr = _leadStuckCtr + 1;
				// Debug:
				if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
					systemChat format ["%1 OCCUPY > %2 '%3' leader looks stuck %4 time(s).",
					CSWR_txtDebugHeader, _tag, _grp, _leadStuckCtr];
				};
				// After timeout and leader looks stuck, teleport them to a free space:
				if ( _leadStuckCtr isEqualTo 5 ) then {
					if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
						systemChat format ["%1 OCCUPY > %2 '%3' leader apparently was stuck, but now he's free.",
						CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
					};
					// Find pos min 10m (_disLimiterFromBldg) from (leader _grp) but not further 20m, not closer 4m to other obj, not in water, max gradient 0.7, not on shoreline:
					_getOutPos = [(leader _grp), 10, 12, 4, 0, 0.7, 0] call BIS_fnc_findSafePos;
					// Teleport to the safe position out:
					(leader _grp) setPosATL [_getOutPos # 0, _getOutPos # 1, 0];
					// Destroying the position just in case:
					_getOutPos = nil;
					// Restart the first OCCUPY step:
					[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
					// Stop the while-looping:
					break;
				};
			};
			// Breather to avoid crazy loops:
			sleep _wait;
		};  // While-loop ends.
	// If a building is NOT found:
	} else {
		// Delete the group:
		//{ deleteVehicle _x } forEach units _grp;  // Dont delete the group coz maybe all buildings are destroyed during the game.
		// Warning:
		systemChat format ["%1 OCCUPY > A %2 OCCUPY marker looks not close enough to buildins, or the group size doesn't fit in the buildings, or all buildings around are destroyed, or the marker has no a good range configured in fn_CSWR_1_management.sqf ('CSWR_occupyMkrRange'). A %2 group will stand still in its current position.",
		CSWR_txtWarnHeader, _tag];
		// Breather:
		sleep _wait;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_find_buildings_by_grp = {
	// This function checks what buildings are available around a specific occupy-marker range and selects one of them to be used for the occupier-group. Similar function: THY_fnc_CSWR_WATCH_find_towers.
	// Return _bldg: object.

	params ["_dests", "_grp", "_grpSize", "_tag"];
	private ["_bldgsAvailable", "_bldg", "_bldgsByMkr", "_bldgsToCheck", "_spots", "_isWaterSurrounding"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_bldgsAvailable     = [];
	_bldg               = objNull;
	_bldgsByMkr         = [];
	_bldgsToCheck       = [];
	_spots              = [];
	_isWaterSurrounding = nil;
	// Declarations:
		// Reserved space;
	// FIRST STEP: find the buildings for marker:
	{  // forEach _dests:
		_bldgsByMkr = nearestObjects [[markerPos _x # 0, markerPos _x # 1, 0], ["HOUSE", "BUILDING"], CSWR_occupyMkrRange];  // Important: assets from 'building' category generally has no ALIVE option, so they cant be destroy in-game. 'building' category is here to be mapped to check further if one of them is in the CSWR_occupyAcceptableRuins list as exception, because basically no assets that cannot be destroy get in the final list, except those ones in CSWR_occupyAcceptableRuins.
		//_bldgsByMkr = [(markerPos _x) # 0, (markerPos _x) # 1] nearObjects ["HOUSE", CSWR_occupyMkrRange];  // BACKUP ONLY.
		_bldgsToCheck append _bldgsByMkr;
	} forEach _dests;
	// SECOND STEP: among the buildings found, select only those specific ones:
	{  // forEach _bldgsToCheck:
		// If the building is NOT an ignored one, NOT got its position as ignored also, it's not invisible, and it wasn't destroyed (or it's an acceptible ruin):
		if ( !(typeOf _x in CSWR_occupyIgnoredBuildings) && !(getPosATL _x in CSWR_occupyIgnoredPositions) && !isObjectHidden _x && { alive _x || typeOf _x in CSWR_occupyAcceptableRuins } ) then {
			// Check how much spot the building got and if it fits the group size:
			_spots = [_x, _grpSize] call BIS_fnc_buildingPositions;
			if ( count _spots >= _grpSize ) then { 
				// Check if the building is over water:
				_isWaterSurrounding = surfaceIsWater (getPosATL _x);  // specialy ignoring Tanoa's riverside houses issue.
				// If not over the water or the building is an exception, do it:
				if ( !_isWaterSurrounding || typeOf _x in CSWR_occupyAcceptableRuins ) then {
					// Adding the building to the final options for side groups executing occupy-movement:
					_bldgsAvailable pushBackUnique _x;
				};
			};
		};
	} forEach _bldgsToCheck;
	// Error handling:
	If ( _bldgsAvailable isEqualTo [] ) exitWith {
		// Debug:
		if CSWR_isOnDebug then {
			systemChat format ["%1 OCCUPY > %2 '%3' has no buildings available.",
			CSWR_txtDebugHeader, _tag, _grp];
		};
		// Return:
		_bldg;
	};
	// From all of them, select one:
	_bldg = selectRandom _bldgsAvailable;
	// When debug mode on:
	if CSWR_isOnDebug then {
		systemChat format ["%1 OCCUPY > %2 '%3' going to 1 of %4 building(s) found.",
		CSWR_txtDebugHeader, _tag, _grp, count _bldgsAvailable];
	};
	if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
		if ( alive _bldg || typeOf _bldg in CSWR_occupyAcceptableRuins ) then {
			["%1 OCCUPY > Chosen building: %2 / Loc: %3",
			CSWR_txtDebugHeader, typeOf _bldg, getPosATL _bldg] call BIS_fnc_error; sleep 1;
		};
	};
	// Return:
	_bldg;
};


THY_fnc_CSWR_OCCUPY_remove_unit_from_group = {
	// It's a new thread!
	// This function removes a specific unit left behind, and set them to a new group that's abled to execute also the occupy-movement by itself.
	// Returns nothing, but open a new thread.

	params ["_dests", "_unit", "_tag", "_behavior", "_wait"];
	private ["_newGrp"];

	// Debug:
	if CSWR_isOnDebug then {
		systemChat format ["%1 OCCUPY > A unit of %2 '%3' has been removed as member to preserve the group movement.",
		CSWR_txtDebugHeader, _tag, group _unit]; sleep 1;
	};
	// Create the new group:
	_newGrp = createGroup [side _unit, true];  // [side, deleteWhenEmpty]
	// Add the removed unit to the new group:
	[_unit] joinSilent _newGrp;
	// Cooldown to prevent crazy loopings:
	sleep _wait;
	// Restart the first OCCUPY step:
	[_dests, _tag, _newGrp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_nearEnemies = {
	// This function searches for enemies around a specific unit.
	// Returns _isEnemyNear: bool.

	params ["_unit", "_disLimiterEnemy"];
	private ["_isEnemyNear", "_nearEnemies"];

	// WIP IMPORTANT: the command findNearestEnemy is not working in my tests Feb/2023. Even in Wiki has mistakes with the examples:  https://forums.bohemia.net/forums/topic/241587-solved-findnearestenemy-command-looks-not-okay-for-me-a-noob/
	// Initial values:
	_isEnemyNear = false;
	// Searching:
	_nearEnemies = (_unit nearEntities ["Man", _disLimiterEnemy]) select { _x isKindOf "CAManBase" && side _unit isNotEqualTo (side _x) && side _unit isNotEqualTo CIVILIAN && alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" };
	if ( _nearEnemies isNotEqualTo [] ) then { _isEnemyNear = true };
	// Return:
	_isEnemyNear;
};


THY_fnc_CSWR_OCCUPY_unitBodyPosition_getIn = {
	// This function prepares the unit basic settings to stay in a building during the occupy movement.
	// Returns nothing.

	params ["_unit", "_compass", "_isRuin"];
	// After the arrival on spot, it removes the man's movement capacible:
	_unit disableAI "PATH";
	// Set the direction:
	_unit setDir (selectRandom _compass);
	// If unit inside a ruin, so stay on knees to get low their profile:
	if _isRuin then { _unit setUnitPos "MIDDLE" };
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_unitBodyPosition_getOut = {
	// This function prepares the unit basic settings to leave a building after the occupy movement.
	// Returns nothing.

	params ["_unit"];
	// Stand up:
	_unit setUnitPos "UP";
	// Animation breather:
	sleep 0.5;
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_doGetIn = {
	// It's a new thread!
	// This function will try to make the group get inside the chosen building to occupy it.
	// Returns nothing, but open a new thread.

	params ["_bldg", "_bldgPos", "_dests", "_grp", "_tag", "_behavior", "_disLimiterFromBldg", "_disLimiterEnemy", "_disLimiterFrndPlayer", "_wait"];
	private ["_spots", "_spot", /* "_isFrndPlayerNear", */ "_isEnemyNear", "_timeOutToUnit", "_canTeleport", "_alreadySheltered", "_orderCtr", "_t", "_grpSize", "_compass", "_isRuin"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_spots            = [];
	_spot             = [];
	//_isFrndPlayerNear = false;
	_isEnemyNear      = false;
	_timeOutToUnit    = nil;
	_canTeleport      = true;
	_alreadySheltered = [];
	_orderCtr     = nil;
	_t             = 0;
	// Declarations:
	_grpSize = {alive _x} count (units _grp);
	_compass = [0, 45, 90, 135, 180, 225, 270, 315];  // Better final-result than 'random 360'.
	_isRuin  = typeOf _bldg in CSWR_occupyAcceptableRuins;
	// If there's a building:
	if ( !isNull _bldg ) then {
		{  // forEach _grp members:
			// Declarations:
			_orderCtr  = 0;
			_timeOutToUnit = 15;  // secs to the unit get-in the building before be ignored.
			// Meanwhile the unit is alive or their group to exist:
			while { alive _x || !isNull _grp } do {
				// If the unit is the leader:
				if ( _x isEqualTo (leader _grp) ) then {
					// if the leader is NOT awake:
					if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then {
						// Kill the AI leader to renew the group leadership:
						_x setDamage 1;
						// Stop the while-looping:
						break;
					};
					// if group leader is close enough to the chosen building:
					if ( _x distance _bldg < _disLimiterFromBldg + 2 ) then {
						// This time take all spots available in the building:
						_spots = [_bldg] call BIS_fnc_buildingPositions;
						// For script integrity, check again right after the arrival if there are enough spots to the whole group:
						if ( count _spots >= _grpSize ) then {
							// if the building is free to be occupied:
							if ( !(_bldgPos in CSWR_occupyIgnoredPositions) ) then {
								// If the building wasn't completely destroyed or it's an exception (like a specific ruin):
								if ( alive _bldg || _isRuin ) then {
									// Flag the building for other groups that this building is ours:
									CSWR_occupyIgnoredPositions pushBack _bldgPos;
									// Update the global variable:
									publicVariable "CSWR_occupyIgnoredPositions";
									// Select an available spot:
									_spot = selectRandom _spots;
								// If the building doesn't exist anymore:
								} else {
									// Debug:
									if CSWR_isOnDebug then {
										systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.",
										CSWR_txtDebugHeader, _tag, _grp]; sleep 1 };
									// Small cooldown to prevent crazy loopings:
									sleep 1;
									// Restart the first OCCUPY step:
									[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
									// Stop the while-looping:
									break;
								};
							// if the building is already occupied for someone else:
							} else {
								// Debug:
								if CSWR_isOnDebug then {
									systemChat format ["%1 OCCUPY > %2 '%3' building is already occupied!",
									CSWR_txtDebugHeader, _tag, _grp]; sleep 1 };
								// Small cooldown to prevent crazy loopings:
								sleep 3;
								// Restart the first OCCUPY step:
								[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
								// Stop the while-looping:
								break;
							};
							// Check if there are friendly players around:
							//_isFrndPlayerNear = [_x, "friendlyPlayers", _disLimiterFrndPlayer] call THY_fnc_CSWR_is_playerNear;  // It doesn't needed anymore because when the building is a tower, the AI has too much difficult to get in without teleportation. So avoid to use traditional/natural get-in moviment.
							// Check if there are enemies around:
							_isEnemyNear = [_x, _disLimiterEnemy] call THY_fnc_CSWR_OCCUPY_nearEnemies;
							// If an enemy is NOT around, and leader is NOT engaging:
							if ( /* !_isFrndPlayerNear &&  */!_isEnemyNear && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
								// flags:
								_canTeleport = true;
								// force the leader to stop and prevent them to died when they are teleported to the new position:
								doStop _x;
								// wait a bit until the leader stops completely:
								sleep 1;
								// Teleport the unit to their spot inside the building:
								_x setPosATL _spot;
								// Configure the unit body position inside the building:
								[_x, _compass, _isRuin] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getIn;
								// Wait to confirm the unit still alive before remove the current spot position from the list of spots available:
								sleep 1;
								// Delete that occupied spot to avoid more than one man there:
								if ( alive _x ) then { _spots deleteAt (_spots find _spot) };
								// Report the unit is sheltered:
								_alreadySheltered pushBackUnique _x;
								// Stop the while-looping:
								break;
							// Otherwise, if an enemy around, or leader is engaging:
							} else {
								// Debug:
								if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
									systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-in without teleport.",
									CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
								};
								// flag:
								_canTeleport = false;
								// Move to spot:
								_x doMove _spot;
								// Delete that occupied spot to avoid more than one man there:
								if ( alive _x ) then { _spots deleteAt (_spots find _spot) };
								// Wait the leader arrives inside the building or be killed:
								waitUntil { sleep 1; moveToCompleted _x || moveToFailed _x || !alive _x };
								// Configure the unit body position inside the building:
								[_x, _compass, _isRuin] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getIn;
								// Report the leader is sheltered:
								_alreadySheltered pushBackUnique _x;
								// Stop the while-loop:
								break;
							};
						// If has no spots for the whole group:
						} else {
							// Debug:
							if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
								systemChat format ["%1 %2 > OCCUPY > Failed: '%3' has %4 spot(s) to %5 men.",
								CSWR_txtDebugHeader, _tag, typeOf _bldg, count _spots, {alive _x} count (units _grp)];
							};
							// Cooldown to prevent crazy loopings:
							sleep _wait;
							// Restart the first OCCUPY step:
							[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
							// Stop the while-loop:
							break;
						};
					};
					// CPU breather if leader will repeat this loop:
					sleep _wait;
				// If the unit is NOT group leader:
				} else {
					// if the leader is already inside the building in position, and the unit WAS NOT FORCED ONCE yet to go there, do it:
					if ( !(leader _grp checkAIFeature "PATH") && _orderCtr < 1 ) then {
						// Move to the building:
						_x doMove _bldgPos;
						// Updating the counter:
						_orderCtr = _orderCtr + 1;
					};
					// if the unit is unconscious:
					if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then {
						// Debug:
						if CSWR_isOnDebug then {
							systemChat format ["%1 > OCCUPY > An incapacitated %2 unit has been killed to preserve the group mobility.",
							CSWR_txtDebugHeader, _tag];
						};
						// Kill the AI unit:
						_x setDamage 1;
						// Stop the while-looping:
						break;
					};
					// if the unit is too far away from the leader:
					if ( _x distance leader _grp > 120 ) then {
						// Remove the unit from the current group:
						[_dests, _x, _tag, _behavior, _wait] spawn THY_fnc_CSWR_OCCUPY_remove_unit_from_group;
						// Stop the while-looping:
						break;
					};
					// If the unit's leader is ready, and the unit is close enough the building, even if engaging, just go to inside:
					if ( !(leader _grp checkAIFeature "PATH") && _x distance _bldg < _disLimiterFromBldg + 2 ) then {
						// Select an available spot:
						_spot = selectRandom _spots;
						// If the group member can teleport, but NOT engaging:
						if ( _canTeleport && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
							// force the unit to stop and prevent them to died when they are teleported to the new position:
							doStop _x;
							// wait a bit until the unit stops completely:
							sleep 1;
							// Teleport the unit to their spot inside the building:
							_x setPosATL _spot;
						// If the group member CANNOT teleport:
						} else {
							// Move to spot:
							_x doMove _spot;
							// Wait the unit arrives inside the building or be killed:
							waitUntil { sleep 1; moveToCompleted _x || moveToFailed _x || !alive _x };
						};
						// If still alive (because it has a waitUntil case above):
						if ( alive _x ) then {
							// Configure the unit body position inside the building:
							[_x, _compass, _isRuin] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getIn;
							// Delete that occupied spot to avoid more than one man there:
							_spots deleteAt (_spots find _spot);
							// Report the unit is sheltered:
							_alreadySheltered pushBackUnique _x;
							// Stop the while-loop:
							break;
						};
					};
					// Timeout for script understand the unit is stuck around the building and leave they there until the leader leave the building again and forces the regrouping:
					if ( _timeOutToUnit isEqualTo 0 ) then { break };
					_timeOutToUnit = _timeOutToUnit - 1;
					if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy && !(leader _grp checkAIFeature "PATH") && _timeOutToUnit <= 10 ) then {
						systemChat format ["%1 OCCUPY > %2 '%3' unit should get-in: %4",
						CSWR_txtDebugHeader, _tag, _x, _timeOutToUnit];
					};
					sleep 1.5;
				};
				// If the unit or leader has no group anymore (anomaly), kill the former group member:
				if ( isNull (group _x) ) then {
					// Kill:
					_x setDamage 1;
					// Debug:
					if CSWR_isOnDebug then {
						systemChat format ["%1 OCCUPY > A %2 unit needed to be killed to preserve the game integrity (they lost the group ID).",
						CSWR_txtDebugHeader, _tag];
					};
					// Stop the while-looping:
					break;
				};
				// If the members is NOT close to the building, let's CPU breathes to the next distance checking:
				sleep 1;
			};  // while loop ends.
		} forEach units _grp;
		// If some unit stay ignored behind but still part of the group, order to regroup inside the building:
		{  // forEach of (units _grp) still alive, awake, and not already sheltered:
			// Select an available spot:
			_spot = selectRandom _spots;
			// Trying again to send the unit to a free spot:
			_x doMove _spot;
			// Don't do 'waitUntil moveToCompleted' coz the unit is already ignored and the intension here is try to send all ignored units outside to stay the leader along. (dont include as sheltered cause it's NOT guaranteed).
			// Delete that spot to avoid more than one man there:
			_spots deleteAt (_spots find _spot);
			// CPU breather:
			sleep 1;
		} forEach (units _grp select { alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" && !(_x in _alreadySheltered) });  // It's ok not apply disableAi PATH ;)
		// Check again the current group size in case the while-looping took too long:
		_grpSize = {alive _x} count (units _grp);
		// If the number of group members already sheltered is bigger than half current group size:
		if ( count _alreadySheltered > floor (_grpSize / 2) ) then {
			// Debug messages:
			if CSWR_isOnDebug then { 
				if ( count _alreadySheltered isEqualTo _grpSize ) then {
					systemChat format ["%1 OCCUPY > All %2 '%3' is in a building.",
					CSWR_txtDebugHeader, _tag, _grp];
				} else {
					systemChat format ["%1 OCCUPY > Most of the %2 '%3' is in a building.",
					CSWR_txtDebugHeader, _tag, _grp];
				};
				// Breather:
				sleep 1;
			};
			// Next planned move cooldown:
			_t = time + (selectRandom CSWR_destOccupyTakeabreak); waitUntil { if (!CSWR_isOnDebug && !CSWR_isOnDebugHold) then { sleep 60 } else { sleep 3 }; time > _t };
		// Otherwise:
		} else {
			// Debug:
			if CSWR_isOnDebug then {
				systemChat format ["%1 OCCUPY > %2 '%3' leader would rather move to another building.",
				CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
			};
		};
		// Starts the last stage of OCCUPY function:
		[_dests, _grp, _tag, _behavior, _disLimiterFromBldg, _disLimiterEnemy, _disLimiterFrndPlayer, _bldgPos, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetOut;
	// If a building is NOT found:
	} else {
		// Warning:
		systemChat format ["%1 %2 > OCCUPY > The building doesn't exist anymore. New search in %4 secs.",
		CSWR_txtWarnHeader, _tag, _grp, _wait]; sleep 1;
		// Restart the first OCCUPY step:
		[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_doGetOut = {
	// It's a new thread!
	// This function is the last stage of Occupy function where it removes the group from inside the occupied building.
	// Returns nothing, but open a new thread.

	params ["_dests", "_grp", "_tag", "_behavior", "_disLimiterFromBldg", "_disLimiterEnemy", "_disLimiterFrndPlayer", "_bldgPos", "_wait"];
	private ["_isFrndPlayerNear", "_isEnemyNear", "_getOutPos", "_canTeleport", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_isFrndPlayerNear = false;
	_isEnemyNear      = false;
	_getOutPos        = [];
	_canTeleport      = true;
	_wp               = [];
	// Delete the old waypoints to avoid waypoint bugs, even if Zeus accidently added waypoints:
	for "_i" from (count waypoints _grp - 1) to 1 step -1 do { deleteWaypoint [_grp, _i] };  // waypoints get immediately re-indexed when one gets deleted, delete them from last to first. Never delete index 0. Deleting index 0 causes oddities in group movement during the game logic. Index 0 of a unit is its spawn point or current point, so delete it brings weird movements or waypoint loses (by Larrow).
	{  // forEach _grp members:
		// Meanwhile the unit is alive or their group to exist:
		while { alive _x || !isNull _grp } do {
			// If the unit is the leader:
			if ( _x isEqualTo (leader _grp) ) then {
				// Check if there are friendly players around:
				_isFrndPlayerNear = [_x, "friendlyPlayers", _disLimiterFrndPlayer] call THY_fnc_CSWR_is_playerNear;
				// Check if there are enemies around:
				_isEnemyNear = [_x, _disLimiterEnemy] call THY_fnc_CSWR_OCCUPY_nearEnemies;
				// if the leader is NOT awake:
				if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then {
					// Kill the AI leader to renew the group leadership:
					_x setDamage 1;
					// Stop the while-looping:
					break;
				};
				// If a friendly player NOT around, and enemy NOT around, and the leader is NOT engaging:
				if ( !_isFrndPlayerNear && !_isEnemyNear && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
					// flag:
					_canTeleport = true;
					// Find pos min 10m (_disLimiterFromBldg) from _x but not further 20m, not closer 4m to other object, not in water, max gradient 0.7, not on shoreline:
					_getOutPos = [_x, 10, 12, 4, 0, 0.7, 0] call BIS_fnc_findSafePos;
					// Configure the unit body position when leave the building:
					[_x] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getOut;
					// Teleport to the safe position out:
					_x setPosATL [_getOutPos # 0, _getOutPos # 1, 0];
					// Destroying the position just in case:
					_getOutPos = nil;  // WIP: BUG: dont know why, but sometimes the leader already got a new waypoint but right after to getout by teleportation from the building, he wants to stay in _getOutPos, stuck.
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Give back the movement hability to the unit, sending them to leader position:
					_x doMove (getPosATL _x);  // crucial after use doStop.
					// Force the unit stay out, doesn't going back into the old building:
					_wp = _grp addWaypoint [getPosATL _x, 0];
					_wp setWaypointType "MOVE";
					_grp setCurrentWaypoint _wp;
					// Stop the while-loop:
					break;
				// Otherwise, if a friendly player around, or enemy around, or leader engaging:
				} else {
					// Debug:
					if ( CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
						systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-out without teleport.",
						CSWR_txtDebugHeader, _tag, _grp]; sleep 1;
					};
					// flag:
					_canTeleport = false;
					// Configure the unit body position when leave the building:
					[_x] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getOut;
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Give back the movement hability to the unit, sending them to leader position:
					_x doMove (getPosATL _x);  // crucial after use doStop.
					// Stop the while-loop:
					break;
				};
				// CPU breather if leader will repeat this loop:
				sleep _wait;
			// If the unit is NOT group leader:
			} else {
				// If the leader is ready to get out the building, and the unit is NOT engaging:
				if ( leader _grp checkAIFeature "PATH" && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
					// Configure the unit body position when leave the building:
					[_x] call THY_fnc_CSWR_OCCUPY_unitBodyPosition_getOut;
					// If the group member can teleport:
					if _canTeleport then {
						// Teleport to the leader position:
						_x setPosATL (getPosATL (leader _grp));
					};
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Wait the unit react to the change:
					sleep 2;
					// Give back the movement hability to the unit, sending them to leader position:
					_x doFollow (leader _grp);  // crucial after use doStop.
					// Stop the while-loop:
					break;
				// If something wrong, wait a bit:
				} else { sleep 3 };
				// CPU breather if unit will repeat this loop:
				sleep 1;
			};
		};  // While-loop ends.
	} forEach units _grp;
	// Remove the current building from the occupied buildings list:
	CSWR_occupyIgnoredPositions deleteAt (CSWR_occupyIgnoredPositions find _bldgPos);
	// Update the global variable:
	publicVariable "CSWR_occupyIgnoredPositions";
	// Debug:
	if (CSWR_isOnDebug && CSWR_isOnDebugOccupy ) then {
		systemChat format ["%1 %2 > OCCUPY > %3 building(s) occupied currently.",
		CSWR_txtDebugHeader, _tag, count CSWR_occupyIgnoredPositions];
	};
	// Restart the first OCCUPY step:
	[_dests, _tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_HOLD = {
	// It's a new thread!
	// This function sets the group to arrive in a place and make it doesn't move to another place for a long time. It's a recursive loop.
	// Returns nothing, but open a new thread.
	
	params ["_dests", "_tag", "_grp", "_behavior", "_isVeh"];
	private ["_isVehTracked", "_bookingData", "_mkrToHold", "_isBooked", "_posHolder", "_wp", "_t", "_ctr", "_tryLimit", "_trackedVehTypes", "_vehType", "_veh", "_wpDisLimit", "_wait", "_waitForVeh"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Error handling > if it's a vehicle but for some reason the crew is out of the vehicle, abort:
	if ( _isVeh && isNull (objectParent (leader _grp)) ) exitWith {
		// Crew with no vehicle should join in a infantry group:
		[_tag, _grp, 1, 300, 3, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
	};
	// Initial values:
	_isVehTracked    = false;
	_bookingData     = [];
	_mkrToHold       = "";
	_isBooked        = false;
	_posHolder       = [];
	_wp              = [];
	_t            = 0;
	_ctr             = 0;
	_tryLimit      = 10;
	_trackedVehTypes = [];
	_vehType         = "";
	_veh             = objNull;
	// Declarations:
	_wpDisLimit = 20;  // Critical - from 19m, the risk of the vehicle doesn't reach the waypoint is too high.
	_wait       = 10;
	_waitForVeh = 0.25;
	// Check if it's a vehicle and which kind of them:
	if _isVeh then {
		_veh             = vehicle (leader _grp);
		_trackedVehTypes = ["Tank", "TrackedAPC"];
		_vehType         = (_veh call BIS_fnc_objectType) # 1;  // Returns like [0='vehicle', 1='Tank']
		// It's a tracked vehicle and not from CIV side:
		if ( _vehType in _trackedVehTypes && _tag isNotEqualTo "CIV" ) then { _isVehTracked = true };
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Debug:
	if ( CSWR_isOnDebug && CSWR_isOnDebugHold ) then {
		["%1 HOLD > %2 '%3' is a %4. %5",
		CSWR_txtDebugHeader,
		_tag,
		str _grp,
		if _isVeh then {"'"+_vehType+"'"} else {"group"},
		if _isVehTracked then {""} else {"Only tracked vehicles can take the center position of hold-markers."}] call BIS_fnc_error;
	};
	// BOOKING A HOLD MARKER:
	// if tracked vehicle:
	if _isVehTracked then { 
		// Try to booking a marker:
		_bookingData = ["BOOKING_HOLD", getPosATL (leader _grp), _tag, _dests, 5, _waitForVeh] call THY_fnc_CSWR_marker_booking;
		// Which marker to go:
		_mkrToHold   = _bookingData # 0;
		// Marker position:
		_posHolder   = _bookingData # 1;  // [x,y,z]
		// Is booked?
		_isBooked    = _bookingData # 2;
		// Debug:
		if ( CSWR_isOnDebug && !_isBooked ) then {
			systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle tried but failed to booking a HOLD-MARKER center. Moving to a secondary position.",
			CSWR_txtDebugHeader, _tag, _grp];
		};
	// If group or non-tracked-vehicle:
	} else {
		// Selecting a hold-marker:
		_mkrToHold = selectRandom _dests;
	};

	// SETTING A POSITION:
	// If not booked (people and non-tracked-vehicle never will booking, including tracked-vehicle that didn't find a hold-marker free):
	if !_isBooked then {
		// Looping to find a good spot in selected marker > if the group still exists:
		while { !isNull _grp } do {
			// Counter to prevent crazy loops:
			_ctr = _ctr + 1;
			// if a tracked-vehicle with a secondary pos:
			if _isVehTracked then {
				// Find pos min Xm from center (_mkrToHold) but not further Xm, not closer Xm to other obj, not in water, max gradient, no (0) on shoreline:
				_posHolder = [markerPos _mkrToHold, 20, 30, 3, 0, 0.4, 0] call BIS_fnc_findSafePos;  // https://community.bistudio.com/wiki/BIS_fnc_findSafePos
			// Everything else, including people and big wheeled vehicles:
			} else {
				_posHolder = [markerPos _mkrToHold, 30, 40, 3, 0, 0.7, 0] call BIS_fnc_findSafePos;
			};
			// if the group (or only vehicle in secondary positions) is not over a road, good position and stop the while-loop:
			if ( !isOnRoad _posHolder ) then { break };
			// Warning:
			if ( _ctr > 5 ) then {
				// Restart the counter:
				_ctr = 0;
				// Limit counter:
				_tryLimit = _tryLimit - 1;
				// Message:
				if CSWR_isOnDebug then {
					systemChat format ["%1 HOLD > Looks %2 '%3' ISN'T finding a safe spot to maneuver in '%4' position. They keep trying...",
					CSWR_txtWarnHeader, _tag, _grp, _mkrToHold];
				};
			};
			// Protecting the performance:
			if ( _tryLimit isEqualTo 0 ) then {
				// Warning:
				if CSWR_isOnDebug then {
					systemChat format ["%1 HOLD > %2 '%3' tried many times to find a safe but failed over and over again. The group/vehicle was deleted to save server performance!",
					CSWR_txtWarnHeader, _tag, _grp];
				};
				// Deletion:
				if _isVeh then { deleteVehicleCrew (leader _grp); deleteVehicle _veh } else { deleteVehicle (units _grp) };
				deleteGroup _grp;
			};
			// Cooldown to prevent crazy loops:
			if _isVeh then { sleep _waitForVeh } else { sleep _wait };
		};  // While-loop ends.
	};
	// Escape:
	if ( isNull _grp ) exitWith {};
	
	// WAYPOINT AND GO:
	_wp = _grp addWaypoint [_posHolder, 0]; 
	_wp setWaypointType "HOLD";
	_grp setCurrentWaypoint _wp;
	// If infantry/people:
	if !_isVeh then {
		// Check if the group is already on their destination:
		waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _posHolder < 2 || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
	// If vehicle:
	} else {
		// Wait 'til getting really closer:
		waitUntil { sleep _wait; isNull _grp || !alive _veh || (leader _grp) distance _posHolder < (_wpDisLimit + 30) || isNull (objectParent (leader _grp)) || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
		// if crew still in vehicle:
		if ( !isNull (objectParent (leader _grp)) ) then {
			// If there's still the original waypoint:
			if ( waypointType [_grp, currentWaypoint _grp] isEqualTo "HOLD" ) then {
				// it forces the crew order to drive as closer as possible the waypoint:
				(leader _grp) doMove _posHolder;
			};
		// crew by foot:
		} else {
			// Undo the booking:
			["BOOKING_HOLD", _tag, _mkrToHold, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
			// Update to avoid further checking:
			_isBooked = false;
			// Crew with no vehicle should join in a infantry group:
			[_tag, _grp, 1, 300, 3, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
		};
		// Wait 'til the vehicle is over the waypoint:
		waitUntil { sleep _wait; isNull _grp || !alive _veh || (leader _grp) distance _posHolder < _wpDisLimit || isNull (objectParent (leader _grp)) || (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" };
	};
	// Escape > if NOT a vehicle, and if the group doesn't exist or the leader was killed, abort:
	if ( !_isVeh && { isNull _grp || !alive (leader _grp) } ) exitWith {};
	// Escape > Booked or not, it's a vehicle, and if the ground doesn't exist or the leader was killed, or the vehicle has been destroyed, or even the group is out of the vehicle, abort:
	if ( _isVeh && { isNull _grp || !alive (leader _grp) || !alive _veh || isNull (objectParent (leader _grp)) } ) exitWith {
		// Undo the booking if booked:
		["BOOKING_HOLD", _tag, _mkrToHold, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
	};
	// Escape > if the group/vehicle lost its hold-waypoint:
	if ( (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" ) exitWith { 
		// Undo the booking:
		["BOOKING_HOLD", _tag, _mkrToHold, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
		// Restart:
		[_dests, _tag, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD;
	};

	// ARRIVAL IN MARKER POSITION:
	// If vehicle:
	if _isVeh then {
		// if the crewmen is inside the vehicle:
		if ( !isNull (objectParent (leader _grp)) ) then { 
			// Function validation is: if vehicle has its crewmen inside and the vehicle is a tracked one, do it:
			[_mkrToHold, _grp, _tag, _isVehTracked] call THY_fnc_CSWR_HOLD_tracked_vehicle_direction;
			// If editors choice was stealth all vehicles on hold:
			if CSWR_isHoldVehLightsOff then { sleep 5; _grp setBehaviourStrong "STEALTH" };
		// Otherwise, if the crew is by foot:
		} else {
			// Crew with no vehicle should join in a infantry group:
			[_tag, _grp, 1, 300, 3, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
		};
	// infantry:
	} else {
		// Group always will change the formation for this (aesthetically better):
		_grp setBehaviourStrong "AWARE";  // "'SAFE'  or  'CARELESS' behavior ignores set formation and forces a group to fall into some loose column formation!" by Grumpy Old Man, 2020!
		_grp setFormation "DIAMOND";
		sleep 45;
		// Load the original group behavior (Editor's choice):
		[_grp, _behavior, _isVeh] call THY_fnc_CSWR_grp_behavior;
		// Load again the unit individual and original behavior:
		[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	};
	// Next planned move cooldown:
	_t = time + (selectRandom CSWR_destHoldTakeabreak); 
	waitUntil { sleep _wait; isNull _grp || !alive (leader _grp) || time > _t || { if _isVeh then { !alive _veh } else { false } } };  // Important: dont check the currentWaypoints coz infantry will delete it in their arrival.
	
	// UNDO IF BOOKED:
	["BOOKING_HOLD", _tag, _mkrToHold, _isBooked] call THY_fnc_CSWR_marker_bookingUndo;
	
	// RESTART THE MOVEMENT:
	[_dests, _tag, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD;
	// Return:
	true;
};


THY_fnc_CSWR_HOLD_ground_cleaner = {
	// This function clean the ground around the hold-marker to prevend collision anomalies with tracked-vehicles.
	// Returns nothing.

	params ["_markers"];
	//private [""];

	// Escape:
	if ( _markers isEqualTo [] ) exitWith {};
	// Check the objects to hide from a specific distance of each marker position. The goal here is remove only things the vehicle wouldn't smash easy, like a rock, for example. "HIDE" has rocks too:
	{  // forEach _markers:
		{ hideObjectGlobal _x } forEach nearestTerrainObjects [markerPos _x, ["ROCK", "ROCKS", "HIDE", "TREE"], 30, false, false];  // [position, types, radius, sort, 2Dmode]
		// CPU breather:
		sleep 0.1;
	} forEach _markers;
	// Return:
	true;
};


THY_fnc_CSWR_HOLD_tracked_vehicle_direction = {
	// This function sets the tracked-vehicle as the same direction as the hold-marker placed by the mission editor.
	// Returns nothing.

	params ["_mkr", "_grp", "_tag", "_isVehTracked"];
	private ["_veh", "_blockers", "_attemptCounter", "_attemptLimiter", "_directionToHold", "_vehPos"];
	
	// Declarations - part 1/2:
	_veh = vehicle (leader _grp);
	// Escape > if vehicle is destroyed, abort:
	if ( !alive _veh ) exitWith {};
	// Escape > if not tracked-vehicle, abort:
	if !_isVehTracked exitWith {};
	// Initial values:
	_blockers = [];
	_attemptCounter = 0;
	// Declarations - part 2/2:
	_attemptLimiter = 5;
	_directionToHold = markerDir _mkr;
	// Force the vehicle stop before get the hold-direction:
	_veh sendSimpleCommand "STOP";
	// Wait the vehicle to brake:
	waitUntil { sleep 2; speed _veh <= 0.1 };
	// Check if there is some blocker around the vehicle. A simple unit around can make a tank get to fly like a rocket if too much close during the setDir command:
	while { alive _veh && _attemptCounter < _attemptLimiter && !isNull (objectParent (leader _grp)) && (waypointType [_grp, currentWaypoint _grp]) isEqualTo "" } do {
		// Check if something relevant is blocking the Hold-marker position:
		_blockers = (getPosATL _veh) nearEntities [["Man", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "UAV", "Helicopter", "Plane"], 10];
		// Removing the group vehicle itself from the calc as blocker:
		_blockers deleteAt (_blockers find _veh);
		// If no blockers, leave the verification loop:
		if ( _blockers isEqualTo [] ) then { break };
		// Counter to avoid crazy loopings:
		_attemptCounter = _attemptCounter + 1;
		// Debug:
		if CSWR_isOnDebug then {
			// Warning messages:
			if ( _attemptCounter < _attemptLimiter ) then {
				systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle is WAITING NO BLOCKERS to execute the 'setDir' Hold-move! Current blockers: %4",
				CSWR_txtWarnHeader, _tag, _grp, _blockers];
			} else {
				systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle has been %4 times to execute the hold-move but blocker(s) still there. Hold- to be aborted.",
				CSWR_txtWarnHeader, _tag, _grp, _attemptLimiter];
			};
		};
		// long breather to the next loop check:
		sleep 20;
	};  // while loop ends.
	// Escape > if there are some blockers, abort:
	if ( _blockers isNotEqualTo [] ) exitWith {};
	// Set the direction:
	_vehPos = getPosATL _veh;
	_veh setDir _directionToHold;  // best practices is make it before to use the setPos because odd things can happen about object collision position.
	_veh setPosATL [_vehPos # 0, _vehPos # 1, (_vehPos # 2) + 1 ];  // This will lift the veh so, when redirected, it'll avoid wavy grounds that would cause the veh to bounce.
	
	// Debug:
	if CSWR_isOnDebug then {
		// Breather to make sure the vehicle already in the new position before the debug message "getDir" calc:
		sleep 5;
		// Debug:
		["%1 HOLD > %2 '%3' tracked-vehicle ready in hold-position [Desired direction: %4º | Executed: %5º].",
		CSWR_txtDebugHeader, _tag, _grp, _directionToHold, getDir _veh] call BIS_fnc_error; sleep 1;
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_EXTRACTION = {
	// It's a new thread!
	// After the THY_fnc_CSWR_TRANSPORT_booking_and_wait, this function sets the vehicle to move to the group's leader position (caller) and bring them back to the base. It's NOT a recursive loop.
	// Returns nothing.

	params ["_tag", "_spwn", "_grpCaller", "_grpType", "_grpVeh", "_behavior", ["_searchRange", 80]];
	private ["_isToTryAgain", "_spaceToLand", "_t", "_wasDebugHeliOn", "_basePos", "_minDisCall", "_searchRngLimit", "_disReadyLand", "_veh", "_pickupPos", "_txt1", "_txt2", "_txt3", "_txt4", "_helipad", "_wp"];

	// Escape > If vehicle explode for any reason, abort:
	if ( !alive vehicle (leader _grpVeh) ) exitWith {
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Return:
		true;
	};
	// Initial values:
	_isToTryAgain   = false;
	_spaceToLand    = nil;
	_t              = 0;  // Dont set nil!
	_wasDebugHeliOn = if CSWR_isOnDebugHeli then { true } else { false };  // Debug purposes.
	// Declarations:
	_basePos        = markerPos _spwn;
	_minDisCall     = 500;
	_searchRngLimit = 400;
	_disReadyLand   = 300; if (_minDisCall < _disReadyLand) then { _minDisCall = _disReadyLand + 10 }; // Caution: lower than 300 can cause explosion during the take off!
	_veh            = vehicle leader _grpVeh;
	_pickupPos      = getPosATL leader _grpCaller;  // caller position.
	switch _grpType do {
		case "heliL": { _spaceToLand = 10 };
		case "heliM": { _spaceToLand = 15 };
		case "heliH": { _spaceToLand = 20 };
	};
	_txt1 = "The pickup position CANNOT be used! It appears that the surrounding terrain is unsuitable.";
	_txt2 = "The pickup position requested is TOO CLOSE to the base.";
	_txt3 = "You're in an area that's impossible for the Support Transport team to reach you. You lost the request.";
	_txt4 = "The extraction team was neutralized!";
	
	// STAGE 1/6 > PLAYER REQUEST A POSITION TO PICKUP --------------------------------------------------
	// Finding the landing spot:
	_pickupPos = [
		_pickupPos,  // center
		0,  // minDist
		_searchRange,  // maxDist
		_spaceToLand,  // objDist
		0,  // waterMode (0=land / 1=land+water / 2=water)
		0.25,  // maxGrad (0=absolutely flat, the checking is ignored / 1=absolutely steep, a person would use hands to walking up)
		0,  // shoreMode (0=does not have to be at a shore / 1=must be at a shore)
		[],  // blacklistPos
		[]  // defaultPos (when no position is found)
	] call BIS_fnc_findSafePos; // Returns only [x,y] when something is found!
	// If BIS_fnc_findSafePos appends a Z pos in the _pickupPos array when nothing was found:
	if ( count _pickupPos isEqualTo 3 || _basePos distance2d _pickupPos < _minDisCall ) then {
		if ( count _pickupPos isEqualTo 3 ) then {
			// For single-player:
			if !isMultiplayer then {
				systemChat format ["%1", _txt1];
			// For Multiplayer:
			} else {
				[format ["%1", _txt1]] remoteExec ["systemChat", leader _grpCaller];
			};
		} else {
			// For single-player:
			if !isMultiplayer then {
				systemChat format ["%1", _txt2];
			// For Multiplayer:
			} else {
				[format ["%1", _txt2]] remoteExec ["systemChat", leader _grpCaller];
			};
		};
		// Expand the search area until a certain range limit:
		if (_searchRange <= _searchRngLimit ) then {
			// Cooldown next try:
			sleep 5;  // Important: big number will make the vehicle, already in-game, stand still over the spawn-point!
			// Flag:
			_isToTryAgain = true;
			// Restart the function with twice bigger search range (new thread):
			[_tag, _spwn, _grpCaller, _grpType, _grpVeh, _behavior, (_searchRange * 2)] spawn THY_fnc_CSWR_go_dest_EXTRACTION;
		} else {
			// Failed message:
			// For single-player
			if !isMultiplayer then {
				systemChat format ["%1", _txt3];
			// For multiplayer
			} else {
				[format ["%1", _txt3]] remoteExec ["systemChat", leader _grpCaller];
			};
			// Remove the player's group from the support list:
			[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
			// Delete Transport Team:
			deleteVehicleCrew _veh;
			deleteVehicle _veh;
		};
	};
	// Escape > Leave before of discounting the attempt from the support amount:
	if _isToTryAgain exitWith { true };
	// Escape > If search range is too big, just abort:
	if ( _searchRange > _searchRngLimit ) exitWith { true };
	
	// STAGE 2/6 > EXTRACTION TEAM ON BASE, PREPARING TO GO ---------------------------------------------
	// vehicle config:
	_veh lockDriver true;
	// Load the original group behavior (Editor's choice):
	[_grpVeh, _behavior, true, false] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grpVeh, _behavior, true, false] call THY_fnc_CSWR_unit_behavior;
	// Forcing driver only:
	driver _veh setCombatBehaviour "CARELESS";  // Gunner(s) still open fire.
	// Creating the virtual helipad and the waypoint for there:
	_helipad = "Land_HelipadEmpty_F"; if CSWR_isOnDebug then { _helipad = "Land_HelipadSquare_F"};
	_helipad = _helipad createVehicle _pickupPos;
	_wp = _grpVeh addWaypoint [_pickupPos, 0];
	//_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointType "MOVE";
	_grpVeh setCurrentWaypoint _wp;
	// Message:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		// For military context:
		if ( _tag isNotEqualTo "CIV" ) then {
			leader _grpVeh commandChat format ["Heading to the %1 position!",
			_grpCaller];
		// For cibilian context:
		} else {
			leader _grpVeh commandChat format ["Here is the helicopter's pilot, we are going to Mr. %1 position, okay?!",
			leader _grpCaller];
		};
	};
	
	// STAGE 3/6 > EXTRACTION TEAM ON THE WAY, HEADING TO PLAYERS POSITION ------------------------------
	// Waiting the extraction team to be on the requested position:
	waitUntil {
		// Breather:
		sleep 10;
		// Condition to break the loop:
		// If engine stopped (blades broken or veh destroyed):
		!isEngineOn _veh ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or caller group has no leader anymore:
		!alive leader _grpCaller ||
		// Or the veh is already on the way to the pickup point AND it's touching the ground:
		{ _veh distance2d _basePos > _disReadyLand && ((getPosATL _veh) # 2) <= 0.3 } ||
		// Or the veh is close enough the pickup point:
		_veh distance2d _pickupPos < _disReadyLand;
	};
	// Escape > If some accident, breaking the helicopter blades or an important actor is dead, abort:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || ((getPosATL _veh) # 2) <= 0.3 ) exitWith {
		// Force the destruction:
		{ deleteVehicle _x } forEach units _grpVeh;
		_veh setDamage 1;
		// For single-player:
		if !isMultiplayer then {
			systemChat format ["%1", _txt4];
		// For Multiplayer:
		} else {
			[format ["%1", _txt4]] remoteExec ["systemChat", leader _grpCaller];
		};
		// Remove the dynamic helipad:
		deleteVehicle _helipad;
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Return:
		true;
	};
	// Landing:
	_veh land "GET IN";
	// Debug > Turning off the Debug Heli temporarily:
	[_tag, _grpVeh, _veh, _grpCaller, _t, 1] call THY_fnc_CSWR_debug_supportTransp;
	// Wait until vehicle touches the ground:
	waitUntil {
		// Breather:
		sleep 5;
		// Debug > Showing caller group info:
		[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
		// Conditions:
		((getPosATL _veh) # 2) <= 0.3;
	};
	// Debug > Showing caller group info (last info from this stage):
	[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
	
	// STAGE 4/6 > EXTRACTION TEAM ON THE PICKUP POINT --------------------------------------------------
	// Message > extraction team waiting the leader _grpCaller:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		leader _grpVeh commandChat format ["%1",
		selectRandom ["We are at the requested point. Get in!", "At the requested point. Hurry up!"]];
	};
	// Waiting all _grpCaller members get in:
	_t = time + CSWR_airTransportWaitTime;
	waitUntil {
		// Breather:
		sleep 5;
		// In case of one or more crew members jump out the veh while landed, no matter the reason:
		if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
			// Make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
			// If veh still in-game:
			if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
				_veh lockDriver false;
				_veh setFuel 0;
			};
		};
		// Debug > Showing caller group info:
		[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
		// Condition to break the loop:
		// If engine stopped (blades broken or veh destroyed):
		!isEngineOn _veh ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or caller group has no leader anymore:
		!alive leader _grpCaller ||
		// Or all alive caller group units are in veh:
		({ alive _x } count (units _grpCaller)) isEqualTo ({ _x in _veh } count (units _grpCaller)) ||
		// Or the time ran out:
		time > _t;
	};
	// Debug > Showing caller group info (last info from this stage):
	[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
	// Remove the dynamic helipad:
	deleteVehicle _helipad;
	// Escape > if veh is alive but it's broken, abort:
	if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Debug > Turning On if Debug Heli was On before:
		[_tag, _grpVeh, _veh, _grpCaller, _t, 2, _wasDebugHeliOn] call THY_fnc_CSWR_debug_supportTransp;
		// Return:
		true;
	};
	// Escape > if veh lost its engine or is destroyed, OR crew driver is dead/objNull, OR there's no more leader on caller group, abort:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
		// For single-player:
		if !isMultiplayer then {
			systemChat format ["%1", _txt4];
		// For Multiplayer:
		} else {
			[format ["%1", _txt4]] remoteExec ["systemChat", leader _grpCaller];
		};
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Debug > Turning On if Debug Heli was On before:
		[_tag, _grpVeh, _veh, _grpCaller, _t, 2, _wasDebugHeliOn] call THY_fnc_CSWR_debug_supportTransp;
		// Return:
		true;
	};
	// Message:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		if ( time <= _t ) then {
			_veh vehicleChat "Let's get out of here!";
		} else {
			leader _grpVeh commandChat "Sorry, but we CANNOT stay longer! We are leaving!";
		};
	};
	// Debug > Turning On if Debug Heli was On before:
	[_tag, _grpVeh, _veh, _grpCaller, _t, 2, _wasDebugHeliOn] call THY_fnc_CSWR_debug_supportTransp;
	
	// STAGE 5/6 > EXTRACTION TEAM RETURNING TO BASE  ---------------------------------------------------
	// Returning the origin position:
	_wp = _grpVeh addWaypoint [_basePos, 0];
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointType "MOVE";
	_grpVeh setCurrentWaypoint _wp;
	// Waiting the extraction team to be back to the base:
	waitUntil {
		// Breather:
		sleep 5;
		// In case of one or more crew members jump out the veh while landed, no matter the reason:
		if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
			// Make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
			// If veh still in-game:
			if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
				_veh lockDriver false;
				_veh setFuel 0;
			};
		};
		// Condition to break the loop:
		// If engine stopped (blades broken or veh destroyed):
		!isEngineOn _veh ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or caller group has no leader anymore:
		!alive leader _grpCaller ||
		// 
		_veh distance2d _basePos < _disReadyLand;
	};
	// Escape > If some accident at base, breaking the helicopter blades or an important actor is dead, abort:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
		// Canceling landing:
		if ( alive _veh && isEngineOn _veh ) then { _veh land "NONE" };
		// For single-player:
		if !isMultiplayer then {
			systemChat format ["%1", _txt4];
		// For Multiplayer:
		} else {
			[format ["%1", _txt4]] remoteExec ["systemChat", leader _grpCaller];
		};
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Return:
		true;
	};
	// Landing:
	_veh land "LAND";  // Caution: 'LAND" forces the engine off!
	
	// STAGE 6/6 > EXTRACTION TEAM AT BASE  -------------------------------------------------------------
	// Waiting until touch the ground:
	waitUntil {
		// Breather:
		sleep 5;
		// Conditions:
		((getPosATL _veh) # 2) <= 0.3;
	};
	_veh engineOn false;
	// Message of mission completed:
	if ( alive driver _veh && leader _grpVeh distance2d _basePos < _disReadyLand ) then {
		leader _grpVeh commandChat "We are back to the base! Our mission's complete, over!";
	};
	// Finishing some details:
	{ deleteVehicle _x } forEach units _grpVeh;  // deleteVehicleCrew _veh; -- it would delete your AI group members too.
	{ moveOut (_x # 0) } forEach (fullCrew _veh);  // moveOut is faster, no animation, works with players, AI and dead bodies.
	_veh setVehicleLock "LOCKED";
	// A short time to players take back something added in vehicle cargo:
	sleep 30;
	deleteVehicle _veh;
	// Remove the player's group from the support list:
	[_grpCaller, "CSWR_suprtExtractAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_TRANSPORT = {
	// It's a new thread!
	// After the THY_fnc_CSWR_TRANSPORT_booking_and_wait, this function sets the vehicle to move to the caller group (always a player) pickup-point and bring them for a custom position called delivery-point.
	// There the caller leader once into the vehicle, they provide the delivery-point with their map by clicking. Once the transport support is done, the vehicle returns to base and it's deleted. 
	// It's NOT a recursive loop.
	// Returns nothing.

	params ["_tag", "_spwn", "_grpCaller", "_grpType", "_grpVeh", "_behavior", ["_searchRange", 80]];
	private ["_basePos", "_minDisCall", "_callerPos", "_isToTryAgain", "_spaceToLand", "_isToShowMsg", "_data", "_searchRngLimit", "_disReadyLand", "_veh", "_txt1", "_txt2", "_txt3"];

	// Escape > If the veh explodes for any reason, abort:
	if ( !alive vehicle (leader _grpVeh) ) exitWith {
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
		// Return:
		true;
	};
	// Declarations - part 1/2:
	_basePos    = markerPos _spwn;
	_minDisCall = 500;
	_callerPos  = getPosATL leader _grpCaller;  // caller position.
	// Initial values:
	_isToTryAgain = false;
	_spaceToLand  = nil;
	_isToShowMsg  = true;
	_data         = createHashMap;  // Important: storing things that can change and it's more dynamic to store!
	_data set ["isCallerOnBase", _basePos distance2d _callerPos < _minDisCall];  // if true, the veh doesn't need to execute the entire Pickup function, just the last moment where the player get in the veh.
	_data set ["isCanceled", false];  // most important info where, if true, the entire support service should be finished as soon as possible, depends if the veh and its driver are alive or not.
	_data set ["isDeliveryBase", false];  // if true, the veh doesn't need to execute the RTB stage coz the veh will be at base already, just short cooldown to be deleted once it arrives at delivery-point (base).
	_data set ["wasCanceledEarlierAtBase", false];  // if true, it means the veh not even more, so the function can just jump all sub-functions straight to the deletion veh and its crew stage.
	_data set ["whereToGoPos", []];  // the coordenates defined by caller for the delivery-point.
	_data set ["helipadType", if !CSWR_isOnDebug then { "Land_HelipadEmpty_F" } else { "Land_HelipadSquare_F" }];
	_data set ["helipad", objNull];  // Coz sometimes one sub-function of air transport creates the helipad, and just another later is responsable to delete it.
	_data set ["wasDebugHeliOn", if CSWR_isOnDebugHeli then { true } else { false }];  // Crucial to know if debug transp should turn off debug heli just once and then restore it if needed later.
	// Declarations - part 2/2:
	_searchRngLimit = 400;
	_disReadyLand   = 300; if (_minDisCall < _disReadyLand) then { _minDisCall = _disReadyLand + 10 }; // Caution: lower than 300 can cause explosion during the take off!
	_veh            = vehicle leader _grpVeh;
	switch _grpType do {
		case "heliL": { _spaceToLand = 10 };
		case "heliM": { _spaceToLand = 15 };
		case "heliH": { _spaceToLand = 20 };
	};
	_txt1 = "For some reason, the Air Transport was canceled.";
	_txt2 = format ["The pickup point CANNOT be used! It appears that %1m of terrain is unsuitable. Checking...", _searchRange];
	_txt3 = format ["After to check %1m around, you're in a TOO RISKY terrain for this class (%2) of Air Transport to reach you. You LOST THIS REQUEST.", _searchRange, _grpType];

	// STAGE 1/5 > CALLER REQUESTS TRANSPORT SUPPORT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	// Player group is NOT AT BASE:
	if !(_data get "isCallerOnBase") then {
		// Finding the landing spot:
		_callerPos = [
			_callerPos,  // center
			0,  // minDist
			_searchRange,  // maxDist
			_spaceToLand,  // objDist
			0,  // waterMode (0=land / 1=land+water / 2=water)
			0.25,  // maxGrad (0=absolutely flat, the checking is ignored / 1=absolutely steep, a person would use hands to walking up)
			0,  // shoreMode (0=does not have to be at a shore / 1=must be at a shore)
			[],  // blacklistPos
			[]  // defaultPos (when no position is found)
		] call BIS_fnc_findSafePos; // Returns only [x,y] when something is found!
		// If BIS_fnc_findSafePos appends a Z pos in the _callerPos array when nothing was found:
		if ( count _callerPos isEqualTo 3 ) then {
			// Expand the search area until a certain range limit:
			if ( _searchRange <= _searchRngLimit ) then {
				// Message:
				// For Single-player:
				if !isMultiplayer then {
					systemChat format ["%1", _txt2];
				// For Multiplayer:
				} else {
					[format ["%1", _txt2]] remoteExec ["systemChat", leader _grpCaller];
				};
				// Cooldown next try:
				sleep 5;  // Important: big number will make the vehicle, already in-game, stand still over the spawn-point!
				// Flag:
				_isToTryAgain = true;
				// Restart the function with twice bigger search range (new thread):
				[_tag, _spwn, _grpCaller, _grpType, _grpVeh, _behavior, (_searchRange * 2)] spawn THY_fnc_CSWR_go_dest_TRANSPORT;
			} else {
				// Failed message:
				// For Single-player:
				if !isMultiplayer then {
					systemChat format ["%1", _txt3];
				// For Multiplayer:
				} else {
					[format ["%1", _txt3]] remoteExec ["systemChat", leader _grpCaller];
				};
				// Remove the player's group from the support list:
				[_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
				// Delete Transport Team:
				deleteVehicleCrew _veh;
				deleteVehicle _veh;
			};
		};
	};
	// Escape > Leave this thread for a new try, OR if search range is too big, just abort:
	if ( _isToTryAgain || _searchRange > _searchRngLimit ) exitWith { true };
	
	// STAGE 2/5 > TRANSPORT TEAM WAITS CALLER GROUP TO GET IN - OR - GOES TO THE PICKUP POINT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	_data = [_data, _grpCaller, _callerPos, _tag, _grpVeh, _veh, _behavior, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_pickup;
	// Remove the dynamic helipad, no matter if canceled or going to the next stage:
	deleteVehicle (_data get "helipad");
	// Action if support canceled:
	if ( _data get "isCanceled" ) then {
		// Debug > Turning On if Debug Heli was On before:
		[_tag, _grpVeh, _veh, _grpCaller, nil, 2, _data get "wasDebugHeliOn"] call THY_fnc_CSWR_debug_supportTransp;
		// Message only to caller:
		if _isToShowMsg then {
			// For single-player:
			if !isMultiplayer then {
				systemChat format ["%1", _txt1];
			// For multiplayer:
			} else {
				[format ["%1", _txt1]] remoteExec ["systemChat", leader _grpCaller];
			};
			_isToShowMsg = false;
		};
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
	};
	// Escape > If the veh was destroyed OR the pilot is dead, abort:
	if ( !isEngineOn _veh || !alive driver _veh ) exitWith { true };

	// STEP 3/5> TRANSPORT TEAM WITH CALLER, ASKING WHERE TO GO |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	_data = [_data, _grpCaller, _tag, _grpVeh, _veh, _basePos, _spaceToLand, _minDisCall] call THY_fnc_CSWR_TRANSPORT_where_to_go;
	// Important: don't remove the helipad by code here as the previously stages! This function above is different than others.
	// Debug > Turning On if Debug Heli was On before:
	// Important: no matter what, this debug support won't be used in the next stage!
	[_tag, _grpVeh, _veh, _grpCaller, nil, 2, _data get "wasDebugHeliOn"] call THY_fnc_CSWR_debug_supportTransp;  // Next stages this debug is not needed!
	// Action if support canceled:
	if ( _data get "isCanceled" ) then {
		// Message only to caller:
		if _isToShowMsg then {
			// For single-player:
			if !isMultiplayer then {
				systemChat format ["%1", _txt1];
			// For multiplayer:
			} else {
				[format ["%1", _txt1]] remoteExec ["systemChat", leader _grpCaller];
			};
			_isToShowMsg = false;
		};
		// Remove the player's group from the support list:
		[_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
	};
	// Escape > If the veh was destroyed OR the pilot is dead, abort:
	if ( !isEngineOn _veh || !alive driver _veh ) exitWith { true };

	// STAGE 4/5 > TRANSPORT TEAM WITH CALLER, GOES TO DELIVERY POINT ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	_data = [_data, _grpCaller, _tag, _grpVeh, _veh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_delivery;
	// Remove the dynamic helipad, no matter if canceled or going to the next stage:
	deleteVehicle (_data get "helipad");
	// Remove the player's group from the support list:
	// Important: at this point caller is at delivery point, so it removes the caller group from the booking list no matter what:
	[_grpCaller, "CSWR_suprtTranspAirData"] call THY_fnc_CSWR_TRANSPORT_grp_bookingUndo;
	// Action if support canceled:
	if ( _data get "isCanceled" ) then {  // It's NOT "Escape"!
		// Message only to caller:
		if _isToShowMsg then {
			// For single-player:
			if !isMultiplayer then {
				systemChat format ["%1", _txt1];
			// For multiplayer:
			} else {
				[format ["%1", _txt1]] remoteExec ["systemChat", leader _grpCaller];
			};
		};
	};
	// Escape > If the veh was destroyed OR the pilot is dead, abort:
	//if ( !alive _veh || !alive driver _veh ) exitWith { true };  // Not needed!

	// STAGE 5/5> TRANSPORT TEAM RETURNING TO BASE |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	[_data, _grpCaller, _tag, _grpVeh, _veh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_RTB;
	// Important: no reason to have the THY_fnc_CSWR_TRANSPORT_grp_bookingUndo here because caller doesn't reach this step with the transport team!
	// Return:
	true;
};


THY_fnc_CSWR_TRANSPORT_pickup = {
	// This function takes the first stage of the transport support resource, finding the caller (player) position and, if not at base side by side the vehicle spawn-point,
	// the vehicle spawns and goes to the caller position to pickup them.
	// Returns _data: hashMap/array.

	params ["_data", "_grpCaller", "_callerPos", "_tag", "_grpVeh", "_veh", "_behavior", "_basePos", "_disReadyLand"];
	private ["_helipad", "_wp", "_t"];

	// Initial values:
	_helipad = "";
	_wp      = [];
	_t       = 0;  // Dont set nil!
	// Escape > Veh is destroyed, OR veh driver is dead/objNull, abort:
	if ( !isEngineOn _veh || _veh getHitPointDamage "HitVRotor" > 0.6 || !alive driver _veh ) exitWith { _data set ["isCanceled", true]; _data set ["wasCanceledEarlierAtBase", true]; _data };
	// Declarations:
		// Reserved space.
	// Load the original group behavior (Editor's choice):
	[_grpVeh, _behavior, true, false] call THY_fnc_CSWR_grp_behavior;
	// Load again the unit individual and original behavior:
	[_grpVeh, _behavior, true, false] call THY_fnc_CSWR_unit_behavior;
	// Forcing the pilot only:
	driver _veh setCombatBehaviour "CARELESS";  // Gunner still open fire.
	// vehicle config:
	_veh lockDriver true;
	// Debug > Turning off the Debug Heli temporarily:
	[_tag, _grpVeh, _veh, _grpCaller, _t, 1] call THY_fnc_CSWR_debug_supportTransp;

	// STEP 1/2 > TRANSPORT TEAM ON BASE, PREPARING TO GO |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	// Caller already IS AT BASE:
	if (_data get "isCallerOnBase") then {
		// Messages:
		if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
			if ( _tag isNotEqualTo "CIV" ) then {
				leader _grpVeh commandChat format ["We are READY and less than %2 meters from the %1 position. We gonna waiting for them!",
				_grpCaller, _minDisCall];
			} else {
				leader _grpVeh commandChat format ["We are READY and close enough to the Mr. %1. We gonna waiting for them!",
				leader _grpCaller];
			};
		};

		// STEP 1.1/2 > TRANSPORT TEAM ON LANDED ON PICKUP POINT (BASE) --------------------------------------------------
		// Waiting all _grpCaller members get in:
		_t = time + CSWR_airTransportWaitTime;
		waitUntil {
			// Breather:
			sleep 5;
			// Debug > Showing caller group info:
			[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
			// Condition to break the loop:
			// If engine stopped (blades broken or veh destroyed):
			!isEngineOn _veh ||
			// Or veh driver is dead/objnull:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or caller group has no leader anymore:
			!alive leader _grpCaller ||
			// Or if the entire caller group (alive members) is in veh:
			({ alive _x } count (units _grpCaller)) isEqualTo ({ _x in _veh } count (units _grpCaller)) ||
			// Or if nobody from caller group is in veh and the time ran out:
			// Important: dont set validations abourt 'leader distance releated to veh' coz the leader called to transport from the base and that's it!
			{ { alive _x && _x in _veh } count (units _grpCaller) isEqualTo 0 && time > _t };
		};
		// Debug > Showing caller group info (last info from this stage):
		[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
		// Escape > If some accident at base, breaking the helicopter blades or an important actor is dead, abort:
		if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
			_data set ["wasCanceledEarlierAtBase", true];
		};
		// Escape > if pickup failed coz NO one from caller group was in veh when the time ran out:
		if ( { alive _x && _x in _veh } count (units _grpCaller) isEqualTo 0 && time > _t ) exitWith {
			// Message:
			if ( alive _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
				// For military context:
				if ( _tag isNotEqualTo "CIV" ) then {
					leader _grpVeh commandChat format ["Base, looks %1 couldn't reach the pickup point. We are abording the mission. Engine off, over!",
					_grpCaller];
				// For civilian context:
				} else {
					leader _grpVeh commandChat format ["For some reason, Mr. %1 wasn't at pickup point. Taxiing canceled...",
					leader _grpCaller];
				};
			};
			// Prepare to return:
			_data set ["isCanceled", true];
			_data set ["wasCanceledEarlierAtBase", true];
		};

	// STEP 2/2 > TRANSPORT TEAM GOING TO PICKUP POINT ---------------------------------------------------------------
	// Caller is NOT at base:
	} else {
		_helipad = (_data get "helipadType") createVehicle _callerPos;
		// Storing the obj to be accessable later through another function:
		_data set ["helipad", _helipad];
		_wp = _grpVeh addWaypoint [_callerPos, 0];
		//_wp setWaypointCombatMode "YELLOW";
		_wp setWaypointType "MOVE";
		_grpVeh setCurrentWaypoint _wp;
		// Message:
		if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
			// For military context:
			if ( _tag isNotEqualTo "CIV" ) then {
				leader _grpVeh commandChat format ["Heading to the %1 position!",
				_grpCaller];
			// For civilian context:
			} else {
				leader _grpVeh commandChat format ["Here is the helicopter pilot, we are heading to Mr. %1 position...",
				leader _grpCaller];
			};
		};
		// Waiting the Transport team to be on the pickup point:
		waitUntil {
			// Breather:
			sleep 10;
			// Condition to break the loop:
			// If engine stopped (blades broken or veh destroyed):
			!isEngineOn _veh ||
			// Or veh has no driver:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or veh is far from the base (but before the pickup point) and is touching the ground:
			{ _veh distance2d _basePos > _disReadyLand && ((getPosATL _veh) # 2) <= 0.3 } ||
			// Or veh is already landing to pickup the caller:
			_veh distance2d _callerPos < _disReadyLand;
		};
		// Escape > if veh lost its blades or is destroyed, OR crew driver is dead/objNull, Or veh is far from the base, far from the pickup point, but it's touching the ground, abort:
		if (!isEngineOn _veh ||
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			{ _veh distance2d _basePos > _disReadyLand && _veh distance2d _callerPos > _disReadyLand && ((getPosATL _veh) # 2) <= 0.3 } ) exitWith {
			// Force the destruction:
			{ deleteVehicle _x } forEach units _grpVeh;
			_veh setDamage 1;
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > if the caller group is dead (inside the veh), abort:
		if ( !alive leader _grpCaller ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Landing:
		_veh land "GET IN";
		// Wait until vehicle touches the ground:
		waitUntil {
			// Breather:
			sleep 5;
			// Conditions:
			// If engine stopped (blades broken or veh destroyed):
			!isEngineOn _veh ||
			// Or veh driver is dead/objnull:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or caller group has no leader anymore:
			!alive leader _grpCaller ||
			// Or veh is touching the ground:
			((getPosATL _veh) # 2) <= 0.3;
		};
		// Escape > if veh is alive but it's broken, abort:
		if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > if veh lost its engine or is destroyed, OR crew driver is dead/objNull, OR there's no more leader on caller group, abort:
		if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
			// Abort the landing if crew and veh alive:
			_veh land "NONE";
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		
		// STEP 2.1/2 > TRANSPORT TEAM ON LANDED ON PICKUP POINT ---------------------------------------------------------
		// Message > Transport team waiting the leader _grpCaller:
		if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
			leader _grpVeh commandChat format ["%1",
			selectRandom ["We are at the requested point. Get in!", "At the requested point. Hurry up!"]];
		};
		// Waiting all _grpCaller members get in:
		_t = time + CSWR_airTransportWaitTime;
		waitUntil {
			// Breather:
			sleep 5;
			// In case of one or more crew members jump out the veh while landed, no matter the reason:
			if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
				// Make them join to an ally group if in the range, including caller group and vehicles:
				[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
				// If veh still in-game:
				if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
					_veh lockDriver false;
					_veh setFuel 0;
				};
			};
			// Debug > Showing caller group info:
			[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
			// Condition to break the loop:
			// If engine stopped (blades broken or veh destroyed):
			!isEngineOn _veh ||
			// Or veh driver is dead/objnull:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or caller group has no leader anymore:
			!alive leader _grpCaller ||
			// Or if the entire caller group (alive members) is in veh:
			({ alive _x } count (units _grpCaller)) isEqualTo ({ _x in _veh } count (units _grpCaller)) ||
			// Or if caller leader is not close, AND nobody from their group is in veh AND the time ran out:
			{ leader _grpCaller distance2d _veh > 80 && { alive _x && _x in _veh } count (units _grpCaller) isEqualTo 0 && time > _t };
		};
		// Debug > Showing caller group info (last info from this stage):
		[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
		// Escape > if pickup failed coz caller leader wasn't close, AND veh has engine On, AND no one from their group was in veh, AND the time ran out:
		if ( leader _grpCaller distance2d _veh > 80 && isEngineOn _veh && { alive _x && _x in _veh } count (units _grpCaller) isEqualTo 0 && time > _t ) exitWith {
			// In order to make sure (CPU lag?) no one from caller group is in veh in this case:
			{ moveOut _x } forEach (units _grpCaller) select { alive _x && _x in _veh };
			// Message:
			if ( alive _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
				// For military context:
				if ( _tag isNotEqualTo "CIV" ) then {
					leader _grpVeh commandChat format ["Base, looks %1 couldn't reach the pickup point. We are returning to base, over!",
					_grpCaller];
				// For civilian context:
				} else {
					leader _grpVeh commandChat format ["For some reason, Mr. %1 wasn't at pickup point. Returning to heliport...",
					leader _grpCaller];
				};
			};
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > if veh is alive but it's broken, abort:
		if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > if veh lost its engine or is destroyed, OR crew driver is dead/objNull, OR there's no more leader on caller group, abort:
		if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
			// Another crew member tries to take the vehicle control:
			[_tag, _grpVeh, _veh] call THY_fnc_CSWR_TRANSPORT_copilot_takes_control;
			// Prepare to return:
			_data set ["isCanceled", true];
		};
	};
	// Return:
	_data;
};


THY_fnc_CSWR_TRANSPORT_where_to_go = {
	// This function manage the stage that the transport team asks the caller leader (player) where to go next.
	// This will call the function THY_fnc_CSWR_TRANSPORT_provide_pos_using_map that will call another one on client-side.
	// Returns _data: hashMap/array.
	
	params ["_data", "_grpCaller", "_tag", "_grpVeh", "_veh", "_basePos", "_spaceToLand", "_minDisCall"];
	private ["_t"];

	// Escape > If support service failed, abort this function, even if the veh still running:
	if ( _data get "isCanceled" ) exitWith { _data };
	// Initial values:
	_t = 0;
	
	// Asking to the player where to go:
	// CRITICAL STAGE (CAN TAKE A WHILE, DEPENDS THE PLAYER):
	_data = [_data, _tag, _grpCaller, _grpVeh, _veh, _basePos, _spaceToLand, _minDisCall] call THY_fnc_CSWR_TRANSPORT_provide_pos_using_map;
	// IMPORTANT TO KNOW: if everything fine, now the transport has its waypoint to delivery-point!

	// Escape > Something went wrong with the original player group's leader:
	if ( !isEngineOn _veh || _data isEqualTo [] ) exitWith {
		// Remove the dynamic helipad:
		deleteVehicle (_data get "helipad");
		// Force the caller group members already in veh to get out:
		{ moveOut _x } forEach (units _grpCaller) select { alive _x && _x in _veh };
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Escape > if veh is broken, OR driver is dead/objNull, OR the caller group leader is dead, abort:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
		// Remove the dynamic helipad:
		deleteVehicle (_data get "helipad");
		// Another crew member tries to take the vehicle control:
		[_tag, _grpVeh, _veh] call THY_fnc_CSWR_TRANSPORT_copilot_takes_control;
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Message:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		// Checking if the delivery point is NOT on the base:
		if ( (_data get "whereToGoPos") distance2d _basePos > _minDisCall ) then {
			_veh vehicleChat format ["%1",
			selectRandom ["Right! Let's do it!", "Okay, that will be fun!", "Solid copy, sir!", "Already! We know this area...", "Alright, here we go!", "Copy! Let's go!"]];
		} else {
			// Message for military context
			if ( _tag isNotEqualTo "CIV" ) then {
				_veh vehicleChat "Wow, it's the base position! Sir, you should call to Extraction team on the next time... Returning to base!";
			// Message for cibilian context
			} else {
				_veh vehicleChat "Let's go back to home...";
			};
			// Flag it:
			_data set ["isDeliveryBase", true];
		};
	};
	// Return:
	_data;
};


THY_fnc_CSWR_TRANSPORT_delivery = {
	// This function takes care of the transport support stage where the caller (player) is already in vehicle, riding the caller group until the requested position.
	// Returns _data: hashMap/array.

	params ["_data", "_grpCaller", "_tag", "_grpVeh", "_veh", "_basePos", "_disReadyLand"];
	private ["_t"];

	// Escape > If support service failed, abort this function, even if the veh still running:
	if ( _data get "isCanceled" ) exitWith { _data };
	// Initial values:
	_t = 0;  // Dont set nil!
	// Waiting the helicopter get some high and distance:
	waitUntil {
		// Breather:
		sleep 5;
		// In case of one or more crew members jump out the veh while landed, no matter the reason:
		if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
			// Make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
			// If veh still in-game:
			if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
				_veh lockDriver false;
				_veh setFuel 0;
			};
		};
		// Condition to break the loop:
		// If engine stopped (blades broken or veh destroyed):
		!isEngineOn _veh ||
		// Caller group is dead:
		!alive leader _grpCaller ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or veh is higher than 10 meters:
		((getPosATL _veh) # 2) > 10;
	};
	// Escape > if veh is alive but it's broken, abort:
	if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
		// Prepare to return:
		_data set ["isCanceled", true];
	};
	// Escape > if veh lost its engine or is destroyed, OR crew driver is dead/objNull, OR there's no more leader on caller group, abort:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
		// Prepare to return:
		_data set ["isCanceled", true];
	};
	// Messages:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		// For military context:
		if ( _tag isNotEqualTo "CIV" ) then {
			// If caller wants to move out there:
			if !(_data get "isDeliveryBase") then {
				leader _grpVeh commandChat format ["Moving %1 at the delivery-point, over!",
				_grpCaller];
			// If caller wants to return to base:
			} else {
				leader _grpVeh commandChat format ["%1The %2 team's with me and we are straight on to the base, over!",
				selectRandom ["", "This is Bird. ", "This is God. ", "This is Eagle. ", "This is Soprano. ", "This is Lammel. "],
				_grpCaller];
			};
		// For civilian context:
		} else {
			leader _grpVeh commandChat format ["Going to take Mr. %1 to the requested location.",
			leader _grpCaller];
		};
	};
	// Waiting the helicopter reaches the delivery position:
	waitUntil {
		// Breather:
		sleep 5;
		// In case of one or more crew members jump out the veh while landed, no matter the reason:
		if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
			// Make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
			// If veh still in-game:
			if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
				_veh lockDriver false;
				_veh setFuel 0;
			};
		};
		// Condition to break the loop:
		// If engine stopped (blades broken):
		!isEngineOn _veh ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or caller group has no leader anymore:
		!alive leader _grpCaller ||
		// Or veh is touching the ground:
		((getPosATL _veh) # 2) <= 0.3 ||
		// Or veh is close enough to the delivery point:
		_veh distance2d (_data get "whereToGoPos") <= _disReadyLand;
	};
	// Escape > if veh is alive but it's broken, abort:
	if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
		// Remove the dynamic helipad:
		deleteVehicle (_data get "helipad");
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Escape > if veh is destroyed, OR its crew is dead, OR veh is touching the ground before to get close from final destination, abort:
	if ( 
		!isEngineOn _veh ||
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || 
		{ ((getPosATL _veh) # 2) <= 0.3 && _veh distance2d (_data get "whereToGoPos") > _disReadyLand } ) exitWith {
		// Force the destruction:
		{ deleteVehicle _x } forEach units _grpVeh;
		_veh setDamage 1;
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Escape > if the caller group is dead (inside the veh), abort:
	if ( !alive leader _grpCaller ) exitWith {
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Land type depends if out there or base:
	driver _veh setCombatBehaviour "CARELESS";
	if !(_data get "isDeliveryBase") then { _veh land "GET OUT" } else { _veh land "LAND" };  // Caution: 'LAND" forces the engine off!
	// Waiting touch the ground on delivery point:
	waitUntil {
		// Breather:
		sleep 5;
		// In case of one or more crew members jump out the veh while landed, no matter the reason:
		if !(_data get "isDeliveryBase") then {
			if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
				// Make them join to an ally group if in the range, including caller group and vehicles:
				[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
				// If veh still in-game:
				if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
					_veh lockDriver false;
					_veh setFuel 0;
				};
			};
		};
		// Conditions:
		// If engine stopped (blades broken):
		!isEngineOn _veh ||
		// Or veh driver is dead/objnull:
		!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
		// Or veh is touching the ground:
		((getPosATL _veh) # 2) <= 0.3;
	};
	// Escape > if veh is alive but it's broken, abort:
	if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Escape > if veh is destroyed, OR its crew is dead, abort:
	if (!alive _veh ||  // CAUTION: don't use engine check here coz, if delivery is at base, the helicopter turns its engine off and would cause an explosion!
		!alive driver _veh ||
		incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS") exitWith {
		// Force the destruction:
		{ deleteVehicle _x } forEach units _grpVeh;
		_veh setDamage 1;
		// Prepare to return:
		_data set ["isCanceled", true];
		// Return:
		_data;
	};
	// Message:
	if ( isEngineOn _veh && alive driver _veh && incapacitatedState (driver _veh) isNotEqualTo "UNCONSCIOUS" ) then {
		if !(_data get "isDeliveryBase") then {
			leader _grpVeh commandChat format ["%1... %2",
			selectRandom ["On ground", "The bird touchesdown", "Here we are"],
			selectRandom ["Up to you, sir!", "Go, go, go!", "Good luck!"]];
		} else {
			_veh vehicleChat format ["%1",
			selectRandom ["Home, sweet home...", "At home, sir!", "That's it! At home, boys..."]];
		};
	};
	// The delivery is finished here if it was at base!
	// Otherwise, for delivery out there, prepare to RTB:
	if !(_data get "isDeliveryBase") then {
		// Waiting the caller group gets out of veh:
		_t = time + CSWR_airTransportWaitTime;
		waitUntil {
			// Breather:
			sleep 5;
			// In case of one or more crew members jump out the veh while landed, no matter the reason:
			if ( (units _grpVeh) findIf { alive _x && isNull objectParent _x } isNotEqualTo -1 ) then {
				// Make them join to an ally group if in the range, including caller group and vehicles:
				[_tag, _grpVeh, 0, 300, 5, false, false, true] call THY_fnc_CSWR_grp_join_to_survive;
				// If veh still in-game:
				if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
					_veh lockDriver false;
					_veh setFuel 0;
				};
			};
			// Condition to break the loop:
			// If engine stopped (blades broken):
			!isEngineOn _veh ||
			// Or veh driver is dead/objnull:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or nobody from caller group is in veh:
			{ alive _x && _x in _veh } count (units _grpCaller) isEqualTo 0 ||
			// Or the time ran out:
			time > _t;
		};
		// Escape > if veh is alive but it's broken, abort:
		if ( [_tag, _veh, _grpVeh, _basePos, _disReadyLand] call THY_fnc_CSWR_TRANSPORT_message_mayday ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > Veh is destroyed, OR veh driver is dead/objNull, abort:
		if ( !isEngineOn _veh || !alive _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ) exitWith {
			// Another crew member tries to take the vehicle control:
			[_tag, _grpVeh, _veh] call THY_fnc_CSWR_TRANSPORT_copilot_takes_control;
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// If the time ran out, it forces the remainder of the caller group to get out:
		if ( time > _t ) then {
			// Forcing the caller group to get out of veh:
			{ moveOut _x } forEach (units _grpCaller) select { alive _x && _x in _veh };
		};
	};
	// Return:
	_data;
};


THY_fnc_CSWR_TRANSPORT_RTB = {
	// This function takes care about the last stage of the transport support service. Once the caller group (player) is dropped on the delivery point or the transport support is canceled,
	// if the veh wasn't at base, the veh starts the way back to its spawn-point position that here is called "base". After its arrival, the veh and its crew is deleted successfully.
	// CRITICAL: if the veh and its crew are alive, this stage MUST be executed, no matter is mission is on-going or canceled!
	// Returns nothing.

	params ["_data", "_grpCaller", "_tag", "_grpVeh", "_veh", "_basePos", "_disReadyLand"];
	private ["_t", "_wp"];

	// Escape > If not at base yet, AND (veh is destroyed OR driver's dead), abort:
	if ( !(_data get "isDeliveryBase") && { !isEngineOn _veh || !alive driver _veh } ) exitWith {
		// If veh still alive:
		if ( alive _veh ) then {
			// Veh config pos-accident:
			_veh lockDriver false;
			_veh setFuel 0;
			// If crew leader is okay and the veh is not in the air:
			if ( alive leader _grpVeh && ((getPosATL _veh) # 2) <= 1 ) then {
				// For them to get out:
				{ moveOut _x } forEach units _grpVeh;
			};
		};
		if ( alive leader _grpVeh ) then {
			// If alive crew, make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
		};
		// Return:
		true;
	};
	// Initial values:
	_t  = 0;  // Dont set nil!
	_wp = [];

	// STEP 1/3 > TRANSPORT TEAM AND CALLER GROUP ON DELIVERY POINT (AND SOON THE TRANSPORT TEAM WILL DO RTB) --------
	// If support was NOT canceled in the first step (Pickup) of the service:
	if !(_data get "wasCanceledEarlierAtBase") then {
		// Delivery point is NOT at base:
		if !(_data get "isDeliveryBase") then {
			// If support is NOT canceled:
			if !(_data get "isCanceled") then {
				// To avoid players get in again:
				_veh setVehicleLock "LOCKEDPLAYER";
				// Message:
				if ( alive _veh && alive driver _veh ) then {
					// For military context:
					if ( _tag isNotEqualTo "CIV" ) then {
						leader _grpVeh commandChat format ["%1! %2!",
						selectRandom ["The package has been delivered", "The ground team has been placed"],
						selectRandom ["Returning to base", "Bird's returning to nest"]];
					// For civilian context:
					} else {
						leader _grpVeh commandChat format ["Mr. %1 on the ground. Helicopter returning to the heliport!", leader _grpCaller];
					};
				};
			// If support WAS CANCELED:
			} else {
				// Message:
				if ( isEngineOn _veh && alive driver _veh ) then {
					// For military context:
					if ( _tag isNotEqualTo "CIV" ) then {
						leader _grpVeh commandChat "Our mission was aborted. Returning to base, over!";
					// For civilian context:
					} else {
						leader _grpVeh commandChat "Apparently, the plan has been changed. Returning to heliport...";
					};
				};
			};

			// STEP 2/3 > TRANSPORT TEAM RETURNING TO BASE  ------------------------------------------------------------------
			// Vehicle config:
			driver _veh setCombatBehaviour "CARELESS";  // Gunner still open fire.
			// Creating the waypoint to the base's helipad position:
			_wp = _grpVeh addWaypoint [_basePos, 0];
			_wp setWaypointCombatMode "YELLOW";
			_wp setWaypointType "MOVE";
			_grpVeh setCurrentWaypoint _wp;
			// Waiting the Transport team to be back at base:
			waitUntil {
				// Breather:
				sleep 10;
				// Condition to break the loop:
				// If engine stopped (blades broken):
				!isEngineOn _veh ||
				// Or veh driver is dead/objnull:
				!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
				// Or veh is close enough from the base:
				_veh distance2d _basePos < _disReadyLand;
			};
			// Landing:
			_veh land "LAND";  // Caution: 'LAND" forces the engine off!

			// STEP 3/3 > TRANSPORT TEAM AT BASE  ----------------------------------------------------------------------------
			// Waiting until touch the ground:
			waitUntil {
				// Breather:
				sleep 10;
				// Condition to break the loop:
				// If engine stopped (blades broken):
				!isEngineOn _veh ||
				// Or veh driver is dead/objnull:
				!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
				// Or veh is touching the ground:
				((getPosATL _veh) # 2) <= 0.3;
			};
			// Escape > Veh is destroyed, OR veh driver is dead/objNull, abort:
			if ( !alive _veh || !alive driver _veh ) exitWith { true };  // CAUTION: don't check the engine here coz it's expected to be turned it off.
			// Message of mission completed:
			if !(_data get "isCanceled") then {
				// For military context:
				if ( _tag isNotEqualTo "CIV" ) then {
					if ( alive driver _veh && leader _grpVeh distance2d _basePos < _disReadyLand ) then {
						leader _grpVeh commandChat "We are back to base! Our mission's complete, over!";
					};
				};
				// For civilian context:
				// The pilot doesn't care if civilian knows what's going on!
			};
		};  // ends of NOT "isDeliveryBase".
		// Deleting the dynamic helipad:
		//deleteVehicle (_data get "helipad");  // Not needed!
	};  // ends of NOT "wasCanceledEarlierAtBase".
	// Turn off engine:
	_veh engineOn false;
	// Finishing some details:
	{ deleteVehicle _x } forEach units _grpVeh;  // deleteVehicleCrew _veh; -- it would delete your AI group members too.
	// Just for make sure, get out for everyone accidentally still in veh:
	{ moveOut (_x # 0) } forEach (fullCrew _veh);
	_veh setVehicleLock "LOCKED";
	// A short time to players take back something added in vehicle cargo:
	sleep 30;
	deleteVehicle _veh;
	// Return:
	true;
};


THY_fnc_CSWR_TRANSPORT_booking_and_wait = {
	// This function has 2 actions:
	// 1) it adds the caller group (a player group) to the _globalData (CSWR_suprtTranspAirData or CSWR_suprtExtractAirData) if that player group didn't receive it before. In other words, a group can take just one call at a time;
	// 2) once a caller has the support assigned, it waits the caller to call for it;
	// Only after that, the support resource is spawned to execute the destination: THY_fnc_CSWR_go_dest_TRANSPORT or THY_fnc_CSWR_go_dest_EXTRACTION.
	// Returns _grpCaller: group.

	params ["_side", "_tag", "_feedbackName", "_globalData", "_class"];
	private ["_grpCaller", "_playersLeaders", "_player", "_localData", "_grpsWithSuprt", "_isToUseSuprt", "_idx", "_hasSuprtOwner", "_cooldown"];

	// Case need to restart the owner check:
	scopeName "restartownercheck";
	// Initial values:
	_grpCaller      = grpNull;
	_playersLeaders = [];
	_player         = objNull;
	_localData      = [];
	_grpsWithSuprt  = [];  // Groups with THIS support TYPE!
	_isToUseSuprt   = false;
	_idx            = -1;
	// Declarations:
	_hasSuprtOwner = false;  // It means if this resource already has a player as owner for this resource be aware, waiting to be called.
	_cooldown      = 45;  // Lower values is bad to the performance.

	// STEP 1/2 > FIND A GROUP TO GIVE THIS RESOURCE ------------------------------------------------------------------
	// This support resource searches for a group without this resource type:
	while { !_hasSuprtOwner } do {
		// For Multiplayer:
		if isMultiplayer then {
			// Select only player leader of the same side:
			_playersLeaders = (allPlayers - entities "HeadlessClient_F") select { side _x isEqualTo _side && _x isEqualTo leader (group _x) };
		// For Single-player:
		} else {
			_playersLeaders = [player];
		};
		// By the side, check those groups that a player is the leader and don't have the support resource yet:
		{  // forEach _playersLeaders:
			// Breather:
			sleep 0.25;
			// Internal declarations:
			_player        = _x;
			_localData     = missionNamespace getVariable _globalData;  // Returns [ [side, [grpArray1, grpArray3, ...]], ..., ..., ... ];  // grpArray1 = [_isToUseSuprt, grp1];
			_grpsWithSuprt = _localData get _side;  // returns [grpArray1, grpArray3, ...] or array empty;
			// If there's something to check:
			if ( _grpsWithSuprt isNotEqualTo [] ) then {
				// If the group has the same support resource type, skip to the next one:
				if ( _grpsWithSuprt findIf { group _player isEqualTo (_x # 1) } isNotEqualTo -1 ) then { continue };
			};
			// Add the support request option for the group's leader:
			// calling a custom subclass (requestTranspHeli) of built-in class (CfgCommunicationMenu) declared in description.ext.
			[_player, _class] call BIS_fnc_addCommMenuItem;
			// Defining the support owner's group:
			_grpCaller = group _player;
			// Add the group to the list:
			_grpsWithSuprt pushBack [_isToUseSuprt, _grpCaller];  // _isToUseSuprt must be 'false' here!
			// In _localData, search for the index/key SIDENAME and, then, replace the value for _grpsWithSuprt content:
			_localData set [_side, _grpsWithSuprt];
			// Broadcasting the update:
			missionNamespace setVariable [_globalData, _localData, true];
			// Flag it to break the while-loop:
			_hasSuprtOwner = true;
			// Debug:
			if CSWR_isOnDebug then {
				["%1 SUPPORT RESOURCE > %2 player leader from '%3' received a %4 resource.",
				CSWR_txtDebugHeader, _tag, _grpCaller, _feedbackName] call BIS_fnc_error; sleep 2;
				// More debug:
				if CSWR_isOnDebugSupport then {
					["%1 SUPPORT RESOURCE > Groups with %2 available = %3",
					CSWR_txtDebugHeader, _globalData, missionNamespace getVariable _globalData] call BIS_fnc_error; sleep 2;
				};
			};
		} forEach _playersLeaders;
		// Breather if new looping is needed:
		if !_hasSuprtOwner then {
			// Debug:
			if ( CSWR_isOnDebug && CSWR_isOnDebugSupport ) then {
				["%1 SUPPORT RESOURCE > A %2 %3 has NO group owner yet (it's okay). Next try in %4s...",
				CSWR_txtDebugHeader, _tag, _feedbackName, _cooldown] call BIS_fnc_error;
			};
			// Breather:
			sleep _cooldown;
		};
	};  // While loop ends.

	// STEP 2/2 > WAITING THE CALLER GROUP TO REQUEST SUPPORT --------------------------------------------------------
	// Waiting the player's leader request support via description.ext (THY_fnc_CSWR_support_transp_by_air or THY_fnc_CSWR_support_extract_by_air):
	waitUntil {
		// Breather for next loop check:
		sleep 15;
		// Check if the description.ext updated the boolean value in grpArray:
		_localData = missionNamespace getVariable _globalData;
		_grpsWithSuprt = _localData get _side;  // returns [grpArray1, grpArray3, ...]
		_idx = _grpsWithSuprt findIf { _grpCaller isEqualTo (_x # 1) };
		// Case something goes wrong the _i
		if ( _idx isEqualTo -1 ) exitWith {
			if CSWR_isOnDebug then {
				systemChat format ["%1 SUPPORT RESOURCE > A non-used %2 %3 resource returned to be available!",
				CSWR_txtDebugHeader, _tag, _feedbackName];
				sleep 2;
			};
			breakTo "restartownercheck";
		};
		_isToUseSuprt = (_grpsWithSuprt # _idx) # 0;  // Returns only the boolean value: [_isToUseSuprt, grp1];
		// Condition to break the loop:
		_isToUseSuprt;
	};
	// Return:
	_grpCaller;
};


THY_fnc_CSWR_TRANSPORT_grp_bookingUndo = {
	// This function removes the player's group from the _globalData (CSWR_suprtTranspAirData or CSWR_suprtExtractAirData), making the group able to receive the resource again if it's still available.
	// Returns nothing.

	params ["_grp", "_globalData"];
	private ["_localData", "_grpsWithSuprt", "_idx"];

	// Escape:
	if ( isNull _grp ) exitWith { true };
	// Take the current version of the  the player's group from the support list:
	_localData = missionNamespace getVariable _globalData;
	// Take only those side groups that have this resource:
	_grpsWithSuprt = _localData get (side _grp);  // returns [grpArray1, grpArray3, ...]
	// Figure out the index of the player's group in _grpsWithSuprt list:
	_idx = _grpsWithSuprt findIf { _grp isEqualTo (_x # 1) };  // [_isToUseSuprt, grp1];
	// Remove the grpArray from the list of those groups with support resource:
	_grpsWithSuprt deleteAt _idx;
	// Update the entire side with the _grpsWithSuprt update:
	_localData set [side _grp, _grpsWithSuprt];
	// Broading the update:
	missionNamespace setVariable [_globalData, _localData, true];
	// Return:
	true;
};


THY_fnc_CSWR_TRANSPORT_caller_pos = {
	// CLIENT-SIDE function, and it's called by server-side: THY_fnc_CSWR_TRANSPORT_provide_pos_using_map.
	// This function asks for the leader of caller group its cursor position over the map by click.
	// Returns _pos: array. Positon where the caller group leader wants to go.

	params ["_grpCaller"];
	private ["_pos"];

	// Making sure player exist in multiplayer:
	waitUntil { sleep 0.1; !isNull player };
    // Initial values:
    _pos = [];
	// Escape > If the machine has no interface, or the player is dead, or the player is not the caller group leader, abort:
	if ( !hasInterface || !alive player || player isNotEqualTo leader _grpCaller ) exitWith { _pos };
	// Forcing player to open map:
	openMap [true, true];
	// Check the click pos on map:
	addMissionEventHandler [
        "MapSingleClick", {
			params ["_units", "_pos", "_alt", "_shift"];
			// Defining:
			player setVariable ["whereToGoPos", _pos, true];
			// Closes the player map normally:
			openMap [false, false];
			// Ends the event handler:
			removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
		}
	];
	// Waiting for caller to provide position:
	waitUntil { sleep 1; !alive player || (leader _grpCaller getVariable "whereToGoPos") isNotEqualTo [] };
	// prepare to return:
	_pos = leader _grpCaller getVariable "whereToGoPos";	
	// Return:
	_pos;
};


THY_fnc_CSWR_TRANSPORT_provide_pos_using_map = {
	// This function requests for the player where they want to go, and creates the helicopter waypoint over that position.
	// Returns _data: hashMap/array. If returns an empty array, it's coz something went wrong.

	params ["_data", "_tag", "_grpCaller", "_grpVeh", "_veh", "_basePos", "_spaceToLand", "_minDisCall"];
	private ["_isTryAgain", "_t", "_requestedPos", "_helipad", "_wp", "_searchRange", "_txt1"];

	// Initial values:
	_isTryAgain   = nil;
	_t            = 0;  // Dont set nil!
	_requestedPos = [];
	_helipad      = "";
	_wp           = [];
	// Declarations:
	_searchRange = 80;
	_txt1 = "Please, provide another position";
	// If _veh still working, the current driver still alive, and the player is in the vehicle, keep looping:
	// Critical: don't check whether leader is in veh coz if leader dies in veh and the current leader is out, it would break the following logic of leadership transfering to another caller group unit!
	while { isEngineOn _veh && alive driver _veh && alive leader _grpCaller} do {
		// Internal initial values:
		leader _grpCaller setVariable ["whereToGoPos", [], true];
		_isTryAgain = false;
		// Intruction message:
		_veh vehicleChat format ["%1",
		selectRandom ["Where do we go, sir?", "Where should we go, sir?", "What's the next point, sir?", "Sir, we need the delivery-point coordenates!", "Sir, what's the coords?"]];
		["CLICK OVER THE AREA YOU WANT TO GO!"] remoteExec ["systemChat", leader _grpCaller];
		// To run only in caller group leader's machine:
		_requestedPos = [_grpCaller] call THY_fnc_CSWR_TRANSPORT_caller_pos;
		// Waiting for caller to provide position:
		waitUntil { sleep 1; !alive leader _grpCaller || _requestedPos isNotEqualTo [] };
		// Timeout:
		_t = time + CSWR_airTransportWaitTime;
		// Confirming caller group leader is in veh:
		waitUntil {
			// Breather:
			sleep 2;
			// Debug > Showing caller group info:
			[_tag, _grpVeh, _veh, _grpCaller, _t] call THY_fnc_CSWR_debug_supportTransp;
			// Condition to break the loop:
			// If engine stopped (blades broken):
			!isEngineOn _veh ||
			// Or veh driver is dead/objnull:
			!alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ||
			// Or if the original caller group leader dies, it makes the veh waits a possible new leader that still coming to the veh position:
			leader _grpCaller in _veh ||
			// Or if the time ran out:
			time > _t;
		};
		// Escape > if veh is destroyed, OR crew driver is dead/objNull, OR caller leader, abort:
		if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Escape > If helicopter still landed, and the time ran out:
		if ( ((getPosATL _veh) # 2) < 1 && time > _t ) exitWith {
			// Force the caller group members already in veh to get out:
			{ moveOut _x } forEach (units _grpCaller) select { alive _x && _x in _veh };
			// Message:
			if ( alive _veh && alive driver _veh ) then {
				// Message for military context
				if ( _tag isNotEqualTo "CIV" ) then {
					leader _grpVeh commandChat "Sorry boys, we CAN'T wait you all forever. Returning to base!";
				// Message for civilian context
				} else {
					leader _grpVeh commandChat "Sorry, sir. I CAN'T wait you all day long. Returning to heliport!";
				};
			};
			// Prepare to return:
			_data set ["isCanceled", true];
		};
		// Validation > Check if caller requested pos is okay to land:
		 _requestedPos = [
			_requestedPos,  // center
			0,  // minDist
			_searchRange,  // maxDist
			_spaceToLand,  // objDist
			0,  // waterMode (0=land / 1=land+water / 2=water)
			0.25,  // maxGrad (0=absolutely flat, the checking is ignored / 1=absolutely steep, a person would use hands to walking up)
			0,  // shoreMode (0=does not have to be at a shore / 1=must be at a shore)
			[],  // blacklistPos
			[]  // defaultPos (when no position is found)
		] call BIS_fnc_findSafePos; // Returns only [x,y] when something is found!
		// If BIS_fnc_findSafePos appends a Z pos in the _requestedPos array when nothing was found:
		if ( count _requestedPos isEqualTo 3 ) then {
			// Flag it to try again:
			_isTryAgain = true;
			// Message:
			_veh vehicleChat format ["Sir, even checking %1m around, that COORDS is NO GOOD ENOUGH to drop you out. %2...",
			_searchRange, _txt1];
		};
		// Validation > Forbidden position > too close:
		if ( _requestedPos distance2d (getPosATL _veh) < _minDisCall ) then {
			// Flag it to try again:
			_isTryAgain = true;
			// Message:
			_veh vehicleChat format ["Sir, this coordenates are TOO CLOSE. %1...",
			_txt1];
		} else {
			// Validation > Forbidden position > on water:
			if ( surfaceIsWater _requestedPos ) then {
				// Flag it to try again:
				_isTryAgain = true;
				// Message:
				_veh vehicleChat format ["Sir, I CAN'T leave you ON WATER. %1...",
				_txt1];
			};
		};
		// Approved to leave the loop:
		if !_isTryAgain then { break };
		// In case a new looping, breather:
		sleep 3;  // It avoids "map blinking" on player screen!
	};  // while-loop ends.
	// Escape > something bad happened, it's already canceled so just abort to return now:
	if ( !isEngineOn _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller ) exitWith {
		// Debug > Turning On if Debug Heli was On before:
		[_tag, _grpVeh, _veh, _grpCaller, _t, 2, _wasDebugHeliOn] call THY_fnc_CSWR_debug_supportTransp;
		// Return:
		_data;
	};
	// If everything is fine:
	// Creating the waypoint to the Delivery point:
	_helipad = (_data get "helipadType") createVehicle _requestedPos;
	_wp = _grpVeh addWaypoint [_requestedPos, 0];
	_wp setWaypointType "MOVE";
	_grpVeh setCurrentWaypoint _wp;
	// Prepare to return:
	_data set ["whereToGoPos", _requestedPos];
	_data set ["helipad", _helipad];
	// Check if the delivery point is at base:
	if ( _requestedPos distance2d _basePos < _minDisCall ) then { _data set ["isDeliveryBase", true] };
	// Return:
	_data;
};


THY_fnc_CSWR_TRANSPORT_copilot_takes_control = {
	// This function prepares another crewman to take driver seat if the original driver is lost and the vehicle is not broken or destroyed.
	// Returns nothing.

	params ["_tag", "_grpVeh", "_veh"];
	private ["_copilot"];

	// Escape:
	if ( isNull _grpVeh ) exitWith { true };
	// Initial values:
	_copilot = objNull;
	// If there's another crew alive:
	if ( (units _grpVeh) select { alive _x } isNotEqualTo [] ) then {
		// If veh not broken:
		if ( isEngineOn _veh ) then {
			// Unlock the seat:
			_veh lockDriver false;
			(driver _veh) moveOut _veh;
			_veh engineOn true;
			// Copilot takes control:
			_copilot = (((units _grpVeh) select { alive _x && lifeState _x isNotEqualTo "UNCONSCIOUS" }) # 0);
			_copilot setCombatBehaviour "CARELESS";
			_copilot assignAsDriver _veh;
			_copilot moveInDriver _veh;
			waitUntil { sleep 1; !alive _veh || !alive _copilot || !isNull driver _veh };
			// Lock the seat again:
			_veh lockDriver true;
		// Veh is broken:
		} else {
			// Make them join to an ally group if in the range, including caller group and vehicles:
			[_tag, _grpVeh, 0, 300, 5, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
			// If veh still in-game:
			if ( alive _veh ) then {  // The idea is don't provide a not planned veh for players, but without lock seats in case the player fells that into it is a safer place for any reason!
				_veh lockDriver false;
				_veh setFuel 0;
			};
		};
	} else {
		// If vehicle still in-game and landed:
		if ( alive _veh && ((getPosATL _veh) # 2) <= 0.3 ) then {
			_veh engineOn false;
			_veh lockDriver false;
			_veh setFuel 0;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_TRANSPORT_message_mayday = {
	// This function just sends a mayday message on command chat.
	// Returns _isMayday: bool.

	params ["_tag", "_veh", "_grpVeh", "_basePos", "_disReadyLand"];
	private ["_isMayday"];

	// Initial values:
	_isMayday = false;
	// Escape:
	if ( !alive _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" ) exitWith { _isMayday };
	// If veh is not in RTB (where it need to turn off engine), AND (veh lost power or lost rotor tail):
	if ( _basePos distance2d _veh > _disReadyLand && { !isEngineOn _veh || _veh getHitPointDamage "HitVRotor" > 0.8 } ) then {
		// Flag it:
		_isMayday = true;
		// For military context:
		if ( _tag isNotEqualTo "CIV" ) then {
			leader _grpVeh commandChat format ["Mayday, Mayday, Mayday! %1",
			selectRandom ["", "Bird's down! Bird's down!", "Come on, baby, hang on, hang on!", "... No good, no good...!", "... NO, NO, NO, COME ON! ..."]];
		// For civilian context:
		} else {
			leader _grpVeh commandChat format ["%1",
			selectRandom ["Mayday, Mayday, Mayday!", "Oh my God!"]];
		};
		// Waiting the veh be on the ground:
		waitUntil { sleep 5; !isEngineOn _veh || !alive driver _veh || ((getPosATL _veh) # 2) <= 0.3 };
		// If veh still in-game:
		if ( alive _veh ) then {
			_veh lockDriver false;
			_veh setFuel 0;
			// For them to get out:
			{ moveOut _x } forEach units _grpVeh;
		};
		// Make them join to an ally group if in the range, including caller group and vehicles:
		[_tag, _grpVeh, 0, 300, 2, true, false, true] call THY_fnc_CSWR_grp_join_to_survive;
	};
	// Return:
	_isMayday;
};


THY_fnc_CSWR_support_extract_by_air = {
	// This function is called if a player request a Extraction Support by Communication Menu (defined in description.ext file).
	// parameters = _this = ["caller", "pos", "target", "is3D", "id"] e.g [bis_01, [1234,5678], objNull, true, 1]
	// Important: this function cannot be suspended (sleep, waitUntil, ...) once it's using 'call' and not 'spawn' method in description.ext.
	// Returns nothing.

	if !isServer exitWith {};  // Just in case once this function is called through description.ext and I'm not sure if client machine could read it.

	//params ["_unit"];
	private ["_player", "_globalData", "_grpsWithSuprt", "_idx"];

	// Declarations:
	_player     = _this # 0;  // caller.
	_globalData = missionNamespace getVariable "CSWR_suprtExtractAirData";
	// Take only those side groups that have this resource:
	_grpsWithSuprt = _globalData get (side _player);  // returns [grpArray1, grpArray3, ...]
	// Figure out the index of the player's group in _grpsWithSuprt list:
	_idx = _grpsWithSuprt findIf { group _player isEqualTo (_x # 1) };  // [_isToUseSuprt, grp1];
	// Update the grpArray, authorizing them to use the support, changing the _isToUseSuprt value to 'true':
	_grpsWithSuprt set [_idx, [true, group _player]];
	// Update the entire side with the _grpsWithSuprt update:
	_globalData set [side _player, _grpsWithSuprt];
	// Broading the update:
	missionNamespace setVariable ["CSWR_suprtExtractAirData", _globalData, true];
	// Return:
	true;
};


THY_fnc_CSWR_support_transp_by_air = {
	// This function is called if a player request a Transport Support by Communication Menu (defined in description.ext file).
	// parameters = _this = ["caller", "pos", "target", "is3D", "id"] e.g [bis_01, [1234,5678], objNull, true, 1]
	// Important: this function cannot be suspended (sleep, waitUntil, ...) once it's using 'call' and not 'spawn' method in description.ext.
	// Returns nothing.

	if !isServer exitWith {};  // Just in case once this function is called through description.ext and I'm not sure if client machine could read it.

	//params ["_unit"];
	private ["_player", "_globalData", "_grpsWithSuprt", "_idx"];

	// Declarations:
	_player     = _this # 0;  // caller.
	_globalData = missionNamespace getVariable "CSWR_suprtTranspAirData";
	// Take only those side groups that have this resource:
	_grpsWithSuprt = _globalData get (side _player);  // returns [grpArray1, grpArray3, ...]
	// Figure out the index of the player's group in _grpsWithSuprt list:
	_idx = _grpsWithSuprt findIf { group _player isEqualTo (_x # 1) };  // [_isToUseSuprt, grp1];
	// Update the grpArray, authorizing them to use the support, changing the _isToUseSuprt value to 'true':
	_grpsWithSuprt set [_idx, [true, group _player]];
	// Update the entire side with the _grpsWithSuprt update:
	_globalData set [side _player, _grpsWithSuprt];
	// Broading the update:
	missionNamespace setVariable ["CSWR_suprtTranspAirData", _globalData, true];
	// Return:
	true;
};


THY_fnc_CSWR_debug_supportTransp = {
	// This function just check the caller group (player) situation after they request a transport support.
	// Returns nothing.

	params ["_tag", "_grpVeh", "_veh", "_grpCaller", "_t", ["_whatToDo", 0], ["_wasDebugHeliOn", false]];
	//private [""];

	// Escape > If one of these debugs are off, abort:
	if ( !CSWR_isOnDebug || !CSWR_isOnDebugSupport ) exitWith { true };
	// Escape > If is not trying to turn off this debug, AND (veh is destroy, or driver is dead, or caller is dead), abort:
	if ( _whatToDo isNotEqualTo 2 && { !alive _veh || !alive driver _veh || incapacitatedState (driver _veh) isEqualTo "UNCONSCIOUS" || !alive leader _grpCaller } ) exitWith { true };
	// Check case:
	switch _whatToDo do {
		// Do nothing, just read debug message:
		case 0: {};
		// Just turn On this debug, turning Off the Debug Helicopter in case it's On:
		case 1: { if CSWR_isOnDebugHeli then { missionNamespace setVariable ["CSWR_isOnDebugHeli", false, true] } };
		// Just turn Off this debug, turning On the Debug Helicopter if On before:
		case 2: { if _wasDebugHeliOn then { missionNamespace setVariable ["CSWR_isOnDebugHeli", true, true] } };
	};
	// Escape > after case selected:
	if ( _whatToDo in [1, 2] ) exitWith { true };
	// Debug message:
	["%1 SUPPORT RESOURCE > %2 %3 %4 > Members of %5 in vehicle: %6 | Entire group? = %7 | Timeout? = %8",
	CSWR_txtDebugHeader,
	_tag,
	_grpVeh,
	(_veh call BIS_fnc_objectType) # 1,
	_grpCaller,
	{ alive _x && _x in _veh } count (units _grpCaller),
	({ alive _x } count (units _grpCaller)) isEqualTo ({ _x in _veh } count (units _grpCaller)),
	if (_t isNotEqualTo 0) then {time > _t} else {"Doesn't exist now!"}] call BIS_fnc_error;
	// Return:
	true;
};


THY_fnc_CSWR_debug = {
	// This function shows some numbers to the mission editor when debugging.
	// Returns nothing.

	//params [];
	private ["_playableBLU", "_playableOPF", "_playableIND", "_playableCIV", "_aliveAll", "_aliveBLU", "_aliveOPF", "_aliveIND", "_aliveCIV"];

	// Declarations:
	_playableBLU = { alive _x && side _x isEqualTo BLUFOR } count playableUnits;
	_playableOPF = { alive _x && side _x isEqualTo OPFOR } count playableUnits;
	_playableIND = { alive _x && side _x isEqualTo INDEPENDENT } count playableUnits;
	_playableCIV = { alive _x && side _x isEqualTo CIVILIAN } count playableUnits;
	_aliveAll = { alive _x } count (allUnits - playableUnits);
	_aliveBLU = ({ alive _x } count units BLUFOR)      - _playableBLU;
	_aliveOPF = ({ alive _x } count units OPFOR)       - _playableOPF;
	_aliveIND = ({ alive _x } count units INDEPENDENT) - _playableIND;
	_aliveCIV = ({ alive _x } count units CIVILIAN)    - _playableCIV;
	// Debug monitor:
	hintSilent format [
		"\n" +
		"\n--- CSWR DEBUG MONITOR ---" +
		"\n" +
		"\nAIs in Spawn Delay: %1" +
		"\nAIs in-game: %2" + 
		"\n-----" +
		"\nBLU AI units in-game: %3" +
		"\nOPF AI units in-game: %4" +
		"\nIND AI units in-game: %5" +
		"\nCIV AI units in-game: %6" +
		"\n\n",
		CSWR_spwnDelayQueue,
		_aliveAll,
		_aliveBLU,
		_aliveOPF,
		_aliveIND,
		_aliveCIV
	];
	// CPU breather:
	sleep 10;
	// Return:
	true;
};
// Return:
true;
