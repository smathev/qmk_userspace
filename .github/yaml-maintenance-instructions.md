# Keymap YAML Maintenance Instructions

This file contains instructions for AI assistants to maintain `keymap-drawer.yaml` when keymap wrapper definitions are modified.

## When to Update

Update `keymap-drawer.yaml` whenever you modify any of these files:
- `users/smathev/wrappers.h` - Defines key assignments within each wrapper
- `users/smathev/combos.c/h` - Defines key combinations and their outputs  
- `users/smathev/process_records.c/h` - Custom key behaviors and macros
- `users/smathev/smathev.h` - Helper macros like HRML_KEY
- `keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c` - Physical layout arrangement

## Source Files

Your QMK userspace follows this structure:

**Wrapper System** (defines what keys appear):
- `users/smathev/wrappers.h` - Individual key definitions and combined wrappers
- `users/smathev/smathev.h` - Helper macros like HRML_KEY

**Physical Layout** (arranges wrappers on keyboard):
- `keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c` - Uses wrappers to define actual layout

**Additional Behaviors** (affect key functions):
- `users/smathev/combos.c/h` - Key combinations (e.g., two keys pressed together → different output)
- `users/smathev/process_records.c/h` - Custom key processing, macros, tap behaviors
- `users/smathev/config.h` - Configuration settings affecting autoshift, etc.

## Process

1. **Locate Wrapper Definitions**: Find the `#define` wrapper macros in `users/smathev/wrappers.h` (e.g., `__________________NORTO_L1____________________`)

2. **Extract Keys**: From each wrapper definition, extract the key sequence, respecting:
   - Home row mods: `HRML_KEY(k, mod)` → `{h: mod, t: k}`
   - Layer taps: `LT(layer, key)` → `{h: LAYER, t: key}`
   - Regular keys: Use their keycode names

3. **Update Corresponding Layer**: Match wrapper names to layers:
   - `NORTO_*` → `NORTO` layer
   - `ENTHIUM_*` → `ENTHIUM` layer
   - `NUMPAD_*` → Right side of `NAV` layer
   - `NORTSYMBOLS_*` → Right side of `SYM` layer
   - `FKEY_*` → Left side of `SYM` layer
   - `KB_SETUP_*` → Right side of `SETUP` layer
   - `MOUSENAV_*` → `MOUSE` layer
   - `QWERTY_*` → `QWERTY` layer

4. **Preserve Format**: Maintain the exact YAML structure in `keymap-drawer.yaml`, including:
   - Special keys: `{type: ghost}`, `{type: trans}`, `{type: held}`
   - Ghost keys at positions 30 and 35
   - Proper layer names and hierarchy

## Example Transformation

```c
// In users/smathev/wrappers.h
#define ____NORTO_L1_K1__ DK_OSTR
#define ____NORTO_L1_K2__ DK_AE
#define ____NORTO_L1_K3__ KC_U
#define ____NORTO_L1_K4__ KC_G
#define ____NORTO_L1_K5__ KC_J

#define __________________NORTO_L1____________________ ____NORTO_L1_K1__, ____NORTO_L1_K2__, ____NORTO_L1_K3__, ____NORTO_L1_K4__, ____NORTO_L1_K5__

// In keymap-drawer.yaml
NORTO:
  - [Ø, Æ, U, G, J, ...remaining keys...]
```

## Important Notes

- Wrapper definitions use individual key definitions (e.g., `____NORTO_L1_K1__`) that are then combined
- Home row mods are defined using `LGUI_T()`, `LALT_T()`, `LSFT_T()`, `LCTL_T()` and their right-hand equivalents
- Danish keycodes use `DK_` prefix (e.g., `DK_OSTR` for Ø, `DK_AE` for Æ, `DK_ARNG` for Å)
- Look for the individual key definitions first, then the wrapper that combines them

## Validation

After updating, verify:
1. All layers have correct number of keys (10 per row for 3 rows + thumb cluster)
2. Special Norwegian characters maintained (Ø, Æ, Å)
3. Home row mods properly represented
4. Layer activators correctly linked

## File Locations

- **Wrapper definitions**: `users/smathev/wrappers.h`
- **Helper macros**: `users/smathev/smathev.h`
- **Custom functions**: `users/smathev/process_records.c`, `users/smathev/combos.c`
- **Keymap usage**: `keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c`
- **YAML target**: `keymap-drawer.yaml`

## Regenerate Visual

After updating YAML, run:
```bash
keymap draw ./qmk_userspace/keymap-drawer.yaml -o ./qmk_userspace/visual_keymap.svg
```
