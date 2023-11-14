// ATTENCION: if you already have a init.sqf file in your mission, just include the lines below in that file. 



// CSWR > HIDE THE SCRIPT MARKERS:
// Documentation: your_mission\CSWRandomizr\_CSWR_Script_Documentation.pdf
if !CSWR_isOnDebugGlobal then {{private _mkr = toUpper _x; private _mkrChecking = _mkr splitString "_"; if (_mkrChecking find "CSWR" != -1) then {_x setMarkerAlpha 0}} forEach allMapMarkers};