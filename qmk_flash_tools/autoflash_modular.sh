#!/usr/bin/env bash
# =============================================================================
# QMK Auto-Flashing Script (Modular Version)
# =============================================================================
# For: Fingerpunch/Sweeeeep with Liatris (RP2040)
#
# Features:
#   - Intelligent device detection with three-state verification
#   - Learns devices on first run, verifies on subsequent runs
#   - Rejects unknown devices once mapping is complete (safety)
#   - Uses HOST USB information (reliable even when EEPROM is wiped)
#   - Modular design with separate testable libraries
# =============================================================================

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# Configuration
KEYBOARD="fingerpunch/sweeeeep"
KEYMAP="smathev"
export USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
export RP2040_PATTERN="*RP2040*"
export USB_WAIT_INTERVAL=0.5
export SIDE_MAPPING_FILE="$SCRIPT_DIR/device_mappings.json"

# Source library modules
source "$LIB_DIR/device_detection.sh"
source "$LIB_DIR/side_mapping.sh"
source "$LIB_DIR/qmk_helpers.sh"

# ----------------------
# Function: flash_side_with_verification
# Ask user which side they're flashing, then verify device matches
# ----------------------
flash_side_with_verification() {
    local expected_side="$1"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "� Preparing to flash: $expected_side side"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Please enter bootloader mode on the $expected_side half:"
    echo "  • Double-tap RESET button on Liatris controller"
    echo "  • Wait for RPI-RP2 drive to appear"
    echo ""
    read -rp "Press Enter when you've entered bootloader mode..."
    echo ""
    echo "⏳ Waiting for device..."

    # Wait for device to be mounted
    local mount_point
    mount_point=$(wait_for_rp2040)

    echo ""

    # Get unique device identifier from HOST
    local device_id
    device_id=$(get_device_identifier "$mount_point")

    # Verify device matches expected side
    local verified_side
    verified_side=$(detect_side_with_expected "$device_id" "$expected_side")

    echo ""
    echo "🎯 Flashing: $verified_side side"
    echo ""

    # Flash using the verified side
    if flash_side "$KEYBOARD" "$KEYMAP" "$verified_side"; then
        echo ""
        echo "✅ $verified_side side flashed successfully!"
        echo ""
        return 0
    else
        echo ""
        echo "❌ Failed to flash $verified_side side"
        echo ""
        return 1
    fi
}

# ----------------------
# Function: flash_side_auto_detect
# Auto-detect which side is plugged in (no asking)
# Used when mapping exists (partial or complete)
# ----------------------
flash_side_auto_detect() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔌 Plug in a keyboard half and enter bootloader mode"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Instructions:"
    echo "  • Plug in the keyboard half you want to flash"
    echo "  • Double-tap RESET button on Liatris controller"
    echo "  • Wait for RPI-RP2 drive to appear"
    echo ""
    read -rp "Press Enter when you've entered bootloader mode..."
    echo ""
    echo "⏳ Waiting for device..."

    # Wait for device to be mounted
    local mount_point
    mount_point=$(wait_for_rp2040)

    echo ""

    # Get unique device identifier from HOST
    local device_id
    device_id=$(get_device_identifier "$mount_point")

    # Get saved side (if exists)
    local saved_side
    saved_side=$(get_saved_side "$device_id" 2>/dev/null)

    local detected_side

    if [[ -n "$saved_side" ]]; then
        # Device is known - use saved mapping
        echo "   🎯 Auto-detected: $saved_side side (known device)" >&2
        detected_side="$saved_side"
    else
        # Device is unknown - infer from mapping state
        local mapping_state
        mapping_state=$(get_mapping_state)

        if [[ "$mapping_state" == "partial" ]]; then
            # Partial mapping - this must be the unmapped side
            local unmapped_side
            unmapped_side=$(get_unmapped_side)
            echo "   🎯 Auto-detected: $unmapped_side side (inferred from partial mapping)" >&2
            detected_side="$unmapped_side"

            # Save this device
            echo "   📝 Saving device mapping..." >&2
            save_side_mapping "$device_id" "$detected_side"
        else
            # Complete mapping but unknown device - this should error
            echo "" >&2
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
            echo "❌ ERROR: UNKNOWN DEVICE (COMPLETE MAPPING)" >&2
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
            echo "" >&2
            echo "Detected device: $device_id" >&2
            echo "Expected one of the known devices:" >&2
            get_mapped_devices | tr ' ' '\n' | while read dev; do
                local side=$(get_saved_side "$dev")
                echo "  - $dev ($side side)" >&2
            done
            echo "" >&2
            echo "Both sides are already mapped!" >&2
            echo "If you replaced a controller, clear mappings:" >&2
            echo "  rm $SIDE_MAPPING_FILE" >&2
            return 1
        fi
    fi

    echo ""
    echo "🎯 Flashing: $detected_side side"
    echo ""

    # Flash using the detected side
    if flash_side "$KEYBOARD" "$KEYMAP" "$detected_side"; then
        echo ""
        echo "✅ $detected_side side flashed successfully!"
        echo ""
        return 0
    else
        echo ""
        echo "❌ Failed to flash $detected_side side"
        echo ""
        return 1
    fi
}

