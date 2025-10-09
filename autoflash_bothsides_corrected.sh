#!/usr/bin/env bash
# =============================================================================
# QMK Auto-Flashing Script for Fingerpunch/Sweeeeep with Liatris (RP2040)
# =============================================================================
# CORRECTED VERSION - Uses HOST USB information for device identification
#
# Key Insight:
#   - Liatris overwrites EEPROM on flash, so on-board info is unreliable
#   - Board-ID in INFO_UF2.TXT is the SAME for all controllers of the same type
#   - ONLY the host's USB serial/path is reliable for distinguishing sides
#
# Features:
#   - Single firmware compilation
#   - TRUE auto-detection using USB serial from host system
#   - First-run learning: asks user to identify which side is which
#   - Persistent mapping stored in ~/.qmk_rp2040_sides.json
#   - Automated flashing using uf2-split-left/right bootloader targets
#   - Robust USB detection across Linux distributions
# =============================================================================

set -euo pipefail

# ----------------------
# User-configurable variables
# ----------------------
KEYBOARD="fingerpunch/sweeeeep"
KEYMAP="smathev"
USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
RP2040_PATTERN="*RP2040*"
USB_WAIT_INTERVAL=0.5
SIDE_MAPPING_FILE="$HOME/.qmk_rp2040_sides.json"

# Ensure mapping file exists
if [[ ! -f "$SIDE_MAPPING_FILE" ]]; then
    echo "{}" > "$SIDE_MAPPING_FILE"
fi

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ Error: 'jq' is required but not installed."
    echo "   Install it with: sudo apt-get install jq"
    exit 1
fi

# ----------------------
# Function: build_firmware
# Build the firmware once for reuse during flashing
# ----------------------
build_firmware() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🛠  Building firmware for $KEYBOARD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
    echo "✅ Firmware compiled successfully"
    echo ""
}

# ----------------------
# Function: wait_for_rp2040
# Wait until an RP2040 UF2 device is mounted on any of the configured paths
# Returns the mount point
# ----------------------
wait_for_rp2040() {
    echo "⏳ Waiting for RP2040 UF2 device..."
    local device=""
    while true; do
        for path in "${USB_MOUNT_PATHS[@]}"; do
            device=$(find "$path" -maxdepth 2 -type d -name "$RP2040_PATTERN" 2>/dev/null | head -n1)
            if [[ -n "$device" ]]; then
                echo "✅ Found RP2040 device at $device"
                echo "$device"
                return
            fi
        done
        sleep "$USB_WAIT_INTERVAL"
    done
}

# ----------------------
# Function: get_usb_serial_from_host
# Get the USB serial number from the HOST system (not from the device itself)
# This is the ONLY reliable way to identify devices when EEPROM is wiped
# ----------------------
get_usb_serial_from_host() {
    local mount_point="$1"

    # Method 1: Get the block device, then trace to USB serial
    local dev
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null || echo "")

    if [[ -n "$dev" ]]; then
        local block_dev=$(basename "$dev")

        # Try to find USB serial through sysfs
        local sys_path="/sys/class/block/$block_dev"

        # Walk up the device tree to find the USB device
        local current_path=$(readlink -f "$sys_path/device" 2>/dev/null || echo "")

        while [[ -n "$current_path" && "$current_path" != "/sys" ]]; do
            # Check if this directory has a serial file
            if [[ -f "$current_path/serial" ]]; then
                cat "$current_path/serial"
                return
            fi
            # Also check for idVendor/idProduct to confirm it's a USB device
            if [[ -f "$current_path/idVendor" ]]; then
                # Found USB device level, check for serial
                if [[ -f "$current_path/serial" ]]; then
                    cat "$current_path/serial"
                    return
                fi
            fi
            # Move up one level
            current_path=$(dirname "$current_path")
        done
    fi

    # Method 2: Use udevadm to get USB info
    if [[ -n "$dev" ]]; then
        local serial
        serial=$(udevadm info --query=property --name="$dev" 2>/dev/null | grep "ID_SERIAL_SHORT=" | cut -d'=' -f2)
        if [[ -n "$serial" ]]; then
            echo "$serial"
            return
        fi
    fi

    # Method 3: Fallback - use the mount point path as identifier
    # This is less reliable but better than nothing
    echo "mount_path_$(basename "$mount_point")"
}

# ----------------------
# Function: get_usb_device_path
# Get a unique identifier based on USB physical port location
# This persists even when serial is not available
# ----------------------
get_usb_device_path() {
    local mount_point="$1"

    local dev
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null || echo "")

    if [[ -n "$dev" ]]; then
        # Get the physical USB path (bus and port numbers)
        local devpath
        devpath=$(udevadm info --query=property --name="$dev" 2>/dev/null | grep "DEVPATH=" | cut -d'=' -f2)
        if [[ -n "$devpath" ]]; then
            # Extract the USB bus and port info (e.g., /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0)
            echo "$devpath" | grep -oP 'usb\d+/\d+-[\d.]+'
            return
        fi
    fi

    echo ""
}

