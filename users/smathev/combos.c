#include "combos.h"
#include "keycodes.h"
#include "keymap_danish.h"

// COMBOS - https://github.com/qmk/qmk_firmware/blob/master/docs/feature_combo.md

//l3 + R3 doesn't work because of homerow-mods
const uint16_t PROGMEM undo_combo[] = {KC_X, KC_H, COMBO_END}; // L3_K1 + L3_K2
const uint16_t PROGMEM cut_combo[] = {KC_H, KC_L, COMBO_END}; //L3_K2 + L3_K3
const uint16_t PROGMEM copy_combo[] = {KC_L, KC_F, COMBO_END}; // L3_K3 + L3_K4
const uint16_t PROGMEM paste_combo[] = {KC_C, KC_COMM, COMBO_END}; // L3_K4 + L3_K5 KC_I
const uint16_t PROGMEM enter_combo[] = {KC_S, KC_D, COMBO_END}; // R2_K4 + R2_K5
const uint16_t PROGMEM tab_combo[] = {KC_O, KC_I, COMBO_END}; // L2_K1 + L2_K2
const uint16_t PROGMEM delete_combo[] = {KC_L, KC_H, COMBO_END}; // R1_K3 + R1_K4
const uint16_t PROGMEM bcksp_combo[] = {KC_H, KC_X, COMBO_END}; // R1_K4 + R1_K5
const uint16_t PROGMEM new_tab_combo[] = {KC_G, KC_J, COMBO_END}; // L1_K4 + L1_K5
const uint16_t PROGMEM esc_combo[] = {DK_OSTR, DK_AE, COMBO_END}; // L1_K1 + L1_K2
const uint16_t PROGMEM search_ctrl_f_combo[] = {KC_F, KC_B, COMBO_END}; // R1_K1 + R1_K2
const uint16_t PROGMEM close_window_combo[] = {KC_T, KC_PGDN, COMBO_END}; // L1_K4 + L1_K5
const uint16_t PROGMEM cancel_combo[] = {KC_LEFT, KC_HOME, COMBO_END}; // l2_K1 + L2_K2
const uint16_t PROGMEM reopen_closed_tab_combo[] = {KC_T, KC_PGDN, KC_UP, COMBO_END}; // L1_K3 + L1_K4 + L1_K5
const uint16_t PROGMEM ffive_reload_combo[] = {KC_U, KC_G, COMBO_END}; // L1_K3 + L1_K4
const uint16_t PROGMEM reset_keyboard_left_combo[] = {KC_J, KC_M, KC_C, COMBO_END}; // L1_K3 + L1_K4 + L1_K5
const uint16_t PROGMEM reset_keyboard_right_combo[] = {KC_B, KC_P, KC_W, COMBO_END}; // L1_K3 + L1_K4 + L1_K5
combo_t key_combos[COMBO_COUNT] = {
COMBO(reopen_closed_tab_combo, RCS(KC_T)),
  COMBO(close_window_combo, LCTL(KC_W)),
  COMBO(undo_combo, LCTL(KC_Z)),
  COMBO(copy_combo, LCTL(KC_C)),
  COMBO(cut_combo, LCTL(KC_X)),
  COMBO(paste_combo, LCTL(KC_V)),
  COMBO(new_tab_combo, LCTL(KC_T)),
  COMBO(cancel_combo, LCTL(KC_C)),
  COMBO(search_ctrl_f_combo, LCTL(KC_F)),
  COMBO(ffive_reload_combo, KC_F5),
  COMBO(enter_combo, KC_ENT),
  COMBO(tab_combo, KC_TAB),
  COMBO(bcksp_combo, KC_BSPC),
  COMBO(delete_combo, KC_DEL),
  COMBO(esc_combo, KC_ESC),
  COMBO(reset_keyboard_left_combo, QK_BOOT),
  COMBO(reset_keyboard_right_combo, QK_BOOT)
};


