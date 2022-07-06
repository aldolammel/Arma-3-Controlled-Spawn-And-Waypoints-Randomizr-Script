// File: your_mission\CSWRandomizr\fn_CSWR_globalFunctions.sqf
// by thy (@aldolammel)

// CSWR CORE / TRY TO CHANGE NOTHING:


THY_fnc_CSWR_people = 
{
	// This function: generates a group of people. 
	
	params ["_faction","_spwnPnts","_grpType","_behaviourMode","_combatMode","_speedMode","_wpFunction"];
	private ["_grp"];
	
	_grp = [getMarkerPos (selectRandom _spwnPnts), _faction, _grpType,[],[],[],[],[],180] call BIS_fnc_spawnGroup; 
	_grp setBehaviourStrong str(_behaviourMode);
	_grp setCombatMode str(_combatMode);
	_grp setSpeedMode str(_speedMode);
	[_grp] spawn _wpFunction; 
	sleep 1;
};


THY_fnc_CSWR_vehicle = 
{
	// This function: generates a vehicle. Its crew is created automatically.
	
	params ["_faction","_spwnPnts","_vehType","_behaviourMode","_combatMode","_speedMode","_wpFunction"];
	private ["_vehSpawn","_vehPos","_veh"];
	
	_vehSpawn = getMarkerPos (selectRandom _spwnPnts);
	_vehPos = _vehSpawn findEmptyPosition [30, 100];            // trying to avoid collisions on spawn: [radius, distance]
	_veh = [_vehPos, _faction, _vehType,[],[],[],[],[],180] call BIS_fnc_spawnGroup;  
	_veh setBehaviour str(_behaviourMode);
	_veh setCombatMode str(_combatMode);
	_veh setSpeedMode str(_speedMode);
	[_veh] spawn _wpFunction;
	sleep 5;
};


THY_fnc_CSWR_wpGoToAnywhere =
{ 
	// This function: xxxxxxxxxxx
	
	private ["_where","_wp"];
	params ["_grp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationAnywhere);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;  
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToAnywhere"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestShared = 
{ 
	// This function: xxxxxxxxxxx
	
	private ["_where","_wp"];
	params ["_grp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationShared);
	_wp = _grp addWaypoint [_where, 0];
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestShared"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestBlu = 
{ 
	// This function: xxxxxxxxxxx
	
	private ["_where","_wp"];
	params ["_grp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationBlu);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut;
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestBlu"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestOp = 
{ 
	// This function: xxxxxxxxxxx
	
	private ["_where","_wp"];
	params ["_grp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationOp);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestOp"];
};


// ----------------------------


THY_fnc_CSWR_wpGoToDestInd = 
{	
	// This function: xxxxxxxxxxx
	
	private ["_where","_wp"];
	params ["_grp"];
	
	_where = getMarkerPos (selectRandom CSWR_destinationInd);
	_wp = _grp addWaypoint [_where, 0]; 
	_wp setWaypointTimeout CSWR_wpTimeOut; 
	_wp setWaypointStatements ["true", "[group this] spawn THY_fnc_CSWR_wpGoToDestInd"];
};

