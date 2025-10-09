#!/usr/bin/env bash
# =============================================================================
# Device Detection Library
# =============================================================================
# Functions for detecting and identifying RP2040 devices in bootloader mode
# Uses HOST-side USB information (serial, port location)
# =============================================================================

# ----------------------
# Function: wait_for_rp2040
# Wait until an RP2040 UF2 device is mounted on any of the configured paths
# Returns the mount point
# Usage: mount_point=$(wait_for_rp2040)
# ----------------------
wait_for_rp2040() {
    local usb_mount_paths=("${USB_MOUNT_PATHS[@]:-/media/$USER /run/media/$USER /mnt}")
    local rp2040_pattern="${RP2040_PATTERN:-*RP2040*}"
    local wait_interval="${USB_WAIT_INTERVAL:-0.5}"

    echo "⏳ Waiting for RP2040 UF2 device..." >&2
    local device=""
    while true; do
        for path in "${usb_mount_paths[@]}"; do
            device=$(find "$path" -maxdepth 2 -type d -name "$rp2040_pattern" 2>/dev/null | head -n1)
            if [[ -n "$device" ]]; then
                echo "✅ Found RP2040 device at $device" >&2
                echo "$device"
                return 0
            fi
        done
        sleep "$wait_interval"
    done
}

# ----------------------
# Function: get_usb_serial_from_host
# Get the USB serial number from the HOST system (not from the device itself)
# This is the ONLY reliable way to identify devices when EEPROM is wiped
# Usage: serial=$(get_usb_serial_from_host "/media/user/RPI-RP2")
# ----------------------
get_usb_serial_from_host() {
    local mount_point="$1"

    if [[ -z "$mount_point" ]]; then
        echo "" >&2
        return 1
    fi

    # Method 1: Get the block device, then trace to USB serial
    local dev
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null || echo "")

    if [[ -n "$dev" ]]; then
        local block_dev=$(basename "$dev")

        # Try to find USB serial through sysfs
        local sys_path="/sys/class/block/$block_dev"

        # Walk up the device tree to find the USB device
        local current_path=$(readlink -f "$sys_path/device" 2>/dev/null || echo "")

        while [[ -n "$current_path" && "$current_path" != "/sys" ]]; do
            # Check if this directory has a serial file
            if [[ -f "$current_path/serial" ]]; then
                cat "$current_path/serial"
                return 0
            fi
            # Also check for idVendor/idProduct to confirm it's a USB device
            if [[ -f "$current_path/idVendor" ]]; then
                # Found USB device level, check for serial
                if [[ -f "$current_path/serial" ]]; then
                    cat "$current_path/serial"
                    return 0
                fi
            fi
            # Move up one level
            current_path=$(dirname "$current_path")
        done
    fi

    # Method 2: Use udevadm to get USB info
    if [[ -n "$dev" ]]; then
        local serial
        serial=$(udevadm info --query=property --name="$dev" 2>/dev/null | grep "ID_SERIAL_SHORT=" | cut -d'=' -f2)
        if [[ -n "$serial" ]]; then
            echo "$serial"
            return 0
        fi
    fi

    # No serial found
    echo ""
    return 1
}

# ----------------------
# Function: get_usb_device_path
# Get a unique identifier based on USB physical port location
# This persists even when serial is not available
# Usage: usbpath=$(get_usb_device_path "/media/user/RPI-RP2")
# ----------------------
get_usb_device_path() {
    local mount_point="$1"

    if [[ -z "$mount_point" ]]; then
        echo "" >&2
        return 1
    fi

    local dev
    dev=$(findmnt -n -o SOURCE --target "$mount_point" 2>/dev/null || echo "")

    if [[ -n "$dev" ]]; then
        # Get the physical USB path (bus and port numbers)
        local devpath
        devpath=$(udevadm info --query=property --name="$dev" 2>/dev/null | grep "DEVPATH=" | cut -d'=' -f2)
        if [[ -n "$devpath" ]]; then
            # Extract the USB bus and port info (e.g., /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0)
            local usbpath=$(echo "$devpath" | grep -oP 'usb\d+/\d+-[\d.]+')
            if [[ -n "$usbpath" ]]; then
                echo "$usbpath"
                return 0
            fi
        fi
    fi

    echo ""
    return 1
}

# ----------------------
# Function: get_device_identifier
# Get the best available identifier for the USB device
# Prefers USB serial, falls back to USB port location, then mount path
# Usage: device_id=$(get_device_identifier "/media/user/RPI-RP2")
# Returns: "serial:ABC123" or "usbpath:usb1/1-3" or "mount:RPI-RP2"
# ----------------------
get_device_identifier() {
    local mount_point="$1"

    if [[ -z "$mount_point" ]]; then
        echo "Error: mount_point required" >&2
        return 1
    fi

    # Try to get USB serial from host (PREFERRED)
    local usb_serial
    usb_serial=$(get_usb_serial_from_host "$mount_point")

    if [[ -n "$usb_serial" ]]; then
        echo "serial:$usb_serial"
        return 0
    fi

    # Try USB device path (FALLBACK 1)
    local usb_path
    usb_path=$(get_usb_device_path "$mount_point")
    if [[ -n "$usb_path" ]]; then
        echo "usbpath:$usb_path"
        return 0
    fi

    # Final fallback: use mount point basename (FALLBACK 2)
    echo "mount:$(basename "$mount_point")"
    return 0
}

# ----------------------
# Function: print_device_info
# Print detailed information about a detected device (for debugging)
# Usage: print_device_info "/media/user/RPI-RP2"
# ----------------------
print_device_info() {
    local mount_point="$1"

    echo "Device Information:"
    echo "  Mount Point: $mount_point"

    local serial=$(get_usb_serial_from_host "$mount_point")
    echo "  USB Serial: ${serial:-[not available]}"

    local usbpath=$(get_usb_device_path "$mount_point")
    echo "  USB Path: ${usbpath:-[not available]}"

    local device_id=$(get_device_identifier "$mount_point")
    echo "  Identifier: $device_id"
}
