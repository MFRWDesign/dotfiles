#!/bin/bash
# PreCompact hook - prepares for session data compaction
# Based on official Claude Code documentation - no metrics

set -euo pipefail

# Read hook input
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r ".session.id // empty")
SESSION_SIZE=$(echo "$INPUT" | jq -r ".session.size // 0")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log directory
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

# Log compaction event
COMPACT_LOG="$LOG_DIR/compaction.log"
echo "[$TIMESTAMP] PreCompact: Session $SESSION_ID (size: $SESSION_SIZE bytes)" >> "$COMPACT_LOG"

# Create backup of current session state
BACKUP_DIR="$HOME/.claude/backups/sessions"
mkdir -p "$BACKUP_DIR"

# Archive important session data before compaction
SESSION_BACKUP="$BACKUP_DIR/session_${SESSION_ID}_$(date +%Y%m%d_%H%M%S).json"
echo "$INPUT" | jq ". + {timestamp: \"$TIMESTAMP\", event: \"pre_compact\"}" > "$SESSION_BACKUP"

# Clean up old session backups (keep last 10)
find "$BACKUP_DIR" -name "session_*.json" -type f | sort -r | tail -n +11 | xargs -r rm -f

# Notify about large sessions
if [[ $SESSION_SIZE -gt 1048576 ]]; then  # 1MB
    SIZE_MB=$((SESSION_SIZE / 1048576))
    echo "Warning: Large session detected - ${SIZE_MB}MB will be compacted" >&2
fi

# Always exit 0 to allow compaction to proceed
exit 0