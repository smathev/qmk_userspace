#!/usr/bin/env bash
# Complete firmware builder for fingerpunch/sweeeeep with Liatris
# Builds three versions:
#   1. Regular firmware (for normal use after handedness is set)
#   2. LEFT handedness initialization firmware
#   3. RIGHT handedness initialization firmware

set -e  # Exit on error

KEYBOARD="sweeeeep"
KEYMAP="smathev"
OUTPUT_NAME="sweeeeep_smathev"

CONFIG_FILE="$HOME/git_dev/keyboards/qmk_userspace/keyboards/fingerpunch/sweeeeep/keymaps/smathev/config.h"
BACKUP_FILE="${CONFIG_FILE}.backup"
QMK_FIRMWARE_DIR="$HOME/git_dev/keyboards/qmk_firmware"
OUTPUT_DIR="$HOME/git_dev/keyboards/latest_firmware"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔨 Building ALL firmware versions for $KEYBOARD"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚙️  Keyboard: $KEYBOARD"
echo "⚙️  Keymap: $KEYMAP"
echo "⚙️  Controller: Liatris (RP2040)"
echo ""

# Clean build
echo "🧹 Cleaning previous build..."
qmk clean > /dev/null 2>&1
echo ""

# ============================================================================
# 1. Build REGULAR firmware (for normal use)
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 [1/3] Building REGULAR firmware..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
if [ $? -eq 0 ]; then
    cp "$QMK_FIRMWARE_DIR/${OUTPUT_NAME}.uf2" "$OUTPUT_DIR/${OUTPUT_NAME}.uf2"
    echo "✅ Regular firmware: ${OUTPUT_NAME}.uf2"
else
    echo "❌ Regular firmware build failed!"
    exit 1
fi
echo ""

# Backup original config for handedness builds
cp "$CONFIG_FILE" "$BACKUP_FILE"

# ============================================================================
# 2. Build LEFT handedness initialization firmware
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 [2/3] Building LEFT hand initialization firmware..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# Add INIT_EE_HANDS_LEFT to config
sed -i '/^#define EE_HANDS/a #define INIT_EE_HANDS_LEFT' "$CONFIG_FILE"

qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
if [ $? -eq 0 ]; then
    cp "$QMK_FIRMWARE_DIR/${OUTPUT_NAME}.uf2" "$OUTPUT_DIR/${OUTPUT_NAME}_LEFT.uf2"
    echo "✅ LEFT hand firmware: ${OUTPUT_NAME}_LEFT.uf2"
else
    echo "❌ LEFT hand build failed!"
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    rm "$BACKUP_FILE"
    exit 1
fi

# Restore config
cp "$BACKUP_FILE" "$CONFIG_FILE"
echo ""

# ============================================================================
# 3. Build RIGHT handedness initialization firmware
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 [3/3] Building RIGHT hand initialization firmware..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# Add INIT_EE_HANDS_RIGHT to config
sed -i '/^#define EE_HANDS/a #define INIT_EE_HANDS_RIGHT' "$CONFIG_FILE"

qmk compile -kb "$KEYBOARD" -km "$KEYMAP"
if [ $? -eq 0 ]; then
    cp "$QMK_FIRMWARE_DIR/${OUTPUT_NAME}.uf2" "$OUTPUT_DIR/${OUTPUT_NAME}_RIGHT.uf2"
    echo "✅ RIGHT hand firmware: ${OUTPUT_NAME}_RIGHT.uf2"
else
    echo "❌ RIGHT hand build failed!"
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    rm "$BACKUP_FILE"
    exit 1
fi

# Restore original config
cp "$BACKUP_FILE" "$CONFIG_FILE"
rm "$BACKUP_FILE"
rm "$QMK_FIRMWARE_DIR/${OUTPUT_NAME}.uf2"


echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 ALL FIRMWARE FILES BUILT SUCCESSFULLY!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Files created:"
ls -lh "$OUTPUT_DIR/${OUTPUT_NAME}.uf2" "$OUTPUT_DIR/${OUTPUT_NAME}_LEFT.uf2" "$OUTPUT_DIR/${OUTPUT_NAME}_RIGHT.uf2"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 USAGE GUIDE:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔧 FIRST-TIME SETUP (Set handedness in EEPROM):"
echo "   1. Flash ${OUTPUT_NAME}_LEFT.uf2 to LEFT keyboard half"
echo "   2. Flash ${OUTPUT_NAME}_RIGHT.uf2 to RIGHT keyboard half"
echo "   3. Only do this ONCE to initialize handedness"
echo ""
echo "🔄 REGULAR UPDATES (After handedness is set):"
echo "   1. Flash ${OUTPUT_NAME}.uf2 to BOTH keyboard halves"
echo "   2. Handedness is preserved in EEPROM"
echo "   3. Either half can be plugged in as master"
echo ""
echo "💡 TIP: To enter bootloader, double-tap RESET on Liatris"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
