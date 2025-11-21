// Hold on other key press per-key implementation
// This requires HOLD_ON_OTHER_KEY_PRESS_PER_KEY in config.h

#include "smathev.h"

bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case LT(_MOUSENAV, DK_MINS):
        case LT(_NORTNAVIGATION, KC_E):
            // Immediately select the hold action when another key is pressed.
            return true;
        default:
            // Do not select the hold action when another key is pressed.
            return false;
    }
}
