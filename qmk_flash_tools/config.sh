#!/usr/bin/env bash
# =============================================================================
# QMK Flash Tools - Central Configuration
# =============================================================================
# Shared configuration for all flash tool scripts
# Source this file in your scripts: source "path/to/config.sh"
#
# USAGE:
#   1. Edit the values below to match your setup
#   2. All scripts will automatically use these settings
#   3. No need to edit individual scripts
# =============================================================================

# ----------------------
# Keyboard Configuration
# ----------------------
# Change these to match your keyboard and keymap
export KEYBOARD="fingerpunch/sweeeeep"
export KEYMAP="smathev"

# Derived values (do not edit)
export KEYBOARD_SAFE=$(echo "$KEYBOARD" | tr '/' '_')

# ----------------------
# QMK Directory Configuration
# ----------------------
# Path to QMK firmware directory (where qmk commands are run)
# Auto-detect: goes up from qmk_userspace/qmk_flash_tools to qmk_firmware
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export QMK_USERSPACE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/qmk_userspace"
export QMK_FIRMWARE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")/qmk_firmware"

# Verify directories exist
if [[ ! -d "$QMK_USERSPACE_DIR" ]]; then
    echo "❌ Error: QMK userspace directory not found: $QMK_USERSPACE_DIR" >&2
    echo "   Please set QMK_USERSPACE_DIR in config.sh" >&2
fi

if [[ ! -d "$QMK_FIRMWARE_DIR" ]]; then
    echo "❌ Error: QMK firmware directory not found: $QMK_FIRMWARE_DIR" >&2
    echo "   Please set QMK_FIRMWARE_DIR in config.sh" >&2
fi

# ----------------------
# USB Device Detection
# ----------------------
# Where to look for mounted USB devices (in order of preference)
# Add custom paths if your system mounts drives elsewhere
export USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")

# Pattern to match RP2040 bootloader mount points
# Change if your board uses a different bootloader name
export RP2040_PATTERN="*RP2040*"

# How long to wait between device detection attempts (in seconds)
# Increase if detection is unreliable, decrease for faster scanning
export USB_WAIT_INTERVAL=0.5

# ----------------------
# Device Mapping
# ----------------------
# File to store device-to-side mappings (left/right identification)
# Uses ~/.config by default (standard Linux location for user configs)
# Change this if you want mappings stored elsewhere
export SIDE_MAPPING_FILE="${SIDE_MAPPING_FILE:-$HOME/.config/qmk_flash_tools/device_mappings.json}"

# Ensure config directory exists
mkdir -p "$(dirname "$SIDE_MAPPING_FILE")"

# ----------------------
# Notes
# ----------------------
# - These settings are shared across all scripts (main script and tests)
# - Device mappings persist across runs (script learns your devices)
# - USB detection works even when EEPROM is wiped (uses host-side info)
# - Multiple keyboards? Create separate config files and switch between them

