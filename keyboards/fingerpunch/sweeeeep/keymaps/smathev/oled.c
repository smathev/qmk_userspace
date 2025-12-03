char wpm_str[6];

// Include headers for Caps Word and XCASE detection
#include "caps_word.h"
#include "xcase.h"

#ifdef OLED_ENABLE
//    static uint32_t oled_timer = 0;
    bool process_record_oled(uint16_t keycode, keyrecord_t *record);
    oled_rotation_t oled_init_user(oled_rotation_t rotation);
    void render_layer_symbol(void);
    void render_layer_name(void);
    void render_mod_state(uint8_t modifiers);
    void render_status(void);
    bool oled_task_user(void);
#endif
#ifdef OLED_ENABLE
oled_rotation_t oled_init_user(oled_rotation_t rotation) { return OLED_ROTATION_270; }

void render_space(void) {
    oled_write_P(PSTR("     "), false);
}

void render_mod_status_gui_alt(uint8_t modifiers) {
    static const char PROGMEM gui_off_1[] = {0x85, 0x86, 0};
    static const char PROGMEM gui_off_2[] = {0xa5, 0xa6, 0};
    static const char PROGMEM gui_on_1[] = {0x8d, 0x8e, 0};
    static const char PROGMEM gui_on_2[] = {0xad, 0xae, 0};

    static const char PROGMEM alt_off_1[] = {0x87, 0x88, 0};
    static const char PROGMEM alt_off_2[] = {0xa7, 0xa8, 0};
    static const char PROGMEM alt_on_1[] = {0x8f, 0x90, 0};
    static const char PROGMEM alt_on_2[] = {0xaf, 0xb0, 0};

    // fillers between the modifier icons bleed into the icon frames
    static const char PROGMEM off_off_1[] = {0xc5, 0};
    static const char PROGMEM off_off_2[] = {0xc6, 0};
    static const char PROGMEM on_off_1[] = {0xc7, 0};
    static const char PROGMEM on_off_2[] = {0xc8, 0};
    static const char PROGMEM off_on_1[] = {0xc9, 0};
    static const char PROGMEM off_on_2[] = {0xca, 0};
    static const char PROGMEM on_on_1[] = {0xcb, 0};
    static const char PROGMEM on_on_2[] = {0xcc, 0};

    if(modifiers & MOD_MASK_GUI) {
        oled_write_P(gui_on_1, false);
    } else {
        oled_write_P(gui_off_1, false);
    }

    if ((modifiers & MOD_MASK_GUI) && (modifiers & MOD_MASK_ALT)) {
        oled_write_P(on_on_1, false);
    } else if(modifiers & MOD_MASK_GUI) {
        oled_write_P(on_off_1, false);
    } else if(modifiers & MOD_MASK_ALT) {
        oled_write_P(off_on_1, false);
    } else {
        oled_write_P(off_off_1, false);
    }

    if(modifiers & MOD_MASK_ALT) {
        oled_write_P(alt_on_1, false);
    } else {
        oled_write_P(alt_off_1, false);
    }

    if(modifiers & MOD_MASK_GUI) {
        oled_write_P(gui_on_2, false);
    } else {
        oled_write_P(gui_off_2, false);
    }

    if ((modifiers & MOD_MASK_GUI) && (modifiers & MOD_MASK_ALT)) {
        oled_write_P(on_on_2, false);
    } else if(modifiers & MOD_MASK_GUI) {
        oled_write_P(on_off_2, false);
    } else if(modifiers & MOD_MASK_ALT) {
        oled_write_P(off_on_2, false);
    } else {
        oled_write_P(off_off_2, false);
    }

    if(modifiers & MOD_MASK_ALT) {
        oled_write_P(alt_on_2, false);
    } else {
        oled_write_P(alt_off_2, false);
    }
}


