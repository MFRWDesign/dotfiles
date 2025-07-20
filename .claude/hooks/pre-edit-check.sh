#!/bin/bash
# Pre-edit validation and backup hook

set -euo pipefail

# Read the hook input
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.parameters.file_path // .parameters.path // empty')

# Skip if no file path
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Check if file exists for edit operations
if [[ "$INPUT" == *'"tool":"Edit"'* ]] || [[ "$INPUT" == *'"tool":"MultiEdit"'* ]]; then
    if [ ! -f "$FILE_PATH" ]; then
        echo '{"allow": false, "reason": "File does not exist. Use Write tool for new files."}'
        exit 0
    fi
fi

# Create backup directory
BACKUP_DIR="$HOME/.claude/backups/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Create backup if file exists
if [ -f "$FILE_PATH" ]; then
    BACKUP_NAME="$(basename "$FILE_PATH").$(date +%H%M%S).bak"
    cp "$FILE_PATH" "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || true
fi

# Check for sensitive files
SENSITIVE_PATTERNS=(
    ".env"
    ".env.local"
    "secrets"
    "credentials"
    "private.key"
    "id_rsa"
)

BASENAME=$(basename "$FILE_PATH")
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if [[ "$BASENAME" == *"$pattern"* ]]; then
        echo '{"allow": true, "warning": "Editing sensitive file. Please review changes carefully."}'
        exit 0
    fi
done

# Check file permissions
if [ -f "$FILE_PATH" ] && [ ! -w "$FILE_PATH" ]; then
    echo '{"allow": false, "reason": "File is not writable. Check permissions."}'
    exit 0
fi

# Check for binary files
if [ -f "$FILE_PATH" ]; then
    if file "$FILE_PATH" | grep -q "binary"; then
        echo '{"allow": false, "reason": "Cannot edit binary files."}'
        exit 0
    fi
fi

# All checks passed
echo '{"allow": true, "metadata": {"backup_created": true, "backup_dir": "'"$BACKUP_DIR"'"}}'