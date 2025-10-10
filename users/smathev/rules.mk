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

AUTO_SHIFT_ENABLE = yes      # Auto shift for hold-to-shift
OLED_ENABLE = yes            # Enable OLED displays
OLED_DRIVER = ssd1306        # Standard I2C OLED driver (SSD1306)

# Implemented from  https://github.com/samhocevar-forks/qmk-firmware/blob/master/docs/feature_tap_dance.md
# TAP_DANCE_ENABLE = yes

# https://github.com/qmk/qmk_firmware/blob/master/docs/feature_leader_key.md
# LEADER_ENABLE = yes

# CASEMODE_ENABLE
CASEMODE_ENABLE = yes

#WPM ENABLE
WPM_ENABLE = yes

DYNAMIC_TAPPING_TERM_ENABLE = yes
