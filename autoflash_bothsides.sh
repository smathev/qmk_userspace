#!/usr/bin/env bash
# =============================================================================
# QMK Flashing Script for Fingerpunch/Sweeeeep with Liatris (RP2040)
# =============================================================================
# Features:
#   - Single prebuilt firmware compilation
#   - Automated handedness-aware flashing using uf2-split-left/right targets
#   - Robust USB detection across Linux distributions
#   - Auto-detection of which side is plugged in based on RP2040 USB serial/Board ID
#   - Persistent mapping of USB devices to left/right sides (~/.qmk_rp2040_sides.json)
#   - Optional prompting for unknown devices
#   - Waits for device mount before flashing
# =============================================================================

set -euo pipefail

# ----------------------
# User-configurable variables
# ----------------------
KEYBOARD="fingerpunch/sweeeeep"
KEYMAP="smathev"
OUTPUT_DIR="$HOME/git_dev/keyboards/latest_firmware"
USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
RP2040_PATTERN="*RP2040*"
USB_WAIT_INTERVAL=0.5
SIDE_MAPPING_FILE="$HOME/.qmk_rp2040_sides.json"

# Ensure mapping file exists
if [[ ! -f "$SIDE_MAPPING_FILE" ]]; then
    echo "{}" > "$SIDE_MAPPING_FILE"
fi

# ----------------------
# Function: build_firmware
# Build the firmware once for reuse during flashing
# ----------------------
build_firmware() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🛠 Building firmware once for $KEYBOARD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
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
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null)
    if [[ -n "$dev" ]]; then
        local sys_path
        sys_path=$(readlink -f "/sys/class/block/$(basename "$dev")/device")
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
    elif [[ -f "$mount_point/info_uf2.txt" ]]; then
        grep "^Board ID" "$mount_point/info_uf2.txt" | awk -F': ' '{print $2}'
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

    local side
    side=$(jq -r --arg id "$rp_id" '.[$id]' "$SIDE_MAPPING_FILE")

    if [[ "$side" == "null" ]]; then
        read -rp "Unknown device detected. Which side is this half? [left/right]: " side
        side=${side,,}
        if [[ "$side" != "left" && "$side" != "right" ]]; then
            echo "Invalid input. Defaulting to left."
            side="left"
        fi
        # Save mapping
        tmpfile=$(mktemp)
        jq --arg id "$rp_id" --arg side "$side" '. + {($id): $side}' "$SIDE_MAPPING_FILE" > "$tmpfile"
        mv "$tmpfile" "$SIDE_MAPPING_FILE"
    fi

    echo "$side"
}

# ----------------------
# Function: flash_side
# Flash the prebuilt firmware to the given side (left/right)
# Waits for device and applies UF2 split target
# ----------------------
flash_side() {
    local side="$1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔌 Flashing $side side..."

    # Wait for device
    local mount_point
    mount_point=$(wait_for_rp2040)

    # Auto-detect side if unknown
    local detected_side
    detected_side=$(detect_side "$mount_point")

    if [[ "$detected_side" != "$side" ]]; then
        echo "⚠️  Detected side '$detected_side' does not match expected side '$side'. Using detected side."
        side="$detected_side"
    fi

    # Flash using prebuilt UF2 split target
    qmk flash -kb "$KEYBOARD" -km "$KEYMAP:uf2-split-$side" -f

    echo "✅ $side side flashed successfully."
}

# ----------------------
# Function: main
# Main workflow: build firmware and flash both sides
# ----------------------
main() {
    build_firmware

    # Ask which side to flash first
    read -rp "Which side to flash first? [left/right]: " SIDE1
    SIDE1=${SIDE1,,}
    if [[ "$SIDE1" != "left" && "$SIDE1" != "right" ]]; then
        echo "Invalid input. Must be 'left' or 'right'."
        exit 1
    fi

    # Determine second side
    SIDE2=$([[ "$SIDE1" == "left" ]] && echo "right" || echo "left")

    read -rp "Will you flash the other side afterward? [y/n]: " DO_SECOND
    DO_SECOND=${DO_SECOND,,}

    # Flash first side
    flash_side "$SIDE1"

    # Flash second side if requested
    if [[ "$DO_SECOND" == "y" ]]; then
        echo "Please reset the $SIDE2 half now, then press Enter to continue..."
        read -r
        flash_side "$SIDE2"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 All requested flashing complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main
main
