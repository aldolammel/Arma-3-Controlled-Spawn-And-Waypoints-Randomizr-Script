// CSWR v5.5
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
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
	if ( _spacerAmount isNotEqualTo 3 ) then {
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
	if ( _itShouldBeNumeric isNotEqualTo 0 ) then { 
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
	private ["_spwnsBLU", "_spwnsVehBLU", "_spwnsHeliBLU", "_spwnsParadropBLU", "_spwnsOPF", "_spwnsVehOPF", "_spwnsHeliOPF", "_spwnsParadropOPF", "_spwnsIND", "_spwnsVehIND", "_spwnsHeliIND", "_spwnsParadropIND", "_spwnsCIV", "_spwnsVehCIV", "_spwnsHeliCIV", "_spwnsParadropCIV", "_destMoveBLU", "_destWatchBLU", "_destOccupyBLU", "_destHoldBLU", "_destMoveOPF", "_destWatchOPF", "_destOccupyOPF", "_destHoldOPF", "_destMoveIND", "_destWatchIND", "_destOccupyIND", "_destHoldIND", "_destMoveCIV", "_destWatchCIV", "_destOccupyCIV", "_destHoldCIV", "_destMovePUBLIC", "_confirmedMarkers", "_spwns", "_spwnsVeh", "_spwnsHeli", "_spwnsParadrop", "_isValid", "_mkrType", "_isValidShape", "_tag", "_isNumber", "_realPrefix", "_txt0", "_txt1", "_possibleMarkers", "_mkrNameStructure"];

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
	_isValidShape = false;
	_tag = "";
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
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Select") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _spwnsBLU pushBack _x; _x setMarkerText "BLU Spawn" };
						case "OPF": { _spwnsOPF pushBack _x; _x setMarkerText "OPF Spawn" };
						case "IND": { _spwnsIND pushBack _x; _x setMarkerText "IND Spawn" };
						case "CIV": { _spwnsCIV pushBack _x; _x setMarkerText "CIV Spawn" };
					};
				};
			};
			// Case example: cswr_spawnveh_blu_1
			case "SPAWNVEH": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Select") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _spwnsVehBLU pushBack _x; _x setMarkerText "BLU Veh Spawn" };
						case "OPF": { _spwnsVehOPF pushBack _x; _x setMarkerText "OPF Veh Spawn" };
						case "IND": { _spwnsVehIND pushBack _x; _x setMarkerText "IND Veh Spawn" };
						case "CIV": { _spwnsVehCIV pushBack _x; _x setMarkerText "CIV Veh Spawn" };
					};
				};
			};
			// Case example: cswr_spawnheli_blu_1
			case "SPAWNHELI": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Select") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _spwnsHeliBLU pushBack _x; _x setMarkerText "BLU Heli Spawn" };
						case "OPF": { _spwnsHeliOPF pushBack _x; _x setMarkerText "OPF Heli Spawn" };
						case "IND": { _spwnsHeliIND pushBack _x; _x setMarkerText "IND Heli Spawn" };
						case "CIV": { _spwnsHeliCIV pushBack _x; _x setMarkerText "CIV Heli Spawn" };
					};
				};
			};
			// Case example: cswr_spawnparadrop_blu_1
			case "SPAWNPARADROP": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Select") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, true] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _spwnsParadropBLU pushBack _x; _x setMarkerText "BLU Spawn Paradrop" };
						case "OPF": { _spwnsParadropOPF pushBack _x; _x setMarkerText "OPF Spawn Paradrop" };
						case "IND": { _spwnsParadropIND pushBack _x; _x setMarkerText "IND Spawn Paradrop" };
						case "CIV": { _spwnsParadropCIV pushBack _x; _x setMarkerText "CIV Spawn Paradrop" };
					};
				};
			};
			// Case example: cswr_move_blu_1
			case "MOVE": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Empty") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU":    { _destMoveBLU pushBack _x;    _x setMarkerText "BLU Move" };
						case "OPF":    { _destMoveOPF pushBack _x;    _x setMarkerText "OPF Move" };
						case "IND":    { _destMoveIND pushBack _x;    _x setMarkerText "IND Move" };
						case "CIV":    { _destMoveCIV pushBack _x;    _x setMarkerText "CIV Move" };
						case "PUBLIC": { _destMovePUBLIC pushBack _x; _x setMarkerText "Move" };
					};
				};
			};
			// Case example: cswr_watch_blu_1
			case "WATCH": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Empty") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _destWatchBLU pushBack _x; _x setMarkerText "BLU To Watch zone" };
						case "OPF": { _destWatchOPF pushBack _x; _x setMarkerText "OPF To Watch zone" };
						case "IND": { _destWatchIND pushBack _x; _x setMarkerText "IND To Watch zone" };
						case "CIV": { _destWatchCIV pushBack _x; _x setMarkerText "CIV To Watch zone" };
					};
				};
			};
			// Case example: cswr_occupy_blu_1
			case "OCCUPY": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Empty") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _destOccupyBLU pushBack _x; _x setMarkerText "BLU Occupy" };
						case "OPF": { _destOccupyOPF pushBack _x; _x setMarkerText "OPF Occupy" };
						case "IND": { _destOccupyIND pushBack _x; _x setMarkerText "IND Occupy" };
						case "CIV": { _destOccupyCIV pushBack _x; _x setMarkerText "CIV Occupy" };
					};
				};
			};
			// Case example: cswr_hold_blu_1
			case "HOLD": {
				// Check the type of marker:
				_isValidShape = if ( getMarkerType _x isEqualTo "Empty") then { true } else { false };
				// Check if there is a valid owner tag:
				_tag = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _tag do {
						case "BLU": { _destHoldBLU pushBack _x; _x setMarkerText "BLU Hold" };
						case "OPF": { _destHoldOPF pushBack _x; _x setMarkerText "OPF Hold" };
						case "IND": { _destHoldIND pushBack _x; _x setMarkerText "IND Hold" };
						case "CIV": { _destHoldCIV pushBack _x; _x setMarkerText "CIV Hold" };
					};
				};
			};
		};
		// Error handling:
		if !_isValidShape then {
			// Deleting the marker:
			deleteMarker _x;
			_possibleMarkers deleteAt (_possibleMarkers find _x);
			// Warning message:
			systemChat format ["%1 A %2 %3 marker DOESN'T HAVE the correct marker shape. For spawn, use 'Select' marker, and for destination, use 'Empty' marker.", CSWR_txtWarningHeader, _tag, _mkrType];
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


THY_fnc_CSWR_marker_booking = {
	// This function makes the booking of a marker (destination or spawn-point) when it's available.
	// Param > _mkrType > string: which type of spawn-point (for infantry, for vehicle, for heli) or type of destination marker ( watch, hold, occupy, etc).
	// Param > _markers > array: all markers must be checked.
	// Param > _attemptLimit > number: limit of times the function will try to find a free marker.
	// Returns _bookingInfo. Array [string, bool].

	params ["_mkrType", "_mkrPos", "_tag", "_markers", "_attemptLimit", "_cooldown"];
	private ["_mkr", "_isBooked", "_bookingInfo", "_bookedLoc", "_isError", "_counter"];

	// Escape - part 1/2:
		// reserved space.
	// Initial values:
	_mkr = "";
	//_mkrPos = [0,0,0];
	_isBooked = false;
	_bookingInfo = [_mkr, _mkrPos, _isBooked];
	_bookedLoc = [];
	_isError = false;
	// Declarations:
	_counter = 0;
	switch _mkrType do {
		case "BOOKING_WATCH":     { _bookedLoc = CSWR_bookedLocWatch };     // [[blu],[opf],[ind],[civ]]
		case "BOOKING_HOLD":      { _bookedLoc = CSWR_bookedLocHold };      // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNVEH":  { _bookedLoc = CSWR_bookedLocSpwnVeh };   // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNHELI": { _bookedLoc = CSWR_bookedLocSpwnHeli };  // [[blu],[opf],[ind],[civ]]
		default { ["%1 There is no '%2' in 'THY_fnc_CSWR_marker_booking' function.", CSWR_txtWarningHeader, _mkrType] call BIS_fnc_error; _isError = true };
	};
	// Escape - part 2/2:
	if _isError exitWith { _bookingInfo /* Returning */ };
	// Debug texts:
		// reserved space.
	// Looping for select the marker:
	while { _counter <= _attemptLimit } do {
		// Pick a marker:
		_mkr = selectRandom _markers;
		// For each case, check which booked-list the marker should be included:
		switch _tag do {
			// If _mkr is NOT in the booked-list yet, include it:
			case "BLU": { if ( !(_mkr in (_bookedLoc # 0)) ) then { (_bookedLoc # 0) pushBackUnique _mkr; _isBooked = true } };
			case "OPF": { if ( !(_mkr in (_bookedLoc # 1)) ) then { (_bookedLoc # 1) pushBackUnique _mkr; _isBooked = true } };
			case "IND": { if ( !(_mkr in (_bookedLoc # 2)) ) then { (_bookedLoc # 2) pushBackUnique _mkr; _isBooked = true } };
			case "CIV": { if ( !(_mkr in (_bookedLoc # 3)) ) then { (_bookedLoc # 3) pushBackUnique _mkr; _isBooked = true } };
		};
		// if booked, update the public variable and create the marker position:
		if _isBooked then {
			switch _mkrType do {
				case "BOOKING_WATCH":     { CSWR_bookedLocWatch    = _bookedLoc; publicVariable "CSWR_bookedLocWatch";    _mkrPos = [locationPosition _mkr # 0, locationPosition _mkr # 1, 0] };
				case "BOOKING_HOLD":      { CSWR_bookedLocHold     = _bookedLoc; publicVariable "CSWR_bookedLocHold";     _mkrPos = [markerPos _mkr # 0, markerPos _mkr # 1, 0] };
				case "BOOKING_SPAWNVEH":  { CSWR_bookedLocSpwnVeh  = _bookedLoc; publicVariable "CSWR_bookedLocSpwnVeh";  _mkrPos = [markerPos _mkr # 0, markerPos _mkr # 1, 0] };
				case "BOOKING_SPAWNHELI": { CSWR_bookedLocSpwnHeli = _bookedLoc; publicVariable "CSWR_bookedLocSpwnHeli"; _mkrPos = [markerPos _mkr # 0, markerPos _mkr # 1, 0] };
			};
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugBooking ) then { systemChat format ["%1 %2 > %3 '%4' marker was booked.", CSWR_txtDebugHeader, _mkrType, _tag, _mkr]; sleep 1};
			// Stop the looping;
			break;
		// Otherwise:
		} else {
			// clean the _mkr to prevent fake booking in case of the while-loop reachs the attempt limit:
			_mkr = "";
		};
		// Counter to prevent crazy loops:
		_counter = _counter + 1;
		// Important: if it's vehicles using the function right after spawn, be fast to avoid explosions:
		sleep _cooldown;
	};  // While-loop ends.
	// Preparing to return:
	_bookingInfo = [_mkr, _mkrPos, _isBooked];
	// Return:
	_bookingInfo;
};


THY_fnc_CSWR_marker_booking_undo = {
	// This function undo the booking of a marker (destination or spawn-point) when it becomes available.
	// Returns nothing.

	params ["_mkrType", "_tag", "_mkr", "_isBooked"];
	private ["_bookedLoc", "_bookedAmount", "_isError"];

	// Escape - part 1/2:
	if !_isBooked exitWith {};
	// Initial values:
	_bookedLoc = [];
	_isError = false;
	_bookedAmount = 0;  // debug purposes.
	// All cases where booking can be applied:
	switch _mkrType do {
		case "BOOKING_WATCH":     { _bookedLoc = CSWR_bookedLocWatch };     // [[blu],[opf],[ind],[civ]]
		case "BOOKING_HOLD":      { _bookedLoc = CSWR_bookedLocHold };      // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNVEH":  { _bookedLoc = CSWR_bookedLocSpwnVeh };   // [[blu],[opf],[ind],[civ]]
		case "BOOKING_SPAWNHELI": { _bookedLoc = CSWR_bookedLocSpwnHeli };  // [[blu],[opf],[ind],[civ]]
		default { ["%1 There is no '%2' in 'THY_fnc_CSWR_marker_booking_undo' function.", CSWR_txtWarningHeader, _mkrType] call BIS_fnc_error; _isError = true };
	};
	// Escape - part 2/2:
	if _isError exitWith {};
	// Debug texts:
		// reserved space.
	// Main functionality:
	// For each case, remove the current hold-marker as reserved from the reservation list:
	switch _tag do {
		case "BLU": { (_bookedLoc # 0) deleteAt ((_bookedLoc # 0) find _mkr); _bookedAmount = count (_bookedLoc # 0) };
		case "OPF": { (_bookedLoc # 1) deleteAt ((_bookedLoc # 1) find _mkr); _bookedAmount = count (_bookedLoc # 1) };
		case "IND": { (_bookedLoc # 2) deleteAt ((_bookedLoc # 2) find _mkr); _bookedAmount = count (_bookedLoc # 2) };
		case "CIV": { (_bookedLoc # 3) deleteAt ((_bookedLoc # 3) find _mkr); _bookedAmount = count (_bookedLoc # 3) };
	};
	// After that, update the public variable with the new reservation:
	switch _mkrType do {
		case "BOOKING_WATCH":     { CSWR_bookedLocWatch    = _bookedLoc; publicVariable "CSWR_bookedLocWatch" };
		case "BOOKING_HOLD":      { CSWR_bookedLocHold     = _bookedLoc; publicVariable "CSWR_bookedLocHold" };
		case "BOOKING_SPAWNVEH":  { CSWR_bookedLocSpwnVeh  = _bookedLoc; publicVariable "CSWR_bookedLocSpwnVeh" };
		case "BOOKING_SPAWNHELI": { CSWR_bookedLocSpwnHeli = _bookedLoc; publicVariable "CSWR_bookedLocSpwnHeli" };
	};
	// Debug:
	if CSWR_isOnDebugGlobal then {
		// Hold message 1:
		if ( _mkrType isEqualTo "BOOKING_HOLD" ) then {
			systemChat format ["%1 HOLD > A %2 tracked vehicle's changing position.", CSWR_txtDebugHeader, _tag];
			// Breath:
			sleep 5;
		};
		// Hold message 2:
		if CSWR_isOnDebugHold then {
			systemChat format ["%1 HOLD > %2 > There is/are %3 tracked vehicle(s) in perfect HOLDING right now.", CSWR_txtDebugHeader, _tag, _bookedAmount];
			// Breath:
			sleep 5;
		};
	};
	// Return:
	true;
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
		default { /* Debug message is not needed here coz the error handling is make in THY_fnc_CSWR_add_group and THY_fnc_CSWR_add_vehicle functions */ };
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
	private ["_isValid", "_txt1"];

	// Initial values:
	_isValid = true;
	// Errors handling > If _classnames receive something that's not an array, convert it to an array:
	if ( typeName _classnames isNotEqualTo "ARRAY" ) then { _classnames = [_classnames] };
	// Escape > If array empty:
	if ( count _classnames == 0 ) exitWith {
		/* // Update the validation flag:
		_isValid = false;
		// Warning message:
		["%1 %2 > The variable '%3' looks EMPTY. Fix it to avoid errors.", CSWR_txtWarningHeader, _tag, _var] call BIS_fnc_error;
		// Breath:
		sleep 5; */
		// Return:
		_isValid;  // true
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
	if !_isValid exitWith { _isValid /* Returning false */ };
	// Escape > if editor's using 'RANDOM' command exclusively for civilian uniform, it's ok, just leave as valid:
	if ( _tag isEqualTo "CIV" && _what == "uniform" && (_classnames # 0) isEqualTo "RANDOM" ) exitWith { _isValid;  /* Returning true */ };
	// Declarations:
		// reserved space.
	// Debug texts:
	_txt1 = "Check if it's spelled correct or, if it's from a mod, the mod is loaded on server. FIX IT!";
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
	private ["_isValid", "_classnameType", "_classnamesOk", "_delta", "_classnamesAmount", "_whatIndividual", "_whatColletive", "_eachAbleType"];

	// Initial values:
	_isValid = true;
	_classnameType = [];
	_classnamesOk = [];
	_delta = 0;
	// Declarations:
	_classnamesAmount = count _classnames;
	_whatIndividual = if _isVeh then { "VEHICLE" } else { "UNIT" };
	_whatColletive = if _isVeh then { "VEHICLE" } else { "GROUP" };
	// Escape:
	if ( _classnamesAmount isEqualTo 0 ) exitWith { _isValid = false; _isValid /* Returning... */ };
	// Debug texts:
		// reserved space.
	
	{  // forEach _ableTypes:
		_eachAbleType = _x;
		{  // forEach _classnames:
			// if group members:
			if !_isVeh then {
				// If the classname is an abled type, include this valid classname in another array:
				if ( _x isKindOf _eachAbleType ) then { _classnamesOk pushBack _x };
			// otherwise, if vehicle:
			} else {
				// Using this method for vehicles to prevent the insertion of nautical vehicles or planes, etc:
				_classnameType = (_x call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
				// If the classname is an abled type, include this valid classname in another array:
				if ( _classnameType in _eachAbleType ) then { _classnamesOk pushBack _x };
			};
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
		if ( _delta isEqualTo 1 ) then {
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
		["%1 %2 > One or more %3s HAS NO BEHAVIOR properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integrity, the %3 WON'T BE CREATED.", CSWR_txtWarningHeader, _tag, _requester] call BIS_fnc_error; sleep 5;
	};
	// Return:
	_isValid;
};


THY_fnc_CSWR_is_valid_destination = {
	// This function just validates if there is at least the minimal valid destination amount dropped on the map for further validations.
	// Return _isThereDest: bool.

	params ["_tag", "_isVeh", "_destType"];
	private ["_isThereDest", "_isValid", "_destMarkers", "_minAmount", "_requester", "_isError", "_txt1", "_txt2", "_txt3", "_txt4"];

	// Initial value:
	_isThereDest = false;
	_isValid = false;
	_destMarkers = [];
	_minAmount = nil;
	_isError = false;
	// Escape - part 1/2:
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
		default                 { ["%1 There is no '%2' in 'THY_fnc_CSWR_is_valid_destination' function.", CSWR_txtWarningHeader, _destType] call BIS_fnc_error; _isError = true };
	};
	// Escape - part 2/2:
	if _isError exitWith { _isThereDest /* Returning */ };
	// Debug texts:
	_txt1 = format ["A %1 %2 won't be created coz the DESTINATION TYPE '%3' HAS NO %4 or more markers dropped on the map.", _tag, _requester, _destType, _minAmount];
	_txt2 = format ["One or more %1 %2s HAS NO DESTINATION properly configured in 'fn_CSWR_population.sqf' file. For script integrity, the %2 won't be created.", _tag, _requester];
	_txt3 = format ["%1 %2 CANNOT use '%3' destinations. Check the 'fn_CSWR_population.sqf' file. For script integrity, the %2 won't be created.", _tag, _requester, _destType];
	_txt4 = format ["Civilians CANNOT use '%1' destinations. Check the 'fn_CSWR_population.sqf' file. For script integrity, the civilian group won't be created.", _destType];
	// Errors handling:
	if ( typeName _destType isEqualTo "STRING" ) then { _destType = toUpper _destType };
	// Main validation:
	switch _destType do {
		case "MOVE_ANY": {
			// if at least X destinations of this type, and the faction IS NOT civilian:
			if ( count CSWR_destsANYWHERE >= CSWR_minDestAny && _tag isNotEqualTo "CIV" ) then { 
				// Prepare to return, saying there are available destinations:
				_isThereDest = true;
			// Otherwise:
			} else {
				// If civilian:
				if ( _tag isEqualTo "CIV" ) then {
					// Warning message:
					["%1 %2", CSWR_txtWarningHeader, _txt4] call BIS_fnc_error; sleep 5;
				} else {
					// Warning message:
					["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
				};
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
		["%1 %2 > One or more groups HAS NO FORMATION properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integrity, the group WON'T BE CREATED.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		sleep 5;
	};
	// Return:
	_isValid;
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

	params ["_spwns", "_spwnPos", "_isVeh", "_isAirCrew"];
	private ["_return", "_isParadrop"];

	// Initial values:
	_isParadrop = false;
	_return = [_isParadrop, _spwnPos];
	// Escape:
	if _isAirCrew exitWith { _return /* Returning... */};
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// If _spwns are the faction paradrop spawns, keep going:
	if ( _spwns isEqualTo CSWR_spwnsParadropBLU || _spwns isEqualTo CSWR_spwnsParadropOPF || _spwns isEqualTo CSWR_spwnsParadropIND || _spwns isEqualTo CSWR_spwnsParadropCIV ) then { 
		// Update the validation flag:
		_isParadrop = true;
		// Update the altitude of _spwnPos:
		if !_isVeh then {
			_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropUnitAlt];
		} else {
			_spwnPos = [_spwnPos # 0, _spwnPos # 1, abs CSWR_spwnsParadropVehAlt];
		};
	};
	// Preparing to return:
	_return = [_isParadrop, _spwnPos];
	// Return:
	_return;
};


THY_fnc_CSWR_group_type_rules = {
	// This function defines rules to each Group Type of a faction (through Erros Handling), and returns a "dictionary" to be used for another functions (e.g. Skills) later.
	// Returns _grpInfo array. If it returns empty, it's because the group is invalid and can't be spawned.

	params["_faction", "_tag", "_grpClasses", "_destType", "_behavior", "_form"];
	private["_teamLight", "_teamMedium", "_teamHeavy", "_teamCustom1", "_teamCustom2", "_teamCustom3", "_teamSniper", "_vehLight", "_vehMedium", "_vehHeavy", "_vehCustom1", "_vehCustom2", "_vehCustom3", "_heliLight", "_heliHeavy", "_isError", "_grpInfo","_grpType", "_grpSize"];

	// Escape:
		// reserved space.
	// Initial values:
	_teamLight=[]; _teamMedium=[]; _teamHeavy=[]; _teamCustom1=[]; _teamCustom2=[]; _teamCustom3=[]; _teamSniper=[];  // people groups;
	_vehLight=[]; _vehMedium=[]; _vehHeavy=[]; _vehCustom1=[]; _vehCustom2=[]; _vehCustom3=[]; _heliLight=[]; _heliHeavy=[];  // vehicle groups;
	_isError = false;
	_grpInfo = [];
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
		default { ["%1 %2 > There is no faction called '%3'. There are only 'BLUFOR', 'OPFOR', 'INDEPENDENT' and 'CIVILIAN'. Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag, _faction] call BIS_fnc_error; _isError = true };
	};
	// Escape:
	if _isError exitWith { _grpInfo /* Returning */ };
	// Group information > basic:
	// _grpInfo is [ group faction (side variable), group faction tag (strig), group id (obj), group type (str), group classnames ([strs]), group behavior (str), group formation (str), destination type (str) ]
	_grpInfo = [_faction, _tag, grpNull, "", [], _behavior, _form, _destType];  // Tip: to figure out the _grpInfo units (objs), use: "units _grpInfo # 2" or "units _grp".
	// Group information > specificity:
	switch _grpClasses do {
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


THY_fnc_CSWR_group_type_isAirCrew = {
	// This function returns if the group belongs an air group type.
	// Returns _irAirCrew. Bool.

	params ["_grpType"];
	private ["_irAirCrew"];

	// Escape:
	// WIP - when the 'isNil' is here, the exitWith is activated badly. Working on...
	if ( /* isNil _grpType || */ _grpType isEqualTo "" ) exitWith { false };
	// Initial values:
	_irAirCrew = false;
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Main functionality:
	if ( _grpType isEqualTo "heliL" || _grpType isEqualTo "heliH" ) then { _irAirCrew = true };  // WIP including to check if is plane, helicopter 
	// Return:
	_irAirCrew;
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
		default { ["%1 %2 > THERE IS NO behavior called '%3'. Check the documentation and fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, side (leader _grp), _behavior] call BIS_fnc_error };
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


THY_fnc_CSWR_veh_electronic_warfare = {
	// This function sets the electronic warfare resources for vehicles.
	// Returns nothing.

	params ["_tag", "_veh", "_isAirCrew"];
	private ["_isOn"];

	// Escape:
		// reserved space.
	// Initial values:
	_isOn = true;
	// Declarations:
	switch _tag do {
		case "BLU": { _isOn = CSWR_isElectroWarForBLU };
		case "OPF": { _isOn = CSWR_isElectroWarForOPF };
		case "IND": { _isOn = CSWR_isElectroWarForIND };
		case "CIV": { /* this faction has no this option */ };
	};
	// Debug texts:
		// reserved space.
	// Main functionality:
	_veh setVehicleReportOwnPosition _isOn;
	if _isAirCrew then { _veh setVehicleReceiveRemoteTargets true } else { _veh setVehicleReceiveRemoteTargets _isOn };
	_veh setVehicleReportRemoteTargets _isOn;
	// Return:
	true;
};


THY_fnc_CSWR_veh_paradrop = {
	// This function creates the paradrop system for one vehicle, including multiples parachutes attached on it.
	// About the original author: it's a lighter/modificated version of KK_fnc_paraDrop function: http://killzonekid.com/arma-scripting-tutorials-epic-armour-drop/
	// Returns nothing.

	params ["_tag", "_veh", "_grp"];
	private ["_colorChute", "_vehTypesHeavy", "_vehTypesMedium", "_vehType", "_mainChute", "_allChutes", "_velocity"];

	// Escape part 1/2:
	_colorChute = "";
	// Declarations:
	_vehTypesHeavy  = ["Tank"];
	_vehTypesMedium = ["WheeledAPC", "TrackedAPC"];
	_vehType = (_veh call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
	switch _tag do {
		case "BLU": { _colorChute = "B_Parachute_02_F" };
		case "OPF": { _colorChute = "O_Parachute_02_F" };
		case "IND": { _colorChute = "I_Parachute_02_F" };
		//case "CIV": {  CIV has no paradrop for vehicles, nor parachute with specific color };
	};
	// Debug:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugPara ) then {
		systemChat format ["%1 PARADROP > %2 '%3' vehicle is a '%4' type.", CSWR_txtDebugHeader, _tag, _veh, _vehType];
	};
	// Creating the main vehicle parachute:
	_mainChute = createVehicle [_colorChute, [0,0,0], [], 0, "FLY"];
	[_mainChute, getDir _veh] remoteExec ["setDir"];
	_mainChute setPos (getPos _veh);
	_veh attachTo [_mainChute, [0,2,0]];

	// Additionals if probably a heavy vehicle:
	_allChutes = [_mainChute];
	if ( _vehType in _vehTypesHeavy ) then {
		{  // Multiple parachutes for vehicle:
			_i = createVehicle [_colorChute, [0,0,0], [], 0, "FLY"];
			_allChutes set [count _allChutes, _i];
			_i attachTo [_mainChute, [0,0,0]];
			_i setVectorUp _x;
		} count [ [0.5,0.4,0.8], [-0.5,0.4,0.8], [0.5,-0.4,0.8], [-0.5,-0.4,0.8] ];
	// Otherwise:
	} else {
		// Additionals if probably a medium vehicle:
		if ( _vehType in _vehTypesMedium ) then {
			{  // Multiple parachutes for vehicle:
				_i = createVehicle [_colorChute, [0,0,0], [], 0, "FLY"];
				_allChutes set [count _allChutes, _i];
				_i attachTo [_mainChute, [0,0,0]];
				_i setVectorUp _x;
			} count [ [0.5,0.2,0.9], [-0.5,0.2,0.9] ];
		};
	};
	// Force the crewmen to hold-fire if they see an enemy (hehehe):
	{ _x disableAI "all" } forEach units _grp;
	// Waiting the vechile get closer to the ground:
	waitUntil { sleep 0.1; ((getPos _veh) # 2) < 4 || !alive _veh };
	// Adjust to vehicle velocity after the parachutes detachment:
	_velocity = velocity _veh;  // [x,y,z]
	detach _veh;
	_veh setVelocity _velocity;
	// Detachment of parachutes from the vehicle:
	playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _veh];
	{ detach _x; _x disableCollisionWith _veh } forEach _allChutes;
	// Restore the crewmen capability to engage:
	{ _x enableAI "all" } forEach units _grp;
	// Animations breath:
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
			if ( count _content > 0 ) then { { _unit addItemToUniform _x } forEach _content };
		};
		case "backpack": {
			// Old backpack content:
			_content = backpackItems _unit;
			// Remove the old backpack:
			removeBackpack _unit;
			// Replace for the new backpack:
			_unit addBackpack _newContainer;
			// if there is one or more items from old backpack, repack them to the new one:
			if ( count _content > 0 ) then { { _unit addItemToBackpack _x } forEach _content };
		};
		case "vest": {
			// Old vest content:
			_content = vestItems _unit;
			// Remove the old vest:
			removeVest _unit;
			// Replace for the new vest:
			_unit addVest _newContainer;
			// if there is one or more items from old vest, repack them to the new one:
			if ( count _content > 0 ) then { { _unit addItemToVest _x } forEach _content };
		};
	};
	// CPU breath:
	sleep 0.1;
	// Return:
	_content;
};


THY_fnc_CSWR_gear_NVG = {
	// This function undestands with unit class can got Nigh Vision Goggles and, if allowed in fn_CSWR_management.sqf file, customizes it with editor's choice.
	// Returns nothing.

	params ["_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_canNvgInfantry", "_canNvgParatroops", "_canNvgSnipers", "_canFlashlight", "_newNvg", "_newFlashlight", "_oldNvg"];
	
	// Initial values:
	_canNvgInfantry = false;
	_canNvgParatroops = false;
	_canNvgSnipers = false;
	_canFlashlight = false;
	_newNvg = "";
	_newFlashlight = "";
	// Errors handling:
		// Reserved space.
	// Declarations - part 1/2:
	_oldNvg = hmd _unit;  // if empty, returns "".
	// Remove any possible gear from the unit reached here:
	_unit unlinkItem _oldNvg;
	_unit removeItem _oldNvg;
	// Escape > Any heavy crew cannot use NVG:
	if ( _grpSpec in ["specHeavyCrew", "specParaHeavyCrew"] ) exitWith {};  // Leave this always after NVG removal.
	// Declarations - part 2/2:
	// Check all information about gear for the unit's faction:
	switch _tag do {
		case "BLU": { _canNvgInfantry = CSWR_canNvgInfantryBLU; _canNvgParatroops = CSWR_canNvgParatroopsBLU; _canNvgSnipers = CSWR_canNvgSnipersBLU; _canFlashlight = CSWR_canFlashlightBLU; _newNvg = CSWR_nvgDeviceBLU; _newFlashlight = CSWR_flashlightDeviceBLU };
		case "OPF": { _canNvgInfantry = CSWR_canNvgInfantryOPF; _canNvgParatroops = CSWR_canNvgParatroopsOPF; _canNvgSnipers = CSWR_canNvgSnipersOPF; _canFlashlight = CSWR_canFlashlightOPF; _newNvg = CSWR_nvgDeviceOPF; _newFlashlight = CSWR_flashlightDeviceOPF };
		case "IND": { _canNvgInfantry = CSWR_canNvgInfantryIND; _canNvgParatroops = CSWR_canNvgParatroopsIND; _canNvgSnipers = CSWR_canNvgSnipersIND; _canFlashlight = CSWR_canFlashlightIND; _newNvg = CSWR_nvgDeviceIND; _newFlashlight = CSWR_flashlightDeviceIND };
		case "CIV": { _canNvgInfantry = CSWR_canNvgCIV; _newNvg = CSWR_nvgDeviceCIV };
	};
	// Debug texts:
		// reserved space.

	// If the usage is mandatory:
	if _isMandatory then {
		// Important: not create a validation to check if the newGear is equal to oldGear to check if the change is needed coz the editor probably wants to change the NVG model.
		// Add the new gear:
		_unit linkItem _newNvg;
	// Otherwise, not mandatory:
	} else {
		
		// SNIPER GROUP:
		// If the unit is a sniper group member:
		if ( _grpType isEqualTo "teamS" ) then {
			// INFANTRY Sniper group:
			// If infantry sniper group members are allowed to use the gear:
			if _canNvgSnipers then {
				// Add the new gear:
				_unit linkItem _newNvg;
			// Otherwise:
			} else {
				// PARATROOPER Sniper group:
				// If paratrooper sniper group members are allowed to use the gear:
				if ( _canNvgParatroops && _grpSpec isEqualTo "specPara" ) then {
					// Add the new gear:
					_unit linkItem _newNvg;
				};
			};
		
		} else {

			// PARATROOPER:
			// If the unit is a paratrooper:
			if ( _grpSpec isEqualTo "specPara" ) then {
				// If PARATROOPER is allowed to use the gear:
				if _canNvgParatroops then { 
					_unit linkItem _newNvg;
				} else {
					// If the faction can use flashlight, at least the unit will get one when no NVG:
					if _canFlashlight then {
						// Avoids a duplication at least if the gear is the same classname:
						_unit removePrimaryWeaponItem _newFlashlight;
						// Add the gear:
						_unit addPrimaryWeaponItem _newFlashlight;
						// Setting the flashlight:
						_unit enableGunLights "Auto";
					};
				};
			
			} else {

				// INFANTRY:
				// If INFANTRY is allowed to use the gear:
				if _canNvgInfantry then {
					_unit linkItem _newNvg;
				} else {
					// If the faction can use flashlight, at least the unit will get one when no NVG:
					if _canFlashlight then {
						// Avoids a duplication at least if the gear is the same classname:
						_unit removePrimaryWeaponItem _newFlashlight;
						// Add the gear:
						_unit addPrimaryWeaponItem _newFlashlight;
						// Setting the flashlight:
						_unit enableGunLights "Auto";
					};
				};
			};
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_facewear = {
	// This function replace the old unit's facewear (goggles, glasses, balaclava, mask) for the new one.
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear"];

	// Escape:
		// Reserved space.
	// Initial values:
		// Reserved space.
	// Errors handling:
		// Reserved space.
	// Declarations:
	_oldGear = goggles _unit;  // if empty, returns "".
	// Debug texts:
		// reserved space.

	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroopers".
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
		// Otherwise, force removal:
		removeGoggles _unit;
	};
	// Return:
	true;
};


THY_fnc_CSWR_gear_helmet = {
	// This function replace the old unit's helmet for the new one.
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear"];

	// Escape:
		// Reserved space.
	// Initial values:
		// Reserved space.
	// Errors handling:
		// Reserved space.
	// Declarations:
	_oldGear = headgear _unit;  // if empty, returns "".
	// Debug texts:
			// reserved space.

	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroopers".
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
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear", "_genericGear"];

	// Escape:
		// Reserved space.
	// Initial values:
		// Reserved space.
	// Errors handling:
		// Reserved space.
	// Declarations:
	_oldGear = uniform _unit;  // if empty, returns "".
	_genericGear = "U_BG_Guerilla2_1";
	// Debug texts:
		// reserved space.

	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroopers".
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
					_unit forceAddUniform _genericGear;
					// Warning message:
					["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using UNIFORM but in 'fn_CSWR_loadout.sqf' you didn't set a UNIFORM for them or, at least, for the group class they inherit the UNIFORM. For script integrity, CSWR sets a generic one.", CSWR_txtWarningHeader, _tag, str (group _unit), _grpType] call BIS_fnc_error; sleep 5;
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
	// Return:
	true;
};


THY_fnc_CSWR_gear_vest = {
	// This function add to the new vest all the old unit's vest original content.
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear", "_genericGear"];

	// Escape:
		// Reserved space.
	// Initial values:
		// Reserved space.
	// Errors handling:
		// Reserved space.
	// Declarations:
	_oldGear = vest _unit;  // if empty, returns "".
	_genericGear = "V_Chestrig_blk";
	// Debug texts:
		// reserved space.

	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroopers".
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
					// Warning message:
					["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using VEST but in 'fn_CSWR_loadout.sqf' you didn't set a VEST for them or, at least, for the group class they inherit the VEST. For script integrity, CSWR sets a generic one.", CSWR_txtWarningHeader, _tag, str (group _unit), _grpType] call BIS_fnc_error; sleep 5;
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
	// Returns nothing.

	params ["_newGear", "_unit", "_grpType", "_grpSpec", "_tag", "_isMandatory"];
	private ["_oldGear", "_genericGear"];

	// Escape > Infantry (ANY) Crew never get backpack (not including passagers):
	if ( !isNull (objectParent _unit) && { _unit isEqualTo driver (vehicle _unit) || _unit isEqualTo gunner (vehicle _unit) || _unit isEqualTo commander (vehicle _unit) } ) exitWith {};
		// Escape > Infantry Heavy Crew never get backpack (not including passagers):
		//if ( _grpSpec in ["specHeavyCrew", "specParaHeavyCrew"] ) exitWith {};
	// Initial values:
		// Reserved space.
	// Errors handling:
		// Reserved space.
	// Declarations:
	_oldGear = backpack _unit;  // if empty, returns "".
	_genericGear = "B_Carryall_blk";
	// Debug texts:
		// reserved space.

	// If editor is NOT trying to remove the gear by force:
	if ( _newGear isNotEqualTo "REMOVED" ) then {  // IMPORTANT: if you need to stop the editor to force removal, create rules in loadout functions, as e.g. "Infantry basic", or "Paratroopers".
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
					// Warning message:
					["%1 LOADOUT > %2 '%3' members ('%4' group type) should be using BACKPACK but in 'fn_CSWR_loadout.sqf' you didn't set a BACKPACK for them or, at least, for the group class they inherit the BACKPACK. For script integrity, CSWR sets a generic one.", CSWR_txtWarningHeader, _tag, str (group _unit), _grpType] call BIS_fnc_error; sleep 5;
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
	// Initial values:
		// Reserved space.
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
		// ["%1 LOADOUT > %2 Sniper groups got rifle and its ammo compability issues. Check it out in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error; sleep 5;
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


THY_fnc_CSWR_loadout_infantry_basicGroup = {
	// This function organizes the basic of all infantry classes unit loadout, including: heavy crew, sniper groups, and paratroopers. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_newBackpack", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_isValidBackpackClass"];

	// Escape:
		// reserved space.
	// Initial values:
	_isValidUniformClasses = true;
	_isValidVestClasses    = true;
	_isValidHelmetClasses  = true;
	_isValidGogglesClass   = true;
	_isValidBackpackClass  = true;
	// Errors handling:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		_isValidUniformClasses = [_tag, "CfgWeapons",  "uniform",  "_newUniform",  [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		_isValidVestClasses    = [_tag, "CfgWeapons",  "vest",     "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		_isValidHelmetClasses  = [_tag, "CfgWeapons",  "helmet",   "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		_isValidGogglesClass   = [_tag, "CfgGlasses",  "goggles",  "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
		_isValidBackpackClass  = [_tag, "CfgVehicles", "backpack", "_newBackpack", [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
	};
	
	// Uniform:
	// If editor is NOT trying to randomize the uniforms, keep going:
	if ( _newUniform isNotEqualTo "RANDOM" ) then {
		[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
	// Otherwise:
	} else {
		// If civilian unit:
		if ( _tag isEqualTo "CIV" ) then {
			// use the command random to select one of the CSWR_civilianOutfits clothes available:
			[selectRandom CSWR_civilianOutfits, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
		// Otherwise:
		} else {
			// Warning message:
			// The msg shows up just once:
			if ( _unit isEqualTo (leader (group _unit))) then {
				["%1 %2 > Only CIV faction can use the command 'RANDOM' in its loadout. A %2 group has been deleted. Fix this in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error; sleep 5;
			};
			// Delete the unit:
			deleteVehicle _unit;
		};
	};
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
	if ( !(_grpSpec in ["specPara", "specParaHeavyCrew", "specHeavyCrew"]) ) then {
		// If NOT civilian:
		if ( _tag isNotEqualTo "CIV" ) then {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, CSWR_isBackpackForAllByFoot] call THY_fnc_CSWR_gear_backpack;
		// Otherwise:
		} else {
			[_newBackpack, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_backpack;
		};
		// As parachuters, the sniper group member will receive (or not) the NVG further, not now:
		if ( _grpType isNotEqualTo "teamS" ) then {
			// NightVision:
			[_unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_NVG;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_infantry_specialityParachuting = {
	// This function organizes the unit loadout of any group with parachuting specialty. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_genericChute"];

	// Escape > if the unit doesn't have some parachute speciality, abort:
	if ( !(_grpSpec in ["specPara", "specParaHeavyCrew"]) ) exitWith {};
	// Escape > If editor's trying to remove a mandatory gear, or no new gear was declared and the unit has NO an old gear to inherit:
	if ( _newVest isEqualTo "REMOVED" || {_newVest isEqualTo "" && vest _unit isEqualTo ""} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 PARACHUTE group member was deleted coz a mandatory gear (VEST) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no vest. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	// WIP - Not working propperly. Always one group member is reaching the ground with no any goggles when editor doesn't set some.
	if ( _newGoggles isEqualTo "REMOVED" || {_newGoggles isEqualTo "" && !(goggles _unit in CSWR_parachuteAcceptableGoggles)} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 PARACHUTE group member was deleted coz a mandatory gear (GOGGLES) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no valid goggles for parachuting. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	// Initial values:
	_isValidUniformClasses = true;
	_isValidVestClasses    = true;
	_isValidHelmetClasses  = true;
	_isValidGogglesClass   = true;
	// Errors handling:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Declarations:
	_genericChute = "B_Parachute";
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		_isValidUniformClasses = [_tag, "CfgWeapons",  "uniform",  "_newUniform",  [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		_isValidVestClasses    = [_tag, "CfgWeapons",  "vest",     "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		_isValidHelmetClasses  = [_tag, "CfgWeapons",  "helmet",   "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		_isValidGogglesClass   = [_tag, "CfgGlasses",  "goggles",  "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
	};
	// if parachuter is open-chest free fall (never including e.g. specParaHeavyCrew):
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
		// NightVision:
		[_unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_NVG;
	};
	// Uniform
	// Important: parachuters and any crew executing paradrop can has the same specific uniform.
	[_newUniform, _unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_uniform;
	// Return:
	true;
};


THY_fnc_CSWR_loadout_infantry_heavyCrewGroup = {
	// This function organizes exclusively the infantry heavy crew unit loadout. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newHelmet", "_newGoggles", "_newVest", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_veh"];

	// Escape > If the unit speciality is NOT any kind of heavy crew, or if it's a civilian, abort:
	if ( !(_grpSpec in ["specHeavyCrew", "specParaHeavyCrew"]) || _tag isEqualTo "CIV" ) exitWith {};
	// Initial values:
	_isValidVestClasses    = true;
	_isValidHelmetClasses  = true;
	_isValidGogglesClass   = true;
	// Errors handling:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Declarations:
	_veh = vehicle _unit;
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		_isValidVestClasses    = [_tag, "CfgWeapons",  "vest",     "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		_isValidHelmetClasses  = [_tag, "CfgWeapons",  "helmet",   "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		_isValidGogglesClass   = [_tag, "CfgGlasses",  "goggles",  "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
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
		// Important: Heavy Crew cannot have NVG, but the function need to be called to remove any NVG in crewmen loadout:
		[_unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_NVG;
	};
	// Return:
	true;
};


THY_fnc_CSWR_loadout_infantry_sniperGroup = {
	// This function organizes exclusively the infantry sniper group unit loadout. The rules exceptions must be applied in this function, and not in the gear functions.
	// Returns nothing.

	params ["_newUniform", "_newHelmet", "_newGoggles", "_newVest", "_newBackpack", "_newRifle", "_newMag", "_newOptics", "_newRail", "_newMuzzle", "_newBipod", "_newBinoc", "_unit", "_grpType", "_grpSpec", "_tag"];
	private ["_isValidUniformClasses", "_isValidVestClasses", "_isValidHelmetClasses", "_isValidGogglesClass", "_isValidBackpackClass", "_isValidRifleClass", "_isValidMagClass", "_isValidOpticsClass", "_isValidRailClass", "_isValidMuzzleClass", "_isValidBipodClass", "_isValidBinocClass", "_genericPistol", "_genericPistolAmmo"];

	// Escape > If unit is NOT member of sniper group, abort:
	if ( _grpType isNotEqualTo "teamS" ) exitWith {};
	// Escape > If editor's trying to remove a mandatory gear, or no new gear was declared and the unit has NO an old gear to inherit:
	if ( _newMag isEqualTo "REMOVED" || {_newMag isEqualTo "" && primaryWeaponMagazine _unit isEqualTo ""} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (PRIMARY AMMO) WAS REMOVED or it WASN'T DECLARED in its loadout or in its inherited loadout. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newRifle isEqualTo "REMOVED" || {_newRifle isEqualTo "" && primaryWeapon _unit isEqualTo ""} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (PRIMARY WEAPON) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no primary weapon. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newVest isEqualTo "REMOVED" || {_newVest isEqualTo "" && vest _unit isEqualTo ""} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (VEST) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no vest. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	if ( _newBinoc isEqualTo "REMOVED" || {_newBinoc isEqualTo "" && binocular _unit isEqualTo ""} ) exitWith {
		// Warning message:
		["%1 LOADOUT > A %2 SNIPER GROUP was deleted coz a mandatory gear (BINOCULARS) 1) WAS REMOVED or 2) it WASN'T DECLARED in its loadout or in its inherited loadout, or even 3) the original unit has no binoculars. Check the %2 section in 'fn_CSWR_loadout.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Remove the unit as pushiment:
		deleteVehicle _unit;
	};
	// Initial values:
	_isValidUniformClasses = true;
	_isValidVestClasses    = true;
	_isValidHelmetClasses  = true;
	_isValidGogglesClass   = true;
	_isValidBackpackClass  = true;
	_isValidRifleClass     = true;
	_isValidMagClass       = true;
	_isValidOpticsClass    = true;
	_isValidRailClass      = true;
	_isValidMuzzleClass    = true;
	_isValidBipodClass     = true;
	_isValidBinocClass     = true;
	// Errors handling:
		// reserved space.
	// Debug texts:
		// reserved space.
	// Declarations:
	_genericPistol     = "hgun_P07_F";
	_genericPistolAmmo = "16Rnd_9x21_Mag";
	// Classnames validation of group leader loadout:
	// WIP - Important: these bools below are not used yet in the whole code because for this current CSWR version it's not needed.
	if ( _unit isEqualTo (leader (group _unit)) ) then {
		_isValidUniformClasses = [_tag, "CfgWeapons",   "uniform",   "_newUniform",  [_newUniform]] call THY_fnc_CSWR_is_valid_classname;
		_isValidVestClasses    = [_tag, "CfgWeapons",   "vest",      "_newVest",     [_newVest]] call THY_fnc_CSWR_is_valid_classname;
		_isValidHelmetClasses  = [_tag, "CfgWeapons",   "helmet",    "_newHelmet",   [_newHelmet]] call THY_fnc_CSWR_is_valid_classname;
		_isValidGogglesClass   = [_tag, "CfgGlasses",   "goggles",   "_newGoggles",  [_newGoggles]] call THY_fnc_CSWR_is_valid_classname;
		_isValidBackpackClass  = [_tag, "CfgVehicles",  "backpack",  "_newBackpack", [_newBackpack]] call THY_fnc_CSWR_is_valid_classname;
		_isValidRifleClass     = [_tag, "CfgWeapons",   "rifle",     "_newRifle",    [_newRifle]] call THY_fnc_CSWR_is_valid_classname;
		_isValidMagClass       = [_tag, "CfgMagazines", "rifle magazine",   "_newMag",     [_newMag]] call THY_fnc_CSWR_is_valid_classname;
		_isValidMuzzleClass    = [_tag, "CfgWeapons",   "muzzle/suppressor", "_newMuzzle", [_newMuzzle]] call THY_fnc_CSWR_is_valid_classname;
		_isValidOpticsClass    = [_tag, "CfgWeapons",   "optics",     "_newOptics",  [_newOptics]] call THY_fnc_CSWR_is_valid_classname;
		_isValidRailClass      = [_tag, "CfgWeapons",   "rail",       "_newRail",    [_newRail]] call THY_fnc_CSWR_is_valid_classname;
		_isValidBipodClass     = [_tag, "CfgWeapons",   "bipod",      "_newBipod",   [_newBipod]] call THY_fnc_CSWR_is_valid_classname;
		_isValidBinocClass     = [_tag, "CfgWeapons",   "binoculars", "_newBinoc",   [_newBinoc]] call THY_fnc_CSWR_is_valid_classname;
	};
	// If the sniper group member is NOT a paratrooper (coz they must inherit some paratrooper gears):
	if ( _grpSpec isNotEqualTo "specPara" ) then {
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
		// NightVision:
		[_unit, _grpType, _grpSpec, _tag, false] call THY_fnc_CSWR_gear_NVG;
	};
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


THY_fnc_CSWR_loadout_selector = {
	// This function understands who is the group, its class and context, and select the right loadout must be applied for each group member.
	// Returns nothing.

	params ["_tag", "_grp", "_grpType", "_veh", "_isVeh", "_isAirCrew", "_isParadrop"];
	private ["_vehType", "_wait"];

	// Escape:
		// reserved space.
	// Initial values:
	_vehType = [];
	// Declarations:
	_wait = 0.3;
	// Debug texts:
		// reserved space.
		
	// Belong to Ground forces:
	if !_isAirCrew then {
		// Infantry air insertion:
		if _isParadrop then {
			// Paradrop vehicle:
			if _isVeh then {
				// Check the vehicle type:
				_vehType = (_veh call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
				// by heavy vehicle:
				if ( _vehType in CSWR_vehGroundHeavy ) then {
					// Apply the loadout:
					{ [_tag, _x, _grpType, "specParaHeavyCrew"] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;
				// by regular vehicle:
				} else {
					// Apply the loadout:
					{ [_tag, _x, _grpType, "specPara"] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;
				};
			// Paradrop soldiers:
			} else {
				// Apply the loadout:
				{ [_tag, _x, _grpType, "specPara"] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;
			};
		// Infantry ground insertion:
		} else {
			// If vehicle:
			if _isVeh then {
				// Check the vehicle type:
				_vehType = (_veh call BIS_fnc_objectType) # 1;  //  Returns like ['vehicle','Tank']
				// by heavy vehicle:
				if ( _vehType in CSWR_vehGroundHeavy ) then {
					// Apply the loadout:
					{ [_tag, _x, _grpType, "specHeavyCrew"] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;
				// by regular vehicle:
				} else {
					// Apply the loadout:
					{ [_tag, _x, _grpType, ""] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;  // Important: don't apply "specPara" in crew, even when they are paratroopers.
				};
			// Soldiers by foot:
			} else {
				// Apply the loadout:
				{ [_tag, _x, _grpType, ""] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;
			};
		};

	// Belong to Air forces:
	} else {
		// Loadout > Air Crew:
		//{ [_tag, _x, _grpType, ""] call THY_fnc_CSWR_loadout; sleep _wait } forEach units _grp;   // WIP ...
	};
	// Return:
	true;
};


THY_fnc_CSWR_base_service_station = {
	// This function provides rearming, refueling and repairing for AI vehicles, and health for crewmen.
	// Returns nothing.

	params ["_spwns", "_tag", "_grpType", "_grp", "_veh", "_isHeli", "_destType", "_behavior"];
	private ["_time", "_wait"];

	// Escape:
	if ( isNull _grp || !alive _veh ) exitWith {};
	// Initial values:
	_time = 0;
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
		_time = time + (random CSWR_heliTakeoffDelay); waitUntil { sleep 10; time > _time };
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


THY_fnc_CSWR_veh_condition = {
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
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHeli && _isHeli && ((getPos _veh) # 2) > 1 ) then {
				["%1 HELICOPTER > %2 '%3' > Pilot wounds: %4/1  |  Gunner wounds: %5/1  |  Heli damages: %6/1  |  Heli fuel: %7/0", CSWR_txtDebugHeader, _tag, str _grp, str damage _driver, str damage _gunner, damage _veh, fuel _veh] call BIS_fnc_error;
			};
			// Allows the heli to go to the next waypoint:
			isNull _grp || _veh distance _areaToPass < 200 || damage _veh > 0.4 || fuel _veh < 0.3 || damage _driver > 0.1;
		// Otherwise:
		} else {
			// Reserved space for other types of vehicles.
		};
	};
	// If the vehicle or crew has some of these conditions, the next waypoint must be the base:
	if ( damage _veh > 0.4 ||  fuel _veh < 0.3 || damage _driver > 0.1 ) then { _shouldRTB = true };
	// Return:
	_shouldRTB;
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
	// This function checks if the group or the vehicle needs to wait to spawn or if it's been granted to do its first pre-defined move now.
	// Returns nothing.

	params ["_spwns", "_spwnDelayMethods", "_grpInfo", "_isVeh", "_behavior", "_destType"];
	private ["_isValidToSpwnHere", "_canSpawn", "_veh", "_spwn", "_spwnPosChecker", "_spwnPos", "_isParadrop", "_bookingInfo", "_isBooked", "_serverBreath", "_blockers", "_time", "_nvg", "_faction", "_tag", "_grp", "_grpType", "_grpClasses", "_isAirCrew", "_grpSize", "_requester", "_safeDis", "_txt1", "_txt2", "_txt3"];

	// Escape:
	if ( _grpInfo isEqualTo [] ) exitWith {};
	// Initial values:
	_canSpawn = true;
	_veh = objNull;
	_spwn = "";
	_bookingInfo = [];
	_isBooked = false;
	_spwnPosChecker = [];
	_spwnPos = [];
	_isParadrop = false;
	_serverBreath = 0;
	_blockers = [];
	_time = 0;
	_nvg = "";
	// Errors handling:
		// reserved space.
	// Declarations:
	_faction    = _grpInfo # 0;
	_tag        = _grpInfo # 1;
	_grp        = _grpInfo # 2;
	_grpType    = _grpInfo # 3;
	_grpClasses = _grpInfo # 4;
	_isAirCrew  = [_grpType] call THY_fnc_CSWR_group_type_isAirCrew;
	_grpSize    = count _grpClasses;  // debug proposes.
	_requester  = if _isVeh then {"vehicle"} else {"group"};
	_safeDis    = 20;
	// Debug texts:
	_txt1 = format ["A %1 %2 has an error in 'fn_CSWR_population.sqf' file.", _tag, _requester];
	_txt2 = format ["For script integrity, the %1 WON'T SPAWN!", _requester];
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
					["%1 SPAWN DELAY > %2 Make sure you're using a timer, triggers, and targets without quotes, e.g: [5] or [varname_1] or [varname_1, varname_2] or [5, varname_1, varname_2]. %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error; sleep 5;
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
		// Check current server performance:
		_serverBreath = ((abs(CSWR_serverMaxFPS-diag_fps) / (CSWR_serverMaxFPS-CSWR_serverMinFPS)) ^ 2) * 2;  // ((abs(FPSMAX-diag_fps)/(FPSMAX-FPSLIMIT))^2)*MAXDELAY;
		// Select a spawn:
		_spwn = selectRandom _spwns;
		// Check if they will be paradrop (group and vehicle), regarding the answer, it returns the spawn position (_spwnPos):
		_spwnPosChecker = [_spwns, markerPos _spwn, _isVeh, _isAirCrew] call THY_fnc_CSWR_is_spawn_paradrop;
		_isParadrop = _spwnPosChecker # 0;
		_spwnPos = _spwnPosChecker # 1;

		// If NOT vehicle:
		if !_isVeh then {

			// BOOKING A SPAWN OF PEOPLE:
				// Units without any vehicle has no booking needed to spawn.	

			// SPAWNING GROUP OF PEOPLE:
			// Create the group id:
			_grp = createGroup _faction;
			// Create the units:
			if !_isParadrop then {
				// People on ground:
				{ _grp createUnit [_x, _spwnPos, [], 20, "NONE"]; sleep _serverBreath } forEach _grpClasses;
			} else {
				// People on air (parachuters):
				{ _grp createUnit [_x, _spwnPos, [], 200, "NONE"]; sleep _serverBreath } forEach _grpClasses;
			};
			// Not a good performance solution at all (by GOM, 2014 July):
				//_grp = [_spwnPos, _faction, _grpClasses, [],[],[],[],[], markerDir _spwn, false, 0] call BIS_fnc_spawnGroup; // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
			
		// Otherwise, if vehicle:
		} else {

			// BOOKING A GROUND SPAWN FOR VEHICLE:
			// Looping to booking a spawn-point (exclusively for vehicles in GROUND SPAWNS to avoid vehicle explosions by instant collision):
			while { !_isParadrop } do {
				// If ground crew:
				if !_isAirCrew then {
					_bookingInfo = ["BOOKING_SPAWNVEH", _spwnPos, _tag, _spwns, 10, 5] call THY_fnc_CSWR_marker_booking;
				// Otherwise, if air crew:
				} else {
					_bookingInfo = ["BOOKING_SPAWNHELI", _spwnPos, _tag, _spwns, 10, 20] call THY_fnc_CSWR_marker_booking;
				};
				// Which marker to spawn:
				_spwn = _bookingInfo # 0;
				// Spawn position:
				_spwnPos = _bookingInfo # 1;  // [x,y,z]
				// Is booked?
				_isBooked = _bookingInfo # 2;
				// If not booked:
				if !_isBooked then {
					// Debug message:
					if CSWR_isOnDebugGlobal then {
						// If ground vehicle:
						if !_isAirCrew then {
							["%1 VEHICLE > A %2 vehicle selected a spawn-point already booked for another vehicle. Next try soon...", CSWR_txtDebugHeader, _tag] call BIS_fnc_error;
						// Otherwise, if helicopter:
						} else {
							["%1 HELICOPTER > A %2 helicopter selected a helipad already booked for another helicopter. Next try soon...", CSWR_txtDebugHeader, _tag] call BIS_fnc_error;
						};
					};
					// CPU breath to prevent crazy loopings:
					sleep 10;
				// Otherwise, it's booked:
				} else {
					// Stop the loop:
					break;
				};
			};  // While-loop ends.

			// SPAWNING THE VEHICLE AND CREW:
			// If not air vehicle:
			if !_isAirCrew then {
				// If the vehicle will spawn on ground:
				if !_isParadrop then {
					// Find an empty place near to the ground spawn-point:
					_spwnPos = _spwnPos findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valius might result in vehicle explosions.
					// Creating the vehicle on ground:
					_veh = createVehicle [_grpClasses # 0, _spwnPos, [], 0, "NONE"];
				// Otherwise, if the ground vehicle will spawn in air (paradrop):
				} else {
					// Creating the vehicle in air:
					_veh = createVehicle [_grpClasses # 0, _spwnPos, [], 200, "NONE"];
				};
				// Not a good performance solution at all (by GOM, 2014 July):
					// Horrible for server performance: BIS_fnc_spawnVehicle;  // https://community.bistudio.com/wiki/BIS_fnc_spawnVehicle
				// Only ground vehicle config > Features:
				_veh setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners never will leave the their vehicle.
			// Otherwise, if the vehicle is a helicopter:
			} else {

				// SPAWNING THE HELICOPTER AND CREW:
				// if heli will spawn landed, this looping manages if has no blockers over the booked helipad:
				while { !CSWR_shouldHeliSpwnInAir } do {
					// Check if something relevant is blocking the _spwn position:
					_blockers = _spwnPos nearEntities [["Helicopter", "Plane", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "UAV"], 20];
					// If there's NO blockers:
					if ( count _blockers isEqualTo 0 ) then { break };
					// Debug messages:
					if CSWR_isOnDebugGlobal then {
						systemChat format ["%1 HELICOPTER > A %2 helicopter's waiting its HELIPAD (%3) to be clear. Next try soon...", CSWR_txtDebugHeader, _tag, _spwn];
						if CSWR_isOnDebugHeli then { { systemChat format ["HELIPAD BLOCKER:   %1", typeOf _x] } forEach _blockers };
					};
					// Breath for the next loop check:
					sleep 20;  // IMPORTANT: leave this command in the final of this scope/loop, never in the beginning.
				};  // While loop ends.
				// If Helicopter must spawn already in air:
				if CSWR_shouldHeliSpwnInAir then {
					// Create the helicopter:
					_veh = createVehicle [_grpClasses # 0, _spwnPos, [], 0, "FLY"];
				// Otherwise, Helicopter must spawn landed:
				} else {
					// Create the helicopter:
					_veh = createVehicle [_grpClasses # 0, _spwnPos, [], 0, "NONE"];
					// WIP : find a way to calc the height of the solid surface right over the Sea level...
					if ( underwater _veh ) then { _veh setPosASL [_spwnPos # 0, _spwnPos # 1, CSWR_spwnHeliOnShipFloor] };
				};
				// Only helicopter config > Features:
				if ( _grpType isEqualTo "heliL" ) then { _veh flyInHeight abs CSWR_heliLightAlt };
				if ( _grpType isEqualTo "heliH" ) then { _veh flyInHeight abs CSWR_heliHeavyAlt };
			};
			// Only vehicle config > Setting the vehicle direction:
			[_veh, markerDir _spwn] remoteExec ["setDir"];
			// Creating the group and its ground vehicle crew:
			_grp = _faction createVehicleCrew _veh;  // CRITICAL: never remove _faction to avoid inconscistences when mission editor to use vehicles from another faction.
			// Additional CPU Breath for all vehicles:
			sleep _serverBreath;
			// Only vehicle config > Features:
			[_tag, _veh, _isAirCrew] call THY_fnc_CSWR_veh_electronic_warfare;
		};

		// RIGHT AFTER THE SPAWN:
		// Update the _grpInfo:
		_grpInfo set [2, _grp];
		// Group/Vehicle config > Server performance:
		_grp deleteGroupWhenEmpty true;
		// Loadout selector:
		[_tag, _grp, _grpType, _veh, _isVeh, _isAirCrew, _isParadrop] call THY_fnc_CSWR_loadout_selector;
		// Group/Vehicle config > Units skills:
		[_grpType, _grp, _destType] call THY_fnc_CSWR_unit_skills;
		// Only group config > Formation:
		if !_isVeh then { [_grpInfo] call THY_fnc_CSWR_group_formation };
		// Group/Vehicle config > Adding to ZEUS:
		if CSWR_isEditableByZeus then {
			{  // forEach allCurators:
				// Unit(s):
				_x addCuratorEditableObjects [units _grp, true];
				// Vehicle itself:
				if _isVeh then { _x addCuratorEditableObjects [[vehicle (leader _grp)], true] };
				// Breath:
				sleep 1;
			} forEach allCurators;
		};
		// Only helicopter config > Takeoff delay:
		if _isAirCrew then {
			// Wait a bit:
			_time = time + (random CSWR_heliTakeoffDelay); waitUntil { sleep 5; time > _time };
			// Debug message:
			if ( CSWR_isOnDebugGlobal && !CSWR_shouldHeliSpwnInAir ) then { systemChat format ["%1 %2 '%3' helicopter is TAKING OFF!", CSWR_txtDebugHeader, _tag, str _grp] };
		};
		// If Spawn was a Paradrop:
		if _isParadrop then {
			// If group of people:
			if !_isVeh then {
				// Wait the leader touch the ground:
				waitUntil { sleep 10; (getPos (leader _grp) # 2) < 0.2 || !alive leader _grp };
				// If the group has more than one unit alive:
				if ( {alive _x} count (units _grp) > 1 ) then {
					// Regroup with leader:
					{  // forEach units _grp:
						// If a group member gets unconscious:
						if ( incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then { 
							// Kills the unit:
							_x setDamage 1;
							// Debug message:
							if CSWR_isOnDebugGlobal then { systemChat format ["%1 PARADROP > A %2 '%3' gets unconscious. The CSWR kills them to preverse the group plans.", CSWR_txtDebugHeader, _tag, str _grp] };
						};
						// if leader:
						if ( _x isEqualTo (leader _grp) ) then {
							// If not civilian leader, it sets a military body position to wait group members:
							if ( _tag isNotEqualTo "CIV" ) then { _x setUnitPos "MIDDLE" };
						// Otherwise, if another group member:
						} else {
							// Wait the own unit (_x) touch the ground if not yet:
							waitUntil { sleep 3; (getPos _x # 2) < 0.2 || !alive _x };
							// Wait the parachute detchament animation gets finished:
							sleep 1;
							// Regroup at leader position:
							_x doFollow (leader _grp);
						};
					} forEach units _grp;
					// Wait the group members regroup for the first mission move after paradrop landing:
					waitUntil { sleep 10; (({alive _x} count units _grp) isEqualTo ({_x distance (leader _grp) < 30} count units _grp)) || isNull _grp || !alive (leader _grp) };
					// Restore the leader body position if they get "MIDDLE":
					leader _grp setUnitPos "UP";
				};
			// Otherwise, if vehicle:
			} else {
				// Paradrop things:
				[_tag, _veh, _grp] call THY_fnc_CSWR_veh_paradrop;
				// Time before the vehicle start to move right after the paradrop landing:
				_time = time + 5; waitUntil { sleep 1; time > _time };
			};
		};

		// WAYPOINTS SECTION:
		// Group/Vehicle config > Move:
		[_spwns, _destType, _tag, _grpType, _grp, _behavior, _isVeh, _isAirCrew] spawn THY_fnc_CSWR_go;

		// UNDO THE BOOKING:
		// if vehicle:
		if _isVeh then {
			// When the vehicle get distance from spawn or be destroyed (or for some reason the group leaves the vehicle and get distance by foot), stop the looping:
			waitUntil { sleep 5; isNull _grp || !alive _veh || _veh distance _spwnPos > _safeDis || (leader _grp) distance _spwnPos > _safeDis };
			// over the spawn-point, if the vehicle has been destroyed, or the crew has been killed, or the crew rampout leaving the vehicle, it deletes the wreck/vehicle and everything around it to avoid explosions:
			if ( !alive _veh || !alive (leader _grp) || isNull (objectParent (leader _grp)) ) then {
				// Delete everything in spawn position:
				{ deleteVehicle _x; sleep 0.1 } forEach (_spwnPos nearObjects _safeDis) + units _grp;
				// Debug message:
				if CSWR_isOnDebugGlobal then { systemChat format ["%1 BOOKING > A %2 vehicle (or its wreck) has been delete over a spawn-point to preserve the spawn integrity.", CSWR_txtDebugHeader, _tag, _spwn]	};
			};
			// If ground vehicle:
			if !_isAirCrew then {
				// Undo the spawn booking:
				["BOOKING_SPAWNVEH", _tag, _spwn, _isBooked] call THY_fnc_CSWR_marker_booking_undo;
				// Debug message:
				if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugBooking ) then { systemChat format ["%1 BOOKING_SPAWNVEH > %2 '%3' marker is free.", CSWR_txtDebugHeader, _tag, _spwn]; sleep 1};
			// Otherwise, if helicopter:
			} else {
				// Undo the spawn booking:
				["BOOKING_SPAWNHELI", _tag, _spwn, _isBooked] call THY_fnc_CSWR_marker_booking_undo;
				// Debug message:
				if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugBooking ) then { systemChat format ["%1 BOOKING_SPAWNHELI > %2 '%3' marker is free.", CSWR_txtDebugHeader, _tag, _spwn]; sleep 1};
			};
			
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_spawn_delay = {
	// This function verify what method of Spawn Delay the group/vehicle will execute.
	// Returns nothing.

	params ["_tag", "_spwnDelayMethods", "_isVeh", "_grpSize"];
	private ["_isReadyToSpwn", "_timeLoop", "_time", "_counter", "_wait", "_requester", "_txt1"];

	// Escape:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Initial values:
	_isReadyToSpwn = false;
	_timeLoop = 0;
	// Declarations:
	_time = time;
	_counter = _time;
	_wait = 10;  // CAUTION: this number is used to calcs the TIMER too.
	_requester = if _isVeh then {"vehicle"} else {"group"};
	
	// Debug texts:
	_txt1 = format ["A %1 %2 was granted TO SPAWN", _tag, _requester];

	// Spawn Delay conditions > Stay checking if the group ISN'T ready to spawn:
	while { !_isReadyToSpwn } do {
		_timeLoop = time;
		// Delay for each loop check:
		waitUntil { sleep _wait; time >= _timeLoop + _wait };
		// Escape:
			// reserved space.

		{  // forEach _spwnDelayMethods:
			// TIMER DELAY:
			// If Spawn Delay has a timer, check if it's a number:
			if ( typeName _x isEqualTo "SCALAR" ) then {
				// Counter increase:
				_counter = _counter + _wait;
				// Timer checker:
				if ( _counter >= _time + ((abs _x) * 60) ) exitWith {
					// Function completed:
					_isReadyToSpwn = true;
					// Debug message:
					if CSWR_isOnDebugGlobal then {
						systemChat format ["%1 SPAWN DELAY > %2 by TIMER (it was %3 minutes).", CSWR_txtDebugHeader, _txt1, _x];
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
	
	params ["_faction", ["_spwns", []], ["_grpClasses", []], ["_form", ""], ["_behavior", ""], ["_destType", ""], ["_spwnDelayMethods", 0]];
	private ["_tag", "_txt0", "_txt1", "_txt2", "_txt3", "_isValidClasses", "_isValidClassTypes", "_isValidBehavior", "_isThereDest", "_isValidForm", "_grpInfo"];
	
	// Initial values:
		// reserved space.
	// Declarations - part 1/2:
	_tag = [_faction] call THY_fnc_CSWR_convertion_faction_to_tag;
	// Debug texts:
	_txt0 = format ["IMPOSSIBLE TO SPAWN a %1 group in spawn-points from another faction. Check 'fn_CSWR_population.sqf' file and make sure all %1 group lines have the spawn-point assigned to 'CSWR_spwns%1'.", _tag];
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a group. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _tag];
	_txt2 = format ["%1 > At least one type of group configured in 'fn_CSWR_population.sqf' file HAS NO classname(s) declared for CSWR script get to know which unit(s) should be created. FIX IT!", _tag];
	_txt3 = "One or more groups have a typo/mispelling in the name of the faction they belong to. Check the 'fn_CSWR_population.sqf' file and fix it. The group WON'T be created.";
	// Escape - part 1/2:
	if ( typeName _spwns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( toUpper (_spwns # 0) find _tag == -1 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt0] call BIS_fnc_error; sleep 5 };
	if ( count _grpClasses == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	// Declarations - part 2/2:
	_isValidClasses = [_tag, "CfgVehicles", "unit", "_grpClasses", _grpClasses] call THY_fnc_CSWR_is_valid_classname;
	_isValidClassTypes = [_tag, _grpClasses, ["Man"], false] call THY_fnc_CSWR_is_valid_classnames_type;
	_isValidBehavior = [_tag, false, _behavior] call THY_fnc_CSWR_is_valid_behavior;
	_isThereDest = [_tag, false, _destType] call THY_fnc_CSWR_is_valid_destination;
	_isValidForm = [_tag, false, _form] call THY_fnc_CSWR_is_valid_formation;
	// Escape - part 2/2:
	if ( _tag isEqualTo "" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt3] call BIS_fnc_error; sleep 5 };
	if !_isValidClasses exitWith {};
	if !_isValidClassTypes exitWith {};
	if !_isValidBehavior exitWith {};
	if !_isThereDest exitWith {};
	if !_isValidForm exitWith {};
	// To check other escapes and errors handling based in _grpClasses):
	_grpInfo = [_faction, _tag, _grpClasses, _destType, _behavior, _form] call THY_fnc_CSWR_group_type_rules;
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
	
	params ["_faction", ["_spwns", []], ["_vehClass", ""], ["_behavior", ""], ["_destType", ""], ["_spwnDelayMethods", 0]];
	private ["_tag", "_isHeli", "_txt0", "_txt1", "_txt2", "_txt3", "_txt4", "_txt5", "_isValidClasses", "_isValidClassTypes", "_isValidBehavior", "_isThereDest", "_grpInfo"];
	
	// Initial values:
		// reserved space.
	// Declarations - part 1/2:
	_tag = [_faction] call THY_fnc_CSWR_convertion_faction_to_tag;
	_isHeli = if ( _vehClass isKindOf "Helicopter" ) then { true } else { false };
	// Debug texts:
	_txt0 = "For script integrity, the vehicle WON'T SPAWN!";
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a vehicle. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _tag];
	_txt2 = format ["%1 > A HELICOPTER HAS NO SPAWNPOINT. Add at least one SPAWN-MARKER for helicopters on Eden, e.g. 'cswr_spawnheli_%2_aNumber'.", _tag, toLower _tag];
	_txt3 = format ["%1 > At least one type of vehicle configured in 'fn_CSWR_population.sqf' file HAS NO classname declared for CSWR script get to know which vehicle should be created. FIX IT!", _tag];
	_txt4 = format ["IMPOSSIBLE TO SPAWN a %1 vehicle in spawn-points from another faction. Check 'fn_CSWR_population.sqf' file and make sure all %1 vehicle lines have the spawn-point assigned to 'CSWR_spwns%1' or 'CSWR_spwnsVeh%1' or 'CSWR_spwnsHeli%1'.", _tag];
	_txt5 = "One or more groups have a typo/mispelling in the name of the faction they belong to. Check the 'fn_CSWR_population.sqf' file and fix it. The group WON'T be created.";
	// Escape - part 1/2:
	if ( _tag isEqualTo "" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt5] call BIS_fnc_error; sleep 5 };
	if ( typeName _spwns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 && !_isHeli ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spwns == 0 && _isHeli ) exitWith { ["%1 %2 %3", CSWR_txtWarningHeader, _txt2, _txt0] call BIS_fnc_error; sleep 5 };
	if ( _vehClass isEqualTo "" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt3] call BIS_fnc_error; sleep 5 };
	// Declarations - part 2/2:
	_isValidClasses = [_tag, "CfgVehicles", "vehicle", "_vehClass", [_vehClass]] call THY_fnc_CSWR_is_valid_classname;
	_isValidClassTypes = [_tag, [_vehClass], ["Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "Helicopter"], true] call THY_fnc_CSWR_is_valid_classnames_type;
	_isValidBehavior = [_tag, true, _behavior] call THY_fnc_CSWR_is_valid_behavior;
	_isThereDest = [_tag, true, _destType] call THY_fnc_CSWR_is_valid_destination;
	// Escape - part 2/2:
	if !_isValidClasses exitWith {};
	if !_isValidClassTypes exitWith {};
	if !_isValidBehavior exitWith {};
	if !_isThereDest exitWith {};
	// To check other escapes and errors handling based in type of _vehClass:
	_grpInfo = [_faction, _tag, [_vehClass], _destType, _behavior, ""] call THY_fnc_CSWR_group_type_rules;
	// Escape > Invalid group:
	if ( _grpInfo isEqualTo [] ) exitWith {};
	// Spawn Schadule:
	[_spwns, _spwnDelayMethods, _grpInfo, true, _behavior, _destType] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breath:
	sleep 10;  // CRITICAL: helps to avoid veh colissions and explosions at beggining of the match. <10 = heavy veh can blow up in spawn. <5 = any veh can blow up in spawn.
	// Return:
	true;
};


THY_fnc_CSWR_go = {
	// This function select the type of movement the group/vehicle will execute in a row.
	// Returns nothing.

	params["_spwns", "_destType", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli"];
	//private["", "", ""];

	// Escape > if the group doesn't exist anymore, or its leader is dead, abort:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Escape > if it's vehicle and the vehicle is destroyed, abort:
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
		case "MOVE_OCCUPY":     { [_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY };  // Vehicles are not able to do this.
		case "MOVE_HOLD":       { [_tag, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD };  // Helicopters are not able to do this.
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
			_shouldRTB = [_grp, _areaToPass, _isHeli] call THY_fnc_CSWR_veh_condition;
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
	// Forcing to return and not re-engage:
	_grp setBehaviourStrong "CARELESS";  // WIP need to test more!
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
		((getPos _veh) # 2) < 0.2 || !alive _veh || isNull _grp;
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
	private ["_time", "_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Error handling:
	if ( _tag isEqualTo "CIV" ) exitWith { ["%1 MOVE ANYWHERE > Civilians CANNOT use '_move_ANY'. Please, fix it in 'fn_CSWR_population.sqf' file. For script integrity, the civilian group was deleted.", CSWR_txtWarningHeader] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Initial values:
	_time = 0;
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
	// Check if the group is already on their destination:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_ANY", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If ground vehicle or a group of people:
	if !_isHeli then {
		// waiting the group gets close enough of the waypoint position:
		waitUntil { sleep 10; leader _grp distance _areaToPass < random 30 || !alive (leader _grp) };
		// When there, cooldown:
		_time = time + (random CSWR_destCommonTakeabreak); 
		waitUntil { sleep 10; time > _time || !alive (leader _grp) };
	// Otherwise, if helicopter:
	} else {
		// waiting the heli gets close enough of the waypoint position:
		waitUntil { sleep 3; leader _grp distance _areaToPass < 200 || !alive (leader _grp) };
	};
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_ANYWHERE;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_PUBLIC = { 
	// This function sets the group/vehicle to move through PUBLIC destinations where civilians and soldiers can go, excluding the specialized (watch, hold, occupy) ones and the waypoints restricted by other factions. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli", "_shouldRTB"];
	private ["_time", "_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
	_time = 0;
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
	// Check if the group is already on their destination:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_PUBLIC", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If ground vehicle or a group of people:
	if !_isHeli then {
		// waiting the group gets close enough of the waypoint position:
		waitUntil { sleep 10; leader _grp distance _areaToPass < random 30 || !alive (leader _grp) };
		// When there, cooldown:
		_time = time + (random CSWR_destCommonTakeabreak);
		waitUntil { sleep 10; time > _time || !alive (leader _grp) };
	// Otherwise, if helicopter:
	} else {
		// waiting the heli gets close enough of the waypoint position:
		waitUntil { sleep 3; leader _grp distance _areaToPass < 200 || !alive (leader _grp) };
	};
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_dest_PUBLIC;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_RESTRICTED = { 
	// This function sets the group/vehicle to move only through the exclusive faction destinations, excluding public and specialized (watch, hold, occupy) ones. It's a looping.
	// Returns nothing.
	
	params ["_spwns", "_tag", "_grpType", "_grp", "_behavior", "_isVeh", "_isHeli", "_shouldRTB"];
	private ["_time", "_destMarkers", "_areaToPass","_wp", "_shouldRTB"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destMarkers = [];
	_time = 0;
	// Defining the group markers to be considered:
	switch _tag do {
		case "BLU": { _destMarkers = CSWR_destBLU };
		case "OPF": { _destMarkers = CSWR_destOPF };
		case "IND": { _destMarkers = CSWR_destIND };
		case "CIV": { _destMarkers = CSWR_destCIV };
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
	// Check if the group is already on their destination:
	_shouldRTB = [_grp, _areaToPass, _isVeh, _isHeli] call THY_fnc_CSWR_go_next_condition;
	// Return to base:
	if _shouldRTB exitWith { [_spwns, _tag, _grpType, _grp, _isHeli, "MOVE_RESTRICTED", _behavior] spawn THY_fnc_CSWR_go_RTB };
	// Next planned move cooldown:
	// If ground vehicle or a group of people:
	if !_isHeli then {
		// waiting the group gets close enough of the waypoint position:
		waitUntil { sleep 10; leader _grp distance _areaToPass < random 30 || !alive (leader _grp) };
		// When there, cooldown:
		_time = time + (random CSWR_destCommonTakeabreak);
		waitUntil { sleep 10; time > _time || !alive (leader _grp) };
	// Otherwise, if helicopter:
	} else {
		// waiting the heli gets close enough of the waypoint position:
		waitUntil { sleep 3; leader _grp distance _areaToPass < 200 || !alive (leader _grp) };
	};
	// Restart the movement:
	[_spwns, _tag, _grpType, _grp, _behavior, _isVeh, _isHeli, _shouldRTB] spawn THY_fnc_CSWR_go_dest_RESTRICTED;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_WATCH = { 
	// This function sets the group to move only through the high natural spots destinations and stay there for as long the mission runs, watching around quiet, perfect for snipers and marksmen groups. It's NOT a looping.
	// Returns nothing.
	
	params ["_tag", "_grpType", "_grp", "_behavior"];
	private ["_destMarkers", "_areaPos", "_locationPos", "_obj", "_disLocToArea", "_counter", "_attemptLimit", "_bookingInfo", "_location", "_isBooked", "_roadsAround", "_mkrDebugWatch", "_wait", "_areaToWatch", "_locations", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Errors handling:
	if ( _grpType isNotEqualTo "teamS" ) exitWith { ["%1 WATCH > A non-sniper-group tried to use the '_move_WATCH'. Please, fix it in 'fn_CSWR_population.sqf' file. For script integrity, the group was deleted.", CSWR_txtWarningHeader] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	if ( side (leader _grp) isEqualTo CIVILIAN ) exitWith { ["%1 WATCH > Civilians CANNOT use Watch-Destinations. Please, fix it in 'fn_CSWR_population.sqf' file. For script integrity, the civilian group was deleted.", CSWR_txtWarningHeader] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Initial values:
	_destMarkers = [];
	_areaPos = [];
	_locationPos = [];
	_obj = objNull;
	_disLocToArea = nil;
	_counter = 0;
	_attemptLimit = 5;
	_bookingInfo = [];
	_location = nil;
	_isBooked = false;
	_roadsAround = [];
	_mkrDebugWatch = "";  // Debug purposes.
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, false] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, false] call THY_fnc_CSWR_unit_behavior;
	// Declarations:
	_wait = 10;
	// Defining the group markers to be considered:
	switch _tag do {
		case "BLU": { _destMarkers = CSWR_destWatchBLU };
		case "OPF": { _destMarkers = CSWR_destWatchOPF };
		case "IND": { _destMarkers = CSWR_destWatchIND };
		case "CIV": { _destMarkers = CSWR_destWatchCIV };
	};
	// Check the available WATCH faction markers on map:
	_areaToWatch = markerPos (selectRandom _destMarkers);
	// Finding out specific types of locations around:
	_locations = nearestLocations [_areaToWatch, ["RockArea", "Hill", "ViewPoint", "Flag"], CSWR_watchMarkerRange];
	// If found at least one location:
	if ( count _locations isNotEqualTo 0 ) then {
		// Debug watch-markers:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
			{  // forEach _locations:
				// Show me all locations found on the map with visible markers:
				_mkrDebugWatch = createMarker ["debug_" + str _x, locationPosition _x];
				_mkrDebugWatch setMarkerType "hd_dot";
				switch _tag do {
					case "BLU": { 
						_mkrDebugWatch setMarkerAlpha 0.7;
						_mkrDebugWatch setMarkerColor "colorBLUFOR";
						_mkrDebugWatch setMarkerText "BLU sniper pos";
						_mkrDebugWatch setMarkerPos [(locationPosition _x # 0) + 10, locationPosition _x # 1, 0];
					};
					case "OPF": {
						_mkrDebugWatch setMarkerAlpha 0.7;
						_mkrDebugWatch setMarkerColor "colorOPFOR";
						_mkrDebugWatch setMarkerText "OPF sniper pos";
						_mkrDebugWatch setMarkerPos [locationPosition _x # 0, (locationPosition _x # 1) + 10, 0];
					};
					case "IND": {
						_mkrDebugWatch setMarkerAlpha 0.7;
						_mkrDebugWatch setMarkerColor "colorIndependent";
						_mkrDebugWatch setMarkerText "IND sniper pos";
						_mkrDebugWatch setMarkerPos [(locationPosition _x # 0) - 10, locationPosition _x # 1, 0];
					};
					//case "CIV": {}; // not appliable here!
				};
			} forEach _locations;
		};
		
		// BOOKING A LOCATION:
		// Looping to booking (mandatory in Watch) a location:
		while { !isNull _grp && _counter <= _attemptLimit } do {
			// Counter to prevent crazy loops:
			_counter = _counter + 1;
			// Try to booking a marker:
			_bookingInfo = ["BOOKING_WATCH", getPos (leader _grp), _tag, _locations, 10, 3] call THY_fnc_CSWR_marker_booking;
			// Which marker to go:
			_location = _bookingInfo # 0;  // return a location in this format: "Location Hill at 3999, 7028"
			// Marker position:
			_locationPos = _bookingInfo # 1;  // [x,y,z]
			// Is booked?
			_isBooked = _bookingInfo # 2;
			// If not booked:
			if !_isBooked then {
				// Debug message:
				if (CSWR_isOnDebugGlobal && _counter <= _attemptLimit ) then {
					["%1 WATCH > %2 '%3' sniper group selected a location already booked for another group. Next try soon...", CSWR_txtDebugHeader, _tag, str _grp] call BIS_fnc_error;
				};
				// CPU breath to prevent craze loopings:
				sleep _wait;
			// Otherwise, it's booked:
			} else { 
				// Clean counter:
				_counter = 0;
				// Stop the loop:
				break;
			};
		};  // While-loop ends.
		// Error handling:
		if ( _counter > _attemptLimit ) exitWith {
			// Delete the sniper group:
			{ deleteVehicle _x } forEach units _grp;
			// Warning message:
			["%1 WATCH > All locations found by %2 watch-markers look already watched. A sniper group without watch-marker was deleted. CONSIDER TO ADD more watch-markers OR TO REMOVE a %2 sniper group in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error; sleep 5;
		};
	
		// SETTING A POSITION:
		// If booked:
		if _isBooked then {
			// Creating a generic asset on-the map to provide an object (and, next, check its position):
			_obj = createSimpleObject ["Land_Canteen_F", _locationPos, false];  // false = global / true = local.
			// Figuring out the distance between the location found (a hill peak, for example) and the area-target to watch:
			_disLocToArea = _obj distance _areaToWatch;
			// Delete the asset used as reference:
			deleteVehicle _obj;
			// Looping to find a good spot in selected location > if the group still exists:
			while { !isNull _grp } do {
				// Counter to prevent crazy loops:
				_counter = _counter + 1;
				// Finding a empty spot based on selected location position. 10m from _pos but not further 100m, not closer 4m to other obj, not in water, max gradient 0.7, not on shoreline:
				_areaPos = [_locationPos, 10, 100, 4, 0, 0.7, 0] call BIS_fnc_findSafePos;  // https://community.bistudio.com/wiki/BIS_fnc_findSafePos
				// Check if there's road around the sniper spot:
				_roadsAround = _areaPos nearRoads 20;  // meters
				// WIP: trying to identify if there's a terrain between the sniper eyes and the area-target:
				//private _isTerrainBlockingView = terrainIntersect [_areaPos, _areaToWatch];  // High cost for Engine/server (info from wiki);
				// If the spot is within target range and there's No any road too close, it potencialy is a good spot:
				if ( _areaPos distance _areaToWatch <= _disLocToArea /* && (!isOnRoad _areaPos) */ && count _roadsAround == 0 /* && (!_isTerrainBlockingView) */ ) then { break };
				// Warning message:
				if ( _counter > 20 ) then {
					// Restart the counter:
					_counter = 0;
					// Message:
					if CSWR_isOnDebugGlobal then { ["%1 WATCH > %2 '%3' group has no good spot. Next try soon...", CSWR_txtDebugHeader, _tag, str _grp] call BIS_fnc_error };
					// A good additional cooldown for Server CPU:
					sleep _wait;
				};
				// CPU breath to prevent craze loopings:
				sleep 1;
			};  // While-loop ends.
			// Debug message:
			if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %3 location(s) found, %2 '%4' moving: %5.", CSWR_txtDebugHeader, _tag, count _locations, str _grp, _location] };
		};
	// If didn't find even one location:
	} else {
		// Delete the sniper group:
		{ deleteVehicle _x } forEach units _grp;
		// Warning message:
		["%1 WATCH > A %2 WATCH-MARKER (%3) looks has no natural high locations to scan around. Change its position! A sniper group was deleted!", CSWR_txtWarningHeader, _tag, str _areaToWatch] call BIS_fnc_error;
	};
	// Escape:
	if ( isNull _grp || _areaPos isEqualTo [] ) exitWith { ["BOOKING_WATCH", _tag, _location, _isBooked] call THY_fnc_CSWR_marker_booking_undo };

	// WAYPOINT AND GO:
	_wp = _grp addWaypoint [_areaPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCombatMode "WHITE";  // Important: forcing this for snipers out of their watch location // hold fire, kill only if own position spotted.
	_grp setCurrentWaypoint _wp;
	// Debug message:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
		{  // forEach units _grp:
			["%1 WATCH > %2 '%3' unit has their: aimingAccuracy = %4 | spotDistance = %5 | aimingSpeed = %6 | endurance = %7", CSWR_txtDebugHeader, _tag, str _x, (_x skill "aimingAccuracy"), (_x skill "spotDistance"), (_x skill "aimingSpeed"), (_x skill "endurance")] call BIS_fnc_error; sleep 5;
		} forEach units _grp;
	};
	// Wait the sniper group gets closer:
	waitUntil {sleep 5; isNull _grp || leader _grp distance _areaPos < 100 };
	// Escape:
	if ( isNull _grp ) exitWith { 
		// undo the booking:
		["BOOKING_WATCH", _tag, _location, _isBooked] call THY_fnc_CSWR_marker_booking_undo;
		// Debug message:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
			systemChat format ["%1 WATCH > A few moments earlier, a %2 sniper group HAS BEEN KILLED (or deleted) BEFORE to reach 100m close to set their watching.", CSWR_txtDebugHeader, _tag];
		};
	};
	// From here, keep stealth to make sure the spot is clear:
	_grp setBehaviourStrong "STEALTH";  // Every unit in the group, and the group itself.
	_grp setSpeedMode "LIMITED";
	{  // forEach units _grp:
		// Prone:
		_x setUnitPos "DOWN";
		// Dont speak anymore:
		_x setSpeaker "NoVoice";
	} forEach units _grp;
	// Wait the sniper group arrival in the area for to stay watching the marker direction:
	waitUntil { sleep 5; isNull _grp || leader _grp distance _areaPos < 3 };
	// Escape:
	if ( isNull _grp ) exitWith {
		// undo the booking:
		["BOOKING_WATCH", _tag, _location, _isBooked] call THY_fnc_CSWR_marker_booking_undo;
		// Debug message:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
			systemChat format ["%1 WATCH > A few moments earlier, a %2 sniper group HAS BEEN KILLED (or deleted) almost in their watching position.", CSWR_txtDebugHeader, _tag];
		};
	};
	// Make the arrival smooth:
	sleep 1;
	// Go to the next WATCH stage:
	[_grp, _areaToWatch, _behavior, _tag] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
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
	{  // forEach units _grp;:
		// If member is the SNIPER:
		if ( _x isEqualTo (leader _grp) ) then {
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
			waitUntil { sleep 3; speed _x isEqualTo 0 || !alive _x };
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
		{  // forEach units _grp;:
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
		{  // forEach units _grp;:
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
	
	params ["_tag", "_grp", "_behavior"];
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
	switch _tag do {
		case "BLU": { _destMarkers = CSWR_destOccupyBLU };
		case "OPF": { _destMarkers = CSWR_destOccupyOPF };
		case "IND": { _destMarkers = CSWR_destOccupyIND };
		case "CIV": { _destMarkers = CSWR_destOccupyCIV };
	};
	// Check the available OCCUPY faction markers on map:
	_regionToSearch = markerPos (selectRandom _destMarkers);
	// Selecting one building from probably many others found in that range:
	_building = [_grp, _tag] call THY_fnc_CSWR_OCCUPY_find_buildings_by_group;  // return object.
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
					_grpLead setDamage 1;
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
						[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
						// Stop the while-looping:
						break;
					};
				};
				// if group leader is close enough to the chosen building:
				if ( _grpLead distance _bldgPos < _distLimiterFromBldg ) then {
					// When there, execute the occupy function:
					[_building, _bldgPos, _grp, _tag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetIn;
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
					[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
						[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
			[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
		};
	// If a building is NOT found:
	} else {
		// Delete the group:
		//{ deleteVehicle _x } forEach units _grp;  // Dont delete the group coz maybe all buildings are destroyed during the game.
		// Warning message:
		["%1 OCCUPY > A %2 OCCUPY marker looks not close enough to buildins, or all buildings around are destroyed, or the marker has no a good range configured in fn_CSWR_management.sqf ('CSWR_occupyMarkerRange'). A %2 group will stand still in its current position.", CSWR_txtWarningHeader, _tag] call BIS_fnc_error;
		// Breath:
		sleep _wait;
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

	params ["_grp", "_tag"];
	private ["_bldgsAvailable", "_bldgsStillExist", "_building"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_bldgsAvailable = [];
	_building = objNull;
	// Declarations:
	switch _tag do {
		case "BLU": { _bldgsAvailable = CSWR_bldgsAvailableBLU };
		case "OPF": { _bldgsAvailable = CSWR_bldgsAvailableOPF };
		case "IND": { _bldgsAvailable = CSWR_bldgsAvailableIND };
		case "CIV": { _bldgsAvailable = CSWR_bldgsAvailableCIV };
	};
	// Select only the buildings that were not destroyed yet or those ones included as exception (like specific ruins):
	_bldgsStillExist = _bldgsAvailable select { alive _x || typeOf _x in CSWR_occupyAcceptableRuins };
	// Error handling:
	If ( count _bldgsStillExist isEqualTo 0 ) exitWith { 
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
	// This function removes a specific unit left behind, and set them to a new group that's abled to execute also the occupy-movement by itself.
	// Returns nothing.

	params ["_unit", "_tag", "_behavior", "_wait"];
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
	[_tag, _newGrp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
	_nearEnemies = _nearUnits select { side _unit isNotEqualTo side _x && side _unit isNotEqualTo CIVILIAN && alive _x && incapacitatedState _x isNotEqualTo "UNCONSCIOUS" };
	if ( count _nearEnemies > 0 ) then { _isEnemyClose = true };
	// Return:
	_isEnemyClose;
};


THY_fnc_CSWR_OCCUPY_doGetIn = {
	// This function will try to make the group get inside the chosen building to occupy it.
	// Returns nothing.

	params ["_building", "_bldgPos", "_grp", "_tag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_wait"];
	private ["_spots", "_spot", "_isFriendPlayerClose", "_isEnemyClose", "_timeOutToUnit", "_canTeleport", "_alreadySheltered", "_orderCounter", "_time", "_grpSize", "_compass"];

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
	_time = 0;
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
						_x setDamage 1;
						// Stop the while-looping:
						break;
					};
					// if group leader is close enough to the chosen building:
					if ( _x distance _building < _distLimiterFromBldg + 2 ) then {
						// Figure out if the selected building has enough spots for current group size:
						_spots = [_building, _grpSize] call BIS_fnc_buildingPositions;
						// For script integrity, check again right after the arrival if there are enough spots to the whole group:
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
									[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
								waitUntil { sleep 1; moveToCompleted _x || moveToFailed _x || !alive _x };
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
							[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
						_x setDamage 1;
						// Stop the while-looping:
						break;
					};
					// if the unit is too far away from the leader:
					if ( _x distance leader _grp > 120 ) then {
						// Remove the unit from the current group:
						[_x, _tag, _behavior, _wait] spawn THY_fnc_CSWR_OCCUPY_remove_unit_from_group;
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
							waitUntil { sleep 1; moveToCompleted _x || moveToFailed _x || !alive _x };
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
					_x setDamage 1;
					// Debug message:
					if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > A %2 unit needed to be killed to preserve the game integrity (they lost the group ID).", CSWR_txtDebugHeader, _tag]};
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
			_time = time + (random CSWR_destOccupyTakeabreak); waitUntil { sleep 60; time > _time };
		// Otherwise:
		} else {
			// Debug message:
			if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' leader would rather move to another building.", CSWR_txtDebugHeader, _tag, str _grp]; sleep 3 };
		};
		// Starts the last stage of OCCUPY function:
		[_grp, _tag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _bldgPos, _wait] spawn THY_fnc_CSWR_OCCUPY_doGetOut;
	// If a building is NOT found:
	} else {
		// Warning message:
		["%1 %2 > OCCUPY > The building doesn't exist anymore. New search in %4 secs.", CSWR_txtWarningHeader, _tag, str _grp, _wait] call BIS_fnc_error; sleep 5;
		// Restart the first OCCUPY step:
		[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_doGetOut = {
	// This function is the last stage of Occupy function where it removes the group from inside the occupied building.
	// Returns nothing.

	params ["_grp", "_tag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_bldgPos", "_wait"];
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
					_x setDamage 1;
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
	[_tag, _grp, _behavior] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_HOLD = { 
	// This function sets the group to arrive in a place and make it doesn't move to another place for a long time. It's a looping.
	// Returns nothing.
	
	params ["_tag", "_grp", "_behavior", "_isVeh"];
	private ["_destMarkers", "_isVehTracked", "_bookingInfo", "_areaToHold", "_isBooked", "_areaPos", "_wp", "_time", "_counter", "_trackedVehTypes", "_vehType", "_wpDisLimit", "_wait", "_waitForVeh"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destMarkers = [];
	_isVehTracked = false;
	_bookingInfo = [];
	_areaToHold = "";
	_isBooked = false;
	_areaPos = [];
	_wp = [];
	_time = 0;
	_counter = 0;
	_trackedVehTypes = [];
	_vehType = "";
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior, _isVeh] call THY_fnc_CSWR_unit_behavior;
	// Declarations:
	_wpDisLimit = 20;  // Critical - from 19m, the risk of the vehicle doesn't reach the waypoint is too high.
	_wait = 10;
	_waitForVeh = 0.25;
	// Defining the group markers to be considered:
	switch _tag do {
		case "BLU": { _destMarkers = CSWR_destHoldBLU };
		case "OPF": { _destMarkers = CSWR_destHoldOPF };
		case "IND": { _destMarkers = CSWR_destHoldIND };
		case "CIV": { _destMarkers = CSWR_destHoldCIV };
	};
	// Check if it's a vehicle and which kind of them:
	if _isVeh then {
		_trackedVehTypes = ["Tank", "TrackedAPC"];
		_vehType = ((vehicle (leader _grp)) call BIS_fnc_objectType) # 1;  // Returns like ['vehicle','Tank']
		// It's a tracked vehicle:
		if ( _vehType in _trackedVehTypes ) then { _isVehTracked = true };  // WIP the reason of this is, in future, only tracked veh will execute the turn maneuver over its axis, without setDir cheat like nowadays.
	};
	// Debug message:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugHold ) then {
		systemChat format ["%1 HOLD > %2 '%3' is a %4. %5", CSWR_txtDebugHeader, _tag, str _grp, if _isVeh then {"'"+_vehType+"'"} else {"group"}, if _isVehTracked then {""} else {"Only tracked vehicles can take the center pos of hold-markers."}];
	};

	// BOOKING A HOLD MARKER:
	// if tracked vehicle:
	if _isVehTracked then { 
		// Try to booking a marker:
		_bookingInfo = ["BOOKING_HOLD", getPos (leader _grp), _tag, _destMarkers, 5, _waitForVeh] call THY_fnc_CSWR_marker_booking;
		// Which marker to go:
		_areaToHold = _bookingInfo # 0;
		// Marker position:
		_areaPos = _bookingInfo # 1;  // [x,y,z]
		// Is booked?
		_isBooked = _bookingInfo # 2;
		// Debug message:
		if ( CSWR_isOnDebugGlobal && !_isBooked ) then {
			systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle tried but failed to booking a HOLD-MARKER center. Moving to a secondary position.", CSWR_txtDebugHeader, _tag, str _grp];
		};
	// If group or non-tracked-vehicle:
	} else {
		// Selecting a hold-marker:
		_areaToHold = selectRandom _destMarkers;
	};

	// SETTING A POSITION:
	// If booked:
	if _isBooked then {
		// Reserved space.
	// If not booked (people and non-tracked-vehicle never will booking, including tracked-vehicle that didn't find a hold-marker free):
	} else {
		// Looping to find a good spot in selected marker > if the group still exists:
		while { !isNull _grp } do {
			// Counter to prevent crazy loops:
			_counter = _counter + 1;
			// Find pos min 0m from center (_areaToHold) but not further 30m, not closer 3m to other obj, not in water, max gradient 0.7, no (0) on shoreline:
			_areaPos = [markerPos _areaToHold, 20, 30, 3, 0, 0.7, 0] call BIS_fnc_findSafePos;  // https://community.bistudio.com/wiki/BIS_fnc_findSafePos
			// if troops are not over a road, good position and stop the while-loop:
			if ( !isOnRoad _areaPos ) then { break };
			// Warning message:
			if ( _counter > 5 ) then {
				// Restart the counter:
				_counter = 0;
				// Message:
				if CSWR_isOnDebugGlobal then { ["%1 HOLD > Looks %2 '%3' ISN'T finding a save spot to maneuver in '%4' position. They keep trying...", CSWR_txtWarningHeader, _tag, str _grp, _areaToHold] call BIS_fnc_error };
			};
			// Cooldown to prevent crazy loops:
			if _isVeh then { sleep _waitForVeh } else { sleep _wait };
		};  // While-loop ends.
	};
	
	// WAYPOINT AND GO:
	_wp = _grp addWaypoint [_areaPos, 0]; 
	_wp setWaypointType "HOLD";
	_grp setCurrentWaypoint _wp;
	// If infantry/people:
	if !_isVeh then {
		// Check if the group is already on their destination:
		waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _areaPos < 2 };
	// Otherwise, if vehicle:
	} else {
		// Wait 'til getting really closer:
		waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _areaPos < (_wpDisLimit + 30) || !alive (vehicle (leader _grp)) };
		// if crew still in vehicle:
		if ( !isNull (objectParent leader _grp) ) then {
			// it forces the crew order to drive as closer as possible the waypoint:
			leader _grp doMove _areaPos;
		};
		// Wait 'til the vehicle is over the waypoint:
		waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _areaPos < _wpDisLimit || !alive (vehicle (leader _grp)) };
	};
	// Escape:
	if ( isNull _grp || !alive (vehicle (leader _grp)) ) exitWith { ["BOOKING_HOLD", _tag, _areaToHold, _isBooked] call THY_fnc_CSWR_marker_booking_undo };

	// ARRIVAL IN MARKER POSITION:
	// If vehicle:
	if _isVeh then {
		// The function accepts only trached vehicle to adjust the vehicle direction:
		[_areaToHold, _grp, _tag, _isVehTracked] call THY_fnc_CSWR_HOLD_tracked_vehicle_direction;
		// If editors choice was stealth all vehicles on hold, do it:
		if CSWR_isHoldVehLightsOff then { _grp setBehaviourStrong "STEALTH" };
	// Otherwise, if infantry/people:
	} else {
		// Group always will change the formation for this (aesthetically better):
		_wp setWaypointFormation "DIAMOND";
	};
	// Next planned move cooldown:
	_time = time + (random CSWR_destHoldTakeabreak); 
	waitUntil { sleep _wait; time > _time || isNull _grp || !alive (vehicle (leader _grp)) };
	
	// UNDO IF BOOKED:
	["BOOKING_HOLD", _tag, _areaToHold, _isBooked] call THY_fnc_CSWR_marker_booking_undo;
	
	// RESTART THE MOVEMENT:
	[_tag, _grp, _behavior, _isVeh] spawn THY_fnc_CSWR_go_dest_HOLD;
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

	params ["_mkr", "_grp", "_tag", "_isVehTracked"];
	private ["_blockers", "_attemptCounter", "_attemptLimiter", "_veh", "_directionToHold", "_vehPos"];
	
	// Escape:
	if !_isVehTracked exitWith {};
	// Initial values:
	_blockers = [];
	_attemptCounter = 0;
	// Declarations:
	_attemptLimiter = 5;
	_veh = vehicle (leader _grp);
	_directionToHold = markerDir _mkr; 
	// Force the vehicle stop before get the hold-direction:
	_veh sendSimpleCommand "STOP";
	// Wait the vehicle to brake:
	waitUntil { sleep 2; speed _veh <= 0.1 };
	// Check if there is some blocker around the vehicle. A simple unit around can make a tank get to fly like a rocket if too much close during the setDir command:
	while { alive _veh && _attemptCounter < _attemptLimiter } do {
		// Check if something relevant is blocking the Hold-marker position:
		_blockers = (getPos _veh) nearEntities [["Man", "Car", "Motorcycle", "Tank", "WheeledAPC", "TrackedAPC", "UAV", "Helicopter", "Plane"], 10];
		// Removing the group vehicle itself from the calc as blocker:
		_blockers deleteAt (_blockers find _veh);
		// If no blockers, leave the verification loop:
		if ( count _blockers isEqualTo 0 ) then { break };
		// Counter to avoid crazy loopings:
		_attemptCounter = _attemptCounter + 1;
		// Debug:
		if CSWR_isOnDebugGlobal then {
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
	_vehPos = getPosATL _veh;
	_veh setPosATL [_vehPos # 0, _vehPos # 1, (_vehPos # 2) + 1 ];  // This will lift the veh so, when redirected, it'll avoid wavy grounds that would cause the veh to bounce.
	[_veh, _directionToHold] remoteExec ["setDir"];
	// Debug:
	if CSWR_isOnDebugGlobal then {
		// Breath to make sure the vehicle already in the new position before the debug message "getDir" calc:
		sleep 5;
		// Debug message:
		systemChat format ["%1 HOLD > %2 '%3' tracked-vehicle ready in hold-position [Desired direction: %4º | Executed: %5º].", CSWR_txtDebugHeader, _tag, str _grp, _directionToHold, getDir _veh];
	};
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
