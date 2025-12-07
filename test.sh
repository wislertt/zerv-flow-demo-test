
BRANCH_NAME="dev"
COMMIT_HASH="g5dee3c55a010e9d1efb51a6c17718759e6cd7daf"
# DISTANCE="--distance $(($(zerv version --output-template "{{ distance }}") - 1))"
# DISTANCE=""
DISTANCE=$(($(zerv version --output-template "{{ distance }}")))
DISTANCE=$((DISTANCE - 1))

echo $DISTANCE

zerv flow --bumped-branch $BRANCH_NAME --bumped-commit-hash $COMMIT_HASH --distance $DISTANCE
