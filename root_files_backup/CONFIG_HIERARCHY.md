# QMK Configuration Hierarchy

Understanding where to put your settings in QMK userspace.

## Configuration Priority (Highest to Lowest)

```
1. keyboards/.../keymaps/smathev/config.h  ← HIGHEST PRIORITY (keyboard-specific)
   ↓ overrides
2. users/smathev/config.h                   ← USER DEFAULTS (all keyboards)
   ↓ overrides  
3. keyboards/.../config.h                   ← KEYBOARD DEFAULTS
   ↓ overrides
4. QMK defaults                             ← LOWEST PRIORITY
```

## Your Current Setup

### 📁 `users/smathev/config.h`
**Purpose:** Settings that apply to ALL your keyboards

**What belongs here:**
- ✅ Tapping terms (`TAPPING_TERM`, `PERMISSIVE_HOLD`)
- ✅ Auto-shift settings (`AUTO_SHIFT_TIMEOUT`, `RETRO_SHIFT`)
- ✅ Combo preferences (`COMBO_REF_DEFAULT`)
- ✅ Personal preferences that don't change between keyboards
- ✅ Layout aliases (`LAYOUT_sweeeeep`)

**Example:**
```c
#define TAPPING_TERM 140
#define PERMISSIVE_HOLD
#define CASEMODES_ENABLE
```

### 📁 `keyboards/fingerpunch/sweeeeep/keymaps/smathev/config.h`
**Purpose:** Settings specific to THIS keyboard/keymap

**What belongs here:**
- ✅ Split keyboard settings (`EE_HANDS`, `SPLIT_USB_DETECT`)
- ✅ Hardware-specific features (`OLED_FONT_H`)
- ✅ Keyboard-specific overrides
- ✅ Split communication settings

**Example:**
```c
#define EE_HANDS
#define SPLIT_USB_DETECT
#define OLED_FONT_H "path/to/font.c"
```

## Why This Matters

### ❌ Wrong Approach:
Putting everything in `users/smathev/config.h`
- Split keyboard settings affect non-split keyboards
- OLED settings break keyboards without OLED
- Hardware-specific settings cause conflicts

### ✅ Correct Approach:
- **Userspace (`users/`)**: Personal preferences that work everywhere
- **Keymap (`keymaps/`)**: Keyboard-specific hardware and features

## Common Settings Placement

| Setting | Location | Reason |
|---------|----------|--------|
| `TAPPING_TERM` | `users/` | Personal preference |
| `EE_HANDS` | `keymaps/` | Split keyboard specific |
| `OLED_FONT_H` | `keymaps/` | Hardware specific |
| `COMBO_REF_DEFAULT` | `users/` | User preference |
| `SPLIT_USB_DETECT` | `keymaps/` | Split keyboard specific |
| `AUTO_SHIFT_TIMEOUT` | `users/` | Personal preference |
| `PERMISSIVE_HOLD` | `users/` | Personal preference |

## Your Configuration Files

### Current Structure:
```
qmk_userspace/
├── users/smathev/
│   ├── config.h              ← User-wide settings
│   ├── rules.mk              ← User-wide features
│   ├── combos.c/h
│   └── ...
└── keyboards/
    └── fingerpunch/sweeeeep/
        └── keymaps/smathev/
            ├── config.h      ← Keyboard-specific settings (EE_HANDS here!)
            ├── keymap.c
            └── keymap.json
```

## Testing Your Configuration

```bash
# Compile to see if settings are applied correctly
qmk compile -kb fingerpunch/sweeeeep -km smathev

# Check for configuration conflicts in warnings
qmk compile -kb fingerpunch/sweeeeep -km smathev 2>&1 | grep "config.h"
```

## Pro Tips

💡 **Use Comments:** Clearly mark which config file is for what purpose

💡 **Test on Multiple Keyboards:** If you add more keyboards, userspace settings will automatically apply

💡 **Override When Needed:** Keymap config.h can override userspace defaults

💡 **Keep It DRY:** Don't repeat settings - put them in the most appropriate place

## If You Add More Keyboards

When you add another keyboard (e.g., a 60% board):

1. **User settings automatically apply** (tapping, combos, etc.)
2. **Create keyboard-specific config.h** only for that keyboard's unique needs
3. **Split settings don't affect** your non-split boards

This is the power of QMK userspace! 🚀
