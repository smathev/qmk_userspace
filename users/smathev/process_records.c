#include "smathev.h"
#include "autoshift.c"

// Forward declaration for xcase function
void enable_xcase_with(uint16_t delimiter);

 // for alternating between 45 degree angle routing and free angle routing with one key
bool kicad_free_angle_routing = false;

__attribute__((weak)) bool process_record_keymap(uint16_t keycode, keyrecord_t *record) { return true; }

__attribute__((weak)) bool process_record_secrets(uint16_t keycode, keyrecord_t *record) { return true; }

// Defines actions tor my global custom keycodes. Defined in smathev.h file
// Then runs the _keymap's record handler if not processed here
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (!(process_record_keymap(keycode, record) && process_record_secrets(keycode, record))) {
        return false;
    }

    switch (keycode) {
        // Danish xcase keycodes - use Danish keyboard layout delimiters
        case XCASE_DK_SNAKE:
            if (record->event.pressed) {
                enable_xcase_with(DK_UNDS);  // Danish underscore
            }
            return false;
        case XCASE_DK_KEBAB:
            if (record->event.pressed) {
                enable_xcase_with(DK_MINS);  // Danish minus
            }
            return false;
        case TO_NORTO_EXIT_MOUSE:
            if (record->event.pressed) {
                set_single_persistent_default_layer(_NORTO);
                layer_off(_MOUSENAV);
            }
            return false;
        case TO_ENTH_EXIT_MOUSE:
            if (record->event.pressed) {
                set_single_persistent_default_layer(_ENTHIUMDK);
                layer_off(_MOUSENAV);
            }
            return false;
        // COMMENT TO DISABLE MACROS
    }
    return true;
}

// Caps Word configuration - allow Danish characters
bool caps_word_press_user(uint16_t keycode) {
    switch (keycode) {
        // Keycodes that continue Caps Word, with shift applied.
        case KC_A ... KC_Z:
        case DK_AE:      // Æ
        case DK_OSTR:    // Ø
        case DK_ARNG:    // Å
        case KC_MINS:
            add_weak_mods(MOD_BIT(KC_LSFT));  // Apply shift to next key.
            return true;

        // Keycodes that continue Caps Word, without shifting.
        case KC_1 ... KC_0:
        case KC_BSPC:
        case KC_DEL:
        case KC_UNDS:
            return true;

        default:
            return false;  // Deactivate Caps Word.
    }
}
