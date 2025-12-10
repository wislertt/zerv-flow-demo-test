# Plan: Generalize Zerv-Versioning Workflow Output

## Overview

Generalize the zerv-versioning workflow to support flexible, user-defined output formats and templates through JSON configuration inputs.

## Current State

- Fixed outputs: `semver`, `pep440`, `docker_tag`
- Hard-coded output formats and templates in the workflow
- Limited extensibility for new version formats

## Proposed Changes

### 1. New Workflow Inputs

Add the following new inputs to `zerv-versioning.yml`:

```yaml
inputs:
    # Existing inputs...
    output_formats:
        type: string
        description: "JSON object mapping output names to zerv output formats"
        default: '{"semver": "semver", "pep440": "pep440"}'

    output_templates:
        type: string
        description: "JSON object mapping output names to zerv output templates"
        default: '{"docker_tag": "{{ semver_obj.docker }}"}'

    custom_outputs:
        type: string
        description: "JSON object mapping output names to full zerv command arguments"
        default: '{"v_semver": "--output-prefix v --output-format semver"}'
```

### 2. Dynamic Output Generation

#### Step: Generate Versions

Replace the fixed version generation with a dynamic approach:

```bash
# Parse JSON inputs
OUTPUT_FORMATS='${{ inputs.output_formats }}'
OUTPUT_TEMPLATES='${{ inputs.output_templates }}'
CUSTOM_OUTPUTS='${{ inputs.custom_outputs }}'

# Generate base ZERV_RON once
ZERV_RON=$(zerv flow \
    --bumped-branch "$BRANCH_NAME" \
    --bumped-commit-hash "g$COMMIT_HASH" \
    $OVERRIDDEN_TAG_VERSION_FLAG \
    $SCHEMA_FLAG \
    --branch-rules "$BRANCH_RULES" \
    --output-format zerv)

# Create JSON object to store all versions
VERSIONS_JSON="{}"

# Function to add version to JSON
add_version() {
    local key=$1
    local value=$2
    VERSIONS_JSON=$(echo "$VERSIONS_JSON" | jq --arg key "$key" --arg value "$value" '. + {($key): $value}')
}

# Process output_formats
echo "$OUTPUT_FORMATS" | jq -r 'to_entries[] | @base64' | while read -r entry; do
    _jq() {
        echo ${entry} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.key')
    format=$(_jq '.value')
    value=$(echo "$ZERV_RON" | zerv version --source stdin --output-format "$format")
    VERSIONS_JSON=$(echo "$VERSIONS_JSON" | jq --arg key "$key" --arg value "$value" '. + {($key): $value}')
done

# Process output_templates
echo "$OUTPUT_TEMPLATES" | jq -r 'to_entries[] | @base64' | while read -r entry; do
    _jq() {
        echo ${entry} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.key')
    template=$(_jq '.value')
    value=$(echo "$ZERV_RON" | zerv version --source stdin --output-template "$template")
    VERSIONS_JSON=$(echo "$VERSIONS_JSON" | jq --arg key "$key" --arg value "$value" '. + {($key): $value}')
done

# Process custom_outputs
echo "$CUSTOM_OUTPUTS" | jq -r 'to_entries[] | @base64' | while read -r entry; do
    _jq() {
        echo ${entry} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.key')
    args=$(_jq '.value')
    value=$(echo "$ZERV_RON" | zerv version --source stdin $args)
    VERSIONS_JSON=$(echo "$VERSIONS_JSON" | jq --arg key "$key" --arg value "$value" '. + {($key): $value}')
done

# Output the final JSON
echo "all_versions=$VERSIONS_JSON" >> $GITHUB_OUTPUT
```

### 3. Dynamic Workflow Outputs

Since GitHub Actions doesn't support dynamic outputs, we'll use a single JSON output containing all generated versions:

```yaml
outputs:
    all_versions:
        description: "JSON object containing all generated versions"
        value: ${{ jobs.zerv-versioning.outputs.all_versions }}
```

### 4. Implementation Steps

1. **Backup current workflow** - Save existing zerv-versioning.yml
2. **Add new inputs** - Introduce JSON configuration inputs
3. **Implement dynamic generation** - Replace hard-coded version generation
4. **Update outputs** - Modify output definitions
5. **Add jq dependency** - Ensure jq is available
6. **Test configurations** - Create test cases for various input configurations
7. **Update documentation** - Document new input format and examples

### 5. Example Usage

#### Standard Usage:

```yaml
- uses: ./.github/workflows/zerv-versioning.yml
  with:
      output_formats: |
          {
            "version": "semver",
            "python_version": "pep440",
            "npm_version": "npm"
          }
      output_templates: |
          {
            "docker": "{{ semver_obj.docker }}",
            "full_version": "v{{ semver_obj.full }}"
          }
      custom_outputs: |
          {
            "v_semver": "--output-prefix v --output-format semver",
            "build_info": "--output-template \"{{ semver_obj.full }}+{{ build_number }}\""
          }
```

### 6. Error Handling

- Validate JSON inputs using jq
- Provide clear error messages for malformed JSON
- Handle missing or invalid zerv commands gracefully
- Add debugging output for troubleshooting

### 7. Testing Strategy

- Test with various JSON configurations
- Test error cases (invalid JSON, missing commands)
- Test with different branch patterns and version scenarios
- Verify JSON output structure and content

### 8. Documentation Updates

- Update README with new input formats
- Provide example configurations
- Document JSON output structure
- Add troubleshooting section

### 9. Future Enhancements

- Support for output validation
- Conditional output generation based on branch
- Integration with artifact naming
- Support for custom version scripts
