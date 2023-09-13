// CSWR v4.5
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------


// STRUCTURE OF A FUNCTION BY THY:
/* THY_fnc_CSWR_name_of_the_function = {
	// This function <doc string>.
	// Return nothing <or varname + type>

	params["", "", "", ""];
	private["", "", ""];

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
	// Return _isValidMkr: bool.

	params ["_mkr"];
	private ["_isValidMkr", "_mkrPos", "_mkrPosA", "_mkrPosB", "_txt1"];

	// Initial values:
	_isValidMkr = false;
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
		_mkrPos = getMarkerPos _mkr;
		_mkrPosA = _mkrPos # 0;
		_mkrPosB = _mkrPos # 1;
		// Check if the marker is out of the map edges:
		if ( (_mkrPosA >= 0) && (_mkrPosB >= 0) && (_mkrPosA <= worldSize) && (_mkrPosB <= worldSize) ) then {
			// Update to return:
			_isValidMkr = true;
		// Otherwise, if not on map area:
		} else {
			// Warning message:
			["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
		};
	};
	// Return:
	_isValidMkr;
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
	_spwnTypes = ["SPAWN", "SPAWNVEH"];
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
	if ( (count _mkrNameStructure) == 4 ) then { _index = 3 };  // it's needed because marker names can have 4 or 5 sections (edited: not anymore), depends if the xxxxxxxxx tag is been used.
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
	private ["_spwnsBLU", "_spwnsVehBLU", "_spwnsOPF", "_spwnsVehOPF", "_spwnsIND", "_spwnsVehIND", "_spwnsCIV", "_spwnsVehCIV", "_destsMoveBLU", "_destsWatchBLU", "_destsOccupyBLU", "_destsHoldBLU", "_destsMoveOPF", "_destsWatchOPF", "_destsOccupyOPF", "_destsHoldOPF", "_destsMoveIND", "_destsWatchIND", "_destsOccupyIND", "_destsHoldIND", "_destsMoveCIV", "_destsWatchCIV", "_destsOccupyCIV", "_destsHoldCIV", "_destsMovePUBLIC", "_confirmedMarkers", "_spwns", "_spwnsVeh", "_isValidMkr", "_mkrType", "_mkrOwner", "_isNumber", "_realPrefix", "_txt0", "_txt1", "_possibleMarkers", "_mkrNameStructure"];

	// Initial values:
	_spwnsBLU=[]; _spwnsVehBLU=[];
	_spwnsOPF=[]; _spwnsVehOPF=[];
	_spwnsIND=[]; _spwnsVehIND=[];
	_spwnsCIV=[]; _spwnsVehCIV=[];
	_destsMoveBLU=[]; _destsWatchBLU=[]; _destsOccupyBLU=[]; _destsHoldBLU=[];
	_destsMoveOPF=[]; _destsWatchOPF=[]; _destsOccupyOPF=[]; _destsHoldOPF=[];
	_destsMoveIND=[]; _destsWatchIND=[]; _destsOccupyIND=[]; _destsHoldIND=[];
	_destsMoveCIV=[]; _destsWatchCIV=[]; _destsOccupyCIV=[]; _destsHoldCIV=[];
	_destsMovePUBLIC=[];
	_confirmedMarkers = [
		[
			[_spwnsBLU, _spwnsVehBLU],
			[_spwnsOPF, _spwnsVehOPF],
			[_spwnsIND, _spwnsVehIND],
			[_spwnsCIV, _spwnsVehCIV]
		], 
		[
			[_destsMoveBLU, _destsWatchBLU, _destsOccupyBLU, _destsHoldBLU],
			[_destsMoveOPF, _destsWatchOPF, _destsOccupyOPF, _destsHoldOPF],
			[_destsMoveIND, _destsWatchIND, _destsOccupyIND, _destsHoldIND],
			[_destsMoveCIV, _destsWatchCIV, _destsOccupyCIV, _destsHoldCIV],
			[_destsMovePUBLIC]
		]
	];
	_spwns = 0;
	_spwnsVeh = 0;
	_isValidMkr = false;
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
		_isValidMkr = [_x] call THY_fnc_CSWR_marker_checker;
		// If something wrong, remove the marker from the list and from the map:
		if ( !_isValidMkr ) then {
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
			// Case example: cswr_move_blu_1
			case "MOVE": {
				// Check if there is a valid owner tag:
				_mkrOwner = [_mkrNameStructure, _x, _prefix, _spacer, false] call THY_fnc_CSWR_marker_name_section_owner;  // if owner not valid, returns "", otherwise it returns the owner tag.
				// Check if the last section of the area marker name is numeric:
				_isNumber = [_mkrNameStructure, _x, _prefix, _spacer] call THY_fnc_CSWR_marker_name_section_number;
				// If all validations alright:
				if ( _mkrType isNotEqualTo "" && _isNumber ) then {
					switch _mkrOwner do {
						case "BLU": { _destsMoveBLU pushBack _x };
						case "OPF": { _destsMoveOPF pushBack _x };
						case "IND": { _destsMoveIND pushBack _x };
						case "CIV": { _destsMoveCIV pushBack _x };
						case "PUBLIC": { _destsMovePUBLIC pushBack _x };
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
						case "BLU": { _destsWatchBLU pushBack _x };
						case "OPF": { _destsWatchOPF pushBack _x };
						case "IND": { _destsWatchIND pushBack _x };
						case "CIV": { _destsWatchCIV pushBack _x };
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
						case "BLU": { _destsOccupyBLU pushBack _x };
						case "OPF": { _destsOccupyOPF pushBack _x };
						case "IND": { _destsOccupyIND pushBack _x };
						case "CIV": { _destsOccupyCIV pushBack _x };
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
						case "BLU": { _destsHoldBLU pushBack _x };
						case "OPF": { _destsHoldOPF pushBack _x };
						case "IND": { _destsHoldIND pushBack _x };
						case "CIV": { _destsHoldCIV pushBack _x };
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
			[_spwnsBLU, _spwnsVehBLU],
			[_spwnsOPF, _spwnsVehOPF],
			[_spwnsIND, _spwnsVehIND],
			[_spwnsCIV, _spwnsVehCIV]
		], 
		[
			[_destsMoveBLU, _destsWatchBLU, _destsOccupyBLU, _destsHoldBLU],
			[_destsMoveOPF, _destsWatchOPF, _destsOccupyOPF, _destsHoldOPF],
			[_destsMoveIND, _destsWatchIND, _destsOccupyIND, _destsHoldIND],
			[_destsMoveCIV, _destsWatchCIV, _destsOccupyCIV, _destsHoldCIV],
			[_destsMovePUBLIC]
		]
	];
	// By actived faction, check if there is, at least, one spawn mark available:
	if CSWR_isOnBLU then {
		// Defining amount of _spwns + _spwnsVeh of the faction:
		_spwns    = count (((_confirmedMarkers # 0) # 0) # 0);
		_spwnsVeh = count (((_confirmedMarkers # 0) # 0) # 1);
		if ( _spwns + _spwnsVeh == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO BLU SPAWN FOUND. Check the documentation or turn 'CSWR_isOnBLU' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnOPF then {
		// Defining amount of _spwns + _spwnsVeh of the faction:
		_spwns    = count (((_confirmedMarkers # 0) # 1) # 0);
		_spwnsVeh = count (((_confirmedMarkers # 0) # 1) # 1);
		if ( _spwns + _spwnsVeh == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO OPF SPAWN FOUND. Check the documentation or turn 'CSWR_isOnOPF' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnIND then {
		// Defining amount of _spwns + _spwnsVeh of the faction:
		_spwns    = count (((_confirmedMarkers # 0) # 2) # 0);
		_spwnsVeh = count (((_confirmedMarkers # 0) # 2) # 1);
		if ( _spwns + _spwnsVeh == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO IND SPAWN FOUND. Check the documentation or turn 'CSWR_isOnIND' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	if CSWR_isOnCIV then {
		// Defining amount of _spwns + _spwnsVeh of the faction:
		_spwns    = count (((_confirmedMarkers # 0) # 3) # 0);
		_spwnsVeh = count (((_confirmedMarkers # 0) # 3) # 1);
		if ( _spwns + _spwnsVeh == 0 ) then {
			// Warning message:
			systemChat format ["%1 NO CIV SPAWN FOUND. Check the documentation or turn 'CSWR_isOnCIV' to 'false' in 'fn_CSWR_management.sqf' file!", CSWR_txtWarningHeader];
		};
	};
	// Return:
	_confirmedMarkers;
};


THY_fnc_CSWR_convertion_faction_to_owner_tag = {
	// This function converts the faction name to the owner tag for further validations.
	// Returns _ownerTag: string of faction abbreviation.

	params ["_faction"];
	private ["_ownerTag"];

	// Initial values:
	_ownerTag = "";
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
		case BLUFOR:      { _ownerTag = "BLU" };
		case OPFOR:       { _ownerTag = "OPF" };
		case INDEPENDENT: { _ownerTag = "IND" };
		case CIVILIAN:    { _ownerTag = "CIV" };
		// In here PUBLIC is not applied.
	};
	// Return:
	_ownerTag;
};


THY_fnc_CSWR_population_behavior = {
	// This function just validates if there is a valid behavior to the units for further validations.
	// Return _isValidBehavior: bool.

	params ["_ownerTag", "_isInVehicle", "_behavior"];
	private ["_isValidBehavior", "_requester"];

	// Initial value:
	_isValidBehavior = false;
	// Errors handling:
	if ( typeName _behavior isEqualTo "STRING" ) then { _behavior = toUpper _behavior };
	// Escape:
		// reserved space.
	// Declarations:
	_requester = if _isInVehicle then { "vehicle" } else { "group" };
	// Debug texts:
		// reserved space.
	// If the configured behavior is known:
	if ( _behavior in ["BE_SAFE", "BE_AWARE", "BE_COMBAT", "BE_STEALTH", "BE_CHAOS"] ) then { 
		// Preparing to successfully return:
		_isValidBehavior = true;
	// Otherwise:
	} else {
		// Warning message:
		["%1 '%2' > One or more %3s has no BEHAVIOR properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integraty, the %3 won't be created.", CSWR_txtWarningHeader, _ownerTag, _requester] call BIS_fnc_error; sleep 5;
	};
	// Return:
	_isValidBehavior;
};


THY_fnc_CSWR_population_destination = {
	// This function just validates if there is at least the minimal valid destination amount dropped on the map for further validations.
	// Return _areThereDests: bool.

	params ["_ownerTag", "_isInVehicle", "_destsType"];
	private ["_areThereDests", "_isValidMkr", "_destsList", "_minAmount", "_requester", "_txt1", "_txt2", "_txt3", "_txt4"];

	// Initial value:
	_areThereDests = false;
	_isValidMkr = false;
	_destsList = [];
	_minAmount = objNull;
	// Escape:
		// reserved space.
	// Declarations:
	_requester = if _isInVehicle then { "vehicle" } else { "group" };
	switch _destsType do {
		case "MOVE_ANY":        { _minAmount = CSWR_minDestAny };
		case "MOVE_PUBLIC":     { _minAmount = CSWR_minDestPublic };
		case "MOVE_RESTRICTED": { _minAmount = CSWR_minDestRestricted };
		case "MOVE_WATCH":      { _minAmount = CSWR_minDestWatch };
		case "MOVE_OCCUPY":     { _minAmount = CSWR_minDestOccupy };
		case "MOVE_HOLD":       { _minAmount = CSWR_minDestHold };
		default                 { /* _minAmount = objNull */ };
	};
	// Debug texts:
	_txt1 = format ["A %1 %2 won't be created coz the DESTINATION TYPE '%3' HAS NO %4 or more markers dropped on the map.", _ownerTag, _requester, _destsType, _minAmount];
	_txt2 = format ["One or more %1 %2s HAS NO DESTINATION properly configured in 'fn_CSWR_population.sqf' file. For script integraty, the %2 won't be created.", _ownerTag, _requester];
	_txt3 = format ["%1 %2 CANNOT use '%3' destinations. Check the 'fn_CSWR_population.sqf' file. For script integraty, the %2 won't be created.", _ownerTag, _requester, _destsType];
	_txt4 = format ["Civilians CANNOT use '%1' destinations. Check the 'fn_CSWR_population.sqf' file. For script integraty, the civilian group won't be created.", _destsType];
	// Errors handling:
	if ( typeName _destsType isEqualTo "STRING" ) then { _destsType = toUpper _destsType };
	// Main validation:
	switch _destsType do {
		case "MOVE_ANY": {
			// if at least X destinations of this type:
			if ( count CSWR_destsANYWHERE >= CSWR_minDestAny ) then { 
				// Prepare to return, saying there are available destinations:
				_areThereDests = true;
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
				_areThereDests = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		case "MOVE_RESTRICTED": { 
			// Checking which faction is here:
			switch _ownerTag do {
				case "BLU": { _destsList = CSWR_destsBLU };
				case "OPF": { _destsList = CSWR_destsOPF };
				case "IND": { _destsList = CSWR_destsIND };
			};
			// if at least X destinations of this type:
			if ( count _destsList >= CSWR_minDestRestricted ) then {
				// Prepare to return, saying there are available destinations:
				_areThereDests = true;
			// Otherwise:
			} else {
				// Warning message:
				["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5;
			}; 
		};
		case "MOVE_WATCH": { 
			// Checking which faction is here:
			switch _ownerTag do {
				case "BLU": { _destsList = CSWR_destsWatchBLU };
				case "OPF": { _destsList = CSWR_destsWatchOPF };
				case "IND": { _destsList = CSWR_destsWatchIND };
			};
			// if at least X destinations of this type, and the requester IS NOT a vehicle, and the faction IS NOT civilian:
			if ( count _destsList >= CSWR_minDestWatch && _requester isNotEqualTo "vehicle" && _ownerTag isNotEqualTo "CIV" ) then {
				// Prepare to return, saying there are available destinations:
				_areThereDests = true;
			// Otherwise:
			} else {
				// If NOT a vehicle, and NOT civilian:
				if ( _requester isNotEqualTo "vehicle" && _ownerTag isNotEqualTo "CIV" ) then {
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
					if ( _ownerTag isEqualTo "CIV" ) then {
						// Warning message:
						["%1 %2", CSWR_txtWarningHeader, _txt4] call BIS_fnc_error; sleep 5;
					};
				};
			}; 
		};
		case "MOVE_OCCUPY": { 
			// Checking which faction is here:
			switch _ownerTag do {
				case "BLU": { _destsList = CSWR_destsOccupyBLU };
				case "OPF": { _destsList = CSWR_destsOccupyOPF };
				case "IND": { _destsList = CSWR_destsOccupyIND };
				case "CIV": { _destsList = CSWR_destsOccupyCIV };
			};
			// if at least X destinations of this type (and the requester IS NOT a vehicle):
			if ( count _destsList >= CSWR_minDestOccupy && _requester isNotEqualTo "vehicle" ) then { 
				// Prepare to return, saying there are available destinations:
				_areThereDests = true;
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
			switch _ownerTag do {
				case "BLU": { _destsList = CSWR_destsHoldBLU };
				case "OPF": { _destsList = CSWR_destsHoldOPF };
				case "IND": { _destsList = CSWR_destsHoldIND };
				case "CIV": { _destsList = CSWR_destsHoldCIV };
			};
			// if at least X destinations of this type:
			if ( count _destsList >= CSWR_minDestHold ) then {
				// Prepare to return, saying there are available destinations:
				_areThereDests = true;
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
	_areThereDests;
};


THY_fnc_CSWR_group_type_rules = {
	// This function defines rules to each Group Type of a faction (through Erros Handling), and returns a "dictionary" to be used for another functions (e.g. Skills) later.
	// Returns _factionGrpDict array. If it returns empty, it's because the group is invalid and can't be spawned.

	params["_faction", "_ownerTag", "_grpType", "_destsType"];
	private["_teamLight", "_teamMedium", "_teamHeavy", "_teamCustom1", "_teamCustom2", "_teamCustom3", "_teamSniper", "_vehLight", "_vehMedium", "_vehHeavy", "_vehCustom1", "_vehCustom2", "_vehCustom3", "_factionGrpDict", "_isValidGroup"];

	// Escape:
		// reserved space.
	// Initial values:
	_teamLight=[]; _teamMedium=[]; _teamHeavy=[]; _teamCustom1=[]; _teamCustom2=[]; _teamCustom3=[]; _teamSniper=[]; 
	_vehLight=[]; _vehMedium=[]; _vehHeavy=[]; _vehCustom1=[]; _vehCustom2=[]; _vehCustom3=[];
	_factionGrpDict = [];
	_isValidGroup = true;
	
	// Debug texts:
		// reserved space.
	// Declarations:
	switch _faction do {
		case BLUFOR: {
			// Groups:
			_teamLight   = CSWR_group_BLU_light;
			_teamMedium  = CSWR_group_BLU_medium;
			_teamHeavy   = CSWR_group_BLU_heavy;
			_teamCustom1 = CSWR_group_BLU_custom_1;
			_teamCustom2 = CSWR_group_BLU_custom_2;
			_teamCustom3 = CSWR_group_BLU_custom_3;
			_teamSniper  = CSWR_group_BLU_sniper;
			// Vehicles:
			_vehLight   = [CSWR_vehicle_BLU_light];
			_vehMedium  = [CSWR_vehicle_BLU_medium];
			_vehHeavy   = [CSWR_vehicle_BLU_heavy];
			_vehCustom1 = [CSWR_vehicle_BLU_custom_1];
			_vehCustom2 = [CSWR_vehicle_BLU_custom_2];
			_vehCustom3 = [CSWR_vehicle_BLU_custom_3];
		};
		case OPFOR: {
			// Groups:
			_teamLight   = CSWR_group_OPF_light;
			_teamMedium  = CSWR_group_OPF_medium;
			_teamHeavy   = CSWR_group_OPF_heavy;
			_teamCustom1 = CSWR_group_OPF_custom_1;
			_teamCustom2 = CSWR_group_OPF_custom_2;
			_teamCustom3 = CSWR_group_OPF_custom_3;
			_teamSniper  = CSWR_group_OPF_sniper;
			// Vehicles:
			_vehLight   = [CSWR_vehicle_OPF_light];
			_vehMedium  = [CSWR_vehicle_OPF_medium];
			_vehHeavy   = [CSWR_vehicle_OPF_heavy];
			_vehCustom1 = [CSWR_vehicle_OPF_custom_1];
			_vehCustom2 = [CSWR_vehicle_OPF_custom_2];
			_vehCustom3 = [CSWR_vehicle_OPF_custom_3];
		};
		case INDEPENDENT: {
			// Groups:
			_teamLight   = CSWR_group_IND_light;
			_teamMedium  = CSWR_group_IND_medium;
			_teamHeavy   = CSWR_group_IND_heavy;
			_teamCustom1 = CSWR_group_IND_custom_1;
			_teamCustom2 = CSWR_group_IND_custom_2;
			_teamCustom3 = CSWR_group_IND_custom_3;
			_teamSniper  = CSWR_group_IND_sniper;
			// Vehicles:
			_vehLight   = [CSWR_vehicle_IND_light];
			_vehMedium  = [CSWR_vehicle_IND_medium];
			_vehHeavy   = [CSWR_vehicle_IND_heavy];
			_vehCustom1 = [CSWR_vehicle_IND_custom_1];
			_vehCustom2 = [CSWR_vehicle_IND_custom_2];
			_vehCustom3 = [CSWR_vehicle_IND_custom_3];
		};
		case CIVILIAN: {
			// Groups:
			_teamLight   = CSWR_group_CIV_lone;
			_teamMedium  = CSWR_group_CIV_couple;
			_teamHeavy   = CSWR_group_CIV_gang;
			_teamCustom1 = CSWR_group_CIV_custom_1;
			_teamCustom2 = CSWR_group_CIV_custom_2;
			_teamCustom3 = CSWR_group_CIV_custom_3;
			_teamSniper  = [];  // Civilian has no sniper group.
			// Vehicles:
			_vehLight   = [CSWR_vehicle_CIV_light];
			_vehMedium  = [CSWR_vehicle_CIV_medium];
			_vehHeavy   = [CSWR_vehicle_CIV_heavy];
			_vehCustom1 = [CSWR_vehicle_CIV_custom_1];
			_vehCustom2 = [CSWR_vehicle_CIV_custom_2];
			_vehCustom3 = [CSWR_vehicle_CIV_custom_3];
		};
	};
	// Errors handling > Sniper group cannot execute WatchMove with more than 2 members:
	if ( _grpType isEqualTo _teamSniper && _destsType isEqualTo "MOVE_WATCH" && count _grpType > 2 ) then {
		["%1 WATCH > %2 SNIPER group CANNOT have more than 2 units! The group WON'T SPAWN! Fix it in 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _ownerTag] call BIS_fnc_error;
		sleep 5;
		// Flag to invalid this group:
		_isValidGroup = false;
	};
	// Preparing to return if everything ok:
	if _isValidGroup then {
		// [ _faction, _ownerTag, _grpType  [ [ group_types_arrays ], [ vehicle_types_arrays ] ] ]
		_factionGrpDict = [_faction, _ownerTag, _grpType, [
			[_teamLight, _teamMedium, _teamHeavy, _teamCustom1, _teamCustom2, _teamCustom3, _teamSniper], 
			[_vehLight, _vehMedium, _vehHeavy, _vehCustom1, _vehCustom2, _vehCustom3]
		]]; 
	};
	// Return:
	_factionGrpDict;
};


THY_fnc_CSWR_group_formation = {
	// This function applies a formation to the group.
	// Return nothing.

	params ["_form", "_grp", "_ownerTag", "_isInVehicle"];
	//private [];

	// Escape:
	if ( _form isEqualTo "" ) exitWith {};
	if _isInVehicle exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
		// reserved space.
	// Debug texts:
		// reserved space.

	// Check if the custom formation is valid: https://community.bistudio.com/wiki/formation
	if ( _form in ["COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"] ) then {
		// Custom formation:
		_grp setFormation _form;
	// Otherwise:
	} else {
		// Auto-fixing with generic formation:
		_grp setFormation "WEDGE";
		// Warning message:
		["%1 '%2' > One or more group HAS NO FORMATION properly configured in 'fn_CSWR_population.sqf' file. Check the documentation. For script integraty, the group formation was set as '%3'.", CSWR_txtWarningHeader, _ownerTag, formation _grp] call BIS_fnc_error; sleep 5;
	};
	// Breath for the group execute the new formation:
	sleep 3;
	// Return:
	true;
};


THY_fnc_CSWR_group_behavior = {
	// This function defines the group behavior only.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Return nothing.

	params ["_grp", "_behavior", "_isInVehicle"];
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
			if _isInVehicle then {
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
			if _isInVehicle then {
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
	// Return nothing.

	params ["_grp", "_behavior"/* , "_isInVehicle" */];
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
	// Return nothing.

	params ["_factionGrpDict", "_grp", "_destsType"];
	private ["_grpType", "_dictGroups", "_dictVehicles", "_teamL", "_teamM", "_teamH", "_teamC1", "_teamC2", "_teamC3", "_teamS", "_vehL", "_vehM", "_vehH", "_vehC1", "_vehC2", "_vehC3"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
		// reserved space.
	// Errors handling:
		// reserved space.
	// Declarations:
	_grpType = _factionGrpDict # 2;
	_dictGroups   = (_factionGrpDict # 3) # 0;
	_dictVehicles = (_factionGrpDict # 3) # 1;
	_teamL   = _dictGroups # 0;
	_teamM   = _dictGroups # 1;
	_teamH   = _dictGroups # 2;
	_teamC1  = _dictGroups # 3;
	_teamC2  = _dictGroups # 4;
	_teamC3  = _dictGroups # 5;
	_teamS   = _dictGroups # 6;
	_vehL    = _dictVehicles # 0;
	_vehM    = _dictVehicles # 1;
	_vehH    = _dictVehicles # 2;
	_vehC1   = _dictVehicles # 3;
	_vehC2   = _dictVehicles # 4;
	_vehC3   = _dictVehicles # 5;
	// Debug texts:
		// reserved space.

	{  // forEach units _grp:
		// If member of Light group:
		if ( _grpType isEqualTo _teamL ) then {
			_x setSkill ["endurance", 0.8];
		};
		// If member of Medium group:
		if ( _grpType isEqualTo _teamM ) then {
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 0.7];
			};
		};
		// If member of Heavy group:
		if ( _grpType isEqualTo _teamH ) then { 
			if ( _x == leader _grp ) then {
				_x setSkill ["commanding", 0.9];
			};
			_x setSkill ["courage", 0.8];
		};
		// If member of Custom 1 group:
			//if ( _grpType isEqualTo _teamC1 ) then {   };
		// If member of Custom 2 group:
			//if ( _grpType isEqualTo _teamC2 ) then {   };
		// If member of Custom 3 group:
			//if ( _grpType isEqualTo _teamC3 ) then {   };
		// If member of Sniper group:
		if ( _grpType isEqualTo _teamS && _destsType isEqualTo "MOVE_WATCH" ) then {
			// skills:
			_x setSkill ["aimingAccuracy", 0.9];
			_x setSkill ["spotDistance", 1];
			_x setSkill ["spotTime", 1];
			_x setSkill ["aimingShake", 0.9];
			_x setSkill ["endurance", 0.7];
		};
		// If crewman of Vehicle Light:
			//if ( _vehType isEqualTo _vehL ) then {   };
		// If crewman of Vehicle Medium:
			//if ( _vehType isEqualTo _vehM ) then {   };
		// If crewman of Vehicle Heavy:
			//if ( _vehType isEqualTo _vehH ) then {   };
		// If crewman of Vehicle Custom 1:
			//if ( _vehType isEqualTo _vehC1 ) then {   };
		// If crewman of Vehicle Custom 2:
			//if ( _vehType isEqualTo _vehC2 ) then {   };
		// If crewman of Vehicle Custom 3:
			//if ( _vehType isEqualTo _vehC3 ) then {   };
		// CPU breath
		sleep 0.1;

	} forEach units _grp;
	// Return:
	true;
};


THY_fnc_CSWR_spawn_delay = {
	// This function verify what method of Spawn Delay the group/vehicle will execute.
	// Return nothing.

	params ["_ownerTag", "_spwnDelayMethods", "_isInVehicle", "_grpSize"];
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
	_requester = if _isInVehicle then {"vehicle"} else {"group"};
	// Debug texts:
	_txt1 = format ["A %1 %2 was granted TO SPAWN", _ownerTag, _requester];

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


THY_fnc_CSWR_spawn_and_go = {
	// This function checks if the group/vehicle needs to wait to spawn or if it's been granted to do its first move in game.
	// Returns nothing.

	params ["_spawns", "_spwnDelayMethods", "_factionGrpDict", "_isInVehicle", "_behavior", "_destsType", "_form"];
	private ["_canSpawn", "_grp", "_vehSpawn", "_vehPos", "_faction", "_ownerTag", "_grpType", "_grpSize", "_requester", "_txt1", "_txt2", "_txt3", "_veh"];

	// Escape:
	if ( _factionGrpDict isEqualTo [] ) exitWith {};
	// Initial values:
	_canSpawn = true;
	_grp = grpNull;
	_vehSpawn = [];
	_vehPos = [];
	// Errors handling:
		// reserved space.
	// Declarations:
	_faction      = _factionGrpDict # 0;
	_ownerTag     = _factionGrpDict # 1;
	_grpType      = _factionGrpDict # 2;
	_grpSize      = count _grpType;  // debug proposes.
	_requester = if _isInVehicle then {"vehicle"} else {"group"};
	// Debug texts:
	_txt1 = format ["A %1 %2 has an error in 'fn_CSWR_population.sqf' file.", _ownerTag, _requester];
	_txt2 = format ["For script integraty, the %1 WON'T SPAWN!", _requester];
	_txt3 = format ["%1 %2 %3 will spawn LATER.", str _grpSize, _ownerTag, if _isInVehicle then {"vehicle and its crew"} else {"unit(s) of a group"}];

	// Check if _spwnDelayMethods is in the correct format:
	if ( typeName _spwnDelayMethods isEqualTo "ARRAY" ) then {

		// SPAWN DELAY SECTION:
		// If _spwnDelayMethods is not empty, it's coz the group needs Spawn Delay:
		if ( count _spwnDelayMethods > 0 ) then {
			
			// Validation Step 1/4:
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
			if ( !_canSpawn ) exitWith {};

			// Validation Step 2/4:
			// Escape > If there is more than 1 timer, abort the spawn:
			{  // forEach _spwnDelayMethods:
				if ( { typeName _x isEqualTo "SCALAR" } count _spwnDelayMethods > 1 ) exitWith {
					// Flag to abort the group/vehicle spawn:
					_canSpawn = false;
					// Warning message:
					["%1 SPAWN DELAY > %2 It's NOT allowed a group with more than 1 TIMER. %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error; sleep 5;
				};
			} forEach _spwnDelayMethods;
			// If the object doesn't exist, the spawn isn't available, so there's no reason the keep the validation process running:
			if ( !_canSpawn ) exitWith {};

			// Validation Step 3/4:
			// Errors handling > If the method is Timer:
			{  // forEach _spwnDelayMethods:
				if ( typeName _x isEqualTo "SCALAR" ) then {
					// If the Timer value is 0 (invalid), delete it from the array and keep going the validation:
					// Important: editors during the mission edition will use "0" in array istead of leave that empty.
					if ( _x == 0 ) then { _spwnDelayMethods deleteAt (_spwnDelayMethods find 0)};
				};
			} forEach _spwnDelayMethods;

			// Validation Step 4/4:
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
				[_ownerTag, _spwnDelayMethods, _isInVehicle, _grpSize] call THY_fnc_CSWR_spawn_delay;
			};
		};

		// SPAWN SECTION:
		if _canSpawn then {
			if ( !_isInVehicle ) then {
				// SPAWNING a group:
				_grp = [getMarkerPos (selectRandom _spawns), _faction, _grpType, [],[],[],[],[], 180, false, 0] call BIS_fnc_spawnGroup; // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
				
			} else {
				// SPAWNING a vehicle and its crewmen:
				_vehSpawn = getMarkerPos (selectRandom _spawns);
				_vehPos = _vehSpawn findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valius might result in explosions and vehicles not spawning.
				_grp = [_vehPos, _faction, _grpType, [],[],[],[],[], 180, false, 1] call BIS_fnc_spawnGroup;
				_veh = vehicle leader _grp;
				// Vehicle config > Features:
				_veh setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners never will leave the their vehicle.
				_veh setVehicleReportOwnPosition true;
				_veh setVehicleReceiveRemoteTargets true;
				_veh setVehicleReportRemoteTargets true;
				//_faction reportRemoteTarget [<enemy vehicle>, 60];
				//_veh setVehicleRadar 1;
				//_enemy = "";
				//if (_faction == xxxxx ) then { _enemy = xxxxx } else { _enemy = xxxxx }; <<-- WIP Use this: https://community.bistudio.com/wiki/BIS_fnc_enemySides
				//_veh confirmSensorTarget [_enemy, true];
			};
			// Group/Vehicle config > Server performance:
			_grp deleteGroupWhenEmpty true;
			// Group/Vehicle config > Loadout customization:
			{ [side _x, _grpType, _x] call THY_fnc_CSWR_loadout; sleep 0.1 } forEach units _grp;
			// Group/Vehicle config > Units skills:
			[_factionGrpDict, _grp, _destsType] call THY_fnc_CSWR_unit_skills;
			// Group config > Formation:
			[_form, _grp, _ownerTag, _isInVehicle] call THY_fnc_CSWR_group_formation;
			// Group/Vehicle config > Adding to ZEUS:
			if CSWR_isEditableByZeus then {
				{  // forEach allCurators:
					// Unit(s):
					_x addCuratorEditableObjects [units _grp, true];
					// Vehicle:
					if _isInVehicle then { _x addCuratorEditableObjects [[vehicle (leader _grp)], true] };
				} forEach allCurators;
			};

			// WAYPOINTS SECTION:
			// Group/Vehicle config > Move:
			switch _destsType do {
				case "MOVE_ANY":        { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_ANYWHERE };
				case "MOVE_PUBLIC":     { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_PUBLIC };
				case "MOVE_RESTRICTED": { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_RESTRICTED };
				case "MOVE_WATCH":      { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_WATCH };  // Vehicles and Civilian faction are not able to do this.
				case "MOVE_OCCUPY":     { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY };  // Vehicles are not able to do this.
				case "MOVE_HOLD":       { [_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_HOLD };
				// And if something wrong:
				default { ["%1 %2 '%3' group has an UNKNOWN DESTINATION. Check the 'fn_CSWR_population.sqf' file.", CSWR_txtWarningHeader, _ownerTag, str _grp] call BIS_fnc_error; sleep 5 };
			};
		};

	// Otherwise, if the _spwnDelayMethods is not an array:
	} else {
		// Warning message:
		["%1 SPAWN DELAY > %2 %3", CSWR_txtWarningHeader, _txt1, _txt2] call BIS_fnc_error;
		// Message breath:
		sleep 5;
	};
	// Return:
	true;
};


THY_fnc_CSWR_add_group = {
	// This function requests and prepares the basic of the creation of a group of AI soldiers.
	// Returns nothing.
	
	params ["_faction", ["_spawns", []], ["_grpType", []], ["_form", ""], ["_behavior", ""], ["_destsType", ""], ["_spwnDelayMethods", 0]];
	private ["_isValidClassname", "_isInVehicle", "_ownerTag", "_isValidBehavior", "_areThereDests", "_txt1", "_txt2", "_txt3", "_factionGrpDict"];
	
	// Initial values:
	_isValidClassname = true;
	// Declarations:
	_isInVehicle = false;
	_ownerTag = [_faction] call THY_fnc_CSWR_convertion_faction_to_owner_tag;
	_isValidBehavior = [_ownerTag, _isInVehicle, _behavior] call THY_fnc_CSWR_population_behavior;
	_areThereDests = [_ownerTag, _isInVehicle, _destsType] call THY_fnc_CSWR_population_destination;
	// Debug texts:
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a group. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _ownerTag];
	_txt2 = format ["%1 > There IS NO a defined SOLDIERS GROUP at least in one of %1 lines in 'fn_CSWR_population.sqf'. Check the documentation. For script integraty, the group WON'T SPAWN!", _ownerTag];
	_txt3 = "Make sure it's spelled correctly and, if the classname comes from a mod, check if the mod is properly loaded on server.";
	// Escape:
	if ( typeName _spawns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spawns == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( typeName _grpType isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	if ( count _grpType == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	{ if ( !(isClass (configFile >> "CfgVehicles" >> _x)) ) exitWith { _isValidClassname = false; ["%1 %2 > '%3' IS NOT a valid UNIT CLASSNAME. %4", CSWR_txtWarningHeader, _ownerTag, _x, _txt3] call BIS_fnc_error; sleep 5} } forEach _grpType;
	if ( typeName _form isEqualTo "STRING" ) then { _form = toUpper _form };
	if ( !_isValidBehavior ) exitWith {};
	if ( !_areThereDests ) exitWith {};
	if ( !_isValidClassname ) exitWith {};
	// Group Type Rules:
	_factionGrpDict = [_faction, _ownerTag, _grpType, _destsType] call THY_fnc_CSWR_group_type_rules;
	// Spawn Schadule:
	[_spawns, _spwnDelayMethods, _factionGrpDict, _isInVehicle, _behavior, _destsType, _form] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breath:
	sleep 1;
	// Return:
	true;
};


THY_fnc_CSWR_add_vehicle = {
	// This function requests and prepares the basic of the creation of a vehicle and its AI crewmen.
	// Returns nothing.
	
	params ["_faction", ["_spawns", []], ["_vehType", ""], ["_behavior", ""], ["_destsType", ""], ["_spwnDelayMethods", 0]];
	private ["_isInVehicle", "_ownerTag", "_isValidBehavior", "_areThereDests", "_txt1", "_txt2", "_txt3", "_factionGrpDict"];
	
	// Initial values:
		// reserved space.
	// Declarations:
	_isInVehicle = true;
	_ownerTag = [_faction] call THY_fnc_CSWR_convertion_faction_to_owner_tag;
	_isValidBehavior = [_ownerTag, _isInVehicle, _behavior] call THY_fnc_CSWR_population_behavior;
	_areThereDests = [_ownerTag, _isInVehicle, _destsType] call THY_fnc_CSWR_population_destination;
	// Debug texts:
	_txt1 = format ["%1 > There IS NO SPAWNPOINT to create a vehicle. In 'fn_CSWR_population.sqf' check if 'CSWR_spwns%1' is spelled correctly and make sure there's at least 1 %1 spawn marker of this faction on Eden.", _ownerTag];
	_txt2 = format ["%1 > There IS NO a defined VEHICLE at least in one of %1 lines in 'fn_CSWR_population.sqf'. Check the documentation. For script integraty, the vehicle WON'T SPAWN!", _ownerTag];
	_txt3 = "Make sure it's spelled correctly and, if the classname comes from a mod, check if the mod is properly loaded on server.";
	// Escape:
	if ( typeName _spawns isNotEqualTo "ARRAY" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( count _spawns == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt1] call BIS_fnc_error; sleep 5 };
	if ( typeName _vehType isNotEqualTo "STRING" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	if ( count _vehType == 0 ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	if ( _vehType isEqualTo "" ) exitWith { ["%1 %2", CSWR_txtWarningHeader, _txt2] call BIS_fnc_error; sleep 5 };
	if ( !(isClass (configFile >> "CfgVehicles" >> _vehType)) ) exitWith { ["%1 %2 > '%3' IS NOT a valid VEHICLE CLASSNAME. %4", CSWR_txtWarningHeader, _ownerTag, _vehType, _txt3] call BIS_fnc_error; sleep 5 };
	if ( !_isValidBehavior ) exitWith {};
	if ( !_areThereDests ) exitWith {};
	// Group Type Rules:
	_vehType = [_vehType];  // Converting string to array. In "fn_CSWR_population.sqf" vehicles are only strings to discourage the editor from creating groups of vehicles.
	_factionGrpDict = [_faction, _ownerTag, _vehType, _destsType] call THY_fnc_CSWR_group_type_rules;
	// Spawn Schadule:
	[_spawns, _spwnDelayMethods, _factionGrpDict, _isInVehicle, _behavior, _destsType, ""] spawn THY_fnc_CSWR_spawn_and_go;
	// CPU breath:
	sleep 10;  // CRITICAL: helps to avoid veh colissions and explosions at the beggining of the match. Less than 10, heavy vehicles can blow up in spawn. Less than 5, any vehicle can blow up in spawn.
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
	private ["_oldHeadgear", "_veh"];

	// Initial values:
	_oldHeadgear = "";
	_veh = objNull;

	// CREW HEADGEAR:
	if (!isNull (objectParent _unit)) then {
		// Declarations:
		_oldHeadgear = headgear _unit;  // if empty, returns "".
		_veh = vehicle _unit;
		// Units can use headgear:
		if ( _newHelmetCrew isNotEqualTo "REMOVED" ) then {
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
		if ( _newHelmetInfantry isNotEqualTo "REMOVED" ) then {
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
	private ["_oldUniformContent", "_oldUniform"];

	// Initial values:
	_oldUniformContent = [];
	// Declarations:
	_oldUniform = uniform _unit;  // if empty, returns "".
	// Units can use uniform:
	if ( _newUniform isNotEqualTo "REMOVED") then {
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

	params ["_unit", "_newVest", "_isMandatory"];
	private ["_oldVestContent", "_oldVest"];

	// Initial values:
	_oldVestContent = [];
	// Declarations:
	_oldVest = vest _unit;  // if empty, returns "".
	// Units can use vest:
	if ( _newVest isNotEqualTo "REMOVED") then {
		// if the unit had an old vest OR the CSWR is been forced to add vest for each unit, including those ones originally with no vest:
		if ( _oldVest isNotEqualTo "" || _isMandatory ) then {
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

	params ["_unit", "_newBackpack", "_isMandatory"];
	private ["_oldBackpackContent", "_oldBackpack"];

	// Initial values:
	_oldBackpackContent = [];
	// Declarations:
	_oldBackpack = backpack _unit;  // if empty, returns "".
	// Units can use backpack:
	if ( _newBackpack isNotEqualTo "REMOVED") then {
		// if the unit had an old backpack OR the CSWR is been forced to add backpack for each unit, including those ones originally with no backpack:
		if ( _oldBackpack isNotEqualTo "" || _isMandatory ) then {
			// if the editors registered a new backpack, && both are not the same:
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

	params ["_teamType", "_unit", "_uniform", "_vest", "_rifle", "_rifleMagazine", "_rifleOptics", "_rifleRail", "_rifleMuzzle", "_rifleBipod", "_binoculars"];
	private ["_isSniperTeam"];

	// Initial values:
	_isSniperTeam = false;
	// Declarations:
	switch ( side _unit ) do {  // Important: it's needed coz team-public-vars are declared only if the faction is TRUE on fn_CSWR_management, otherwise the faction validation wouldn't necessary.
		case BLUFOR:      { if (_teamType isEqualTo CSWR_group_BLU_sniper) then { _isSniperTeam = true } };
		case OPFOR:       { if (_teamType isEqualTo CSWR_group_OPF_sniper) then { _isSniperTeam = true } };
		case INDEPENDENT: { if (_teamType isEqualTo CSWR_group_IND_sniper) then { _isSniperTeam = true } };
		// Civilian is not appliable here!
	};
	// Escape:
	if ( !_isSniperTeam ) exitWith {};
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
	//[_unit, ""] call THY_fnc_CSWR_loadout_backpack;  // Snipers never got backpack, even when CSWR_isVestForAll is true.
	// Rifle:
	[_unit, _rifle, _rifleMagazine, _rifleOptics, _rifleRail, _rifleMuzzle, _rifleBipod] call THY_fnc_CSWR_loadout_team_sniper_weapon;
	// Binocular:
	if ( _binoculars isNotEqualTo "" && _binoculars isNotEqualTo "REMOVED" ) then {  // So the editor wants another binoculars.
		// Remove the old one if it exists:
		_unit removeWeapon (binocular _unit);
		// New binoculars replacement:
		_unit addWeapon _binoculars;
	// If there's NO custom binoculars, check if there is at least a regular one:
	} else { 
		// If no binoculars at all, add it because for sniper group is mandatory:
		if ( binocular _unit isEqualTo "" || _binoculars isEqualTo "REMOVED" ) then {  // Binoculars are mandatory for sniper group coz the logic used for sniper group with 2 units.
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


THY_fnc_CSWR_loadout_team_sniper_weapon = {
	// This function replace the old sniper rifle for new stuff. Parameters empties result no changes.
	// Returns nothing.

	params ["_unit", "_rifle", "_rifleNewMag", "_rifleNewOptics", "_rifleNewRail", "_rifleNewMuzzle", "_rifleNewBipod", ["_magAmount", 6]];
	private ["_rifleOldAccessories", "_rifleOldMag"];

	// Initial values:
		// Reserved space.
	// Declarations:
		_rifleOldAccessories = _unit weaponAccessories (primaryWeapon _unit);  // [silencer, laserpointer/flashlight, optics, bipod] like ["","acc_pointer_IR","optic_Aco",""]
		//private _rifleOldMags = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "magazines");  // collect all types of magazines from primary weapon.
		_rifleOldMag = primaryWeaponMagazine _unit;  // old mag loaded on rifle.
	
	// Magazine (Crucial: need to be first!)
		if ( _rifle isNotEqualTo "REMOVED" ) then {  // it's correct about rifle here in magazines!
			if ( _rifleNewMag isNotEqualTo "" && _rifleNewMag isNotEqualTo "REMOVED" ) then {
				// Removing all old rifle magazines from the loadout:
				_unit removeMagazines (_rifleOldMag # 0); 
				// Include new magazines in loadout containers (the old ones only will be removed if the rifle was replaced):
				_unit addMagazines [_rifleNewMag, _magAmount];
			// Got new rifle but magazine wasn't declared:
			} else {
				if ( _rifleNewMag isEqualTo "REMOVED" ) then {
					// Removing all rifle magazines from the loadout:
					_unit removeMagazines (_rifleOldMag # 0); 
				};
				// Warning message:
				if ( CSWR_isOnDebugGlobal && _rifle isNotEqualTo "" && _rifle isNotEqualTo "REMOVED" ) then { 
					["%1 WATCH > '%2' needs magazines for their new rifle!", CSWR_txtWarningHeader, str (group _unit)] call BIS_fnc_error; sleep 5;
				};
			};
		} else {
			if CSWR_isOnDebugGlobal then { 
				["%1 WATCH > To set magazines to '%2' sniper group, first fix their rifle inconsistence!", CSWR_txtWarningHeader, str (group _unit)] call BIS_fnc_error; sleep 5;
			};
		};
	// Rifle:
		if ( _rifle isNotEqualTo "" && _rifle isNotEqualTo "REMOVED" ) then {  // Rifle is mandatory for sniper group.
			// removes primary weapon:
			_unit removeWeapon (primaryWeapon _unit);
			// Add the new rifle (without magazines and acessories):
			_unit addWeapon _rifle;
			// Add an additional new magazine directly on the weapon loader:
			_unit addPrimaryWeaponItem _rifleNewMag;
			// Use the new rifle since mission starts:
			_unit selectWeapon _rifle;
		} else {
			if ( _rifle isEqualTo "REMOVED") then {
				["%1 WATCH > '%2' needs a primary weapon. No rifle will be removed from them!", CSWR_txtWarningHeader, str (group _unit)] call BIS_fnc_error; sleep 5;
			};
		};
	// Optics:
		if ( _rifle isNotEqualTo "REMOVED" && _rifleNewOptics isNotEqualTo "" && _rifleNewOptics isNotEqualTo "REMOVED" ) then {
			// removes old optics if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 2);
			// adds the new optics:
			_unit addPrimaryWeaponItem _rifleNewOptics;
		} else {
			if ( _rifleNewOptics isEqualTo "REMOVED" && (_rifleOldAccessories # 2) isNotEqualTo "" ) then {
				// removes old optics if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 2);
			};
		};
	// Rail:
		if ( _rifle isNotEqualTo "REMOVED" && _rifleNewRail isNotEqualTo "" && _rifleNewRail isNotEqualTo "REMOVED" ) then {
			// removes old rail item if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 1);
			// adds the new rail item:
			_unit addPrimaryWeaponItem _rifleNewRail;
		} else {
			if ( _rifleNewRail isEqualTo "REMOVED" && (_rifleOldAccessories # 1) isNotEqualTo "" ) then {
				// removes old rail item if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 1);
			};
		};
	// Muzzle:
		if ( _rifle isNotEqualTo "REMOVED" && _rifleNewMuzzle isNotEqualTo "" && _rifleNewMuzzle isNotEqualTo "REMOVED" ) then {
			// removes old muzzle if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 0);
			// adds the new muzzle:
			_unit addPrimaryWeaponItem _rifleNewMuzzle;
		} else {
			if ( _rifleNewMuzzle isEqualTo "REMOVED" && (_rifleOldAccessories # 0) isNotEqualTo "" ) then {
				// removes old muzzle if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 0);
			};
		};
	// Bipod:
		if ( _rifle isNotEqualTo "REMOVED" && _rifleNewBipod isNotEqualTo "" && _rifleNewBipod isNotEqualTo "REMOVED" ) then {
			// removes old bipod if there is one:
			_unit removePrimaryWeaponItem (_rifleOldAccessories # 3);
			// adds the new bipod:
			_unit addPrimaryWeaponItem _rifleNewBipod;
		} else {
			if ( _rifleNewBipod isEqualTo "REMOVED" && (_rifleOldAccessories # 3) isNotEqualTo "" ) then {
				// removes old bipod if there is one:
				_unit removePrimaryWeaponItem (_rifleOldAccessories # 3);
			};
		};
	// Return:
	true;
};


THY_fnc_CSWR_go_ANYWHERE = {
	// This function sets the group to move to any destination (sum of almost all other preset destinations), including exclusive enemy faction destinations but excluding the specialized ones. It's a looping.
	// Returns nothing.
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_areaToPass","_wp"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
		// Reserved space.
	// Declarations:
	_areaToPass = getMarkerPos (selectRandom CSWR_destsANYWHERE);
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0]; 
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	waitUntil { sleep 10; isNull _grp || ((leader _grp) distance _areaToPass < 10) };
	// Error handling:
	if ( isNull _grp ) exitWith {};
	// Next planned move cooldown:
	sleep (random CSWR_destCommonTakeabreak);
	// Restart the movement:
	[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_ANYWHERE;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_PUBLIC = { 
	// This function sets the group to move through PUBLIC destinations where civilians and soldiers can go. It's a looping.
	// Returns nothing.
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_areaToPass","_wp"];

	// Escape:
	if ( isNull _grp ) exitWith {};
	// Initial values:
		// Reserved space.
	// Declarations:
	_areaToPass = getMarkerPos (selectRandom CSWR_destsPUBLIC);
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0];
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	waitUntil { sleep 10; isNull _grp || ((leader _grp) distance _areaToPass < 10) };
	// Error handling:
	if ( isNull _grp ) exitWith {};
	// Next planned move cooldown:
	sleep (random CSWR_destCommonTakeabreak);
	// Restart the movement:
	[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_PUBLIC;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_RESTRICTED = { 
	// This function sets the group to move only through the exclusive faction destinations. It's a looping.
	// Returns nothing.
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_destsList", "_areaToPass","_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destsList = [];
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destsList = CSWR_destsBLU };
		case OPFOR:       { _destsList = CSWR_destsOPF };
		case INDEPENDENT: { _destsList = CSWR_destsIND };
		case CIVILIAN:    { _destsList = CSWR_destsCIV };
	};
	// Check the available RESTRICTED faction markers on map:
	_areaToPass = getMarkerPos (selectRandom _destsList);
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_areaToPass, 0]; 
	_wp setWaypointType "MOVE";
	_grp setCurrentWaypoint _wp;
	// Check if the group is already on their destine:
	waitUntil { sleep 10; isNull _grp || ((leader _grp) distance _areaToPass < 10) };
	// Error handling:
	if ( isNull _grp ) exitWith {};
	// Next planned move cooldown:
	sleep (random CSWR_destCommonTakeabreak);
	// Restart the movement:
	[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_RESTRICTED;
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_WATCH = { 
	// This function sets the group to move only through the high natural spots destinations and stay there for as long the mission runs, watching around quiet, perfect for snipers and marksmen groups. It's NOT a looping.
	// Returns nothing.
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_destsList", "_areaToWatch", "_sniperSpot", "_chosenSpotPosToATL", "_wp"];

	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Debug and warning purposes:
	_ownerTag = [side (leader _grp)] call THY_fnc_CSWR_convertion_faction_to_owner_tag;
	// Error handling:
	if _isInVehicle exitWith { ["%1 WATCH > %2 Vehicles CANNOT use Watch-Destinations. Please, fix it in 'fn_CSWR_population.sqf' file. For script integraty, the vehicle and its crewmen were deleted.", CSWR_txtWarningHeader, _ownerTag] call BIS_fnc_error; deleteVehicle (vehicle (leader _grp)); { deleteVehicle _x } forEach units _grp; sleep 5 };
	if ( (side (leader _grp)) == CIVILIAN ) exitWith { ["%1 WATCH > Civilians CANNOT use Watch-Destinations. Please, fix it in 'fn_CSWR_population.sqf' file. For script integraty, the civilian group was deleted.", CSWR_txtWarningHeader] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Initial values:
	_destsList = [];
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destsList = CSWR_destsWatchBLU };
		case OPFOR:       { _destsList = CSWR_destsWatchOPF };
		case INDEPENDENT: { _destsList = CSWR_destsWatchIND };
		case CIVILIAN:    { _destsList = CSWR_destsWatchCIV };
	};
	// Check the available WATCH faction markers on map:
	_areaToWatch = getMarkerPos (selectRandom _destsList);
	_sniperSpot = [_grp, _areaToWatch, CSWR_watchMarkerRange, _ownerTag] call THY_fnc_CSWR_WATCH_find_spot;
	// Restart if previous try the spot was reserved:
	if ( (count _sniperSpot) == 0 ) exitWith { [_grp, side (leader _grp), _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_WATCH };
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Creating the waypoint:
	_wp = _grp addWaypoint [_sniperSpot, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCombatMode "WHITE";  // FORCING THIS FOR SNIPERS // hold fire, kill only if own position spotted.
	_grp setCurrentWaypoint _wp;
	// Debug message:
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
		{
			["%1 WATCH > %2 '%3' unit has their: aimingAccuracy = %4 | spotDistance = %5 | aimingSpeed = %6 | endurance = %7", CSWR_txtDebugHeader, _ownerTag, str _x, (_x skill "aimingAccuracy"), (_x skill "spotDistance"), (_x skill "aimingSpeed"), (_x skill "endurance")] call BIS_fnc_error; sleep 5;
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
	// Jump to the next WATCH stage:
	[_grp, _areaToWatch, _behavior, _ownerTag] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_find_spot = {
	// This function finds first a specific type of locations and, later, a spot around the selected location for snipers execute the overwatching further.
	// Return _sniperPos: array.

	params ["_grp", "_areaToWatch", "_range", "_ownerTag"];
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
	if ( (count _locations) != 0 ) then {
		// Debug markers:
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then {
			{  // forEach _locations:
				// Show me all locations found on the map with markers:
				_mkrLocPos = createMarker [((str _x) + (str (side (leader _grp)))), locationPosition _x];
				_mkrLocPos setMarkerType "hd_dot";
				switch ( side (leader _grp) ) do {
					case BLUFOR: { 
						_mkrLocPos setMarkerColor "colorBLUFOR"; 
						((str _x) + (str (side (leader _grp)))) setMarkerPos [((locationPosition _x # 0) + 10), (locationPosition _x # 1), 0];
					};
					case OPFOR: { 
						_mkrLocPos setMarkerColor "colorOPFOR";
						((str _x) + (str (side (leader _grp)))) setMarkerPos [(locationPosition _x # 0), ((locationPosition _x # 1) + 10), 0];
					};
					case INDEPENDENT: { 
						_mkrLocPos setMarkerColor "colorIndependent"; 
						((str _x) + (str (side (leader _grp)))) setMarkerPos [((locationPosition _x # 0) - 10), (locationPosition _x # 1), 0];
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
				if ( _sniperPos distance _areaToWatch <= _disLocToArea /* && (!isOnRoad _sniperPos) */ && (count _roadsAround) == 0 /* && (!_isTerrainBlockingView) */ ) then {
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
				if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %3 location(s) found, %2 '%4' moving: %5.", CSWR_txtDebugHeader, _ownerTag, count _locations, str _grp, _location] };
			// Message fail:
			} else {
				// When debug mode on:
				if CSWR_isOnDebugGlobal then { ["%1 WATCH > %2 '%3' group has no good spot. Next try soon...", CSWR_txtDebugHeader, _ownerTag, str _grp] call BIS_fnc_error };
				// CPU breath to prevent craze loopings:
				sleep _wait;
			};
		// If the location is already reserved for another (same faction) group:
		} else {
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 sniper group selected a location already reserved for other group. Next try soon...", CSWR_txtDebugHeader, _ownerTag] call BIS_fnc_error };
			// CPU breath to prevent craze loopings:
			sleep _wait;
		};
	// If didnt find even one location:
	} else {
		// Warning message:
		["%1 WATCH > A %2 WATCH-MARKER (%3) looks has no natural high locations to scan around. Change its position is adviced.", CSWR_txtDebugHeader, _ownerTag, str _areaToWatch] call BIS_fnc_error;
		// CPU breath to prevent craze loopings:
		sleep _wait;
	};
	// Return:
	_sniperPos;
};


THY_fnc_CSWR_WATCH_doWatching = {
	// This function organizes the sniper/marksman group during the overwatching. It's a looping.
	// Returns nothing.

	params ["_grp", "_areaToWatch", "_behavior", "_ownerTag"];
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
			waitUntil { sleep 3; (speed _x == 0) || (!alive _x) };
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
		if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit reseted: unitCombatMode '%4' / behaviour '%5' / elevation '%6' / pos fixed '%7' / leader '%8'", CSWR_txtDebugHeader, _ownerTag, str _x, unitCombatMode _x, behaviour _x, round (getTerrainHeightASL (getPosATL _x)), !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 3 };
	} forEach units _grp;
	
	
	// STEP 2/4: SEEKING TARGETS
	// Debug message:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %2 Sniper in position and '%3'!", CSWR_txtDebugHeader, _ownerTag, behaviour (leader _grp)]; sleep 1 };
	// Seek looping:
	while { behaviour (leader _grp) isNotEqualTo "COMBAT" } do {
		{  // forEach (units _grp):
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit: unitCombatMode '%4' / behaviour '%5' / pos fixed '%6' / leader '%7'", CSWR_txtDebugHeader, _ownerTag, str _x, unitCombatMode _x, behaviour _x, !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 1 };
			// Forcing the sniper/leader 
			if ( _x == (leader _grp) ) then {
				// leader behavior aware if they're feel safe:
				if ( (behaviour _x) isEqualTo "SAFE" ) then { _x setCombatBehaviour "AWARE" };
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
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 WATCH > %2 Sniper leader in position and '%3'!", CSWR_txtDebugHeader, _ownerTag, behaviour (leader _grp)]; sleep 1 };
	// Combat looping:
	while { behaviour (leader _grp) isEqualTo "COMBAT" } do {
		{  // forEach (units _grp):
			// Error handling:
			if ( !alive _x || incapacitatedState _x isEqualTo "UNCONSCIOUS" ) then { break };
			// Debug message:
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch ) then { ["%1 WATCH > %2 '%3' unit: unitCombatMode '%4' / behaviour '%5' / pos fixed '%6' / leader '%7'", CSWR_txtDebugHeader, _ownerTag, str _x, unitCombatMode _x, behaviour _x, !(_x checkAIFeature "PATH"), (_x == (leader _grp))] call BIS_fnc_error; sleep 1 };
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
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugWatch && !isNull (getAttackTarget _x) ) then { systemChat format ["%1 WATCH > %2 '%3' unit has a target: '%4'.", CSWR_txtDebugHeader, _ownerTag, str _x, getAttackTarget _x]; sleep 1 };
			// CPU breath:
			sleep 1;
		} forEach units _grp;
		// CPU breath before restart the COMBAT loop:
		sleep 2;
	};  // While-loop TWO ends.

	// STEP 4/4: RESTART FROM STEP 1:
	[_grp, _areaToWatch, _behavior, _ownerTag] spawn THY_fnc_CSWR_WATCH_doWatching;
	// Return:
	true;
};


THY_fnc_CSWR_WATCH_spotter_fire_support = {
	// This function verifies if the unit members of sniper group must provide fire support for the group leader.
	// Return nothing.

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
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_ownerTag", "_destsList", "_bldgPos", "_spots", "_wp", "_grpLead", "_leadStuckCounter", "_getOutPos", "_distLimiterFromBldg", "_distLimiterFriendPlayer", "_distLimiterEnemy", "_wait", "_grpSize", "_regionToSearch", "_building"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Initial values:
	_destsList = [];
	_bldgPos = [];
	_spots = [];
	_wp = [];
	_grpLead = objNull;
	_leadStuckCounter = 0;
	_getOutPos = [];
	// Declarations:
	_ownerTag = [side (leader _grp)] call THY_fnc_CSWR_convertion_faction_to_owner_tag;
	_distLimiterFromBldg = 10;  // Distance to activate occupy functions validations to group leader.
	_distLimiterFriendPlayer = 40;  // Distance to desactivate the AI teleport when player is around.
	_distLimiterEnemy = 200;  // Distance to desactivate the AI teleport when enemies (including player) are around.
	_wait = 10;  // Avoid crazy loopings in entery occupy functions. Be careful.
	_grpSize = count (units _grp);
	// Errors handling:
	if _isInVehicle exitWith { ["%1 OCCUPY > %2 Vehicles CANNOT use Occupy-Destinations. Please, fix it in 'fn_CSWR_population.sqf' file. For script integraty, the vehicle and its crewmen were deleted.", CSWR_txtWarningHeader, _ownerTag] call BIS_fnc_error; deleteVehicle (vehicle (leader _grp)); { deleteVehicle _x } forEach units _grp; sleep 5 };
	if ( _grpSize > 6 ) exitWith { ["%1 OCCUPY > %2 '%3' group current size (%4) is too big for occupy movement integrity. Use groups composed from 1 to 6 units. For now, the group has been deleted.", CSWR_txtWarningHeader, _ownerTag, str _grp, _grpSize] call BIS_fnc_error; { deleteVehicle _x } forEach units _grp; sleep 5 };
	// Forcing unit basic setup to start the Occupy movement to prevent anomalies:
	{  // forEach of units _grp:
		_x enableAI "PATH";
		_x doFollow (leader _grp);
		sleep 0.25;
	} forEach units _grp;
	// Load the original group behavior (Editor's choice):
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destsList = CSWR_destsOccupyBLU };
		case OPFOR:       { _destsList = CSWR_destsOccupyOPF };
		case INDEPENDENT: { _destsList = CSWR_destsOccupyIND };
		case CIVILIAN:    { _destsList = CSWR_destsOccupyCIV };
	};
	// Check the available OCCUPY faction markers on map:
	_regionToSearch = getMarkerPos (selectRandom _destsList);
	// Selecting one building from probably many others found in that range:
	_building = [_grp, side (leader _grp), _ownerTag] call THY_fnc_CSWR_OCCUPY_find_buildings_by_group;  // return object.
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
						if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.", CSWR_txtDebugHeader, _ownerTag, str _grp]; };
						// Small cooldown to prevent crazy loopings:
						sleep 1;
						// Restart the first OCCUPY step:
						[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
						// Stop the while-looping:
						break;
					};
				};
				// if group leader is close enough to the chosen building:
				if ( _grpLead distance _bldgPos < _distLimiterFromBldg ) then {
					// When there, execute the occupy function:
					[_building, _bldgPos, _grp, _ownerTag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _wait, _isInVehicle] spawn THY_fnc_CSWR_OCCUPY_doGetIn;
					// Stop the while-looping:
					break;
				};
				// Check if the waypoint was lost (sometimes bugs or misclick by zeus can delete the waypoint):
				if ( waypointType _wp isEqualTo "" || currentWaypoint _grp == 0 ) then {
					// Debug message:
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' group lost the waypoint for unknown reason. New search in %6 secs.", CSWR_txtDebugHeader, _ownerTag, str _grp, count units _grp, count _spots, _wait]; sleep 1 };
					// Small cooldown to prevent crazy loopings:
					sleep 3;
					// Restart the first OCCUPY step:
					[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
					// Stop the while-looping:
					break;
				};
				// Check if the leader is alive, is not stuck in their way to the building and not injured, not engaging, they're awake, give a timeout to restart the whole function again:
				if ( alive _grpLead && unitReady _grpLead && lifeState _grpLead isNotEqualTo "INJURED" && incapacitatedState _grpLead isNotEqualTo "SHOOTING" && incapacitatedState _grpLead isEqualTo "UNCONSCIOUS" ) then {
					_leadStuckCounter = _leadStuckCounter + 1;
					// Debug message:
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' leader looks stuck %4 time(s).", CSWR_txtDebugHeader, _ownerTag, str _grp, _leadStuckCounter] };
					// After timeout and leader looks stuck, teleport them to a free space:
					if ( _leadStuckCounter == 5 ) then {
						if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > %2 '%3' leader apparently was stuck, but now he's free.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 1 };
						// Find pos min 10m (_distLimiterFromBldg) from _grpLead but not further 20m, not closer 4m to other obj, not in water, max gradient 0.7, not on shoreline:
						_getOutPos = [_grpLead, _distLimiterFromBldg, (_distLimiterFromBldg * 2), 4, 0, 0.7, 0] call BIS_fnc_findSafePos;
						// Teleport to the safe position out:
						_grpLead setPosATL [_getOutPos # 0, _getOutPos # 1, 0];
						// Destroying the position just in case:
						_getOutPos = nil;
						// Restart the first OCCUPY step:
						[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
			if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 '%2' > OCCUPY > Failed: '%3' has %4 spot(s) to %5 men.", CSWR_txtDebugHeader, _ownerTag, typeOf _building, count _spots, count (units _grp)] };
			// Cooldown to prevent crazy loopings:
			sleep _wait;
			// Restart the first OCCUPY step:
			[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
		};
	// If a building is NOT found:
	} else {
		// Warning message:
		["%1 OCCUPY > An OCCUPY marker looks not close enough or without good range set ('CSWR_occupyMarkerRange') to allowed buildings for OCCUPY movement. New search in %2 secs.", CSWR_txtWarningHeader, _wait] call BIS_fnc_error;
		// Cooldown to prevent crazy loopings:
		sleep _wait;
		// Restart the first OCCUPY step:
		[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
	if ( (count _mkrsOccupy) == 0 ) exitWith { _bldgsSpotsAvailable /* return */ };
	// FIRST STEP: find the buildings for faction marker:
	{  // forEach _mkrsOccupyBLU:
		_bldgsByMkr = nearestObjects [[getMarkerPos _x # 0, getMarkerPos _x # 1, 0], ["HOUSE", "BUILDING"], _range];  // Important: assets from 'building' category generally has no ALIVE option, so they cant be destroy in-game. 'building' category is here to be mapped to check further if one of them is in the CSWR_occupyAcceptableRuins list as exception, because basically no assets that cannot be destroy get in the final list, except those ones in CSWR_occupyAcceptableRuins.
		//_bldgsByMkr = [(getMarkerPos _x) # 0, (getMarkerPos _x) # 1] nearObjects ["HOUSE", _range];  // BACKUP ONLY.
		_bldgsToCheck append _bldgsByMkr;
	} forEach _mkrsOccupy;
	// SECOND STEP: among the buildings found, select only those specific ones:
	{  // forEach _bldgsToCheck:
		// If the building is NOT an ignored one, NOT got its position as ignored also, keep going:
		if ( !(typeOf _x in _ignoredBldgs) && !(getPosATL _x in _ignoredPos) ) then {
			// Check how much spot the building got:
			_spots = [_x] call BIS_fnc_buildingPositions;
			// Crucial: if at least one spot available:
			if ( (count _spots) > 0 ) then { 
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

	params ["_grp", "_faction", "_ownerTag"];
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
	If ( (count _bldgsStillExist) == 0 ) exitWith { 
		// Debug message:
		if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' has no buildings available.", CSWR_txtDebugHeader, _ownerTag, str _grp] };
		// Return:
		_building;
	};
	// From all of them, select one:
	_building = selectRandom _bldgsStillExist;
	// When debug mode on:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' going to 1 of %4 building(s) found.", CSWR_txtDebugHeader, _ownerTag, str _grp, count _bldgsAvailable] };
	if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { 
		if ( (alive _building) || ((typeOf _building) in CSWR_occupyAcceptableRuins) ) then {
			["%1 OCCUPY > '%2' chosen building: %3 / Loc: %4", CSWR_txtDebugHeader, str _grp, typeOf _building, getPosATL _building] call BIS_fnc_error; sleep 5 };
		};
	// Return:
	_building;
};


THY_fnc_CSWR_OCCUPY_remove_unit_from_group = {
	// This function removes a specific unit left behind, and set them to a new group that is allowed to execute also the occupy-movement by itself.
	// Returns nothing.

	params ["_unit", "_ownerTag", "_behavior", "_wait", "_isInVehicle"];
	private ["_newGrp"];

	// Debug message:
	if (CSWR_isOnDebugGlobal) then {
		systemChat format ["%1 OCCUPY > A unit of %2 '%3' has been removed as member to preserve the group movement.", CSWR_txtDebugHeader, _ownerTag, str (group _unit)];
		sleep 5;
	};
	// Create the new group:
	_newGrp = createGroup [side _unit, true];  // [side, deleteWhenEmpty]
	// Add the removed unit to the new group:
	[_unit] joinSilent _newGrp;
	// Cooldown to prevent crazy loopings:
	sleep _wait;
	// Restart the first OCCUPY step:
	[_newGrp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_nearFriendlyPlayers = {
	// This function searches for friendly humam players around a specific unit.
	// Returns _isFriendPlayerClose: bool.

	params ["_unit", "_distLimiterFriendPlayer"];
	private ["_isFriendPlayerClose", "_playersFriendAlive"];

	// WIP IMPORTANT: actually a friendly faction is not been considered here yet :(
	// Initial values:
	_isFriendPlayerClose = false;
	// Main declaration:
	_playersFriendAlive = allPlayers - entities "HeadlessClient_F" select { alive _x && side _x == side _unit };
	{ 
		if ( _x distance _unit < _distLimiterFriendPlayer ) then { _isFriendPlayerClose = true; break };
	} forEach _playersFriendAlive;
	// Return:
	_isFriendPlayerClose;
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

	params ["_building", "_bldgPos", "_grp", "_ownerTag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_wait", "_isInVehicle"];
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
	_compass = [0, 45, 90, 135, 180, 225, 270, 315];
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
						if ( (count _spots) >= _grpSize ) then {
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
									if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' group had its building destroyed.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 1 };
									// Small cooldown to prevent crazy loopings:
									sleep 1;
									// Restart the first OCCUPY step:
									[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
									// Stop the while-looping:
									break;
								};
							// if the building is already occupied for someone else:
							} else {
								// Debug message:
								if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' building is already occupied for someone else.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 1 };
								// Small cooldown to prevent crazy loopings:
								sleep 3;
								// Restart the first OCCUPY step:
								[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
								// Stop the while-looping:
								break;
							};
							// Check if there are friendly players around:
							_isFriendPlayerClose = [_x, _distLimiterFriendPlayer] call THY_fnc_CSWR_nearFriendlyPlayers;
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
								if (alive _x) then { _spots deleteAt (_spots find _spot) };
								// Report the unit is sheltered:
								_alreadySheltered pushBackUnique _x;
								// Stop the while-looping:
								break;
							// Otherwise, if a friendly player around, or enemy around, or leader is engaging:
							} else {
								// Debug message:
								if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-in without teleport.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 3 };
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
							if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 '%2' > OCCUPY > Failed: '%3' has %4 spot(s) to %5 men.", CSWR_txtDebugHeader, _ownerTag, typeOf _building, count _spots, count (units _grp)] };
							// Cooldown to prevent crazy loopings:
							sleep _wait;
							// Restart the first OCCUPY step:
							[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
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
						if CSWR_isOnDebugGlobal then { systemChat format ["%1 > OCCUPY > An incapacitated %2 unit has been killed to preserve the group mobility.", CSWR_txtDebugHeader, _ownerTag] };
						// Kill the AI unit:
						_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
						// Stop the while-looping:
						break;
					};
					// if the unit is too far away from the leader:
					if ( _x distance leader _grp > 120 ) then {
						// Remove the unit from the current group:
						[_x, _ownerTag, _behavior, _wait, _isInVehicle] spawn THY_fnc_CSWR_OCCUPY_remove_unit_from_group;
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
						if (alive _x) then {
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
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy && !(leader _grp checkAIFeature "PATH") && _timeOutToUnit <= 10 ) then { systemChat format ["%1 OCCUPY > %2 '%3' unit should get-in: %4", CSWR_txtDebugHeader, _ownerTag, _x, _timeOutToUnit] };
					sleep 1.5;
				};
				// If the unit or leader has no group anymore (anomaly), kill the former group member:
				if ( isNull (group _x) ) then {
					// Kill:
					_x setDamage 1;  // WIP <------------------------- NOT SURE IF IT WILL RUN PROPER WITH ACE.
					// Debug message:
					if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > A %2 unit needed to be killed to preserve the game integraty (they lost the group ID).", CSWR_txtDebugHeader, _ownerTag]};
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
					systemChat format ["%1 OCCUPY > All %2 '%3' is in a building.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 3;
				} else {
					systemChat format ["%1 OCCUPY > Most of the %2 '%3' is in a building.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 3;
				};
			};
			// Next planned move cooldown:
			sleep (random CSWR_destOccupyTakeabreak);
		// Otherwise:
		} else {
			// Debug message:
			if CSWR_isOnDebugGlobal then { systemChat format ["%1 OCCUPY > %2 '%3' leader would rather move to another building.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 3 };
		};
		// Starts the last stage of OCCUPY function:
		[_grp, _ownerTag, _behavior, _distLimiterFromBldg, _distLimiterEnemy, _distLimiterFriendPlayer, _bldgPos, _wait, _isInVehicle] spawn THY_fnc_CSWR_OCCUPY_doGetOut;
	// If a building is NOT found:
	} else {
		// Warning message:
		["%1 '%2' > OCCUPY > The building doesn't exist anymore. New search in %4 secs.", CSWR_txtWarningHeader, _ownerTag, str _grp, _wait] call BIS_fnc_error; sleep 5;
		// Restart the first OCCUPY step:
		[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	};
	// Return:
	true;
};


THY_fnc_CSWR_OCCUPY_doGetOut = {
	// This function is the last stage of Occupy function where it removes the group from inside the occupied building.
	// Returns nothing.

	params ["_grp", "_ownerTag", "_behavior", "_distLimiterFromBldg", "_distLimiterEnemy", "_distLimiterFriendPlayer", "_bldgPos", "_wait", "_isInVehicle"];
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
				_isFriendPlayerClose = [_x, _distLimiterFriendPlayer] call THY_fnc_CSWR_nearFriendlyPlayers;
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
					if ( CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 OCCUPY > The context asks to %2 '%3' goes-out without teleport.", CSWR_txtDebugHeader, _ownerTag, str _grp]; sleep 3 };
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
	if (CSWR_isOnDebugGlobal && CSWR_isOnDebugOccupy ) then { systemChat format ["%1 '%2' > OCCUPY > %3 building(s) occupied currently.", CSWR_txtDebugHeader, _ownerTag, count CSWR_occupyIgnoredPositions] };	
	// Restart the first OCCUPY step:
	[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_OCCUPY;
	// Return:
	true;
};


THY_fnc_CSWR_HOLD_tracked_vehicle_direction = {
	// This function sets the tracked vehicle in the same direction as the hold-marker set by the mission editor.
	// Return nothing.

	params ["_mkr", "_grp", "_ownerTag"];
	private ["_clockwise", "_vehicle", "_directionToHold", "_dirRelative", "_tolerance"];
	
	// Escape:
	if ( !(vehicle (leader _grp) isKindOf "Tank") && !(vehicle (leader _grp) isKindOf "TrackedAPC") ) exitWith {};
	// Initial values:
	_clockwise = false;
	// Declarations:
	_vehicle = vehicle (leader _grp);
	_directionToHold = markerDir _mkr; 
	_dirRelative = _directionToHold - (getDir _vehicle);
	_tolerance = 2;
	// Force the vehicle doest start to turn when still moving (rare, but happens):
	_vehicle sendSimpleCommand "STOP";
	// Wait the vehicle to brakes:
	sleep 1;
	//
	if ( abs(_dirRelative) > _tolerance ) then {
		
		if ( _dirRelative > 0 ) then {

			if (_dirRelative < 180) then { _clockwise = true };

		} else {

			if (_dirRelative < -180) then { _clockwise = true };
		};

		if ( abs(_dirRelative) > _tolerance ) then { // > 120 

			if (_clockwise) then { _vehicle sendSimpleCommand "RIGHT" } else { _vehicle sendSimpleCommand "LEFT" };
			
			waitUntil { 
				_dirRelative = _directionToHold - (getDir _vehicle);
				if ( _dirRelative > 180 ) then { _dirRelative = abs(360 - _dirRelative) };
				if ( _dirRelative < -180 ) then { _dirRelative = abs(_dirRelative + 360) };
				// 
				if ( abs _dirRelative <= 100 ) exitWith { true };
				false;
			};
			//
			_vehicle sendSimpleCommand "STOPTURNING";
		};
	};
	// Debug message:
	if CSWR_isOnDebugGlobal then { systemChat format ["%1 HOLD > %2 '%3' tracked vehicle hold [Desired %4º | Executed: %5º].", CSWR_txtDebugHeader, _ownerTag, str _grp, _directionToHold, ((getDir _vehicle) - 85)] };
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_HOLD = { 
	// This function sets the group to arrive in a place and make it doesn't move to another place for a long time. It's a looping.
	// Returns nothing.
	
	params ["_grp", "_behavior", "_isInVehicle"];
	private ["_ownerTag", "_destsList", "_isReservedToAnother", "_areaToHoldPos", "_isVehicleTracked", "_areaToHold", "_isReservedNow", "_grpPos", "_wpDisTolerance", "_wp", "_holdReservedAmount", "_attemptCounter", "_attemptTolerance", "_wait"];
	
	// Escape:
	if ( isNull _grp || !alive (leader _grp) ) exitWith {};
	// Debug and warning purposes:
	_ownerTag = [side (leader _grp)] call THY_fnc_CSWR_convertion_faction_to_owner_tag;
	// Initial values:
	_destsList = [];
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
	[_grp, _behavior, _isInVehicle] call THY_fnc_CSWR_group_behavior;
	// Load again the unit individual and original behavior:
	[_grp, _behavior/* , _isInVehicle */] call THY_fnc_CSWR_unit_behavior;
	// Declarations:
	_attemptTolerance = 20;
	_wait = 10;
	// Defining the group markers to be considered:
	switch ( side (leader _grp) ) do {
		case BLUFOR:      { _destsList = CSWR_destsHoldBLU };
		case OPFOR:       { _destsList = CSWR_destsHoldOPF };
		case INDEPENDENT: { _destsList = CSWR_destsHoldIND };
		case CIVILIAN:    { _destsList = CSWR_destsHoldCIV };
	};
	// Check if it's a vehicle and which kind of them:
	if _isInVehicle then {
		// It's a tracked vehicle:
		if ( vehicle (leader _grp) isKindOf "Tank" || vehicle (leader _grp) isKindOf "TrackedAPC" ) then { _isVehicleTracked = true };
	};
	// Looping for select hold-marker:
	_attemptCounter = 0;  // 1/2 usage.
	while { !isNull _grp && _attemptCounter < _attemptTolerance } do {
		// Counter to prevent crazy loops:
		_attemptCounter = _attemptCounter + 1;
		// Check the available HOLD faction markers on map:
		_areaToHold = selectRandom _destsList;
		// If tracked vehicle:
		if ( _isInVehicle && _isVehicleTracked ) then {
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
					["%1 HOLD > Looks it's working with less hold-markers than %2 tracked vehicles using it. ADD MORE %2 HOLD-MARKERS!", CSWR_txtWarningHeader, _ownerTag] call BIS_fnc_error;
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
	_areaToHoldPos = getMarkerPos _areaToHold;  // [x, y]
	// Converting the position to ATL format and defining this as the basic infantry/vehicle position:
	_grpPos = [_areaToHoldPos # 0, _areaToHoldPos # 1, 0];  // converted to [x, y, z].
	
	// CREATING WAYPOINT > IF TRACKED VEHICLE:
	if ( _isInVehicle && _isVehicleTracked ) then {
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
			if _isInVehicle then { sleep 0.25 } else { sleep _wait };
		};  // While-loop ends.
		// Finally creating the infantry / non-tracked vehicles waypoint:
		_wp = _grp addWaypoint [_grpPos, 0]; 
		_wp setWaypointType "HOLD";
		_grp setCurrentWaypoint _wp;
		if ( !_isInVehicle ) then { _wp setWaypointFormation "DIAMOND" };  // better formation for this case!
	};
	// Check if the group is already on their destine:
	waitUntil { sleep _wait; isNull _grp || (leader _grp) distance _grpPos < _wpDisTolerance };
	// Error handling:
	if ( isNull _grp ) exitWith {};
	// AFTER THE ARRIVAL, IF ANY VEHICLE TYPE:
	if _isInVehicle then {
		// Adjust only trached vehicle direction:
		[_areaToHold, _grp, _ownerTag] call THY_fnc_CSWR_HOLD_tracked_vehicle_direction;
		// If editors choice was stealth all vehicles on hold, do it:
		if ( CSWR_isHoldVehLightsOff ) then { _grp setBehaviourStrong "STEALTH" };
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
		if (CSWR_isOnDebugGlobal && CSWR_isOnDebugHold ) then { systemChat format ["%1 HOLD > %3 position(s) got %2 TRACKED VEHICLES on tactical hold currently.", CSWR_txtDebugHeader, _ownerTag, _holdReservedAmount] };
	};
	// Restart the movement:
	[_grp, _behavior, _isInVehicle] spawn THY_fnc_CSWR_go_dest_HOLD;
	// Return:
	true;
};


THY_fnc_CSWR_debug = {
	// This function shows some numbers to the mission editor when debugging.
	// Return nothing.

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
	_aliveAll = { alive _x } count allUnits - playableUnits;
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
