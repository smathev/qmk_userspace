bool get_custom_auto_shifted_key(uint16_t keycode, keyrecord_t *record) {
    switch(keycode) {
        case DK_MINS:
        case DK_SLSH:
        case DK_LPRN:
        case DK_LBRC:
        case DK_LCBR:
        case DK_LABK:
        case DK_QUOT:
            return true;
        default:
            // Enable Auto-Shift for mod-tap keys (for Retro-Shift to work)
            if (IS_RETRO(keycode)) {
                return true;
            }
            return false;
    }
}

void autoshift_press_user(uint16_t keycode, bool shifted, keyrecord_t *record) {
    switch(keycode) {
        case DK_MINS:
            register_code16((!shifted) ? DK_MINS : DK_UNDS);
            break;
        case DK_SLSH:
            register_code16((!shifted) ? DK_SLSH : DK_BSLS);
            break;
        case DK_LPRN:
            register_code16((!shifted) ? DK_LPRN : DK_RPRN);
            break;
        case DK_LBRC:
            register_code16((!shifted) ? DK_LBRC : DK_RBRC);
            break;
        case DK_LCBR:
            register_code16((!shifted) ? DK_LCBR : DK_RCBR);
            break;
        case DK_LABK:
            register_code16((!shifted) ? DK_LABK : DK_RABK);
            break;
        case DK_QUOT:
            register_code16((!shifted) ? DK_QUOT : DK_DQUO);
            break;
        case DK_DLR:
            register_code16((!shifted) ? DK_DLR : DK_EURO);
            break;
        default:
            if (shifted) {
                add_weak_mods(MOD_BIT(KC_LSFT));
            }
    // & 0xFF gets the Tap key for Tap Holds, required when using Retro Shift
            register_code16((IS_RETRO(keycode)) ? keycode & 0xFF : keycode);
    }
}

void autoshift_release_user(uint16_t keycode, bool shifted, keyrecord_t *record) {
    switch(keycode) {
        case DK_MINS:
            unregister_code16((!shifted) ? DK_MINS : DK_UNDS);
            break;
        case DK_SLSH:
            unregister_code16((!shifted) ? DK_SLSH : DK_BSLS);
            break;
        case DK_LPRN:
            unregister_code16((!shifted) ? DK_LPRN : DK_RPRN);
            break;
        case DK_LBRC:
            unregister_code16((!shifted) ? DK_LBRC : DK_RBRC);
            break;
        case DK_LCBR:
            unregister_code16((!shifted) ? DK_LCBR : DK_RCBR);
            break;
        case DK_LABK:
            unregister_code16((!shifted) ? DK_LABK : DK_RABK);
            break;
        case DK_QUOT:
            unregister_code16((!shifted) ? DK_QUOT : DK_DQUO);
            break;
        default:
            // & 0xFF gets the Tap key for Tap Holds, required when using Retro Shift
            // The IS_RETRO check isn't really necessary here, always using
            // keycode & 0xFF would be fine.
            unregister_code16((IS_RETRO(keycode)) ? keycode & 0xFF : keycode);
    }
}