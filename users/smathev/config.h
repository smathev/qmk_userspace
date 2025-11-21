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

// ============================================================================
// USERSPACE-WIDE CONFIGURATION
// These settings apply to ALL keyboards using the smathev userspace
// For keyboard-specific settings, use keyboards/.../keymaps/smathev/config.h
// ============================================================================

// Tapping and timing configuration

#define AUTO_SHIFT_TIMEOUT 175   // at what point are you holding the key to send a SHIFTED value
#define TAPPING_TERM 175   // Enable per-key tapping term (needed for tap dance timing)
#define FLOW_TAP 150
#define PERMISSIVE_HOLD
#define CHORDAL_HOLD
#define RETRO_SHIFT 500
#define RETRO_TAPPING


#define DUMMY_MOD_NEUTRALIZER_KEYCODE KC_RIGHT_CTRL

// Neutralize left alt and left GUI (Default value)
#define MODS_TO_NEUTRALIZE { MOD_BIT(KC_LEFT_ALT), MOD_BIT(KC_LEFT_GUI) }

// Combo configuration

#ifdef OLED_ENABLE
#define OLED_DISPLAY_128X32
#endif
