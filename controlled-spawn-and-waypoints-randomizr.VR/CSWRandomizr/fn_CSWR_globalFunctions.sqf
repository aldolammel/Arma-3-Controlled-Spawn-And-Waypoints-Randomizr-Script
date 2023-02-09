// CSWR v3.0
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------


THY_fnc_CSWR_is_there_spawn = {
	// This function validates if the earlier spawnpoints configure exist in-game.
	// Return _isThereSpawn: bool.

	params ["_faction", "_spawns"];
	private ["_txtDebugHeader", "_txtWarningHeader", "_txtMsg_1", "_counterExpected", "_counterExist", "_isThereSpawn"];

	// Debug txts:
	_txtDebugHeader = "CSWR DEBUG >";
	_txtWarningHeader = "CSWR WARNING >";
	_txtMsg_1 = "There's no any spawnpoint for the faction";
	// Declarations:
	_counterExpected = count _spawns;
	// Initial values:
	_counterExist = 0;
	_isThereSpawn = false;
	// Looking for at least one existent spawn:
	{ 
		// If the marker has a color, it's because the marker exists LOL:
		if ( (getMarkerColor _x) != "" ) then {  // For some reason, 'isNil' or 'isNull' or 'alive' doesn't work to make a marker existence validation.
			_isThereSpawn = true; 
			_counterExist = _counterExist + 1;
		};
	} forEach _spawns;
	// Error handling > If debug true and number of expected spawns are different of existent spawns, do it:
	if ( CSWR_isOnDebug AND (_counterExpected != _counterExist) ) then {
		systemChat format ["%1 '%2' > From %3 spawn(s) expected, %4 of them are available in-game. Add the missing ones to the mission through Eden Editor.", _txtDebugHeader, _faction, _counterExpected, _counterExist];
	};
	// Error handling > if no spawns registered in file:
	if ( _counterExpected == 0 ) then {
		systemChat format ["%1 '%2' > %3 in 'fn_CSWR_spawnsAndWaypoints.sqf' file. Turn %2 faction as 'false' in there or register at least one %2 spawnpoint in there.", _txtWarningHeader, _faction, _txtMsg_1];
	// Error handling > if at least one spawn registered in file:
	} else {
		// if no spawns markers on map:
		if ( _counterExist == 0 ) then { systemChat format ["%1 '%2' > %3 in-game. The 'fn_CSWR_spawnsAndWaypoints.sqf' file has %4 %2 spawns registered. Add all of them as markers through Eden Editor.", _txtWarningHeader, _faction, _txtMsg_1, _counterExpected]};
	};
	// Return:
	_isThereSpawn;
};


THY_fnc_CSWR_faction_checker = {
	// This function just validates which faction is trying to do something for further validations.
	// Return _factionSign: string.

	params ["_faction"];
	private ["_factionSign"];

	// Initial value:
	_factionSign = "";
	// Case by case:
	switch ( _faction ) do {
		case BLUFOR: { _factionSign = "BLU" };
		case OPFOR: { _factionSign = "OPF" };
		case INDEPENDENT: { _factionSign = "IND" };
		case CIVILIAN: { _factionSign = "CIV" };
	};
	// Return:
	_factionSign;
};


THY_fnc_CSWR_behavior_checker = {
	// This function just validates if there is a valid behavior to the units for further validations.
	// Return _isValidBehavior: bool.

	params ["_behavior"];
	private ["_isValidBehavior"];

	// Initial value:
	_isValidBehavior = false;
	// Error handling:
	_behavior = toUpper _behavior;
	// Main validation:
	if ( _behavior in ["SAFE", "AWARE", "COMBAT", "STEALTH", "CHAOS"] ) then { _isValidBehavior = true };
	// Return:
	_isValidBehavior;
};


