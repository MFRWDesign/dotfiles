#!/bin/bash
# SubagentStop hook - tracks when autonomous agents complete their tasks
# Based on official Claude Code documentation - no metrics

set -euo pipefail

# Read hook input
INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r ".agent.id // empty")
AGENT_TYPE=$(echo "$INPUT" | jq -r ".agent.type // empty")
COMPLETION_STATUS=$(echo "$INPUT" | jq -r ".status // \"completed\"")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log directory
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

# Simple agent completion logging
AGENT_LOG="$LOG_DIR/agents.log"
echo "[$TIMESTAMP] SubagentStop: Agent $AGENT_ID ($AGENT_TYPE) - Status: $COMPLETION_STATUS" >> "$AGENT_LOG"

# Clean up any temporary agent files
AGENT_TEMP_DIR="$LOG_DIR/.agent_$AGENT_ID"
if [[ -d "$AGENT_TEMP_DIR" ]]; then
    rm -rf "$AGENT_TEMP_DIR"
fi

# Always exit 0 to continue processing
exit 0