#!/usr/bin/env bash
# =============================================================================
# QMK Helper Functions Library
# =============================================================================
# Functions for building and flashing QMK firmware
# =============================================================================

# ----------------------
# Function: build_firmware
# Build QMK firmware for the specified keyboard and keymap
# Usage: build_firmware "fingerpunch/sweeeeep" "smathev"
# ----------------------
build_firmware() {
    local keyboard="$1"
    local keymap="$2"

    if [[ -z "$keyboard" || -z "$keymap" ]]; then
        echo "❌ Error: keyboard and keymap required" >&2
        return 1
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "🛠  Building firmware for $keyboard" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2

    qmk compile -kb "$keyboard" -km "$keymap"

    if [[ $? -eq 0 ]]; then
        echo "✅ Firmware compiled successfully" >&2
        echo "" >&2
        return 0
    else
        echo "❌ Firmware compilation failed" >&2
        return 1
    fi
}

# ----------------------
# Function: flash_with_bootloader
# Flash firmware using a specific bootloader target
# Usage: flash_with_bootloader "fingerpunch/sweeeeep" "smathev" "uf2-split-left"
# ----------------------
flash_with_bootloader() {
    local keyboard="$1"
    local keymap="$2"
    local bootloader="$3"

    if [[ -z "$keyboard" || -z "$keymap" || -z "$bootloader" ]]; then
        echo "❌ Error: keyboard, keymap, and bootloader required" >&2
        return 1
    fi

    echo "📤 Flashing firmware with bootloader: $bootloader" >&2
    echo "" >&2

    qmk flash -kb "$keyboard" -km "$keymap" -bl "$bootloader"

    if [[ $? -eq 0 ]]; then
        echo "" >&2
        echo "✅ Firmware flashed successfully!" >&2
        return 0
    else
        echo "" >&2
        echo "❌ Firmware flashing failed" >&2
        return 1
    fi
}

# ----------------------
# Function: flash_side
# Flash firmware for a specific keyboard side (left/right)
# Usage: flash_side "fingerpunch/sweeeeep" "smathev" "left"
# ----------------------
flash_side() {
    local keyboard="$1"
    local keymap="$2"
    local side="$3"

    if [[ -z "$keyboard" || -z "$keymap" || -z "$side" ]]; then
        echo "❌ Error: keyboard, keymap, and side required" >&2
        return 1
    fi

    if [[ "$side" != "left" && "$side" != "right" ]]; then
        echo "❌ Error: side must be 'left' or 'right'" >&2
        return 1
    fi

    local bootloader="uf2-split-$side"

    echo "🎯 Flashing $side side with handedness" >&2

    flash_with_bootloader "$keyboard" "$keymap" "$bootloader"
}

# ----------------------
# Function: check_qmk_installed
# Verify QMK CLI is installed and available
# Usage: check_qmk_installed || exit 1
# ----------------------
check_qmk_installed() {
    if ! command -v qmk &> /dev/null; then
        echo "❌ Error: 'qmk' CLI is not installed or not in PATH" >&2
        echo "   Install it with: python3 -m pip install qmk" >&2
        return 1
    fi
    return 0
}

# ----------------------
# Function: verify_keyboard_exists
# Check if a keyboard definition exists in QMK
# Usage: verify_keyboard_exists "fingerpunch/sweeeeep"
# ----------------------
verify_keyboard_exists() {
    local keyboard="$1"

    if [[ -z "$keyboard" ]]; then
        echo "❌ Error: keyboard required" >&2
        return 1
    fi

    # Try to list keymaps for this keyboard
    qmk list-keymaps -kb "$keyboard" &>/dev/null

    if [[ $? -eq 0 ]]; then
        return 0
    else
        echo "❌ Error: Keyboard '$keyboard' not found in QMK" >&2
        return 1
    fi
}

# ----------------------
# Function: clean_build
# Clean previous build artifacts
# Usage: clean_build
# ----------------------
clean_build() {
    echo "🧹 Cleaning previous build..." >&2
    qmk clean &>/dev/null
    echo "✅ Build directory cleaned" >&2
}
