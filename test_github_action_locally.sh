#!/bin/bash

set -e

echo "=== Testing GitHub Action workflow locally ==="
echo ""

# Set the same variables as in GitHub Actions
BRANCH_NAME="release/15/dev"
COMMIT_HASH="6e96ae6da25c70942cf4a785d24de01b87dd17f1"

echo "BRANCH_NAME=$BRANCH_NAME"
echo "COMMIT_HASH=$COMMIT_HASH"
echo ""

# Simulate the workflow logic
if [ -n "" ]; then
    OVERRIDDEN_TAG_VERSION_FLAG="--tag-version "
fi

if [ -n "" ]; then
    SCHEMA_FLAG="--schema "
fi

# This is the problematic part - the multiline string expansion
BRANCH_RULES='[
    (
        pattern: "develop",
        pre_release_label: beta,
        pre_release_num: Some(1),
        post_mode: commit
    ),
    (
        pattern: "release/*",
        pre_release_label: rc,
        pre_release_num: None,
        post_mode: tag
    ),
    (
        pattern: "*",
        pre_release_label: alpha,
        pre_release_num: None,
        post_mode: commit
    )
]'

echo "=== Branch Rules (multiline) ==="
echo "$BRANCH_RULES"
echo ""

if [ -n "$BRANCH_RULES" ]; then
    BRANCH_RULES_FLAG="--branch-rules '$BRANCH_RULES'"
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

echo "=== Executing zerv flow ==="
# Build the full command as a string
ZERV_CMD="zerv flow \
    --bumped-branch \"$BRANCH_NAME\" \
    --bumped-commit-hash \"g$COMMIT_HASH\" \
    $OVERRIDDEN_TAG_VERSION_FLAG \
    $SCHEMA_FLAG \
    $BRANCH_RULES_FLAG \
    --output-format zerv"

# Execute with eval to handle the quoting properly
ZERV_RON=$(eval "$ZERV_CMD")

echo "$ZERV_RON"