// ATTENCION: if you already have a init.sqf file in your mission, just include the lines below in that file. 




// CSWR > HIDE THE SCRIPT MARKERS:
// Documentation: https://github.com/aldolammel/Arma-3-Controlled-Spawn-And-Waypoints-Randomizr-Script/blob/main/_CSWR_Script_Documentation.pdf
if (!CSWR_isOn || !CSWR_isOnDebug) then {if !isMultiplayer then {uiSleep 1};{private _mkr = toUpper _x; private _mkrChecking = _mkr splitString CSWR_spacer; if (_mkrChecking find CSWR_prefix isNotEqualTo -1) then {_x setMarkerAlpha 0}} forEach allMapMarkers};