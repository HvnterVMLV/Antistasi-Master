private ["_estatica","_cercano","_jugador"];

_estatica = _this select 0;
_jugador = _this select 1;

if (!alive _estatica) exitWith {hint "Negative. Asset destroyed."};

if (alive gunner _estatica) exitWith {hint "Negative. Asset in use."};

if ((alive assignedGunner _estatica) and (!isPlayer (assignedGunner _estatica))) exitWith {hint "Negative. Gunner still breathing."};

_cercano = _estatica call AS_location_fnc_nearest;

if (_cercano call AS_location_fnc_side == "AAF") exitWith {hint "Negative. Area unsecured."};

_estatica setOwner (owner _jugador);

_tipoEst = typeOf _estatica;
_tipoB1 = "";
_tipoB2 = "";

switch _tipoEst do {
	case statMG: {
		_tipoB1 = statMGBackpacks select 0;
		_tipoB2 = statMGBackpacks select 1;
	};
	case statAA: {
		_tipoB1 = statAABackpacks select 0;
		_tipoB2 = statAABackpacks select 1;
	};
	case statAT: {
		_tipoB1 = statATBackpacks select 0;
		_tipoB2 = statATBackpacks select 1;
	};
	case statMortar: {
		_tipoB1 = statMortarBackpacks select 0;
		_tipoB2 = statMortarBackpacks select 1;
	};
	case statMGlow: {
		_tipoB1 = statMGlowBackpacks select 0;
		_tipoB2 = statMGlowBackpacks select 1;
	};
	case statMGtower: {
		_tipoB1 = statMGtowerBackpacks select 0;
		_tipoB2 = statMGtowerBackpacks select 1;
	};
	default {hint "Negative. Invalid asset."};
	};

_posicion1 = [_jugador, 1, (getDir _jugador) - 90] call BIS_fnc_relPos;
_posicion2 = [_jugador, 1, (getDir _jugador) + 90] call BIS_fnc_relPos;

deleteVehicle _estatica;

if (_tipoB1 == "") exitWith {};

_bag1 = _tipoB1 createVehicle _posicion1;
_bag2 = _tipoB2 createVehicle _posicion2;

[_bag1, "FIA"] call AS_fnc_initVehicle;
[_bag2, "FIA"] call AS_fnc_initVehicle;
