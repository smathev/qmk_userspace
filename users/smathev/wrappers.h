#pragma once
#include "smathev.h"
#include "keymap_danish.h"
//#include "features/repeat_key.h"
//#include "features/sentence_case.h"

/*
Since our quirky block definitions are basically a list of comma separated
arguments, we need a wrapper in order for these definitions to be
expanded before being used as arguments to the LAYOUT_xxx macro.
*/

// Since sweeeeep uses the name LAYOUT_sweeeeep instead of LAYOUT
#if (!defined(LAYOUT) && defined(LAYOUT_sweeeeep))
#    define LAYOUT LAYOUT_sweeeeep
#endif

// clang-format off
#define LAYOUT_ergodox_wrapper(...)          LAYOUT_ergodox(__VA_ARGS__)
#define LAYOUT_ergodox_pretty_wrapper(...)   LAYOUT_ergodox_pretty(__VA_ARGS__)
#define KEYMAP_wrapper(...)                  LAYOUT(__VA_ARGS__)
#define LAYOUT_wrapper(...)                  LAYOUT(__VA_ARGS__)
#define LAYOUT_ortho_4x12_wrapper(...)       LAYOUT_ortho_4x12(__VA_ARGS__)
#define LAYOUT_ortho_5x12_wrapper(...)       LAYOUT_ortho_5x12(__VA_ARGS__)
#define LAYOUT_gergo_wrapper(...)            LAYOUT_gergo(__VA_ARGS__)
#define LAYOUT_split_3x6_3_wrapper(...)      LAYOUT_split_3x6_3(__VA_ARGS__)
#define LAYOUT_reviung39_wrapper(...)        LAYOUT_reviung39(__VA_ARGS__)
#define LAYOUT_pteron38_wrapper(...)         LAYOUT_pteron38(__VA_ARGS__)
#define LAYOUT_ffkbhw_wrapper(...)           LAYOUT_ffkbhw(__VA_ARGS__)

/*
Blocks for each of the four major keyboard layouts
Organized so we can quickly adapt and modify all of them
at once, rather than for each keyboard, one at a time.
And this allows for much cleaner blocks in the keymaps.
For instance Tap/Hold for Control on all of the layouts

NOTE: These are all the same length.  If you do a search/replace
  then you need to add/remove underscores to keep the
  lengths consistent.
*/


#define ____QWERTY_L1_K1__ KC_Q
#define ____QWERTY_L1_K2__ KC_W
#define ____QWERTY_L1_K3__ KC_E
#define ____QWERTY_L1_K4__ KC_R
#define ____QWERTY_L1_K5__ KC_T

#define ____QWERTY_L2_K1__ KC_A
#define ____QWERTY_L2_K2__ KC_S
#define ____QWERTY_L2_K3__ KC_D
#define ____QWERTY_L2_K4__ KC_F
#define ____QWERTY_L2_K5__ KC_G

#define ____QWERTY_L3_K1__ LGUI_T(KC_Z)
#define ____QWERTY_L3_K2__ LALT_T(KC_X)
#define ____QWERTY_L3_K3__ LSFT_T(KC_C)
#define ____QWERTY_L3_K4__ LCTL_T(KC_V)
#define ____QWERTY_L3_K5__ KC_B



#define ____QWERTY_R1_K1__ KC_Y
#define ____QWERTY_R1_K2__ KC_U
#define ____QWERTY_R1_K3__ KC_I
#define ____QWERTY_R1_K4__ KC_O
#define ____QWERTY_R1_K5__ KC_P

#define ____QWERTY_R2_K1__ KC_H
#define ____QWERTY_R2_K2__ KC_J
#define ____QWERTY_R2_K3__ KC_K
#define ____QWERTY_R2_K4__ KC_L
#define ____QWERTY_R2_K5__ DK_ARNG

#define ____QWERTY_R3_K1__ KC_N
#define ____QWERTY_R3_K2__ RCTL_T(KC_M)
#define ____QWERTY_R3_K3__ RSFT_T(DK_AE)
#define ____QWERTY_R3_K4__ RALT_T(DK_OSTR)
#define ____QWERTY_R3_K5__ RGUI_T(KC_MINS)

