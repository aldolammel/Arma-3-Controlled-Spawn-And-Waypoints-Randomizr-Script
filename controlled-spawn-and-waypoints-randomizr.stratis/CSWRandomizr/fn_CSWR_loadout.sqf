// CSWR v5.5
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)


// This function defines the faction loadout details for each unit spawned by CSWR. 
// Returns nothing.

params ["_tag", "_unit", "_grpType", "_grpSpec"];
//private [];

switch _tag do {

    // BLUFOR
    case "BLU": {

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
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                        // infantry uniform
                "H_Booniehat_tan",         // infantry helmet
                "V_Chestrig_khk",          // infantry vest
                "B_Carryall_cbr",          // infantry backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // BLU HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_HelmetCrew_I",       // heavy crew helmet
                "V_Chestrig_khk",       // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // BLU SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_B_FullGhillie_lsh",   // sniper uniform
                "REMOVED",               // sniper helmet
                "",                      // sniper vest (cannot be removed!)
                "REMOVED",               // sniper backpack
                "srifle_EBR_F",          // sniper rifle
                "20Rnd_762x51_Mag",      // sniper rifle magazine
                "optic_SOS",             // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "muzzle_snds_B",         // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

        // BLU PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_B_CombatUniform_mcam_tshirt",   // Paratrooper uniform
                "H_HelmetB_light_desert",          // Paratrooper helmet
                "G_Lowprofile",                    // Paratrooper goggles (cannot be removed!)
                "V_HarnessO_brn",                  // Paratrooper vest (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_speciality_parachuting;

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


    // OPFOR
    case "OPF": {

        // OPF ALL UNITS:
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
            _unit removeWeapon "hgun_Rook40_F";

        // OPF INFANTRY UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_O_CombatUniform_ocamo",  // infantry uniform
                "H_HelmetB_camo",           // infantry helmet
                "V_Chestrig_khk",           // infantry vest
                "B_Kitbag_cbr",             // infantry backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // OPF HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_Tank_black_F",       // heavy crew helmet
                "V_Chestrig_khk",       // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // OPF SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_O_FullGhillie_ard",   // sniper uniform
                "REMOVED",               // sniper helmet
                "",                      // sniper vest (cannot be removed!)
                "REMOVED",               // sniper backpack
                "srifle_DMR_01_F",       // sniper rifle
                "10Rnd_762x54_Mag",      // sniper rifle magazine
                "optic_LRPS",            // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "muzzle_snds_B",         // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

        // OPF PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratrooper uniform
                "H_HelmetB_light_desert",   // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be removed!)
                "V_HarnessO_brn",           // Paratrooper vest (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_speciality_parachuting;

        // OPF ALL UNITS:
        // To add or link stuff:
            // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
            //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
    };


    // INDEPENDENT
    case "IND": {

        // IND ALL UNITS:
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
            _unit removeItem "9Rnd_45ACP_Mag";
            _unit removeItem "9Rnd_45ACP_Mag";
            _unit removeWeapon "Binocular";
            _unit removeWeapon "hgun_ACPC2_F";

        // IND INFANTRY UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_BG_Guerrilla_6_1",     // infantry uniform
                "H_Watchcap_khk",         // infantry helmet
                "V_BandollierB_rgr",      // infantry vest
                "B_AssaultPack_rgr",      // infantry backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // IND HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_Beret_Colonel",       // heavy crew helmet
                "REMOVED",               // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // IND SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_I_GhillieSuit",       // sniper uniform
                "REMOVED",               // sniper helmet
                "",                      // sniper vest (cannot be removed!)
                "REMOVED",               // sniper backpack
                "srifle_GM6_F",          // sniper rifle
                "5Rnd_127x108_Mag",      // sniper rifle magazine
                "optic_LRPS",            // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "",                      // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

        // IND PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratrooper uniform
                "REMOVED",                  // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be removed!)
                "V_HarnessO_brn",           // Paratrooper vest (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_speciality_parachuting;

        // IND ALL UNITS:
        // To add or link stuff:
            // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
            //_unit addItem "FirstAidKit";    // create just one bandage in unit inventory.
    };


    // CIVILIAN
    case "CIV": {

        // CIV ALL PEOPLE:
        // To remove or unlink stuff:
            // Never remove NightVision from here. Use the fn_CSWR_management.sqf to set this.
            _unit removeItems "FirstAidKit";    // it removes all (removeItemS) firstAidKits in person inventory;
            _unit unlinkItem "ItemWatch";
            _unit removeItem "ItemWatch";
            _unit unlinkItem "ItemCompass";
            _unit removeItem "ItemCompass";
            _unit unlinkItem "ItemMap";
            _unit removeItem "ItemMap";

        // CIV CITIZENS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                        // Citizen uniform
                "",                        // Citizen hat
                "",                        // Citizen vest
                "",                        // Citizen backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // CIV PARACHUTERS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Parachuter uniform
                "REMOVED",                  // Parachuter helmet
                "G_Shades_Blue",            // Parachuter goggles (cannot be removed!)
                "V_Chestrig_blk",           // Parachuter vest (cannot be removed!)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_speciality_parachuting;

        // CIV ALL POEPLE:
        // To add or link stuff:
            // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
            //_unit addItem "FirstAidKit";    // create just one bandage in person inventory.
    };

};
// Return:
true;
