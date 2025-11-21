#pragma once
#include "smathev.h"
#include "keymap_danish.h"

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


#define __NORTO_THUMB_L1__ _______
#define __NORTO_THUMB_L2__ LT(_MOUSENAV, DK_MINS)
#define __NORTO_THUMB_L3__ LT(_NORTNAVIGATION, KC_E)
#define __NORTO_THUMB_R1__ KC_SPACE
#define __NORTO_THUMB_R2__ KC_BSPC
#define __NORTO_THUMB_R3__ _______

#define __NORTO_THUMBS_LEFT_2__                             __NORTO_THUMB_L2__, __NORTO_THUMB_L3__
#define __NORTO_THUMBS_RIGHT_2__                            __NORTO_THUMB_R1__, __NORTO_THUMB_R2__

#define __NORTO_THUMBS_LEFT_3__                             __NORTO_THUMB_L1__, __NORTO_THUMB_L2__, __NORTO_THUMB_L3__
#define __NORTO_THUMBS_RIGHT_3__                            __NORTO_THUMB_R1__, __NORTO_THUMB_R2__, __NORTO_THUMB_R3__

#define __NORTO_THUMBS_4__                                  __NORTO_THUMBS_LEFT_2__, __NORTO_THUMBS_RIGHT_2__
#define __NORTO_THUMBS_5__                                  __NORTO_THUMB_L1__, __NORTO_THUMB_L2__, __NORTO_THUMB_R1__, __NORTO_THUMB_R2__, __NORTO_THUMB_R3__
#define __NORTO_THUMBS_6__                                  __NORTO_THUMBS_LEFT_3__, __NORTO_THUMBS_RIGHT_3__

#define _NOR_NAV_THUMB_L1_ _______
#define _NOR_NAV_THUMB_L2_ _______
#define _NOR_NAV_THUMB_L3_ _______
#define _NOR_NAV_THUMB_R1_ _______
#define _NOR_NAV_THUMB_R2_ KC_DEL
#define _NOR_NAV_THUMB_R3_ _______

#define _NOR_NAV_THUMBS_LEFT_2__                             _NOR_NAV_THUMB_L1_, _NOR_NAV_THUMB_L2_
#define _NOR_NAV_THUMBS_RIGHT_2__                            _NOR_NAV_THUMB_R1_, _NOR_NAV_THUMB_R2_
#define _NOR_NAV_THUMBS_LEFT_3__                             _NOR_NAV_THUMBS_LEFT_2__, _NOR_NAV_THUMB_L3_
#define _NOR_NAV_THUMBS_RIGHT_3__                            _NOR_NAV_THUMBS_RIGHT_2__, _NOR_NAV_THUMB_R3_

#define _NOR_NAV_THUMBS_4__                                  _NOR_NAV_THUMBS_LEFT_2__, _NOR_NAV_THUMBS_RIGHT_2__
#define _NOR_NAV_THUMBS_5__                                  _NOR_NAV_THUMB_L1_, _NOR_NAV_THUMB_L2_, _NOR_NAV_THUMB_R1_, _NOR_NAV_THUMB_R2_, _NOR_NAV_THUMB_R3_
#define _NOR_NAV_THUMBS_6__                                  _NOR_NAV_THUMBS_LEFT_3__, _NOR_NAV_THUMBS_RIGHT_3__

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
#define __NORTNAV_L3_K2__ LALT_T(_______)
#define __NORTNAV_L3_K3__ LSFT_T(_______)
#define __NORTNAV_L3_K4__ LCTL_T(_______)
#define __NORTNAV_L3_K5__ LT(_SYMFKEYS, KC_PSCR)

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
#define ______FKEY____L3_K3__ LSFT_T(_______)
#define ______FKEY____L3_K4__ LCTL_T(_______)
#define ______FKEY____L3_K5__ _______


#define __NORTSYMBOLS_R1_K1__ _______
#define __NORTSYMBOLS_R1_K2__ XCASE_DK_SNAKE
#define __NORTSYMBOLS_R1_K3__ XCASE_DK_KEBAB
#define __NORTSYMBOLS_R1_K4__ XCASE_CAMEL
#define __NORTSYMBOLS_R1_K5__ XCASE_OFF