#define __________________QWERTY_L1____________________			____QWERTY_L1_K1__,    ____QWERTY_L1_K2__,    ____QWERTY_L1_K3__,    ____QWERTY_L1_K4__,    ____QWERTY_L1_K5__
#define __________________QWERTY_L2____________________			____QWERTY_L2_K1__,    ____QWERTY_L2_K2__,    ____QWERTY_L2_K3__,    ____QWERTY_L2_K4__,    ____QWERTY_L2_K5__
#define __________________QWERTY_L3____________________			____QWERTY_L3_K1__,    ____QWERTY_L3_K2__,    ____QWERTY_L3_K3__,    ____QWERTY_L3_K4__,    ____QWERTY_L3_K5__

#define __________________QWERTY_R1____________________			____QWERTY_R1_K1__,    ____QWERTY_R1_K2__,    ____QWERTY_R1_K3__,    ____QWERTY_R1_K4__,    ____QWERTY_R1_K5__
#define __________________QWERTY_R2____________________			____QWERTY_R2_K1__,    ____QWERTY_R2_K2__,    ____QWERTY_R2_K3__,    ____QWERTY_R2_K4__,    ____QWERTY_R2_K5__
#define __________________QWERTY_R3____________________			____QWERTY_R3_K1__,    ____QWERTY_R3_K2__,    ____QWERTY_R3_K3__,    ____QWERTY_R3_K4__,    ____QWERTY_R3_K5__


#define _QWERTY_THUMB_L1__ KC_DEL
#define _QWERTY_THUMB_L2__ DK_COMM
#define _QWERTY_THUMB_L3__ KC_BSPC

#define _QWERTY_THUMB_R1__ KC_SPACE
#define _QWERTY_THUMB_R2__ DK_DOT
#define _QWERTY_THUMB_R3__ KC_ENT

#define _QWERTY_THUMBS_LEFT_2__                             _QWERTY_THUMB_L2__, _QWERTY_THUMB_L3__
#define _QWERTY_THUMBS_RIGHT_2__                            _QWERTY_THUMB_R1__, _QWERTY_THUMB_R2__

#define _QWERTY_THUMBS_LEFT_3__                             _QWERTY_THUMB_L1__, _QWERTY_THUMB_L2__, _QWERTY_THUMB_L3__
#define _QWERTY_THUMBS_RIGHT_3__                            _QWERTY_THUMB_R1__, _QWERTY_THUMB_R2__, _QWERTY_THUMB_R3__

#define __QWERTY_THUMBS_4__                                  _QWERTY_THUMBS_LEFT_2__, _QWERTY_THUMBS_RIGHT_2__
#define __QWERTY_THUMBS_5__                                  _QWERTY_THUMB_L1__, _QWERTY_THUMB_L2__, _QWERTY_THUMB_R1__, _QWERTY_THUMB_R2__, _QWERTY_THUMB_R3__
#define __QWERTY_THUMBS_6__                                  _QWERTY_THUMBS_LEFT_3__, _QWERTY_THUMBS_RIGHT_3__

/* Norto https://lykt.xyz/skl/norto/#da
 *
 * ,----------------------------------.           ,----------------------------------.
 * |   Ø  |   Æ  |   U  |   G  |   J  |           |   B  |   F  |   L  |   H  |   X  |
 * |------+------+------+------+------|           |------+------+------+------+------|
 * |   O  |   I  |   A  |   T  |   M  |           |   P  |   N  |   R  |   S  |   D  |
 * |------+------+------+------+------|           |------+------+------+------+------|
 * |   Y  |   Å  |   V  |   C  |   ,  |           |   .  |   W  |   K  |   Z  |   Q  |
 * `----------------------------------'           `----------------------------------'
 *                  ,--------------------.    ,--------------------.
 *                  | LOWER| Enter|   E  |    |BckSpc| Space| RAISE|
 *                  `--------------------'    `--------------------.
 */

#define __NORTO_THUMB_L1__ KC_DOT
#define __NORTO_THUMB_L2__ DK_MINS
#define __NORTO_THUMB_L3__ KC_E
#define __NORTO_THUMB_R1__ KC_SPACE
#define __NORTO_THUMB_R2__ KC_BSPC
#define __NORTO_THUMB_R3__ DK_COMM

#define __NORTO_THUMBS_LEFT_2__                             __NORTO_THUMB_L2__, __NORTO_THUMB_L3__
#define __NORTO_THUMBS_RIGHT_2__                            __NORTO_THUMB_R1__, __NORTO_THUMB_R2__

