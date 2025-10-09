#!/usr/bin/env bash
# =============================================================================
# Quick Testing Script - Run all tests in sequence
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  QMK Flash Tools - Quick Test Suite                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Test 1: Side Mapping (no hardware needed)
echo "Running side mapping tests..."
echo ""
bash "$SCRIPT_DIR/test_side_mapping.sh"
echo ""

# Test 2: QMK Helpers (partial, no hardware needed)
echo "Running QMK helper tests..."
echo ""
bash "$SCRIPT_DIR/test_qmk_helpers.sh"
echo ""

# Test 3: Device Detection (requires hardware)
echo "Running device detection tests..."
echo ""
read -rp "Do you have a keyboard in bootloader mode? [y/n]: " has_device

if [[ "$has_device" == "y" ]]; then
    bash "$SCRIPT_DIR/test_device_detection.sh"
else
    echo "⏭️  Skipping device detection test"
    echo "   Run manually when you have hardware ready:"
    echo "   ./test/test_device_detection.sh"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  ✅ All tests complete!                                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
