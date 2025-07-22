#!/bin/bash
# Create backups before file modifications - handles all file tools
# Based on official Claude Code documentation

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract tool and parameters
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Handle all file modification tools
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit|NotebookEdit)$ ]]; then
    # Extract file paths based on tool type
    case "$TOOL" in
        Write|Edit)
            FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
            ;;
        MultiEdit)
            FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
            ;;
        NotebookEdit)
            FILE_PATH=$(echo "$PARAMS" | jq -r ".notebook_path // empty")
            ;;
    esac
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Create backup directory with date
        BACKUP_DIR="$HOME/.claude/backups/$(date +%Y%m%d)"
        mkdir -p "$BACKUP_DIR"
        
        # Create timestamped backup
        BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup"
        cp "$FILE_PATH" "$BACKUP_FILE" 2>/dev/null || true
        
        # Log backup creation
        echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backed up $FILE_PATH to $BACKUP_FILE" >&2
    fi
fi

# Always exit 0 to continue processing
exit 0