#define __NORTO_THUMBS_LEFT_3__                             __NORTO_THUMB_L1__, __NORTO_THUMB_L2__, __NORTO_THUMB_L3__
#define __NORTO_THUMBS_RIGHT_3__                            __NORTO_THUMB_R1__, __NORTO_THUMB_R2__, __NORTO_THUMB_R3__

#define __NORTO_THUMBS_4__                                  __NORTO_THUMBS_LEFT_2__, __NORTO_THUMBS_RIGHT_2__
#define __NORTO_THUMBS_5__                                  __NORTO_THUMB_L1__, __NORTO_THUMB_L2__, __NORTO_THUMB_R1__, __NORTO_THUMB_R2__, __NORTO_THUMB_R3__
#define __NORTO_THUMBS_6__                                  __NORTO_THUMBS_LEFT_3__, __NORTO_THUMBS_RIGHT_3__

#define ____NORTO_L1_K1__ DK_OSTR
#define ____NORTO_L1_K2__ DK_AE
#define ____NORTO_L1_K3__ KC_U
#define ____NORTO_L1_K4__ KC_G
#define ____NORTO_L1_K5__ KC_J

#define ____NORTO_L2_K1__ KC_O
#define ____NORTO_L2_K2__ KC_I
#define ____NORTO_L2_K3__ KC_A
#define ____NORTO_L2_K4__ KC_T
#define ____NORTO_L2_K5__ KC_M

#define ____NORTO_L3_K1__ LGUI_T(DK_COMM)
#define ____NORTO_L3_K2__ LALT_T(KC_Y)
#define ____NORTO_L3_K3__ LSFT_T(DK_ARNG)
#define ____NORTO_L3_K4__ LCTL_T(KC_V)
#define ____NORTO_L3_K5__ KC_C

#define ____NORTO_R1_K1__ KC_B
#define ____NORTO_R1_K2__ KC_F
#define ____NORTO_R1_K3__ KC_L
#define ____NORTO_R1_K4__ KC_H
#define ____NORTO_R1_K5__ KC_X

#define ____NORTO_R2_K1__ KC_P
#define ____NORTO_R2_K2__ KC_N
#define ____NORTO_R2_K3__ KC_R
#define ____NORTO_R2_K4__ KC_S
#define ____NORTO_R2_K5__ KC_D

#define ____NORTO_R3_K1__ KC_W
#define ____NORTO_R3_K2__ RCTL_T(KC_K)
#define ____NORTO_R3_K3__ RSFT_T(KC_Z)
#define ____NORTO_R3_K4__ RALT_T(KC_Q)
#define ____NORTO_R3_K5__ RGUI_T(KC_DOT)

#define __________________NORTO_L1____________________			____NORTO_L1_K1__,    ____NORTO_L1_K2__,    ____NORTO_L1_K3__,    ____NORTO_L1_K4__,    ____NORTO_L1_K5__
#define __________________NORTO_L2____________________			____NORTO_L2_K1__,    ____NORTO_L2_K2__,    ____NORTO_L2_K3__,    ____NORTO_L2_K4__,    ____NORTO_L2_K5__
#define __________________NORTO_L3____________________			____NORTO_L3_K1__,    ____NORTO_L3_K2__,    ____NORTO_L3_K3__,    ____NORTO_L3_K4__,    ____NORTO_L3_K5__

#define __________________NORTO_R1____________________			____NORTO_R1_K1__,    ____NORTO_R1_K2__,    ____NORTO_R1_K3__,    ____NORTO_R1_K4__,    ____NORTO_R1_K5__
#define __________________NORTO_R2____________________			____NORTO_R2_K1__,    ____NORTO_R2_K2__,    ____NORTO_R2_K3__,    ____NORTO_R2_K4__,    ____NORTO_R2_K5__
#define __________________NORTO_R3____________________			____NORTO_R3_K1__,    ____NORTO_R3_K2__,    ____NORTO_R3_K3__,    ____NORTO_R3_K4__,    ____NORTO_R3_K5__

// BLANK FULL LINE
#define ___________________BLANK___________________			_______, _______, _______, _______, _______

// NAVNORT

#define __NORTNAV_L1_K1__ KC_ESC
#define __NORTNAV_L1_K2__ KC_PGUP
#define __NORTNAV_L1_K3__ KC_UP
#define __NORTNAV_L1_K4__ KC_PGDN
#define __NORTNAV_L1_K5__ KC_T

