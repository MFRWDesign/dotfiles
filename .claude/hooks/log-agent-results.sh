#!/bin/bash
# Log multi-agent task results for analysis

set -euo pipefail

# Read the hook input
INPUT=$(cat)
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // empty')
AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // "unknown"')

# Create agent logs directory
LOG_DIR="$HOME/.claude/agent-logs"
mkdir -p "$LOG_DIR"

# Create daily log file
LOG_FILE="$LOG_DIR/agents_$(date +%Y%m%d).log"

# Extract relevant information
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S")
DESCRIPTION=$(echo "$INPUT" | jq -r '.parameters.description // "No description"')
PROMPT=$(echo "$INPUT" | jq -r '.parameters.prompt // empty' | head -c 200)

# Log the agent execution
cat >> "$LOG_FILE" << EOF
[$TIMESTAMP] Agent: $AGENT_NAME (Task: $TASK_ID)
Description: $DESCRIPTION
Prompt excerpt: $PROMPT...
---
EOF

# Track agent performance metrics
METRICS_FILE="$LOG_DIR/metrics.json"
if [ ! -f "$METRICS_FILE" ]; then
    echo '{"agents": {}, "total_tasks": 0}' > "$METRICS_FILE"
fi

# Update metrics (using jq for JSON manipulation)
if command -v jq &> /dev/null; then
    # Increment agent usage count
    jq --arg agent "$AGENT_NAME" '
        .agents[$agent] = ((.agents[$agent] // 0) + 1) |
        .total_tasks = .total_tasks + 1
    ' "$METRICS_FILE" > "$METRICS_FILE.tmp" && mv "$METRICS_FILE.tmp" "$METRICS_FILE"
fi

# Always allow the task to proceed
exit 0