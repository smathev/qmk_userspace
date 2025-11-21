// Hold on other key press per-key implementation
// This requires HOLD_ON_OTHER_KEY_PRESS_PER_KEY in config.h
// Implementation in hold_on_other_key_press.c

#pragma once

#include QMK_KEYBOARD_H

// Function declaration (implementation in .c file)
bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record);
