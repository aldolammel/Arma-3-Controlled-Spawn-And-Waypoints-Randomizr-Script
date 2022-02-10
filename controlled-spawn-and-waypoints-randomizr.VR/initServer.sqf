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
			sleep 15;
			_x addCuratorEditableObjects [vehicles, true];
			sleep 15;
		} forEach allCurators;
	};
};