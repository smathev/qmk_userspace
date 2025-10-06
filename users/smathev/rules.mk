SRC += smathev.c \
       process_records.c \
       combos.c \
       casemodes.c

# Build Options
#   change yes to no to disable
#
BOOTMAGIC_ENABLE = no       # Virtual DIP switch configuration
EXTRAKEY_ENABLE = yes       # Audio control and System control
CONSOLE_ENABLE = no        # Console for debug
COMMAND_ENABLE = no        # Commands for debug and configuration
# Do not enable SLEEP_LED_ENABLE. it uses the same timer as BACKLIGHT_ENABLE
SLEEP_LED_ENABLE = no       # Breathing sleep LED during USB suspend
# if this doesn't work, see here: https://github.com/tmk/tmk_keyboard/wiki/FAQ#nkro-doesnt-work
NKRO_ENABLE = no            # USB Nkey Rollover
BACKLIGHT_ENABLE = no       # Enable keyboard backlight functionality

MIDI_ENABLE = no            # MIDI support
UNICODE_ENABLE = no         # Unicode
BLUETOOTH_ENABLE = no       # Enable Bluetooth with the Adafruit EZ-Key HID
AUDIO_ENABLE = no           # Audio output on port C6
FAUXCLICKY_ENABLE = no      # Use buzzer to emulate clicky switches
ENCODER_ENABLE = no
OLED_ENABLE = YES
OLED_DRIVER_ENABLE = yes
OLED_DRIVER = ssd1306
# EXTRAFLAGS     += -flto     # macros disabled, if you need the extra space
MOUSEKEY_ENABLE = no

SPLIT_KEYBOARD = yes        # Use shared split_common code

LAYOUTS = split_3x5_3       # Community layout support

DEFERRED_EXEC_ENABLE = yes
# Smathev added from: https://getreuer.info/posts/keyboards/repeat-key/index.html
COMBO_ENABLE = yes

# Smathev implemented from: https://docs.qmk.fm/#/feature_auto_shift
AUTO_SHIFT_ENABLE = yes

# Implemented from  https://github.com/samhocevar-forks/qmk-firmware/blob/master/docs/feature_tap_dance.md
# TAP_DANCE_ENABLE = yes

# https://github.com/qmk/qmk_firmware/blob/master/docs/feature_leader_key.md
# LEADER_ENABLE = yes

# CASEMODE_ENABLE
CASEMODE_ENABLE = yes

#WPM ENABLE
WPM_ENABLE = yes

