#!/bin/bash

# Test robust version that handles quote issues
echo "=== Testing Robust Lock Logic ==="

# Simulating the problematic input with trailing quote
KEY="d"
KEY_OWNER_RAW="refs/pull/17/merge\""
LOCK_REASON="owner:refs/heads/12/implement-branch-deploy-736a0562a32e784cd4fe4268b971cfe216dfab62"
LOCKED="true"

echo "Original KEY_OWNER_RAW: $KEY_OWNER_RAW"

# Method 1: Strip ALL non-alphanumeric characters except forward slash, dash, underscore
KEY_OWNER=$(echo "$KEY_OWNER_RAW" | sed 's/[^a-zA-Z0-9\/\-\_\.\:]//g')
echo "Cleaned KEY_OWNER: $KEY_OWNER"

# Extract lock owner
LOCK_OWNER=$(echo "$LOCK_REASON" | grep -o 'owner:[^,]*' | cut -d: -f2 || true)
echo "Lock owner: $LOCK_OWNER"

# Compare
if [ "$LOCK_OWNER" = "$KEY_OWNER" ]; then
    echo "✓ Lock is already held by this owner"
    echo "should_proceed=true"
elif [ -z "$LOCK_OWNER" ]; then
    echo "✓ Lock is available (no owner)"
    echo "should_proceed=true"
else
    echo "✗ Lock is held by $LOCK_OWNER"
    echo "Current owner: $KEY_OWNER"
    echo "should_proceed=false"
fi

echo ""
echo "=== Alternative: Using different input formats ==="
echo "If we use github.ref_name instead of github.ref:"
REF_NAME="17/merge"
echo "PR ref_name: $REF_NAME"
echo "Would this match better with the lock owner?"