# ----------------------
# Function: main
# Main workflow
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

    # Check dependencies
    if ! check_qmk_installed; then
        exit 1
    fi

    if ! check_jq_installed; then
        exit 1
    fi

    # Initialize mapping file
    init_mapping_file

    # Build firmware once
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if ! build_firmware "$KEYBOARD" "$KEYMAP"; then
        echo "❌ Build failed. Exiting."
        exit 1
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Ready to flash!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Check mapping state to determine if we need to ask
    local mapping_state
    mapping_state=$(get_mapping_state)

    # -----------------------------------------------------------------
    # EMPTY MAPPING: Must ask user which side (learning mode)
    # -----------------------------------------------------------------
    if [[ "$mapping_state" == "empty" ]]; then
        echo "📝 First time setup - learning your keyboard halves"
        echo ""

        # Ask which side to flash first (BEFORE entering bootloader)
        local first_side
        while true; do
            read -rp "Which side will you flash first? [left/right]: " first_side
            first_side=${first_side,,}
            if [[ "$first_side" == "left" || "$first_side" == "right" ]]; then
                break
            else
                echo "⚠️  Please enter 'left' or 'right'"
            fi
        done
        echo ""

        # Flash first side with verification
        if ! flash_side_with_verification "$first_side"; then
            echo "❌ Flashing failed. Exiting."
            exit 1
        fi

        # Determine the other side
        local second_side
        if [[ "$first_side" == "left" ]]; then
            second_side="right"
        else
            second_side="left"
        fi

        # Ask if user wants to flash the second side
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        read -rp "Flash the $second_side side now? [y/n]: " DO_SECOND
        DO_SECOND=${DO_SECOND,,}
        echo ""

        if [[ "$DO_SECOND" == "y" ]]; then
            # Flash second side with verification
            if ! flash_side_with_verification "$second_side"; then
                echo "❌ Flashing failed. Exiting."
                exit 1
            fi
        fi

    # -----------------------------------------------------------------
    # PARTIAL or COMPLETE MAPPING: Auto-detect (no asking needed)
    # -----------------------------------------------------------------
    else
        echo "✅ Device mapping exists - auto-detection enabled"
        echo ""

        # Flash first side with auto-detection
        if ! flash_side_auto_detect; then
            echo "❌ Flashing failed. Exiting."
            exit 1
        fi

        # Ask if user wants to flash the second side
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        read -rp "Flash the other keyboard half now? [y/n]: " DO_SECOND
        DO_SECOND=${DO_SECOND,,}
        echo ""

        if [[ "$DO_SECOND" == "y" ]]; then
            # Flash second side with auto-detection
            if ! flash_side_auto_detect; then
                echo "❌ Flashing failed. Exiting."
                exit 1
            fi
        fi
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
    echo "Current device mappings:"
    list_all_mappings
    echo ""
}

# Execute main
main "$@"
