# QMK Flash Tools# QMK Flash Tools



Simple flashing script for split keyboards with EE_HANDS.Automated flashing tools for QMK split keyboards with RP2040 controllers (like Liatris).



## Usage## ⚡ Quick Start - Use the Simple Script!



```bash```bash

bash flash.shcd qmk_flash_tools

```./autoflash_simple.sh

```

That's it! The script will:

**✅ Recommended:** Use `autoflash_simple.sh` - it's faster, simpler, and correct.

1. **Guide you to flash LEFT side**

   - Plug in left halfSee [SIMPLIFIED_SCRIPT.md](SIMPLIFIED_SCRIPT.md) for details on why the simple script is better.

   - Double-tap RESET button

   - Script auto-mounts device and flashes firmware with left handedness## 📁 Scripts Available



2. **Guide you to flash RIGHT side**| Script | Status | Description |

   - Plug in right half  |--------|--------|-------------|

   - Double-tap RESET button| **autoflash_simple.sh** | ✅ **RECOMMENDED** | Simple, correct workflow. Builds once, flashes both sides with same firmware. No prompts during bootloader. |

   - Script auto-mounts device and flashes firmware with right handedness| **autoflash_modular.sh** | ⚠️ **OLD** | Complex workflow with design flaws. Builds firmware multiple times, prompts during bootloader (broken!). |



## Features## 📁 Structure



✅ **Auto-mounting**: Automatically mounts RP2040 bootloader device  ```

✅ **EE_HANDS support**: Builds separate firmware for each side  qmk_flash_tools/

✅ **No complex detection**: Just follow the simple instructions  ├── autoflash_simple.sh         # ✅ RECOMMENDED - Simple, correct workflow

✅ **Optimized builds**: Only builds twice (once per side)├── autoflash_modular.sh        # ⚠️ OLD - Complex, has design flaws

├── config.sh                   # Configuration (shared by both scripts)

## Configuration├── lib/                        # Reusable library modules

│   ├── device_detection.sh     # USB device detection functions

Edit `config.sh` to change:│   ├── side_mapping.sh         # Device-to-side mapping storage

- `KEYBOARD`: Your keyboard name│   └── continuous_automount.sh # Background auto-mount monitor

- `KEYMAP`: Your keymap name├── docs/                       # Documentation

- `QMK_FIRMWARE_DIR`: Path to QMK firmware directory│   ├── SIMPLIFIED_SCRIPT.md    # Why the simple script is better

│   ├── WORKFLOW_GUIDE.md       # Detailed workflow documentation

## Requirements│   ├── AUTOMOUNT_SETUP.md      # Auto-mount setup guide

│   └── MOUNT_COMPARISON.md     # Mount methods comparison

- QMK CLI installed and configured└── README.md                   # This file

- RP2040-based split keyboard (like Fingerpunch boards)```

- `udisksctl` for auto-mounting (usually pre-installed)

## 🚀 Usage

## Troubleshooting

### Basic Usage (Flash Both Sides)

**Device won't mount?**

- Make sure you're in bootloader mode (double-tap RESET)```bash

- Try manually mounting in your file manager./autoflash_simple.sh

- Check if `udisksctl` is installed: `which udisksctl````



**Build fails?****Note:** If your RP2040 devices don't auto-mount, see [AUTOMOUNT_SETUP.md](AUTOMOUNT_SETUP.md) for solutions. The script can auto-mount devices using `udisksctl`, or you can install udev rules for system-wide auto-mounting.

- Make sure QMK is properly configured: `qmk doctor`

- Check that your keyboard/keymap paths are correctThe script will:

1. Build firmware once

**Flash hangs?**2. **First time only:** Ask which side you'll flash (left/right)

- Unplug the keyboard and try again3. **Subsequent runs:** Auto-detect which side is plugged in

- Make sure only ONE keyboard half is plugged in at a time4. Wait for you to enter bootloader

5. Verify and flash with correct handedness
6. Repeat for the other side

### 2. Test Individual Components

```bash
# Test device detection
cd test
chmod +x test_device_detection.sh
./test_device_detection.sh

# Test side mapping
chmod +x test_side_mapping.sh
./test_side_mapping.sh

