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
		format ["\n\nAI's units alive right now:\n%1\n\n", _allUnitsAlive] remoteExec ["hint"];
		
		sleep 5;
	};
};