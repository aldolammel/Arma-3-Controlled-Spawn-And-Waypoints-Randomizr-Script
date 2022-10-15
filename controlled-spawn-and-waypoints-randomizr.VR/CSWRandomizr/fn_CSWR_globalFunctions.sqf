// CSWR v2.6.1
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// Documentation: https://docs.google.com/document/d/1uFOSXVuf2w_BZxTRIbmuRTrcf5b07Nu2SEGSfdDlXfI/edit?usp=sharing
// by thy (@aldolammel)


THY_fnc_CSWR_loadout = {
	// This function: define the faction loadout details for each unit spawned by CSWR. 
	// Returns nothing.
	
	params ["_faction", "_unit"];
	
	switch (_faction) do {

		case BLUFOR: {
			// Exclusively for things to unlink and remove:
				//_unit unlinkItem "NVGoggles";    // unlink the night vision from the unit head;
				//_unit removeItem "NVGoggles";    // remove the night vision from the unit backpack/vest/uniform;
				//_unit removeItems "FirstAidKit";    // it removes all (removeItemS) firstAidKits in unit's inventory;
				_unit unlinkItem "ItemWatch";
				_unit removeItem "ItemWatch";
				_unit unlinkItem "ItemCompass";
				_unit removeItem "ItemCompass";
				_unit unlinkItem "ItemRadio";
				_unit removeItem "ItemRadio";
				_unit unlinkItem "ItemGPS";
				_unit removeItem "ItemGPS";
				_unit unlinkItem "ItemMap";
				_unit removeItem "ItemMap";
				_unit removeWeapon "Binocular";
				//removeHeadgear _unit;    // removes the helmet and facewear from everyone in the faction.

			// Exclusively for Uniform replacement:
				[_unit, "U_C_Driver_2"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
			
			// Exclusively for Vest replacement:
				[_unit, "V_TacVest_blk_POLICE"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
			
			// Exclusively for Backpack replacement:
				[_unit, "B_Bergen_mcamo_F"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.
			
			// Exclusively for things to add or link:
				//_unit addHeadgear "H_HelmetB";    // add the same helmet or facewear to faction units.
				//_unit addItem "arifle_MXM_Hamr_pointer_F";    // create the item and store it somewhere in the unit inventory.
				//_unit linkItem "arifle_MXM_Hamr_pointer_F";   // assign the item to its specific space in the unit inventory.
				//_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
				//_unit addItem "FirstAidKit";    // create another bandage in unit inventory.
				//_unit addItem "ItemGPS";    // create item to unit inventary.
				//_unit linkItem "ItemGPS";    // assign the  item to the correct slot in unit inventory.
		};

		case OPFOR: {
			// Exclusively for things to unlink and remove:
				//_unit unlinkItem "NVGoggles_OPFOR";
				//_unit removeItem "NVGoggles_OPFOR";
				//_unit removeItems "FirstAidKit";
				_unit unlinkItem "ItemWatch";
				_unit removeItem "ItemWatch";
				_unit unlinkItem "ItemCompass";
				_unit removeItem "ItemCompass";
				_unit unlinkItem "ItemRadio";
				_unit removeItem "ItemRadio";
				_unit unlinkItem "ItemGPS";
				_unit removeItem "ItemGPS";
				_unit unlinkItem "ItemMap";
				_unit removeItem "ItemMap";
				_unit removeWeapon "Binocular";

			// Exclusively for Uniform replacement:
				//[_unit, "U_C_Driver_1_red"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
			
			// Exclusively for Vest replacement:
				//[_unit, "V_TacVest_brn"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
			
			// Exclusively for Backpack replacement:
				//[_unit, "B_Kitbag_rgr"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.

			// Exclusively for things to add or link:
				// xxxxxxx
		};

		case INDEPENDENT: {
			// Exclusively for things to unlink and remove:
				//_unit unlinkItem "NVGoggles_INDEP";
				//_unit removeItem "NVGoggles_INDEP";
				//_unit removeItems "FirstAidKit";
				_unit unlinkItem "ItemWatch";
				_unit removeItem "ItemWatch";
				_unit unlinkItem "ItemCompass";
				_unit removeItem "ItemCompass";
				_unit unlinkItem "ItemRadio";
				_unit removeItem "ItemRadio";
				_unit unlinkItem "ItemGPS";
				_unit removeItem "ItemGPS";
				_unit unlinkItem "ItemMap";
				_unit removeItem "ItemMap";
				_unit removeWeapon "Binocular";

			// Exclusively for Uniform replacement:
				//[_unit, "U_C_Driver_1"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
			
			// Exclusively for Vest replacement:
				//[_unit, "V_TacVest_camo"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
			
			// Exclusively for Backpack replacement:
				//[_unit, "B_Kitbag_sgg"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.
			
			// Exclusively for things to add or link:
				// xxxxxxx
		};

		case CIVILIAN: {
			// Exclusively for things to unlink and remove:
				_unit unlinkItem "ItemWatch";
				_unit removeItem "ItemWatch";
				_unit unlinkItem "ItemCompass";
				_unit removeItem "ItemCompass";
				_unit unlinkItem "ItemMap";
				_unit removeItem "ItemMap";
				_unit removeItems "FirstAidKit";

			// Exclusively for Uniform replacement:
				//[_unit, "U_C_Poloshirt_stripped"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
			
			// Exclusively for Vest replacement:
				//[_unit, "xxxxxx"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
			
			// Exclusively for Backpack replacement:
				//[_unit, "xxxxxx"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.

			// Exclusively for things to add or link:
				// xxxxxxx
		};
	};

	true
};


// CSWR CORE / TRY TO CHANGE NOTHING BELOW!!! --------------------------------------------------------------------


THY_fnc_CSWR_uniformScanner = {
	// This function checks the unit's uniform to understand its current contents in case the mission editor chooses to replace the uniform by a new one.
	// Returns _uniformContent.

	params ["_unit"];
	private ["_uniform", "_uniformContent"];

	_uniform = uniform _unit;
	_uniformContent = [];

	// if there's an uniform, then save all its original content:
	if ( _uniform != "" ) then { _uniformContent = uniformItems _unit };

	_uniformContent  //Returning.
};


THY_fnc_CSWR_vestScanner = {
	// This function checks the unit's vest to understand its current contents in case the mission editor chooses to replace the vest by a new one.
	// Returns _vestContent.

	params ["_unit"];
	private ["_vest", "_vestContent"];

	_vest = vest _unit;
	_vestContent = [];

	// if there's a backpack, then save all its original content:
	if ( _vest != "" ) then { _vestContent = vestItems _unit };

	_vestContent  //Returning.
};


THY_fnc_CSWR_backpackScanner = {
	// This function checks the unit's backpack to understand its current contents in case the mission editor chooses to replace the backpack by a new one.
	// Returns _backpackContent.

	params ["_unit"];
	private ["_backpack", "_backpackContent"];

	_backpack = backpack _unit;
	_backpackContent = [];

	// if there's a backpack, then save all its original content:
	if ( _backpack != "" ) then { _backpackContent = backpackItems _unit };

	_backpackContent  //Returning.
};


THY_fnc_CSWR_uniformRepacker = {
	// This function add to the new uniform all the old unit's uniform original content.
	// Returns nothing.

	params ["_unit", "_newUniform"];
	private ["_oldUniform", "_oldUniformContent"];

	_oldUniform = uniform _unit;
	_oldUniformContent = [_unit] call THY_fnc_CSWR_uniformScanner;

	// if there's an uniform, then...
	if ( _oldUniform != "" ) then 
	{
		removeUniform _unit;
		_unit forceAddUniform _newUniform;
		{ _unit addItemToUniform _x } forEach _oldUniformContent;
	};

	true
};


THY_fnc_CSWR_vestRepacker = {
	// This function add to the new vest all the old unit's vest original content.
	// Returns nothing.

	params ["_unit", "_newVest"];
	private ["_oldVest", "_oldVestContent"];

	_oldVest = vest _unit;
	_oldVestContent = [_unit] call THY_fnc_CSWR_vestScanner;

	// if there's a vest, then...
	if ( _oldVest != "" OR CSWR_vestForAll ) then 
	{
		removeVest _unit;
		_unit addVest _newVest;
		{ _unit addItemToVest _x } forEach _oldVestContent;
	};

	true
};


THY_fnc_CSWR_backpackRepacker = {
	// This function add to the new backpack all the old unit's backpack original content.
	// Returns nothing.

	params ["_unit", "_newBackpack"];
	private ["_oldBackpack", "_oldBackpackContent"];

	_oldBackpack = backpack _unit;
	_oldBackpackContent = [_unit] call THY_fnc_CSWR_backpackScanner;

	// if there's a backpack, then...
	if ( _oldBackpack != "" OR CSWR_backpackForAll ) then 
	{
		removeBackpack _unit;
		_unit addBackpack _newBackpack;
		{ _unit addItemToBackpack _x } forEach _oldBackpackContent;
	};

	true
};


THY_fnc_CSWR_people = {
	// This function: generates a group of people. 
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.
	
	params ["_faction","_spwnPnts","_grpType","_behavior","_wpFunction"];
	private ["_grp"];
	
	_grp = [getMarkerPos (selectRandom _spwnPnts), _faction, _grpType,[],[],[],[],[],180, false, 0] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
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

	[_grp] spawn _wpFunction; 
	
	if ( CSWR_editableByZeus ) then {{_x addCuratorEditableObjects [units _grp, true]} forEach allCurators};
	
	sleep 1;

	true
};


THY_fnc_CSWR_vehicle = {
	// This function: generates a vehicle. Its crew is created automatically.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	// Returns nothing.
	
	params ["_faction","_spwnPnts","_vehType","_behavior","_wpFunction"];
	private ["_vehSpawn","_vehPos","_grpVeh"];
	
	_vehSpawn = getMarkerPos (selectRandom _spwnPnts);
	_vehPos = _vehSpawn findEmptyPosition [10, 300];  // [radius, distance] / IMPORTANT: if decrease these valius might result in explosions and vehicles not spawning.
	sleep 0.1;
	_grpVeh = [_vehPos, _faction, _vehType,[],[],[],[],[],180, true, 1] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
	_grpVeh deleteGroupWhenEmpty true;
	
	// Vehicle behavior:
	(vehicle leader _grpVeh) setUnloadInCombat [true, false];  // [allowCargo, allowTurrets] / Gunners never will leave the their vehicle.
	(vehicle leader _grpVeh) setVehicleReportOwnPosition true;
	(vehicle leader _grpVeh) setVehicleReceiveRemoteTargets true;
	(vehicle leader _grpVeh) setVehicleReportRemoteTargets true;
	_faction reportRemoteTarget [vehicle leader _grpVeh, 60];
	//(vehicle leader _grpVeh) setVehicleRadar 1;
	//_enemy = "";
	//if (_faction == blufor) then { _enemy = opfor} else { _enemy = blufor };
	//(vehicle leader _grpVeh) confirmSensorTarget [_enemy, true];
	
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
	} forEach units _grpVeh;
	
	[_grpVeh] spawn _wpFunction;
	
	if ( CSWR_editableByZeus ) then {{_x addCuratorEditableObjects [units _grpVeh, true]; _x addCuratorEditableObjects [[vehicle leader _grpVeh], true]} forEach allCurators};
	
	sleep 5;  // IMPORTANT: helps to avoid veh colissions and explosions at the beggining of the match.

	true
};


THY_fnc_CSWR_wpGoToAnywhere = { 
	// This function: set the group to move any waypoint mark on the map.
	// Returns nothing.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationAnywhere);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;  
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToAnywhere"];

	true
};


THY_fnc_CSWR_wpGoToDestShared = { 
	// This function: set the group to move only shared waypoint marks on the map.
	// Returns nothing.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationShared);
	_wp = _grp addWaypoint [_where, 0];
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestShared"];

	true
};


THY_fnc_CSWR_wpGoToDestBlu = { 
	// This function: set the group to move only BluFor waypoint marks on the map.
	// Returns nothing.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationBlu);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestBlu"];

	true
};


THY_fnc_CSWR_wpGoToDestOp = { 
	// This function: set the group to move only OpFor waypoint marks on the map.
	// Returns nothing.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationOp);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestOp"];

	true
};


THY_fnc_CSWR_wpGoToDestInd = {
	// This function: set the group to move only Independent waypoint marks on the map.
	// Returns nothing.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationInd);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestInd"];

	true
};
