#include "smathev.h"
#include "casemodes.h"
#include "autoshift.c"

 // for alternating between 45 degree angle routing and free angle routing with one key
bool kicad_free_angle_routing = false;

__attribute__((weak)) bool process_record_keymap(uint16_t keycode, keyrecord_t *record) { return true; }

__attribute__((weak)) bool process_record_secrets(uint16_t keycode, keyrecord_t *record) { return true; }

// Defines actions tor my global custom keycodes. Defined in smathev.h file
// Then runs the _keymap's record handler if not processed here
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    #ifdef CASEMODES_ENABLE
    // Process case modes
    if (!process_case_modes(keycode, record)) {
        return false;
    }
    // If console is enabled, it will print the matrix position and status of each key pressed
    #endif

    if (!(process_record_keymap(keycode, record) && process_record_secrets(keycode, record))) {
        return false;
    }

    switch (keycode) {
        case C_CAPSWORD:
            // NOTE: if you change this behavior, may want to update in keymap.c for COMBO behavior
            #ifdef CASEMODES_ENABLE
            if (record->event.pressed) {
                enable_caps_word();
            }
            #endif
            break;
        case C_HYPHENCASE:
            #ifdef CASEMODES_ENABLE
            if (record->event.pressed) {
                enable_xcase_with(KC_MINS);
            }
            #endif
            break;
        case C_ANYCASE:
            #ifdef CASEMODES_ENABLE
            if (record->event.pressed) {
                enable_xcase();
            }
            #endif
            break;
        case C_UNDERSCORECASE:
            #ifdef CASEMODES_ENABLE
            if (record->event.pressed) {
                enable_xcase_with(KC_UNDS);
            }
            #endif
            break;
        // COMMENT TO DISABLE MACROS
    }
    return true;
}
