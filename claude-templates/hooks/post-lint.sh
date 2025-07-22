#!/bin/bash
# Auto-format code after modifications - supports many languages
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Only process file write/edit operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit|NotebookEdit)$ ]]; then
    # Extract file path based on tool
    case "$TOOL" in
        "Write"|"Edit"|"MultiEdit")
            FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
            ;;
        "NotebookEdit")
            FILE_PATH=$(echo "$PARAMS" | jq -r ".notebook_path // empty")
            ;;
    esac
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Determine file type and apply appropriate formatting
        case "$FILE_PATH" in
            *.js|*.jsx|*.ts|*.tsx|*.json|*.md|*.css|*.scss|*.html|*.vue)
                # JavaScript/TypeScript/Web files
                if command -v prettier &> /dev/null; then
                    prettier --write "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.py|*.pyi)
                # Python
                if command -v black &> /dev/null; then
                    black "$FILE_PATH" 2>/dev/null || true
                elif command -v autopep8 &> /dev/null; then
                    autopep8 --in-place "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.go)
                # Go
                if command -v gofmt &> /dev/null; then
                    gofmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rs)
                # Rust
                if command -v rustfmt &> /dev/null; then
                    rustfmt "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rb)
                # Ruby
                if command -v rubocop &> /dev/null; then
                    rubocop -a "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.java)
                # Java
                if command -v google-java-format &> /dev/null; then
                    google-java-format -i "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.c|*.cpp|*.cc|*.h|*.hpp)
                # C/C++
                if command -v clang-format &> /dev/null; then
                    clang-format -i "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.sh|*.bash)
                # Shell scripts
                if command -v shfmt &> /dev/null; then
                    shfmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
        esac
    fi
fi

exit 0