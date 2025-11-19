/* Copyright 2021 Sadek Baroudi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "smathev.h"
#include <stdio.h>
#include "flow_tap.c"
#include "wrappers.h"
#include QMK_KEYBOARD_H
#include "oled.c"

// Forward declaration for xcase function
void add_exclusion_keycode(uint16_t keycode);

extern keymap_config_t keymap_config;

// clang-format off
#define LAYOUT_sweeeeep_base( \
    K01, K02, K03, K04, K05, K06, K07, K08, K09, K0A, \
    K11, K12, K13, K14, K15, K16, K17, K18, K19, K1A, \
    K21, K22, K23, K24, K25, K26, K27, K28, K29, K2A, \
              K33, K34, K35, K36, K37, K38 \
  ) \
  LAYOUT_wrapper( \
        K01,    K02,    K03,    K04, 	K05,	K06,	K07,	K08,	K09,	K0A, \
        K11,    K12,    K13,    K14,    K15,    K16,    K17,    K18,    K19,    K1A, \
        K21,    K22,    K23,    K24,    K25,    K26,    K27,    K28,    K29,    K2A, \
            LT(_NORTNAVIGATION, K33),  K34,    K35,    K36,    K37,    LT(_MOUSENAV, K38) \
    )

/* Re-pass though to allow templates to be used */
#define LAYOUT_sweeeeep_base_wrapper(...)       LAYOUT_sweeeeep_base(__VA_ARGS__)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
        [_NORTO] = LAYOUT_sweeeeep_base_wrapper(
        __________________NORTO_L1____________________, __________________NORTO_R1____________________,
        __________________NORTO_L2____________________, __________________NORTO_R2____________________,
        __________________NORTO_L3____________________, __________________NORTO_R3____________________,
                                                        __NORTO_THUMBS_6__
    ),

    [_NORTNAVIGATION] = LAYOUT_sweeeeep_base_wrapper(
        ____________NORTNAVIGATION_1_______________, _________________NUMPAD_1__________________,
        ____________NORTNAVIGATION_2_______________, _________________NUMPAD_2__________________,
        ____________NORTNAVIGATION_3_______________, _________________NUMPAD_3__________________,
                                                        _NOR_NAV_THUMBS_6__
    ),

    [_SYMFKEYS] = LAYOUT_sweeeeep_base_wrapper(
        ___________________FKEY______L1________________, ________________NORTSYMBOLS_R1_________________,
        ___________________FKEY______L2________________, ________________NORTSYMBOLS_R2_________________,
        ___________________FKEY______L3________________, ________________NORTSYMBOLS_R3_________________,
                           _______, TG(_SETUP), _______, _______, _______, _______
    ),

        [_SETUP] = LAYOUT_sweeeeep_base_wrapper(
        __________________QWERTY_L1____________________, _________________KB_SETUP_1________________,
        __________________QWERTY_L2____________________, _________________KB_SETUP_2________________,
        __________________QWERTY_L3____________________, _________________KB_SETUP_3________________,
                           _______, TG(_SETUP), TG(_NORTO), TG(_NORTO), TG(_SETUP), _______
    ),

        [_MOUSENAV] = LAYOUT_sweeeeep_base_wrapper(
        _________________MOUSENAV____L1________________, ________________MOUSENAV_R1_________________,
        _________________MOUSENAV____L2________________, ________________MOUSENAV_R2_________________,
        _________________MOUSENAV____L3________________, ________________MOUSENAV_R3_________________,
                                                            _MOUSENAV_THUMBS_6__
    )

};

const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM =
    LAYOUT(
        'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R',
        'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R',
        'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R',
                  '*', 'L', 'L',  'R', 'R', '*'
    );

bool get_speculative_hold(uint16_t keycode, keyrecord_t* record) {
  switch (keycode) {  // Enable speculative holding for these keys.

    // left side modifiers baselayer
    case LGUI_T(DK_COMM):
    case LALT_T(KC_Y):
    case LSFT_T(DK_ARNG):
    case LCTL_T(KC_V):

    // Right side modifiers baselayer
    case RCTL_T(KC_K):
    case RSFT_T(KC_Z):
    case RALT_T(KC_Q):
    case LGUI_T(DK_DOT):
      return true;
  }
  return false;  // Disable otherwise.
}

void keyboard_post_init_keymap(void) {
    // Add Danish characters as exclusion keycodes for xcase
    add_exclusion_keycode(DK_ARNG);  // Å
    add_exclusion_keycode(DK_AE);    // Æ
    add_exclusion_keycode(DK_OSTR);  // Ø
}
