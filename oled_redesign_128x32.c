// ============================================================================
// IMPROVED OLED CODE FOR 128x32 DISPLAYS (4 rows × 21 characters)
// ============================================================================
// This is a redesigned OLED layout that fits properly on 128x32 displays
//
// Layout strategy for 4 rows:
// Row 1: Small logo/icon (2-3 chars) + Layer name (text)
// Row 2: Layer icon (2-3 chars) + Modifier status indicators
// Row 3: WPM counter or other stats
// Row 4: Additional info (caps lock, scroll lock, etc.)
//
// To use this code, replace the OLED functions in your keymap.c
// ============================================================================

#ifdef OLED_ENABLE

void render_space(void) {
    oled_write_P(PSTR(" "), false);
}

void render_newline(void) {
    oled_write_P(PSTR("\n"), false);
}

// Compact logo - just 2 characters wide for 128x32
void render_logo_compact(void) {
    // Use a simple 2-char logo (you can design these at positions 0x80-0x81)
    static const char PROGMEM logo[] = {0x80, 0x81, 0};
    oled_write_P(logo, false);
}

// Text-based layer display (more readable on small screens)
void render_layer_name(void) {
    if(layer_state_is(_SYMFKEYS)) {
        oled_write_P(PSTR(" SYMBOLS"), false);
    } else if(layer_state_is(_NORTNAVIGATION)) {
        oled_write_P(PSTR(" NAVIGATE"), false);
    } else if(layer_state_is(_QWERTY)) {
        oled_write_P(PSTR(" QWERTY"), false);
    } else {
        oled_write_P(PSTR(" NORTO"), false);
    }
}

// Compact 2-char layer icon
void render_layer_icon(void) {
    if(layer_state_is(_SYMFKEYS)) {
        // Symbol layer icon (2 chars: 0x94-0x95)
        static const char PROGMEM symbol_icon[] = {0x94, 0x95, 0};
        oled_write_P(symbol_icon, false);
    } else if(layer_state_is(_NORTNAVIGATION)) {
        // Navigation layer icon (2 chars: 0x96-0x97)
        static const char PROGMEM nav_icon[] = {0x96, 0x97, 0};
        oled_write_P(nav_icon, false);
    } else {
        // Default layer icon (2 chars: 0x92-0x93)
        static const char PROGMEM default_icon[] = {0x92, 0x93, 0};
        oled_write_P(default_icon, false);
    }
}

// Compact modifier status - single character per modifier
void render_modifiers_compact(uint8_t modifiers) {
    // GUI/Super (1 char)
    if(modifiers & MOD_MASK_GUI) {
        oled_write_P(PSTR("W"), false);  // Or use custom char 0x98
    } else {
        oled_write_P(PSTR("-"), false);
    }

    // ALT (1 char)
    if(modifiers & MOD_MASK_ALT) {
        oled_write_P(PSTR("A"), false);  // Or use custom char 0x99
    } else {
        oled_write_P(PSTR("-"), false);
    }

    // CTRL (1 char)
    if(modifiers & MOD_MASK_CTRL) {
        oled_write_P(PSTR("C"), false);  // Or use custom char 0x9A
    } else {
        oled_write_P(PSTR("-"), false);
    }

    // SHIFT (1 char)
    if(modifiers & MOD_MASK_SHIFT) {
        oled_write_P(PSTR("S"), false);  // Or use custom char 0x9B
    } else {
        oled_write_P(PSTR("-"), false);
    }
}

void render_wpm(void) {
    char wpm_str[16];
    sprintf(wpm_str, "WPM:%03d", get_current_wpm());
    oled_write(wpm_str, false);
}

void render_status_compact(void) {
    // Row 1: Logo + Layer name
    render_logo_compact();
    render_layer_name();
    render_newline();

    // Row 2: Layer icon + Modifiers
    render_layer_icon();
    render_space();
    render_modifiers_compact(get_mods()|get_oneshot_mods());
    render_newline();

    // Row 3: WPM
    render_wpm();
    render_newline();

    // Row 4: Additional status
    led_t led_state = host_keyboard_led_state();
    oled_write_P(led_state.caps_lock ? PSTR("CAPS ") : PSTR("     "), false);
    oled_write_P(led_state.scroll_lock ? PSTR("SCRL ") : PSTR("     "), false);
}

static bool oled_active = true;

bool process_record_user_keymap(uint16_t keycode, keyrecord_t *record) {
    return true;
}

bool oled_task_user(void) {
    // Auto-sleep after 15 seconds of inactivity
    if (last_input_activity_elapsed() > 15000) {
        if (oled_active) {
            oled_off();
            oled_active = false;
        }
        return false;
    }

    if (!oled_active) {
        oled_on();
        oled_active = true;
    }

    // Same display on both halves for 128x32
    render_status_compact();

    return false;
}

#endif

// ============================================================================
// FONT DESIGN GUIDE for 128x32 displays
// ============================================================================
//
// Character positions you need to design:
//
// 0x80-0x81: Small logo (2 chars wide, 1 row tall)
//            Design a simple keyboard icon or your initials
//
// 0x92-0x93: Default layer icon (2 chars, 1 row)
//            Suggestion: Simple keyboard outline
//
// 0x94-0x95: Symbol layer icon (2 chars, 1 row)
//            Suggestion: # $ % & symbols
//
// 0x96-0x97: Navigation layer icon (2 chars, 1 row)
//            Suggestion: Arrow keys design
//
// 0x98: GUI/Super modifier icon (1 char)
//       Suggestion: Windows logo or Super key
//
// 0x99: ALT modifier icon (1 char)
//       Suggestion: "ALT" text or alt symbol
//
// 0x9A: CTRL modifier icon (1 char)
//       Suggestion: "CTL" text or ctrl symbol
//
// 0x9B: SHIFT modifier icon (1 char)
//       Suggestion: Up arrow or shift symbol
//
// Use https://helixfonteditor.netlify.com/ to design these characters.
// Each character is 6 pixels wide × 8 pixels tall.
// Keep designs simple and readable at small size!
