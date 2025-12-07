
BRANCH_NAME="dev"
COMMIT_HASH="g5dee3c55a010e9d1efb51a6c17718759e6cd7daf"
ZERV_RON=$(zerv flow \
    --bumped-branch "$BRANCH_NAME" \
    --bumped-commit-hash "$COMMIT_HASH" \
    --output-format zerv)

DISTANCE=$(($(zerv version --output-template "{{ distance }}") - 1))
echo $DISTANCE

ZERV_RON=$(echo $ZERV_RON | \
    zerv version --source stdin --distance $DISTANCE --output-format zerv)

SEMVER=$(echo $ZERV_RON | zerv version --source stdin --output-format semver)
PEP440=$(echo $ZERV_RON | zerv version --source stdin --output-format pep440)
DOCKER=$(echo $ZERV_RON | zerv version --source stdin --output-template "{{ semver_obj.docker }}")

echo $SEMVER
echo $PEP440
echo $DOCKER
