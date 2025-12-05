SRC += smathev.c \
       process_records.c \
       combos.c

# Build Options
# Only include userspace-specific features here
# Hardware and basic features should be in keyboard's info.json

DEFERRED_EXEC_ENABLE = yes

# Userspace-specific features
COMBO_ENABLE = yes           # Combo key feature

AUTO_SHIFT_ENABLE = yes      # Auto shift for hold-to-shift
OLED_ENABLE = yes            # Enable OLED displays
OLED_DRIVER = ssd1306        # Standard I2C OLED driver (SSD1306)

CAPS_WORD_ENABLE = yes

#WPM ENABLE
WPM_ENABLE = yes

DYNAMIC_TAPPING_TERM_ENABLE = yes
