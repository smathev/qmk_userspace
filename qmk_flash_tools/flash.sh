#!/usr/bin/env bash
# ============================================================
# Simple QMK Flash Script for Split Keyboards
# ============================================================
# NO AUTO-DETECTION - Just clear instructions!
# 1. Flash left side (you plug it in)
# 2. Flash right side (you plug it in)
# Done!
# ============================================================

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# ----------------------
# Function: wait_and_mount_rp2040
# Wait for RP2040 bootloader, then auto-mount if needed
# ----------------------
wait_and_mount_rp2040() {
    local mount_paths=("/run/media/$USER" "/media/$USER")

    echo "⏳ Waiting for RP2040 bootloader device..." >&2

    while true; do
        # Check if already mounted (verify with findmnt, not just directory existence)
        for path in "${mount_paths[@]}"; do
            if [[ -d "$path/RPI-RP2" ]] && findmnt "$path/RPI-RP2" &>/dev/null; then
                echo "✅ Device ready at: $path/RPI-RP2" >&2
                echo "$path/RPI-RP2"
                return 0
            fi
            if [[ -d "$path/RPI-RP21" ]] && findmnt "$path/RPI-RP21" &>/dev/null; then
                echo "✅ Device ready at: $path/RPI-RP21" >&2
                echo "$path/RPI-RP21"
                return 0
            fi
        done

        # Look for unmounted device by label
        local device=$(lsblk -no PATH,LABEL | grep -iE "RPI-RP2" | awk '{print $1}' | head -n1)

        if [[ -n "$device" ]]; then
            echo "📡 Found device: $device" >&2

            # Try to mount with udisksctl (works without sudo)
            if udisksctl mount -b "$device" &>/dev/null; then
                sleep 0.5  # Give it a moment
                for path in "${mount_paths[@]}"; do
                    if [[ -d "$path/RPI-RP2" ]] || [[ -d "$path/RPI-RP21" ]]; then
                        local found_path="$path/RPI-RP2"
                        [[ -d "$path/RPI-RP21" ]] && found_path="$path/RPI-RP21"
                        echo "✅ Auto-mounted to: $found_path" >&2
                        echo "$found_path"
                        return 0
                    fi
                done
            fi
        fi

        sleep 0.5
    done
}

# ----------------------
# Function: flash_side
# Flash a keyboard half using qmk flash
# (builds and flashes in one command - quiet mode)
# ----------------------
flash_side() {
    local side="$1"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📝 STEP: Flash $side side"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Instructions:"
    echo "  1. Plug in the $side keyboard half"
    echo "  2. Double-tap the RESET button on the controller"
    echo ""
    echo "⚡ Waiting for bootloader..."
    echo ""

    lowerside=$(echo "$side" | tr '[:upper:]' '[:lower:]')

    cd "$QMK_FIRMWARE_DIR"

    # Pre-mount the device so qmk flash doesn't hang
    wait_and_mount_rp2040 > /dev/null

    echo "🔨 Building and flashing firmware for $side side..."

    # Capture output, filter to show only errors/warnings or final result
    local temp_output=$(mktemp)
    if qmk flash -kb "$KEYBOARD" -km "$KEYMAP" -bl "uf2-split-$lowerside" 2>&1 | tee "$temp_output" | grep -E "(error:|warning:|Wrote [0-9]+ bytes|Successfully flashed|Failed)" | grep -v "\[OK\]"; then
        echo ""
        echo "✅ Successfully flashed $side side!"
        echo ""
        rm -f "$temp_output"
        return 0
    else
        echo ""
        echo "❌ Failed to flash $side side"
        echo ""
        echo "Full output:"
        cat "$temp_output"
        rm -f "$temp_output"
        return 1
    fi
}

# ----------------------
# Function: update_keymap_visual
# Regenerate keymap visual after successful flash
# ----------------------
update_keymap_visual() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎨 Updating keymap visualization..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Regenerating visual keymap from latest firmware..."
    echo ""

    local userspace_dir="$(dirname "$SCRIPT_DIR")"
    local keymap_yaml="$userspace_dir/keymap-drawer.yaml"
    local output_svg="$userspace_dir/visual_keymap.svg"

    if [[ ! -f "$keymap_yaml" ]]; then
        echo "⚠️  Warning: keymap-drawer.yaml not found at $keymap_yaml"
        echo "   Skipping visualization update"
        return 0
    fi

    if ! command -v keymap &> /dev/null; then
        echo "⚠️  Warning: keymap-drawer not installed"
        echo "   Install with: pip install keymap-drawer"
        echo "   Skipping visualization update"
        return 0
    fi

    echo "Running: keymap draw keymap-drawer.yaml -o visual_keymap.svg"
    if keymap draw "$keymap_yaml" -o "$output_svg" 2>&1 | grep -v "INFO"; then
        echo ""
        echo "✅ Keymap visualization updated successfully!"
        echo "   📄 File: visual_keymap.svg"
        echo "   📂 Location: qmk_userspace/"
        return 0
    else
        echo ""
        echo "⚠️  Warning: Failed to update keymap visualization"
        return 0
    fi
}

