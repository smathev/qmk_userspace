#!/usr/bin/env bash
# =============================================================================
# Side Mapping Library
# =============================================================================
# Functions for storing and retrieving keyboard side mappings
# Maps USB device identifiers to left/right sides
# =============================================================================

# Default mapping file location (will be set by calling script)
# Falls back to current directory if not set
SIDE_MAPPING_FILE="${SIDE_MAPPING_FILE:-./device_mappings.json}"

# ----------------------
# Function: init_mapping_file
# Ensure the mapping file exists
# Usage: init_mapping_file
# ----------------------
init_mapping_file() {
    if [[ ! -f "$SIDE_MAPPING_FILE" ]]; then
        echo "{}" > "$SIDE_MAPPING_FILE"
        echo "Created new mapping file: $SIDE_MAPPING_FILE" >&2
    fi
}

# ----------------------
# Function: check_jq_installed
# Verify jq is available for JSON operations
# Usage: check_jq_installed || exit 1
# ----------------------
check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        echo "❌ Error: 'jq' is required but not installed." >&2
        echo "   Install it with: sudo apt-get install jq" >&2
        return 1
    fi
    return 0
}

# ----------------------
# Function: get_saved_side
# Retrieve the saved side mapping for a device identifier
# Usage: side=$(get_saved_side "serial:ABC123")
# Returns: "left", "right", or empty string if not found
# ----------------------
get_saved_side() {
    local device_id="$1"

    if [[ -z "$device_id" ]]; then
        echo "" >&2
        return 1
    fi

    check_jq_installed || return 1
    init_mapping_file

    local side
    side=$(jq -r --arg id "$device_id" '.[$id] // ""' "$SIDE_MAPPING_FILE" 2>/dev/null)

    # Handle null or empty
    if [[ "$side" == "null" || -z "$side" ]]; then
        echo ""
        return 1
    fi

    echo "$side"
    return 0
}

# ----------------------
# Function: save_side_mapping
# Save a device identifier to side mapping
# Usage: save_side_mapping "serial:ABC123" "left"
# ----------------------
save_side_mapping() {
    local device_id="$1"
    local side="$2"

    if [[ -z "$device_id" || -z "$side" ]]; then
        echo "Error: device_id and side required" >&2
        return 1
    fi

    if [[ "$side" != "left" && "$side" != "right" ]]; then
        echo "Error: side must be 'left' or 'right'" >&2
        return 1
    fi

    check_jq_installed || return 1
    init_mapping_file

    # Save mapping
    local tmpfile=$(mktemp)
    jq --arg id "$device_id" --arg side "$side" '. + {($id): $side}' "$SIDE_MAPPING_FILE" > "$tmpfile"

    if [[ $? -eq 0 ]]; then
        mv "$tmpfile" "$SIDE_MAPPING_FILE"
        echo "✅ Saved mapping: $device_id → $side" >&2
        return 0
    else
        rm -f "$tmpfile"
        echo "❌ Failed to save mapping" >&2
        return 1
    fi
}

# ----------------------
# Function: prompt_for_side
# Ask user to identify which side a device is
# Usage: side=$(prompt_for_side "serial:ABC123")
# Returns: "left" or "right"
# ----------------------
prompt_for_side() {
    local device_id="$1"

    echo "" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "⚠️  UNKNOWN DEVICE - First Time Setup" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "" >&2
    echo "The script has detected a keyboard half that it hasn't" >&2
    echo "seen before. This is expected on first run." >&2
    echo "" >&2
    echo "Device ID: $device_id" >&2
    echo "" >&2
    echo "Please tell me which side this is so I can remember it" >&2
    echo "for future flashing sessions." >&2
    echo "" >&2

    local side
    while true; do
        read -rp "Which side is currently plugged in? [left/right]: " side
        side=${side,,}

        if [[ "$side" == "left" || "$side" == "right" ]]; then
            echo "$side"
            return 0
        else
            echo "❌ Invalid input. Please type 'left' or 'right'." >&2
        fi
    done
}

# ----------------------
# Function: detect_side
# Determine the left/right side of a device
# Checks saved mapping first, prompts user if unknown, then saves
# Usage: side=$(detect_side "serial:ABC123")
# Returns: "left" or "right"
# ----------------------
detect_side() {
    local device_id="$1"

    if [[ -z "$device_id" ]]; then
        echo "Error: device_id required" >&2
        return 1
    fi

    echo "   Device Identifier: $device_id" >&2

    # Try to get saved side
    local side
    side=$(get_saved_side "$device_id" 2>/dev/null)

    if [[ -n "$side" ]]; then
        # Found in mapping
        echo "   ✅ Recognized: $side side (from saved mapping)" >&2
        echo "$side"
        return 0
    fi

    # Not found - prompt user
    side=$(prompt_for_side "$device_id")

    # Save the mapping
    save_side_mapping "$device_id" "$side"

    echo "" >&2
    echo "   Next time this device is detected, it will be" >&2
    echo "   automatically identified as the $side side." >&2
    echo "" >&2

    echo "$side"
    return 0
}

