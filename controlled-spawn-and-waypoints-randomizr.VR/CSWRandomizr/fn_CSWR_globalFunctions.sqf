// CSWR v2.7
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)


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

		[_faction, _x] call THY_fnc_CSWR_loadout;

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