THY_fnc_CSWR_destination_checker = {
	// This function just validates if there is at least two destinations to go for further validations.
	// Return _areThereDestinations: bool.

	params ["_destinationType"];
	private ["_areThereDestinations", "_counterExist"];

	// Initial value:
	_areThereDestinations = false;
	_counterExist = 0;
	// Error handling:
	_destinationType = toUpper _destinationType;
	// Main validation:
	switch ( _destinationType ) do {
		case "ANYWHERE": { 	
			{  // Looking for at least one existent destination:
				// If the marker has a color, it's because the marker exists LOL:
				if ( (getMarkerColor _x) != "" ) then { _counterExist = _counterExist + 1 };
			} forEach CSWR_destANYWHERE;
			if ( _counterExist >= 2 ) then { _areThereDestinations = true }; 
		};
		case "PUBLIC": { 
			{  // Looking for at least one existent destination:
				// If the marker has a color, it's because the marker exists LOL:
				if ( (getMarkerColor _x) != "" ) then { _counterExist = _counterExist + 1 };
			} forEach CSWR_destPUBLIC;
			if ( _counterExist >= 2 ) then { _areThereDestinations = true }; 
		};
		case "ONLY_BLU": { 
			{  // Looking for at least one existent destination:
				// If the marker has a color, it's because the marker exists LOL:
				if ( (getMarkerColor _x) != "" ) then { _counterExist = _counterExist + 1 };
			} forEach CSWR_destOnlyBLU;
			if ( _counterExist >= 2 ) then { _areThereDestinations = true };
		};
		case "ONLY_OPF": { 
			{  // Looking for at least one existent destination:
				// If the marker has a color, it's because the marker exists LOL:
				if ( (getMarkerColor _x) != "" ) then { _counterExist = _counterExist + 1 };
			} forEach CSWR_destOnlyOPF;
			if ( _counterExist >= 2 ) then { _areThereDestinations = true };
		};
		case "ONLY_IND": { 
			{  // Looking for at least one existent destination:
				// If the marker has a color, it's because the marker exists LOL:
				if ( (getMarkerColor _x) != "" ) then { _counterExist = _counterExist + 1 };
			} forEach CSWR_destOnlyIND;
			if ( _counterExist >= 2 ) then { _areThereDestinations = true };
		};
	};  // switch ends.
	// Return:
	_areThereDestinations;
};


