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
#define TAPPING_TERM 140
#define PERMISSIVE_HOLD         // Activate mod immediately when another key pressed
#define AUTO_SHIFT_TIMEOUT 170  // Slightly longer than TAPPING_TERM
#define RETRO_SHIFT             // Enable retroactive shift
#define RETRO_TAPPING           // Enable retroactive tapping

// Combo configuration
#define CASEMODES_ENABLE
#define COMBO_REF_DEFAULT _NORTO
