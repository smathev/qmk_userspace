SRC += smathev.c \
       process_records.c \
       combos.c \
       casemodes.c

# Build Options
# Only include userspace-specific features here
# Hardware and basic features should be in keyboard's info.json

DEFERRED_EXEC_ENABLE = yes

# Userspace-specific features
COMBO_ENABLE = yes           # Combo key feature
# Use the actual keymap.c for introspection instead of the generated one from keymap.json
INTROSPECTION_KEYMAP_C = keyboards/fingerpunch/sweeeeep/keymaps/smathev/keymap.c

AUTO_SHIFT_ENABLE = yes      # Auto shift for hold-to-shift

# Implemented from  https://github.com/samhocevar-forks/qmk-firmware/blob/master/docs/feature_tap_dance.md
# TAP_DANCE_ENABLE = yes

# https://github.com/qmk/qmk_firmware/blob/master/docs/feature_leader_key.md
# LEADER_ENABLE = yes

# CASEMODE_ENABLE
CASEMODE_ENABLE = yes

#WPM ENABLE
WPM_ENABLE = yes

