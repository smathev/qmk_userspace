# Flashing Split Keyboard Handedness (EE_HANDS)

Your fingerpunch/sweeeeep keyboard with **Liatris controllers** uses `EE_HANDS` for split keyboard handedness detection. This means each half needs to be flashed with its handedness information stored in EEPROM.

> **Note:** The Liatris is an RP2040-based Pro Micro replacement controller. It uses `.uf2` files and bootloader mode for flashing.

## Visual Guide

```
┌─────────────────────────────────────────────────────────┐
│  STEP 1: Build handedness firmware files                │
│  $ ./build_handedness.sh                                │
│    → Creates _LEFT.uf2 and _RIGHT.uf2                   │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  STEP 2: Flash LEFT half                                │
│  1. Unplug both halves                                  │
│  2. Plug in LEFT half                                   │
│  3. Double-tap RESET button on Liatris                  │
│  4. Drag _LEFT.uf2 to RPI-RP2 drive                     │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  STEP 3: Flash RIGHT half                               │
│  1. Unplug both halves                                  │
│  2. Plug in RIGHT half                                  │
│  3. Double-tap RESET button on Liatris                  │
│  4. Drag _RIGHT.uf2 to RPI-RP2 drive                    │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  STEP 4: Test                                           │
│  • Test each half independently (plug in solo)          │
│  • Both halves should work when connected               │
│  • If one acts wrong, re-flash that specific half       │
└─────────────────────────────────────────────────────────┘
```

## Quick Reference

### Build Commands

```bash
# Build LEFT hand firmware with EEPROM handedness
qmk compile -kb fingerpunch/sweeeeep -km smathev -e INIT_EE_HANDS_LEFT=yes

# Build RIGHT hand firmware with EEPROM handedness  
qmk compile -kb fingerpunch/sweeeeep -km smathev -e INIT_EE_HANDS_RIGHT=yes
```

### Generated Files

After building, you'll have:
- `fingerpunch_sweeeeep_smathev.uf2` - The most recent build (left OR right)
- Copy this immediately after building to preserve it!

### Recommended Workflow

```bash
cd /home/smathev/git_dev/keyboards/qmk_userspace

# Build and save LEFT hand
qmk compile -kb fingerpunch/sweeeeep -km smathev -e INIT_EE_HANDS_LEFT=yes
cp fingerpunch_sweeeeep_smathev.uf2 fingerpunch_sweeeeep_smathev_LEFT.uf2

# Build and save RIGHT hand
qmk compile -kb fingerpunch/sweeeeep -km smathev -e INIT_EE_HANDS_RIGHT=yes
cp fingerpunch_sweeeeep_smathev.uf2 fingerpunch_sweeeeep_smathev_RIGHT.uf2

# Now you have both files ready to flash
ls -lh fingerpunch_sweeeeep_smathev_*.uf2
```

## Flashing Instructions

### For Liatris Controllers (RP2040-based):

The **Liatris** has a **RESET button** (small button on the controller). To enter bootloader mode:

#### Method 1: Double-tap Reset (Recommended)
1. **Left Half:**
   - Unplug both halves
   - Plug in LEFT half
   - **Quickly double-tap the RESET button** on the Liatris controller
   - The controller will appear as a USB drive named `RPI-RP2`
   - Copy/drag `fingerpunch_sweeeeep_smathev_LEFT.uf2` to the `RPI-RP2` drive
   - The board will reboot automatically and disappear

2. **Right Half:**
   - Unplug both halves  
   - Plug in RIGHT half
   - **Quickly double-tap the RESET button** on the Liatris controller
   - The controller will appear as a USB drive named `RPI-RP2`
   - Copy/drag `fingerpunch_sweeeeep_smathev_RIGHT.uf2` to the `RPI-RP2` drive
   - The board will reboot automatically and disappear

#### Method 2: Hold Boot + Plug In
1. If double-tap doesn't work, you can hold the BOOT button while plugging in the USB cable
2. The Liatris has a small BOOT button - check the controller PCB for its location

> **💡 Tip:** If the `RPI-RP2` drive doesn't appear, try:
> - Double-tapping faster or slower
> - Using a different USB cable/port
> - Checking that the Liatris is properly seated in the sockets

3. **Test:**
   - Plug in ONLY the left half → keyboard should work
   - Plug in ONLY the right half → keyboard should work
   - If either half doesn't work solo, re-flash that half

## After Initial Handedness Setup

Once each half has been flashed with its handedness, you can flash regular firmware to BOTH halves:

```bash
# Normal build (no handedness parameter)
qmk compile -kb fingerpunch/sweeeeep -km smathev

# Flash this to BOTH halves - handedness is preserved in EEPROM
```

The handedness information persists in EEPROM through normal firmware updates!

## Troubleshooting

### "Wrong half detected"
- Re-flash the problematic half with the handedness firmware
- Make sure you're copying the correct file (LEFT vs RIGHT)
- Verify you're flashing the correct physical half

### "Both halves act as the same side"
- You need to flash different files to each half
- `*_LEFT.uf2` → left physical half (usually has the TRRS jack on the left side)
- `*_RIGHT.uf2` → right physical half (usually has the TRRS jack on the right side)

### "RPI-RP2 drive doesn't appear"
- **Liatris-specific:** Try double-tapping the RESET button faster or slower
- The timing can be finicky - practice a few times
- Make sure you're using a data USB cable (not charge-only)
- Try a different USB port
- Check that the Liatris is properly installed in the Pro Micro sockets

### "Keyboard not detected as USB device"
- Check USB cable (must be a data cable, not charge-only)
- Try a different USB port
- Verify the Liatris is correctly inserted (orientation matters!)
- Check for bent pins on the Liatris controller

### "Compile fails with 'converter not found'"
- Your keymap should have `"converter": "liatris"` in `keymap.json`
- This tells QMK to build for the Liatris controller

## File Naming Convention

To avoid confusion, use this naming:
- `*_LEFT.uf2` - For the **left physical half**
- `*_RIGHT.uf2` - For the **right physical half**  
- `*.uf2` (no suffix) - Regular firmware (both halves)

## Build Script

Created: `build_handedness.sh` for easier building
