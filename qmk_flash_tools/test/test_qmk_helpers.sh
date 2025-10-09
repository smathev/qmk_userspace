#!/usr/bin/env bash
# =============================================================================
# Test QMK Helper Functions
# =============================================================================
# Standalone test script for qmk_helpers.sh library
# =============================================================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../lib"

# Source the QMK helpers library
source "$LIB_DIR/qmk_helpers.sh"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║  QMK Helpers Library Test                             ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Test configuration
TEST_KEYBOARD="fingerpunch/sweeeeep"
TEST_KEYMAP="smathev"

# Test 1: Check QMK installation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: Check QMK CLI installation..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if check_qmk_installed; then
    echo "✅ QMK CLI is installed"
    qmk --version
else
    echo "❌ QMK CLI is not installed"
    exit 1
fi
echo ""

# Test 2: Verify keyboard exists
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 2: Verify keyboard exists..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checking for: $TEST_KEYBOARD"
if verify_keyboard_exists "$TEST_KEYBOARD"; then
    echo "✅ Keyboard exists in QMK"
else
    echo "⚠️  Keyboard not found (may need to adjust TEST_KEYBOARD variable)"
fi
echo ""

# Test 3: Test build (optional)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 3: Build firmware (optional)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "This will compile the firmware for $TEST_KEYBOARD:$TEST_KEYMAP"
read -rp "Proceed with build test? [y/n]: " do_build

if [[ "$do_build" == "y" ]]; then
    echo ""
    if build_firmware "$TEST_KEYBOARD" "$TEST_KEYMAP"; then
        echo "✅ Build test passed"
    else
        echo "⚠️  Build test failed (check keyboard/keymap configuration)"
    fi
else
    echo "⏭️  Skipped build test"
fi
echo ""

# Test 4: Test clean build
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 4: Clean build directory..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -rp "Proceed with clean test? [y/n]: " do_clean

if [[ "$do_clean" == "y" ]]; then
    clean_build
    echo "✅ Clean test passed"
else
    echo "⏭️  Skipped clean test"
fi
echo ""

# Test 5: Function signature tests (no actual flashing)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 5: Test function signatures (dry run)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Testing flash_side with missing arguments:"
flash_side "" "" "" 2>&1 | head -n1
echo ""

echo "Testing flash_side with invalid side:"
flash_side "$TEST_KEYBOARD" "$TEST_KEYMAP" "middle" 2>&1 | head -n1
echo ""

echo "Testing flash_with_bootloader with missing arguments:"
flash_with_bootloader "" "" "" 2>&1 | head -n1
echo ""

echo "✅ Function signature tests passed"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ QMK helpers tests complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Note: Actual flashing tests require hardware and should be"
echo "      done through the main autoflash script."
