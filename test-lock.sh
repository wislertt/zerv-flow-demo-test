#!/bin/bash

# Simulating the exact scenario from GitHub Actions
echo "=== Test Script for Lock Logic ==="

# Simulating inputs
KEY="d"
KEY_OWNER="refs/pull/17/merge"  # This is what github.ref provides
LOCK_REASON="owner:refs/heads/12/implement-branch-deploy-736a0562a32e784cd4fe4268b971cfe216dfab62"
LOCKED="true"

echo "Key: $KEY"
echo "Key owner: $KEY_OWNER"
echo "Lock reason: $LOCK_REASON"
echo "Locked: $LOCKED"

if [ "$LOCKED" = "true" ]; then
    echo "Lock exists, checking owner..."
    LOCK_OWNER=$(echo "$LOCK_REASON" | grep -o 'owner:[^,]*' | cut -d: -f2 || true)

    echo "Lock owner: $LOCK_OWNER"
    echo "Current owner: $KEY_OWNER"

    # Strip any surrounding quotes
    KEY_OWNER=$(echo "$KEY_OWNER" | sed 's/^"//;s/"$//')
    LOCK_OWNER=$(echo "$LOCK_OWNER" | sed 's/^"//;s/"$//')

    echo "After quote stripping:"
    echo "Lock owner: $LOCK_OWNER"
    echo "Current owner: $KEY_OWNER"

    if [ "$LOCK_OWNER" = "$KEY_OWNER" ]; then
        echo "✓ Lock is already held by this owner"
        echo "should_proceed=true"
    elif [ -z "$LOCK_OWNER" ]; then
        echo "✓ Lock is available (no owner)"
        echo "should_proceed=true"
    else
        echo "✗ Lock is held by $LOCK_OWNER"
        echo "should_proceed=false"
        echo "Error: Key '$KEY' is locked by $LOCK_OWNER"
        exit 1
    fi
else
    echo "✓ Key is not locked"
    echo "should_proceed=true"
fi

echo ""
echo ""
echo "=== Test 2: When lock is not locked ==="
LOCKED="false"
if [ "$LOCKED" = "true" ]; then
    echo "Lock exists, checking owner..."
else
    echo "✓ Key is not locked"
    echo "should_proceed=true"
fi

echo ""
echo "=== Test 3: Simulating the syntax error case ==="
# Test with trailing quote that might be causing the issue
KEY_OWNER_TRAILING="refs/pull/17/merge\""
echo "Testing with trailing quote: $KEY_OWNER_TRAILING"

# Try to detect and fix trailing quotes
if [[ "$KEY_OWNER_TRAILING" == *"\"" ]]; then
    echo "Found trailing quote, fixing..."
    KEY_OWNER_TRAILING=$(echo "$KEY_OWNER_TRAILING" | sed 's/"$//')
    echo "Fixed: $KEY_OWNER_TRAILING"
fi