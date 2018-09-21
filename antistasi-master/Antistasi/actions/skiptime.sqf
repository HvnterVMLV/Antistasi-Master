private _enemies_around = false;

if (count ("aaf_attack" call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "Negative. Cannot rest while FIA assets are under fire.";
};
if (count ("aaf_attack_hq" call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "Negative. Cannot rest while HQ is under fire.";
};

{
	if ((side _x == side_red) and {[250,_x,"BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance}) exitWith {_enemies_around = true};
} forEach allUnits;
if (_enemies_around) exitWith {hint "Negative. Enemies Close."};

private _all_around = false;
private _posHQ = getMarkerPos "FIA_HQ";
{
	if (_x distance _posHQ > 200) exitWith {_all_around = true};
} forEach (allPlayers - (entities "HeadlessClient_F"));

if _all_around exitWith {hint "All players must be around the HQ to rest"};

[[], "AS_fnc_skipTime"] call BIS_fnc_MP;
