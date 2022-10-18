// CSWR v2.7
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// Documentation: https://docs.google.com/document/d/1uFOSXVuf2w_BZxTRIbmuRTrcf5b07Nu2SEGSfdDlXfI/edit?usp=sharing
// by thy (@aldolammel)


// This function: define the faction loadout details for each unit spawned by CSWR. 
// Returns nothing.

params ["_faction", "_unit"];

switch (_faction) do {

	case BLUFOR: {
		// Exclusively for things to unlink and remove:
			_unit unlinkItem "NVGoggles";    // unlink the night vision from the unit head;
			_unit removeItem "NVGoggles";    // remove the night vision from the unit backpack/vest/uniform;
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
			removeHeadgear _unit;    // removes the helmet and facewear from everyone in the faction.

		// Exclusively for Uniform replacement:
			[_unit, "U_B_CTRG_3"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
		
		// Exclusively for Vest replacement:
			[_unit, "V_PlateCarrierL_CTRG"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
		
		// Exclusively for Backpack replacement:
			[_unit, "B_Kitbag_tan"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.
		
		// Exclusively for things to add or link:
			_unit addHeadgear "H_Booniehat_tan";    // add the same helmet or facewear to faction units.
			//_unit addItem "arifle_MXM_Hamr_pointer_F";    // create the item and store it somewhere in the unit inventory.
			//_unit linkItem "arifle_MXM_Hamr_pointer_F";   // assign the item to its specific space in the unit inventory.
			//_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
			//_unit addItem "FirstAidKit";    // create another bandage in unit inventory.
			//_unit addItem "ItemGPS";    // create item to unit inventary.
			//_unit linkItem "ItemGPS";    // assign the  item to the correct slot in unit inventory.
	};

	case OPFOR: {
		// Exclusively for things to unlink and remove:
			_unit unlinkItem "NVGoggles_OPFOR";
			_unit removeItem "NVGoggles_OPFOR";
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
			removeHeadgear _unit;

		// Exclusively for Uniform replacement:
			//[_unit, "U_C_Driver_1_red"] call THY_fnc_CSWR_uniformRepacker;  // add a new uniform to the unit.
		
		// Exclusively for Vest replacement:
			//[_unit, "V_TacVest_brn"] call THY_fnc_CSWR_vestRepacker;  // add a new vest to the unit.
		
		// Exclusively for Backpack replacement:
			//[_unit, "B_Kitbag_rgr"] call THY_fnc_CSWR_backpackRepacker;  // add a new backpack to the unit.

		// Exclusively for things to add or link:
			_unit addHeadgear "H_HelmetB_camo";    // add the same helmet or facewear to faction units.
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
