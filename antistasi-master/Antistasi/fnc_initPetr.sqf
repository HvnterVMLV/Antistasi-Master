#include "macros.hpp"
AS_SERVER_ONLY("fnc_initPetr.sqf");

if (!isNil "Petr") then {
    deleteVehicle Petr;
    deleteGroup grupoPetr;
};

grupoPetr = createGroup side_blue;
Petr = grupoPetr createUnit ["B_G_officer_F", getMarkerPos "FIA_HQ", [], 0, "NONE"];
[[Petr,"mission"],"AS_fnc_addAction"] call BIS_fnc_MP;
grupoPetr setGroupId ["Petr","GroupColor4"];
Petr setName "Petr";
Petr disableAI "MOVE";
Petr disableAI "AUTOTARGET";

removeHeadgear Petr;
removeGoggles Petr;
Petr setSkill 1;
[Petr, false] call AS_medical_fnc_setUnconscious;
Petr setVariable ["respawning",false];

call AS_fnc_rearmPetr;

Petr addEventHandler ["HandleDamage",
        {
        private ["_part","_dam","_injurer"];
        _part = _this select 1;
        _dam = _this select 2;
        _injurer = _this select 3;

        if (isPlayer _injurer) then
            {
            [_injurer,60] remoteExec ["AS_fnc_penalizePlayer",_injurer];
            _dam = 0;
            };
        if ((isNull _injurer) or (_injurer == Petr)) then {_dam = 0};
        if (_part == "") then
            {
            if (_dam > 0.95) then
                {
                if (!(Petr call AS_medical_fnc_isUnconscious)) then
                    {
                    _dam = 0.9;
                    [Petr, true] call AS_medical_fnc_setUnconscious;
                    }
                else
                    {
                    Petr removeAllEventHandlers "HandleDamage";
                    };
                };
            };
        _dam
        }];

Petr addMPEventHandler ["mpkilled", {
    removeAllActions Petr;
    private _killer = _this select 1;
    if isServer then {
        diag_log format ["[AS] INFO: Petr died. Killer: %1", _killer];
        if (side _killer == side_red) then {
            [] spawn {
                ["FIA_HQ", "garrison", []] call AS_location_fnc_set;

				// remove 1/2 of every item.
                waitUntil {not AS_S("lockTransfer")};
                AS_Sset("lockTransfer", true);
				([caja, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
				{
					private _values = _x select 1;
					for "_i" from 0 to (count _values - 1) do {
						private _new_value = floor ((_values select _i)/2.0);
						_values set [_i, _new_value];
					};
				} forEach [_cargo_w, _cargo_m, _cargo_i, _cargo_b];

				[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true, true] call AS_fnc_populateBox;
                AS_Sset("lockTransfer", false);

                waitUntil {sleep 5; isPlayer AS_commander};
                [] remoteExec ["AS_fnc_HQselect", AS_commander];
            };
        } else {
            call AS_fnc_initPetr;
        };
    };
}];

publicVariable "grupoPetr";
publicVariable "Petr";
