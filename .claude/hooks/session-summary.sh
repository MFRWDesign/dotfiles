#!/bin/bash
# Session summary generation hook

set -euo pipefail

# Read the hook input
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session.id // empty')
WORKING_DIR=$(echo "$INPUT" | jq -r '.session.workingDirectory // empty')

# Create session summary directory
SUMMARY_DIR="$HOME/.claude/session-summaries"
mkdir -p "$SUMMARY_DIR"

# Generate summary filename with timestamp
TIMESTAMP=$(date -u +%Y%m%d_%H%M%S)
SUMMARY_FILE="$SUMMARY_DIR/session_${SESSION_ID}_${TIMESTAMP}.md"

# Create session summary
cat > "$SUMMARY_FILE" << EOF
# Claude Session Summary

- **Session ID**: $SESSION_ID
- **Date**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
- **Working Directory**: $WORKING_DIR

## Session Statistics
- Tools used: $(echo "$INPUT" | jq -r '.stats.toolsUsed // 0')
- Files modified: $(echo "$INPUT" | jq -r '.stats.filesModified // 0')
- Commands executed: $(echo "$INPUT" | jq -r '.stats.commandsExecuted // 0')

## Key Activities
$(echo "$INPUT" | jq -r '.activities[]? // "- Session activities not tracked"' 2>/dev/null || echo "- Session activities not tracked")

---
*Generated automatically by Claude Expert System*
EOF

# Also create a latest symlink
ln -sf "$SUMMARY_FILE" "$SUMMARY_DIR/latest.md"

# Log session end
echo "Session $SESSION_ID completed at $(date)" >> "$HOME/.claude/session.log"

exit 0