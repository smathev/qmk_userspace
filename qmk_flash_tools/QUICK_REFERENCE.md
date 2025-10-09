# QMK Flash Tools - Quick Reference

## 🚀 Common Commands

### Flash Both Keyboard Sides
```bash
cd qmk_flash_tools
./autoflash_modular.sh
```

### Test Individual Components
```bash
# Test side mapping (no hardware needed)
./test/test_side_mapping.sh

# Test device detection (needs keyboard in bootloader)
./test/test_device_detection.sh

# Test QMK functions
./test/test_qmk_helpers.sh

# Run all tests
./test/run_all_tests.sh
```

### View Saved Mappings
```bash
cd qmk_flash_tools
cat device_mappings.json
# or
jq '.' device_mappings.json
```

### Reset Mappings
```bash
# Reset all
cd qmk_flash_tools
rm device_mappings.json

# Or use the library
source lib/side_mapping.sh
clear_all_mappings
```

## 🔍 Debug Commands

### Check Device Info
```bash
source lib/device_detection.sh
mount_point="/media/$USER/RPI-RP2"  # Adjust path
print_device_info "$mount_point"
```

### Manually Test Detection
```bash
source lib/device_detection.sh
source lib/side_mapping.sh

# Wait for device
mount_point=$(wait_for_rp2040)

# Get identifier
device_id=$(get_device_identifier "$mount_point")
echo "Device ID: $device_id"

# Detect side
side=$(detect_side "$device_id")
echo "Side: $side"
```

### Test QMK Commands
```bash
# Check QMK version
qmk --version

# List keymaps
qmk list-keymaps -kb fingerpunch/sweeeeep

# Compile only (no flash)
qmk compile -kb fingerpunch/sweeeeep -km smathev

# Flash with specific bootloader
qmk flash -kb fingerpunch/sweeeeep -km smathev -bl uf2-split-left
```

## 🛠️ Manual Side Mapping

### Add Mapping Manually
```bash
source lib/side_mapping.sh
save_side_mapping "serial:ABC123XYZ" "left"
save_side_mapping "serial:DEF456RST" "right"
```

### Check Specific Device
```bash
source lib/side_mapping.sh
side=$(get_saved_side "serial:ABC123XYZ")
echo "Device is: $side"
```

### List All Mappings
```bash
source lib/side_mapping.sh
list_all_mappings
```

## 📝 Environment Variables

```bash
# Keyboard configuration
export KEYBOARD="fingerpunch/sweeeeep"
export KEYMAP="smathev"

# Device detection
export USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
export RP2040_PATTERN="*RP2040*"
export USB_WAIT_INTERVAL=0.5

# Side mapping file (relative to qmk_flash_tools/)
export SIDE_MAPPING_FILE="./device_mappings.json"
```

## 🐛 Troubleshooting One-Liners

```bash
# Check if RP2040 is mounted
ls /media/$USER/ | grep -i rp2040

# Find all USB devices
lsusb

# Check USB device info
udevadm info --query=property /dev/sdb1  # Adjust device

# Monitor USB events (run in separate terminal)
udevadm monitor

# Check QMK firmware location
qmk config user.qmk_home

# Force clean and rebuild
qmk clean && qmk compile -kb fingerpunch/sweeeeep -km smathev

# Check if jq is installed
jq --version
```

## 📂 File Locations

```
Main script:        qmk_flash_tools/autoflash_modular.sh
Libraries:          qmk_flash_tools/lib/*.sh
Tests:              qmk_flash_tools/test/*.sh
Mapping file:       qmk_flash_tools/device_mappings.json
QMK firmware:       ~/qmk_firmware/ (or user.qmk_home)
Build output:       ~/qmk_firmware/.build/
```

## 🔧 Common Fixes

### Device not appearing
```bash
# Check dmesg for USB events
dmesg | tail -n 20

# Try different USB port
# Try different USB cable (must be data cable, not charge-only)
```

### Wrong side detected
```bash
# Clear and re-learn
source lib/side_mapping.sh
clear_mapping "serial:YOUR_DEVICE_ID"
# Then run autoflash again
```

### Build fails
```bash
# Update QMK
python3 -m pip install --upgrade qmk

# Pull latest QMK firmware
cd ~/qmk_firmware
git pull

# Clean and try again
qmk clean
```

### Permission denied
```bash
# Make scripts executable
chmod +x qmk_flash_tools/*.sh
chmod +x qmk_flash_tools/lib/*.sh
chmod +x qmk_flash_tools/test/*.sh
```

## 📚 Function Quick Reference

### device_detection.sh
- `wait_for_rp2040()` - Wait for device
- `get_usb_serial_from_host(mount)` - Get serial
- `get_usb_device_path(mount)` - Get USB path
- `get_device_identifier(mount)` - Get ID
- `print_device_info(mount)` - Debug info

### side_mapping.sh
- `init_mapping_file()` - Create file
- `save_side_mapping(id, side)` - Save
- `get_saved_side(id)` - Retrieve
- `detect_side(id)` - Auto-detect/prompt
- `list_all_mappings()` - Show all
- `clear_mapping(id)` - Remove one
- `clear_all_mappings()` - Reset

### qmk_helpers.sh
- `build_firmware(kb, km)` - Compile
- `flash_side(kb, km, side)` - Flash with handedness
- `check_qmk_installed()` - Verify QMK
- `verify_keyboard_exists(kb)` - Check KB
- `clean_build()` - Clean
