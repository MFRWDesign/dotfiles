#!/bin/bash
# Intelligent code formatting hook

set -euo pipefail

# Read the hook input
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.parameters.file_path // .parameters.new_file_path // empty')

# Skip if no file path
[ -z "$FILE_PATH" ] && exit 0

# Detect file type and format accordingly
case "$FILE_PATH" in
    *.ts|*.tsx|*.js|*.jsx)
        # TypeScript/JavaScript formatting
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null || true
        elif command -v eslint &> /dev/null; then
            eslint --fix "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.py)
        # Python formatting
        if command -v black &> /dev/null; then
            black "$FILE_PATH" 2>/dev/null || true
        elif command -v autopep8 &> /dev/null; then
            autopep8 --in-place "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.go)
        # Go formatting
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.rs)
        # Rust formatting
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.json)
        # JSON formatting
        if command -v jq &> /dev/null; then
            jq . "$FILE_PATH" > "$FILE_PATH.tmp" && mv "$FILE_PATH.tmp" "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
esac

# Always exit successfully to not block operations
exit 0