# ----------------------
# Function: get_mapping_state
# Determine the current state of the mapping file
# Returns: "empty", "partial", or "complete"
# ----------------------
get_mapping_state() {
    check_jq_installed || return 1
    init_mapping_file

    local count
    count=$(jq 'length' "$SIDE_MAPPING_FILE")

    case $count in
        0) echo "empty" ;;
        1) echo "partial" ;;
        2) echo "complete" ;;
        *) echo "unknown" ;;
    esac
}

# ----------------------
# Function: get_mapped_devices
# Get list of all mapped device IDs
# Returns: space-separated list of device IDs
# ----------------------
get_mapped_devices() {
    check_jq_installed || return 1
    init_mapping_file

    jq -r 'keys[]' "$SIDE_MAPPING_FILE" | tr '\n' ' '
}

# ----------------------
# Function: get_unmapped_side
# If mapping is partial, determine which side is NOT mapped yet
# Returns: "left", "right", or empty string if both/neither mapped
# ----------------------
get_unmapped_side() {
    check_jq_installed || return 1
    init_mapping_file

    local has_left has_right
    has_left=$(jq -r 'to_entries | map(select(.value == "left")) | length' "$SIDE_MAPPING_FILE")
    has_right=$(jq -r 'to_entries | map(select(.value == "right")) | length' "$SIDE_MAPPING_FILE")

    if [[ "$has_left" -eq 0 ]]; then
        echo "left"
    elif [[ "$has_right" -eq 0 ]]; then
        echo "right"
    else
        echo ""
    fi
}

