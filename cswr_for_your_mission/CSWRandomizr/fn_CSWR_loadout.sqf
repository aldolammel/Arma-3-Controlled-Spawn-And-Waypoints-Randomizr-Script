// CSWR v7.0
// File: your_mission\CSWRandomizr\fn_CSWR_loadout.sqf
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
// by thy (@aldolammel)


if !CSWR_isOn exitWith {};

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
            //_unit unlinkItem "ItemRadio";  // Carefull coz a unit without radio can't receive/give orders or share knowledge with other groups far away.
            //_unit removeItem "ItemRadio";
            _unit unlinkItem "ItemGPS";
            _unit removeItem "ItemGPS";
            _unit unlinkItem "ItemMap";
            _unit removeItem "ItemMap";
            //_unit removePrimaryWeaponItem "acc_pointer_IR";
            //_unit removePrimaryWeaponItem "optic_Arco_AK_lush_F";
            //_unit removePrimaryWeaponItem "optic_Holosight_lush_F";
            //_unit removeItem "16Rnd_9x21_Mag";
            //_unit removeItem "16Rnd_9x21_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_P07_F";

        // BLU ROLE > INFANTRY:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                       // Infantry uniform
                "",                       // Infantry helmet
                "",                       // Infantry goggles
                "",                       // Infantry vest (only units with vest will take the custom one)
                "",                       // Infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // BLU ROLE > MARINES:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Marine uniform
                "REMOVED",               // Marine helmet
                "G_B_Diving",            // Marine goggles
                "",                      // Marine vest
                "",                      // Marine backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_marines;

        // BLU ROLE > PARATROOPS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratroop uniform
                "",                         // Paratroop helmet
                "G_Lowprofile",             // Paratroop goggles
                "",                         // Paratroop vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_paratroops;

        // BLU ROLE > HEAVY CREW:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_HelmetCrew_I",        // Heavy crew helmet
                "",                      // Heavy crew goggles
                "",                      // Heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_heavyCrew;

        // BLU ROLE > INF. SNIPER GROUP:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Sniper uniform
                "",                      // Sniper helmet
                "",                      // Sniper goggles
                "",                      // Sniper vest (cannot be "REMOVED")
                "",                      // Sniper backpack
                "",                      // Sniper rifle (cannot be "REMOVED")
                "",                      // Sniper rifle magazine (cannot be "REMOVED")
                "",                      // Sniper rifle sight/optics
                "",                      // Sniper rifle rail
                "",                      // Sniper rifle muzzle/supressor
                "",                      // Sniper rifle bipod
                "Rangefinder",           // Sniper binoculars (cannot be "REMOVED")

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
            //_unit unlinkItem "ItemRadio";  // Carefull coz a unit without radio can't receive/give orders or share knowledge with other groups far away.
            //_unit removeItem "ItemRadio";
            _unit unlinkItem "ItemGPS";
            _unit removeItem "ItemGPS";
            _unit unlinkItem "ItemMap";
            _unit removeItem "ItemMap";
            //_unit removePrimaryWeaponItem "acc_pointer_IR";
            //_unit removePrimaryWeaponItem "optic_Arco_AK_lush_F";
            //_unit removePrimaryWeaponItem "optic_Holosight_lush_F";
            //_unit removeItem "16Rnd_9x21_Mag";
            //_unit removeItem "16Rnd_9x21_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_Rook40_F";

        // OPF ROLE > INFANTRY:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                       // Infantry uniform
                "",                       // Infantry helmet
                "",                       // Infantry goggles
                "",                       // Infantry vest (only units with vest will take the custom one)
                "",                       // Infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // OPF ROLE > MARINES:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Marine uniform
                "REMOVED",               // Marine helmet
                "G_O_Diving",            // Marine goggles
                "",                      // Marine vest
                "",                      // Marine backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_marines;
        
        // OPF ROLE > PARATROOPS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratroop uniform
                "",                         // Paratroop helmet
                "G_Lowprofile",             // Paratroop goggles
                "",                         // Paratroop vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_paratroops;

        // OPF ROLE > HEAVY CREW:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_Tank_black_F",        // Heavy crew helmet
                "",                      // Heavy crew goggles
                "",                      // Heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_heavyCrew;

        // OPF ROLE > INF. SNIPER GROUP:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Sniper uniform
                "",                      // Sniper helmet
                "",                      // Sniper goggles
                "",                      // Sniper vest (cannot be "REMOVED")
                "",                      // Sniper backpack
                "",                      // Sniper rifle (cannot be "REMOVED")
                "",                      // Sniper rifle magazine (cannot be "REMOVED")
                "",                      // Sniper rifle sight/optics
                "",                      // Sniper rifle rail
                "",                      // Sniper rifle muzzle/supressor
                "",                      // Sniper rifle bipod
                "Laserdesignator",           // Sniper binoculars (cannot be "REMOVED")

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
            //_unit unlinkItem "ItemRadio";  // Carefull coz a unit without radio can't receive/give orders or share knowledge with other groups far away.
            //_unit removeItem "ItemRadio";
            _unit unlinkItem "ItemGPS";
            _unit removeItem "ItemGPS";
            _unit unlinkItem "ItemMap";
            _unit removeItem "ItemMap";
            //_unit removePrimaryWeaponItem "acc_pointer_IR";
            //_unit removePrimaryWeaponItem "optic_Arco_AK_lush_F";
            //_unit removePrimaryWeaponItem "optic_Holosight_lush_F";
            //_unit removeItem "9Rnd_45ACP_Mag";
            //_unit removeItem "9Rnd_45ACP_Mag";
            _unit removeWeapon "Binocular";
            //_unit removeWeapon "hgun_ACPC2_F";

        // IND ROLE > INFANTRY:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "",                       // Infantry uniform
                "",                       // Infantry helmet
                "",                       // Infantry goggles
                "",                       // Infantry vest (only units with vest will take the custom one)
                "",                       // Infantry backpack (only units with backpack will take the custom one)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // IND ROLE > MARINES:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Marine uniform
                "REMOVED",               // Marine helmet
                "G_I_Diving",            // Marine goggles
                "",                      // Marine vest
                "",                      // Marine backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_marines;
        
        // IND ROLE > PARATROOPS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Paratroop uniform
                "",                         // Paratroop helmet
                "G_Lowprofile",             // Paratroop goggles
                "",                         // Paratroop vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_paratroops;

        // IND ROLE > HEAVY CREW:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "H_Tank_eaf_F",          // Heavy crew helmet
                "",                      // Heavy crew goggles
                "",                      // Heavy crew vest

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_heavyCrew;

        // IND ROLE > INF. SNIPER GROUP:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                      // Sniper uniform
                "",                      // Sniper helmet
                "",                      // Sniper goggles
                "",                      // Sniper vest (cannot be "REMOVED")
                "",                      // Sniper backpack
                "",                      // Sniper rifle (cannot be "REMOVED")
                "",                      // Sniper rifle magazine (cannot be "REMOVED")
                "",                      // Sniper rifle sight/optics
                "",                      // Sniper rifle rail
                "",                      // Sniper rifle muzzle/supressor
                "",                      // Sniper rifle bipod
                "Rangefinder",           // Sniper binoculars (cannot be "REMOVED")

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
            //_unit unlinkItem "ItemWatch";
            //_unit removeItem "ItemWatch";
            _unit unlinkItem "ItemCompass";
            _unit removeItem "ItemCompass";
            _unit unlinkItem "ItemMap";
            _unit removeItem "ItemMap";

        // CIV ROLE > CITIZENS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED" in uppercase:
            [
                "RANDOM",                  // Citizen uniform (Only for CIV, use "RANDOM" if you wanna use specific clothes listed in CSWR_civOutfits management)
                "",                        // Citizen hat
                "",                        // Citizen goggles
                "",                        // Citizen vest (if used, it'll add to all CIV)
                "",                        // Citizen backpack (if used, it'll add to all CIV)

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_infantry_basicGroup;

        // CIV ROLE > SWIMMERS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "REMOVED",               // Swimmers uniform
                "REMOVED",               // Swimmers helmet
                "G_Diving",              // Swimmers goggles
                "REMOVED",               // Swimmers vest
                "REMOVED",               // Swimmers backpack

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_marines;
        
            // CIV ROLE > PARACHUTERS:
        // Loadout replacement / empty ("") results no change. To force removal, type "REMOVED":
            [
                "",                         // Parachuter uniform
                "REMOVED",                  // Parachuter helmet
                "G_Shades_Blue",            // Parachuter goggles
                "V_RebreatherB",            // Parachuter vest (cannot be "REMOVED")

            _unit, _grpType, _grpSpec, _tag] call THY_fnc_CSWR_loadout_paratroops;

        // CIV ALL POEPLE:
        // To add or link stuff:
            // Never add NightVision from here. Use the fn_CSWR_management.sqf to set this.
            //_unit addItem "FirstAidKit";    // create just one bandage in person inventory.
    };
};
// Return:
true;