#define __NORTSYMBOLS_R2_K1__ DK_AT // @
#define __NORTSYMBOLS_R2_K2__ DK_LBRC // [ - Shifted ]
#define __NORTSYMBOLS_R2_K3__ DK_LCBR // { - Shifted {}
#define __NORTSYMBOLS_R2_K4__ DK_CIRC
#define __NORTSYMBOLS_R2_K5__ _______

#define __NORTSYMBOLS_R3_K1__ DK_QUOT // ' SHFITED "
#define __NORTSYMBOLS_R3_K2__ DK_LABK // < - Shifted >
#define __NORTSYMBOLS_R3_K3__ DK_DLR // $ - Shifted €
#define __NORTSYMBOLS_R3_K4__ DK_PIPE // |
#define __NORTSYMBOLS_R3_K5__ DK_GRV // ` - Shifted ¨





#define ___________________FKEY______L1________________			______FKEY____L1_K1__, ______FKEY____L1_K2__, ______FKEY____L1_K3__, ______FKEY____L1_K4__, ______FKEY____L1_K5__
#define ___________________FKEY______L2________________			______FKEY____L2_K1__, ______FKEY____L2_K2__, ______FKEY____L2_K3__, ______FKEY____L2_K4__, ______FKEY____L2_K5__
#define ___________________FKEY______L3________________         ______FKEY____L3_K1__, ______FKEY____L3_K2__, ______FKEY____L3_K3__, ______FKEY____L3_K4__, ______FKEY____L3_K5__

#define ________________NORTSYMBOLS_R1_________________			__NORTSYMBOLS_R1_K1__, __NORTSYMBOLS_R1_K2__, __NORTSYMBOLS_R1_K3__, __NORTSYMBOLS_R1_K4__, __NORTSYMBOLS_R1_K5__
#define ________________NORTSYMBOLS_R2_________________			__NORTSYMBOLS_R2_K1__, __NORTSYMBOLS_R2_K2__, __NORTSYMBOLS_R2_K3__, __NORTSYMBOLS_R2_K4__, __NORTSYMBOLS_R2_K5__
#define ________________NORTSYMBOLS_R3_________________			__NORTSYMBOLS_R3_K1__, __NORTSYMBOLS_R3_K2__, __NORTSYMBOLS_R3_K3__, __NORTSYMBOLS_R3_K4__, __NORTSYMBOLS_R3_K5__



#define _________________KB_SETUP_1________________     AS_UP,   DT_UP,   KC_C,    KC_V,    KC_G
#define _________________KB_SETUP_2________________     AS_DOWN,    DT_DOWN,    KC_E,    KC_R,    KC_D
#define _________________KB_SETUP_3________________     AS_RPT,    DT_PRNT,    KC_TAB,  KC_L,    KC_H
#define _________________KB_SETUP_4________________     KC_T,    KC_COMM, KC_K,    KC_SCLN, KC_DOT


// // MOUSENAV
// #define ____MOUSENAV__L1_K1__ _______
// #define ____MOUSENAV__L1_K2__ MS_WHLU
// #define ____MOUSENAV__L1_K3__ MS_UP
// #define ____MOUSENAV__L1_K4__ MS_WHLD
// #define ____MOUSENAV__L1_K5__ _______

// #define ____MOUSENAV__L2_K1__ MS_WHLL
// #define ____MOUSENAV__L2_K2__ MS_LEFT
// #define ____MOUSENAV__L2_K3__ MS_DOWN
// #define ____MOUSENAV__L2_K4__ MS_RGHT
// #define ____MOUSENAV__L2_K5__ MS_WHLR

// #define ____MOUSENAV__L3_K1__ LGUI_T(_______)
// #define ____MOUSENAV__L3_K2__ LALT_T(_______)
// #define ____MOUSENAV__L3_K3__ LSFT_T(_______)
// #define ____MOUSENAV__L3_K4__ LCTL_T(_______)
// #define ____MOUSENAV__L3_K5__ _______


// #define ___MOUSENAV_R1_K1___ MS_ACL0
// #define ___MOUSENAV_R1_K2___ MS_ACL1
// #define ___MOUSENAV_R1_K3___ MS_ACL2
// #define ___MOUSENAV_R1_K4___ _______
// #define ___MOUSENAV_R1_K5___ _______

// #define ___MOUSENAV_R2_K1___ _______
// #define ___MOUSENAV_R2_K2___ MS_BTN1
// #define ___MOUSENAV_R2_K3___ MS_BTN2
// #define ___MOUSENAV_R2_K4___ MS_BTN2
// #define ___MOUSENAV_R2_K5___ _______

