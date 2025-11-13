#pragma once
#include "smathev.h"

enum userspace_custom_keycodes {
    C_CAPSWORD = QK_USER_0,  // Start at QK_USER_0 to avoid conflicts with QMK keycodes
    C_HYPHENCASE,
    C_UNDERSCORECASE,
    C_ANYCASE,
    NEW_SAFE_RANGE
};

bool process_record_secrets(uint16_t keycode, keyrecord_t *record);
bool process_record_keymap(uint16_t keycode, keyrecord_t *record);

#define KC_SEC1 KC_SECRET_1
#define KC_SEC2 KC_SECRET_2
#define KC_SEC3 KC_SECRET_3
#define KC_SEC4 KC_SECRET_4
#define KC_SEC5 KC_SECRET_5

#define KC_RESET RESET
#define KC_RST   KC_RESET
