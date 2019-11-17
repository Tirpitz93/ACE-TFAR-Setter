#include "../config_macros.hpp"
#define PROFILESETTINGS(suffix) ADDON##_Settings_##suffix
#define PROFILESETTINGS_LR PROFILESETTINGS(LR)
#define PROFILESETTINGS_SR PROFILESETTINGS(SR)
#define PROFILESETTINGS_PREF_SR PROFILESETTINGS(Pref_SR)
#define PROFILESETTINGS_PREF_LR PROFILESETTINGS(Pref_LR)
#define PROFILESETTINGS_PREF_LAYOUT PROFILESETTINGS(Pref_Layout)
// #define Q_DIAG_LOG_CHECK __FILE__  //Use: diag_log Q_DIAG_LOG_CHECK; Place in a fnc sqf to see if it is referenced.