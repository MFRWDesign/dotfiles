#!/bin/bash
# Comprehensive security validation hook based on official docs
# Returns JSON response for allow/deny decisions

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Function to output JSON response
output_json() {
    local allow="$1"
    local reason="$2"
    jq -n \
        --arg allow "$allow" \
        --arg reason "$reason" \
        '{"allow": ($allow | test("true")), "reason": $reason}'
}

# Security checks for different tools
case "$TOOL" in
    Bash)
        COMMAND=$(echo "$PARAMS" | jq -r ".command // empty")
        
        # Check for dangerous patterns
        if echo "$COMMAND" | grep -qE "(rm -rf /|:(){:|:|&};:|dd if=/dev/zero|chmod 777)"; then
            output_json "false" "Security policy violation: dangerous command pattern detected"
            exit 0
        fi
        
        # Check for operations on sensitive files
        if echo "$COMMAND" | grep -qE "(~/.ssh/|/etc/passwd|/etc/shadow|\.env|\.git/config|\.aws/|\.kube/)"; then
            output_json "false" "Security policy violation: operation on sensitive files"
            exit 0
        fi
        
        # Check for network operations that might exfiltrate data
        if echo "$COMMAND" | grep -qE "(curl.*POST|wget.*--post|nc -l|socat)"; then
            output_json "false" "Security policy violation: potential data exfiltration"
            exit 0
        fi
        ;;
        
    "Write"|"Edit"|"MultiEdit"|"NotebookEdit")
        # Extract file path based on tool type
        if [[ "$TOOL" == "NotebookEdit" ]]; then
            FILE_PATH=$(echo "$PARAMS" | jq -r ".notebook_path // empty")
        else
            FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
        fi
        
        # Block modifications to critical system files
        if echo "$FILE_PATH" | grep -qE "^(/etc/|/usr/|/bin/|/sbin/|/boot/)"; then
            output_json "false" "Security policy violation: cannot modify system files"
            exit 0
        fi
        
        # Warn about sensitive file modifications
        if echo "$FILE_PATH" | grep -qE "(\.ssh/|\.env|config\.json|secrets\.|credentials)"; then
            output_json "true" "Warning: modifying potentially sensitive file - proceed with caution"
            exit 0
        fi
        ;;
        
    WebFetch|WebSearch)
        # Check for internal network access attempts
        URL=$(echo "$PARAMS" | jq -r ".url // .query // empty")
        if echo "$URL" | grep -qE "(localhost|127\.0\.0\.1|192\.168\.|10\.|172\.16\.)"; then
            output_json "false" "Security policy violation: internal network access not allowed"
            exit 0
        fi
        ;;
esac

# Default: allow
output_json "true" "Security check passed"
exit 0