#include "../macros.hpp"
if AS_S("blockCSAT") exitWith {
	hint "OPFOR frequencies already jammed.";
};
if (AS_S("timeToNextJam") > dateToNumber date) exitWith {
	hint format ["Negative. No technicians available. Wait %1 minutes", AS_S("timeToNextJam")];
};

private _antenasFIA = 0;
{
	private _location = _x call AS_location_fnc_nearest;
	if (_location call AS_location_fnc_side == "FIA") then {
		_antenasFIA = _antenasFIA + 1
	};
} forEach AS_P("antenasPos_alive");

private _jDuration = 20 + (_antenasFIA * 10);
private _cd = 20 + (_antenasFIA * 20);

hint format ["OPFOR has lost radio signal. Attack operations have been delayed for the next %1 minutes.", _jDuration];

private _jtime = dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + _cd];

AS_Sset("timeToNextJam", _jtime);
AS_Sset("blockCSAT", true);
sleep (_jDuration * 60);
AS_Sset("blockCSAT", false);
