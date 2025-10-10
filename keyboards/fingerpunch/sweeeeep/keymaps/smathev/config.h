/* Copyright 2022 Sadek Baroudi
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

#pragma once

// ============================================================================
// KEYBOARD-SPECIFIC CONFIGURATION (fingerpunch/sweeeeep)
// These settings override userspace and keyboard defaults
// ============================================================================

// Split keyboard handedness detection method
// IMPORTANT: This must be set for EE_HANDS to work properly
#define EE_HANDS

#ifdef OLED_ENABLE
#define OLED_DISPLAY_128X32
#endif

// Split keyboard features synchronization
#define SPLIT_LAYER_STATE_ENABLE   // Sync layer state between halves
#define SPLIT_MODS_ENABLE          // Sync modifier keys between halves
#define SPLIT_WPM_ENABLE           // Sync WPM counter between halves

// OLED configuration (sweeeeep-specific)
#define OLED_FONT_H "keyboards/fingerpunch/sweeeeep/keymaps/smathev/glcdfont.c"

// Backwards compatibility with existing keymaps
#define LAYOUT_sweeeeep LAYOUT_split_3x5_3
