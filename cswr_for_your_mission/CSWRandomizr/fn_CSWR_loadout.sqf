// CSWR v6.5.2
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)


// This function defines the side loadout details for each unit spawned by CSWR. 
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
            //_unit removePrimaryWeaponItem  "acc_pointer_IR";
			//_unit removePrimaryWeaponItem  "optic_Arco_AK_lush_F";
			//_unit removePrimaryWeaponItem  "optic_Holosight_lush_F";
            //_unit removeItem "16Rnd_9x21_Mag";
            //_unit removeItem "16Rnd_9x21_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_P07_F";

        // BLU INFANTRY UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",          // infantry uniform
                "",          // infantry helmet
                "",          // infantry goggles
                "",          // infantry vest (only units with vest will take the custom one)
                "",          // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // BLU PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                 // Paratrooper uniform
                "",                 // Paratrooper helmet
                "G_Lowprofile",     // Paratrooper goggles (cannot be "REMOVED")
                "",                 // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // BLU INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",               // heavy crew helmet
                "",               // heavy crew goggles
                "",               // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // BLU INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                      // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "",                      // sniper rifle (cannot be "REMOVED")
                "",                      // sniper rifle magazine (cannot be "REMOVED")
                "",                      // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "",                      // sniper rifle muzzle/supressor
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
            //_unit removeItem "16Rnd_9x21_Mag";
            //_unit removeItem "16Rnd_9x21_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_Rook40_F";

        // OPF INFANTRY UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                         // infantry uniform
                "",                         // infantry helmet
                "",                         // infantry goggles
                "",                         // infantry vest (only units with vest will take the custom one)
                "",                         // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;
        
        // OPF PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratrooper uniform
                "",                         // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be "REMOVED")
                "",                         // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // OPF INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                     // heavy crew helmet
                "",                     // heavy crew goggles
                "",                     // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // OPF INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "",                      // sniper rifle (cannot be "REMOVED")
                "",                      // sniper rifle magazine (cannot be "REMOVED")
                "",                      // sniper rifle sight/optics
                "",                      // sniper rifle rail
                "",                      // sniper rifle muzzle/supressor
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
            //_unit removeItem "9Rnd_45ACP_Mag";
            //_unit removeItem "9Rnd_45ACP_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_ACPC2_F";

        // IND INFANTRY UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                       // infantry uniform
                "",                       // infantry helmet
                "",                       // infantry goggles
                "",                       // infantry vest (only units with vest will take the custom one)
                "",                       // infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;
        
        // IND PARATROOP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                         // Paratrooper uniform
                "",                         // Paratrooper helmet
                "G_Lowprofile",             // Paratrooper goggles (cannot be "REMOVED")
                "",                         // Paratrooper vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_specialityParachuting;

        // IND INF. HEAVY CREW UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                      // heavy crew helmet
                "",                      // heavy crew goggles
                "",                      // heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_heavyCrewGroup;

        // IND INF. SNIPER GROUP UNITS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                      // sniper uniform
                "",                      // sniper helmet
                "",                      // sniper goggles
                "",                      // sniper vest (cannot be "REMOVED")
                "",                      // sniper backpack
                "",                      // sniper rifle (cannot be "REMOVED")
                "",                      // sniper rifle magazine (cannot be "REMOVED")
                "",                      // sniper rifle sight/optics
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
