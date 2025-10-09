#!/usr/bin/env bash
# =============================================================================
# QMK Auto-Flashing Script for Fingerpunch/Sweeeeep with Liatris (RP2040)
# =============================================================================
# OPTIMIZED VERSION - Features:
#   - Single firmware compilation
#   - TRUE auto-detection: plug in any side, script detects which it is
#   - Automated handedness-aware flashing using uf2-split-left/right bootloader targets
#   - Robust USB detection across Linux distributions
#   - Persistent mapping of USB devices to left/right sides (~/.qmk_rp2040_sides.json)
#   - No need to specify which side first - script figures it out!
#   - Waits for device mount before flashing
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
# Function: get_rp2040_usb_serial
# Attempt to get the USB serial number of the RP2040 device
# Returns empty string if unavailable
# ----------------------
get_rp2040_usb_serial() {
    local mount_point="$1"
    local dev
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null || echo "")
    if [[ -n "$dev" ]]; then
        local sys_path
        sys_path=$(readlink -f "/sys/class/block/$(basename "$dev")/device" 2>/dev/null || echo "")
        if [[ -f "$sys_path/serial" ]]; then
            cat "$sys_path/serial"
            return
        fi
    fi
    echo ""
}

# ----------------------
# Function: get_rp2040_id
# Extract a unique identifier from the mounted RP2040
# Prefers USB serial, falls back to info_uf2.txt Board ID, then mount path
# ----------------------
get_rp2040_id() {
    local mount_point="$1"
    local usb_serial
    usb_serial=$(get_rp2040_usb_serial "$mount_point")
    if [[ -n "$usb_serial" ]]; then
        echo "$usb_serial"
    elif [[ -f "$mount_point/INFO_UF2.TXT" ]]; then
        grep -i "^Board-ID" "$mount_point/INFO_UF2.TXT" | awk -F': ' '{print $2}' | tr -d '\r\n '
    elif [[ -f "$mount_point/info_uf2.txt" ]]; then
        grep -i "^Board-ID" "$mount_point/info_uf2.txt" | awk -F': ' '{print $2}' | tr -d '\r\n '
    else
        basename "$mount_point"
    fi
}

# ----------------------
# Function: detect_side
# Determine the left/right side of the plugged-in board
# If unknown, prompt the user and update mapping
# ----------------------
detect_side() {
    local mount_point="$1"
    local rp_id
    rp_id=$(get_rp2040_id "$mount_point")

    echo "   Device ID: $rp_id"

    local side
    side=$(jq -r --arg id "$rp_id" '.[$id] // "null"' "$SIDE_MAPPING_FILE")

    if [[ "$side" == "null" || -z "$side" ]]; then
        echo ""
        echo "⚠️  Unknown device detected!"
        read -rp "   Which side is this keyboard half? [left/right]: " side
        side=${side,,}
        if [[ "$side" != "left" && "$side" != "right" ]]; then
            echo "   Invalid input. Defaulting to left."
            side="left"
        fi
        # Save mapping
        tmpfile=$(mktemp)
        jq --arg id "$rp_id" --arg side "$side" '. + {($id): $side}' "$SIDE_MAPPING_FILE" > "$tmpfile"
        mv "$tmpfile" "$SIDE_MAPPING_FILE"
        echo "   ✅ Saved mapping: $rp_id → $side"
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

    # Auto-detect which side
    local detected_side
    detected_side=$(detect_side "$mount_point")

    echo ""
    echo "🎯 Detected: $detected_side side"
    echo "📤 Flashing as $detected_side..."
    echo ""

    # Flash using the detected side's bootloader target
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

    # Build firmware once
    build_firmware

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Ready to flash!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Instructions:"
    echo "  1. Enter bootloader on FIRST keyboard half (either side)"
    echo "  2. Script will auto-detect which side it is"
    echo "  3. After first side completes, do the same for the OTHER half"
    echo ""
    read -rp "Press Enter when ready to start..."
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
        echo "  1. Unplug the keyboard half you just flashed"
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
    echo "✓ Future firmware updates can be flashed to both sides"
    echo "✓ Handedness will persist across updates"
    echo ""
}

# Execute main
main
