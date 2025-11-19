#!/usr/bin/env bash

# Script to update xcase module
# Note: Danish character support is now handled via add_exclusion_keycode() API
# in keyboard_post_init_user() - no patching required!
# Usage: ./update-xcase-with-patch.sh

XCASE_DIR="/home/smathev/git_dev/keyboards/qmk_userspace/modules/ohshitgorillas/xcase"

echo "🔄 Updating xcase module..."
cd "$XCASE_DIR" || exit 1

# Check if there are local changes
if git diff --quiet && git diff --cached --quiet; then
    echo "✓ No local changes detected"
else
    echo "⚠️  Local changes detected - please commit or stash them first"
    exit 1
fi

# Pull latest updates
echo "📥 Pulling latest xcase updates..."
git pull origin main

# Return to original directory
cd - > /dev/null || exit 1

echo "✅ Done! Danish characters are supported via add_exclusion_keycode() in keymap.c"
echo "   No patching required - the upstream xcase now has proper API support."

