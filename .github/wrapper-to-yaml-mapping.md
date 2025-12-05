# Keymap Wrapper to YAML Layer Mapping Reference

This document maps QMK wrapper macro names to their corresponding layers in `keymap-drawer.yaml`.

## Source Files

**Wrapper definitions**: `users/smathev/wrappers.h` - What keys are in each wrapper  
**Physical layout**: `keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c` - How wrappers are arranged  
**Key behaviors**: 
- `users/smathev/combos.c/h` - Key combinations
- `users/smathev/process_records.c/h` - Custom behaviors and macros
- `users/smathev/smathev.h` - Helper macros

## Wrapper Naming Convention

Wrappers follow the pattern: `__<LAYER>_<SIDE><ROW>__` where:
- `LAYER` = Layer name (e.g., NORTO, ENTHIUM)
- `SIDE` = L (left) or R (right)
- `ROW` = 1 (top), 2 (middle), 3 (bottom)

Plus thumb cluster wrappers: `__<LAYER>_THUMBS_6__`

## Layer Mappings

### NORTO Layer (Norwegian Dvorak)
```
Left side:  __________________NORTO_L1____________________
Right side: __________________NORTO_R1____________________
Left side:  __________________NORTO_L2____________________
Right side: __________________NORTO_R2____________________
Left side:  __________________NORTO_L3____________________
Right side: __________________NORTO_R3____________________
Thumbs:     __NORTO_THUMBS_6__
```

### ENTHIUM Layer (English custom layout)
```
Left side:  __________________ENTHIUM_L1____________________
Right side: __________________ENTHIUM_R1____________________
Left side:  __________________ENTHIUM_L2____________________
Right side: __________________ENTHIUM_R2____________________
Left side:  __________________ENTHIUM_L3____________________
Right side: __________________ENTHIUM_R3____________________
Thumbs:     __ENTHIUM_THUMBS_6__
```

### NAV Layer (Navigation + Numpad)
```
Left side:  ____________NORTNAVIGATION_1_______________
Right side: _________________NUMPAD_1__________________
Left side:  ____________NORTNAVIGATION_2_______________
Right side: _________________NUMPAD_2__________________
Left side:  ____________NORTNAVIGATION_3_______________
Right side: _________________NUMPAD_3__________________
Thumbs:     _NOR_NAV_THUMBS_6__
```

### SYM Layer (Function Keys + Symbols)
```
Left side:  ___________________FKEY______L1________________
Right side: ________________NORTSYMBOLS_R1_________________
Left side:  ___________________FKEY______L2________________
Right side: ________________NORTSYMBOLS_R2_________________
Left side:  ___________________FKEY______L3________________
Right side: ________________NORTSYMBOLS_R3_________________
Thumbs:     (uses trans/layer toggles)
```

### SETUP Layer (Configuration)
```
Left side:  __________________QWERTY_L1____________________
Right side: _________________KB_SETUP_1________________
Left side:  __________________QWERTY_L2____________________
Right side: _________________KB_SETUP_2________________
Left side:  __________________QWERTY_L3____________________
Right side: _________________KB_SETUP_3________________
Thumbs:     (uses layer toggle keys)
```

### MOUSE Layer (Mouse Navigation)
```
Left side:  _________________MOUSENAV____L1________________
Right side: ________________MOUSENAV_R1_________________
Left side:  _________________MOUSENAV____L2________________
Right side: ________________MOUSENAV_R2_________________
Left side:  _________________MOUSENAV____L3________________
Right side: ________________MOUSENAV_R3_________________
Thumbs:     _MOUSENAV_THUMBS_6__
```

### QWERTY Layer (Standard QWERTY)
```
Left side:  __________________QWERTY_L1____________________
Right side: __________________QWERTY_R1____________________
Left side:  __________________QWERTY_L2____________________
Right side: __________________QWERTY_R2____________________
Left side:  __________________QWERTY_L3____________________
Right side: __________________QWERTY_R3____________________
Thumbs:     __QWERTY_THUMBS_6__
```

## Layout Structure

Each layer in the YAML follows this structure:
```yaml
LAYER_NAME:
  - [key0, key1, key2, key3, key4, key5, key6, key7, key8, key9]    # Row 1 (L1 + R1)
  - [key10, key11, key12, key13, key14, key15, key16, key17, key18, key19]  # Row 2 (L2 + R2)
  - [key20, key21, key22, key23, key24, key25, key26, key27, key28, key29]  # Row 3 (L3 + R3)
  - {type: ghost}  # Position 30 (outer thumb left - not physically present)
  - key31          # Position 31 (inner thumb left)
  - key32          # Position 32 (main thumb left)
  - key33          # Position 33 (main thumb right)
  - key34          # Position 34 (inner thumb right)
  - {type: ghost}  # Position 35 (outer thumb right - not physically present)
```

## Special Key Syntax

- **Home row mods**: `{h: Modifier, t: Key}` (e.g., `{h: Ctrl, t: A}`)
- **Layer tap**: `{h: LAYER, t: Key}` (e.g., `{h: NAV, t: Space}`)
- **Transparent**: `{type: trans}`
- **Held key**: `{type: held}` (shows layer is active)
- **Ghost key**: `{type: ghost}` (not physically present)

## Quick Reference: Finding a Wrapper

1. **Identify the layer** you want to update in YAML
2. **Open `users/smathev/wrappers.h`** - This is where ALL wrapper definitions live
3. **Find the individual key definitions** (e.g., `____NORTO_L1_K1__` through `____NORTO_L1_K5__`)
4. **Extract the actual keycodes** from each key definition
5. **Update the corresponding row** in the YAML layer

Example:
```c
// users/smathev/wrappers.h
#define ____NORTO_L1_K1__ DK_OSTR   // Ø
#define ____NORTO_L1_K2__ DK_AE     // Æ  
#define ____NORTO_L1_K3__ KC_U      // U
#define ____NORTO_L1_K4__ KC_G      // G
#define ____NORTO_L1_K5__ KC_J      // J

#define __________________NORTO_L1____________________ ____NORTO_L1_K1__, ____NORTO_L1_K2__, ____NORTO_L1_K3__, ____NORTO_L1_K4__, ____NORTO_L1_K5__
```
→
```yaml
# keymap-drawer.yaml
NORTO:
  - [Ø, Æ, U, G, J, ...]  # First 5 keys from L1
```

## Key Translation Notes

- `DK_OSTR` → `Ø` (Danish Ø)
- `DK_AE` → `Æ` (Danish Æ)
- `DK_ARNG` → `Å` (Danish Å)
- `DK_COMM` → `,` (Comma)
- `DK_DOT` → `.` (Period)
- `DK_MINS` → `-` (Minus)
- `LGUI_T(key)` → `{h: Gui, t: key}` (Home row mod)
- `LALT_T(key)` → `{h: Alt, t: key}`
- `LSFT_T(key)` → `{h: Shift, t: key}`
- `LCTL_T(key)` → `{h: Ctrl, t: key}`
- Same pattern for right-hand mods (RGUI_T, RALT_T, RSFT_T, RCTL_T)
