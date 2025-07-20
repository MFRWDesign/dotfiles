#!/bin/bash
# Advanced command validation hook

set -euo pipefail

# Read the hook input
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.parameters.command // empty')

# Security checks
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "dd if=/dev/random"
    "fork bomb"
    ":(){ :|:& };:"
    "> /dev/sda"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if [[ "$COMMAND" == *"$pattern"* ]]; then
        echo '{"allow": false, "reason": "Potentially dangerous command detected"}'
        exit 0
    fi
done

# Best practice suggestions
if [[ "$COMMAND" == *"git commit -m"* ]] && [[ ! "$COMMAND" == *"git commit -m"*$'\n'* ]]; then
    echo '{"allow": true, "suggestion": "Consider using multi-line commit messages for better clarity"}'
    exit 0
fi

# Check for common mistakes
if [[ "$COMMAND" == "cd "* ]] && [[ ! "$COMMAND" == *"&&"* ]] && [[ ! "$COMMAND" == *";"* ]]; then
    echo '{"allow": true, "warning": "cd command without follow-up - working directory will be lost"}'
    exit 0
fi

# Allow with enhanced logging
echo "{\"allow\": true, \"metadata\": {\"validated\": true, \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}}"