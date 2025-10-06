/* Copyright 2022 Sadek Baroudi <sadekbaroudi@gmail.com>
 *#define TAPPING_TERM 140
#define AUTO_SHIFT_TIMEOUT 170  // Slightly longer than TAPPING_TERM
#define RETRO_SHIFT
#define RETRO_TAPPINGThis program is free software: you can redistribute it and/or modify
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
#define ENABLE_COMPILE_KEYCODE
#pragma once

// #include "config_common.h"

/*
 * Keyboard Matrix Assignments
 *
 * Change this to how you wired your keyboard
 * COLS: AVR pins used for columns, left to right
 * ROWS: AVR pins used for rows, top to bottom
 * DIODE_DIRECTION: COL2ROW = COL = Anode (+), ROW = Cathode (-, marked on diode)
 *                  ROW2COL = ROW = Anode (+), COL = Cathode (-, marked on diode)
 *                  NO_DIODE = switches are directly connected to AVR pins
 *
*/
#define DIRECT_PINS { \
    { B5, F7, F6, F5, F4 }, \
    { B4, D4, C6, D7, E6 }, \
    { B3, B2, B6, B7, D5 }, \
    { F0, F1, C7, NO_PIN, NO_PIN } \
}

#ifdef OLED_ENABLE
#define OLED_DISPLAY_128X32
#endif

// #define SSD1306OLED
#undef USE_I2C
//#undef SSD1306OLED

/* Debounce reduces chatter (unintended double-presses) - set 0 if debouncing is not needed */
#define DEBOUNCE 5

/* Mechanical locking support. Use KC_LCAP, KC_LNUM or KC_LSCR instead in keymap */
#define LOCKING_SUPPORT_ENABLE
/* Locking resynchronize hack */
#define LOCKING_RESYNC_ENABLE

/* Serial settings */
#define USE_SERIAL
/* serial.c configuration for split keyboard */
#define SOFT_SERIAL_PIN D2

#define TAPPING_TERM 140
#define PERMISSIVE_HOLD  // Activate mod immediately when another key pressed
#define AUTO_SHIFT_TIMEOUT 170
#define RETRO_SHIFT
#define RETRO_TAPPING

// #define MASTER_LEFT

// Use EE_HANDS to allow USB connection on either side
// Flash each half with appropriate handedness bootloader
#define EE_HANDS

/*#define SPLIT_USB_DETECT
#define SPLIT_LAYER_STATE_ENABLE */
#define SPLIT_WPM_ENABLE
#define SPLIT_MODS_ENABLE
#define SPLIT_LAYER_STATE_ENABLE
// Smathev - define combos
#define COMBO_COUNT 17

#define CASEMODES_ENABLE

#define COMBO_REF_DEFAULT _NORTO

/* Backwards compatibility with existing out-of-tree keymaps */
#define LAYOUT_sweeeeep LAYOUT_split_3x5_3



#define OLED_FONT_H "keyboards/fingerpunch/sweeeeep/keymaps/smathev/glcdfont.c"
