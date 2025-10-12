#include "smathev.h"


userspace_config_t userspace_config;

__attribute__((weak)) void keyboard_pre_init_keymap(void) {}

void keyboard_pre_init_user(void) {
      // Set our LED pin as output
  setPinOutput(24);
  // Turn the LED off
  // (Due to technical reasons, high is off and low is on)
  writePinHigh(24);
    userspace_config.raw = eeconfig_read_user();

    // hack for a weird issue where userspace_config.val gets set to 0 on keyboard restart
    userspace_config.val = 255;

    keyboard_pre_init_keymap();
}
// Add reconfigurable functions here, for keymap customization
// This allows for a global, userspace functions, and continued
// customization of the keymap.  Use _keymap instead of _user
// functions in the keymaps
__attribute__((weak)) void matrix_init_keymap(void) {}

// Call user matrix init, set default RGB colors and then
// call the keymap's init function
void matrix_init_user(void) {
    matrix_init_keymap();
}

__attribute__((weak)) void keyboard_post_init_keymap(void) {}

void keyboard_post_init_user(void) {
    #if defined(PIMORONI_TRACKBALL_ENABLE) && !defined(USERSPACE_RGBLIGHT_ENABLE)
    pimoroni_trackball_set_rgbw(RGB_BLUE, 0x00);
    #endif
#if defined(USERSPACE_RGBLIGHT_ENABLE)
    keyboard_post_init_rgb_light();
#endif
    keyboard_post_init_keymap();
}

__attribute__((weak)) void shutdown_keymap(void) {}

void rgb_matrix_update_pwm_buffers(void);

bool shutdown_user(bool jump_to_bootloader) {
    shutdown_keymap();
    return true;
}

__attribute__((weak)) void suspend_power_down_keymap(void) {}

void suspend_power_down_user(void) { suspend_power_down_keymap(); }

__attribute__((weak)) void suspend_wakeup_init_keymap(void) {}

void suspend_wakeup_init_user(void) { suspend_wakeup_init_keymap(); }

__attribute__((weak)) void matrix_scan_keymap(void) {}

__attribute__((weak)) layer_state_t layer_state_set_keymap(layer_state_t state) { return state; }

// on layer change, no matter where the change was initiated
// Then runs keymap's layer change check
layer_state_t layer_state_set_user(layer_state_t state) {
#if defined(USERSPACE_RGBLIGHT_ENABLE)
    state = layer_state_set_rgb_light(state);
#endif  // USERSPACE_RGBLIGHT_ENABLE
#if defined(HAPTIC_ENABLE)
    state = layer_state_set_haptic(state);
#endif  // HAPTIC_ENABLE
#if defined(POINTING_DEVICE_ENABLE)
// all handled in keyboards/fingerpunch/fp_pointing.c now
//    state = layer_state_set_pointing(state);
#endif  // HAPTIC_ENABLE
    return layer_state_set_keymap(state);
}

__attribute__((weak)) layer_state_t default_layer_state_set_keymap(layer_state_t state) { return state; }

// Runs state check and changes underglow color and animation
layer_state_t default_layer_state_set_user(layer_state_t state) {
    state = default_layer_state_set_keymap(state);
    return state;
}

__attribute__((weak)) void led_set_keymap(uint8_t usb_led) {}

// Any custom LED code goes here.
// So far, I only have keyboard specific code,
// So nothing goes here.
void led_set_user(uint8_t usb_led) { led_set_keymap(usb_led); }

__attribute__((weak)) void eeconfig_init_keymap(void) {}

void eeconfig_init_user(void) {
    userspace_config.raw              = 0;
    userspace_config.rgb_base_layer_override = false;
    userspace_config.rgb_layer_change = true;
    #ifdef USERSPACE_RGBLIGHT_ENABLE
    userspace_config.mode = RGBLIGHT_MODE_STATIC_LIGHT;
    #endif
    userspace_config.hue = 167; // BLUE
    userspace_config.sat = 255;
    userspace_config.val = 255;
    userspace_config.speed = 1;
    eeconfig_update_user(userspace_config.raw);
    eeconfig_init_keymap();
    keyboard_init();
}

bool hasAllBitsInMask(uint8_t value, uint8_t mask) {
    value &= 0xF;
    mask &= 0xF;

    return (value & mask) == mask;
}

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        // I always type the shift keys too fast, so tapping term of 200 is way too high
        case LSFT_T(KC_T):
        case RSFT_T(KC_N):
            return 75;
        default:
            return TAPPING_TERM;
    }
}

// CRITICAL FIX: Exclude layer-tap keys from Auto Shift/RETRO_SHIFT
// RETRO_SHIFT interferes with layer activation, causing combos to fail on first press
bool get_auto_shifted_key(uint16_t keycode, keyrecord_t *record) {
    // First: Exclude ALL layer-tap keys from Auto Shift/RETRO_SHIFT
    if (IS_QK_LAYER_TAP(keycode)) {
        return false;  // DO NOT apply Auto Shift/RETRO_SHIFT to layer-taps
    }

    // Second: Enable default Auto Shift for standard keys (alphas, numbers, symbols)
    switch (keycode) {
#ifndef NO_AUTO_SHIFT_ALPHA
        case AUTO_SHIFT_ALPHA:
#endif
#ifndef NO_AUTO_SHIFT_NUMERIC
        case AUTO_SHIFT_NUMERIC:
#endif
#ifndef NO_AUTO_SHIFT_SPECIAL
# ifndef NO_AUTO_SHIFT_TAB
        case KC_TAB:
# endif
# ifndef NO_AUTO_SHIFT_SYMBOLS
        case AUTO_SHIFT_SYMBOLS:
# endif
#endif
#ifdef AUTO_SHIFT_ENTER
        case KC_ENT:
#endif
            return true;  // Enable Auto Shift for these standard keys
    }

    // Third: Check custom keys (Danish symbols, mod-taps, etc.)
    return get_custom_auto_shifted_key(keycode, record);
}

// This was added to deal with this issue:
// * https://www.reddit.com/r/olkb/comments/mwf5re/help_needed_controlling_individual_rgb_leds_on_a/
// * https://github.com/qmk/qmk_firmware/issues/12037
#ifdef SPLIT_KEYBOARD
void housekeeping_task_user(void) {
    static layer_state_t old_layer_state = 0;
    if (!is_keyboard_master() && old_layer_state != layer_state) {
        old_layer_state = layer_state;
        layer_state_set_user(layer_state);
    }
}
#endif
