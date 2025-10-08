#!/usr/bin/env python3
"""
OLED Font Helper - Visualize and design custom graphics for QMK OLED displays
For 128x32 displays (4 rows × 21 characters, each character is 6x8 pixels)
"""

import re

def parse_font_file(filename):
    """Parse the glcdfont.c file and extract character definitions"""
    with open(filename, 'r') as f:
        content = f.read()

    # Extract the font array data
    font_match = re.search(r'const unsigned char font\[\] PROGMEM = \{(.*?)\};', content, re.DOTALL)
    if not font_match:
        print("ERROR: Could not find font array in file")
        return None

    font_data = font_match.group(1)

    # Parse hex values
    hex_values = re.findall(r'0x[0-9A-Fa-f]{2}', font_data)

    # Each character is 6 bytes
    characters = []
    for i in range(0, len(hex_values), 6):
        if i + 6 <= len(hex_values):
            char_bytes = [int(h, 16) for h in hex_values[i:i+6]]
            characters.append(char_bytes)

    return characters

def visualize_char(char_bytes, char_code):
    """Visualize a single character as ASCII art"""
    print(f"\n=== Character 0x{char_code:02X} ({char_code}) ===")

    # Each byte represents 8 vertical pixels
    # We have 6 bytes (6 columns of pixels)
    for row in range(8):
        line = ""
        for col in range(6):
            byte = char_bytes[col]
            # Check if bit at position 'row' is set
            if byte & (1 << row):
                line += "██"
            else:
                line += "  "
        print(line)

def visualize_range(characters, start, end):
    """Visualize a range of characters"""
    print(f"\n{'='*60}")
    print(f"Visualizing characters 0x{start:02X} to 0x{end:02X}")
    print(f"{'='*60}")

    for i in range(start, min(end + 1, len(characters))):
        visualize_char(characters[i], i)

def show_oled_layout(characters, char_codes, title="OLED Display"):
    """Show how characters will look when displayed together on OLED"""
    print(f"\n{'='*60}")
    print(f"{title}")
    print(f"{'='*60}")

    # For 128x32 display, we can show characters side by side
    # Each character is 6 pixels wide, 8 pixels tall

    # Find how many characters we have
    num_chars = len(char_codes)

    # Display all 8 rows
    for row in range(8):
        line = ""
        for char_code in char_codes:
            if char_code >= len(characters):
                # Empty character
                line += "      "
            else:
                char_bytes = characters[char_code]
                for col in range(6):
                    byte = char_bytes[col]
                    if byte & (1 << row):
                        line += "█"
                    else:
                        line += " "
        print(line)

def main():
    font_file = "keyboards/fingerpunch/sweeeeep/keymaps/smathev/glcdfont.c"

    print("="*60)
    print("QMK OLED Font Visualizer")
    print("="*60)

    characters = parse_font_file(font_file)
    if not characters:
        return

    print(f"\nFound {len(characters)} characters in font file")

    # Show the logo (what render_logo displays)
    print("\n" + "="*60)
    print("CURRENT LOGO (render_logo)")
    print("="*60)
    logo_chars = [
        0x80, 0x81, 0x82, 0x83, 0x84,  # Row 1
        0xa0, 0xa1, 0xa2, 0xa3, 0xa4,  # Row 2
        0xc0, 0xc1, 0xc2, 0xc3, 0xc4,  # Row 3
    ]
    show_oled_layout(characters, logo_chars, "Logo Graphics")
    print("\nFollowed by text: 'Gio*K'")

    # Show layer indicators
    print("\n" + "="*60)
    print("DEFAULT LAYER INDICATOR")
    print("="*60)
    default_layer = [0x94, 0x95, 0x96, 0xb4, 0xb5, 0xb6, 0xd4, 0xd5, 0xd6]
    show_oled_layout(characters, default_layer, "Default Layer Icon")

    print("\n" + "="*60)
    print("RAISE/NAVIGATION LAYER INDICATOR")
    print("="*60)
    raise_layer = [0x97, 0x98, 0x99, 0xb7, 0xb8, 0xb9, 0xd7, 0xd8, 0xd9]
    show_oled_layout(characters, raise_layer, "Navigation Layer Icon")

    print("\n" + "="*60)
    print("LOWER/SYMBOLS LAYER INDICATOR")
    print("="*60)
    lower_layer = [0x9a, 0x9b, 0x9c, 0xba, 0xbb, 0xbc, 0xda, 0xdb, 0xdc]
    show_oled_layout(characters, lower_layer, "Symbols Layer Icon")

    # Show modifier indicators
    print("\n" + "="*60)
    print("MODIFIER KEY INDICATORS")
    print("="*60)

    print("\nGUI (Super/Windows) Key:")
    show_oled_layout(characters, [0x85, 0x86, 0xa5, 0xa6], "GUI Off")
    show_oled_layout(characters, [0x87, 0x88, 0xa7, 0xa8], "GUI On")

    print("\nALT Key:")
    show_oled_layout(characters, [0x89, 0x8a, 0xa9, 0xaa], "ALT Off")
    show_oled_layout(characters, [0xcd, 0xce, 0xcf, 0xd0], "ALT On")

    print("\nCTRL Key:")
    show_oled_layout(characters, [0x8d, 0x8e, 0xad, 0xae], "CTRL Off")
    show_oled_layout(characters, [0x8f, 0x90, 0xaf, 0xb0], "CTRL On")

    print("\nSHIFT Key:")
    show_oled_layout(characters, [0x8b, 0x8c, 0xab, 0xac], "SHIFT Off")
    show_oled_layout(characters, [0xcd, 0xce, 0xcf, 0xd0], "SHIFT On")

    print("\n" + "="*60)
    print("\nNOTE: Your OLED is 128x32 (4 rows × 21 characters)")
    print("Each character is 6 pixels wide × 8 pixels tall")
    print("Total usable width: 126 pixels (21 chars × 6 pixels)")
    print("\nFor best results on 4 rows:")
    print("- Row 1: Logo + text (first line)")
    print("- Row 2: Layer indicator + modifiers (second line)")
    print("- Row 3: Additional info (third line)")
    print("- Row 4: WPM or other status (fourth line)")
    print("\nTo edit graphics, use: https://helixfonteditor.netlify.com/")
    print("Or manually edit the hex values in glcdfont.c")
    print("="*60)

if __name__ == "__main__":
    main()