# Test QMK helpers
chmod +x test_qmk_helpers.sh
./test_qmk_helpers.sh
```

## 🔧 Configuration

Edit the top of `autoflash_modular.sh`:

```bash
KEYBOARD="fingerpunch/sweeeeep"  # Your keyboard
KEYMAP="smathev"                 # Your keymap
USB_MOUNT_PATHS=(...)            # Where USB drives mount
SIDE_MAPPING_FILE="..."          # Device mappings (defaults to ./device_mappings.json)
```

## 📚 Library Documentation

### device_detection.sh

Functions for detecting RP2040 devices via host USB information.

**Key Functions:**
- `wait_for_rp2040()` - Wait for device to enter bootloader
- `get_usb_serial_from_host(mount_point)` - Get USB serial from host
- `get_usb_device_path(mount_point)` - Get USB port location
- `get_device_identifier(mount_point)` - Get best available ID
- `print_device_info(mount_point)` - Debug info

**Example:**
```bash
source lib/device_detection.sh
mount_point=$(wait_for_rp2040)
device_id=$(get_device_identifier "$mount_point")
echo "Device: $device_id"
```

### side_mapping.sh

Functions for storing and retrieving which device is left/right.

**Key Functions:**
- `init_mapping_file()` - Create mapping file if needed
- `save_side_mapping(device_id, side)` - Save mapping
- `get_saved_side(device_id)` - Retrieve saved side
- `detect_side(device_id)` - Get side (prompts if unknown)
- `list_all_mappings()` - Show all saved mappings
- `clear_mapping(device_id)` - Remove a mapping
- `clear_all_mappings()` - Reset all mappings

**Example:**
```bash
source lib/side_mapping.sh
export SIDE_MAPPING_FILE="./device_mappings.json"

save_side_mapping "serial:ABC123" "left"
side=$(get_saved_side "serial:ABC123")
echo "Side: $side"
```

### qmk_helpers.sh

Wrapper functions for QMK CLI commands.

**Key Functions:**
- `check_qmk_installed()` - Verify QMK is available
- `build_firmware(keyboard, keymap)` - Compile firmware
- `flash_side(keyboard, keymap, side)` - Flash with handedness
- `flash_with_bootloader(keyboard, keymap, bootloader)` - Flash with specific bootloader
- `verify_keyboard_exists(keyboard)` - Check keyboard definition
- `clean_build()` - Clean build artifacts

**Example:**
```bash
source lib/qmk_helpers.sh

check_qmk_installed || exit 1
build_firmware "fingerpunch/sweeeeep" "smathev"
flash_side "fingerpunch/sweeeeep" "smathev" "left"
```

## 🧪 Testing Workflow

### Test Device Detection

1. **Without device:**
```bash
./test/test_device_detection.sh
# Shows "no device found", good for baseline
```

2. **With device:**
```bash
# Enter bootloader mode on keyboard
./test/test_device_detection.sh
# Shows USB serial, path, and identifier
```

### Test Side Mapping

```bash
./test/test_side_mapping.sh
# Runs comprehensive tests:
# - Create mapping file
# - Save/retrieve mappings
# - Clear mappings
# - Interactive prompt (optional)
```

### Test QMK Helpers

```bash
./test/test_qmk_helpers.sh
# Tests:
# - QMK installation check
# - Keyboard verification
# - Build (optional)
# - Function signatures
```

## 🐛 Troubleshooting

### Device not detected

```bash
# Check if device appears
ls /media/$USER/
# Should see RPI-RP2 or similar

# Run device detection test
./test/test_device_detection.sh
```

### Can't identify device

The script uses these methods in order:
1. USB serial number (most reliable)
2. USB physical port path
3. Mount point name (fallback)

Check which method worked:
```bash
source lib/device_detection.sh
mount_point="/media/$USER/RPI-RP2"
print_device_info "$mount_point"
```

### Side mismatch detected

If you see a mismatch warning:

**Option 1: Exit and plug in correct side (safest)**
- Choose `[e]` to exit
- Unplug the keyboard
- Plug in the correct side
- Run the script again

**Option 2: Update the mapping**
- Choose `[c]` to clear old mapping and save new one
- Use this if you know the old mapping was wrong

**Option 3: Force flash (dangerous!)**
- Choose `[f]` to flash anyway
- Only use if you're absolutely certain
- May result in swapped left/right behavior

Or manually reset mappings:
```bash
source lib/side_mapping.sh
clear_mapping "serial:ABC123"  # Use your device ID
```

Or reset all mappings:
```bash
cd qmk_flash_tools
rm device_mappings.json
```

### Build fails

```bash
# Test QMK directly
qmk compile -kb fingerpunch/sweeeeep -km smathev