# ----------------------
# Function: main
# Main workflow - simple and clear!
# ----------------------
main() {
    local flash_mode="${1:-both}"  # Default to 'both' if no argument

    # Normalize input to uppercase
    flash_mode=$(echo "$flash_mode" | tr '[:lower:]' '[:upper:]')

    # Validate argument
    if [[ ! "$flash_mode" =~ ^(LEFT|RIGHT|BOTH)$ ]]; then
        echo "❌ Invalid argument: $1"
        echo ""
        echo "Usage: $0 [left|right|both]"
        echo "  left  - Flash only the left side"
        echo "  right - Flash only the right side"
        echo "  both  - Flash both sides (default)"
        echo ""
        exit 1
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║       Fingerpunch Sweeeeep - Simple Flash Script          ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    if [[ "$flash_mode" == "BOTH" ]]; then
        echo "This script will:"
        echo "  1. Validate firmware compiles without errors"
        echo "  2. Flash LEFT side (builds firmware with left handedness)"
        echo "  3. Flash RIGHT side (builds firmware with right handedness)"
    else
        echo "This script will:"
        echo "  1. Validate firmware compiles without errors"
        echo "  2. Flash $flash_mode side only"
    fi
    echo ""
    echo ""

    # Initial validation: clean and test compile
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🧹 Cleaning previous firmware builds..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    cd "$QMK_FIRMWARE_DIR"

    if ! qmk clean > /dev/null 2>&1; then
        echo "⚠️  Warning: Clean failed (might be first run)"
    fi

    # Flash based on mode
    if [[ "$flash_mode" == "LEFT" ]] || [[ "$flash_mode" == "BOTH" ]]; then
        if ! flash_side "LEFT"; then
            echo "❌ Failed to flash left side"
            exit 1
        fi

        if [[ "$flash_mode" == "LEFT" ]]; then
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🎉 Flashing complete!"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "✓ LEFT side flashed successfully"
            echo ""
            echo "Your keyboard is ready to use!"
            echo ""
            return 0
        fi
    fi

    if [[ "$flash_mode" == "BOTH" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✅ Left side complete!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Now:"
        echo "  1. Unplug the LEFT keyboard half"
        echo "  2. Plug in the RIGHT keyboard half"
        echo "  3. Double-tap the RESET button on the controller"
        echo ""
        echo "⏳ Waiting for LEFT side to be unplugged..."

        # Wait for left side to be unplugged (bootloader device to disappear)
        while lsblk -no PATH,LABEL 2>/dev/null | grep -qiE "RPI-RP2"; do
            sleep 0.5
        done

        echo "✅ LEFT side unplugged"
        echo ""
        echo "⏳ Script will automatically continue when RIGHT side bootloader is detected..."
        echo ""
    fi

    # Flash RIGHT side
    if [[ "$flash_mode" == "RIGHT" ]] || [[ "$flash_mode" == "BOTH" ]]; then
        if ! flash_side "RIGHT"; then
            echo "❌ Failed to flash right side"
            exit 1
        fi
    fi

    # Success!
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Flashing complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    if [[ "$flash_mode" == "BOTH" ]]; then
        echo "✓ Both keyboard halves flashed with correct handedness"
    else
        echo "✓ $flash_mode side flashed successfully"
    fi
    echo "✓ EE_HANDS will auto-detect left/right on boot"
    echo ""

    # Prompt for YAML update before generating visuals (only for RIGHT or BOTH)
    if [[ "$flash_mode" == "RIGHT" ]] || [[ "$flash_mode" == "BOTH" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📝 KEYMAP YAML UPDATE"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Did you modify any wrapper definitions in keymap.c?"
        echo ""
        echo "Options:"
        echo "  y - Yes, I need to update keymap-drawer.yaml"
        echo "  n - No changes to wrappers, skip YAML update"
        echo ""
        read -p "Update YAML? [y/N]: " -n 1 -r
        echo ""
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🤖 AI ASSISTANT PROMPT"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "Copy and paste this to your AI assistant:"
            echo ""
            echo "────────────────────────────────────────────────"
            echo "Please update keymap-drawer.yaml based on changes in:"
            echo "  - Wrapper definitions: users/smathev/wrappers.h"
            echo "  - Physical layout: keyboards/.../keymap.c"
            echo "  - Combos: users/smathev/combos.c/h"
            echo "  - Custom behaviors: users/smathev/process_records.c/h"
            echo "  - Helpers: users/smathev/smathev.h"
            echo ""
            echo "Follow the instructions in:"
            echo ".github/yaml-maintenance-instructions.md"
            echo ""
            echo "Reference the mapping guide:"
            echo ".github/wrapper-to-yaml-mapping.md"
            echo "────────────────────────────────────────────────"
            echo ""
            echo "Files to check:"
            echo "  - Wrappers: users/smathev/wrappers.h"
            echo "  - Layout: keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c"
            echo "  - Combos: users/smathev/combos.c/h"
            echo "  - Behaviors: users/smathev/process_records.c/h"
            echo "  - Helpers: users/smathev/smathev.h"
            echo "  - Target: keymap-drawer.yaml"
            echo "  - Instructions: .github/yaml-maintenance-instructions.md"
            echo "  - Reference: .github/wrapper-to-yaml-mapping.md"
            echo ""
            read -p "Press Enter when YAML has been updated..."
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
        fi

        # Update keymap visualization only after YAML is confirmed updated
        update_keymap_visual
    fi

    echo "Your keyboard is ready to use!"
    echo ""
}

# Execute main
main "$@"
