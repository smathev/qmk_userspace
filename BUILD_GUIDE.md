# QMK Firmware Build Guide for Fingerpunch Sweeeeep

This guide explains how to build and flash firmware for your split keyboard with EE_HANDS.

## Quick Start

### Build All Firmware Files

```bash
./build_all.sh
```

This creates three files:
- `fingerpunch_sweeeeep_smathev.uf2` - Regular firmware
- `fingerpunch_sweeeeep_smathev_LEFT.uf2` - LEFT hand initialization
- `fingerpunch_sweeeeep_smathev_RIGHT.uf2` - RIGHT hand initialization

## First-Time Setup (One-Time Only)

You only need to do this ONCE to set the handedness in EEPROM:

1. **Initialize LEFT keyboard half:**
   - Unplug both halves
   - Plug in the LEFT half
   - Double-tap RESET button on Liatris controller
   - Drag `fingerpunch_sweeeeep_smathev_LEFT.uf2` to the RPI-RP2 drive
   - Wait for it to disconnect/reconnect

2. **Initialize RIGHT keyboard half:**
   - Unplug both halves
   - Plug in the RIGHT half
   - Double-tap RESET button on Liatris controller
   - Drag `fingerpunch_sweeeeep_smathev_RIGHT.uf2` to the RPI-RP2 drive
   - Wait for it to disconnect/reconnect

3. **Test:** Plug either half in via USB - keys should work correctly regardless of which side is plugged in!

## Regular Firmware Updates

After handedness is initialized, use the regular firmware for all future updates:

1. **Flash regular firmware to BOTH halves:**
   - Double-tap RESET on each half
   - Drag `fingerpunch_sweeeeep_smathev.uf2` to each
   
2. **Handedness is preserved:** The EEPROM remembers which half is which, so you don't need the `_LEFT` or `_RIGHT` files anymore (unless you want to change handedness).

## How It Works

### EE_HANDS (EEPROM Handedness)

- Each keyboard half stores its identity (LEFT or RIGHT) in EEPROM
- The handedness firmware (`_LEFT.uf2` and `_RIGHT.uf2`) initializes this EEPROM value on first flash
- After initialization, either half can be plugged in as master
- Regular firmware preserves the EEPROM handedness value

### Build Process

The `build_all.sh` script:

1. **Regular firmware:** Builds with `EE_HANDS` defined
2. **LEFT firmware:** Temporarily adds `INIT_EE_HANDS_LEFT` to config.h and builds
3. **RIGHT firmware:** Temporarily adds `INIT_EE_HANDS_RIGHT` to config.h and builds
4. **Restores:** Original config.h is restored after builds

The `INIT_EE_HANDS_LEFT/RIGHT` defines tell QMK to write the handedness to EEPROM on boot.

## Troubleshooting

### Keys are backwards when plugging in one side

- You probably flashed the wrong `_LEFT` or `_RIGHT` file to the wrong keyboard half
- Solution: Re-flash with the correct handedness files

### Master side always seems to be the same regardless of which I plug in

- The `EE_HANDS` setting may not be properly configured
- Check that `config.h` has `#define EE_HANDS` (not `MASTER_LEFT` or `MASTER_RIGHT`)
- Rebuild and reflash handedness files

### How do I reset/change handedness?

- Simply flash the opposite handedness firmware to swap a keyboard half's identity
- Example: Flash `_RIGHT.uf2` to what was previously the LEFT half

## File Structure

```
qmk_userspace/
├── build_all.sh                          # Main build script (builds all 3 files)
├── build_handedness_manual.sh            # Legacy handedness-only builder
├── fingerpunch_sweeeeep_smathev.uf2      # Regular firmware
├── fingerpunch_sweeeeep_smathev_LEFT.uf2 # LEFT initialization
├── fingerpunch_sweeeeep_smathev_RIGHT.uf2# RIGHT initialization
├── keyboards/
│   └── fingerpunch/
│       └── sweeeeep/
│           └── keymaps/
│               └── smathev/
│                   ├── config.h          # Keyboard-specific config (EE_HANDS)
│                   └── keymap.c          # Your keymap
└── users/
    └── smathev/
        ├── config.h                      # Userspace config
        ├── combos.c/h                    # Combo definitions
        └── ...
```

## Additional Notes

### Liatris Controller

- The Liatris uses RP2040 (same as Raspberry Pi Pico)
- Firmware files are `.uf2` format
- Double-tap RESET to enter bootloader mode (appears as RPI-RP2 drive)
- No need for QMK Toolbox - just drag and drop files

### Configuration Hierarchy

1. **users/smathev/config.h** - User preferences (applies to all keyboards)
2. **keyboards/.../keymaps/smathev/config.h** - Keyboard-specific overrides
3. **Keyboard defaults** - Base keyboard configuration

The `EE_HANDS` setting is in the keyboard-specific config because it's hardware-dependent.