# Check keyboard exists
qmk list-keymaps -kb fingerpunch/sweeeeep
```

## 💡 Advanced Usage

### Use in other scripts

```bash
#!/usr/bin/env bash
source /path/to/qmk_flash_tools/lib/device_detection.sh
source /path/to/qmk_flash_tools/lib/side_mapping.sh

# Your custom logic here
mount_point=$(wait_for_rp2040)
device_id=$(get_device_identifier "$mount_point")
side=$(detect_side "$device_id")
echo "Detected $side side"
```

### Custom keyboard configuration

```bash
# Set environment variables before running
export KEYBOARD="your/keyboard"
export KEYMAP="your_keymap"
./autoflash_modular.sh
```

### Different mapping file

```bash
export SIDE_MAPPING_FILE="/tmp/my_test_mappings.json"
./autoflash_modular.sh
```

## 📋 Requirements

- **bash** - Shell interpreter
- **qmk** - QMK CLI (`python3 -m pip install qmk`)
- **jq** - JSON processor (`sudo apt-get install jq`)
- **findmnt** - Usually included with util-linux
- **udevadm** - Usually included with systemd

## 🔒 File Permissions

Make scripts executable:
```bash
chmod +x autoflash_modular.sh
chmod +x test/*.sh
chmod +x lib/*.sh
```

## 📝 How Device Mapping Works

The script intelligently handles three states:

### 🟢 Empty Mapping (First Time)
- **No devices mapped yet**
- **Asks:** "Which side will you flash first?"
- Script learns both sides as you flash them
- First device = saved as what you specify (left/right)
- Second device = saved as the other side
- Result: Complete mapping of both sides

### 🟡 Partial Mapping (One Side Known)
- **One device mapped, one unknown**
- **Auto-detects:** No asking needed!
- If you plug in the known device → "Detected: left side"
- If you plug in unknown device → "Detected: right side (inferred)"
- Result: Completes mapping automatically

### 🔴 Complete Mapping (Both Sides Known)
- **Both devices are mapped**
- **Auto-detects:** Fully automatic!
- Plug in any side → "Detected: left side" or "Detected: right side"
- Only the two known devices are allowed
- Unknown device → **Rejected immediately** (safety feature)
- Result: Fast, automatic flashing with full protection

### Why This Matters
- **First run**: Asks which side (one-time setup) ✅
- **Normal use**: Fully automatic - just plug and flash! ✅
- **Protection**: Unknown devices rejected - can't flash wrong keyboard ✅
- **Smart**: Knows when to ask vs. when to auto-detect 🧠


## ⚙️ Configuration

All shared settings are centralized in `config.sh`:

```bash
# Keyboard and keymap
export KEYBOARD="fingerpunch/sweeeeep"
export KEYMAP="smathev"

# USB device detection
export USB_MOUNT_PATHS=("/media/$USER" "/run/media/$USER" "/mnt")
export RP2040_PATTERN="*RP2040*"
export USB_WAIT_INTERVAL=0.5

# Device mapping file
export SIDE_MAPPING_FILE="$HOME/.config/qmk_flash_tools/device_mappings.json"
```

Edit this file to customize for your setup.

## �📝 Additional Notes

- **Input timing**: You're asked which side BEFORE entering bootloader (so you can still type!)
- **EEPROM wipe**: Liatris overwrites EEPROM on flash, so we use HOST USB info
- **Board-ID**: INFO_UF2.TXT is NOT unique per device, don't rely on it
- **USB serial**: Burned into RP2040 chip, persists even when EEPROM wiped
- **Centralized config**: All scripts source `config.sh` for consistent settings

## 🆘 Support

Issues? Check:
1. Run test scripts to isolate the problem
2. Check device detection with `print_device_info()`
3. Verify mappings with `list_all_mappings()`
4. Test QMK commands directly: `qmk compile -kb ... -km ...`

## 📄 License

Same as your QMK userspace configuration.
