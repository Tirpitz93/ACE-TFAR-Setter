/*
 * Author: M3ales
 * Sets VLR/LR/SR data of current profile
 *
 * Arguments:
 * 0: LR or SR, LR is true (default:true) <BOOLEAN>
 * 1: LR or VLR, VLR is true (default: false) <BOOLEAN>
 * 2: Data to be saved (default: []) <ARRAY>
 
 * Return Value:
 * True if successful, false if unsuccessful
 *
 * Example:
 * [false, []] call CHTR_TFAR_Setter_fnc_setRadioData - SR
 * [true, []] call CHTR_TFAR_Setter_fnc_setRadioData - LR
 * [true, true, []] call CHTR_TFAR_Setter_fnc_setRadioData - VLR
 *
 * Public: No
 */
#include "function_macros.hpp"
#include "defaults.hpp"
params[
	["_lr", true, [true]],
	["_vlr", false, [true]],
	["_value", [], [[]]]
];

_settings = call FUNC(loadSettings);
if(count _settings == 0) exitWith {
	LOG_ERROR(QUOTE(GVAR(SETTINGS) not initialised));
	false
};
_profileIndex = (_settings select CURRENTPROFILE_ID) + 1;
_currentProfile = _settings select _profileIndex; //Selects profile

LOG("Testing Wether LR or SR Radio Will be Set");
if(!_lr && !_vlr) exitWith {
	LOG("Saving SR Radio Data");
	_currentProfile set [SRDATA_INDEX, _value];
	true
};
if(_lr || _vlr) exitWith {
	_currentLR = player call TFAR_fnc_getActiveLR; //current active radio
	_currentLRName = _currentLR select 1;
	_lrData = _currentProfile select LRDATA_INDEX; // Where LR and VLR info is stored in an array
	_lrIndex = LR_INDEX; // Where LR data is inside the array
	_lrIsArrayofArrays = _lrData isEqualTypeArray [[],[]];
	
	if(!(_lrIsArrayofArrays)) then {
		LOG_ERROR("Old settings layout detected");
		_lrNewData = call FUNC(copyLegacyLRData);
		LOG_ERROR("Data Modified into new format");
		_currentProfile set [LRDATA_INDEX, _lrNewData];
		LOG_ERROR("New Format Applied");
	};

	LOG("Testing VLR or LR Radio Get");
	if(!_vlr) then {
		LOG("Saving LR Radio Data");
	} else {
		LOG("Saving Vehicle LR Data");

		_vehicleLR = player call TFAR_fnc_vehicleLR; //current vehicle's radio
		_vehicleLRName = _vehcileLR select 1;
		_lrIndex = VLR_INDEX;

		if (_currentLRName != _vehicleLRName) then {
			_vehicleLR call TFAR_fnc_setActiveLRRadio; //swap to vehicle lr to edit
		};
	};
	if(count _lrData > 0) then { _lrData set [_lrIndex, _value]; }
	else { LOG_ERROR("No LR Data for setting radio. Probably not a good thing."); };

	_currentLR call TFAR_fnc_setActiveLRRadio; //swap back to original radio
	true
};
LOG_ERROR("Unsupported Operation -- Cannot save Vehicle Short Range Radio");
false