// CSWR v2.1
// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)

// CSWR CORE / TRY TO CHANGE NOTHING ON THIS FILE!!!


THY_fnc_CSWR_people = 
{
	// This function: generates a group of people. 
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	
	params ["_faction","_spwnPnts","_grpType","_behavior","_wpFunction"];
	private ["_grp"];
	
	_grp = [getMarkerPos (selectRandom _spwnPnts), _faction, _grpType,[],[],[],[],[],180, false, 0] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
	_grp deleteGroupWhenEmpty true;
	
	// Group behavior:
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
	
	// Group leader behavior:
	// not yet.
	
	// Each unit behavior:
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
	} forEach units _grp;

	[_grp] spawn _wpFunction; 
	sleep 1;
};


// ----------------------------


THY_fnc_CSWR_vehicle = 
{
	// This function: generates a vehicle. Its crew is created automatically.
	// Native A3 AI behaviours: https://community.bistudio.com/wiki/AI_Behaviour / https://community.bistudio.com/wiki/Combat_Modes / https://community.bistudio.com/wiki/setSpeedMode
	
	params ["_faction","_spwnPnts","_vehType","_behavior","_wpFunction"];
	private ["_vehSpawn","_vehPos","_grpVeh"];
	
	_vehSpawn = getMarkerPos (selectRandom _spwnPnts);
	_vehPos = _vehSpawn findEmptyPosition [10, 300];            // [radius, distance] / IMPORTANT: if decrease these valius might result in explosions and vehicles not spawning.
	sleep 0.1;
	_grpVeh = [_vehPos, _faction, _vehType,[],[],[],[],[],180, true, 1] call BIS_fnc_spawnGroup;  // https://community.bistudio.com/wiki/BIS_fnc_spawnGroup
	_grpVeh deleteGroupWhenEmpty true;
	
	// Vehicle behavior:
	vehicle leader _grpVeh setVehicleReportOwnPosition true;
	vehicle leader _grpVeh setVehicleReceiveRemoteTargets true;
	vehicle leader _grpVeh setVehicleReportRemoteTargets true;
	_faction reportRemoteTarget [vehicle leader _grpVeh, 60];
	//vehicle leader _grpVeh setVehicleRadar 1;
	//_enemy = "";
	//if (_faction == blufor) then { _enemy = opfor} else { _enemy = blufor };
	//vehicle leader _grpVeh  confirmSensorTarget [_enemy, true];
	
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
	sleep 5;            // IMPORTANT: helps to avoid veh colissions and explosions at the beggining of the match.
};


// ----------------------------


THY_fnc_CSWR_wpGoToAnywhere =
{ 
	// This function: set the group to move any waypoint mark on the map.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationAnywhere);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;  
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToAnywhere"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestShared = 
{ 
	// This function: set the group to move only shared waypoint marks on the map.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationShared);
	_wp = _grp addWaypoint [_where, 0];
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestShared"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestBlu = 
{ 
	// This function: set the group to move only BluFor waypoint marks on the map.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationBlu);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestBlu"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestOp = 
{ 
	// This function: set the group to move only OpFor waypoint marks on the map.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationOp);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestOp"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestInd = 
{	
	// This function: set the group to move only Independent waypoint marks on the map.
	
	params ["_grp"];
	private ["_where","_wp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationInd);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestInd"];
};