#define __NORTNAV_L2_K1__ KC_HOME
#define __NORTNAV_L2_K2__ KC_LEFT
#define __NORTNAV_L2_K3__ KC_DOWN
#define __NORTNAV_L2_K4__ KC_RGHT
#define __NORTNAV_L2_K5__ KC_END

#define __NORTNAV_L3_K1__ LGUI_T(_______)
#define __NORTNAV_L3_K2__ LALT_T(KC_K)
#define __NORTNAV_L3_K3__ LSFT_T(_______)
#define __NORTNAV_L3_K4__ LCTL_T(_______)
#define __NORTNAV_L3_K5__ KC_PSCR

#define ____________NORTNAVIGATION_1_______________			__NORTNAV_L1_K1__, __NORTNAV_L1_K2__, __NORTNAV_L1_K3__, __NORTNAV_L1_K4__, __NORTNAV_L1_K5__
#define ____________NORTNAVIGATION_2_______________			__NORTNAV_L2_K1__, __NORTNAV_L2_K2__, __NORTNAV_L2_K3__, __NORTNAV_L2_K4__, __NORTNAV_L2_K5__
#define ____________NORTNAVIGATION_3_______________			__NORTNAV_L3_K1__, __NORTNAV_L3_K2__, __NORTNAV_L3_K3__, __NORTNAV_L3_K4__, __NORTNAV_L3_K5__

#define __NUMPAD_R1_K1__ DK_ASTR
#define __NUMPAD_R1_K2__ KC_7
#define __NUMPAD_R1_K3__ KC_8
#define __NUMPAD_R1_K4__ KC_9
#define __NUMPAD_R1_K5__ DK_PLUS

#define __NUMPAD_R2_K1__ DK_SLSH
#define __NUMPAD_R2_K2__ KC_4
#define __NUMPAD_R2_K3__ KC_5
#define __NUMPAD_R2_K4__ KC_6
#define __NUMPAD_R2_K5__ DK_MINS

#define __NUMPAD_R3_K1__ DK_LPRN
#define __NUMPAD_R3_K2__ RCTL_T(KC_1)
#define __NUMPAD_R3_K3__ RSFT_T(KC_2)
#define __NUMPAD_R3_K4__ RALT_T(KC_3)
#define __NUMPAD_R3_K5__ RGUI_T(KC_0)

#define _________________NUMPAD_1__________________			__NUMPAD_R1_K1__, __NUMPAD_R1_K2__, __NUMPAD_R1_K3__, __NUMPAD_R1_K4__, __NUMPAD_R1_K5__
#define _________________NUMPAD_2__________________			__NUMPAD_R2_K1__, __NUMPAD_R2_K2__, __NUMPAD_R2_K3__, __NUMPAD_R2_K4__, __NUMPAD_R2_K5__
#define _________________NUMPAD_3__________________			__NUMPAD_R3_K1__, __NUMPAD_R3_K2__, __NUMPAD_R3_K3__, __NUMPAD_R3_K4__, __NUMPAD_R3_K5__

// FKeys + SYM
#define ______FKEY____L1_K1__ KC_F1
#define ______FKEY____L1_K2__ KC_F2
#define ______FKEY____L1_K3__ KC_F3
#define ______FKEY____L1_K4__ KC_F4
#define ______FKEY____L1_K5__ KC_F5

#define ______FKEY____L2_K1__ KC_F6
#define ______FKEY____L2_K2__ KC_F7
#define ______FKEY____L2_K3__ KC_F8
#define ______FKEY____L2_K4__ KC_F9
#define ______FKEY____L2_K5__ KC_F10

#define ______FKEY____L3_K1__ LGUI_T(KC_F11)
#define ______FKEY____L3_K2__ LALT_T(KC_F12)
#define ______FKEY____L3_K3__ LSFT_T(KC_C)
#define ______FKEY____L3_K4__ LCTL_T(KC_V)
#define ______FKEY____L3_K5__ KC_B

#define __NORTSYMBOLS_R1_K1__ DK_AT // @
#define __NORTSYMBOLS_R1_K2__ DK_LBRC // [ - Shifted ]
#define __NORTSYMBOLS_R1_K3__ DK_LCBR // { - Shifted {}
#define __NORTSYMBOLS_R1_K4__ DK_CIRC
#define __NORTSYMBOLS_R1_K5__ _______

