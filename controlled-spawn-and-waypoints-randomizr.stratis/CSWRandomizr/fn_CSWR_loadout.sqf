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
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                        // infantry uniform
                "H_Booniehat_tan",         // infantry helmet
                "",                        // infantry goggles
                "V_Chestrig_khk",          // infantry vest (only units with vest will take the custom one)
                "B_Carryall_cbr",          // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // BLU PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_B_CombatUniform_mcam_tshirt",   // Paratrooper uniform
                "H_HelmetB_light_desert",          // Paratrooper helmet
                "",                    // Paratrooper goggles (cannot be "REMOVED")
                "V_HarnessO_brn",                  // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // BLU INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_HelmetCrew_I",          // heavy crew helmet
                "G_Balaclava_lowprofile",  // heavy crew goggles
                "V_Chestrig_khk",          // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // BLU INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "U_B_FullGhillie_sard",  // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "srifle_EBR_F",          // sniper rifle (cannot be "REMOVED")
                "20Rnd_762x51_Mag",      // sniper rifle magazine (cannot be "REMOVED")
                "optic_SOS",             // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "muzzle_snds_B",         // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

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
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "U_O_CombatUniform_ocamo",  // infantry uniform
                "H_HelmetB_camo",           // infantry helmet
                "",                         // infantry goggles
                "V_Chestrig_khk",           // infantry vest (only units with vest will take the custom one)
                "B_Kitbag_cbr",             // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;
        
        // OPF PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratrooper uniform
                "H_HelmetB_light_desert",   // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be "REMOVED")
                "V_HarnessO_brn",           // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // OPF INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "H_Tank_black_F",       // heavy crew helmet
                "",                     // heavy crew goggles
                "V_Chestrig_khk",       // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // OPF INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "U_O_FullGhillie_ard",   // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "srifle_DMR_01_F",       // sniper rifle (cannot be "REMOVED")
                "10Rnd_762x54_Mag",      // sniper rifle magazine (cannot be "REMOVED")
                "optic_LRPS",            // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "muzzle_snds_B",         // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

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
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "U_BG_Guerrilla_6_1",     // infantry uniform
                "H_Watchcap_khk",         // infantry helmet
                "",                       // infantry goggles
                "V_BandollierB_rgr",      // infantry vest (only units with vest will take the custom one)
                "B_AssaultPack_rgr",      // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;
        
        // IND PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                         // Paratrooper uniform
                "REMOVED",                  // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be "REMOVED")
                "V_HarnessO_brn",           // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // IND INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "H_Beret_Colonel",       // heavy crew helmet
                "",                      // heavy crew goggles
                "REMOVED",               // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // IND INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "U_I_GhillieSuit",       // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "srifle_GM6_F",          // sniper rifle (cannot be "REMOVED")
                "5Rnd_127x108_Mag",      // sniper rifle magazine (cannot be "REMOVED")
                "optic_LRPS",            // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "",                      // sniper rifle muzzle/supressor
                "",                      // sniper rifle bipod
                "Rangefinder",           // sniper binoculars (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_sniperGroup;

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
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "RANDOM",                  // Citizen uniform (Only here, use "RANDOM" if you want)
                "",                        // Citizen hat
                "",                        // Citizen goggles
                "",                        // Citizen vest (if used, it'll add to all CIV)
                "",                        // Citizen backpack (if used, it'll add to all CIV)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // CIV PARACHUTERS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                         // Parachuter uniform
                "REMOVED",                  // Parachuter helmet
                "G_Shades_Blue",            // Parachuter goggles (cannot be "REMOVED")
                "V_Chestrig_blk",           // Parachuter vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // CIV ALL POEPLE:
        // To add or link stuff:
            // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
            //_unit addItem "FirstAidKit";    // create just one bandage in person inventory.
    };
};
// Return:
true;
