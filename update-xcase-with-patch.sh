#!/usr/bin/env fish

# Script to update xcase module and reapply Danish letter patch
# Usage: ./update-xcase-with-patch.sh

set XCASE_DIR "/home/smathev/git_dev/keyboards/qmk_userspace/modules/ohshitgorillas/xcase"
set PATCH_FILE "$HOME/xcase-danish-letters.patch"

echo "🔄 Updating xcase module..."
cd $XCASE_DIR

# Check if there are local changes
if git diff --quiet
    echo "✓ No local changes detected"
else
    echo "⚠️  Local changes detected, creating/updating patch file..."
    git diff > $PATCH_FILE
    echo "✓ Patch saved to $PATCH_FILE"
end

# Stash any changes
git stash

# Pull latest updates
echo "📥 Pulling latest xcase updates..."
git pull origin main

# Apply the patch
if test -f $PATCH_FILE
    echo "🩹 Applying Danish letter patch..."
    if git apply --check $PATCH_FILE 2>/dev/null
        git apply $PATCH_FILE
        echo "✓ Patch applied successfully!"
    else
        echo "❌ Patch failed to apply cleanly"
        echo "Trying 3-way merge..."
        if git apply --3way $PATCH_FILE
            echo "✓ Patch applied with 3-way merge"
        else
            echo "⚠️  Manual intervention required"
            echo "Please check $XCASE_DIR/xcase.c for conflicts"
        end
    end
else
    echo "⚠️  No patch file found at $PATCH_FILE"
    echo "Your changes may have been stashed. Use 'git stash pop' to restore them."
end

# Return to original directory
cd -

echo "✅ Done! Compile and test your firmware."
