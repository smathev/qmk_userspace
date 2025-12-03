#include "combos.h"
#include "keycodes.h"
#include "keymap_danish.h"
#include "smathev.h"

// COMBOS - https://github.com/qmk/qmk_firmware/blob/master/docs/feature_combo.md

// ALPHA combos - Mapped to QWERTY physical positions

// L2_K1 + L2_K2 (A + S)
const uint16_t PROGMEM tab_combo[] = {KC_A, KC_S, COMBO_END};
// L1_K3 + L1_K4 (E + R)
const uint16_t PROGMEM ffive_reload_combo[] = {KC_E, KC_R, COMBO_END};

// L1_K5 + L2_K5 + L3_K5 (T + G + B)
const uint16_t PROGMEM reset_keyboard_left_combo[] = {KC_T, KC_G, KC_B, COMBO_END};
// R1_K1 + R2_K1 + R3_K1 (Y + H + N)
const uint16_t PROGMEM reset_keyboard_right_combo[] = {KC_Y, KC_H, KC_N, COMBO_END};

// R1_K3 + R1_K4 (I + O)
const uint16_t PROGMEM to_mouse_layer[] = {KC_O, KC_I, COMBO_END};



// R2_K4 + R2_K5 (L + ;)
const uint16_t PROGMEM enter_combo[] = {KC_L, DK_ARNG, COMBO_END};
// R1_K4 + R1_K5 (O + P)
const uint16_t PROGMEM delete_combo[] = {KC_O, KC_P, COMBO_END};
// L1_K4 + L1_K5 (R + T)
const uint16_t PROGMEM new_tab_combo[] = {KC_R, KC_T, COMBO_END};
// L1_K1 + L1_K2 (Q + W)
const uint16_t PROGMEM esc_combo[] = {KC_Q, KC_W, COMBO_END};

//Layer2 / Nav
// Using Nav Layer Keycodes for Nav Combos to avoid side effects
const uint16_t PROGMEM nav_close_window_combo[] = {KC_T, KC_PGDN, COMBO_END}; // LAYER2 L1_K4 + L1_K5
const uint16_t PROGMEM nav_reopen_closed_tab_combo[] = {KC_T, KC_PGDN, KC_UP, COMBO_END}; // LAYER2 L1_K3 + L1_K4 + L1_K5

combo_t key_combos[COMBO_COUNT] = {
  COMBO(nav_reopen_closed_tab_combo, RCS(KC_T)),
  COMBO(nav_close_window_combo, LCTL(KC_W)),
  COMBO(to_mouse_layer, TG(_MOUSENAV)),
  COMBO(new_tab_combo, LCTL(KC_T)),
  COMBO(ffive_reload_combo, KC_F5),
  COMBO(enter_combo, KC_ENT),
  COMBO(tab_combo, KC_TAB),
  COMBO(delete_combo, KC_DEL),
  COMBO(esc_combo, KC_ESC),
  COMBO(reset_keyboard_left_combo, QK_BOOT),
  COMBO(reset_keyboard_right_combo, QK_BOOT)
};

uint8_t combo_ref_from_layer(uint8_t layer){
    switch (layer){
        case _NORTNAVIGATION: return _NORTNAVIGATION;
        default: return _QWERTY;
    }
}

bool combo_should_trigger(uint16_t combo_index, combo_t *combo, uint16_t keycode, keyrecord_t *record) {
    return true;
}