// #define ___MOUSENAV_R3_K1___ LGUI_T(_______)
// #define ___MOUSENAV_R3_K2___ LALT_T(_______)
// #define ___MOUSENAV_R3_K3___ LSFT_T(_______)
// #define ___MOUSENAV_R3_K4___ LCTL_T(_______)
// #define ___MOUSENAV_R3_K5___ _______

// #define _________________MOUSENAV____L1________________			____MOUSENAV__L1_K1__, ____MOUSENAV__L1_K2__, ____MOUSENAV__L1_K3__, ____MOUSENAV__L1_K4__, ____MOUSENAV__L1_K5__
// #define _________________MOUSENAV____L2________________			____MOUSENAV__L2_K1__, ____MOUSENAV__L2_K2__, ____MOUSENAV__L2_K3__, ____MOUSENAV__L2_K4__, ____MOUSENAV__L2_K5__
// #define _________________MOUSENAV____L3________________         ____MOUSENAV__L3_K1__, ____MOUSENAV__L3_K2__, ____MOUSENAV__L3_K3__, ____MOUSENAV__L3_K4__, ____MOUSENAV__L3_K5__

// #define ________________MOUSENAV_R1_________________			___MOUSENAV_R1_K1___, ___MOUSENAV_R1_K2___, ___MOUSENAV_R1_K3___, ___MOUSENAV_R1_K4___, ___MOUSENAV_R1_K5___
// #define ________________MOUSENAV_R2_________________			___MOUSENAV_R2_K1___, ___MOUSENAV_R2_K2___, ___MOUSENAV_R2_K3___, ___MOUSENAV_R2_K4___, ___MOUSENAV_R2_K5___
// #define ________________MOUSENAV_R3_________________			___MOUSENAV_R3_K1___, ___MOUSENAV_R3_K2___, ___MOUSENAV_R3_K3___, ___MOUSENAV_R3_K4___, ___MOUSENAV_R3_K5___


// #define __MOUSENAV_THUMB_L1__ MS_BTN3
// #define __MOUSENAV_THUMB_L2__ MS_BTN2
// #define __MOUSENAV_THUMB_L3__ MS_BTN1
// #define __MOUSENAV_THUMB_R1__ _______
// #define __MOUSENAV_THUMB_R2__ _______
// #define __MOUSENAV_THUMB_R3__ _______

// #define _MOUSENAV_THUMBS_LEFT_2__                             __MOUSENAV_THUMB_L1__, __MOUSENAV_THUMB_L2__
// #define _MOUSENAV_THUMBS_RIGHT_2__                            __MOUSENAV_THUMB_R1__, __MOUSENAV_THUMB_R2__
// #define _MOUSENAV_THUMBS_LEFT_3__                             _MOUSENAV_THUMBS_LEFT_2__, __MOUSENAV_THUMB_L3__
// #define _MOUSENAV_THUMBS_RIGHT_3__                            _MOUSENAV_THUMBS_RIGHT_2__, __MOUSENAV_THUMB_R3__

// #define _MOUSENAV_THUMBS_4__                                  _MOUSENAV_THUMBS_LEFT_2__, _MOUSENAV_THUMBS_RIGHT_2__
// #define _MOUSENAV_THUMBS_5__                                  __MOUSENAV_THUMB_L1__, __MOUSENAV_THUMB_L2__, __MOUSENAV_THUMB_R1__, __MOUSENAV_THUMB_R2__, __MOUSENAV_THUMB_R3__
// #define _MOUSENAV_THUMBS_6__                                  _MOUSENAV_THUMBS_LEFT_3__, _MOUSENAV_THUMBS_RIGHT_3__


#define ____MOUSENAV__L1_K1__ _______
#define ____MOUSENAV__L1_K2__ OM_W_U
#define ____MOUSENAV__L1_K3__ OM_U
#define ____MOUSENAV__L1_K4__ OM_W_D
#define ____MOUSENAV__L1_K5__ _______

#define ____MOUSENAV__L2_K1__ OM_W_L
#define ____MOUSENAV__L2_K2__ OM_L
#define ____MOUSENAV__L2_K3__ OM_D
#define ____MOUSENAV__L2_K4__ OM_R
#define ____MOUSENAV__L2_K5__ OM_W_R

