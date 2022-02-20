// YOU DONT NEED THIS FILE IN THIS SCRIPT AT ALL / IT EXISTS JUST FOR TESTING PURPOSES.
// ZEUS SEE EVERTHING ON MAP
[] spawn
{
	while { time < 300 } do
	{
		{
			_x addCuratorEditableObjects [allUnits, true];
			_x addCuratorEditableObjects [vehicles, true];
			
		} forEach allCurators;
		
		private _allUnitsAlive = {alive _x} count (allUnits - playableUnits);
		hint format ["\n\nAI's units alive right now:\n%1\n\n", _allUnitsAlive];
		
		sleep 3;
	};
};