THY_fnc_CSWR_people = {
	// This function: generates a group of people.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.
	
	params ["_faction","_spawns","_grpType","_behavior","_destinationType"];
	private ["_txtWarningHeader", "_factionSign", "_isValidBehavior", "_areThereDestinations", "_grp"];
	
	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Declarations for Error Handling:
	_factionSign = [_faction] call THY_fnc_CSWR_faction_checker;
	_isValidBehavior = [_behavior] call THY_fnc_CSWR_behavior_checker;
	_areThereDestinations = [_destinationType] call THY_fnc_CSWR_destination_checker;
	// Errors handling:
	if ( (count _grpType) == 0) exitWith { systemChat format ["%1 '%2' > There's no units configurated in a squad. Add them or change the squad type, both in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign] };
	if ( (count _spawns) == 0 ) exitWith { systemChat format ["%1 '%2' > There's no spawnpoints to create people. Check 'fn_CSWR_spawnsAndWaypoints.sqf'.", _txtWarningHeader, _factionSign] };
	if ( !_isValidBehavior ) exitWith { 
		// If the behavior is typed wrong:
		if (_behavior != "") then {
			systemChat format ["%1 '%2' > A squad won't be created 'cause the behavior '%3' it's not part of the expected behavior. Fix it in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign, _behavior];
		// If there is no any hehavior:
		} else {
			systemChat format ["%1 '%2' > A squad won't be created 'cause it has no behavior configured. Fix it in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign];
		};
	};
	// Errors handling > No destination found:
	if ( !_areThereDestinations ) exitWith {
		// If destination has no declare for the unit/vehicle group, alert:
		if ( _destinationType == "" ) then {
			systemChat format ["%1 '%2' > A squad won't be created 'cause the squad destination is empty in 'fn_CSWR_population.sqf' file.", _txtWarningHeader, _factionSign];
		// If destination declared doesn't exist, alert:
		} else {
			systemChat format ["%1 '%2' > A squad won't be created 'cause the destination's type called '%3' has no 2 or more destinations configured. Check the 'fn_CSWR_spawnsAndWaypoints.sqf' file and if the options are dropped as markers on map.", _txtWarningHeader, _factionSign, _destinationType];
		};
	};
	// Declarations:
	_grp = [getMarkerPos (selectRandom _spawns), _faction, _grpType,[],[],[],[],[],180, false, 0] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
	_grp deleteGroupWhenEmpty true;
	// Group config:
	switch (_behavior) do { 
			case "SAFE": {
				_grp setBehaviourStrong "SAFE"; // calm.
				_grp setSpeedMode "LIMITED";  // walk.
				sleep 0.1;
			};
			case "AWARE": {
				_grp setBehaviourStrong "AWARE";  // consern.
				_grp setSpeedMode "LIMITED";  // walk, but guns ready.
				sleep 0.1;
			};
			case "COMBAT": {
				_grp setBehaviourStrong "AWARE";  // guns ready. Dont set "COMBAT" here coz the bevarior will make the group to prone and stuff over and over again.
				_grp setSpeedMode "NORMAL";  // full speed, maintain formation.
				sleep 0.1;
			};
			case "STEALTH": {
				_grp setBehaviourStrong "STEALTH";  // will cause a group to behave in a very cautious manner. 
				_grp setSpeedMode "NORMAL";  // full speed, maintain formation.
				sleep 0.1;
			};
			case "CHAOS": {
				_grp setBehaviourStrong "AWARE";   // Dont set "COMBAT" here coz the bevarior will make the group to prone and stuff over and over again.
				_grp setSpeedMode "FULL";  // do not wait for any other units in formation.
				sleep 0.1;
			};
	};
	// Group leader config:
	// not yet.
	// Each unit config:
	{ 
		switch (_behavior) do {
			case "SAFE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				weaponLowered _x;  // stay the gun low.
				sleep 0.1;
			};
			case "AWARE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				sleep 0.1;
			};
			case "COMBAT": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				sleep 0.1;
			};
			case "STEALTH": {
				_x setUnitCombatMode "GREEN";  // Hold Fire, Disengage.
				sleep 0.1;
			};
			case "CHAOS": {
				_x setUnitCombatMode "RED";  // Fire at will, engage at will/loose formation.
				sleep 0.1;
			};
		};
		
		[_faction, _x] call THY_fnc_CSWR_loadout;
		
	} forEach units _grp;
	// Defining the waypoints:
	switch ( _destinationType ) do {
		case "ANYWHERE": { [_grp] spawn THY_fnc_CSWR_go_ANYWHERE };
		case "PUBLIC": { [_grp] spawn THY_fnc_CSWR_go_dest_PUBLIC };
		case "ONLY_BLU": { [_grp] spawn THY_fnc_CSWR_go_dest_BLU };
		case "ONLY_OPF": { [_grp] spawn THY_fnc_CSWR_go_dest_OPF };
		case "ONLY_IND": { [_grp] spawn THY_fnc_CSWR_go_dest_IND };
	};
	// Adding to Zeus:
	if ( CSWR_isEditableByZeus ) then { {_x addCuratorEditableObjects [units _grp, true]} forEach allCurators };
	// CPU breath:
	sleep 1;
	// Return:
	true;
};


THY_fnc_CSWR_vehicle = {
	// This function: generates a vehicle. Its crew is created automatically.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.
	
	params ["_faction","_spawns","_vehType","_behavior","_destinationType"];
	private ["_txtWarningHeader", "_factionSign", "_isValidBehavior", "_areThereDestinations", "_vehSpawn","_vehPos","_grpVeh", "_veh"];
	
	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Declarations for Error Handling:
	_factionSign = [_faction] call THY_fnc_CSWR_faction_checker;
	_isValidBehavior = [_behavior] call THY_fnc_CSWR_behavior_checker;
	_areThereDestinations = [_destinationType] call THY_fnc_CSWR_destination_checker;
	// Errors handling:
	if (_vehType == "") exitWith { systemChat format ["%1 '%2' > There's no a configured type of vehicle for this faction. Add it or change the vehicle type, both in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign] };
	if ( (count _spawns) == 0 ) exitWith { systemChat format ["%1 '%2' > There's no spawnpoints to create vehicles. Check 'fn_CSWR_spawnsAndWaypoints.sqf'.", _txtWarningHeader, _factionSign] };
	if ( !_isValidBehavior ) exitWith { 
		// If the behavior is typed wrong:
		if (_behavior != "") then {
			systemChat format ["%1 '%2' > A vehicle won't be created 'cause the behavior '%3' it's not part of the expected behavior. Fix it in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign, _behavior];
		// If there is no any hehavior:
		} else {
			systemChat format ["%1 '%2' > A vehicle won't be created 'cause it has no behavior configured. Fix it in 'fn_CSWR_population.sqf'.", _txtWarningHeader, _factionSign];
		};
	};
	// Errors handling > No destination found:
	if ( !_areThereDestinations ) exitWith {
		// If destination has no declare for the unit/vehicle group, alert:
		if ( _destinationType == "" ) then {
			systemChat format ["%1 '%2' > A vehicle won't be created 'cause the vehicle destination is empty in 'fn_CSWR_population.sqf' file.", _txtWarningHeader, _factionSign];
		// If destination declared doesn't exist, alert:
		} else {
			systemChat format ["%1 '%2' > A vehicle won't be created 'cause the destination's type called '%3' has no 2 or more destinations configured. Check the 'fn_CSWR_spawnsAndWaypoints.sqf' file and if the options are dropped as markers on map.", _txtWarningHeader, _factionSign, _destinationType];
		};
	};
	// Declarations:
	_vehSpawn = getMarkerPos (selectRandom _spawns);
	_vehPos = _vehSpawn findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valius might result in explosions and vehicles not spawning.
	// CPU Breath:
	sleep 0.1;
	// Group creation:
	_grpVeh = [_vehPos, _faction, [_vehType],[],[],[],[],[],180, false, 1] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
	_grpVeh deleteGroupWhenEmpty true;
	_veh = vehicle leader _grpVeh;
	// Vehicle behavior:
	_veh setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners never will leave the their vehicle.
	_veh setVehicleReportOwnPosition true;
	_veh setVehicleReceiveRemoteTargets true;
	_veh setVehicleReportRemoteTargets true;
	//_faction reportRemoteTarget [<enemy vehicle>, 60];
	//_veh setVehicleRadar 1;
	//_enemy = "";
	//if (_faction == blufor) then { _enemy = opfor} else { _enemy = blufor };
	//_veh confirmSensorTarget [_enemy, true];
	// Group behavior:
	switch (_behavior) do {
			case "SAFE": {
				_grpVeh setBehaviourStrong "SAFE"; // calm.
				_grpVeh setSpeedMode "LIMITED";  // half speed.
				sleep 0.1;
			};
			case "AWARE": {
				_grpVeh setBehaviourStrong "AWARE";  // consern.
				_grpVeh setSpeedMode "LIMITED";  // half speed.
				sleep 0.1;
			};
			case "COMBAT": {
				_grpVeh setBehaviourStrong "COMBAT";  // much higher combat performance than Aware.
				_grpVeh setSpeedMode "NORMAL";  // full speed, maintain formation.
				sleep 0.1;
			};
			case "STEALTH": {
				_grpVeh setBehaviourStrong "STEALTH";  // will cause a group to behave in a very cautious manner. 
				_grpVeh setSpeedMode "NORMAL";  // full speed, maintain formation.
				sleep 0.1;
			};
			case "CHAOS": {
				_grpVeh setBehaviourStrong "COMBAT";
				_grpVeh setSpeedMode "FULL";  // do not wait for any other units in formation.
				sleep 0.1;
			};
	};
	// Each unit behavior:
	{ 
		switch (_behavior) do {
			case "SAFE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				sleep 0.1;
			};
			case "AWARE": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				sleep 0.1;
			};
			case "COMBAT": { 
				_x setUnitCombatMode "YELLOW";  // Fire at will, keep formation.
				sleep 0.1;
			};
			case "STEALTH": { 
				_x setUnitCombatMode "GREEN";  // Hold Fire, Disengage.
				sleep 0.1;
			};
			case "CHAOS": {
				_x setUnitCombatMode "RED";  // Fire at will, engage at will/loose formation.
				sleep 0.1;
			};
		};
		[_faction, _x] call THY_fnc_CSWR_loadout;

	} forEach units _grpVeh;
	// Defining the waypoints:
	switch ( _destinationType ) do {
		case "ANYWHERE": { [_grpVeh] spawn THY_fnc_CSWR_go_ANYWHERE };
		case "PUBLIC": { [_grpVeh] spawn THY_fnc_CSWR_go_dest_PUBLIC };
		case "ONLY_BLU": { [_grpVeh] spawn THY_fnc_CSWR_go_dest_BLU };
		case "ONLY_OPF": { [_grpVeh] spawn THY_fnc_CSWR_go_dest_OPF };
		case "ONLY_IND": { [_grpVeh] spawn THY_fnc_CSWR_go_dest_IND };
	};
	// Adding to Zeus:
	if ( CSWR_isEditableByZeus ) then {{_x addCuratorEditableObjects [units _grpVeh, true]; _x addCuratorEditableObjects [[vehicle leader _grpVeh], true]} forEach allCurators};
	// CPU Breath:
	sleep 10;  // CRITICAL: helps to avoid veh colissions and explosions at the beggining of the match. Less than 10, heavy vehicles can blow up in spawn. Less than 5, any vehicle can blow up in spawn.
	// Return:
	true;
};


THY_fnc_CSWR_helmetReplacement = {
	// This function replace the old unit's helmet for the new one.
	// Returns nothing.

	params ["_unit", "_newHelmetInfantry", "_newHelmetCrew"];
	private ["_veh", "_driver", "_gunner", "_commander"];
	
	// Initial values:
	_veh = objNull;
	_driver = objNull;
	_gunner = objNull;
	_commander = objNull;
	// removes the helmet/hat/cap/beret if it exists:
	removeHeadgear _unit;
	// Crew: if the unit is inside a vehicle, they are a crew, then...
	if (!isNull objectParent _unit) then {
		_veh = vehicle _unit;
		_driver = driver _veh;
		_gunner = gunner _veh;
		_commander = commander _veh;
		// if the crew is driver, gunner or commander of vehicle, then...
		if ( (_unit == _driver) OR (_unit == _gunner) OR (_unit == _commander) ) then {
			// if the vehicle's type is a heavy ground vehicle, then...
			if ( (_veh isKindOf "Tank") OR (_veh isKindOf "WheeledAPC") OR (_veh isKindOf "TrackedAPC") ) then {
				// it will add the new crew helmet if it exists, otherwise the crew will have no helmet:
				if ( _newHelmetCrew != "" ) then { _unit addHeadgear _newHelmetCrew };
			// if the vehicle's type is other one...
			} else {
				// the crew will get the same helmet of infantry if it exists:
				if ( _newHelmetInfantry != "" ) then { _unit addHeadgear _newHelmetInfantry };
			};
		// if the crew actually is just a infantry spawned inside the vehicle...
		} else {
			// the unit will get the infantry helmet if it exists:
			if ( _newHelmetInfantry != "" ) then { _unit addHeadgear _newHelmetInfantry };
		};

	// Infantry: if the unit is NOT in a vehicle, do it:
	} else {
		// if you set an infantry helmet, it will add the new gear to the unit, otherwise they will have no helmet:
		if ( _newHelmetInfantry != "" ) then { _unit addHeadgear _newHelmetInfantry };
	};
	// Return:
	true;
};


THY_fnc_CSWR_uniformScanner = {
	// This function checks the unit's uniform to understand its current contents in case the mission editor chooses to replace the uniform by a new one.
	// Returns _uniformContent.

	params ["_unit"];
	private ["_uniform", "_uniformContent"];

	// Declarations:
	_uniform = uniform _unit;
	// Error handling:
	if ( _uniform == "" ) exitWith {};
	// Initial values:
	_uniformContent = [];
	// if there's an uniform, then save all its original content:
	if ( _uniform != "" ) then { _uniformContent = uniformItems _unit };
	// Return:
	_uniformContent;
};


THY_fnc_CSWR_vestScanner = {
	// This function checks the unit's vest to understand its current contents in case the mission editor chooses to replace the vest by a new one.
	// Returns _vestContent.

	params ["_unit"];
	private ["_vest", "_vestContent"];

	// Declarations:
	_vest = vest _unit;
	// Initial values:
	_vestContent = [];
	// if there's a backpack, then save all its original content:
	if ( _vest != "" ) then { _vestContent = vestItems _unit };
	// Return:
	_vestContent;
};


THY_fnc_CSWR_backpackScanner = {
	// This function checks the unit's backpack to understand its current contents in case the mission editor chooses to replace the backpack by a new one.
	// Returns _backpackContent.

	params ["_unit"];
	private ["_backpack", "_backpackContent"];

	// Declarations:
	_backpack = backpack _unit;
	// Initial values:
	_backpackContent = [];
	// if there's a backpack, then save all its original content:
	if ( _backpack != "" ) then { _backpackContent = backpackItems _unit };
	// Return:
	_backpackContent;
};


THY_fnc_CSWR_uniformRepacker = {
	// This function add to the new uniform all the old unit's uniform original content.
	// Returns nothing.

	params ["_unit", "_newUniform"];
	private ["_oldUniform", "_oldUniformContent"];

	// Declarations:
	_oldUniform = uniform _unit;
	// Initial values:
	_oldUniformContent = [];
	// if the unit has an uniform:
	if ( _oldUniform != "" ) then {
		// check if there's something inside the uniform:
		_oldUniformContent = [_unit] call THY_fnc_CSWR_uniformScanner;
		removeUniform _unit;
	};
	// if there is a new uniform configured:
	if ( _newUniform != "" ) then {
		_unit forceAddUniform _newUniform;
		// if there's an old uniform and old items, repack the items into the new one:
		if ( (_oldUniform != "") AND ((count _oldUniformContent) > 0) ) then {
			{ _unit addItemToUniform _x } forEach _oldUniformContent;
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_vestRepacker = {
	// This function add to the new vest all the old unit's vest original content.
	// Returns nothing.

	params ["_unit", "_newVest"];
	private ["_oldVest", "_oldVestContent"];

	// Declarations:
	_oldVest = vest _unit;
	// Initial values:
	_oldVestContent = [];
	// if the unit has a vest:
	if ( _oldVest != "" ) then {
		// check if there's something inside the vest:
		_oldVestContent = [_unit] call THY_fnc_CSWR_vestScanner;
		removeVest _unit;
	};
	// if there is a new vest configured:
	if ( _newVest != "" ) then {
		// if the unit had an old vest OR the CSWR is been forced to add vest for each unit, including those ones originally with no vest, do it:
		if ( (_oldVest != "") OR CSWR_isVestForAll ) then {
			_unit addVest _newVest;
			// if there is one or more items from old vest, repack them to the new one:
			if ( (count _oldVestContent) > 0 ) then { { _unit addItemToVest _x } forEach _oldVestContent };
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_backpackRepacker = {
	// This function add to the new backpack all the old unit's backpack original content.
	// Returns nothing.

	params ["_unit", "_newBackpack"];
	private ["_oldBackpack", "_oldBackpackContent"];

	// Declarations:
	_oldBackpack = backpack _unit;
	// Initial values: 
	_oldBackpackContent = [];
	// if the unit has a backpack:
	if ( _oldBackpack != "" ) then {
		// check if there's something inside the backpack:
		_oldBackpackContent = [_unit] call THY_fnc_CSWR_backpackScanner;
		removeBackpack _unit;
	};
	// if there is a new backpack configured:
	if ( _newBackpack != "" ) then {
		// if the unit had an old backpack OR the CSWR is been forced to add backpack for each unit, including those ones originally with no backpack, do it:
		if ( (_oldBackpack != "") OR CSWR_isBackpackForAll ) then {
			_unit addBackpack _newBackpack;
			// if there is one or more items from old backpack, repack them to the new one:
			if ( (count _oldBackpackContent) > 0 ) then { { _unit addItemToBackpack _x } forEach _oldBackpackContent };
		};
	};
	// Return:
	true;
};


THY_fnc_CSWR_go_ANYWHERE = {
	// This function: set the group to move to any destination (sum of all other preset destinations), including exclusive enemy faction destinations.
	// Returns nothing.
	
	params ["_grp"];
	private ["_txtWarningHeader", "_destAnywhere", "_where","_wp"];

	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	_destAnywhere = [];
	// Checking if the destinations exist in-game:
	{  // forEach CSWR_destANYWHERE:
		// If destination exists:
		if ( (getMarkerColor _x) != "" ) then {
			// send it to the units/vehicles go there:
			_destAnywhere append [_x];
		// If destination doesnt exist in-game:
		} else {
			systemChat format ["%1 The destination '%2' ISN'T configured on map yet. Add it on map or delete it from 'fn_CSWR_spawnsAndWaypoints.sqf' file.", _txtWarningHeader, _x];
		};
	} forEach CSWR_destANYWHERE;
	// Declarations:
	_where = getMarkerPos (selectRandom _destAnywhere);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_destTakeabreak;  
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_go_ANYWHERE"];
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_PUBLIC = { 
	// This function: set the group to move through public destinations where civilians and soldiers can go.
	// Returns nothing.
	
	params ["_grp"];
	private ["_txtWarningHeader", "_destPublic", "_where","_wp"];

	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	_destPublic = [];
	// Checking if the destinations exist in-game:
	{  // forEach CSWR_destPUBLIC:
		// If destination exists:
		if ( (getMarkerColor _x) != "" ) then {
			// send it to the units/vehicles go there:
			_destPublic append [_x];
		// If destination doesnt exist in-game:
		} else {
			systemChat format ["%1 The destination '%2' ISN'T configured on map yet. Add it on map or delete it from 'fn_CSWR_spawnsAndWaypoints.sqf' file.", _txtWarningHeader, _x];
		};
	} forEach CSWR_destPUBLIC;
	// Declarations:
	_where = getMarkerPos (selectRandom _destPublic);
	_wp = _grp addWaypoint [_where, 0];
	_wp setWaypointTimeout CSWR_destTakeabreak; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_go_dest_PUBLIC"];
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_BLU = { 
	// This function: set the group to move only through the exclusive blufor destinations.
	// Returns nothing.
	
	params ["_grp"];
	private ["_txtWarningHeader", "_destOnlyBLU", "_where","_wp"];
	
	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	_destOnlyBLU = [];
	// Checking if the destinations exist in-game:
	{  // forEach CSWR_destOnlyBLU:
		// If destination exists:
		if ( (getMarkerColor _x) != "" ) then {
			// send it to the units/vehicles go there:
			_destOnlyBLU append [_x];
		// If destination doesnt exist in-game:
		} else {
			systemChat format ["%1 The destination '%2' ISN'T configured on map yet. Add it on map or delete it from 'fn_CSWR_spawnsAndWaypoints.sqf' file.", _txtWarningHeader, _x];
		};
	} forEach CSWR_destOnlyBLU;
	// Declarations:
	_where = getMarkerPos (selectRandom _destOnlyBLU);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_destTakeabreak;
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_go_dest_BLU"];
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_OPF = { 
	// This function: set the group to move only through the exclusive opfor destinations.
	// Returns nothing.
	
	params ["_grp"];
	private ["_txtWarningHeader", "_destOnlyOPF", "_where","_wp"];
	
	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	_destOnlyOPF = [];
	// Checking if the destinations exist in-game:
	{  // forEach CSWR_destOnlyOPF:
		// If destination exists:
		if ( (getMarkerColor _x) != "" ) then {
			// send it to the units/vehicles go there:
			_destOnlyOPF append [_x];
		// If destination doesnt exist in-game:
		} else {
			systemChat format ["%1 The destination '%2' ISN'T configured on map yet. Add it on map or delete it from 'fn_CSWR_spawnsAndWaypoints.sqf' file.", _txtWarningHeader, _x];
		};
	} forEach CSWR_destOnlyOPF;
	// Declarations:
	_where = getMarkerPos (selectRandom _destOnlyOPF);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_destTakeabreak; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_go_dest_OPF"];
	// Return:
	true;
};


THY_fnc_CSWR_go_dest_IND = {
	// This function: set the group to move only through the exclusive independent destinations.
	// Returns nothing.
	
	params ["_grp"];
	private ["_txtWarningHeader", "_destOnlyIND", "_where","_wp"];
	
	// Debug txts:
	_txtWarningHeader = "CSWR WARNING >";
	// Initial values:
	_destOnlyIND = [];
	// Checking if the destinations exist in-game:
	{  // forEach CSWR_destOnlyIND:
		// If destination exists:
		if ( (getMarkerColor _x) != "" ) then { 
			// send it to the units/vehicles go there:
			_destOnlyIND append [_x];
		// If destination doesnt exist in-game:
		} else {
			systemChat format ["%1 The destination '%2' ISN'T configured on map yet. Add it on map or delete it from 'fn_CSWR_spawnsAndWaypoints.sqf' file.", _txtWarningHeader, _x];
		};
	} forEach CSWR_destOnlyIND;
	// Declarations:
	_where = getMarkerPos (selectRandom _destOnlyIND);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_destTakeabreak; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_go_dest_IND"];
	// Return:
	true;
};


THY_fnc_CSWR_debug = {
	// This function shows some numbers to the mission editor when debugging.
	// Return nothing.

	//params [];
	private ["_allUnitsAlive", "_unitsAliveBLU", "_unitsAliveOPF", "_unitsAliveIND", "_unitsAliveCIV"];

	// Declarations:
	_allUnitsAlive = {alive _x} count (allUnits - playableUnits);
	_unitsAliveBLU = {alive _x} count (units BLUFOR);
	_unitsAliveOPF  = {alive _x} count (units OPFOR);
	_unitsAliveIND = {alive _x} count (units INDEPENDENT);
	_unitsAliveCIV = {alive _x} count (units CIVILIAN);
	// Debug monitor:
	hintSilent format [
		"\n" +
		"\n--- CSWR DEBUG MONITOR ---" +
		"\n" +
		"\nAI's units alive right now: %1" +
		"\nBlufor units: %2" +
		"\nOpfor units: %3" +
		"\nInd units: %4" +
		"\nCiv units: %5" +
		"\n\n",
		_allUnitsAlive,
		_unitsAliveBLU,
		_unitsAliveOPF,
		_unitsAliveIND,
		_unitsAliveCIV
	];
	sleep 5;
	// Return:
	true;
};

// Return:
true;