void render_mod_status_ctrl_shift(uint8_t modifiers) {
    static const char PROGMEM ctrl_off_1[] = {0x89, 0x8a, 0};
    static const char PROGMEM ctrl_off_2[] = {0xa9, 0xaa, 0};
    static const char PROGMEM ctrl_on_1[] = {0x91, 0x92, 0};
    static const char PROGMEM ctrl_on_2[] = {0xb1, 0xb2, 0};

    static const char PROGMEM shift_off_1[] = {0x8b, 0x8c, 0};
    static const char PROGMEM shift_off_2[] = {0xab, 0xac, 0};
    static const char PROGMEM shift_on_1[] = {0xcd, 0xce, 0};
    static const char PROGMEM shift_on_2[] = {0xcf, 0xd0, 0};

    // fillers between the modifier icons bleed into the icon frames
    static const char PROGMEM off_off_1[] = {0xc5, 0};
    static const char PROGMEM off_off_2[] = {0xc6, 0};
    static const char PROGMEM on_off_1[] = {0xc7, 0};
    static const char PROGMEM on_off_2[] = {0xc8, 0};
    static const char PROGMEM off_on_1[] = {0xc9, 0};
    static const char PROGMEM off_on_2[] = {0xca, 0};
    static const char PROGMEM on_on_1[] = {0xcb, 0};
    static const char PROGMEM on_on_2[] = {0xcc, 0};

    if(modifiers & MOD_MASK_CTRL) {
        oled_write_P(ctrl_on_1, false);
    } else {
        oled_write_P(ctrl_off_1, false);
    }

    if ((modifiers & MOD_MASK_CTRL) && (modifiers & MOD_MASK_SHIFT)) {
        oled_write_P(on_on_1, false);
    } else if(modifiers & MOD_MASK_CTRL) {
        oled_write_P(on_off_1, false);
    } else if(modifiers & MOD_MASK_SHIFT) {
        oled_write_P(off_on_1, false);
    } else {
        oled_write_P(off_off_1, false);
    }

    if(modifiers & MOD_MASK_SHIFT) {
        oled_write_P(shift_on_1, false);
    } else {
        oled_write_P(shift_off_1, false);
    }

    if(modifiers & MOD_MASK_CTRL) {
        oled_write_P(ctrl_on_2, false);
    } else {
        oled_write_P(ctrl_off_2, false);
    }

    if ((modifiers & MOD_MASK_CTRL) && (modifiers & MOD_MASK_SHIFT)) {
        oled_write_P(on_on_2, false);
    } else if(modifiers & MOD_MASK_CTRL) {
        oled_write_P(on_off_2, false);
    } else if(modifiers & MOD_MASK_SHIFT) {
        oled_write_P(off_on_2, false);
    } else {
        oled_write_P(off_off_2, false);
    }

    if(modifiers & MOD_MASK_SHIFT) {
        oled_write_P(shift_on_2, false);
    } else {
        oled_write_P(shift_off_2, false);
    }
}

void render_base_layer_state(void) {
    if (default_layer_state & (1UL << _QWERTY)) {
        oled_write_P(PSTR("QWERT"), false);
    } else if (default_layer_state & (1UL << _ENTHIUMDK)) {
        oled_write_P(PSTR("ENTHI"), false);
    } else {
        oled_write_P(PSTR("NORTO"), false);
    }
}

void render_active_layer_state(void) {
    if (layer_state_is(_MOUSENAV)) {
        oled_write_P(PSTR("MOUSE"), false);
    } else if (layer_state_is(_SYMFKEYS)) {
        oled_write_P(PSTR("SYMB "), false);
    } else if (layer_state_is(_NORTNAVIGATION)) {
        oled_write_P(PSTR("NAV  "), false);
    } else if (layer_state_is(_SETUP)) {
        oled_write_P(PSTR("SETUP"), false);
    } else {
        oled_write_P(PSTR("     "), false);
    }
}

void render_status_main(void) {
    render_base_layer_state();
    oled_write_P(PSTR("\n"), false);
    render_active_layer_state();
    oled_write_P(PSTR("\n\n"), false);

    uint8_t mods = get_mods()|get_oneshot_mods()|get_weak_mods()|get_oneshot_locked_mods();
    render_mod_status_gui_alt(mods);
    render_mod_status_ctrl_shift(mods);

    oled_write_P(PSTR("\n"), false);
    oled_write_P(PSTR("WPM: "), false);
    char wpm_str[6];
    sprintf(wpm_str, "%03d", get_current_wpm());
    oled_write(wpm_str, false);

    // Show Caps Word and XCASE status
    oled_write_P(PSTR("\n"), false);
    if (is_caps_word_on()) {
        oled_write_P(PSTR("CAPS "), false);
    } else {
        oled_write_P(PSTR("     "), false);
    }
    if (is_xcase_active()) {
        oled_write_P(PSTR("XCAS"), false);
    } else {
        oled_write_P(PSTR("    "), false);
    }
}

void render_status_secondary(void) {
    render_base_layer_state();
    oled_write_P(PSTR("\n"), false);

    oled_write_P(PSTR("WPM: "), false);
    oled_write_P(PSTR("\n"), false);
    char wpm_str[6];
    sprintf(wpm_str, "%03d", get_current_wpm());
    oled_write(wpm_str, false);
}

 static bool oled_active = true;

 bool process_record_user_keymap(uint16_t keycode, keyrecord_t *record) {
     return true;
 }

 bool oled_task_user(void) {
     if (last_input_activity_elapsed() > 15000) {
         if (oled_active) {  // Only turn off if it's currently on
             oled_off();
             oled_active = false;
         }
         return false;  // Don't render while sleeping
     }

     // If we get here, there's been recent activity
     if (!oled_active) {
         oled_on();
         oled_active = true;
     }

     if (is_keyboard_left()) {
         render_status_main();
     } else {
         render_status_secondary();
     }
     return false;
 }

#endif
