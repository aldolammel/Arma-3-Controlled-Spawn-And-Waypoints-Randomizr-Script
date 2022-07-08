// File: your_mission\CSWRandomizr\fn_CSWR_debug.sqf
// by thy (@aldolammel)

if (!isServer) exitWith {};

// CSWR CORE / TRY TO CHANGE NOTHING:

[] spawn
{
	while { CSWR_debug } do
	{
		{
			_x addCuratorEditableObjects [allUnits, true];
			_x addCuratorEditableObjects [vehicles, true];
			
		} forEach allCurators;
		
		private _allUnitsAlive = {alive _x} count (allUnits - playableUnits);
		private _bluUnitsAlive = {alive _x} count (units blufor);
		private _opUnitsAlive  = {alive _x} count (units opfor);
		private _indUnitsAlive = {alive _x} count (units independent);
		private _civUnitsAlive = {alive _x} count (units civilian);
		
		format ["\n\n--- DEBUG MONITOR ---\n\nAI's units alive right now: %1\nBlufor units: %2\nOpfor units: %3\nInd units: %4\nCiv units: %5\n\n", _allUnitsAlive, _bluUnitsAlive, _opUnitsAlive, _indUnitsAlive, _civUnitsAlive] remoteExec ["hintSilent"];
		
		sleep 5;
	};
};