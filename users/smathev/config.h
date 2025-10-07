/* Copyright 2022 Sadek Baroudi <sadekbaroudi@gmail.com>
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
#define ENABLE_COMPILE_KEYCODE
#pragma once

// Userspace-specific configuration
// Hardware-specific settings should be in the keyboard's config.h or info.json

// Tapping and timing configuration
#define TAPPING_TERM 140
#define PERMISSIVE_HOLD         // Activate mod immediately when another key pressed
#define AUTO_SHIFT_TIMEOUT 170  // Slightly longer than TAPPING_TERM
#define RETRO_SHIFT
#define RETRO_TAPPING

// Combo configuration
#define CASEMODES_ENABLE
#define COMBO_REF_DEFAULT _NORTO

// Backwards compatibility with existing keymaps
#define LAYOUT_sweeeeep LAYOUT_split_3x5_3

// Custom font for OLED (if keyboard has OLED enabled)
#define OLED_FONT_H "keyboards/fingerpunch/sweeeeep/keymaps/smathev/glcdfont.c"
