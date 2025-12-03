#pragma once
#include "smathev.h"

enum userspace_custom_keycodes {
    XCASE_DK_SNAKE = QK_USER_0,  // Danish snake_case with DK_UNDS
    XCASE_DK_KEBAB,              // Danish kebab-case with DK_MINS
    TO_NORTO_EXIT_MOUSE,         // Set default layer to NORTO and exit Mouse layer
    TO_ENTH_EXIT_MOUSE,          // Set default layer to ENTHIUMDK and exit Mouse layer
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
