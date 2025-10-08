#!/usr/bin/env python3
"""
Generate a minimal custom font section for 128x32 OLED displays
This creates simple, readable icons that fit in a single row
"""

def generate_simple_icons():
    """Generate simple icon designs for the custom characters"""

    icons = {}

    # 0x80-0x81: Logo (simple keyboard icon)
    # Row 1 of 2-char logo
    icons[0x80] = [
        0b00111110,  # |  ████
        0b01000001,  # | █    █
        0b01010101,  # | █ █ █
        0b01010101,  # | █ █ █
        0b01000001,  # | █    █
        0b00111110,  # |  ████
    ]
    # Row 2 of 2-char logo
    icons[0x81] = [
        0b00111110,  # |  ████
        0b01000001,  # | █    █
        0b01010101,  # | █ █ █
        0b01010101,  # | █ █ █
        0b01000001,  # | █    █
        0b00111110,  # |  ████
    ]

    # 0x92-0x93: Default/Base layer icon (house or keyboard)
    icons[0x92] = [
        0b00001000,  # |    █
        0b00011100,  # |   ███
        0b00111110,  # |  █████
        0b01111111,  # | ███████
        0b00101010,  # |  █ █ █
        0b00101010,  # |  █ █ █
    ]
    icons[0x93] = [
        0b00010000,  # |    █
        0b00111000,  # |   ███
        0b01111100,  # |  █████
        0b11111110,  # | ███████
        0b01010100,  # |  █ █ █
        0b01010100,  # |  █ █ █
    ]

    # 0x94-0x95: Symbol layer icon (# and $)
    icons[0x94] = [
        0b00100100,  # |  █  █
        0b01111111,  # | ███████
        0b00100100,  # |  █  █
        0b01111111,  # | ███████
        0b00100100,  # |  █  █
        0b00000000,  # |
    ]
    icons[0x95] = [
        0b00100100,  # |  █  █
        0b00101010,  # |  █ █ █
        0b01111111,  # | ███████
        0b00101010,  # |  █ █ █
        0b00010010,  # |    █  █
        0b00000000,  # |
    ]

    # 0x96-0x97: Navigation layer icon (arrows)
    icons[0x96] = [
        0b00001000,  # |    █
        0b00011100,  # |   ███
        0b00101010,  # |  █ █ █
        0b00001000,  # |    █
        0b00001000,  # |    █
        0b00001000,  # |    █
    ]
    icons[0x97] = [
        0b00001000,  # |    █
        0b00001000,  # |    █
        0b00001000,  # |    █
        0b00101010,  # |  █ █ █
        0b00011100,  # |   ███
        0b00001000,  # |    █
    ]

    # 0x98: GUI/Windows key (simple windows logo)
    icons[0x98] = [
        0b01100110,  # | ██  ██
        0b01100110,  # | ██  ██
        0b00000000,  # |
        0b01111110,  # | ██████
        0b01100110,  # | ██  ██
        0b01100110,  # | ██  ██
    ]

    # 0x99: ALT key (simple A)
    icons[0x99] = [
        0b01111110,  # | ██████
        0b00001001,  # |     █  █
        0b00001001,  # |     █  █
        0b00001001,  # |     █  █
        0b01111110,  # | ██████
        0b00000000,  # |
    ]

    # 0x9A: CTRL key (simple C)
    icons[0x9A] = [
        0b00111110,  # |  █████
        0b01000001,  # | █     █
        0b01000001,  # | █     █
        0b01000001,  # | █     █
        0b00100010,  # |  █   █
        0b00000000,  # |
    ]

    # 0x9B: SHIFT key (up arrow)
    icons[0x9B] = [
        0b00001000,  # |    █
        0b00011100,  # |   ███
        0b00101010,  # |  █ █ █
        0b00001000,  # |    █
        0b00001000,  # |    █
        0b00001000,  # |    █
    ]

    return icons

def format_hex_array(byte_array):
    """Format a byte array as hex values for C code"""
    return ", ".join(f"0x{b:02X}" for b in byte_array)

def main():
    print("="*70)
    print("SIMPLE ICON GENERATOR FOR 128x32 OLED")
    print("="*70)
    print("\nThis generates simple, single-row icons for your custom font.")
    print("Copy these hex values into your glcdfont.c file.\n")

    icons = generate_simple_icons()

    print("// ====================================================================")
    print("// CUSTOM ICONS FOR 128x32 DISPLAY")
    print("// Add these to your glcdfont.c at the appropriate positions")
    print("// ====================================================================\n")

    descriptions = {
        0x80: "Logo part 1 (keyboard icon)",
        0x81: "Logo part 2 (keyboard icon)",
        0x92: "Default layer icon part 1 (home/keyboard)",
        0x93: "Default layer icon part 2 (home/keyboard)",
        0x94: "Symbol layer icon part 1 (# symbol)",
        0x95: "Symbol layer icon part 2 ($ symbol)",
        0x96: "Navigation layer icon part 1 (up arrow)",
        0x97: "Navigation layer icon part 2 (down arrow)",
        0x98: "GUI/Windows modifier key",
        0x99: "ALT modifier key",
        0x9A: "CTRL modifier key",
        0x9B: "SHIFT modifier key (up arrow)",
    }

    for code in sorted(icons.keys()):
        print(f"  // Character 0x{code:02X} ({code}): {descriptions.get(code, '')}")
        print(f"  {format_hex_array(icons[code])},")
        print()

    print("\n" + "="*70)
    print("USAGE INSTRUCTIONS:")
    print("="*70)
    print("""
1. Open your glcdfont.c file
2. Find the position where character 0x80 starts (around line 136)
3. Replace the hex values at positions 0x80, 0x81, 0x92-0x9B with the above
4. Save and recompile your firmware
5. Use the redesigned OLED code from oled_redesign_128x32.c

TIP: To customize these icons further, use:
     https://helixfonteditor.netlify.com/

Each character is 6 bytes representing 6 columns of 8 pixels.
Bit 0 = top pixel, Bit 7 = bottom pixel in each column.
""")

if __name__ == "__main__":
    main()