#define __NORTSYMBOLS_R2_K1__ DK_QUOT // ' SHFITED "
#define __NORTSYMBOLS_R2_K2__ DK_LABK // < - Shifted >
#define __NORTSYMBOLS_R2_K3__ DK_DLR // $ - Shifted €
#define __NORTSYMBOLS_R2_K4__ DK_PIPE // |
#define __NORTSYMBOLS_R2_K5__ DK_GRV // ` - Shifted ¨

#define __NORTSYMBOLS_R3_K1__ _______
#define __NORTSYMBOLS_R3_K2__ RCTL_T(C_CAPSWORD)
#define __NORTSYMBOLS_R3_K3__ RSFT_T(C_UNDERSCORECASE)
#define __NORTSYMBOLS_R3_K4__ RALT_T(C_HYPHENCASE)
#define __NORTSYMBOLS_R3_K5__ RGUI_T(_______)



#define ___________________FKEY______L1________________			______FKEY____L1_K1__, ______FKEY____L1_K2__, ______FKEY____L1_K3__, ______FKEY____L1_K4__, ______FKEY____L1_K5__
#define ___________________FKEY______L2________________			______FKEY____L2_K1__, ______FKEY____L2_K2__, ______FKEY____L2_K3__, ______FKEY____L2_K4__, ______FKEY____L2_K5__
#define ___________________FKEY______L3________________         ______FKEY____L3_K1__, ______FKEY____L3_K2__, ______FKEY____L3_K3__, ______FKEY____L3_K4__, ______FKEY____L3_K5__

#define ________________NORTSYMBOLS_R1_________________			__NORTSYMBOLS_R1_K1__, __NORTSYMBOLS_R1_K2__, __NORTSYMBOLS_R1_K3__, __NORTSYMBOLS_R1_K4__, __NORTSYMBOLS_R1_K5__
#define ________________NORTSYMBOLS_R2_________________			__NORTSYMBOLS_R2_K1__, __NORTSYMBOLS_R2_K2__, __NORTSYMBOLS_R2_K3__, __NORTSYMBOLS_R2_K4__, __NORTSYMBOLS_R2_K5__
#define ________________NORTSYMBOLS_R3_________________			__NORTSYMBOLS_R3_K1__, __NORTSYMBOLS_R3_K2__, __NORTSYMBOLS_R3_K3__, __NORTSYMBOLS_R3_K4__, __NORTSYMBOLS_R3_K5__

// GAMES_LAYER?


#define _________________KB_SETUP_1________________     AS_UP,   DT_UP,   KC_C,    KC_V,    KC_G
#define _________________KB_SETUP_2________________     AS_DOWN,    DT_DOWN,    KC_E,    KC_R,    KC_D
#define _________________KB_SETUP_3________________     AS_RPT,    DT_PRNT,    KC_TAB,  KC_L,    KC_H
#define _________________KB_SETUP_4________________     KC_T,    KC_COMM, KC_K,    KC_SCLN, KC_DOT


#define ___________________GAMES_0_________________     KC_F1,   KC_F2,   KC_C,    KC_V,    KC_G
#define ___________________GAMES_1_________________     KC_Q,    KC_W,    KC_E,    KC_R,    KC_D
#define ___________________GAMES_2_________________     KC_A,    KC_F,    KC_TAB,  KC_L,    KC_H
#define ___________________GAMES_3_________________     KC_T,    KC_COMM, KC_K,    KC_SCLN, KC_DOT
#define __GAMES_R0_L__ KC_F4
#define __GAMES_R1_L__ KC_Z
#define __GAMES_R2_L__ KC_P
#define __GAMES_R3_L__ KC_LSFT
#define __GAMES_R0_R__ KC_N
#define __GAMES_R1_R__ KC_Y
#define __GAMES_R2_R__ KC_F7
#define __GAMES_R3_R__ KC_ESC
#define __GAMES_TH_L__ KC_LALT
#define __GAMES_TH_C__ KC_X
#define __GAMES_TH_R__ KC_B
#define __GAMES_R4_1__ KC_J
#define __GAMES_R4_2__ __GAMES_R3_R__
#define __GAMES_R4_3__ KC_LCTL


// clang-format on
