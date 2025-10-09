# Workflow Diagrams

## Standard Flashing Flow

```
┌────────────────────────────────────────────────────────────┐
│ START: Run ./autoflash_modular.sh                         │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ Build firmware once                                        │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ PROMPT: "Which side will you flash first? [left/right]:"  │
│ USER INPUT: "left" ◄── Can type! Not in bootloader yet    │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ Script: "Enter bootloader mode on the LEFT half..."       │
│ Script: "Press Enter when ready..."                       │
│ USER: Double-taps RESET on LEFT keyboard                  │
│ USER: Presses Enter                                        │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ Script: Waiting for RP2040 device...                      │
│ Script: Found device at /media/user/RPI-RP2               │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ Script: Get device identifier (e.g., serial:ABC123)       │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
         ┌──────────┴───────────┐
         │                      │
         ▼                      ▼
    ┌─────────┐         ┌──────────────┐
    │ First   │         │ Subsequent   │
    │ Time    │         │ Run          │
    └────┬────┘         └──────┬───────┘
         │                     │
         │                     ▼
         │              ┌──────────────────────────────┐
         │              │ Device in mappings?          │
         │              └────┬─────────────────┬───────┘
         │                   │                 │
         │                   ▼                 ▼
         │            ┌────────────┐    ┌────────────┐
         │            │ Matches?   │    │ Mismatch!  │
         │            │ ✅ Yes     │    │ ⚠️  No     │
         │            └─────┬──────┘    └─────┬──────┘
         │                  │                  │
         ▼                  │                  │
┌────────────────────┐      │                  │
│ Save as LEFT       │      │                  │
└────────┬───────────┘      │                  │
         │                  │                  │
         │                  ▼                  ▼
         │           ┌────────────┐    ┌─────────────────────┐
         │           │ Continue   │    │ PROMPT USER:        │
         │           │ flashing   │    │ [e] Exit            │
         │           └─────┬──────┘    │ [c] Clear & update  │
         │                 │           │ [f] Force flash     │
         │                 │           └──────┬──────────────┘
         │                 │                  │
         └─────────────────┴──────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│ Flash LEFT side with uf2-split-left                        │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ ✅ LEFT side flashed successfully!                         │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ PROMPT: "Flash the RIGHT side now? [y/n]:"                │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
         ┌──────────┴───────────┐
         │                      │
         ▼                      ▼
    ┌─────────┐           ┌──────────┐
    │ Yes     │           │ No       │
    └────┬────┘           └────┬─────┘
         │                     │
         │                     ▼
         │              ┌────────────┐
         │              │ DONE       │
         │              └────────────┘
         │
         ▼
    (Repeat process for RIGHT side)
```

## Mismatch Handling Detail

```
┌────────────────────────────────────────────────────────────┐
│ USER said: "left"                                          │
│ Device detected: serial:ABC123                             │
│ Mapping says: "right"                                      │
└───────────────────┬────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────┐
│ ⚠️  WARNING: SIDE MISMATCH DETECTED                        │
│                                                            │
│ Expected: left side                                        │
│ Saved mapping says: right side                             │
│                                                            │
│ This means either:                                         │
│   1. You plugged in the WRONG keyboard half                │
│   2. The saved mapping is incorrect                        │
│                                                            │
│ What would you like to do?                                │
│   [e] Exit safely (recommended)                            │
│   [c] Clear this mapping and save as left                  │
│   [f] Force flash as left anyway (DANGEROUS)               │
└───────────────────┬────────────────────────────────────────┘
                    │
         ┌──────────┼──────────┐
         │          │          │
         ▼          ▼          ▼
    ┌────────┐ ┌────────┐ ┌──────────────┐
    │ [e]    │ │ [c]    │ │ [f]          │
    │ Exit   │ │ Clear  │ │ Force        │
    └───┬────┘ └───┬────┘ └──────┬───────┘
        │          │              │
        │          │              ▼
        │          │       ┌──────────────────┐
        │          │       │ "Are you sure?"  │
        │          │       │ [yes/no]         │
        │          │       └────┬─────────────┘
        │          │            │
        │          │     ┌──────┴──────┐
        │          │     │             │
        │          │     ▼             ▼
        │          │  ┌────┐      ┌────────┐
        │          │  │yes │      │no      │
        │          │  └─┬──┘      └───┬────┘
        │          │    │             │
        │          ▼    ▼             │
        │      ┌───────────┐          │
        │      │ Update    │          │
        │      │ mapping & │          │
        │      │ continue  │          │
        │      └─────┬─────┘          │
        │            │                │
        └────────────┴────────────────┘
                     │
                     ▼
              ┌────────────┐
              │ Exit 1     │
              └────────────┘
```

## First Time Setup

```
Run 1: First Device
───────────────────
User: "left"
Device: serial:ABC123
Mapping: {} (empty)
Result: ✅ Save serial:ABC123 → left

Run 1: Second Device
────────────────────
User: "right"
Device: serial:XYZ789
Mapping: {"serial:ABC123": "left"}
Result: ✅ Save serial:XYZ789 → right

Run 2+: Known Devices
─────────────────────
User: "left"
Device: serial:ABC123
Mapping: {"serial:ABC123": "left", "serial:XYZ789": "right"}
Result: ✅ Match! Continue automatically
```

## Why This Flow Works

1. **User can type** - Asked BEFORE entering bootloader
2. **Safety first** - Verifies device matches expectation
3. **Clear on mismatch** - User knows exactly what's wrong
4. **Flexible** - Can update mappings or exit safely
5. **Persistent** - Only asks once, remembers forever
