#!/usr/bin/env bash
# =============================================================================
# Test Device Detection Functions
# =============================================================================
# Standalone test script for device_detection.sh library
# =============================================================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../lib"

# Source the device detection library
source "$LIB_DIR/device_detection.sh"

# Set configuration for testing
export USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
export RP2040_PATTERN="*RP2040*"
export USB_WAIT_INTERVAL=0.5

echo "╔═══════════════════════════════════════════════════════╗"
echo "║  Device Detection Library Test                        ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Test 1: Check if device is currently connected
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: Looking for currently connected RP2040..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Quick check without waiting
device_found=""
for path in "${USB_MOUNT_PATHS[@]}"; do
    device_found=$(find "$path" -maxdepth 2 -type d -name "$RP2040_PATTERN" 2>/dev/null | head -n1)
    if [[ -n "$device_found" ]]; then
        break
    fi
done

if [[ -n "$device_found" ]]; then
    echo "✅ RP2040 device found at: $device_found"
    echo ""

    # Test 2: Get USB serial
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test 2: Getting USB serial from host..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    usb_serial=$(get_usb_serial_from_host "$device_found")
    if [[ -n "$usb_serial" ]]; then
        echo "✅ USB Serial: $usb_serial"
    else
        echo "⚠️  USB Serial not available"
    fi
    echo ""

    # Test 3: Get USB device path
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test 3: Getting USB device path..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    usb_path=$(get_usb_device_path "$device_found")
    if [[ -n "$usb_path" ]]; then
        echo "✅ USB Path: $usb_path"
    else
        echo "⚠️  USB Path not available"
    fi
    echo ""

    # Test 4: Get device identifier
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test 4: Getting device identifier..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    device_id=$(get_device_identifier "$device_found")
    echo "✅ Device Identifier: $device_id"
    echo ""

    # Test 5: Print full device info
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test 5: Full device information..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_device_info "$device_found"
    echo ""

else
    echo "⚠️  No RP2040 device currently connected"
    echo ""
    echo "To test device detection:"
    echo "  1. Enter bootloader mode on your keyboard (double-tap RESET)"
    echo "  2. Run this test script again"
    echo ""
    echo "Or test the wait function (will wait for device):"
    read -rp "Wait for device? [y/n]: " wait_test

    if [[ "$wait_test" == "y" ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Test: Waiting for RP2040 device..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Enter bootloader mode on your keyboard now..."
        echo ""

        mount_point=$(wait_for_rp2040)
        echo ""
        echo "✅ Device detected!"
        echo ""
        print_device_info "$mount_point"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Device detection tests complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
