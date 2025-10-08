#include "keymap_danish.h"

bool is_flow_tap_key(uint16_t keycode) {
    if ((get_mods() & (MOD_MASK_CG | MOD_BIT_LALT)) != 0) {
        return false; // Disable Flow Tap on hotkeys.
    }
    switch (get_tap_keycode(keycode)) {
        case KC_SPC:
        case KC_A ... KC_Z:
        case KC_DOT:
        case KC_COMM:
        case DK_SCLN:
        case DK_SLSH:
        case DK_ARNG:
        case DK_OSTR:
        case DK_AE:
            return true;
    }
    return false;
}
