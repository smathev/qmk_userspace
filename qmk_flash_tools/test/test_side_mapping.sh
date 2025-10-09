#!/usr/bin/env bash
# =============================================================================
# Test Side Mapping Functions
# =============================================================================
# Standalone test script for side_mapping.sh library
# =============================================================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../lib"

# Use a test mapping file
export SIDE_MAPPING_FILE="/tmp/qmk_test_mappings.json"

# Source the side mapping library
source "$LIB_DIR/side_mapping.sh"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║  Side Mapping Library Test                            ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""
echo "Test mapping file: $SIDE_MAPPING_FILE"
echo ""

# Clean up test file if it exists
rm -f "$SIDE_MAPPING_FILE"

# Test 1: Initialize mapping file
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: Initialize mapping file..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
init_mapping_file
if [[ -f "$SIDE_MAPPING_FILE" ]]; then
    echo "✅ Mapping file created"
    cat "$SIDE_MAPPING_FILE"
else
    echo "❌ Failed to create mapping file"
    exit 1
fi
echo ""

# Test 2: Check jq installation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 2: Check jq installation..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if check_jq_installed; then
    echo "✅ jq is installed"
else
    echo "❌ jq is not installed"
    exit 1
fi
echo ""

# Test 3: Save mappings
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 3: Save test mappings..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

save_side_mapping "serial:ABC123" "left"
save_side_mapping "serial:XYZ789" "right"
save_side_mapping "usbpath:usb1/1-3" "left"

echo ""
echo "Current mappings:"
cat "$SIDE_MAPPING_FILE"
echo ""

# Test 4: Retrieve saved sides
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 4: Retrieve saved sides..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

side1=$(get_saved_side "serial:ABC123")
echo "Device serial:ABC123 → $side1"
if [[ "$side1" == "left" ]]; then
    echo "✅ Correct"
else
    echo "❌ Expected 'left', got '$side1'"
fi

side2=$(get_saved_side "serial:XYZ789")
echo "Device serial:XYZ789 → $side2"
if [[ "$side2" == "right" ]]; then
    echo "✅ Correct"
else
    echo "❌ Expected 'right', got '$side2'"
fi

side3=$(get_saved_side "serial:UNKNOWN")
echo "Device serial:UNKNOWN → ${side3:-[not found]}"
if [[ -z "$side3" ]]; then
    echo "✅ Correct (not found)"
else
    echo "❌ Expected empty, got '$side3'"
fi
echo ""

# Test 5: List all mappings
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 5: List all mappings..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
list_all_mappings
echo ""

# Test 6: Clear specific mapping
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 6: Clear specific mapping..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
clear_mapping "usbpath:usb1/1-3"
echo ""
echo "Mappings after clearing 'usbpath:usb1/1-3':"
cat "$SIDE_MAPPING_FILE"
echo ""

# Test 7: Interactive test (optional)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 7: Interactive prompt test (optional)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -rp "Test the interactive prompt? [y/n]: " test_prompt

if [[ "$test_prompt" == "y" ]]; then
    echo ""
    test_device_id="serial:TEST_DEVICE"
    detected_side=$(detect_side "$test_device_id")
    echo ""
    echo "You identified the device as: $detected_side"
    echo ""
    echo "Updated mappings:"
    cat "$SIDE_MAPPING_FILE"
fi
echo ""

# Test 8: Clear all mappings
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 8: Clear all mappings..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
clear_all_mappings
echo ""
echo "Mappings after clearing all:"
cat "$SIDE_MAPPING_FILE"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Side mapping tests complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Cleaning up test file: $SIDE_MAPPING_FILE"
rm -f "$SIDE_MAPPING_FILE"
