#pragma once
#include "smathev.h"

#if defined(KEYBOARD_fingerpunch_arachnophobe) \
    || defined(KEYBOARD_fingerpunch_sweeeeep)
#    define PLACEHOLDER_SAFE_RANGE FP_SAFE_RANGE
#elif defined(KEYMAP_SAFE_RANGE)
#    define PLACEHOLDER_SAFE_RANGE KEYMAP_SAFE_RANGE
#else
#    define PLACEHOLDER_SAFE_RANGE SAFE_RANGE
#endif

enum userspace_custom_keycodes {
    C_CAPSWORD = PLACEHOLDER_SAFE_RANGE, // Toggles RGB Layer Indication mode
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