# ----------------------
# Function: detect_side_with_expected
# Detect device side and verify it matches expected side
# Uses intelligent verification based on mapping state
# Usage: side=$(detect_side_with_expected "serial:ABC123" "left")
# Returns: "left" or "right", or exits on error
# ----------------------
detect_side_with_expected() {
    local device_id="$1"
    local expected_side="$2"

    if [[ -z "$device_id" || -z "$expected_side" ]]; then
        echo "Error: device_id and expected_side required" >&2
        return 1
    fi

    echo "   Device Identifier: $device_id" >&2
    echo "   Expected Side: $expected_side" >&2

    # Get current mapping state
    local mapping_state
    mapping_state=$(get_mapping_state)
    echo "   Mapping State: $mapping_state" >&2

    # Try to get saved side for this device
    local saved_side
    saved_side=$(get_saved_side "$device_id" 2>/dev/null)

    # -----------------------------------------------------------------
    # STATE 1: EMPTY MAPPING (Learning Mode)
    # -----------------------------------------------------------------
    if [[ "$mapping_state" == "empty" ]]; then
        echo "" >&2
        echo "   📝 Learning mode (first time setup)" >&2
        echo "   ✅ Saving device as $expected_side side" >&2
        save_side_mapping "$device_id" "$expected_side"
        echo "$expected_side"
        return 0
    fi

    # -----------------------------------------------------------------
    # STATE 2: PARTIAL MAPPING (One Side Known)
    # -----------------------------------------------------------------
    if [[ "$mapping_state" == "partial" ]]; then
        local unmapped_side
        unmapped_side=$(get_unmapped_side)

        if [[ -n "$saved_side" ]]; then
            # Device is known - verify it matches
            if [[ "$saved_side" == "$expected_side" ]]; then
                echo "   ✅ Confirmed: $expected_side side (matches saved mapping)" >&2
                echo "$expected_side"
                return 0
            else
                # MISMATCH in partial state
                echo "" >&2
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
                echo "❌ ERROR: MISMATCH IN PARTIAL MAPPING" >&2
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
                echo "" >&2
                echo "Expected: $expected_side side" >&2
                echo "Device is saved as: $saved_side side" >&2
                echo "" >&2
                echo "This device is known but on the wrong side!" >&2
                echo "Clear mappings and re-learn: rm $SIDE_MAPPING_FILE" >&2
                exit 1
            fi
        else
            # Device is unknown - check if user expects the unmapped side
            if [[ "$expected_side" == "$unmapped_side" ]]; then
                echo "" >&2
                echo "   ℹ️  Unknown device, expecting unmapped side" >&2
                echo "   ✅ Saving as $expected_side side (completes mapping)" >&2
                save_side_mapping "$device_id" "$expected_side"
                echo "$expected_side"
                return 0
            else
                # User expects mapped side but got unknown device
                echo "" >&2
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
                echo "❌ ERROR: AMBIGUOUS DEVICE IN PARTIAL MAPPING" >&2
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
                echo "" >&2
                echo "Expected: $expected_side side (which is already mapped)" >&2
                echo "But got: Unknown device $device_id" >&2
                echo "" >&2
                echo "This could be:" >&2
                echo "  1. A replacement controller for $expected_side side" >&2
                echo "  2. The wrong side plugged in" >&2
                echo "" >&2
                echo "Cannot determine safely!" >&2
                echo "Clear mappings and re-learn: rm $SIDE_MAPPING_FILE" >&2
                exit 1
            fi
        fi
    fi

    # -----------------------------------------------------------------
    # STATE 3: COMPLETE MAPPING (Both Sides Known)
    # -----------------------------------------------------------------
    if [[ "$mapping_state" == "complete" ]]; then
        if [[ -z "$saved_side" ]]; then
            # Unknown device with complete mapping = ERROR
            echo "" >&2
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
            echo "❌ ERROR: UNKNOWN DEVICE (COMPLETE MAPPING)" >&2
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
            echo "" >&2
            echo "Detected device: $device_id" >&2
            echo "Expected one of the known devices:" >&2
            get_mapped_devices | tr ' ' '\n' | while read dev; do
                local side=$(get_saved_side "$dev")
                echo "  - $dev ($side side)" >&2
            done
            echo "" >&2
            echo "Mapping is complete (both sides known)." >&2
            echo "Unknown devices are not allowed!" >&2
            echo "" >&2
            echo "If you replaced a controller, clear mappings:" >&2
            echo "  rm $SIDE_MAPPING_FILE" >&2
            exit 1
        fi

        # Device is known - verify it matches
        if [[ "$saved_side" == "$expected_side" ]]; then
            echo "   ✅ Confirmed: $expected_side side (matches saved mapping)" >&2
            echo "$expected_side"
            return 0
        fi

    # MISMATCH! Device is known but wrong side
    echo "" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "⚠️  WARNING: SIDE MISMATCH DETECTED" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "" >&2
    echo "Expected: $expected_side side" >&2
    echo "Saved mapping says: $saved_side side" >&2
    echo "" >&2
    echo "This means either:" >&2
    echo "  1. You plugged in the WRONG keyboard half" >&2
    echo "  2. The saved mapping is incorrect" >&2
    echo "" >&2
    echo "What would you like to do?" >&2
    echo "  [e] Exit safely (recommended)" >&2
    echo "  [c] Clear this mapping and save as $expected_side" >&2
    echo "  [f] Force flash as $expected_side anyway (DANGEROUS)" >&2
    echo "" >&2

    local choice
    while true; do
        read -rp "Your choice [e/c/f]: " choice
        choice=${choice,,}

        case "$choice" in
            e)
                echo "" >&2
                echo "❌ Exiting safely. Please plug in the correct keyboard half." >&2
                exit 1
                ;;
            c)
                echo "" >&2
                echo "🔄 Clearing old mapping and saving as $expected_side side..." >&2
                save_side_mapping "$device_id" "$expected_side"
                echo "✅ Mapping updated" >&2
                echo "$expected_side"
                return 0
                ;;
            f)
                echo "" >&2
                echo "⚠️  WARNING: Flashing device as $expected_side despite mismatch!" >&2
                echo "   This could result in incorrect keyboard behavior." >&2
                read -rp "   Are you absolutely sure? [yes/no]: " confirm
                if [[ "$confirm" == "yes" ]]; then
                    # Don't update mapping, just return expected side
                    echo "   Proceeding with $expected_side..." >&2
                    echo "$expected_side"
                    return 0
                else
                    echo "   Cancelled. Exiting." >&2
                    exit 1
                fi
                ;;
            *)
                echo "Invalid choice. Please enter 'e', 'c', or 'f'." >&2
                ;;
        esac
    done
}

# ----------------------
# Function: list_all_mappings
# Display all saved device mappings
# Usage: list_all_mappings
# ----------------------
list_all_mappings() {
    check_jq_installed || return 1
    init_mapping_file

    echo "Saved Device Mappings:"
    jq '.' "$SIDE_MAPPING_FILE"
}

# ----------------------
# Function: clear_mapping
# Remove a specific device mapping
# Usage: clear_mapping "serial:ABC123"
# ----------------------
clear_mapping() {
    local device_id="$1"

    if [[ -z "$device_id" ]]; then
        echo "Error: device_id required" >&2
        return 1
    fi

    check_jq_installed || return 1
    init_mapping_file

    local tmpfile=$(mktemp)
    jq --arg id "$device_id" 'del(.[$id])' "$SIDE_MAPPING_FILE" > "$tmpfile"

    if [[ $? -eq 0 ]]; then
        mv "$tmpfile" "$SIDE_MAPPING_FILE"
        echo "✅ Removed mapping for: $device_id" >&2
        return 0
    else
        rm -f "$tmpfile"
        echo "❌ Failed to remove mapping" >&2
        return 1
    fi
}

# ----------------------
# Function: clear_all_mappings
# Remove all device mappings (reset to empty)
# Usage: clear_all_mappings
# ----------------------
clear_all_mappings() {
    echo "{}" > "$SIDE_MAPPING_FILE"
    echo "✅ Cleared all mappings" >&2
}
