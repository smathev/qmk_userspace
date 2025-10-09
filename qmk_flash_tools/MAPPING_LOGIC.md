# Device Mapping Logic - Simple Explanation

## The Three States

```
State 1: EMPTY      →  Learn both devices
State 2: PARTIAL    →  Complete the mapping  
State 3: COMPLETE   →  Only allow known devices
```

## State Transitions

```
┌─────────────┐
│   EMPTY     │  No devices mapped
│   (0/2)     │
└──────┬──────┘
       │ Flash first device
       ▼
┌─────────────┐
│  PARTIAL    │  One device mapped
│   (1/2)     │
└──────┬──────┘
       │ Flash second device
       ▼
┌─────────────┐
│  COMPLETE   │  Both devices mapped
│   (2/2)     │  ← Stays here forever
└─────────────┘
```

## Behavior by State

### State 1: EMPTY (0/2 devices)
```
Action: LEARN
Rule:   Save devices as user specifies
Result: Build initial mapping
```

### State 2: PARTIAL (1/2 devices)
```
Action: COMPLETE
Rule:   Known device must match, unknown must be the missing side
Result: Complete mapping OR error if ambiguous
```

### State 3: COMPLETE (2/2 devices)
```
Action: VERIFY
Rule:   Only known devices allowed, must match expected side
Result: Continue OR error immediately
```

## Decision Tree

```
Device Detected
       │
       ▼
┌────────────────┐
│ Mapping State? │
└───┬────┬───┬───┘
    │    │   │
    ▼    ▼   ▼
  Empty Part Comp
    │    │    │
    │    │    ▼
    │    │  ┌──────────────┐
    │    │  │ Device Known?│
    │    │  └──┬───────┬───┘
    │    │     │       │
    │    │     NO      YES
    │    │     │       │
    │    │     ▼       ▼
    │    │   REJECT  Match?
    │    │            │
    │    │      ┌─────┴─────┐
    │    │      YES          NO
    │    │      │            │
    │    │      ▼            ▼
    │    │    CONTINUE    MISMATCH
    │    │                 OPTIONS
    │    │
    │    ▼
    │  ┌──────────────┐
    │  │ Device Known?│
    │  └──┬───────┬───┘
    │     │       │
    │     NO      YES
    │     │       │
    │     ▼       ▼
    │  Expected  Match?
    │  unmapped    │
    │   side?  ┌───┴────┐
    │     │    YES      NO
    │     ▼    │        │
    │  ┌───┐  ▼        ▼
    │  │YES│CONTINUE  ERROR
    │  └─┬─┘
    │    │NO
    │    ▼
    │  ERROR
    │
    ▼
  SAVE AS
  EXPECTED
```

## Examples

### Example 1: First Time (Empty → Partial → Complete)
```
$ ./autoflash_modular.sh

State: EMPTY (0/2)
You: "left"
Device: ABC123
Action: Save ABC123 → left
New State: PARTIAL (1/2)

You: "Flash right? yes"
Device: XYZ789
Action: Save XYZ789 → right
New State: COMPLETE (2/2)

Mapping: {"ABC123": "left", "XYZ789": "right"}
```

### Example 2: Normal Use (Complete)
```
$ ./autoflash_modular.sh

State: COMPLETE (2/2)
You: "left"
Device: ABC123
Check: ABC123 is mapped to "left" ✅
Action: Continue

You: "right"
Device: XYZ789
Check: XYZ789 is mapped to "right" ✅
Action: Continue
```

### Example 3: Unknown Device (Complete → Rejected)
```
$ ./autoflash_modular.sh

State: COMPLETE (2/2)
You: "left"
Device: UNKNOWN
Check: Not in mapping ❌
Action: REJECT and EXIT

Error: "Unknown device! Expected ABC123 or XYZ789"
```

### Example 4: Partial Mapping - Good
```
State: PARTIAL (1/2) - Only "left" mapped

Scenario A: Known device
You: "left"
Device: ABC123 (known as left)
Action: Continue ✅

Scenario B: Unknown device for unmapped side
You: "right" (unmapped)
Device: UNKNOWN
Action: Save as right ✅
New State: COMPLETE
```

### Example 5: Partial Mapping - Bad
```
State: PARTIAL (1/2) - Only "left" mapped

You: "left" (already mapped)
Device: UNKNOWN
Question: Is this a replacement for left? Or the unmapped right?
Action: ERROR - ambiguous ❌
Message: "Cannot determine! Clear mappings."
```

## Key Principle

**Once both sides are mapped (COMPLETE state), the script becomes protective:**
- ✅ Only the two known devices can be flashed
- ❌ Any unknown device is rejected immediately
- 🛡️ This prevents accidentally flashing the wrong keyboard

**To reset:** `cd qmk_flash_tools && rm device_mappings.json`

## Why This Works

1. **Learning Phase** (Empty/Partial) - Flexible, builds mapping
2. **Protection Phase** (Complete) - Strict, prevents mistakes
3. **Clear Errors** - Always know why something failed
4. **Easy Recovery** - Delete mapping file to restart
