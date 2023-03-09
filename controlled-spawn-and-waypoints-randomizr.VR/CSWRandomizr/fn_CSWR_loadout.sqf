// CSWR v4.0.1
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// by thy (@aldolammel)


// This function defines the faction loadout details for each unit spawned by CSWR. 
// Returns nothing.

params ["_faction", "_type", "_unit"];

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
			_unit removeItem "16Rnd_9x21_Mag";
			_unit removeItem "16Rnd_9x21_Mag";
			_unit removeWeapon "Binocular";
			_unit removeWeapon "hgun_P07_F";

		// Exclusively for Helmet replacement [_unit, "regular helmet classname", "heavy crew helmet classname"]:
			[_unit, "H_Booniehat_tan", "H_HelmetSpecB_sand"] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for Uniform replacement of infantry and crewmen [_unit, "uniform classname"]:
			[_unit, "U_B_CTRG_3"] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of sniper team [_type, _unit, "uniform", "vest", "rifle", "rifle magazine", "rifle sight/optics", "rifle rail", "rifle muzzle/supressor", "rifle bipod", "binoculars"]:
			[_type, _unit, "U_B_T_FullGhillie_tna_F", "", "srifle_EBR_F", "20Rnd_762x51_Mag", "optic_DMS", "acc_pointer_IR", "muzzle_snds_B", "", "Rangefinder"] call THY_fnc_CSWR_loadout_team_sniper;  // empty ("") will result no changes. to remove type "removed".
		
		// Exclusively for Vest replacement of infantry and crewmen [_unit, "vest classname"]:
			[_unit, "V_PlateCarrierL_CTRG", CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement of infantry and crewmen [_unit, "backpack classname"]:
			[_unit, "B_Kitbag_tan", CSWR_isBackpackForAll] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for things to add or link:
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
			_unit removeItem "16Rnd_9x21_Mag";
			_unit removeItem "16Rnd_9x21_Mag";
			_unit removeWeapon "Binocular";
			_unit removeWeapon "hgun_Rook40_F";

		// Exclusively for Helmet replacement [_unit, "regular helmet classname", "heavy crew helmet classname"]:
			[_unit, "H_HelmetB_camo", "H_Tank_black_F"] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Uniform replacement of infantry and crewmen [_unit, "uniform classname"]:
			[_unit, "U_BG_Guerilla2_1"] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of sniper team [_type, _unit, "uniform", "vest", "rifle", "rifle magazine", "rifle sight/optics", "rifle rail", "rifle muzzle/supressor", "rifle bipod", "binoculars"]:
			[_type, _unit, "U_O_GhillieSuit", "", "", "", "optic_NVS", "", "", "", "Rangefinder"] call THY_fnc_CSWR_loadout_team_sniper;  // empty ("") will result no changes. to remove type "removed".
		
		// Exclusively for Vest replacement of infantry and crewmen [_unit, "vest classname"]:
			[_unit, "V_TacVest_brn", CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement of infantry and crewmen [_unit, "backpack classname"]:
			[_unit, "", CSWR_isBackpackForAll] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for things to add or link:
			//_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
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
			_unit removeItem "9Rnd_45ACP_Mag";
			_unit removeItem "9Rnd_45ACP_Mag";
			_unit removeWeapon "Binocular";
			_unit removeWeapon "hgun_ACPC2_F";

		// Exclusively for Helmet replacement [_unit, "regular helmet classname", "heavy crew helmet classname"]:
			[_unit, "REMOVED", "H_HelmetCrew_I"] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for Uniform replacement of infantry and crewmen [_unit, "uniform classname"]:
			[_unit, "U_BG_Guerrilla_6_1"] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of sniper team [_type, _unit, "uniform", "vest", "rifle", "rifle magazine", "rifle sight/optics", "rifle rail", "rifle muzzle/supressor", "rifle bipod", "binoculars"]:
			[_type, _unit, "U_O_T_FullGhillie_tna_F", "", "", "", "", "", "", "", "Binocular"] call THY_fnc_CSWR_loadout_team_sniper;  // empty ("") will result no changes. to remove type "removed".
		
		// Exclusively for Vest replacement of infantry and crewmen [_unit, "vest classname"]:
			[_unit, "", CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement of infantry and crewmen [_unit, "backpack classname"]:
			[_unit, "", CSWR_isBackpackForAll] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for things to add or link:
			//_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
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

		// Exclusively for Caps/Hats replacement [_unit, "regular cap/hat classname", "heavy vehicle drivers cap/hat classname"]:
			[_unit, "", ""] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty means no helmet.
		
		// Exclusively for clothes replacement [_unit, "outfit classname"]:
			[_unit, ""] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Vest replacement [_unit, "vest classname"]:
			[_unit, "", CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement [_unit, "backpack classname"]:
			[_unit, "", CSWR_isBackpackForAll] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for things to add or link:
			//_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
	};
};
// Return:
true;
