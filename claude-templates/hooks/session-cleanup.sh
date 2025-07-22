#!/bin/bash
# Session cleanup hook - cleans up old files
# Based on official documentation patterns

set -euo pipefail

# Cleanup temporary files older than 3 days
find "$HOME/.claude/backups" -name "*.backup" -mtime +3 -delete 2>/dev/null || true

# Archive old logs (older than 30 days)
LOG_DIR="$HOME/.claude/logs"
find "$LOG_DIR" -name "*.log" -mtime +30 -exec gzip {} \; 2>/dev/null || true

# Always exit 0
exit 0