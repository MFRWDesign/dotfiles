#!/bin/bash
# Simple tool usage logging based on official documentation
# No analytics or metrics collection

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create log directory if it does not exist
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

# Simple logging as shown in docs
echo "[$TIMESTAMP] Tool: $TOOL, User: $USER" >> "$LOG_DIR/audit.log"

# Always exit 0 to continue processing
exit 0