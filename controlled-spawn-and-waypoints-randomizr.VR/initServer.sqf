// Call the script only on server
null=[] execVM "controlledSpawnAndWpsRandomizr.sqf";
	
// ZEUS SEE EVERTHING ON MAP
[] spawn
{
	while {true} do
	{
		{
			sleep 5;
			_x addCuratorEditableObjects [allUnits, true];
			_x addCuratorEditableObjects [vehicles, true];
			sleep 120;
		} forEach allCurators;
	};
};