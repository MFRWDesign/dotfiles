#!/bin/bash
# Intelligent prompt enhancement hook

set -euo pipefail

# Read the hook input
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# Check if we should enhance (based on environment variable)
if [[ "${CLAUDE_AUTO_ENHANCE:-false}" != "true" ]]; then
    exit 0
fi

# Detect prompt type and add relevant context
ENHANCED_CONTEXT=""

# Code-related keywords
if echo "$PROMPT" | grep -qiE "(debug|fix|error|bug|issue|problem)"; then
    ENHANCED_CONTEXT="Note: For debugging, I'll use systematic analysis including checking logs, understanding the error context, and verifying fixes. "
fi

if echo "$PROMPT" | grep -qiE "(implement|create|build|add feature|new feature)"; then
    ENHANCED_CONTEXT="Note: I'll follow the project's existing patterns, add appropriate tests, and ensure comprehensive error handling. "
fi

if echo "$PROMPT" | grep -qiE "(optimize|performance|speed|slow|faster)"; then
    ENHANCED_CONTEXT="Note: I'll analyze performance bottlenecks, suggest evidence-based optimizations, and consider trade-offs. "
fi

if echo "$PROMPT" | grep -qiE "(refactor|clean|improve|restructure)"; then
    ENHANCED_CONTEXT="Note: I'll maintain functionality while improving code quality, following SOLID principles and project conventions. "
fi

# Add git context if in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    MODIFIED=$(git status --porcelain | wc -l | tr -d ' ')
    if [[ "$MODIFIED" -gt 0 ]]; then
        ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Git context: On branch '$BRANCH' with $MODIFIED uncommitted changes. "
    fi
fi

# Check for common project files to understand context
if [[ -f "package.json" ]]; then
    ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Project type: Node.js/TypeScript project detected. "
fi

if [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
    ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Project type: Python project detected. "
fi

# Add timestamp for context
ENHANCED_CONTEXT="${ENHANCED_CONTEXT}[Session: $(date -u +%Y-%m-%dT%H:%M:%SZ)]"

# Only output if we have enhancements
if [[ -n "$ENHANCED_CONTEXT" ]]; then
    echo "{\"metadata\": {\"enhanced\": true, \"context\": \"$ENHANCED_CONTEXT\"}}"
fi

exit 0