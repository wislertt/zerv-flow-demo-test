#!/bin/bash

set -e

echo "=== Testing zerv-versioning workflow locally ==="
echo ""

# Simulate the workflow variables exactly
BRANCH_NAME="${{ github.ref_name }}"
COMMIT_HASH="${{ github.sha }}"

# Simulate the workflow inputs
OVERRIDDEN_TAG_VERSION="${{ inputs.overridden_tag_version }}"
SCHEMA="${{ inputs.schema }}"
BRANCH_RULES="${{ inputs.branch_rules }}"

echo "=== Workflow variables ==="
echo "BRANCH_NAME: $BRANCH_NAME"
echo "COMMIT_HASH: $COMMIT_HASH"
echo ""
echo "=== Workflow inputs ==="
echo "OVERRIDDEN_TAG_VERSION: ${OVERRIDDEN_TAG_VERSION:-<empty>}"
echo "SCHEMA: ${SCHEMA:-<empty>}"
echo "BRANCH_RULES: ${BRANCH_RULES:-<empty>}"
echo ""

# Simulate the exact workflow logic
if [ -n "$OVERRIDDEN_TAG_VERSION" ]; then
    OVERRIDDEN_TAG_VERSION_FLAG="--tag-version $OVERRIDDEN_TAG_VERSION"
fi

if [ -n "$SCHEMA" ]; then
    SCHEMA_FLAG="--schema $SCHEMA"
fi

if [ -n "$BRANCH_RULES" ]; then
    BRANCH_RULES_FLAG="--branch-rules $BRANCH_RULES"
fi

echo "=== Generated flags ==="
echo "OVERRIDDEN_TAG_VERSION_FLAG: ${OVERRIDDEN_TAG_VERSION_FLAG:-<empty>}"
echo "SCHEMA_FLAG: ${SCHEMA_FLAG:-<empty>}"
echo "BRANCH_RULES_FLAG: ${BRANCH_RULES_FLAG:-<empty>}"
echo ""

echo "=== Command that will be executed ==="
echo "zerv flow \\"
echo "    --bumped-branch \"$BRANCH_NAME\" \\"
echo "    --bumped-commit-hash \"g$COMMIT_HASH\" \\"
echo "    ${OVERRIDDEN_TAG_VERSION_FLAG:-} \\"
echo "    ${SCHEMA_FLAG:-} \\"
echo "    ${BRANCH_RULES_FLAG:-} \\"
echo "    --output-format zerv"
echo ""

ZERV_RON=$(zerv flow \
    --bumped-branch "$BRANCH_NAME" \
    --bumped-commit-hash "g$COMMIT_HASH" \
    $OVERRIDDEN_TAG_VERSION_FLAG \
    $SCHEMA_FLAG \
    $BRANCH_RULES_FLAG \
    --output-format zerv)

echo "$ZERV_RON"