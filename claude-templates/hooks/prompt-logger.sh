#!/bin/bash
# Simple prompt logging based on official documentation
# No categorization or analytics

set -euo pipefail

# Read hook input
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r ".prompt // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create log directory if it does not exist
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

# Simple prompt logging as shown in docs
echo "Processing prompt: $PROMPT" >> "$LOG_DIR/audit.log"

# Always exit 0 to continue processing
exit 0