#define ____MOUSENAV__L3_K1__ OM_CS_L
#define ____MOUSENAV__L3_K2__ OM_CS_U
#define ____MOUSENAV__L3_K3__ OM_CS_D
#define ____MOUSENAV__L3_K4__ OM_CS_R
#define ____MOUSENAV__L3_K5__ _______


#define ___MOUSENAV_R1_K1___ _______
#define ___MOUSENAV_R1_K2___ _______
#define ___MOUSENAV_R1_K3___ _______
#define ___MOUSENAV_R1_K4___ _______
#define ___MOUSENAV_R1_K5___ _______

#define ___MOUSENAV_R2_K1___ _______
#define ___MOUSENAV_R2_K2___ OM_SLOW
#define ___MOUSENAV_R2_K3___ OM_FAST
#define ___MOUSENAV_R2_K4___ _______
#define ___MOUSENAV_R2_K5___ _______

#define ___MOUSENAV_R3_K1___ LGUI_T(_______)
#define ___MOUSENAV_R3_K2___ LALT_T(_______)
#define ___MOUSENAV_R3_K3___ LSFT_T(_______)
#define ___MOUSENAV_R3_K4___ LCTL_T(_______)
#define ___MOUSENAV_R3_K5___ _______

#define _________________MOUSENAV____L1________________			____MOUSENAV__L1_K1__, ____MOUSENAV__L1_K2__, ____MOUSENAV__L1_K3__, ____MOUSENAV__L1_K4__, ____MOUSENAV__L1_K5__
#define _________________MOUSENAV____L2________________			____MOUSENAV__L2_K1__, ____MOUSENAV__L2_K2__, ____MOUSENAV__L2_K3__, ____MOUSENAV__L2_K4__, ____MOUSENAV__L2_K5__
#define _________________MOUSENAV____L3________________         ____MOUSENAV__L3_K1__, ____MOUSENAV__L3_K2__, ____MOUSENAV__L3_K3__, ____MOUSENAV__L3_K4__, ____MOUSENAV__L3_K5__

#define ________________MOUSENAV_R1_________________			___MOUSENAV_R1_K1___, ___MOUSENAV_R1_K2___, ___MOUSENAV_R1_K3___, ___MOUSENAV_R1_K4___, ___MOUSENAV_R1_K5___
#define ________________MOUSENAV_R2_________________			___MOUSENAV_R2_K1___, ___MOUSENAV_R2_K2___, ___MOUSENAV_R2_K3___, ___MOUSENAV_R2_K4___, ___MOUSENAV_R2_K5___
#define ________________MOUSENAV_R3_________________			___MOUSENAV_R3_K1___, ___MOUSENAV_R3_K2___, ___MOUSENAV_R3_K3___, ___MOUSENAV_R3_K4___, ___MOUSENAV_R3_K5___


#define __MOUSENAV_THUMB_L1__ _______
#define __MOUSENAV_THUMB_L2__ _______
#define __MOUSENAV_THUMB_L3__ _______
#define __MOUSENAV_THUMB_R1__ OM_BTN1
#define __MOUSENAV_THUMB_R2__ OM_BTN2
#define __MOUSENAV_THUMB_R3__ _______

#define _MOUSENAV_THUMBS_LEFT_2__                             __MOUSENAV_THUMB_L1__, __MOUSENAV_THUMB_L2__
#define _MOUSENAV_THUMBS_RIGHT_2__                            __MOUSENAV_THUMB_R1__, __MOUSENAV_THUMB_R2__
#define _MOUSENAV_THUMBS_LEFT_3__                             _MOUSENAV_THUMBS_LEFT_2__, __MOUSENAV_THUMB_L3__
#define _MOUSENAV_THUMBS_RIGHT_3__                            _MOUSENAV_THUMBS_RIGHT_2__, __MOUSENAV_THUMB_R3__

#define _MOUSENAV_THUMBS_4__                                  _MOUSENAV_THUMBS_LEFT_2__, _MOUSENAV_THUMBS_RIGHT_2__
#define _MOUSENAV_THUMBS_5__                                  __MOUSENAV_THUMB_L1__, __MOUSENAV_THUMB_L2__, __MOUSENAV_THUMB_R1__, __MOUSENAV_THUMB_R2__, __MOUSENAV_THUMB_R3__
#define _MOUSENAV_THUMBS_6__                                  _MOUSENAV_THUMBS_LEFT_3__, _MOUSENAV_THUMBS_RIGHT_3__
// clang-format on