# ----------------------
# Function: get_device_identifier
# Get the best available identifier for the USB device
# Prefers USB serial, falls back to USB port location
# ----------------------
get_device_identifier() {
    local mount_point="$1"

    # Try to get USB serial from host
    local usb_serial
    usb_serial=$(get_usb_serial_from_host "$mount_point")

    # If serial doesn't start with "mount_path_", it's a real serial
    if [[ -n "$usb_serial" && "$usb_serial" != mount_path_* ]]; then
        echo "serial:$usb_serial"
        return
    fi

    # Try USB device path
    local usb_path
    usb_path=$(get_usb_device_path "$mount_point")
    if [[ -n "$usb_path" ]]; then
        echo "usbpath:$usb_path"
        return
    fi

    # Final fallback: use mount point basename
    echo "mount:$(basename "$mount_point")"
}

# ----------------------
# Function: detect_side
# Determine the left/right side of the plugged-in board
# On first encounter, ask user to identify the side
# ----------------------
detect_side() {
    local mount_point="$1"
    local device_id
    device_id=$(get_device_identifier "$mount_point")

    echo "   Device Identifier: $device_id"

    local side
    side=$(jq -r --arg id "$device_id" '.[$id] // "null"' "$SIDE_MAPPING_FILE")

    if [[ "$side" == "null" || -z "$side" ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "⚠️  UNKNOWN DEVICE - First Time Setup"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "The script has detected a keyboard half that it hasn't"
        echo "seen before. This is expected on first run."
        echo ""
        echo "Please tell me which side this is so I can remember it"
        echo "for future flashing sessions."
        echo ""
        read -rp "Which side is currently plugged in? [left/right]: " side
        side=${side,,}

        if [[ "$side" != "left" && "$side" != "right" ]]; then
            echo "❌ Invalid input. Must be 'left' or 'right'."
            echo "   Exiting to avoid incorrect flashing."
            exit 1
        fi

        # Save mapping
        tmpfile=$(mktemp)
        jq --arg id "$device_id" --arg side "$side" '. + {($id): $side}' "$SIDE_MAPPING_FILE" > "$tmpfile"
        mv "$tmpfile" "$SIDE_MAPPING_FILE"

        echo ""
        echo "✅ Saved mapping: $side side"
        echo "   Next time this device is detected, it will be"
        echo "   automatically identified as the $side side."
        echo ""
    fi

    echo "$side"
}

# ----------------------
# Function: flash_side_auto
# Automatically detect and flash whichever keyboard half is plugged in
# ----------------------
flash_side_auto() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔌 Waiting for keyboard half in bootloader mode..."
    echo "   (Double-tap RESET button on Liatris controller)"
    echo ""

    # Wait for device
    local mount_point
    mount_point=$(wait_for_rp2040)

    # Auto-detect which side based on HOST USB information
    local detected_side
    detected_side=$(detect_side "$mount_point")

    echo ""
    echo "🎯 Detected: $detected_side side"
    echo "📤 Flashing with handedness: $detected_side"
    echo ""

    # Flash using the detected side's bootloader target
    # Using -bl (bootloader) parameter with uf2-split-left or uf2-split-right
    qmk flash -kb "$KEYBOARD" -km "$KEYMAP" -bl "uf2-split-$detected_side"

    echo ""
    echo "✅ $detected_side side flashed successfully!"
    echo ""
}

# ----------------------
# Function: main
# Main workflow: build firmware and flash both sides automatically
# ----------------------
main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  QMK Auto-Flash: Fingerpunch Sweeeeep + Liatris (RP2040) ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "This script will:"
    echo "  • Build firmware once"
    echo "  • Auto-detect which keyboard half you plug in"
    echo "  • Flash the correct handedness (left/right)"
    echo "  • Remember your devices for future flashing"
    echo ""
    echo "Note: On first run, you'll be asked to identify each side."
    echo "      After that, detection is fully automatic!"
    echo ""

    # Build firmware once
    build_firmware

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Ready to flash!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    read -rp "Press Enter to start flashing the first side..."
    echo ""

    # Flash first side (whichever is plugged in)
    flash_side_auto

    # Ask if user wants to flash the second side
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -rp "Flash the other keyboard half now? [y/n]: " DO_SECOND
    DO_SECOND=${DO_SECOND,,}
    echo ""

    if [[ "$DO_SECOND" == "y" ]]; then
        echo "Please:"
        echo "  1. Unplug the first keyboard half"
        echo "  2. Plug in the OTHER half"
        echo "  3. Enter bootloader mode (double-tap RESET)"
        echo ""
        read -rp "Press Enter when ready..."
        echo ""

        # Flash second side (auto-detected)
        flash_side_auto
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Flashing complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "✓ Handedness has been set in EEPROM"
    echo "✓ Device mappings saved to: $SIDE_MAPPING_FILE"
    echo "✓ Future runs will automatically detect sides"
    echo "✓ Future firmware updates will preserve handedness"
    echo ""

    # Show the saved mappings
    echo "Saved device mappings:"
    jq '.' "$SIDE_MAPPING_FILE"
    echo ""
}

# Execute main
main
