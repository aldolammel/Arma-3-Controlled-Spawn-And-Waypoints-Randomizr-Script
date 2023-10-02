// CSWR v5.5
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)


// This function defines the faction loadout details for each unit spawned by CSWR. 
// Returns nothing.

params ["_faction", "_unit", "_grpType", "_grpSpec"];
//private [];

switch _faction do {

	// BLU
	case BLUFOR: {
		
		// BLU ALL UNITS:
		// To remove or unlink stuff:
		    // Never remove NightVision from here. Use the fn_CSWR_management.sqf to set this.
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

		// BLU INFANTRY UNITS:
		// Loadout replacement / empty ("") will result no changes. To force removal, type "REMOVED":
		    [
		        "U_B_CombatUniform_mcam",  // infantry uniform
		        "H_Booniehat_tan",         // infantry helmet
		        "V_Chestrig_khk",          // infantry vest
		        "B_Carryall_cbr",          // infantry backpack
			
		    _unit, _grpType, _grpSpec] call THY_fnc_CSWR_loadout_infantry_basic;

		// BLU HEAVY CREW UNITS:
		// Loadout replacement / empty ("") will result no changes. To force removal, type "REMOVED":
		    [
		        "H_HelmetCrew_I",       // heavy crew helmet
		        "V_Chestrig_khk",       // heavy crew vest
			
			_unit, _grpType, _grpSpec] call THY_fnc_CSWR_loadout_infantry_heavy_crew;

		// BLU SNIPER GROUP UNITS:
		// Loadout replacement / empty ("") will result no changes. To force removal, type "REMOVED":
		    [
		        "U_B_FullGhillie_lsh",   // sniper uniform
		        "",                      // sniper helmet
		        "",                      // sniper vest
				"",                      // sniper backpack
		        "srifle_EBR_F",          // sniper rifle
		        "20Rnd_762x51_Mag",      // sniper rifle magazine
		        "optic_SOS",             // sniper rifle sight/optics
		        "",                      // sniper rifle rail
		        "muzzle_snds_B",         // sniper rifle muzzle/supressor
		        "",                      // sniper rifle bipod
		        "Rangefinder",           // sniper binoculars (cannot be removed!)

		    _unit, _grpType, _grpSpec] call THY_fnc_CSWR_loadout_infantry_sniper;

		// BLU PARATROOP UNITS:
		// Loadout replacement / empty ("") will result no changes. To force removal, type "REMOVED":
		    [
		        "",                         // Paratrooper uniform
		        "H_HelmetB_light_desert",   // Paratrooper helmet
		        "G_Lowprofile",             // Paratrooper goggles (cannot be removed!)
		        "V_HarnessO_brn",           // Paratrooper vest
		        "B_Parachute",              // Paratrooper Parachute-bag (cannot be removed!)

		    _unit, _grpType, _grpSpec] call THY_fnc_CSWR_loadout_speciality_parachuting;

		// BLU ALL UNITS:
		// To add or link stuff:
		    // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
		    //_unit addItem "arifle_MXM_Hamr_pointer_F";    // create the item and store it somewhere in the unit inventory.
		    //_unit linkItem "arifle_MXM_Hamr_pointer_F";   // assign the item to its specific space in the unit inventory.
		    //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
		    //_unit addItem "FirstAidKit";    // create another bandage in unit inventory.
		    //_unit addItem "ItemGPS";    // create item to unit inventary.
		    //_unit linkItem "ItemGPS";    // assign the  item to the correct slot in unit inventory.
	};

	// OPF
	case OPFOR: {
		// Exclusively for things to unlink and remove:
			// Never remove NightVision from here. Use the fn_CSWR_management.sqf to set this.
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

		// Exclusively for Helmet replacement ["regular helmet classname", "heavy crew helmet classname", _unit, ...]:
		    ["H_HelmetB_camo", "H_Tank_black_F", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Uniform replacement of infantry and crewmen ["uniform classname", _unit, ...]:
		    ["U_O_CombatUniform_ocamo", _unit] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of sniper group ["uniform", "vest", "rifle", "rifle magazine", "rifle sight/optics", "rifle rail", "rifle muzzle/supressor", "rifle bipod", "binoculars", _unit, ...]:
		    ["U_O_FullGhillie_ard", "", "srifle_DMR_01_F", "10Rnd_762x54_Mag", "optic_LRPS", "", "muzzle_snds_B", "", "Rangefinder", _unit, _grpType] call THY_fnc_CSWR_loadout_sniper;  // empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Vest replacement of infantry and crewmen ["vest classname", _unit, ...]:
		    ["", _unit, CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement of infantry and crewmen ["backpack classname", _unit, ...]:
		    ["B_Kitbag_cbr", _unit, CSWR_isBackpackForAll, _isParadrop] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of paratrooper groups ["uniform", "helmet", "goggles", "vest", "Parachute bag classname", _unit, ...]:
		    ["", "", "G_Lowprofile", "", "B_Parachute", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_paratrooper;  // empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for things to add or link:
		    // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
		    //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
	};

	// IND
	case INDEPENDENT: {
		// Exclusively for things to unlink and remove:
			// Never remove NightVision from here. Use the fn_CSWR_management.sqf to set this.
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

		// Exclusively for Helmet replacement ["regular helmet classname", "heavy crew helmet classname", _unit, ...]:
		    ["H_Watchcap_khk", "H_Beret_Colonel", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for Uniform replacement of infantry and crewmen ["uniform classname", _unit, ...]:
		    ["U_BG_Guerrilla_6_1", _unit] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of sniper group ["uniform", "vest", "rifle", "rifle magazine", "rifle sight/optics", "rifle rail", "rifle muzzle/supressor", "rifle bipod", "binoculars", _unit, ...]:
		    ["U_I_GhillieSuit", "", "srifle_GM6_F", "5Rnd_127x108_Mag", "optic_LRPS", "", "", "", "Rangefinder", _unit, _grpType] call THY_fnc_CSWR_loadout_sniper;  // empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Vest replacement of infantry and crewmen ["vest classname", _unit, ...]:
		    ["V_BandollierB_rgr", _unit, CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement of infantry and crewmen ["backpack classname", _unit, ...]:
		    ["B_AssaultPack_rgr", _unit, CSWR_isBackpackForAll, _isParadrop] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of paratrooper groups ["uniform", "helmet", "goggles", "vest", "Parachute bag classname", _unit, ...]:
		    ["", "", "G_Lowprofile", "", "B_Parachute", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_paratrooper;  // empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for things to add or link:
		    // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
		    //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
	};

	// CIV
	case CIVILIAN: {
		// Exclusively for things to unlink and remove:
			_unit unlinkItem "ItemWatch";
			_unit removeItem "ItemWatch";
			_unit unlinkItem "ItemCompass";
			_unit removeItem "ItemCompass";
			_unit unlinkItem "ItemMap";
			_unit removeItem "ItemMap";
			_unit removeItems "FirstAidKit";

		// Exclusively for Caps/Hats replacement ["regular cap/hat classname", "heavy vehicle drivers cap/hat classname", _unit, ...]:
		    ["", "", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_helmet;  // add a new helmet to the unit. Empty means no helmet.
		
		// Exclusively for clothes replacement ["outfit classname", _unit, ...]:
		    ["", _unit] call THY_fnc_CSWR_loadout_uniform;  // add a new uniform to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Vest replacement ["vest classname", _unit, ...]:
		    ["", _unit, CSWR_isVestForAll] call THY_fnc_CSWR_loadout_vest;  // add a new vest to the unit. Empty ("") will result no changes. To remove type "REMOVED".
		
		// Exclusively for Backpack replacement ["backpack classname", _unit, ...]:
		    ["", _unit, CSWR_isBackpackForAll, _isParadrop] call THY_fnc_CSWR_loadout_backpack;  // add a new backpack to the unit. Empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for loadout replacement of parachuter groups ["uniform", "helmet", "goggles", "vest", "Parachute bag classname", _unit, ...]:
		    ["", "", "G_Lowprofile", "", "B_Parachute", _unit, _grpType, _isParadrop] call THY_fnc_CSWR_loadout_paratrooper;  // empty ("") will result no changes. To remove type "REMOVED".

		// Exclusively for things to add or link:
		    //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
	};
};
// Return:
true;
