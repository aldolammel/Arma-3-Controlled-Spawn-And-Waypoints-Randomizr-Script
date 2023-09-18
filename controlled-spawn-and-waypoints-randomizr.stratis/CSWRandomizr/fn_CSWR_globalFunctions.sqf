// CSWR v5.0
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------


// STRUCTURE OF A FUNCTION BY THY:
/* THY_fnc_CSWR_name_of_the_function = {
	// This function <doc string>.
	// Returns nothing <or varname + type>

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
	// This function splits the marker's name to check if the name has the basic structure for further validations.
	// Returns _mkrNameStructure: array

	params ["_mkrName", "_prefix", "_spacer"];
	private ["_mkrNameStructureRaw", "_txt1", "_mkrNameStructure", "_spacerAmount"];

	// Initial values:
	_mkrNameStructure = [];
	// Errors handling:
		// reserved space.
	// Escape:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
	_txt1 = format ["CSWR markers must have their structure names like '%1%2SPWN%2BLU%2anynumber' or '%1%2DEST%2PUBLIC%2anynumber' or '%1%2SPWN%2OPF%2anynumber' or '%1%2DEST%2IND%2anynumber' for example.", _prefix, _spacer];
	// check if the object name has more than one _spacer character in its string composition:
	_mkrNameStructureRaw = _mkrName splitString "";
	_spacerAmount = count (_mkrNameStructureRaw select {_x find _spacer isEqualTo 0});  // counting how many times the same character appers in a string.
	// spliting the object name to check its structure:
	_mkrNameStructureRaw = _mkrName splitString _spacer;
	// if the _spacer is NOT been used correctly:
	if ( _spacerAmount != 3 ) then {
		// Warning message:
		["%1 MARKER '%2' > It's not using enough or using too much the spacer character '%3'. %4", CSWR_txtWarningHeader, toUpper _mkrName, _spacer, _txt1] call BIS_fnc_error; sleep 5;
	};
	// Updating to return, converting all strings to uppercase:
	{ _mkrNameStructure pushBack toUpper _x } forEach _mkrNameStructureRaw;
	// Return:
	_mkrNameStructure;
};


THY_fnc_CSWR_marker_checker = {
	// This function checks if the marker (spawn or destination) exists and if it's inside map borders.
	// Return _isValid: bool.

	params ["_mkr"];
	private ["_isValid", "_mkrPos", "_mkrPosA", "_mkrPosB", "_txt1"];

	// Initial values:
	_isValid = false;
	_mkrPos = [];
	_mkrPosA = nil;
	_mkrPosB = nil;
	// Errors handling:
		// reserved space.
	// Escape:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
	_txt1 = format ["MARKER '%1' > This is in an invalid position and will be ignored until its position is within the map borders.", toUpper _mkr];

	// If the marker has a color, it's because the marker exists LOL:
	if ( (getMarkerColor _mkr) isNotEqualTo "" ) then {
		_mkrPos = markerPos _mkr;
		_mkrPosA = _mkrPos # 0;
		_mkrPosB = _mkrPos # 1;
		// Check if the marker is out of the map edges:
		if ( (_mkrPosA >= 0) && (_mkrPosB >= 0) && (_mkrPosA <= worldSize) && (_mkrPosB <= worldSize) ) then {
			// Update to return:
			_isValid = true;
		// Otherwise, if not on map area:
		} else {
			// Warning message:
			["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
		};
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_marker_name_section_type = {
	// This function checks the second section (mandatory) of the marker's name, validating if the section is a valid type of marker (spawn or destination).
	// Returns _mkrType: when valid, type tag as string. When invalid, an empty string ("").

	params ["_mkrNameStructure", "_mkr", "_prefix", "_spacer"];
	private ["_mkrType", "_spwnTypes", "_destTypes", "_allTypesAvailable", "_mkrTypeToCheck", "_txt1"];

	// Initial values:
	_mkrType = "";
	// Escape:
		// reserved space.
	// Declarations:
	_spwnTypes = ["SPAWN", "SPAWNVEH", "SPAWNHELI", "SPAWNPARADROP"];
	_destTypes = ["MOVE", "WATCH", "OCCUPY", "HOLD"];
	_allTypesAvailable = _spwnTypes + _destTypes;
	_mkrTypeToCheck = _mkrNameStructure # 1;
	// Debug texts:
	_txt1 = format ["CSWR markers must have their structure names like '%1%2SPWN%2BLU%2anynumber' or '%1%2DEST%2PUBLIC%2anynumber' or '%1%2SPWN%2OPF%2anynumber' or '%1%2DEST%2IND%2anynumber' for example.", _prefix, _spacer];
	// Errors handling:
	if ( count _mkrNameStructure < 2 ) exitWith {  // cswr_spwn_blu_1   or   cswr_dest_public_1
		["%1 MARKER '%2' > The TYPE TAG looks missing. %3", CSWR_txtWarningHeader, toUpper _mkr, _txt1] call BIS_fnc_error; sleep 5;
		// Returning:
		_mkrType;
	};
	// If the marker type is valid:
	if ( _mkrTypeToCheck in _allTypesAvailable ) then {
		// Update to return:
		_mkrType = _mkrTypeToCheck;
	// If not valid, warning message:
	} else {
		["%1 MARKER '%2' > The TYPE TAG looks wrong. There's no any '%3' type available. The type tags are: %4.", CSWR_txtWarningHeader, toUpper _mkr, _mkrTypeToCheck, _allTypesAvailable] call BIS_fnc_error; sleep 5;
	}; 
	// Return:
	_mkrType;
};


THY_fnc_CSWR_marker_name_section_owner = {
	// This function checks the third section (mandatory) of the marker's name, validating who is the marker's owner.
	// Returns _mkrOwner: when valid, owner tag as string. When invalid, an empty string ("").

	params ["_mkrNameStructure", "_mkr", "_prefix", "_spacer", "_isOwnerForSpwn"];
	private ["_txt1", "_mkrOwner", "_allOwnersAvailable", "_mkrOwnerToCheck"];

	// Initial values:
	_mkrOwner = "";
	_allOwnersAvailable = [];
	// Escape:
		// reserved space.
	// Declarations:
	if _isOwnerForSpwn then {
		// If it's about owners for spawnpoints:
		_allOwnersAvailable = ["BLU", "OPF", "IND", "CIV"];
	} else {
		// If it's about owners for destinations:
		_allOwnersAvailable = ["BLU", "OPF", "IND", "CIV", "PUBLIC"];
	};
	_mkrOwnerToCheck = _mkrNameStructure # 2;  // exemplo: cswr_spwn_blu_1
	// Debug texts:
	_txt1 = format ["CSWR markers must have their structure names like '%1%2SPWN%2BLU%2anynumber' or '%1%2DEST%2PUBLIC%2anynumber' or '%1%2SPWN%2OPF%2anynumber' or '%1%2DEST%2IND%2anynumber' for example.", _prefix, _spacer];
	// Errors handling:
	if ( count _mkrNameStructure < 3 ) exitWith {  // cswr_spwn_blu_1   or   cswr_dest_public_1
		["%1 MARKER '%2' > The OWNER TAG looks missing. %3", CSWR_txtWarningHeader, toUpper _mkr, _txt1] call BIS_fnc_error; sleep 5;
		// Returning:
		_mkrOwner;
	};
	// If the owner is valid:
	if ( _mkrOwnerToCheck in _allOwnersAvailable ) then {
		// Updating to return:
		_mkrOwner = _mkrOwnerToCheck;
	// If NOT valid, warning message:
	} else {
		["%1 MARKER '%2' > The OWNER TAG looks wrong. There's no '%3' option available. Meanwhile this marker is ignored, here's the options: %4", CSWR_txtWarningHeader, toUpper _mkr, _mkrOwnerToCheck, _allOwnersAvailable] call BIS_fnc_error; sleep 5;
	};
	// Return:
	_mkrOwner;
};


THY_fnc_CSWR_marker_name_section_number = {
	// This function checks the last section (mandatory) of the area marker's name, validating if the section is numeric;
	// Returns _isNumber: bool.

	params ["_mkrNameStructure", "_mkr", "_prefix", "_spacer"];
	private ["_isNumber", "_index", "_txt1", "_itShouldBeNumeric"];

	// Initial values:
	_isNumber = false;
	_index = nil;
	// Escape:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
	_txt1 = format ["CSWR markers must have their structure names like '%1%2SPWN%2BLU%2anynumber' or '%1%2DEST%2PUBLIC%2anynumber' or '%1%2SPWN%2OPF%2anynumber' or '%1%2DEST%2IND%2anynumber' for example.", _prefix, _spacer];
	// Errors handling:
	if ( count _mkrNameStructure < 4 ) exitWith {  // cswr_spwn_blu_1   or   cswr_dest_public_1
		["%1 MARKER '%2' > The NUMBER TAG looks missing. %3", CSWR_txtWarningHeader, toUpper _mkr, _txt1] call BIS_fnc_error; sleep 5;
		// Returning:
		_isNumber;
	};
	// Number validation:
	if ( count _mkrNameStructure == 4 ) then { _index = 3 };  // it's needed because marker names can have 4 or 5 sections (edited: not anymore), depends if the xxxxxxxxx tag is been used.
	//if ( (count _mkrNameStructure) == 5 ) then { _index = 4 };
	_itShouldBeNumeric = parseNumber (_mkrNameStructure # _index);  // result will be a number extracted from string OR ZERO if inside the string has no numbers.
	// If is number (not zero), true:
	if ( _itShouldBeNumeric != 0 ) then { 
		_isNumber = true;
	// If is NOT a number (will be zero), warning message:
	} else {
		["%1 MARKER '%2' > It has no a valid name. %3", CSWR_txtWarningHeader, toUpper _mkr, _txt1] call BIS_fnc_error; sleep 5;
	};
	// Return:
	_isNumber;
};


THY_fnc_CSWR_marker_scanner = {
	// This function searches and appends in a list all markers confirmed as real. The searching take place once right at the mission begins.
	// Return: _confirmedMarkers: array

	params ["_prefix", "_spacer"];
	private ["_spwnsBLU", "_spwnsVehBLU", "_spwnsHeliBLU", "_spwnsParadropBLU", "_spwnsOPF", "_spwnsVehOPF", "_spwnsHeliOPF", "_spwnsParadropOPF", "_spwnsIND", "_spwnsVehIND", "_spwnsHeliIND", "_spwnsParadropIND", "_spwnsCIV", "_spwnsVehCIV", "_spwnsHeliCIV", "_spwnsParadropCIV", "_destMoveBLU", "_destWatchBLU", "_destOccupyBLU", "_destHoldBLU", "_destMoveOPF", "_destWatchOPF", "_destOccupyOPF", "_destHoldOPF", "_destMoveIND", "_destWatchIND", "_destOccupyIND", "_destHoldIND", "_destMoveCIV", "_destWatchCIV", "_destOccupyCIV", "_destHoldCIV", "_destMovePUBLIC", "_confirmedMarkers", "_spwns", "_spwnsVeh", "_spwnsHeli", "_spwnsParadrop", "_isValid", "_mkrType", "_mkrOwner", "_isNumber", "_realPrefix", "_txt0", "_txt1", "_possibleMarkers", "_mkrNameStructure"];

	// Initial values:
	_spwnsBLU=[]; _spwnsVehBLU=[]; _spwnsHeliBLU=[]; _spwnsParadropBLU=[];
	_spwnsOPF=[]; _spwnsVehOPF=[]; _spwnsHeliOPF=[]; _spwnsParadropOPF=[];
	_spwnsIND=[]; _spwnsVehIND=[]; _spwnsHeliIND=[]; _spwnsParadropIND=[];
	_spwnsCIV=[]; _spwnsVehCIV=[]; _spwnsHeliCIV=[]; _spwnsParadropCIV=[];
	_destMoveBLU=[]; _destWatchBLU=[]; _destOccupyBLU=[]; _destHoldBLU=[];
	_destMoveOPF=[]; _destWatchOPF=[]; _destOccupyOPF=[]; _destHoldOPF=[];
	_destMoveIND=[]; _destWatchIND=[]; _destOccupyIND=[]; _destHoldIND=[];
	_destMoveCIV=[]; _destWatchCIV=[]; _destOccupyCIV=[]; _destHoldCIV=[];
	_destMovePUBLIC=[];
	_confirmedMarkers = [
		[
			[_spwnsBLU, _spwnsVehBLU, _spwnsHeliBLU, _spwnsParadropBLU],
			[_spwnsOPF, _spwnsVehOPF, _spwnsHeliOPF, _spwnsParadropOPF],
			[_spwnsIND, _spwnsVehIND, _spwnsHeliIND, _spwnsParadropIND],
			[_spwnsCIV, _spwnsVehCIV, _spwnsHeliCIV, _spwnsParadropCIV]
		], 
		[
			[_destMoveBLU, _destWatchBLU, _destOccupyBLU, _destHoldBLU],
			[_destMoveOPF, _destWatchOPF, _destOccupyOPF, _destHoldOPF],
			[_destMoveIND, _destWatchIND, _destOccupyIND, _destHoldIND],
			[_destMoveCIV, _destWatchCIV, _destOccupyCIV, _destHoldCIV],
			[_destMovePUBLIC]
		]
	];
	_spwns = 0;
	_spwnsVeh = 0;
	_spwnsHeli = 0;
	_spwnsParadrop = 0;
	_isValid = false;
	_mkrType = "";
	_mkrOwner = "";
	_isNumber = false;
	// Errors handling:
		// reserved space.
	// Escape:
		// reserved space.
	// Declarations:
	_realPrefix = toUpper _prefix + toUpper _spacer;
	// Debug texts:
	_txt0 = "This mission still HAS NO possible CSWR MARKERS to be loaded.";
	_txt1 = format ["CSWR markers must have their structure names like '%1%2SPWN%2BLU%2anynumber' or '%1%2DEST%2PUBLIC%2anynumber' or '%1%2SPWN%2OPF%2anynumber' or '%1%2DEST%2IND%2anynumber' for example.", _prefix, _spacer];
	
	// Step 1/2 > Creating a list with only markers with right prefix:
	// Selecting the relevant markers:
	_possibleMarkers = allMapMarkers select { toUpper _x find _realPrefix == 0 };
	// Escape > If no _possibleMarkers found:
	if ( count _possibleMarkers == 0 ) exitWith { ["%1 %2 %3", CSWR_txtWarningHeader, _txt0, _txt1] call BIS_fnc_error; sleep 5; _confirmedMarkers /* returning */ };
	// Validating each marker position:
	{  // forEach _possibleMarkers:
		_isValid = [_x] call THY_fnc_CSWR_marker_checker;
		// If something wrong, remove the marker from the list and from the map:
		if !_isValid then {
			deleteMarker _x;
			_possibleMarkers deleteAt (_possibleMarkers find _x);
		};
	} forEach _possibleMarkers;

	// Step 2/2 > Ignoring from the first list those markers that don't fit the name's structure rules, and creating new lists:
	{  // forEach _possibleMarkers:
		// check if the marker name has _spacer character enough in its string composition:
		_mkrNameStructure = [_x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_splitter;
		// check what type is each marker: cswr_spwn_blu_1
		_mkrType = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_type;
		// Case by case, check the valid marker name's amounts of strings:
		switch _mkrType do {
			// Case example: cswr_spawn_blu_1
			case "SPAWN": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _spwnsBLU pushBack _x };
						case "OPF": { _spwnsOPF pushBack _x };
						case "IND": { _spwnsIND pushBack _x };
						case "CIV": { _spwnsCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_spawnveh_blu_1
			case "SPAWNVEH": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _spwnsVehBLU pushBack _x };
						case "OPF": { _spwnsVehOPF pushBack _x };
						case "IND": { _spwnsVehIND pushBack _x };
						case "CIV": { _spwnsVehCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_spawnheli_blu_1
			case "SPAWNHELI": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _spwnsHeliBLU pushBack _x };
						case "OPF": { _spwnsHeliOPF pushBack _x };
						case "IND": { _spwnsHeliIND pushBack _x };
						case "CIV": { _spwnsHeliCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_spawnparadrop_blu_1
			case "SPAWNPARADROP": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _spwnsParadropBLU pushBack _x };
						case "OPF": { _spwnsParadropOPF pushBack _x };
						case "IND": { _spwnsParadropIND pushBack _x };
						case "CIV": { _spwnsParadropCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_move_blu_1
			case "MOVE": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _destMoveBLU pushBack _x };
						case "OPF": { _destMoveOPF pushBack _x };
						case "IND": { _destMoveIND pushBack _x };
						case "CIV": { _destMoveCIV pushBack _x };
						case "PUBLIC": { _destMovePUBLIC pushBack _x };
					};
				};
			};
			// Case example: cswr_watch_blu_1
			case "WATCH": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _destWatchBLU pushBack _x };
						case "OPF": { _destWatchOPF pushBack _x };
						case "IND": { _destWatchIND pushBack _x };
						case "CIV": { _destWatchCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_occupy_blu_1
			case "OCCUPY": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _destOccupyBLU pushBack _x };
						case "OPF": { _destOccupyOPF pushBack _x };
						case "IND": { _destOccupyIND pushBack _x };
						case "CIV": { _destOccupyCIV pushBack _x };
					};
				};
			};
			// Case example: cswr_hold_blu_1
			case "HOLD": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _destHoldBLU pushBack _x };
						case "OPF": { _destHoldOPF pushBack _x };
						case "IND": { _destHoldIND pushBack _x };
						case "CIV": { _destHoldCIV pushBack _x };
					};
				};
			};
		};
	} forEach _possibleMarkers;
	// Destroying unnecessary things:
	_possibleMarkers = nil;
	// Updating the general list to return:
	_confirmedMarkers = [
		[
			[_spwnsBLU, _spwnsVehBLU, _spwnsHeliBLU, _spwnsParadropBLU],
			[_spwnsOPF, _spwnsVehOPF, _spwnsHeliOPF, _spwnsParadropOPF],
			[_spwnsIND, _spwnsVehIND, _spwnsHeliIND, _spwnsParadropIND],
			[_spwnsCIV, _spwnsVehCIV, _spwnsHeliCIV, _spwnsParadropCIV]
		], 
		[
			[_destMoveBLU, _destWatchBLU, _destOccupyBLU, _destHoldBLU],
			[_destMoveOPF, _destWatchOPF, _destOccupyOPF, _destHoldOPF],
			[_destMoveIND, _destWatchIND, _destOccupyIND, _destHoldIND],
			[_destMoveCIV, _destWatchCIV, _destOccupyCIV, _destHoldCIV],
			[_destMovePUBLIC]
		]
	];
	// By actived faction, check if there is, at least, one spawn mark available:
	if CSWR_isOnBLU then {
		// Defining amount of spawns of faction:
		_spwns     = count (((_confirmedMarkers # 0) # 0) # 0);
		_spwnsVeh  = count (((_confirmedMarkers # 0) # 0) # 1);
		_spwnsHeli = count (((_confirmedMarkers # 0) # 0) # 2);
		_spwnsParadrop = count (((_confirmedMarkers # 0) # 0) # 3);
		if ( _spwns + _spwnsVeh + _spwnsHeli + _spwnsParadrop == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO BLU SPAWN FOUND. Check the documentation or turn 'CSWR_isOnBLU' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnOPF then {
		// Defining amount of spawns of faction:
		_spwns     = count (((_confirmedMarkers # 0) # 1) # 0);
		_spwnsVeh  = count (((_confirmedMarkers # 0) # 1) # 1);
		_spwnsHeli = count (((_confirmedMarkers # 0) # 1) # 2);
		_spwnsParadrop = count (((_confirmedMarkers # 0) # 1) # 3);
		if ( _spwns + _spwnsVeh + _spwnsHeli + _spwnsParadrop == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO OPF SPAWN FOUND. Check the documentation or turn 'CSWR_isOnOPF' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnIND then {
		// Defining amount of spawns of faction:
		_spwns     = count (((_confirmedMarkers # 0) # 2) # 0);
		_spwnsVeh  = count (((_confirmedMarkers # 0) # 2) # 1);
		_spwnsHeli = count (((_confirmedMarkers # 0) # 2) # 2);
		_spwnsParadrop = count (((_confirmedMarkers # 0) # 2) # 3);
		if ( _spwns + _spwnsVeh + _spwnsHeli + _spwnsParadrop == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO IND SPAWN FOUND. Check the documentation or turn 'CSWR_isOnIND' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnCIV then {
		// Defining amount of spawns of faction:
		_spwns     = count (((_confirmedMarkers # 0) # 3) # 0);
		_spwnsVeh  = count (((_confirmedMarkers # 0) # 3) # 1);
		_spwnsHeli = count (((_confirmedMarkers # 0) # 3) # 2);
		_spwnsParadrop = count (((_confirmedMarkers # 0) # 3) # 3);
		if ( _spwns + _spwnsVeh + _spwnsHeli + _spwnsParadrop == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO CIV SPAWN FOUND. Check the documentation or turn 'CSWR_isOnCIV' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	// Return:
	_confirmedMarkers;
};


THY_fnc_CSWR_convertion_faction_to_tag = {
	// This function converts the faction name to the owner tag for further validations.
	// Returns _tag: string of faction abbreviation.

	params ["_faction"];
	private ["_tag"];

	// Initial values:
	_tag = "";
	// Errors handling:
		// reserved space.
	// Escape:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Main validation:
	switch _faction do {
		case BLUFOR:      { _tag = "BLU" };
		case OPFOR:       { _tag = "OPF" };
		case INDEPENDENT: { _tag = "IND" };
		case CIVILIAN:    { _tag = "CIV" };
		// In here PUBLIC is not applied.
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
	
	Source: https://community.bistudio.com/wiki/BIS_fnc_exportCfgVehiclesAssetDB
	*/

	params ["_tag", "_cfgClass", "_what", "_var", "_classnames"];
	private ["_isValid", "_txt1"];

	// Initial values:
	_isValid = true;
	// Errors handling > If _classnames receive something that is not an array, convert it to an array:
	if ( typeName _classnames isNotEqualTo "ARRAY" ) then { _classnames = [_classnames] };
	// Escape > If array empty:
	if ( count _classnames == 0 ) exitWith {
		// Update the validation flag:
		_isValid = false;
		// Warning message:
		["%1 %2 > The variable '%3' looks EMPTY. Fix it to avoid errors.", CSWR_txtWarningHeader, _tag, _var] call BIS_fnc_error;
		// Breath:
		sleep 5;
		// Return:
		_isValid;
	};
	// Escape > If array with no string content:
	{  // forEach _classnames:
		if ( typeName _x isNotEqualTo "STRING" ) exitWith { 
			// Update the validation flag:
			_isValid = false;
			// Warning message:
			["%1 %2 > One or more items of '%3' are NOT string types. Fix it to avoid errors.", CSWR_txtWarningHeader, _tag, _var] call BIS_fnc_error;
			// Breath:
			sleep 5;
		};
	} forEach _classnames;
	if !_isValid exitWith { _isValid };
	// Declarations:
		// reserved space.
	// Debug texts:
	_txt1 = "Check if it's spelled correct or, if it's from a mod, the mod is loaded on server. FIX IT!";
	// If the _cfgClass spelled is known:
	if ( _cfgClass isNotEqualTo "" && _cfgClass in ["CfgVehicles", "CfgWeapons", "CfgMagazines"] ) then {
		{  // forEach _classnames:
			// If the classname is not empty string ("") and not a string called "REMOVE", keep going with the validation:
			// Important: this is important to LOADOUT Customization settings in CSWR Script.
			if ( _x isNotEqualTo "" && _x != "REMOVED" ) then {
				// Checking if the each classname (_x) exists. If not, abort:
				if ( !(isClass (configFile >> _cfgClass >> _x)) ) then {
					// Update the validation flag:
					_isValid = false;
					// Warning message:
					["%1 %2 > '%3' is NOT a VALID %4 CLASSNAME. %5", CSWR_txtWarningHeader, _tag, _x, toUpper _what, _txt1] call BIS_fnc_error;
					// Breath:
					sleep 5;
				};
			};
			if !_isValid exitWith {};  // WIP - to remove this line, test this forEach using BREAK inside that "if" above (if-!isClass-configFile...)
		} forEach _classnames;
	// Otherwise, if the classname doesn't belong some Arma Official cfgClass, do it: ()
	} else {
		{  // forEach _classnames:
			if ( isNil _x ) then {
				// Update the validation flag:
				_isValid = false;
				// Warning message:
				["%1 %2 > '%3' is NOT a VALID %4 CLASSNAME. %5", CSWR_txtWarningHeader, _tag, _x, toUpper _what, _txt1] call BIS_fnc_error;
				// Breath:
				sleep 5;
			};
		} forEach _classnames;
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_is_valid_classnames_type = {
	// This function checks if each classname in an array is one of the classname types abled.
	// Returns _isValid. Bool.

	params ["_tag", "_classnames", "_ableTypes", "_isVeh"];
	private ["_isValid", "_classnamesOk", "_delta", "_classnamesAmount", "_whatIndividual", "_whatColletive", "_eachAbleType"];

	// Initial values:
	_isValid = true;
	_classnamesOk = [];
	_delta = 0;
	// Declarations:
	_classnamesAmount = count _classnames;
	_whatIndividual = if _isVeh then { "VEHICLE" } else { "UNIT" };
	_whatColletive = if _isVeh then { "VEHICLE" } else { "GROUP" };
	// Escape:
	if ( _classnamesAmount == 0 ) exitWith { _isValid = false; _isValid /* Returning... */ };
	// Debug texts:
		// reserved space.
	
	{  // forEach _ableTypes:
		_eachAbleType = _x;
		{  // forEach _classnames:
			// If the classname is an abled type, include this valid classname in another array:
			if ( _x isKindOf _eachAbleType ) then { _classnamesOk pushBack _x };
		} forEach _classnames;
		// CPU breath:
		sleep 0.1;
	} forEach _ableTypes;
	// If there's difference between the size of both arrays, it's coz some classname is not an abled type:
	if ( count _classnames isNotEqualTo count _classnamesOk ) then {
		// Update the validation flag:
		_isValid = false;
		//
		_delta = (count _classnames) - (count _classnamesOk);
		// Warning message:
		if ( _delta == 1 ) then {
			// singular message:
			["%1 %2 > %3 classname used to build a %2 %5 is NOT a %4 CLASSNAME, then it CANNOT to be spawned as %2 %5. Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, _delta, _whatIndividual, _whatColletive] call BIS_fnc_error;
		} else {
			// plural message:
			["%1 %2 > %3 classnames used to build a %2 %5 are NOT %4 CLASSNAMES, then they CANNOT to be spawned as %2 %5. Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, _delta, _whatIndividual, _whatColletive] call BIS_fnc_error;
		};
		// WIP - better message: ["%1 %2 > '%3' is NOT a %4 CLASSNAME, then it CANNOT to be spawned as a %2 %5. Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, str _x, _whatIndividual, _whatColletive] call BIS_fnc_error;
		// Message breath:
		sleep 5;
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_is_valid_behavior = {
	// This function just validates if there is a valid behavior to the units for further validations.
	// Return _isValid: bool.

	params ["_tag", "_isVeh", "_behavior"];
	private ["_isValid", "_requester"];

	// Initial value:
	_isValid = false;
	// Errors handling:
	if ( typeName _behavior isEqualTo "STRING" ) then { _behavior = toUpper _behavior };
	// Escape:
		// reserved space.
	// Declarations:
	_requester = if _isVeh then { "vehicle" } else { "group" };
	// Debug texts:
		// reserved space.
	// If the configured behavior is known:
	if ( _behavior in ["BE_SAFE", "BE_AWARE", "BE_COMBAT", "BE_STEALTH", "BE_CHAOS"] ) then { 
		// Preparing to successfully return:
		_isValid = true;
	// Otherwise:
	} else {
		// Warning message:
		["%1 %2 > One or more %3s HAS NO BEHAVIOR properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integraty, the %3 WON'T BE CREATED.", CSWR_txtWarningHeader, _tag, _requester] call BIS_fnc_error; sleep 5;
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_is_valid_destination = {
	// This function just validates if there is at least the minimal valid destination amount dropped on the map for further validations.
	// Return _isThereDest: bool.

	params ["_tag", "_isVeh", "_destType"];
	private ["_isThereDest", "_isValid", "_destMarkers", "_minAmount", "_requester", "_txt1", "_txt2", "_txt3", "_txt4"];

	// Initial value:
	_isThereDest = false;
	_isValid = false;
	_destMarkers = [];
	_minAmount = nil;
	// Escape:
		// reserved space.
	// Declarations:
	_requester = if _isVeh then { "vehicle" } else { "group" };
	switch _destType do {
		case "MOVE_ANY":        { _minAmount = CSWR_minDestAny };
		case "MOVE_PUBLIC":     { _minAmount = CSWR_minDestPublic };
		case "MOVE_RESTRICTED": { _minAmount = CSWR_minDestRestricted };
		case "MOVE_WATCH":      { _minAmount = CSWR_minDestWatch };
		case "MOVE_OCCUPY":     { _minAmount = CSWR_minDestOccupy };
		case "MOVE_HOLD":       { _minAmount = CSWR_minDestHold };
		default                 { /* _minAmount = nil */ };
	};
	// Debug texts:
	_txt1 = format ["A %1 %2 won't be created coz the DESTINATION TYPE '%3' HAS NO %4 or more markers dropped on the map.", _tag, _requester, _destType, _minAmount];
	_txt2 = format ["One or more %1 %2s HAS NO DESTINATION properly configured in 'fn_CSWR_population.sqf' file. For script integraty, the %2 won't be created.", _tag, _requester];
	_txt3 = format ["%1 %2 CANNOT use '%3' destinations. Check the 'fn_CSWR_population.sqf' file. For script integraty, the %2 won't be created.", _tag, _requester, _destType];
	_txt4 = format ["Civilians CANNOT use '%1' destinations. Check the 'fn_CSWR_population.sqf' file. For script integraty, the civilian group won't be created.", _destType];
	// Errors handling:
	if ( typeName _destType isEqualTo "STRING" ) then { _destType = toUpper _destType };
	// Main validation:
	switch _destType do {
		case "MOVE_ANY": {
			// if at least X destinations of this type:
			if ( count CSWR_destsANYWHERE >= CSWR_minDestAny ) then { 
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		case "MOVE_PUBLIC": { 
			// if at least X destinations of this type:
			if ( count CSWR_destsPUBLIC >= CSWR_minDestPublic ) then {
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		case "MOVE_RESTRICTED": { 
			// Checking which faction is here:
			switch _tag do {
				case "BLU": { _destMarkers = CSWR_destBLU };
				case "OPF": { _destMarkers = CSWR_destOPF };
				case "IND": { _destMarkers = CSWR_destIND };
			};
			// if at least X destinations of this type:
			if ( count _destMarkers >= CSWR_minDestRestricted ) then {
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		case "MOVE_WATCH": { 
			// Checking which faction is here:
			switch _tag do {
				case "BLU": { _destMarkers = CSWR_destWatchBLU };
				case "OPF": { _destMarkers = CSWR_destWatchOPF };
				case "IND": { _destMarkers = CSWR_destWatchIND };
			};
			// if at least X destinations of this type, and the requester IS NOT a vehicle, and the faction IS NOT civilian:
			if ( count _destMarkers >= CSWR_minDestWatch && _requester isNotEqualTo "vehicle" && _tag isNotEqualTo "CIV" ) then {
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// If NOT a vehicle, and NOT civilian:
				if ( _requester isNotEqualTo "vehicle" && _tag isNotEqualTo "CIV" ) then {
					// Warning message:
					["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
				// Otherwise:
				} else {
					// If vehicle:
					if ( _requester isEqualTo "vehicle" ) then {
						// Warning message:
						["%1 %2", CSWR_txtWarningHeader, _txt3] call BIS_fnc_error; sleep 5;
					};
					// If civilian:
					if ( _tag isEqualTo "CIV" ) then {
						// Warning message:
						["%1 %2", CSWR_txtWarningHeader, _txt4] call BIS_fnc_error; sleep 5;
					};
				};
			}; 
		};
		case "MOVE_OCCUPY": { 
			// Checking which faction is here:
			switch _tag do {
				case "BLU": { _destMarkers = CSWR_destOccupyBLU };
				case "OPF": { _destMarkers = CSWR_destOccupyOPF };
				case "IND": { _destMarkers = CSWR_destOccupyIND };
				case "CIV": { _destMarkers = CSWR_destOccupyCIV };
			};
			// if at least X destinations of this type (and the requester IS NOT a vehicle):
			if ( count _destMarkers >= CSWR_minDestOccupy && _requester isNotEqualTo "vehicle" ) then { 
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// If NOT a vehicle:
				if ( _requester isNotEqualTo "vehicle" ) then {
					// Warning message:
					["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
				// Otherwise, if vehicle:
				} else {
					// Warning message:
					["%1 %2", CSWR_txtWarningHeader, _txt3] call BIS_fnc_error; sleep 5;
				};
			}; 
		};
		case "MOVE_HOLD": { 
			// Checking which faction is here:
			switch _tag do {
				case "BLU": { _destMarkers = CSWR_destHoldBLU };
				case "OPF": { _destMarkers = CSWR_destHoldOPF };
				case "IND": { _destMarkers = CSWR_destHoldIND };
				case "CIV": { _destMarkers = CSWR_destHoldCIV };
			};
			// if at least X destinations of this type:
			if ( count _destMarkers >= CSWR_minDestHold ) then {
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		default {
			// If the declarated destination type in fn_CSWR_population file IS NOT recognized:
			// Warming message:
			["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5;
		};
	};  // switch ends.
	// Return:
	_isThereDest;
};


THY_fnc_CSWR_is_valid_formation = {
	// This function just validates if there is a valid formation to the group for further validations.
	// Return _isValid: bool.

	params ["_tag", "_isVeh", "_form"];
	private ["_isValid"];

	// Initial value:
	_isValid = false;
	// Escape:
	if _isVeh exitWith { _isValid /* Returning... */ };
	// Errors handling:
	if ( typeName _form isEqualTo "STRING" ) then { _form = toUpper _form };
	// Declarations:
		// Reserved space.
	// Debug texts:
		// reserved space.
	// If the configured formation is valid: https://community.bistudio.com/wiki/formation
	if ( _form in ["COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"] ) then { 
		// Preparing to successfully return:
		_isValid = true;
	// Otherwise:
	} else {
		// Warning message:
		["%1 %2 > One or more groups HAS NO FORMATION properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integraty, the group WON'T BE CREATED.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		sleep 5;
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_group_type_rules = {
	// This function defines rules to each Group Type of a faction (through Erros Handling), and returns a "dictionary" to be used for another functions (e.g. Skills) later.
	// Returns _grpInfo array. If it returns empty, it's because the group is invalid and can't be spawned.

	params["_faction", "_tag", "_grpClassnames", "_destType", "_behavior", "_form"];
	private["_teamLight", "_teamMedium", "_teamHeavy", "_teamCustom1", "_teamCustom2", "_teamCustom3", "_teamSniper", "_vehLight", "_vehMedium", "_vehHeavy", "_vehCustom1", "_vehCustom2", "_vehCustom3", "_heliLight", "_heliHeavy", "_grpInfo","_grpType", "_grpSize"];

	// Escape:
		// reserved space.
	// Initial values:
	_teamLight=[]; _teamMedium=[]; _teamHeavy=[]; _teamCustom1=[]; _teamCustom2=[]; _teamCustom3=[]; _teamSniper=[];  // people groups;
	_vehLight=[]; _vehMedium=[]; _vehHeavy=[]; _vehCustom1=[]; _vehCustom2=[]; _vehCustom3=[]; _heliLight=[]; _heliHeavy=[];  // vehicle groups;
	// Debug texts:
		// reserved space.
	// Groups' dictionary:
	switch _faction do {
		case BLUFOR: {
			// People group:
			_teamLight   = CSWR_group_BLU_light;
			_teamMedium  = CSWR_group_BLU_medium;
			_teamHeavy   = CSWR_group_BLU_heavy;
			_teamCustom1 = CSWR_group_BLU_custom_1;
			_teamCustom2 = CSWR_group_BLU_custom_2;
			_teamCustom3 = CSWR_group_BLU_custom_3;
			_teamSniper  = CSWR_group_BLU_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_BLU_light];
			_vehMedium  = [CSWR_vehicle_BLU_medium];
			_vehHeavy   = [CSWR_vehicle_BLU_heavy];
			_vehCustom1 = [CSWR_vehicle_BLU_custom_1];
			_vehCustom2 = [CSWR_vehicle_BLU_custom_2];
			_vehCustom3 = [CSWR_vehicle_BLU_custom_3];
			_heliLight  = [CSWR_vehicle_BLU_heli_light];
			_heliHeavy  = [CSWR_vehicle_BLU_heli_heavy];
		};
		case OPFOR: {
			// People group:
			_teamLight   = CSWR_group_OPF_light;
			_teamMedium  = CSWR_group_OPF_medium;
			_teamHeavy   = CSWR_group_OPF_heavy;
			_teamCustom1 = CSWR_group_OPF_custom_1;
			_teamCustom2 = CSWR_group_OPF_custom_2;
			_teamCustom3 = CSWR_group_OPF_custom_3;
			_teamSniper  = CSWR_group_OPF_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_OPF_light];
			_vehMedium  = [CSWR_vehicle_OPF_medium];
			_vehHeavy   = [CSWR_vehicle_OPF_heavy];
			_vehCustom1 = [CSWR_vehicle_OPF_custom_1];
			_vehCustom2 = [CSWR_vehicle_OPF_custom_2];
			_vehCustom3 = [CSWR_vehicle_OPF_custom_3];
			_heliLight  = [CSWR_vehicle_OPF_heli_light];
			_heliHeavy  = [CSWR_vehicle_OPF_heli_heavy];
		};
		case INDEPENDENT: {
			// People group:
			_teamLight   = CSWR_group_IND_light;
			_teamMedium  = CSWR_group_IND_medium;
			_teamHeavy   = CSWR_group_IND_heavy;
			_teamCustom1 = CSWR_group_IND_custom_1;
			_teamCustom2 = CSWR_group_IND_custom_2;
			_teamCustom3 = CSWR_group_IND_custom_3;
			_teamSniper  = CSWR_group_IND_sniper;
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_IND_light];
			_vehMedium  = [CSWR_vehicle_IND_medium];
			_vehHeavy   = [CSWR_vehicle_IND_heavy];
			_vehCustom1 = [CSWR_vehicle_IND_custom_1];
			_vehCustom2 = [CSWR_vehicle_IND_custom_2];
			_vehCustom3 = [CSWR_vehicle_IND_custom_3];
			_heliLight  = [CSWR_vehicle_IND_heli_light];
			_heliHeavy  = [CSWR_vehicle_IND_heli_heavy];
		};
		case CIVILIAN: {
			// People group:
			_teamLight   = CSWR_group_CIV_lone;
			_teamMedium  = CSWR_group_CIV_couple;
			_teamHeavy   = CSWR_group_CIV_gang;
			_teamCustom1 = CSWR_group_CIV_custom_1;
			_teamCustom2 = CSWR_group_CIV_custom_2;
			_teamCustom3 = CSWR_group_CIV_custom_3;
			_teamSniper  = [];  // Civilian has no sniper group.
			// Vehicle group:
			_vehLight   = [CSWR_vehicle_CIV_light];
			_vehMedium  = [CSWR_vehicle_CIV_medium];
			_vehHeavy   = [CSWR_vehicle_CIV_heavy];
			_vehCustom1 = [CSWR_vehicle_CIV_custom_1];
			_vehCustom2 = [CSWR_vehicle_CIV_custom_2];
			_vehCustom3 = [CSWR_vehicle_CIV_custom_3];
			_heliLight  = [CSWR_vehicle_CIV_heli_light];
			_heliHeavy  = [CSWR_vehicle_CIV_heli_heavy];
		};
	};
	// Group information > basic:
	// _grpInfo is [ group faction (side variable), group faction tag (strig), group id (obj), group type (str), group classnames ([strs]), group behavior (str), group formation (str), destination type (str) ]
	_grpInfo = [_faction, _tag, grpNull, "", [], _behavior, _form, _destType];  // Tip: to figure out the _grpInfo units (objs), use: "units _grpInfo # 2" or "units _grp".
	// Group information > specificity:
	switch _grpClassnames do {
		// People group:
		case _teamLight:   { _grpInfo set [3, "teamL"];  _grpInfo set [4, _teamLight] };
		case _teamMedium:  { _grpInfo set [3, "teamM"];  _grpInfo set [4, _teamMedium] };
		case _teamHeavy:   { _grpInfo set [3, "teamH"];  _grpInfo set [4, _teamHeavy] };
		case _teamCustom1: { _grpInfo set [3, "teamC1"]; _grpInfo set [4, _teamCustom1] };
		case _teamCustom2: { _grpInfo set [3, "teamC2"]; _grpInfo set [4, _teamCustom2] };
		case _teamCustom3: { _grpInfo set [3, "teamC3"]; _grpInfo set [4, _teamCustom3] };
		case _teamSniper:  { _grpInfo set [3, "teamS"];  _grpInfo set [4, _teamSniper] };
		// Vehicle group:
		case _vehLight:    { _grpInfo set [3, "vehL"];   _grpInfo set [4, _vehLight] };
		case _vehMedium:   { _grpInfo set [3, "vehM"];   _grpInfo set [4, _vehMedium] };
		case _vehHeavy:    { _grpInfo set [3, "vehH"];   _grpInfo set [4, _vehHeavy] };
		case _vehCustom1:  { _grpInfo set [3, "vehC1"];  _grpInfo set [4, _vehCustom1] };
		case _vehCustom2:  { _grpInfo set [3, "vehC2"];  _grpInfo set [4, _vehCustom2] };
		case _vehCustom3:  { _grpInfo set [3, "vehC3"];  _grpInfo set [4, _vehCustom3] };
		case _heliLight:   { _grpInfo set [3, "heliL"];  _grpInfo set [4, _heliLight] };
		case _heliHeavy:   { _grpInfo set [3, "heliH"];  _grpInfo set [4, _heliHeavy] };
	};
	// Declarations:
	_grpType = _grpInfo # 3;
	_grpSize = count (_grpInfo # 4);
	// Errors handling > Sniper group cannot execute WatchMove with more than 2 members:
	if ( _grpType isEqualTo "teamS" && _destType isEqualTo "MOVE_WATCH" && _grpSize > 2 ) then {
		// Warning message:
		["%1 WATCH > %2 SNIPER group CANNOT have more than 2 units! The group WON'T SPAWN! Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		sleep 5;
		// Flag to invalid this group:
		_grpInfo = [];
	};
	// HELICOPTERS > Move restrictions:
	if ( _grpType isEqualTo "heliL" || _grpType isEqualTo "heliH" ) then {
		// Errors handling > Helicopters cannot execute Watch, Hold, nor Occupy:
		if ( _destType isEqualTo "MOVE_WATCH" || _destType isEqualTo "MOVE_HOLD" || _destType isEqualTo "MOVE_OCCUPY" ) then {
			// Warning message:
			["%1 WATCH > %2 HELICOPTER CANNOT execute '%3'! The vehicle WON'T SPAWN! Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, _destType] call BIS_fnc_error;
			sleep 5;
			// Flag to invalid this group:
			_grpInfo = [];
		};
	};
	// Return:
	_grpInfo;
};


THY_fnc_CSWR_group_type_helicopter = {
	// This function checks if the group belongs an helicopter group type.
	// Returns _isHeli. Bool.

	params ["_grpType"];
	private ["_isHeli"];

	// Escape:
	if ( isNil _grpType && _grpType isEqualTo "" ) exitWith { false };
	// Initial values:
	_isHeli = false;
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Main functionality:
	if ( _grpType isEqualTo "heliL" || _grpType isEqualTo "heliH" ) then { _isHeli = true };

	// Return:
	_isHeli;
};


THY_fnc_CSWR_group_formation = {
	// This function applies a formation to the group. Before, the formation has been validated through another function: THY_fnc_CSWR_is_valid_formation.
	// Returns nothing.

	params ["_grpInfo"];
	private ["_grp", "_form"];

	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
	_grp = _grpInfo # 2;
	_form = _grpInfo # 6;
	// Escape:
	if ( _form isEqualTo "" ) exitWith {};
	// Debug texts:
		// reserved space.
	// Custom formation:
	_grp setFormation _form;
	// Breath for the group execute the new formation:
	sleep 3;
	// Return:
	true;
};


THY_fnc_CSWR_group_behavior = {
	// This function defines the group behavior only.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.

	params ["_grp", "_behavior", "_isVeh"];
	//private [""];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// 
	switch _behavior do {
		case "BE_SAFE": {
			_grp setBehaviourStrong "SAFE";  // calm.
			_grp setSpeedMode "LIMITED";  // walk.
		};
		case "BE_AWARE": {
			_grp setBehaviourStrong "AWARE";  // consern.
			_grp setSpeedMode "LIMITED";  // walk, but guns ready.
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
				_grp setSpeedMode "FULL";  // do not wait for any other units in formation.
			// If infantry group:
			} else {
				_grp setBehaviourStrong "AWARE";  // Dont set "COMBAT" here coz the bevarior will make the group to prone and stuff over and over again.
				_grp setSpeedMode "FULL";  // do not wait for any other units in formation.
			};
		};
	};
	// CPU breath
	sleep 0.1;
	// Return:
	true;
};


THY_fnc_CSWR_unit_behavior = {
	// This function defines the unit behavior inside their group.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.

	params ["_grp", "_behavior", "_isVeh"];
	//private [""];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// 
	{  // forEach (units _grp):
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
				_x setUnitCombatMode "RED";  // Fire at will, engage at will/loose formation.
			};
		};
		// CPU breath:
		sleep 0.1;
	} forEach units _grp;
	// Return:
	true;
};


THY_fnc_CSWR_unit_skills = {
	// This function defines the unit skills inside their Group Type.
	// Check this out: https://community.bistudio.com/wiki/Arma_3:_AI_Skill#Sub-Skills
	// Returns nothing.

	params ["_grpType", "_grp", "_destType"];
	//private [];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	{  // forEach units _grp:
		// If member of Light group:
		if ( _grpType isEqualTo "teamL" ) then {
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 0.7];
			};
		};
		// If member of Medium group:
		if ( _grpType isEqualTo "teamM" ) then {
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 0.8];
			};
		};
		// If member of Heavy group:
		if ( _grpType isEqualTo "teamH" ) then {
			if ( _x == leader _grp ) then {
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
			if ( _x == leader _grp ) then {  // leader is the main gunner.
				_x setSkill ["spotTime", 0.6];
				_x setSkill ["aimingAccuracy", 0.8];
			} else {
				_x setSkill ["spotTime", 0.8];  // The other member is the spotter.
				_x setSkill ["aimingAccuracy", 0.7];
			};
			_x setSkill ["spotDistance", 0.7];
			_x setSkill ["aimingShake", 0.8];
			_x setSkill ["reloadSpeed", 0.4];  // a bit faster than when watching.
		};
		// Updating the settings if Sniper group in watch strategy:
		if ( _grpType isEqualTo "teamS" && _destType isEqualTo "MOVE_WATCH" ) then {
			// skills:
			if ( _x == leader _grp ) then {  // leader is the main gunner.
				_x setSkill ["spotTime", 0.8];
				_x setSkill ["aimingAccuracy", 0.9];
			} else {
				_x setSkill ["spotTime", 1];  // The other member is the spotter.
				_x setSkill ["aimingAccuracy", 0.8];
			};
			_x setSkill ["spotDistance", 1];
			_x setSkill ["aimingShake", 0.9];
			_x setSkill ["reloadSpeed", 0.3];  // a bit slower than when not watching.
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
		// If crewman of Heli Light:
		if ( _grpType isEqualTo "heliL" ) then {
			// skills:
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 0.8];
			};
			_x setSkill ["spotDistance", 1];  // as Heli Light is closer from the ground (flyInHeight), it's easier to spot the enemy than Heli Heavy.
			_x setSkill ["courage", 0.9];
		};
		// If crewman of Heli Heavy:
		if ( _grpType isEqualTo "heliH" ) then {
			// skills:
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 1];
			};
			/* if ( _x == gunner (vehicle _x) ) then {
				// reserved space.
			} else {
				// reserved space.
			}; */
			_x setSkill ["spotDistance", 0.8];  // as Heli Heavy is further from the ground (flyInHeight), it's harder to spot the enemy than Heli Light
			_x setSkill ["courage", 0.9];
		};
		// CPU breath
		sleep 0.1;

	} forEach units _grp;
	// Return:
	true;
};


THY_fnc_CSWR_loadout_scanner_uniform = {
	// This function checks the unit's uniform to understand its current contents in case the mission editor chooses to replace the uniform by a new one.
	// Returns _uniformContent.

	params ["_unit"];
	private ["_uniformContent", "_uniform"];

	// Initial values:
	_uniformContent = [];
	// Declarations:
	_uniform = uniform _unit;  // if empty, returns "".
	// Escape:
	if ( _uniform isEqualTo "" ) exitWith {};
	// if there's an uniform, then save all its original content:
	if ( _uniform isNotEqualTo "" ) then { _uniformContent = uniformItems _unit };
	// Return:
	_uniformContent;
};


THY_fnc_CSWR_loadout_scanner_vest = {
	// This function checks the unit's vest to understand its current contents in case the mission editor chooses to replace the vest by a new one.
	// Returns _vestContent.

	params ["_unit"];
	private ["_vestContent", "_vest"];

	// Initial values:
	_vestContent = [];
	// Declarations:
	_vest = vest _unit;  // if empty, returns "".
	// if there's a backpack, then save all its original content:
	if ( _vest isNotEqualTo "" ) then { _vestContent = vestItems _unit };
	// Return:
	_vestContent;
};


THY_fnc_CSWR_loadout_scanner_backpack = {
	// This function checks the unit's backpack to understand its current contents in case the mission editor chooses to replace the backpack by a new one.
	// Returns _backpackContent.

	params ["_unit"];
	private ["_backpackContent", "_backpack"];

	// Initial values:
	_backpackContent = [];
	// Declarations:
	_backpack = backpack _unit;  // if empty, returns "".
	// if there's a backpack, then save all its original content:
	if ( _backpack isNotEqualTo "" ) then { _backpackContent = backpackItems _unit };
	// Return:
	_backpackContent;
};


THY_fnc_CSWR_loadout_helmet = {
	// This function replace the old unit's helmet for the new one.
	// Returns nothing.

	params ["_unit", "_newHelmetInfantry", "_newHelmetCrew"];
	private ["_oldHeadgear", "_veh", "_tag", "_isValidClassname"];

	// Initial values:
	_oldHeadgear = "";
	_veh = objNull;
	// Declarations:
	_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassname = [_tag, "CfgWeapons", "helmet", "of custom helmets", [_newHelmetInfantry, _newHelmetCrew]] call THY_fnc_CSWR_is_valid_classname;
	// CREW HEADGEAR:
	if (!isNull (objectParent _unit)) then {
		// Declarations:
		_oldHeadgear = headgear _unit;  // if empty, returns "".
		_veh = vehicle _unit;
		// Units can use headgear:
		if ( _newHelmetCrew != "REMOVED" && _isValidClassname ) then {
			// if the unit had an old headgear:
			if ( _oldHeadgear isNotEqualTo "" ) then {
				// if the soldiers here are crewmen and not passagers:
				if ( _unit == driver _veh || _unit == gunner _veh || _unit == commander _veh ) then {
					// if the vehicle's type is a heavy ground vehicle:
					if ( _veh isKindOf "Tank" || _veh isKindOf "WheeledAPC" || _veh isKindOf "TrackedAPC" ) then {
						// if the editors registered a new crew headgear, && both are not the same:
						if ( _newHelmetCrew isNotEqualTo "" && _oldHeadgear isNotEqualTo _newHelmetCrew ) then {
							// Remove the headgear:
							removeHeadgear _unit;
							// Add the new crew headgear:
							_unit addHeadgear _newHelmetCrew;
						};
					// if the vehicle's type is other one:
					} else {
						// the crew will get the same helmet of infantry if the editors registered a new headgear, && both are not the same:
						if ( _newHelmetInfantry isNotEqualTo "" && _newHelmetInfantry isNotEqualTo _newHelmetCrew ) then { 
							// Remove the headgear:
							removeHeadgear _unit;
							// Add the new headgear:
							_unit addHeadgear _newHelmetInfantry;
						};
					};
				// if the crew actually is just a infantry spawned inside the vehicle...
				} else {
					// they're infantry so, getting the infantry headgear if the editors registered a new headgear, && both are not the same:
					if ( _newHelmetInfantry isNotEqualTo "" && _newHelmetInfantry isNotEqualTo _newHelmetCrew ) then { 
						// Remove the headgear:
						removeHeadgear _unit;
						// Add the new headgear:
						_unit addHeadgear _newHelmetInfantry;
					};
				};
			};
		// If headgear must be removed at all:
		} else {
			// Remove the headgear:
			removeHeadgear _unit;
		};

	// INFANTRY HEADGEAR:
	} else {
		// Declarations:
		_oldHeadgear = headgear _unit;  // if empty, returns "".
		// Units can use headgear:
		if ( _newHelmetInfantry != "REMOVED" ) then {
			// if the unit had an old headgear:
			if ( _oldHeadgear isNotEqualTo "" ) then {
				// if the editors registered a new headgear, && both are not the same:
				if ( _newHelmetInfantry isNotEqualTo "" && _oldHeadgear isNotEqualTo _newHelmetInfantry ) then { 
					// Remove the headgear:
					removeHeadgear _unit;
					// Add the new headgear:
					_unit addHeadgear _newHelmetInfantry;
				};
			};
		// If headgear must be removed at all:
		} else {
			// Remove the headgear:
			removeHeadgear _unit;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_uniform = {
	// This function add to the new uniform all the old unit's uniform original content.
	// Returns nothing.

	params ["_unit", "_newUniform"];
	private ["_oldUniformContent", "_tag", "_isValidClassname", "_oldUniform"];

	// Initial values:
	_oldUniformContent = [];
	// Declarations:
	_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassname = [_tag, "CfgWeapons", "uniform", "_newUniform", [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
	_oldUniform = uniform _unit;  // if empty, returns "".
	// Units can use uniform:
	if ( _newUniform != "REMOVED" && _isValidClassname ) then {
		// if the unit had an old uniform:
		if ( _oldUniform isNotEqualTo "" ) then {
			// if the editors registered a new uniform, && both are not the same:
			if ( _newUniform isNotEqualTo "" && _oldUniform isNotEqualTo _newUniform ) then {
				// check the uniform original content:
				_oldUniformContent = [_unit] call THY_fnc_CSWR_loadout_scanner_uniform;
				// Remove the old uniform:
				removeUniform _unit;
				// Add the new uniform:
				_unit forceAddUniform _newUniform;
				// if there is one or more items from old uniform, repack them to the new one:
				if ( count _oldUniformContent > 0 ) then { { _unit addItemToUniform _x } forEach _oldUniformContent };
			};
		};
	// If uniform must be removed at all:
	} else {
		// Remove the uniform:
		removeUniform _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_vest = {
	// This function add to the new vest all the old unit's vest original content.
	// Returns nothing.

	params ["_unit", "_newVest"];
	private ["_oldVestContent", "_tag", "_isValidClassname", "_oldVest"];

	// Initial values:
	_oldVestContent = [];
	// Declarations:
	_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassname = [_tag, "CfgWeapons", "vest", "_newVest", [_newVest]] call THY_fnc_CSWR_is_valid_classname;
	_oldVest = vest _unit;  // if empty, returns "".
	// Units can use vest:
	if ( _newVest != "REMOVED" && _isValidClassname ) then {
		// if the unit had an old vest OR the CSWR is been forced to add vest for each unit, including those ones originally with no vest:
		if ( _oldVest isNotEqualTo "" || CSWR_isVestForAll ) then {
			// if the editors registered a new vest, && both are not the same:
			if ( _newVest isNotEqualTo "" && _oldVest isNotEqualTo _newVest ) then {
				// check the vest original content:
				_oldVestContent = [_unit] call THY_fnc_CSWR_loadout_scanner_vest;
				// Remove the old vest:
				removeVest _unit;
				// Add the new vest:
				_unit addVest _newVest;
				// if there is one or more items from old vest, repack them to the new one:
				if ( count _oldVestContent > 0 ) then { { _unit addItemToVest _x } forEach _oldVestContent };
			};
		};
	// If vest must be removed at all:
	} else {
		// Remove the vest:
		removeVest _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_backpack = {
	// This function add to the new backpack all the old unit's backpack original content.
	// Returns nothing.

	params ["_unit", "_newBackpack", "_mandatory", "_shouldEscape"];
	private ["_oldBackpackContent", "_tag", "_isValidClassname", "_oldBackpack"];

	// Escape:
	if _shouldEscape exitWith {};
	// Initial values:
	_oldBackpackContent = [];
	// Declarations:
	_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassname = [_tag, "CfgVehicles", "backpack", "_newBackpack", [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
	_oldBackpack = backpack _unit;  // if empty, returns "".
	// Units can use backpack:
	if ( _newBackpack != "REMOVED" && _isValidClassname ) then {
		// if the unit had an old backpack OR the CSWR is been forced to add backpack for each unit, including those ones originally with no backpack:
		if ( _oldBackpack isNotEqualTo "" || _mandatory ) then {
			// if the editors registered a new backpack, and both are not the same:
			if ( _newBackpack isNotEqualTo "" && _oldBackpack isNotEqualTo _newBackpack ) then {
				// check the backpack original content:
				_oldBackpackContent = [_unit] call THY_fnc_CSWR_loadout_scanner_backpack;
				// Remove the old backpack:
				removeBackpack _unit;
				// Add the new backpack:
				_unit addBackpack _newBackpack;
				// if there is one or more items from old backpack, repack them to the new one:
				if ( count _oldBackpackContent > 0 ) then { { _unit addItemToBackpack _x } forEach _oldBackpackContent };
			};
		};
	// If backpack must be removed at all:
	} else {
		// Remove the backpack:
		removeBackpack _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_sniper = {
	// This function organizes exclusively the sniper group loadout.
	// Returns nothing.

	params ["_grpType", "_unit", "_uniform", "_vest", "_rifle", "_rifleMagazine", "_rifleOptics", "_rifleRail", "_rifleMuzzle", "_rifleBipod", "_binoculars"];
	private ["_tag", "_isValidClassname", "_isSniper"];

	// Initial values:
		// Reserved space.
	// Declarations:
	_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassname = [_tag, "CfgWeapons", "binoculars", "_binoculars", [_binoculars]] call THY_fnc_CSWR_is_valid_classname;
	_isSniper = if ( _grpType isEqualTo "teamS" ) then { true } else { false };
	// Escape:
	if ( !_isSniper ) exitWith {};
	// Uniform:
	if ( _uniform isNotEqualTo "" ) then {
		// New uniform replacement:
		[_unit, _uniform] call THY_fnc_CSWR_loadout_uniform;
	};
	// Helmet:
	//[_unit, _helmet, "H_HelmetSpecB_sand"] call THY_fnc_CSWR_loadout_helmet;
	// Vest:
	if ( _vest isNotEqualTo "" ) then {
		// New vest replacement:
		[_unit, _vest, true] call THY_fnc_CSWR_loadout_vest;
	};
	// Backpack:
		// Snipers never got backpack, even when CSWR_isVestForAll is true.
	// Rifle:
	[_unit, _rifle, _rifleMagazine, _rifleOptics, _rifleRail, _rifleMuzzle, _rifleBipod] call THY_fnc_CSWR_loadout_team_sniper_weapon;
	// Binocular:
	if ( _binoculars isNotEqualTo "" && _binoculars != "REMOVED" && _isValidClassname ) then {  // So the editor wants another binoculars.
		// Remove the old one if it exists:
		_unit removeWeapon (binocular _unit);
		// New binoculars replacement:
		_unit addWeapon _binoculars;
	// If there's NO custom binoculars, check if there is at least a regular one:
	} else { 
		// If no binoculars at all, add it because for sniper group is mandatory:
		if ( binocular _unit isEqualTo "" || _binoculars == "REMOVED" || !_isValidClassname ) then {  // Binoculars are mandatory for sniper group coz the logic used for sniper group with 2 units.
			// Adding the simplest one:
			_unit addWeapon "Binocular";
			// Debug message:
			if CSWR_isOnDebugGlobal then { ["%1 WATCH > '%2' needs binoculars to watch, so each member has one now.", CSWR_txtWarningHeader, str (group _unit)] call BIS_fnc_error; sleep 5 };
		};
	};
	// Pistol:
	// If there's NO pistol (mandatory for sniper group):
	if ( handgunWeapon _unit isEqualTo "" ) then {
		// Add a pistol:
		_unit addWeapon "hgun_P07_F";
		// Add at least one magazine directly on the weapon loader:
		_unit addHandgunItem "16Rnd_9x21_Mag";
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_paratrooper = {
	// This function organizes exclusively the paratrooper group loadout.
	// Returns nothing.

	params ["_unit", "_uniform", "_vest", "_parachute", "_isParadrop"];
	//private [];

	// Escape:
	if !_isParadrop exitWith {};
	// Initial values:
		// Reserved space.
	// Uniform:
	if ( _uniform isNotEqualTo "" ) then {
		// New uniform replacement:
		[_unit, _uniform] call THY_fnc_CSWR_loadout_uniform;
	};
	// Vest:
	if ( _vest isNotEqualTo "" ) then {
		// New vest replacement:
		[_unit, _vest, true] call THY_fnc_CSWR_loadout_vest;
	};
	// Backpack:
	// if has no parachute bag classname declared, and the unit is not in a vehicle:
	if ( _parachute isNotEqualTo "" && isNull (objectParent _unit) ) then {
		[_unit, _parachute, true, false] call THY_fnc_CSWR_loadout_backpack;  // Always set mandatory as true in this case coz the parachuter will always reach here with no backpack.
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_team_sniper_weapon = {
	// This function replace the old sniper rifle for new stuff. Parameters empties result no changes.
	// Returns nothing.

	params ["_unit", "_rifle", "_rifleNewMag", "_rifleNewOptics", "_rifleNewRail", "_rifleNewMuzzle", "_rifleNewBipod", ["_magAmount", 6]];
	private ["_tag", "_isValidClassnameMags", "_isValidClassnameRifle", "_rifleOldAccessories", "_rifleOldMag"];

	// Initial values:
		// Reserved space.
	// Declarations:
		_tag = [side _unit] call THY_fnc_CSWR_convertion_faction_to_tag;
		_isValidClassnameMags = [_tag, "CfgMagazines", "sniper magazine", "of sniper rifle magazines", [_rifleNewMag]] call THY_fnc_CSWR_is_valid_classname;
		_isValidClassnameRifle = [_tag, "CfgWeapons", "sniper rifle or weapon gear", "of sniper weapon stuff", [_rifle, _rifleNewOptics, _rifleNewRail, _rifleNewMuzzle, _rifleNewBipod]] call THY_fnc_CSWR_is_valid_classname;
		_rifleOldAccessories = _unit weaponAccessories (primaryWeapon _unit);  // [silencer, laserpointer/flashlight, optics, bipod] like ["","acc_pointer_IR","optic_Aco",""]
		//private _rifleOldMags = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "magazines");  // collect all types of magazines from primary weapon.
		_rifleOldMag = primaryWeaponMagazine _unit;  // old mag loaded on rifle.
	// Magazine (Crucial: need to be first!)
		if ( _rifle != "REMOVED" ) then {  // it's correct about rifle here in magazines!
			if ( _rifleNewMag isNotEqualTo "" && _rifleNewMag != "REMOVED" && _isValidClassnameMags ) then {
				// Removing all old rifle magazines from the loadout:
				_unit removeMagazines (_rifleOldMag # 0); 
				// Include new magazines in loadout containers (the old ones only will be removed if the rifle was replaced):
				_unit addMagazines [_rifleNewMag, _magAmount];
			// Got new rifle but magazine wasn't declared:
			} else {
				if ( _rifleNewMag == "REMOVED" ) then {
					// Removing all rifle magazines from the loadout:
					_unit removeMagazines (_rifleOldMag # 0);
				};
				// Something is written in Rifle Customization but is not "REMOVED", and the Mag Custom is empty/valid, so:
				if ( _rifle isNotEqualTo "" && _isValidClassnameMags ) then {
					// Warning message:
					["%1 WATCH > %2 '%3' needs magazines for their new rifle!", CSWR_txtWarningHeader, _tag, str (group _unit)] call BIS_fnc_error; sleep 5;
				};
			};
		} else {
			// Warning message:
			if CSWR_isOnDebugGlobal then { 
				["%1 WATCH > To set a custom magazine to %2 '%3' sniper group, first don't remove the rifle to them in 'fn_CSWR_loadout.sqf' file!", CSWR_txtWarningHeader, _tag, str (group _unit)] call BIS_fnc_error; sleep 5;
			};
		};
	// Rifle:
		if ( _rifle isNotEqualTo "" && _rifle != "REMOVED" ) then {  // Rifle is mandatory for sniper group.
			// removes primary weapon:
			_unit removeWeapon (primaryWeapon _unit);
			// Add the new rifle (without magazines and acessories):
			_unit addWeapon _rifle;
			// Add an additional new magazine directly on the weapon loader:
			_unit addPrimaryWeaponItem _rifleNewMag;
			// Use the new rifle since mission starts:
			_unit selectWeapon _rifle;
		} else {
			if ( _rifle == "REMOVED") then {
				["%1 WATCH > %2 '%3' needs a primary weapon. No rifle will be removed from them!", CSWR_txtWarningHeader, _tag, str (group _unit)] call BIS_fnc_error; sleep 5;
			};
		};
	// Optics:
		if ( _rifle != "REMOVED" && _rifleNewOptics isNotEqualTo "" && _rifleNewOptics != "REMOVED" ) then {
			// removes old optics if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 2);
			// adds the new optics:
			_unit addPrimaryWeaponItem _rifleNewOptics;
		} else {
			if ( _rifleNewOptics == "REMOVED" && (_rifleOldAccessories # 2) isNotEqualTo "" ) then {
				// removes old optics if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 2);
			};
		};
	// Rail:
		if ( _rifle != "REMOVED" && _rifleNewRail isNotEqualTo "" && _rifleNewRail != "REMOVED" ) then {
			// removes old rail item if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 1);
			// adds the new rail item:
			_unit addPrimaryWeaponItem _rifleNewRail;
		} else {
			if ( _rifleNewRail == "REMOVED" && (_rifleOldAccessories # 1) isNotEqualTo "" ) then {
				// removes old rail item if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 1);
			};
		};
	// Muzzle:
		if ( _rifle != "REMOVED" && _rifleNewMuzzle isNotEqualTo "" && _rifleNewMuzzle != "REMOVED" ) then {
			// removes old muzzle if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 0);
			// adds the new muzzle:
			_unit addPrimaryWeaponItem _rifleNewMuzzle;
		} else {
			if ( _rifleNewMuzzle == "REMOVED" && (_rifleOldAccessories # 0) isNotEqualTo "" ) then {
				// removes old muzzle if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 0);
			};
		};
	// Bipod:
		if ( _rifle != "REMOVED" && _rifleNewBipod isNotEqualTo "" && _rifleNewBipod != "REMOVED" ) then {
			// removes old bipod if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 3);
			// adds the new bipod:
			_unit addPrimaryWeaponItem _rifleNewBipod;
		} else {
			if ( _rifleNewBipod == "REMOVED" && (_rifleOldAccessories # 3) isNotEqualTo "" ) then {
				// removes old bipod if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 3);
			};
		};
	// Return:
	true;
};


THY_fnc_CSWR_spawn_type_checker = {
	// This function validates if the group type selected is abled to spawn in a specific spawnpoint-type.
	// Returns _isValid. Bool.

	params ["_spwns", "_grpType"];
	private ["_isValid", "_grpTypesAble"];

	// Initial values:
	_isValid = false;
	_grpTypesAble = [];
	// Escape:
	if ( _grpType isEqualTo "" ) exitWith { _isValid /* Returning... */ };
	if ( count _spwns == 0 ) exitWith { _isValid /* Returning... */ };
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Figure out which spawnpoint-type the function will work:
	switch _spwns do {
		// Blu
		case CSWR_spwnsBLU:         { _grpTypesAble = CSWR_spwnsAbleBLU };
		case CSWR_spwnsVehBLU:      { _grpTypesAble = CSWR_spwnsVehAbleBLU };
		case CSWR_spwnsHeliBLU:     { _grpTypesAble = CSWR_spwnsHeliAbleBLU };
		case CSWR_spwnsParadropBLU: { _grpTypesAble = CSWR_spwnsParadropAbleBLU };
		// Opf
		case CSWR_spwnsOPF:         { _grpTypesAble = CSWR_spwnsAbleOPF };
		case CSWR_spwnsVehOPF:      { _grpTypesAble = CSWR_spwnsVehAbleOPF };
		case CSWR_spwnsHeliOPF:     { _grpTypesAble = CSWR_spwnsHeliAbleOPF };
		case CSWR_spwnsParadropOPF: { _grpTypesAble = CSWR_spwnsParadropAbleOPF };
		// Ind
		case CSWR_spwnsIND:         { _grpTypesAble = CSWR_spwnsAbleIND };
		case CSWR_spwnsVehIND:      { _grpTypesAble = CSWR_spwnsVehAbleIND };
		case CSWR_spwnsHeliIND:     { _grpTypesAble = CSWR_spwnsHeliAbleIND };
		case CSWR_spwnsParadropIND: { _grpTypesAble = CSWR_spwnsParadropAbleIND };
		// Civ
		case CSWR_spwnsCIV:         { _grpTypesAble = CSWR_spwnsAbleCIV };
		case CSWR_spwnsVehCIV:      { _grpTypesAble = CSWR_spwnsVehAbleCIV };
		case CSWR_spwnsHeliCIV:     { _grpTypesAble = CSWR_spwnsHeliAbleCIV };
		case CSWR_spwnsParadropCIV: { _grpTypesAble = CSWR_spwnsParadropAbleCIV };
	};
	// Check if the ground is abled to spawn in this type of spawnpoint:
	if ( _grpType in _grpTypesAble ) then { _isValid = true };
	// Return:
	_isValid;
};


THY_fnc_CSWR_spawn_and_go = {
	// This function checks if the group/vehicle needs to wait to spawn or if it's been granted to do its first move in game.
	// Returns nothing.

	params ["_spwns", "_spwnDelayMethods", "_grpInfo", "_isVeh", "_behavior", "_destType"];
	private ["_isValidToSpwnHere", "_canSpawn", "_veh", "_spwn", "_spwnPos", "_paradrop", "_isSpwnParadrop", "_vehDict", "_counter", "_blockers", "_time", "_faction", "_tag", "_grp", "_grpType", "_grpClassnames", "_isVehAir", "_grpSize", "_requester", "_txt1", "_txt2", "_txt3"];

	// Escape:
	if ( _grpInfo isEqualTo [] ) exitWith {};
	// Initial values:
	_isValidToSpwnHere = false;
	_canSpawn = true;
	_veh = objNull;
	_spwn = "";
	_spwnPos = [];
	_paradrop = [];
	_isSpwnParadrop = false;
	_vehDict = [];
	_counter = 0;
	_blockers = [];
	_time = 0;
	// Errors handling:
		// reserved space.
	// Declarations:
	_faction       = _grpInfo # 0;
	_tag           = _grpInfo # 1;
	_grp           = _grpInfo # 2;
	_grpType       = _grpInfo # 3;
	_grpClassnames = _grpInfo # 4;
	_isVehAir      = [_grpType] call THY_fnc_CSWR_group_type_helicopter;
	_grpSize       = count _grpClassnames;  // debug proposes.
	_requester     = if _isVeh then {"vehicle"} else {"group"};
	// Debug texts:
	_txt1 = format ["A %1 %2 has an error in 'fn_CSWR_population.sqf' file.", _tag, _requester];
	_txt2 = format ["For script integraty, the %1 WON'T SPAWN!", _requester];
	_txt3 = format ["%1 %2 %3 will spawn LATER.", str _grpSize, _tag, if _isVeh then {"vehicle and its crew"} else {"unit(s) of a group"}];

	// Basic Validation Step 1/1:
	// Check if the group-type is abled to spawn in selected spawnpoints-type:
	_isValidToSpwnHere = [_spwns, _grpType] call THY_fnc_CSWR_spawn_type_checker;
	// Escape > if group-type is NOT valid to spawn here:
	if !_isValidToSpwnHere exitWith {
		// Flag to abort the group/vehicle spawn:
		_canSpawn = false;
		// Warning message:
		["%1 SPAWN > %2 group-type '%3' is NOT ALLOWED to spawn in the selected spawns-type: %4.", CSWR_txtWarningHeader, _tag, _grpType, str _spwns] call BIS_fnc_error;
		// Message breath:
		sleep 5;
	};
	// Check if _spwnDelayMethods is in the correct format:
	if ( typeName _spwnDelayMethods isEqualTo "ARRAY" ) then {

		// SPAWN DELAY SECTION:
		// If _spwnDelayMethods is not empty, it's coz the group needs Spawn Delay:
		if ( count _spwnDelayMethods > 0 ) then {
			
			// Spawn Delay Validation Step 1/4:
			// Escape > If the object doesn't exist:
			{  // forEach _spwnDelayMethods:
				if ( isNil "_x" ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpawn = false;
					// Warning message:
					["%1 SPAWN DELAY > %2 Make sure you SPELLED the trigger or target name(s) CORRECTLY. %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error; sleep 5;
				};
			} forEach _spwnDelayMethods;
			// If the object doesn't exist, the spawn isn't available, so there's no reason the keep the validation process running:
			if !_canSpawn exitWith {};

			// Spawn Delay Validation Step 2/4:
			// Escape > If there is more than 1 timer, abort the spawn:
			{  // forEach _spwnDelayMethods:
				if ( { typeName _x isEqualTo "SCALAR" } count _spwnDelayMethods > 1 ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpawn = false;
					// Warning message:
					["%1 SPAWN DELAY > %2 It's NOT abled a group with more than 1 TIMER. %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error; sleep 5;
				};
			} forEach _spwnDelayMethods;
			// If the object doesn't exist, the spawn isn't available, so there's no reason the keep the validation process running:
			if !_canSpawn exitWith {};

			// Spawn Delay Validation Step 3/4:
			// Errors handling > If the method is Timer:
			{  // forEach _spwnDelayMethods:
				if ( typeName _x isEqualTo "SCALAR" ) then {
					// If the Timer value is 0 (invalid), delete it from the array and keep going the validation:
					// Important: editors during the mission edition will use "0" in array istead of leave that empty.
					if ( _x == 0 ) then { _spwnDelayMethods deleteAt (_spwnDelayMethods find 0)};
				};
			} forEach _spwnDelayMethods;

			// Spawn Delay Validation Step 4/4:
			// Escape > If some spawn delay method is in a wrong format, abort the spawn:
			{  // forEach _spwnDelayMethods:
				if ( !(typeName _x in ["OBJECT", "SCALAR"]) ) exitWith { 
					// Flag to abort the group/vehicle spawn:
					_canSpawn = false;
					// Warning message:
					["%1 SPAWN DELAY > %2 Make sure you're using a timer, triggers, and targets without quotes, e.g: [300] or [varname_1] or [varname_1, varname_2] or [300, varname_1, varname_2]. %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error; sleep 5;
				};
			} forEach _spwnDelayMethods;

			// If everything is fine, Spawn Delay:
			if _canSpawn then {
				// Debug:
				if CSWR_isOnDebugGlobal then {
					// Debug monitor > How many units will spawn soon:
					CSWR_spwnDelayQueueAmount = CSWR_spwnDelayQueueAmount + _grpSize;
					publicVariable "CSWR_spwnDelayQueueAmount";
					// Debug message:
					systemChat format ["%1 SPAWN DELAY > %2", CSWR_txtDebugHeader, _txt3];
					// Message breath:
					sleep 5;
				};
				// Verify all Spawn Delay methods the group will use:
				[_tag, _spwnDelayMethods, _isVeh, _grpSize] call THY_fnc_CSWR_spawn_delay;
			};
		};
	// Otherwise, if the _spwnDelayMethods is not an array:
	} else {
		// Flag to abort the group/vehicle spawn:
		_canSpawn = false;
		// Warning message:
		["%1 SPAWN DELAY > %2 %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error;
		// Message breath:
		sleep 5;
	};

	// SPAWN SECTION:
	if _canSpawn then {
		// Select a spawn:
		_spwn = selectRandom _spwns;
		// Check if they will be paratroopers/parachuters:
		_paradrop = [_spwns, markerPos _spwn, _isVeh, _isVehAir] call THY_fnc_CSWR_is_spawn_paradrop;
		_isSpwnParadrop = _paradrop # 0;
		_spwnPos = _paradrop # 1;

		// If NOT vehicle:
		if !_isVeh then {
			// SPAWNING GROUP OF PEOPLE:
			// Create the group:
			_grp = [_spwnPos, _faction, _grpClassnames, [],[],[],[],[], markerDir _spwn, false, 0] call BIS_fnc_spawnGroup; // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
		// Otherwise, if vehicle:
		} else {
			// SPAWNING THE GROUND VEHICLE:
			if !_isVehAir then {
				// If the vehicle will spawn on ground:
				if !_isSpwnParadrop then {
					// Find an empty place near to the ground spawn-point:
					_spwnPos = _spwnPos findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valius might result in vehicle explosions.
				};
				// Create the vehicle and its crewmen:
				_vehDict = [_spwnPos, markerDir _spwn, _grpClassnames # 0, _faction] call BIS_fnc_spawnVehicle;  // https://community.bistudio.com/wiki/BIS_fnc_spawnVehicle
				_grp = _vehDict # 2;  // _vehDict content: [createdVehicle, crew, group]
				_veh = vehicle leader _grp;
				// Vehicle config > Features:
				_veh setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners never will leave the their vehicle.
			// Otherwise, if the vehicle is a helicopter:
			} else {
				// SPAWNING THE HELICOPTER:
				// Looping until to find an unblocked spawn-point exclusive for:
				while { true } do {
					// Check if something relevant is blocking the _spwn position:
					_blockers = markerPos _spwn nearEntities [["Helicopter", "Plane", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "Ship", "Submarine"], 20];
					// If there's a blocker:
					if ( count _blockers isNotEqualTo 0 ) then { _counter = _counter + 1 } else { break };
					// Select a new spawn option:
					_spwn = selectRandom _spwns;
					// Debug:
					if ( CSWR_isOnDebugGlobal && _counter > 5 ) then {
						// Restart the counter for the next tries:
						_counter = 0;
						// Messages:
						systemChat format ["%1 HELICOPTER > A %2 helicopter waiting a HELIPAD to be clear. Next try soon...", CSWR_txtDebugHeader, _tag];
						if CSWR_isOnDebugHeli then { { systemChat format ["HELIPAD BLOCKER is:   %1", typeOf _x] } forEach _blockers };
					};
					// Breath for the next loop check:
					sleep 5;  // IMPORTANT: leave this command in the final of this scope/loop, never in the beginning.
				};  // While loop ends.
				// If Helicopter must spawn already in air:
				if CSWR_shouldHeliSpwnAir then {
					_veh = createVehicle [_grpClassnames # 0, markerPos _spwn, [], 0, "FLY"];
				// Otherwise, Helicopter must spawn landed:
				} else {
					_veh = createVehicle [_grpClassnames # 0, markerPos _spwn, [], 0, "NONE"];
				};
				_grp = createVehicleCrew _veh;
				// Helicopter config > Features:
					if ( _grpType isEqualTo "heliL" ) then { _veh flyInHeight abs CSWR_heliLightAlt };
					if ( _grpType isEqualTo "heliH" ) then { _veh flyInHeight abs CSWR_heliHeavyAlt };
			};
			// Any vehicle config > Features:
			_veh setVehicleReportOwnPosition true;
			_veh setVehicleReceiveRemoteTargets true;
			_veh setVehicleReportRemoteTargets true;
		};
		// Update the _grpInfo:
		_grpInfo set [2, _grp];
		// Group/Vehicle config > Server performance:
		_grp deleteGroupWhenEmpty true;
		// Group/Ground vehicle config > Loadout customization:
		if !_isVehAir then { { [_faction, _grpType, _x, _isSpwnParadrop] call THY_fnc_CSWR_loadout; sleep 0.1 } forEach units _grp };
		// Group/Vehicle config > Units skills:
		[_grpType, _grp, _destType] call THY_fnc_CSWR_unit_skills;
		// Group config > Formation:
		if !_isVeh then { [_grpInfo] call THY_fnc_CSWR_group_formation };
		// Group/Vehicle config > Adding to ZEUS:
		if CSWR_isEditableByZeus then {
			{  // forEach allCurators:
				// Unit(s):
				_x addCuratorEditableObjects [units _grp, true];
				// Vehicle itself:
				if _isVeh then { _x addCuratorEditableObjects [[vehicle (leader _grp)], true] };
			} forEach allCurators;
		};
		// Helicopter config > Takeoff delay:
		if _isVehAir then {
			// Wait a bit:
			_time = time + (random CSWR_heliTakeoffDelay);
			waitUntil { sleep 1; time >= _time };
			// Debug message:
			if CSWR_isOnDebugGlobal then { systemChat format ["%1 %2 '%3' helicopter is TAKING OFF!", CSWR_txtDebugHeader, _tag, str _grp] };
		};

		// If the spawn is a Spawn Paradrop:
		if _isSpwnParadrop then { [_veh] call THY_fnc_CSWR_paradrop; sleep 10 };

		// WAYPOINTS SECTION:
		// Group/Vehicle config > Move:
		[_spwns, _destType, _tag, _grpType, _grp, _behavior, _isVeh, _isVehAir] spawn THY_fnc_CSWR_go;
	};
	// Return:
	true;
};


THY_fnc_CSWR_spawn_delay = {
	// This function verify what method of Spawn Delay the group/vehicle will execute.
	// Returns nothing.

	params ["_tag", "_spwnDelayMethods", "_isVeh", "_grpSize"];
	private ["_isReadyToSpwn", "_counter", "_wait", "_requester", "_txt1"];

	// Escape:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Initial values:
	_isReadyToSpwn = false;
	_counter = 0;
	// Declarations:
	_wait = 10;  // CAUTION: this number is used to calcs the TIMER too.
	_requester = if _isVeh then {"vehicle"} else {"group"};
	// Debug texts:
	_txt1 = format ["A %1 %2 was granted TO SPAWN", _tag, _requester];

	// Spawn Delay conditions > Stay checking if the group ISN'T ready to spawn:
	while { !_isReadyToSpwn } do {
		// Delay for each loop check:
		sleep _wait;
		// Escape:
			// reserved space.

		{  // forEach _spwnDelayMethods:
			// TIMER DELAY:
			// If Spawn Delay has a timer, check if it's a number:
			if ( typeName _x isEqualTo "SCALAR" ) then {
				// Counter increase:
				_counter = _counter + _wait;
				// Timer checker:
				if ( _counter >= abs _x ) exitWith {  // (abs command avoid negative numbers).
					// Function completed:
					_isReadyToSpwn = true;
					// Debug message:
					if CSWR_isOnDebugGlobal then {
						systemChat format ["%1 SPAWN DELAY > %2 by TIMER (it was %3 secs).", CSWR_txtDebugHeader, _txt1, _counter];
						// Message breath:
						sleep 5;
					};
				};
			// otherwise:
			} else {
				// TRIGGER DELAY:
				// If Spawn Delay has a trigger, check if it's a trigger object:
				if ( _x isKindOf "EmptyDetector" ) then { 
					// If the trigger has been activated:
					if ( triggerActivated _x ) exitWith { 
						// Function completed:
						_isReadyToSpwn = true; 
						// Debug message:
						if CSWR_isOnDebugGlobal then {
							systemChat format ["%1 SPAWN DELAY > %2 by TRIGGER activation (%3).", CSWR_txtDebugHeader, _txt1, str _x];
							// Message breath:
							sleep 5;
						};
					};
				// Otherwise:
				} else {
					// TARGET DELAY:
					// If the target has been killed/destroyed:
					if ( !alive _x ) exitWith {
						// Function completed:
						_isReadyToSpwn = true;
						// Debug message:
						if CSWR_isOnDebugGlobal then {
							systemChat format ["%1 SPAWN DELAY > %2 by TARGET elimination/destruction (%3).", CSWR_txtDebugHeader, _txt1, str _x];
							// Message breath:
							sleep 5;
						};
					};
				};
			};
		} forEach _spwnDelayMethods;
	};  // while loop ends;
	// Debug:
	if CSWR_isOnDebugGlobal then {
		// Debug monitor > How many units will spawn soon:
		CSWR_spwnDelayQueueAmount = CSWR_spwnDelayQueueAmount - _grpSize;
		publicVariable "CSWR_spwnDelayQueueAmount";
	};
	// Return:
	true;
};


THY_fnc_CSWR_add_group = {
	// This function requests and prepares the basic of the creation of a group of AI soldiers.
	// Returns nothing.
	
	params ["_faction", ["_spwns", []], ["_grpClassnames", []], ["_form", ""], ["_behavior", ""], ["_destType", ""], ["_spwnDelayMethods", 0]];
	private ["_tag", "_isValidClassnames", "_isValidClassnameTypes", "_isValidBehavior", "_isThereDest", "_isValidForm", "_txt1", "_txt2", "_grpInfo"];
	
	// Initial values:
		// reserved space.
	// Declarations:
	_tag = [_faction] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassnames = [_tag, "CfgVehicles", "unit", "_grpClassnames", _grpClassnames] call THY_fnc_CSWR_is_valid_classname;
	_isValidClassnameTypes = [_tag, _grpClassnames, ["Man"], false] call THY_fnc_CSWR_is_valid_classnames_type;
	_isValidBehavior = [_tag, false, _behavior] call THY_fnc_CSWR_is_valid_behavior;
	_isThereDest = [_tag, false, _destType] call THY_fnc_CSWR_is_valid_destination;
	_isValidForm = [_tag, false, _form] call THY_fnc_CSWR_is_valid_formation;
	// Debug texts:
	_txt0 = format ["IMPOSSIBLE TO SPAWN a %1 group in spawn-points from another faction. Check 'fn_CSWR_population.sqf' file and make sure all %1 group lines have the spawn-point assigned to 'CSWR_spwns%1'.", _tag];
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a group. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _tag];
	_txt2 = format ["%1 > At least one type of group configured in 'fn_CSWR_population.sqf' file HAS NO classname(s) declared for CSWR script get to know which unit(s) should be created. FIX IT!", _tag];
	// Escape:
	if ( typeName _spwns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _grpClassnames == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	if ( toUpper (_spwns # 0) find _tag == -1 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt0] call BIS_fnc_error; sleep 5 };
	if !_isValidClassnames exitWith {};
	if !_isValidClassnameTypes exitWith {};
	if !_isValidForm exitWith {};
	if !_isValidBehavior exitWith {};
	if !_isThereDest exitWith {};
	// To check other escapes and errors handling based in _grpClassnames):
	_grpInfo = [_faction, _tag, _grpClassnames, _destType, _behavior, _form] call THY_fnc_CSWR_group_type_rules;
	// Escape > Invalid group:
	if ( _grpInfo isEqualTo [] ) exitWith {};
	// Spawn Schadule:
	[_spwns, _spwnDelayMethods, _grpInfo, false, _behavior, _destType] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breath:
	sleep 1;
	// Return:
	true;
};


THY_fnc_CSWR_add_vehicle = {
	// This function requests and prepares the basic of the creation of a vehicle and its AI crewmen.
	// Returns nothing.
	
	params ["_faction", ["_spwns", []], ["_vehClassname", ""], ["_behavior", ""], ["_destType", ""], ["_spwnDelayMethods", 0]];
	private ["_tag", "_isValidClassnames", "_isValidClassnameTypes", "_isHeli", "_isValidBehavior", "_isThereDest", "_txt0", "_txt1", "_txt2", "_txt3", "_grpInfo"];
	
	// Initial values:
		// reserved space.
	// Declarations:
	_tag = [_faction] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isValidClassnames = [_tag, "CfgVehicles", "vehicle", "_vehClassname", [_vehClassname]] call THY_fnc_CSWR_is_valid_classname;
	_isValidClassnameTypes = [_tag, [_vehClassname], ["Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "Helicopter"], true] call THY_fnc_CSWR_is_valid_classnames_type;
	_isHeli = if ( _vehClassname isKindOf "Helicopter" ) then { true } else { false };
	_isValidBehavior = [_tag, true, _behavior] call THY_fnc_CSWR_is_valid_behavior;
	_isThereDest = [_tag, true, _destType] call THY_fnc_CSWR_is_valid_destination;
	// Debug texts:
	_txt0 = "For script integraty, the vehicle WON'T SPAWN!";
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a vehicle. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _tag];
	_txt2 = format ["A %1 HELICOPTER HAS NO SPAWNPOINT. Each heli needs its own SPAWN-MARKER on Eden, e.g. 'cswr_spawnheli_%2_aNumber'.", _tag, toLower _tag];
	_txt3 = format ["%1 > At least one type of vehicle configured in 'fn_CSWR_population.sqf' file HAS NO classname declared for CSWR script get to know which vehicle should be created. FIX IT!", _tag];
	_txt4 = format ["IMPOSSIBLE TO SPAWN a %1 vehicle in spawn-points from another faction. Check 'fn_CSWR_population.sqf' file and make sure all %1 vehicle lines have the spawn-point assigned to 'CSWR_spwns%1' or 'CSWR_spwnsVeh%1' or 'CSWR_spwnsHeli%1'.", _tag];
	// Escape:
	if ( typeName _spwns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 && !_isHeli ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 && _isHeli ) exitWith { ["%1 %2 %3", CSWR_txtWarningHeader, _txt2, _txt0] call BIS_fnc_error; sleep 5 };
	if ( _vehClassname isEqualTo "" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt3] call BIS_fnc_error; sleep 5 };
	if ( toUpper (_spwns # 0) find _tag == -1 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt4] call BIS_fnc_error; sleep 5 };
	if !_isValidClassnames exitWith {};
	if !_isValidClassnameTypes exitWith {};
	if !_isValidBehavior exitWith {};
	if !_isThereDest exitWith {};
	// To check other escapes and errors handling based in type of _vehClassname:
	_vehClassname = [_vehClassname];  // Converting string to array. In "fn_CSWR_population.sqf" vehicles are only strings to discourage the editor from creating groups of vehicles.
	_grpInfo = [_faction, _tag, _vehClassname, _destType, _behavior, ""] call THY_fnc_CSWR_group_type_rules;
	// Escape > Invalid group:
	if ( _grpInfo isEqualTo [] ) exitWith {};
	// Spawn Schadule:
	[_spwns, _spwnDelayMethods, _grpInfo, true, _behavior, _destType] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breath:
	sleep 10;  // CRITICAL: helps to avoid veh colissions and explosions at beggining of the match. <10 = heavy veh can blow up in spawn. <5 = any veh can blow up in spawn.
	// Return:
	true;
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
		_playersAlive = allPlayers - entities "HeadlessClient_F" select { alive _x && side _x == side _unitTarget };  // WIP - actually a friendly faction is not been considered here yet.
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

	params ["_spwns", "_spwnPos", "_isVeh", "_isVehAir"];
	private ["_return", "_isSpwnParadrop"];

	// Initial values:
	_isSpwnParadrop = false;
	_return = [_isSpwnParadrop, _spwnPos];
	// Escape:
	if _isVehAir exitWith { _return /* Returning... */};
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Main functionality:
	if ( _spwns isEqualTo CSWR_spwnsParadropBLU || _spwns isEqualTo CSWR_spwnsParadropOPF || _spwns isEqualTo CSWR_spwnsParadropIND || _spwns isEqualTo CSWR_spwnsParadropCIV ) then { 
		// Update the validation flag:
		_isSpwnParadrop = true;
		// Update the altitude of _spwnPos:
		if !_isVeh then {
			_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropUnitAlt];
		} else {
			_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropVehAlt];
		};
	};
	// Preparing to return:
	_return = [_isSpwnParadrop, _spwnPos];
	// Return:
	_return;
};


THY_fnc_CSWR_base_service_station = {
	// This function provides rearming, refueling and repairing for AI vehicles, and health for crewmen.
	// Returns nothing.

	params ["_spwns", "_tag", "_grpType", "_grp", "_veh", "_isHeli", "_destType", "_behavior"];
	private ["_wait"];

	// Escape:
	if ( isNull _grp || !alive _veh ) exitWith {};
	// Initial values:
		// reserved space.
	// Declarations:
	_wait = 30;
	// Debug texts:
		// reserved space.
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
		[_veh, 1] remoteExec ["setFuel", _veh];  //the same as "_veh setFuel 1;" but for multiplayer when the variable (setFuel) is not global variable.
		playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_refuel.wss", _veh];
		sleep _wait;
	// Rearming:
		if ( !alive _veh || !alive driver _veh ) exitWith {};  // escape.
		[_veh, 1] remoteExec ["setVehicleAmmo", _veh];  //the same as "_veh setVehicleAmmo 1;" but for multiplayer when the variable (setVehicleAmmo) is not global variable.
		playSound3D ["a3\sounds_f\sfx\ui\vehicles\vehicle_rearm.wss", _veh];
		sleep _wait;
	// Preparing to return to the battle:
	_veh engineOn true;
	sleep _wait;
	// If helicopter:
	if _isHeli then {
		// Dramatization breath:
		sleep (random CSWR_heliTakeoffDelay);
		// Debug message:
		if CSWR_isOnDebugGlobal then { systemChat format ["%1 After maintenance services, %2 '%3' helicopter's BACK TO DUTY!", CSWR_txtDebugHeader, _tag, str _grp] };
	// Otherwise:
	} else {
		// Reserved space.
	 };
	// Return to duty:
	[_spwns, _destType, _tag, _grpType, _grp, _behavior, true, _isHeli] spawn THY_fnc_CSWR_go;
	// Return:
	true;
};


THY_fnc_CSWR_vehicle_condition = {
	// This function checks the vehicle and its crew conditon (health, ammo, fuel, maintenance).
	// Return _shouldRTB. Bool.

	params["_grp", "_areaToPass", "_isHeli"];
	private["_shouldRTB", "_veh", "_driver", "_gunner"];

	// Escape:
		// reserved space.
	// Initial values:
	_shouldRTB = false;
	// Declarations:
	_tag = [side (leader _grp)] call THY_fnc_CSWR_convertion_faction_to_tag;
	_veh = vehicle (leader _grp);
	_driver = driver _veh;
	_gunner = gunner _veh;
	// Debug texts:
		// reserved space.
	// Waiting to the next waypoint:
	waitUntil {
		// If helicopter:
		if _isHeli then {
			// Breath for the next loop check:
			sleep 10;
			// Debug message > If helicopter is flighting (over 1 meter high):
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHeli && _isHeli && getPos _veh # 2 > 1 ) then {
				["%1 HELICOPTER > %2 '%3' > Pilot wounds: %4/1  |  Gunner wounds: %5/1  |  Heli damages: %6/1  |  Heli fuel: %7/0", CSWR_txtDebugHeader, _tag, str _grp, str damage _driver, str damage _gunner, damage _veh, fuel _veh] call BIS_fnc_error;
			};
			// Allows the heli to go to the next waypoint:
			isNull _grp || _veh distance _areaToPass < 200 || damage _veh > 0.4 || fuel _veh < 0.3 || damage _driver > 0.1;  // WIP ACE here!
		// Otherwise:
		} else {
			// Reserved space for other types of vehicles.
		};
	};
	// If the vehicle or crew has some of these conditions, the next waypoint must be the base:
	if ( damage _veh > 0.4 ||  fuel _veh < 0.3 || damage _driver > 0.1 ) then { _shouldRTB = true };  // WIP ACE here: NOT SURE IF IT's WORKS WELL WITH ACE!
	// Return:
	_shouldRTB;
};


THY_fnc_CSWR_go = {
	// This function select the type of movement the group/vehicle will execute in a row.
	// Returns nothing.

	params["_spwns", "_destType", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli"];
	//private["", "", ""];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	if ( _isVeh && !alive (vehicle leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Main functionality:
	switch _destType do {
		case "MOVE_ANY":        { [_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, false] spawn THY_fnc_CSWR_go_ANYWHERE };
		case "MOVE_PUBLIC":     { [_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, false] spawn THY_fnc_CSWR_go_dest_PUBLIC };
		case "MOVE_RESTRICTED": { [_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, false] spawn THY_fnc_CSWR_go_dest_RESTRICTED };
		case "MOVE_WATCH":      { [_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_WATCH };  // Vehicles and Civilian faction are not able to do this.
		case "MOVE_OCCUPY":     { [_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY };  // Vehicles are not able to do this.
		case "MOVE_HOLD":       { [_spwns, _tag, _grpType, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD };  // Helicopters are not able to do this.
		// And if something wrong:
		default { ["%1 %2 '%3' group has an UNKNOWN DESTINATION. Check the 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, str _grp] call BIS_fnc_error; sleep 5 };
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_next_condition = {
	// This function checks if the group or vehicle have been reached the condition for the next waypoint.
	// Returns _shouldRTB. Bool.

	params ["_grp", "_areaToPass", "_isVeh", "_isHeli"];
	private ["_shouldRTB"];

	// Escape:
		// reserved space.
	// Initial values:
	_shouldRTB = false;
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Main functionality:
	// If a vehicle:
	if _isVeh then {
		// If a helicopter:
		if _isHeli then {
			// Looping to decide what waypoint comes next (combat or base):
			_shouldRTB = [_grp, _areaToPass, _isHeli] call THY_fnc_CSWR_vehicle_condition;
		// If a ground vehicle:
		} else {
			waitUntil { sleep 10; isNull _grp || leader _grp distance _areaToPass < 10 };
		};
	// Otherwise, if a group:
	} else {
		waitUntil { sleep 15; isNull _grp || leader _grp distance _areaToPass < 10 };
	};
	// Return:
	_shouldRTB;
};


THY_fnc_CSWR_go_RTB = {
	// This function checks set where are the service stations for vehicles in the faction base.
	// Returns nothing.

	params ["_spwns", "_tag", "_grpType", "_grp", "_isHeli", "_destType", "_behavior"];
	private ["_wp", "_faction", "_veh", "_distToLanding", "_closestStationPos"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
	_wp = [];
	// Declarations:
	_faction = side leader _grp;
	_veh = vehicle (leader _grp);
	_distToLanding = if ( _grpType isEqualTo "heliL" ) then { abs CSWR_heliLightAlt + 50 } else { if ( _grpType isEqualTo "heliH" ) then { abs CSWR_heliHeavyAlt + 50 } else { 300 }  }; // critical!
	_closestStationPos = [_spwns, _veh] call THY_fnc_CSWR_go_RTB_closest_station;
	// Escape:
	if ( isNull _grp || !alive _veh || !alive leader _grp ) exitWith {};
	// Creating the waypoint to the _closestStationPos:
	_wp = _grp addWaypoint [_closestStationPos, 0];
	_wp setWaypointCombatMode "GREEN";  // Hold fire, disengage, don't fire unless fired upon. Keep in formation.
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Debug message:
	if (CSWR_isOnDebugGlobal && alive _veh ) then {
		systemChat format ["%1 %2 '%3' helicopter returning to base!", CSWR_txtDebugHeader, _tag, str _grp];
	};
	// If already in base:
	waitUntil {
		// If helicopter:
		if _isHeli then {
			// Breath for the next loop check:
			sleep 10;
			// Allows the group move to the next waypoint:
			isNull _grp || !alive _veh || _veh distance _closestStationPos < _distToLanding;
		// Otherwise:
		} else {
			// Reserved space for other types of vehicles.
		};
	};
	// If helicopter, execute the landing:m
	if _isHeli then { [_spwns, _tag, _grpType, _grp, _veh, _destType, _behavior] spawn THY_fnc_CSWR_go_RTB_heli_landing };
	// Return:
	true;
};


THY_fnc_CSWR_go_RTB_closest_station = {
	// This function verifies which service station for vehicles is nearest to the group.
	// Returns _closestStationPos. Array of a marker position: [x,y,0].

	params["_factionStations", "_veh"];
	private["_closestStationPos", "_shortestDist", "_currentDist"];

	// Initial values:
	_closestStationPos = markerPos (_factionStations # 0);  // If only one station (spare solution).
	_shortestDist = 0;
	_currentDist = [];
	// Escape:
	if ( !alive _veh || !alive leader (group _veh) ) exitWith { _closestStationPos; /* Returning... */};
	// Debug texts:
		// reserved space.
	// If more than 1 station:
	if ( count _factionStations > 1 ) then {
		// Declarations:
		_shortestDist = _closestStationPos distance2D _veh;
		{  // forEach _factionStations:
			_currentDist = (markerPos _x) distance2D _veh;
			// Check which _closestStationPos is closer:
			if ( _currentDist < _shortestDist ) then { 
				// New shortest distance:
				_shortestDist = _currentDist;
				// Position of the new closest station:
				_closestStationPos = markerPos _x;
			};
		} forEach _factionStations;
	};
	// Return:
	_closestStationPos;
};


THY_fnc_CSWR_go_RTB_heli_landing = {
	// This function makes the helicopter to land in a safe place.
	// Returns nothing.

	params ["_spwns", "_tag", "_grpType", "_grp", "_veh", "_destType", "_behavior"];
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
	// Debug message:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHeli ) then { systemChat format ["%1 HELICOPTER > %2 '%3' landing at base...", CSWR_txtDebugHeader, _tag, str _grp] };
	// Wait 'til the heli touch the ground;
	waitUntil {
		// Large breath to the next loop check:
		sleep 30;
		// Check the helicopter touch the ground:
		(getPos _veh) # 2 < 0.2;
	};
	// Helicopter needs service:
	[_spwns, _tag, _grpType, _grp, _veh, true, _destType, _behavior] spawn THY_fnc_CSWR_base_service_station;
	// Return:
	true;
};


THY_fnc_CSWR_go_ANYWHERE = {
	// This function sets the group/vehicle to move to any destination (sum of almost all other preset destinations), including exclusive enemy faction destinations but excluding the specialized (watch, hold, occupy) ones. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli", "_shouldRTB"];
	private ["_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
		// reserved space.
	// Declarations:
	_areaToPass = markerPos (selectRandom CSWR_destsANYWHERE);
	// If everything is alright wih helicopter, go to right altitude:
	if ( _isHeli && !_shouldRTB ) then {
		// If helicopter, set the new waypoint altitude (z axis):
		if ( _grpType isEqualTo "heliL" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliLightAlt] };
		if ( _grpType isEqualTo "heliH" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliHeavyAlt] };
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0]; 
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_ANY", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If it's not a helicopter, so it's a ground vehicle or a group:
	if ( !_isHeli && !isNull _grp) then { sleep (random CSWR_destCommonTakeabreak) };
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_ANYWHERE;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_PUBLIC = { 
	// This function sets the group/vehicle to move through PUBLIC destinations where civilians and soldiers can go, excluding the specialized (watch, hold, occupy) ones and the waypoints restricted by other factions. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli", "_shouldRTB"];
	private ["_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
		// Reserved space.
	// Declarations:
	_areaToPass = markerPos (selectRandom CSWR_destsPUBLIC);
	// If everything is alright wih helicopter, go to right altitude:
	if ( _isHeli && !_shouldRTB ) then {
		// If helicopter, set the new waypoint altitude (z axis):
		if ( _grpType isEqualTo "heliL" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliLightAlt] };
		if ( _grpType isEqualTo "heliH" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliHeavyAlt] };
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0];
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_PUBLIC", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If it's not a helicopter, so it's a ground vehicle or a group:
	if ( !_isHeli && !isNull _grp) then { sleep (random CSWR_destCommonTakeabreak) };
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_dest_PUBLIC;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_RESTRICTED = { 
	// This function sets the group/vehicle to move only through the exclusive faction destinations, excluding public and specialized (watch, hold, occupy) ones. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli", "_shouldRTB"];
	private ["_destMarkers", "_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destMarkers = [];
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destMarkers = CSWR_destBLU };
		case OPFOR:       { _destMarkers = CSWR_destOPF };
		case INDEPENDENT: { _destMarkers = CSWR_destIND };
		case CIVILIAN:    { _destMarkers = CSWR_destCIV };
	};
	// Check the available RESTRICTED faction markers on map:
	_areaToPass = markerPos (selectRandom _destMarkers);
	// If everything is alright wih helicopter, go to right altitude:
	if ( _isHeli && !_shouldRTB ) then {
		// If helicopter, set the new waypoint altitude (z axis):
		if ( _grpType isEqualTo "heliL" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliLightAlt] };
		if ( _grpType isEqualTo "heliH" ) then { _areaToPass = [_areaToPass # 0, _areaToPass # 1, abs CSWR_heliHeavyAlt] };
	};
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0]; 
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_RESTRICTED", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If it's not a helicopter, so it's a ground vehicle or a group:
	if ( !_isHeli && !isNull _grp) then { sleep (random CSWR_destCommonTakeabreak) };
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_dest_RESTRICTED;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_WATCH = { 
	// This function sets the group to move only through the high natural spots destinations and stay there for as long the mission runs, watching around quiet, perfect for snipers and marksmen groups. It's NOT a looping.
	// Returns nothing.
	
	params ["_tag", "_grpType", "_grp", "_behavior"];
	private ["_destMarkers", "_areaToWatch", "_sniperSpot", "_chosenSpotPosToATL", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Error handling:
	if ( side (leader _grp) == CIVILIAN ) exitWith { ["%1 WATCH > Civilians CANNOT use Watch-Destinations. Please, fix it in 'fn_CSWR_population.sqf' file. For script integraty, the civilian group was deleted.", CSWR_txtWarningHeader] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Initial values:
	_destMarkers = [];
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destMarkers = CSWR_destWatchBLU };
		case OPFOR:       { _destMarkers = CSWR_destWatchOPF };
		case INDEPENDENT: { _destMarkers = CSWR_destWatchIND };
		case CIVILIAN:    { _destMarkers = CSWR_destWatchCIV };
	};
	// Check the available WATCH faction markers on map:
	_areaToWatch = markerPos (selectRandom _destMarkers);
	_sniperSpot = [_grp, _areaToWatch, CSWR_watchMarkerRange, _tag] call THY_fnc_CSWR_WATCH_find_spot;
	// Restart if previous try the spot was reserved:
	if ( count _sniperSpot == 0 ) exitWith { [_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_WATCH };
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, false] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, false] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_sniperSpot, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCombatMode "WHITE";  // FORCING THIS FOR SNIPERS // hold fire, kill only if own position spotted.
	_grp setCurrentWaypoint _wp;
	// Debug message:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
		{
			["%1 WATCH > %2 '%3' unit has their: aimingAccuracy = %4 | spotDistance = %5 | aimingSpeed = %6 | endurance = %7", CSWR_txtDebugHeader, _tag, str _x, (_x skill "aimingAccuracy"), (_x skill "spotDistance"), (_x skill "aimingSpeed"), (_x skill "endurance")] call BIS_fnc_error; sleep 5;
		} forEach units _grp;
	};
	// LAST 100 METERS 'TIL THE SPOT:
	waitUntil {sleep 5; ((leader _grp) distance _sniperSpot) < 100 };
	// From here, keep stealth to make sure the spot is clear:
	_grp setBehaviourStrong "STEALTH";  // Every unit in the group, and the group itself.
	_grp setSpeedMode "LIMITED";
	{ 
		// Prone:
		_x setUnitPos "DOWN";
		// Dont speak anymore:
		_x setSpeaker "NoVoice";
	} forEach units _grp;
	// Wait the arrival:
	waitUntil { sleep 5; (leader _grp) distance _sniperSpot < 3 };
	// Make the arrival smooth:
	sleep 1;
	// Go to the next WATCH stage:
	[_grp, _areaToWatch, _behavior, _tag] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_find_spot = {
	// This function finds first a specific type of locations and, later, a spot around the selected location for snipers execute the overwatching further.
	// Return _sniperPos: array.

	params ["_grp", "_areaToWatch", "_range", "_tag"];
	private ["_sniperPos", "_location", "_locationPos", "_locationPosATL",  "_obj", "_disLocToArea", "_attemptCounter", "_isReservedToAnother", "_roadsAround", "_mkrLocPos", "_wait", "_locations"];

	// Initial values:
	_sniperPos = [];
	_location = nil;
	_locationPos = [];
	_locationPosATL = [];
	_obj = objNull;
	_disLocToArea = nil;
	_attemptCounter = 0;
	_isReservedToAnother = false;
	_roadsAround = [];
	_mkrLocPos = objNull;
	// Declarations:
	_wait = 10;
	// Finding out specific types of locations around:
	_locations = nearestLocations [_areaToWatch, ["RockArea", "Hill", "ViewPoint", "Flag"], _range];
	// If found at least one location:
	if ( count _locations != 0 ) then {
		// Debug markers:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
			{  // forEach _locations:
				// Show me all locations found on the map with markers:
				_mkrLocPos = createMarker [str _x + str (side leader _grp), locationPosition _x];
				_mkrLocPos setMarkerType "hd_dot";
				switch ( side (leader _grp) ) do {
					case BLUFOR: { 
						_mkrLocPos setMarkerColor "colorBLUFOR"; 
						str _x + str side (leader _grp) setMarkerPos [(locationPosition _x # 0) + 10, locationPosition _x # 1, 0];
					};
					case OPFOR: { 
						_mkrLocPos setMarkerColor "colorOPFOR";
						str _x + str side (leader _grp) setMarkerPos [locationPosition _x # 0, (locationPosition _x # 1) + 10, 0];
					};
					case INDEPENDENT: { 
						_mkrLocPos setMarkerColor "colorIndependent"; 
						str _x + str side (leader _grp) setMarkerPos [(locationPosition _x # 0) - 10, locationPosition _x # 1, 0];
					};
					//case CIVILIAN: {}; // not appliable here!
				};
			} forEach _locations;
		};
		// Select one randomly:
		_location = selectRandom _locations;  // return a location in this format: "Location Hill at 3999, 7028"
		// For each case, check which reserved list it should be included:
		switch ( side (leader _grp) ) do {
			case BLUFOR: {
				// If selected location is not reserved yet:
				if ( !(_location in (CSWR_watchReservedLocation # 0)) ) then {
					// Add it:
					(CSWR_watchReservedLocation # 0) pushBackUnique _location;
					// And update the public variable:
					publicVariable "CSWR_watchReservedLocation";
				// If selected location is already reserved for another group:
				} else {
					// flag:
					_isReservedToAnother = true;
				};
			};
			case OPFOR: {
				// If selected location is not reserved yet:
				if ( !(_location in (CSWR_watchReservedLocation # 1)) ) then {
					// Add it:
					(CSWR_watchReservedLocation # 1) pushBackUnique _location;
					// And update the public variable:
					publicVariable "CSWR_watchReservedLocation";
				// If selected location is already reserved for another group:
				} else {
					// flag:
					_isReservedToAnother = true;
				};
			};
			case INDEPENDENT: {
				// If selected location is not reserved yet:
				if ( !(_location in (CSWR_watchReservedLocation # 2)) ) then {
					// Add it:
					(CSWR_watchReservedLocation # 2) pushBackUnique _location;
					// And update the public variable:
					publicVariable "CSWR_watchReservedLocation";
				// If selected location is already reserved for another group:
				} else {
					// flag:
					_isReservedToAnother = true;
				};
			};
			// case CIVILIAN: {}  // Civilian is not appliable here!
		};
		// If the location is reserved for this current group, keep going:
		if ( !_isReservedToAnother ) then {
			// Declaring a position to the selected location:
			_locationPos = locationPosition _location;  // [144.000,411.000, -100.477]
			// Convert the position to ATL format:
			_locationPosATL = [_locationPos # 0, _locationPos # 1, 0];  // [144.000,411.000, 0]
			// Creating a generic asset on-the map to provide an object (and, next, check its position):
			//_obj = createVehicle ["Land_Canteen_F", _locationPosATL, [], 0, "CAN_COLLIDE"];
			_obj = createSimpleObject ["Land_Canteen_F", _locationPosATL, false];  // false = global / true = local.
			// Figuring out the distance between the location found (a hill peak, for example) and the area-target to watch:
			_disLocToArea = _obj distance _areaToWatch;
			// Delete the asset used as reference:
			deleteVehicle _obj;
			// Keep trying to find a good spot until got one or no tries left:
			while { _attemptCounter < 20 } do {
				// Finding a empty spot based on selected location position. 10m from _pos but not further 100m, not closer 4m to other obj, not in water, max gradient 0.7, not on shoreline:
				_sniperPos = [_locationPosATL, 10, 100, 4, 0, 0.7, 0] call BIS_fnc_findSafePos;  // Config: https://community.bistudio.com/wiki/BIS_fnc_findSafePos
				// Check if there's road around the sniper spot:
				_roadsAround = _sniperPos nearRoads 20;  // meters
				// WIP: trying to identify if there's a terrain between the sniper eyes and the area-target:
				//private _isTerrainBlockingView = terrainIntersect [_sniperPos, _areaToWatch];  // High cost for Engine/server (info from wiki);
				// If the spot is within target range and there's No any road too close, it potencialy is a good spot:
				if ( _sniperPos distance _areaToWatch <= _disLocToArea /* && (!isOnRoad _sniperPos) */ && count _roadsAround == 0 /* && (!_isTerrainBlockingView) */ ) then {
					// Done. Stop the looping:
					break;
				};
				// Counter:
				_attemptCounter = _attemptCounter + 1;
				// CPU breath til next go in case spot not found yet:
				sleep 1;
			};  // While-loop ends.
			// Message success:
			if ( _attemptCounter <= 20 ) then {
				// Debug message:
				if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %3 location(s) found, %2 '%4' moving: %5.", CSWR_txtDebugHeader, _tag, count _locations, str _grp, _location] };
			// Message fail:
			} else {
				// When debug mode on:
				if CSWR_isOnDebugGlobal then { ["%1 WATCH > %2 '%3' group has no good spot. Next try soon...", CSWR_txtDebugHeader, _tag, str _grp] call BIS_fnc_error };
				// CPU breath to prevent craze loopings:
				sleep _wait;
			};
		// If the location is already reserved for another (same faction) group:
		} else {
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 sniper group selected a location already reserved for other group. Next try soon...", CSWR_txtDebugHeader, _tag] call BIS_fnc_error };
			// CPU breath to prevent craze loopings:
			sleep _wait;
		};
	// If didnt find even one location:
	} else {
		// Warning message:
		["%1 WATCH > A %2 WATCH-MARKER (%3) looks has no natural high locations to scan around. Change its position is adviced.", CSWR_txtDebugHeader, _tag, str _areaToWatch] call BIS_fnc_error;
		// CPU breath to prevent craze loopings:
		sleep _wait;
	};
	// Return:
	_sniperPos;
};


THY_fnc_CSWR_WATCH_doWatching = {
	// This function organizes the sniper/marksman group during the overwatching. It's a looping.
	// Returns nothing.

	params ["_grp", "_areaToWatch", "_behavior", "_tag"];
	private ["_enemyDangerClose"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Declarations:
	_enemyDangerClose = 50;
	
	// STEP 1/4: RESETING
	{ 
		_x enableAI "PATH";
		_x doFollow (leader _grp);
	} forEach units _grp;  // reset the movement.
	// Force awareness on group and units:
	_grp setBehaviourStrong "AWARE";
	{  // forEach (units _grp):
		// If member is the SNIPER:
		if ( _x == (leader _grp) ) then {
			// Forcing this approach:
			_x setUnitCombatMode "YELLOW";  // fire at will, keep formation.
			// Make it smooth:
			sleep 3;
			// Better formation for sniper group during overwatch:
			_grp setFormation "DIAMOND";
			// Stay focus on the target-area:
			_x doWatch _areaToWatch;
		// If member is the SPOTTER:
		} else {
			// Forcing this approach:
			_x setUnitCombatMode "GREEN";  // hold fire, keep formation.
			// Wait the spotter get their position:
			waitUntil { sleep 3; speed _x == 0 || !alive _x };
			// Stay focus on the target-area:
			_x doWatch _areaToWatch;
			// Spotter uses binoculars:
			_x selectWeapon (binocular _x);
		};
		// Make it smooth:
		sleep 1;
		// Stay in position:
		_x disableAI "PATH";
		// Debug message:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit reseted: unitCombatMode '%4' / behaviour '%5' / elevation '%6' / pos fixed '%7' / leader '%8'", CSWR_txtDebugHeader, _tag, str _x, unitCombatMode _x, behaviour _x, round (getTerrainHeightASL (getPosATL _x)), !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 3 };
	} forEach units _grp;
	
	
	// STEP 2/4: SEEKING TARGETS
	// Debug message:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %2 Sniper in position and '%3'!", CSWR_txtDebugHeader, _tag, behaviour (leader _grp)]; sleep 1 };
	// Seek looping:
	while { behaviour (leader _grp) isNotEqualTo "COMBAT" } do {
		{  // forEach (units _grp):
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit: unitCombatMode '%4' / behaviour '%5' / pos fixed '%6' / leader '%7'", CSWR_txtDebugHeader, _tag, str _x, unitCombatMode _x, behaviour _x, !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 1 };
			// Forcing the sniper/leader 
			if ( _x isEqualTo leader _grp ) then {
				// leader behavior aware if they're feel safe:
				if ( behaviour _x isEqualTo "SAFE" ) then { _x setCombatBehaviour "AWARE" };
				// If a spotter is leader after leader death in aware stage:
				_x setUnitCombatMode "YELLOW";
			// If spotter:
			} else {
				// Check if spotter needs to help with fire:
				[_grp, _x, _enemyDangerClose] call THY_fnc_CSWR_WATCH_spotter_fire_support;
			};
			// CPU breath:
			sleep 1;
		} forEach units _grp;
		// CPU breath before restart the SEEKING loop:
		sleep 2;
	};  // While-loop ONE ends.

	// STEP 3/4: ENGAGING
	// Debug message:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %2 Sniper leader in position and '%3'!", CSWR_txtDebugHeader, _tag, behaviour (leader _grp)]; sleep 1 };
	// Combat looping:
	while { behaviour (leader _grp) isEqualTo "COMBAT" } do {
		{  // forEach (units _grp):
			// Error handling:
			if ( !alive _x || incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then { break };
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit: unitCombatMode '%4' / behaviour '%5' / pos fixed '%6' / leader '%7'", CSWR_txtDebugHeader, _tag, str _x, unitCombatMode _x, behaviour _x, !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 1 };
			// If enemy revealed is too close, unit can move again:
			if ( !isNull (getAttackTarget _x) && _x distance (getAttackTarget _x) < _enemyDangerClose ) then { _x doFollow leader _grp };
			// Remember the leader (or new leader):
			if ( _x == leader _grp ) then {
				_x setUnitCombatMode "YELLOW";
			// If spotter:
			} else {
				// Check if spotter needs to help with fire:
				[_grp, _x, _enemyDangerClose] call THY_fnc_CSWR_WATCH_spotter_fire_support;
			};
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch && !isNull (getAttackTarget _x) ) then { systemChat format ["%1 WATCH > %2 '%3' unit has a target: '%4'.", CSWR_txtDebugHeader, _tag, str _x, getAttackTarget _x]; sleep 1 };
			// CPU breath:
			sleep 1;
		} forEach units _grp;
		// CPU breath before restart the COMBAT loop:
		sleep 2;
	};  // While-loop TWO ends.

	// STEP 4/4: RESTART FROM STEP 1:
	[_grp, _areaToWatch, _behavior, _tag] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_spotter_fire_support = {
	// This function verifies if the unit members of sniper group must provide fire support for the group leader.
	// Returns nothing.

	params ["_grp", "_unit", "_enemyDangerClose"];

	// Escape:
	if ( _unit == (leader _grp) ) exitWith {};
	if ( !isNull (getAttackTarget _unit) && _unit distance (getAttackTarget _unit) < _enemyDangerClose ) exitWith {
		// Spotter get combat mode:
		_unit setCombatBehaviour "COMBAT";
		// Spotter can fire at will:
		_unit setUnitCombatMode "YELLOW";
		// Even if injured, spotter take their primary weapon:
		_unit selectWeapon (primaryWeapon _unit);
	};
	// If there's NOT combat and everyone is fine:
	if ( behaviour (leader _grp) isNotEqualTo "COMBAT" && (lifeState _unit) isNotEqualTo "INJURED" && lifeState (leader _grp) isNotEqualTo "INJURED" ) then {
		// Spotter hold fire:
		_unit setUnitCombatMode "GREEN";
		// Spotter uses only binoculars:
		_unit selectWeapon (binocular _unit);
	// But if something wrong:
	} else {
		// When in combat:
		if ( behaviour (leader _grp) isEqualTo "COMBAT" ) then {
			// if everyone if fine:
			if ( (lifeState _unit) isNotEqualTo "INJURED" && lifeState (leader _grp) isNotEqualTo "INJURED" ) then {
				// Spotter hold fire:
				_unit setUnitCombatMode "GREEN";
				// Spotter uses only binoculars:
				_unit selectWeapon (binocular _unit);
			};
			// if sniper is wounded:
			if ( (lifeState (leader _grp) isEqualTo "INJURED") ) then {
				// Spotter get combat mode:
				_unit setCombatBehaviour "COMBAT";
				// Spotter can fire at will:
				_unit setUnitCombatMode "YELLOW";
				// Even if injured, spotter take their primary weapon:
				_unit selectWeapon (primaryWeapon _unit);
			};
		// If NOT in combat:
		} else {
			// And sniper is wounded:
			if ( lifeState (leader _grp) isEqualTo "INJURED" ) then {
				// Spotter get combat mode:
				_unit setCombatBehaviour "COMBAT";
				// Spotter can fire at will:
				_unit setUnitCombatMode "YELLOW";
				// Even if injured, spotter take their primary weapon:
				_unit selectWeapon (primaryWeapon _unit);
			};
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_OCCUPY = { 
	// This function sets the group to move and occupy buildings in a certain marker range. It's a looping.
	// Returns nothing.
	
	params ["_tag", "_grpType", "_grp", "_behavior"];
	private ["_tag", "_destMarkers", "_bldgPos", "_spots", "_wp", "_grpLead", "_leadStuckCounter", "_getOutPos", "_distLimiterFromBldg", "_distLimiterFriendPlayer", "_distLimiterEnemy", "_wait", "_grpSize", "_regionToSearch", "_building"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destMarkers = [];
	_bldgPos = [];
	_spots = [];
	_wp = [];
	_grpLead = objNull;
	_leadStuckCounter = 0;
	_getOutPos = [];
	// Declarations:
	_distLimiterFromBldg = 10;  // Distance to activate occupy functions validations to group leader.
	_distLimiterFriendPlayer = 40;  // Distance to desactivate the AI teleport when player is around.
	_distLimiterEnemy = 200;  // Distance to desactivate the AI teleport when enemies (including player) are around.
	_wait = 10;  // Avoid crazy loopings in entery occupy functions. Be careful.
	_grpSize = count (units _grp);
	// Errors handling:
	if ( _grpSize > 6 ) exitWith { ["%1 OCCUPY > %2 '%3' group current size (%4) is too big for occupy movement integrity. Use groups composed from 1 to 6 units. For now, the group has been deleted.", CSWR_txtWarningHeader, _tag, str _grp, _grpSize] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Forcing unit basic setup to start the Occupy movement to prevent anomalies:
	{  // forEach of units _grp:
		_x enableAI "PATH";
		_x doFollow (leader _grp);
		sleep 0.25;
	} forEach units _grp;
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, false] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, false] call THY_fnc_CSWR_unit_behavior;
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destMarkers = CSWR_destOccupyBLU };
		case OPFOR:       { _destMarkers = CSWR_destOccupyOPF };
		case INDEPENDENT: { _destMarkers = CSWR_destOccupyIND };
		case CIVILIAN:    { _destMarkers = CSWR_destOccupyCIV };
	};
	// Check the available OCCUPY faction markers on map:
	_regionToSearch = markerPos (selectRandom _destMarkers);
	// Selecting one building from probably many others found in that range:
	_building = [_grp, side (leader _grp), _tag] call THY_fnc_CSWR_OCCUPY_find_buildings_by_group;  // return object.
	// If there's a building:
	if ( !isNull _building ) then {
		// Building position:
		_bldgPos = getPosATL _building;
		// Figure out if the selected building has enough spots for current group size:
		_spots = [_building, _grpSize] call BIS_fnc_buildingPositions;
		// If has enough spots for the whole current group size:
		if ( count _spots >= _grpSize ) then {
			// Delete old waypoints to prevent anomalies:
			//for "_i" from count waypoints _grp -1 to 1 step -1 do { deleteWaypoint [_grp, _i] };  // waypoints get immediately re-indexed when one gets deleted, delete them from last to first. Never delete index 0. Deleting index 0 causes oddities in group movement during the game logic. Index 0 of a unit is its spawn point or current point, so delete it brings weird movements or waypoint loses (by Larrow).
			// Go to the specific building:
			_wp = _grp addWaypoint [_bldgPos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCombatMode "YELLOW";  // Open fire, but keep formation, trying to avoid those units stay far away from the group leader.
			//_wp setWaypointSpeed "NORMAL";  // (aug/2023 = v4.0.2 = fixed the bug where this line was replacing the original group speed defined in fn_CSWR_population file.
			_grp setCurrentWaypoint _wp;
			// Meanwhile the group leader is alive or their group to exist:
			while { alive (leader _grp) || !isNull _grp } do {
				// Declarations:
				_grpLead = leader _grp;  // caution, I'm using obj for leader group here only because inside a looping. Leadership can change anytime.
				// if the leader is NOT awake:
				if ( incapacitatedState _grpLead isEqualTo "UNCONSCIOUS" ) then {
					// Kill the AI leader to renew the group leadership:
					_grpLead setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
					// Stop the while-looping:
					break;
				};
				// If the leader notice (distance) the building doesn't exist anymore:
				if ( _grpLead distance _bldgPos < 80 ) then {  // distance should use building position because, in case the building doesnt exist, distance not works with objNull but works with position.
					// If destroyed but not part of the exception building list:
					if ( !alive _building && !(typeOf _building in CSWR_occupyAcceptableRuins) ) then {
						// Debug message:
						if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.", CSWR_txtDebugHeader, _tag, str _grp]; };
						// Small cooldown to prevent crazy loopings:
						sleep 1;
						// Restart the first OCCUPY step:
						[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
						// Stop the while-looping:
						break;
					};
				};
				// if group leader is close enough to the chosen building:
				if ( _grpLead distance _bldgPos < _distLimiterFromBldg ) then {
					// When there, execute the occupy function:
					[_building, _bldgPos, _grpType, _grp, _tag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetIn;
					// Stop the while-looping:
					break;
				};
				// Check if the waypoint was lost (sometimes bugs or misclick by zeus can delete the waypoint):
				if ( waypointType _wp isEqualTo "" || currentWaypoint _grp == 0 ) then {
					// Debug message:
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' group lost the waypoint for unknown reason. New search in %6 secs.", CSWR_txtDebugHeader, _tag, str _grp, count (units _grp), count _spots, _wait]; sleep 1 };
					// Small cooldown to prevent crazy loopings:
					sleep 3;
					// Restart the first OCCUPY step:
					[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
					// Stop the while-looping:
					break;
				};
				// Check if the leader is alive, is not stuck in their way to the building and not injured, not engaging, they're awake, give a timeout to restart the whole function again:
				if ( alive _grpLead && unitReady _grpLead && lifeState _grpLead isNotEqualTo "INJURED" && incapacitatedState _grpLead isNotEqualTo "SHOOTING" && incapacitatedState _grpLead isEqualTo "UNCONSCIOUS" ) then {
					_leadStuckCounter = _leadStuckCounter + 1;
					// Debug message:
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' leader looks stuck %4 time(s).", CSWR_txtDebugHeader, _tag, str _grp, _leadStuckCounter] };
					// After timeout and leader looks stuck, teleport them to a free space:
					if ( _leadStuckCounter == 5 ) then {
						if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' leader apparently was stuck, but now he's free.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 1 };
						// Find pos min 10m (_distLimiterFromBldg) from _grpLead but not further 20m, not closer 4m to other obj, not in water, max gradient 0.7, not on shoreline:
						_getOutPos = [_grpLead, _distLimiterFromBldg, (_distLimiterFromBldg * 2), 4, 0, 0.7, 0] call BIS_fnc_findSafePos;
						// Teleport to the safe position out:
						_grpLead setPosATL [_getOutPos # 0, _getOutPos # 1, 0];
						// Destroying the position just in case:
						_getOutPos = nil;
						// Restart the first OCCUPY step:
						[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
						// Stop the while-looping:
						break;
					};
				};
				// If leader not close enough to the building, let's CPU breath to the next distance checking:
				sleep _wait;
			};  // While-loop ends.
		// If has NO spots for the whole group:
		} else {
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 %2 > OCCUPY > Failed: '%3' has %4 spot(s) to %5 men.", CSWR_txtDebugHeader, _tag, typeOf _building, count _spots, count (units _grp)] };
			// Cooldown to prevent crazy loopings:
			sleep _wait;
			// Restart the first OCCUPY step:
			[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
		};
	// If a building is NOT found:
	} else {
		// Warning message:
		["%1 OCCUPY > An OCCUPY marker looks not close enough or without good range set ('CSWR_occupyMarkerRange') to abled buildings for OCCUPY movement. New search in %2 secs.", CSWR_txtWarningHeader, _wait] call BIS_fnc_error;
		// Cooldown to prevent crazy loopings:
		sleep _wait;
		// Restart the first OCCUPY step:
		[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_find_buildings_by_faction = {
	// This function finds all relevant buildings in each faction marker (_x) range, and include them in a faction general list to check deeper further. It runs once the mission get started.
	// Returns _bldgsSpotsAvailable: array of objects.

	params ["_isOnFaction", "_mkrsOccupy", "_range", "_ignoredBldgs", "_ignoredPos"];
	private ["_bldgsByMkr", "_bldgsToCheck", "_bldgsSpotsAvailable", "_spots", "_isWaterSurrounding"];

	// Initial values:
	_bldgsByMkr = [];
	_bldgsToCheck = [];
	_bldgsSpotsAvailable = [];
	// Escape:
	if ( !_isOnFaction ) exitWith { _bldgsSpotsAvailable /* return */ };
	// Error handling:
	if ( count _mkrsOccupy == 0 ) exitWith { _bldgsSpotsAvailable /* return */ };
	// FIRST STEP: find the buildings for faction marker:
	{  // forEach _mkrsOccupyBLU:
		_bldgsByMkr = nearestObjects [[markerPos _x # 0, markerPos _x # 1, 0], ["HOUSE", "BUILDING"], _range];  // Important: assets from 'building' category generally has no ALIVE option, so they cant be destroy in-game. 'building' category is here to be mapped to check further if one of them is in the CSWR_occupyAcceptableRuins list as exception, because basically no assets that cannot be destroy get in the final list, except those ones in CSWR_occupyAcceptableRuins.
		//_bldgsByMkr = [(markerPos _x) # 0, (markerPos _x) # 1] nearObjects ["HOUSE", _range];  // BACKUP ONLY.
		_bldgsToCheck append _bldgsByMkr;
	} forEach _mkrsOccupy;
	// SECOND STEP: among the buildings found, select only those specific ones:
	{  // forEach _bldgsToCheck:
		// If the building is NOT an ignored one, NOT got its position as ignored also, keep going:
		if ( !(typeOf _x in _ignoredBldgs) && !(getPosATL _x in _ignoredPos) ) then {
			// Check how much spot the building got:
			_spots = [_x] call BIS_fnc_buildingPositions;
			// Crucial: if at least one spot available:
			if ( count _spots > 0 ) then { 
				// Check if the building is over water:
				_isWaterSurrounding = surfaceIsWater (getPosATL _x);  // specialy ignoring Tanoa's riverside houses issue.
				// If not over the water or the building is an exception, do it:
				if ( !_isWaterSurrounding || typeOf _x in CSWR_occupyAcceptableRuins ) then {
					// Adding the building to the final options for faction groups executing occupy-movement:
					_bldgsSpotsAvailable pushBackUnique _x;
				};
			};
		};
	} forEach _bldgsToCheck;
	// Return:
	_bldgsSpotsAvailable;
};


THY_fnc_CSWR_OCCUPY_find_buildings_by_group = {
	// This function checks what pre-available buildings are around a specific faction marker range and selects one of them to be used for the group requesting the occupy-movement. It's a looping.
	// Return _building: object.

	params ["_grp", "_faction", "_tag"];
	private ["_bldgsAvailable", "_bldgsStillExist", "_building"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_bldgsAvailable = [];
	_building = objNull;
	// Declarations:
	switch _faction do {
		case BLUFOR:      { _bldgsAvailable = CSWR_bldgsAvailableBLU };
		case OPFOR:       { _bldgsAvailable = CSWR_bldgsAvailableOPF };
		case INDEPENDENT: { _bldgsAvailable = CSWR_bldgsAvailableIND };
		case CIVILIAN:    { _bldgsAvailable = CSWR_bldgsAvailableCIV };
	};
	// Select only the buildings that were not destroyed yet or those ones included as exception (like specific ruins):
	_bldgsStillExist = _bldgsAvailable select { alive _x || typeOf _x in CSWR_occupyAcceptableRuins };
	// Error handling:
	If ( count _bldgsStillExist == 0 ) exitWith { 
		// Debug message:
		if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' has no buildings available.", CSWR_txtDebugHeader, _tag, str _grp] };
		// Return:
		_building;
	};
	// From all of them, select one:
	_building = selectRandom _bldgsStillExist;
	// When debug mode on:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' going to 1 of %4 building(s) found.", CSWR_txtDebugHeader, _tag, str _grp, count _bldgsAvailable] };
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { 
		if ( alive _building || typeOf _building in CSWR_occupyAcceptableRuins ) then {
			["%1 OCCUPY > '%2' chosen building: %3 / Loc: %4", CSWR_txtDebugHeader, str _grp, typeOf _building, getPosATL _building] call BIS_fnc_error; sleep 5 };
		};
	// Return:
	_building;
};


THY_fnc_CSWR_OCCUPY_remove_unit_from_group = {
	// This function removes a specific unit left behind, and set them to a new group that is abled to execute also the occupy-movement by itself.
	// Returns nothing.

	params ["_unit", "_grpType", "_tag", "_behavior", "_wait"];
	private ["_newGrp"];

	// Debug message:
	if (CSWR_isOnDebugGlobal) then {
		systemChat format ["%1 OCCUPY > A unit of %2 '%3' has been removed as member to preserve the group movement.", CSWR_txtDebugHeader, _tag, str (group _unit)];
		sleep 5;
	};
	// Create the new group:
	_newGrp = createGroup [side _unit, true];  // [side, deleteWhenEmpty]
	// Add the removed unit to the new group:
	[_unit] joinSilent _newGrp;
	// Cooldown to prevent crazy loopings:
	sleep _wait;
	// Restart the first OCCUPY step:
	[_tag, _grpType, _newGrp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_nearEnemies = {
	// This function searches for enemies around a specific unit.
	// Returns _isEnemyClose: bool.

	params ["_unit", "_distLimiterEnemy"];
	private ["_isEnemyClose", "_nearUnits", "_nearEnemies"];

	// WIP IMPORTANT: the command findNearestEnemy is not working in my tests Feb/2023. Even in Wiki has mistakes with the examples:  https://forums.bohemia.net/forums/topic/241587-solved-findnearestenemy-command-looks-not-okay-for-me-a-noob/
	// Initial values:
	_isEnemyClose = false;
	// Searching:
	_nearUnits = _unit nearEntities ["Man", _distLimiterEnemy];
	_nearEnemies = _nearUnits select { side _unit != side _x && side _unit != CIVILIAN && alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" };
	if ( count _nearEnemies > 0 ) then { _isEnemyClose = true };
	// Return:
	_isEnemyClose;
};


THY_fnc_CSWR_OCCUPY_doGetIn = {
	// This function will try to make the group get inside the chosen building to occupy it.
	// Returns nothing.

	params ["_building", "_bldgPos", "_grpType", "_grp", "_tag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_wait"];
	private ["_spots", "_spot", "_isFriendPlayerClose", "_isEnemyClose", "_timeOutToUnit", "_canTeleport", "_alreadySheltered", "_orderCounter", "_grpSize", "_compass"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_spots = [];
	_spot = [];
	_isFriendPlayerClose = false;
	_isEnemyClose = false;
	_timeOutToUnit = nil;
	_canTeleport = true;
	_alreadySheltered = [];
	_orderCounter = nil;
	// Declarations:
	_grpSize = count (units _grp);
	_compass = [0, 45, 90, 135, 180, 225, 270, 315];  // Better final-result than 'random 360'.
	// If there's a building:
	if ( !isNull _building ) then {
		{  // forEach _grp members:
			// Declarations:
			_orderCounter = 0;
			_timeOutToUnit = 15;  // secs to the unit get-in the building before be ignored.
			// Meanwhile the unit is alive or their group to exist:
			while { alive _x || !isNull _grp } do {
				// If the unit is the leader:
				if ( _x == leader _grp ) then {
					// if the leader is NOT awake:
					if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then {
						// Kill the AI leader to renew the group leadership:
						_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
						// Stop the while-looping:
						break;
					};
					// if group leader is close enough to the chosen building:
					if ( _x distance _building < _distLimiterFromBldg + 2 ) then {
						// Figure out if the selected building has enough spots for current group size:
						_spots = [_building, _grpSize] call BIS_fnc_buildingPositions;
						// For script integraty, check again right after the arrival if there are enough spots to the whole group:
						if ( count _spots >= _grpSize ) then {
							// if the building is free to be occupied:
							if ( !(_bldgPos in CSWR_occupyIgnoredPositions) ) then {
								// If the building wasn't completely destroyed or it's an exception (like a specific ruin):
								if ( alive _building || typeOf _building in CSWR_occupyAcceptableRuins ) then {
									// Flag the building for other groups that this building is ours:
									CSWR_occupyIgnoredPositions pushBack _bldgPos;
									// Update the global variable:
									publicVariable "CSWR_occupyIgnoredPositions";
									// Select an available spot:
									_spot = selectRandom _spots;
								// If the building doesn't exist anymore:
								} else {
									// Debug message:
									if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 1 };
									// Small cooldown to prevent crazy loopings:
									sleep 1;
									// Restart the first OCCUPY step:
									[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
									// Stop the while-looping:
									break;
								};
							// if the building is already occupied for someone else:
							} else {
								// Debug message:
								if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' building is already occupied for someone else.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 1 };
								// Small cooldown to prevent crazy loopings:
								sleep 3;
								// Restart the first OCCUPY step:
								[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
								// Stop the while-looping:
								break;
							};
							// Check if there are friendly players around:
							_isFriendPlayerClose = [_x, "friendlyPlayers", _distLimiterFriendPlayer] call THY_fnc_CSWR_is_playerNear;
							// Check if there are enemies around:
							_isEnemyClose = [_x, _distLimiterEnemy] call THY_fnc_CSWR_OCCUPY_nearEnemies;
							// If a friendly player NOT around, and enemy NOT around, and leader is NOT engaging:
							if ( !_isFriendPlayerClose && !_isEnemyClose && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
								// flags:
								_canTeleport = true;
								// force the leader to stop and prevent them to died when they are teleported to the new position:
								doStop _x;
								// wait a bit until the leader stops completely:
								sleep 1;
								// Teleport the unit to their spot inside the building:
								_x setPosATL _spot;
								// After the arrival on spot, it removes the man's movement capacible:
								_x disableAI "PATH";
								// Set the direction:
								[_x, selectRandom _compass] remoteExec ["setDir"];
								// Wait to confirm the unit still alive before remove the current spot position from the list of spots available:
								sleep 1;
								// Delete that occupied spot to avoid more than one man there:
								if ( alive _x ) then { _spots deleteAt (_spots find _spot) };
								// Report the unit is sheltered:
								_alreadySheltered pushBackUnique _x;
								// Stop the while-looping:
								break;
							// Otherwise, if a friendly player around, or enemy around, or leader is engaging:
							} else {
								// Debug message:
								if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-in without teleport.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3 };
								// flag:
								_canTeleport = false;
								// Move to spot:
								_x doMove _spot;
								// Delete that occupied spot to avoid more than one man there:
								if ( alive _x ) then { _spots deleteAt (_spots find _spot) };
								// Wait the leader arrives inside the building or be killed:
								waitUntil { moveToCompleted _x || moveToFailed _x || !alive _x };
								// After the arrival on spot, it removes the man's movement capacible:
								_x disableAI "PATH";
								// Set the direction:
								[_x, selectRandom _compass] remoteExec ["setDir"];
								// Report the leader is sheltered:
								_alreadySheltered pushBackUnique _x;
								// Stop the while-loop:
								break;
							};
						// If has no spots for the whole group:
						} else {
							// Debug message:
							if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 %2 > OCCUPY > Failed: '%3' has %4 spot(s) to %5 men.", CSWR_txtDebugHeader, _tag, typeOf _building, count _spots, count (units _grp)] };
							// Cooldown to prevent crazy loopings:
							sleep _wait;
							// Restart the first OCCUPY step:
							[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
							// Stop the while-loop:
							break;
						};
					};
					// CPU breath if leader will repeat this loop:
					sleep _wait;
				// If the unit is NOT group leader:
				} else {
					// if the leader is already inside the building in position, and the unit WAS NOT FORCED ONCE yet to go there, do it:
					if ( !(leader _grp checkAIFeature "PATH") && _orderCounter < 1 ) then {
						// Move to the building:
						_x doMove _bldgPos;
						// Updating the counter:
						_orderCounter = _orderCounter + 1;
					};
					// if the unit is unconscious:
					if ( (incapacitatedState _x) isEqualTo "UNCONSCIOUS" ) then {
						// Debug message:
						if CSWR_isOnDebugGlobal then { systemChat format ["%1 > OCCUPY > An incapacitated %2 unit has been killed to preserve the group mobility.", CSWR_txtDebugHeader, _tag] };
						// Kill the AI unit:
						_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
						// Stop the while-looping:
						break;
					};
					// if the unit is too far away from the leader:
					if ( _x distance leader _grp > 120 ) then {
						// Remove the unit from the current group:
						[_x, _grpType, _tag, _behavior, _wait] spawn THY_fnc_CSWR_OCCUPY_remove_unit_from_group;
						// Stop the while-looping:
						break;
					};
					// If the unit's leader is ready, and the unit is close enough the building, even if engaging, just go to inside:
					if ( !(leader _grp checkAIFeature "PATH") && _x distance _building < _distLimiterFromBldg + 2 ) then {
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
							waitUntil { moveToCompleted _x || moveToFailed _x || !alive _x };
						};
						// If still alive (because it has a waitUntil case above):
						if ( alive _x ) then {
							// After the arrival on spot, it removes the man's movement capacible:
							_x disableAI "PATH";
							// Set the direction:
							[_x, selectRandom _compass] remoteExec ["setDir"];
							// Delete that occupied spot to avoid more than one man there:
							_spots deleteAt (_spots find _spot);
							// Report the unit is sheltered:
							_alreadySheltered pushBackUnique _x;
							// Stop the while-loop:
							break;
						};
					};
					// Timeout for script understand the unit is stuck around the building and leave they there until the leader leave the building again and forces the regrouping:
					if ( _timeOutToUnit == 0 ) then { break };
					_timeOutToUnit = _timeOutToUnit - 1;
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy && !(leader _grp checkAIFeature "PATH") && _timeOutToUnit <= 10 ) then { systemChat format ["%1 OCCUPY > %2 '%3' unit should get-in: %4", CSWR_txtDebugHeader, _tag, _x, _timeOutToUnit] };
					sleep 1.5;
				};
				// If the unit or leader has no group anymore (anomaly), kill the former group member:
				if ( isNull (group _x) ) then {
					// Kill:
					_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
					// Debug message:
					if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > A %2 unit needed to be killed to preserve the game integraty (they lost the group ID).", CSWR_txtDebugHeader, _tag]};
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
			// CPU breath:
			sleep 1;
		} forEach (units _grp select { alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" && !(_x in _alreadySheltered) });  // It's ok not apply disableAi PATH ;)
		// Check again the current group size in case the while-looping took too long:
		_grpSize = count (units _grp);
		// If the number of group members already sheltered is bigger than half current group size:
		if ( count _alreadySheltered > floor (_grpSize / 2) ) then {
			// Debug messages:
			if CSWR_isOnDebugGlobal then { 
				if ( count _alreadySheltered == _grpSize ) then {
					systemChat format ["%1 OCCUPY > All %2 '%3' is in a building.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3;
				} else {
					systemChat format ["%1 OCCUPY > Most of the %2 '%3' is in a building.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3;
				};
			};
			// Next planned move cooldown:
			sleep (random CSWR_destOccupyTakeabreak);
		// Otherwise:
		} else {
			// Debug message:
			if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' leader would rather move to another building.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3 };
		};
		// Starts the last stage of OCCUPY function:
		[_grpType, _grp, _tag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _bldgPos, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetOut;
	// If a building is NOT found:
	} else {
		// Warning message:
		["%1 %2 > OCCUPY > The building doesn't exist anymore. New search in %4 secs.", CSWR_txtWarningHeader, _tag, str _grp, _wait] call BIS_fnc_error; sleep 5;
		// Restart the first OCCUPY step:
		[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_doGetOut = {
	// This function is the last stage of Occupy function where it removes the group from inside the occupied building.
	// Returns nothing.

	params ["_grpType", "_grp", "_tag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_bldgPos", "_wait"];
	private ["_isFriendPlayerClose", "_isEnemyClose", "_getOutPos", "_canTeleport"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_isFriendPlayerClose = false;
	_isEnemyClose = false;
	_getOutPos = [];
	_canTeleport = true;

	{  // forEach _grp members:
		// Meanwhile the unit is alive or their group to exist:
		while { alive _x || !isNull _grp } do {
			// If the unit is the leader:
			if ( _x == leader _grp ) then {
				// Check if there are friendly players around:
				_isFriendPlayerClose = [_x, "friendlyPlayers", _distLimiterFriendPlayer] call THY_fnc_CSWR_is_playerNear;
				// Check if there are enemies around:
				_isEnemyClose = [_x, _distLimiterEnemy] call THY_fnc_CSWR_OCCUPY_nearEnemies;
				// if the leader is NOT awake:
				if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then {
					// Kill the AI leader to renew the group leadership:
					_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
					// Stop the while-looping:
					break;
				};
				// If a friendly player NOT around, and enemy NOT around, and the leader is NOT engaging:
				if ( !_isFriendPlayerClose && !_isEnemyClose && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
					// flag:
					_canTeleport = true;
					// Find pos min 10m (_distLimiterFromBldg) from _x but not further 20m, not closer 4m to other object, not in water, max gradient 0.7, not on shoreline:
					_getOutPos = [_x, _distLimiterFromBldg, (_distLimiterFromBldg * 2), 4, 0, 0.7, 0] call BIS_fnc_findSafePos;
					// Teleport to the safe position out:
					_x setPosATL [_getOutPos # 0, _getOutPos # 1, 0];
					// Destroying the position just in case:
					_getOutPos = nil;  // WIP: BUG: dont know why, but sometimes the leader already got a new waypoint but right after to getout by teleportation from the building, he wants to stay in _getOutPos, stuck.
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Give back the movement hability to the unit, sending them to leader position:
					_x doFollow _x;  // crucial after use doStop.
					// Stop the while-loop:
					break;
				// Otherwise, if a friendly player around, or enemy around, or leader engaging:
				} else {
					// Debug message:
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-out without teleport.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3 };
					// flag:
					_canTeleport = false;
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Give back the movement hability to the unit, sending them to leader position:
					_x doFollow _x;  // crucial after use doStop.
					// Stop the while-loop:
					break;
				};
				// CPU breath if leader will repeat this loop:
				sleep _wait;
			// If the unit is NOT group leader:
			} else {
				// If the leader is ready to get out the building, and the unit is NOT engaging:
				if ( leader _grp checkAIFeature "PATH" && incapacitatedState _x isNotEqualTo "SHOOTING" ) then {
					// If the group member can teleport:
					if ( _canTeleport ) then {
						// Teleport to the leader position:
						_x setPosATL (getPosATL (leader _grp));
					};
					// Give back AI hability to find their way:
					_x enableAI "PATH";  // crucial after use disableAI.
					// Wait the unit react to the change:
					sleep 2;
					// Give back the movement hability to the unit, sending them to leader position:
					_x doFollow leader _grp;  // crucial after use doStop.
					// Stop the while-loop:
					break;
				// If something wrong, wait a bit:
				} else { sleep 3 };
				// CPU breath if unit will repeat this loop:
				sleep 1;
			};
		};  // While-loop ends.
	} forEach units _grp;
	// Remove the current building from the occupied buildings list:
	CSWR_occupyIgnoredPositions deleteAt (CSWR_occupyIgnoredPositions find _bldgPos);
	// Update the global variable:
	publicVariable "CSWR_occupyIgnoredPositions";
	// Debug message:
	if (CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 %2 > OCCUPY > %3 building(s) occupied currently.", CSWR_txtDebugHeader, _tag, count CSWR_occupyIgnoredPositions] };	
	// Restart the first OCCUPY step:
	[_tag, _grpType, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_HOLD = { 
	// This function sets the group to arrive in a place and make it doesn't move to another place for a long time. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh"];
	private ["_destMarkers", "_isReservedToAnother", "_areaToHoldPos", "_isVehicleTracked", "_areaToHold", "_isReservedNow", "_grpPos", "_wpDisTolerance", "_wp", "_holdReservedAmount", "_attemptCounter", "_attemptTolerance", "_wait"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destMarkers = [];
	_isReservedToAnother = false;
	_areaToHoldPos = [];
	_isVehicleTracked = false;
	_areaToHold = "";
	_isReservedNow = false;
	_grpPos = [];
	_wpDisTolerance = nil;
	_wp = [];
	_holdReservedAmount = nil;
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Declarations:
	_attemptTolerance = 20;
	_wait = 10;
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destMarkers = CSWR_destHoldBLU };
		case OPFOR:       { _destMarkers = CSWR_destHoldOPF };
		case INDEPENDENT: { _destMarkers = CSWR_destHoldIND };
		case CIVILIAN:    { _destMarkers = CSWR_destHoldCIV };
	};
	// Check if it's a vehicle and which kind of them:
	if _isVeh then {
		// It's a tracked vehicle:
		if ( vehicle (leader _grp) isKindOf "Tank" || vehicle (leader _grp) isKindOf "TrackedAPC" ) then { _isVehicleTracked = true };
	};
	// Looping for select hold-marker:
	_attemptCounter = 0;  // 1/2 usage.
	while { !isNull _grp && _attemptCounter < _attemptTolerance } do {
		// Counter to prevent crazy loops:
		_attemptCounter = _attemptCounter + 1;
		// Check the available HOLD faction markers on map:
		_areaToHold = selectRandom _destMarkers;
		// If tracked vehicle:
		if ( _isVeh && _isVehicleTracked ) then {
			// For each case, check which reserved list it should be included:
			switch ( side (leader _grp) ) do {
				// If _areaToHold is NOT inside the reserved list yet, include it:
				case BLUFOR:      { if ( !(_areaToHold in CSWR_holdReservedLocation # 0) ) then { CSWR_holdReservedLocation # 0 pushBackUnique _areaToHold; _isReservedNow = true } };
				case OPFOR:       { if ( !(_areaToHold in CSWR_holdReservedLocation # 1) ) then { CSWR_holdReservedLocation # 1 pushBackUnique _areaToHold; _isReservedNow = true } };
				case INDEPENDENT: { if ( !(_areaToHold in CSWR_holdReservedLocation # 2) ) then { CSWR_holdReservedLocation # 2 pushBackUnique _areaToHold; _isReservedNow = true } };
				case CIVILIAN:    { if ( !(_areaToHold in CSWR_holdReservedLocation # 3) ) then { CSWR_holdReservedLocation # 3 pushBackUnique _areaToHold; _isReservedNow = true } };
			};
			// if this vehicle was included as owner of the hold-marker, it is reserved:
			if _isReservedNow then {
				// Update the public variable with new reservation:
				publicVariable "CSWR_holdReservedLocation";
				// Stop the looping;
				break;
			// If still not reserved:
			} else {
				// Escape:
				if ( _attemptCounter >= _attemptTolerance ) exitWith {
					// Warning handling:
					["%1 HOLD > Looks it's working with less hold-markers than %2 tracked vehicles using it. ADD MORE %2 HOLD-MARKERS!", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
				};
			};
			// Super short CPU breath to avoid crazy loopings (but it's too dangerous leave vehicles in spawn point stuck, without move. This should be fast!):
			sleep 0.25;
		// If infantry or another kind of vehicle:
		} else {
			// Just take the _areaToHold and leave the looping:
			break;
		};
	};  // While-loop ends.
	
	// Taking the selected hold marker position (2D):
	_areaToHoldPos = markerPos _areaToHold;  // [x, y]
	// Converting the position to ATL format and defining this as the basic infantry/vehicle position:
	_grpPos = [_areaToHoldPos # 0, _areaToHoldPos # 1, 0];  // converted to [x, y, z].
	
	// CREATING WAYPOINT > IF TRACKED VEHICLE:
	if ( _isVeh && _isVehicleTracked ) then {
		// How closer to complete the waypoint:
		_wpDisTolerance = 20;  // Important: below 15, tanks in combat mode brakes before and dont reach the waypoint distance.
		// Finally creating the vehicle waypoint:
		_wp = _grp addWaypoint [_grpPos, 0]; 
		_wp setWaypointType "HOLD";
		_grp setCurrentWaypoint _wp;
		
	// CREATING WAYPOINT > IF INFANTRY OR NON-TRACKED VEHICLE:
	} else {
		// How closer to complete the waypoint:
		_wpDisTolerance = 2;
		// Looping to find a good spot, if it fails, the infantry will be sent to marker position with no safe position guarantees:
		_attemptCounter = 0;  // 2/2 usage.
		while { !isNull _grp && _attemptCounter < 20 } do {
			// Counter to prevent crazy loops:
			_attemptCounter = _attemptCounter + 1;
			// Find pos min 0m from center (_areaToHoldPos) but not further 30m, not closer 3m to other obj, not in water, max gradient 0.7, no (0) on shoreline:
			_grpPos = [_grpPos, 20, 30, 3, 0, 0.7, 0] call BIS_fnc_findSafePos;
			// if troops are not over a road, good position and stop the while-loop:
			if ( !isOnRoad _grpPos ) then { break };
			// Cooldown to prevent crazy loops:
			if _isVeh then { sleep 0.25 } else { sleep _wait };
		};  // While-loop ends.
		// Finally creating the infantry / non-tracked vehicles waypoint:
		_wp = _grp addWaypoint [_grpPos, 0]; 
		_wp setWaypointType "HOLD";
		_grp setCurrentWaypoint _wp;
		if ( !_isVeh ) then { _wp setWaypointFormation "DIAMOND" };  // better formation for this case!
	};
	// Check if the group is already on their destine:
	waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _grpPos < _wpDisTolerance };
	// Error handling:
	if ( isNull _grp ) exitWith {};
	// AFTER THE ARRIVAL, IF ANY VEHICLE TYPE:
	if _isVeh then {
		// Adjust only trached vehicle direction:
		[_areaToHold, _grp, _tag] call THY_fnc_CSWR_HOLD_tracked_vehicle_direction;
		// If editors choice was stealth all vehicles on hold, do it:
		if CSWR_isHoldVehLightsOff then { _grp setBehaviourStrong "STEALTH" };
	// AFTER THE ARRIVAL, IF INFANTRY:
	} else {
		// Reserved code block for infantry after its arrival.
	};
	// Next planned move cooldown:
	sleep (random CSWR_destHoldTakeabreak);
	// If the group had reserved the position:
	if _isReservedNow then {
		// For each case, remove the current hold-marker as reserved from the reservation list:
		switch ( side (leader _grp) ) do {
			case BLUFOR: { 
				(CSWR_holdReservedLocation # 0) deleteAt ((CSWR_holdReservedLocation # 0) find _areaToHold);
				// Debug purposes:
				if CSWR_isOnDebugGlobal then { _holdReservedAmount = count (CSWR_holdReservedLocation # 0) };
			};
			case OPFOR: { 
				(CSWR_holdReservedLocation # 1) deleteAt ((CSWR_holdReservedLocation # 1) find _areaToHold); 
				// Debug purposes:
				if CSWR_isOnDebugGlobal then { _holdReservedAmount = count (CSWR_holdReservedLocation # 1) };
			};
			case INDEPENDENT: { 
				(CSWR_holdReservedLocation # 2) deleteAt ((CSWR_holdReservedLocation # 2) find _areaToHold); 
				// Debug purposes:
				if CSWR_isOnDebugGlobal then { _holdReservedAmount = count (CSWR_holdReservedLocation # 2) };
			};
			case CIVILIAN: { 
				(CSWR_holdReservedLocation # 3) deleteAt ((CSWR_holdReservedLocation # 3) find _areaToHold); 
				// Debug purposes:
				if CSWR_isOnDebugGlobal then { _holdReservedAmount = count (CSWR_holdReservedLocation # 3) };
			};
		};
		// After that, update the public variable with the new reservation:
		publicVariable "CSWR_holdReservedLocation";
		// Debug message:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHold ) then { systemChat format ["%1 HOLD > %3 position(s) got %2 TRACKED VEHICLES on tactical hold currently.", CSWR_txtDebugHeader, _tag, _holdReservedAmount] };
	};
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD;
	// Return:
	true;
};


THY_fnc_CSWR_HOLD_ground_cleaner = {
	// This function clean the ground around the hold-marker to prevend collision anomalies with tracked-vehicles.
	// Returns nothing.

	params ["_markers"];
	//private [""];

	// Escape:
	if ( count _markers == 0 ) exitWith {};
	// Initial values:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Check the objects to hide from a specific distance of each marker position. The goal here is remove only things the vehicle wouldn't smash easy, like a rock, for example. "HIDE" has rocks too:
	{  // forEach _markers:
		{ hideObjectGlobal _x } forEach nearestTerrainObjects [markerPos _x, ["ROCK", "ROCKS", "HIDE", "TREE"], 30, false, false];  // [position, types, radius, sort, 2Dmode]
		// CPU breath:
		sleep 0.1;
	} forEach _markers;
	// Return:
	true;
};


THY_fnc_CSWR_HOLD_tracked_vehicle_direction = {
	// This function sets the tracked-vehicle as the same direction as the hold-marker placed by the mission editor.
	// Returns nothing.

	params ["_mkr", "_grp", "_tag"];
	private ["_blockers", "_attemptCounter", "_attemptLimiter", "_veh", "_directionToHold"];
	
	// Escape:
	if ( !(vehicle (leader _grp) isKindOf "Tank") && !(vehicle (leader _grp) isKindOf "TrackedAPC") ) exitWith {};
	// Initial values:
	_blockers = [];
	_attemptCounter = 0;
	// Declarations:
	_attemptLimiter = 5;
	_veh = vehicle (leader _grp);
	_directionToHold = markerDir _mkr; 
	// Force the vehicle doest start to turn when still moving (rare, but happens):
	_veh sendSimpleCommand "STOP";
	// Wait the vehicle to brakes:
	sleep 2;
	// Check if there is some blocker around the vehicle. A simple unit around can make a tank get to fly like a rocket if too much close during the setDir command:
	while { alive _veh && _attemptCounter < _attemptLimiter } do {
		// Check if something relevant is blocking the Hold-marker position:
		_blockers = (getPos _veh) nearEntities [["Man", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC"], 10];
		// Removing the group vehicle itself from the calc as blocker:
		_blockers deleteAt (_blockers find _veh);
		// If no blockers, leave the verification loop:
		if ( count _blockers isEqualTo 0 ) then { break };
		// Counter to avoid crazy loopings:
		_attemptCounter = _attemptCounter + 1;
		// Debug:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHold ) then {
			// Warning messages:
			if ( _attemptCounter < _attemptLimiter ) then {
				["%1 HOLD > %2 '%3' tracked-vehicle is WAITING NO BLOCKERS to execute the 'setDir' Hold-move! Current blockers: %4", CSWR_txtWarningHeader, _tag, str _grp, str _blockers] call BIS_fnc_error;
			} else {
				["%1 HOLD > %2 '%3' tracked-vehicle has been %4 times to execute the hold-move but blocker(s) still there. Hold- to be aborted.", CSWR_txtWarningHeader, _tag, str _grp, _attemptLimiter] call BIS_fnc_error;
			};
		};
		// long breath to the next loop check:
		sleep 20;
	};  // while loop ends.
	// Escape:
	if ( count _blockers > 0 ) exitWith {};
	// Set the direction:
	[_veh, _directionToHold] remoteExec ["setDir"];
	// Debug:
	if CSWR_isOnDebugGlobal then {
		// Breath to make sure the vehicle already in the new position before the debug message "getDir" calc:
		sleep 5;
		// Debug message:
		systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle hold [Desired: %4º | Executed: %5º].", CSWR_txtDebugHeader, _tag, str _grp, _directionToHold, getDir _veh];
	};
	// Return:
	true;
};


THY_fnc_CSWR_paradrop = {
	// This function creates the paradrop system for one vehicle, including multiples parachutes attached on it.
	// About the original author: it's a lighter/modificated version of KK_fnc_paraDrop function: http://killzonekid.com/arma-scripting-tutorials-epic-armour-drop/
	// Returns nothing.

	params ["_veh"];
	private ["_eachPara", "_parachutes", "_i", "_velocity", "_time"];

	// Escape:
		// reserved space.
	// Creating the parachute:
	_eachPara = createVehicle ["Steerable_Parachute_F", [0,0,0], [], 0, "FLY"];
	[_eachPara, getDir _veh] remoteExec ["setDir"];
	_eachPara setPos (getPos _veh);
	_parachutes = [_eachPara];
	_veh attachTo [_eachPara, [0,2,0]];

	{
		_i = createVehicle ["Steerable_Parachute_F", [0,0,0], [], 0, "FLY"];
		_parachutes set [count _parachutes, _i];
		_i attachTo [_eachPara, [0,0,0]];
		_i setVectorUp _x;

	} count [ [0.5,0.4,0.6], [-0.5,0.4,0.6], [0.5,-0.4,0.6], [-0.5,-0.4,0.6] ];

	// Waiting the vechile get closer to the ground:
	waitUntil { sleep 0.1; ((getPos _veh) # 2) < 4 };
	// Adjust to vehicle velocity after the parachutes detachment:
	_velocity = velocity _veh;  // [x,y,z]
	detach _veh;
	_veh setVelocity _velocity;
	// Detachment of parachutes from the vehicle:
	playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _veh];
	{ detach _x; _x disableCollisionWith _veh } forEach _parachutes;
	_time = time + 5;
	waitUntil { sleep 0.3; time > _time };
	{ if ( !isNull _x ) then { deleteVehicle _x } } forEach _parachutes;
	// Return:
	true;
};


THY_fnc_CSWR_debug = {
	// This function shows some numbers to the mission editor when debugging.
	// Returns nothing.

	//params [];
	private ["_playableBLU", "_playableOPF", "_playableIND", "_playableCIV", "_aliveAll", "_aliveBLU", "_aliveOPF", "_aliveIND", "_aliveCIV"];

	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Escape:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Declarations:
	_playableBLU = { alive _x && side _x == BLUFOR } count playableUnits;
	_playableOPF = { alive _x && side _x == OPFOR } count playableUnits;
	_playableIND = { alive _x && side _x == INDEPENDENT } count playableUnits;
	_playableCIV = { alive _x && side _x == CIVILIAN } count playableUnits;
	_aliveAll = { alive _x } count (allUnits - playableUnits);
	_aliveBLU = ({ alive _x } count units BLUFOR) - _playableBLU;
	_aliveOPF = ({ alive _x } count units OPFOR) - _playableOPF;
	_aliveIND = ({ alive _x } count units INDEPENDENT) - _playableIND;
	_aliveCIV = ({ alive _x } count units CIVILIAN) - _playableCIV;
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
		CSWR_spwnDelayQueueAmount,
		_aliveAll,
		_aliveBLU,
		_aliveOPF,
		_aliveIND,
		_aliveCIV
	];
	// CPU breath:
	sleep 10;
	// Return:
	true;
};
// Return:
true;