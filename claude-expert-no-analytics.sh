#!/bin/bash
# Claude Expert Setup - No Analytics Edition
# Creates comprehensive Claude Code expert configuration with ALL features except analytics/metrics
# Based on claude-expert-enhanced.sh but with analytics/metrics removed

set -euo pipefail

# Script version
VERSION="2.0.0-no-analytics"

echo "🚀 Claude Expert Setup - No Analytics Edition (v$VERSION)"
echo "========================================================="
echo "Setting up comprehensive Claude Code expert configuration"
echo "with ALL features except analytics/metrics"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directories
CLAUDE_HOME="${HOME}/.claude"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine absolute path style for the system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    HOME_ABSOLUTE="$HOME"
else
    # Linux/Unix
    HOME_ABSOLUTE="$HOME"
fi

# Function to handle file conflicts
handle_file_conflict() {
    local target_file="$1"
    local new_content="$2"
    local file_description="$3"
    
    if [[ -f "$target_file" ]]; then
        echo -e "\n${YELLOW}⚠ File already exists: $target_file${NC}"
        
        # Show diff if possible
        if command -v diff &> /dev/null; then
            echo -e "\n${YELLOW}Differences:${NC}"
            echo "$new_content" | diff -u "$target_file" - || true
        fi
        
        echo -e "\nWhat would you like to do with $file_description?"
        echo "1) Skip (keep existing file)"
        echo "2) Overwrite with new version"
        echo "3) Create backup and overwrite"
        echo "4) View existing file first"
        
        while true; do
            read -p "Choose [1-4]: " choice
            case $choice in
                1)
                    echo -e "${BLUE}↷ Keeping existing file${NC}"
                    return 1
                    ;;
                2)
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Overwritten with new version${NC}"
                    return 0
                    ;;
                3)
                    local backup="${target_file}.backup-$(date +%Y%m%d-%H%M%S)"
                    cp "$target_file" "$backup"
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Backed up to $backup and overwritten${NC}"
                    return 0
                    ;;
                4)
                    echo -e "\n${YELLOW}=== Current file content ===${NC}"
                    cat "$target_file"
                    echo -e "${YELLOW}=== End of file ===${NC}\n"
                    continue
                    ;;
                *)
                    echo "Invalid choice. Please choose 1-4."
                    ;;
            esac
        done
    else
        echo "$new_content" > "$target_file"
        echo -e "${GREEN}✓ Created $file_description${NC}"
        return 0
    fi
}

# Function to ensure jq is installed
ensure_jq() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}❌ jq is required but not installed.${NC}"
        echo "Please install jq and run this script again."
        echo ""
        echo "Installation options:"
        echo "  macOS:    brew install jq"
        echo "  Ubuntu:   sudo apt-get install jq"
        echo "  Other:    https://stedolan.github.io/jq/download/"
        exit 1
    fi
}

# Create directory structure
echo -e "\n${YELLOW}Creating comprehensive directory structure...${NC}"
directories=(
    "$CLAUDE_HOME"
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/commands"
    "$CLAUDE_HOME/commands/common"
    "$CLAUDE_HOME/commands/development"
    "$CLAUDE_HOME/commands/analysis"
    "$CLAUDE_HOME/commands/creative"
    "$CLAUDE_HOME/commands/productivity"
    "$CLAUDE_HOME/commands/research"
    "$CLAUDE_HOME/backups"
    "$CLAUDE_HOME/scripts"
    "$CLAUDE_HOME/logs"
    "$CLAUDE_HOME/templates"
    "$CLAUDE_HOME/memory"
    "$CLAUDE_HOME/workflows"
    "$CLAUDE_HOME/ide-integration"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Step 1: Create Comprehensive Hooks (without analytics)
echo -e "\n${YELLOW}Step 1: Creating Comprehensive Hooks (No Analytics)...${NC}"

# Pre-backup hook for all file modification tools
PRE_BACKUP_HOOK='#!/bin/bash
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
        BACKUP_DIR="'"$HOME_ABSOLUTE"'/.claude/backups/$(date +%Y%m%d)"
        mkdir -p "$BACKUP_DIR"
        
        # Create timestamped backup
        BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup"
        cp "$FILE_PATH" "$BACKUP_FILE" 2>/dev/null || true
        
        # Log backup creation
        echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backed up $FILE_PATH to $BACKUP_FILE" >&2
    fi
fi

# Always exit 0 to continue processing
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/pre-backup.sh" "$PRE_BACKUP_HOOK" "comprehensive pre-backup hook"
chmod +x "$CLAUDE_HOME/hooks/pre-backup.sh" 2>/dev/null || true

# Enhanced post-lint hook with more language support
POST_LINT_HOOK='#!/bin/bash
# Auto-format code after modifications - supports many languages
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Only process file write/edit operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit|NotebookEdit)$ ]]; then
    # Extract file path based on tool
    case "$TOOL" in
        Write|Edit|MultiEdit)
            FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
            ;;
        NotebookEdit)
            FILE_PATH=$(echo "$PARAMS" | jq -r ".notebook_path // empty")
            ;;
    esac
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Determine file type and apply appropriate formatting
        case "$FILE_PATH" in
            *.js|*.jsx|*.ts|*.tsx|*.json|*.md|*.css|*.scss|*.html|*.vue)
                # JavaScript/TypeScript/Web files
                if command -v prettier &> /dev/null; then
                    prettier --write "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.py|*.pyi)
                # Python
                if command -v black &> /dev/null; then
                    black "$FILE_PATH" 2>/dev/null || true
                elif command -v autopep8 &> /dev/null; then
                    autopep8 --in-place "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.go)
                # Go
                if command -v gofmt &> /dev/null; then
                    gofmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rs)
                # Rust
                if command -v rustfmt &> /dev/null; then
                    rustfmt "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rb)
                # Ruby
                if command -v rubocop &> /dev/null; then
                    rubocop -a "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.java)
                # Java
                if command -v google-java-format &> /dev/null; then
                    google-java-format -i "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.c|*.cpp|*.cc|*.h|*.hpp)
                # C/C++
                if command -v clang-format &> /dev/null; then
                    clang-format -i "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.sh|*.bash)
                # Shell scripts
                if command -v shfmt &> /dev/null; then
                    shfmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
        esac
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/post-lint.sh" "$POST_LINT_HOOK" "enhanced post-lint hook"
chmod +x "$CLAUDE_HOME/hooks/post-lint.sh" 2>/dev/null || true

# Comprehensive security validation hook
SECURITY_HOOK='#!/bin/bash
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
        "{allow: (\$allow | test(\"true\")), reason: \$reason}"
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
        
    Write|Edit|MultiEdit|NotebookEdit)
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
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/security-check.sh" "$SECURITY_HOOK" "comprehensive security check hook"
chmod +x "$CLAUDE_HOME/hooks/security-check.sh" 2>/dev/null || true

# Simple tool usage logging hook (no analytics/metrics)
TOOL_USAGE_HOOK='#!/bin/bash
# Simple tool usage logging based on official documentation
# No analytics or metrics collection

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create log directory if it does not exist
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
mkdir -p "$LOG_DIR"

# Simple logging as shown in docs
echo "[$TIMESTAMP] Tool: $TOOL, User: $USER" >> "$LOG_DIR/audit.log"

# Always exit 0 to continue processing
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/tool-usage.sh" "$TOOL_USAGE_HOOK" "simple tool usage logging hook"
chmod +x "$CLAUDE_HOME/hooks/tool-usage.sh" 2>/dev/null || true

# Simple user prompt logging hook (no analytics)
PROMPT_LOGGER_HOOK='#!/bin/bash
# Simple prompt logging based on official documentation
# No categorization or analytics

set -euo pipefail

# Read hook input
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r ".prompt // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create log directory if it does not exist
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
mkdir -p "$LOG_DIR"

# Simple prompt logging as shown in docs
echo "Processing prompt: $PROMPT" >> "$LOG_DIR/audit.log"

# Always exit 0 to continue processing
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/prompt-logger.sh" "$PROMPT_LOGGER_HOOK" "simple prompt logger hook"
chmod +x "$CLAUDE_HOME/hooks/prompt-logger.sh" 2>/dev/null || true

# Session cleanup hook (no metrics)
SESSION_CLEANUP_HOOK='#!/bin/bash
# Session cleanup hook - cleans up old files
# Based on official documentation patterns

set -euo pipefail

# Cleanup temporary files older than 3 days
find "'"$HOME_ABSOLUTE"'/.claude/backups" -name "*.backup" -mtime +3 -delete 2>/dev/null || true

# Archive old logs (older than 30 days)
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
find "$LOG_DIR" -name "*.log" -mtime +30 -exec gzip {} \; 2>/dev/null || true

# Always exit 0
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/session-cleanup.sh" "$SESSION_CLEANUP_HOOK" "session cleanup hook"
chmod +x "$CLAUDE_HOME/hooks/session-cleanup.sh" 2>/dev/null || true

# SubagentStop hook (no metrics)
SUBAGENT_STOP_HOOK='#!/bin/bash
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
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
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
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/subagent-stop.sh" "$SUBAGENT_STOP_HOOK" "subagent stop hook"
chmod +x "$CLAUDE_HOME/hooks/subagent-stop.sh" 2>/dev/null || true

# Enhanced notification hook with more options
NOTIFY_HOOK='#!/bin/bash
# Enhanced cross-platform notification system
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r ".message // \"Claude Code notification\"")
TYPE=$(echo "$INPUT" | jq -r ".type // \"info\"")
TITLE=$(echo "$INPUT" | jq -r ".title // \"Claude Code\"")

# Function to send notification based on type
send_notification() {
    local msg="$1"
    local notification_type="$2"
    local notification_title="$3"
    
    # Add emoji based on type
    case "$notification_type" in
        error)
            notification_title="❌ $notification_title"
            ;;
        warning)
            notification_title="⚠️ $notification_title"
            ;;
        success)
            notification_title="✅ $notification_title"
            ;;
        *)
            notification_title="ℹ️ $notification_title"
            ;;
    esac
    
    # Send notification based on platform
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        osascript -e "display notification \"$msg\" with title \"$notification_title\"" 2>/dev/null || true
        
        # Also try terminal-notifier if available
        if command -v terminal-notifier &> /dev/null; then
            terminal-notifier -title "$notification_title" -message "$msg" 2>/dev/null || true
        fi
    elif command -v notify-send &> /dev/null; then
        # Linux with notify-send
        case "$notification_type" in
            error)
                notify-send -u critical "$notification_title" "$msg" 2>/dev/null || true
                ;;
            warning)
                notify-send -u normal "$notification_title" "$msg" 2>/dev/null || true
                ;;
            *)
                notify-send -u low "$notification_title" "$msg" 2>/dev/null || true
                ;;
        esac
    elif command -v zenity &> /dev/null; then
        # Linux with zenity
        case "$notification_type" in
            error)
                zenity --error --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
            warning)
                zenity --warning --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
            *)
                zenity --info --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
        esac
    else
        # Fallback: terminal bell
        echo -e "\a" 2>/dev/null || true
        echo "[$notification_title] $msg" >&2
    fi
}

# Send the notification
send_notification "$MESSAGE" "$TYPE" "$TITLE"

# Always exit 0
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/notify.sh" "$NOTIFY_HOOK" "enhanced notification hook"
chmod +x "$CLAUDE_HOME/hooks/notify.sh" 2>/dev/null || true

# PreCompact hook (no metrics)
PRECOMPACT_HOOK='#!/bin/bash
# PreCompact hook - prepares for session data compaction
# Based on official Claude Code documentation - no metrics

set -euo pipefail

# Read hook input
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r ".session.id // empty")
SESSION_SIZE=$(echo "$INPUT" | jq -r ".session.size // 0")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log directory
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
mkdir -p "$LOG_DIR"

# Log compaction event
COMPACT_LOG="$LOG_DIR/compaction.log"
echo "[$TIMESTAMP] PreCompact: Session $SESSION_ID (size: $SESSION_SIZE bytes)" >> "$COMPACT_LOG"

# Create backup of current session state
BACKUP_DIR="'"$HOME_ABSOLUTE"'/.claude/backups/sessions"
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
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/pre-compact.sh" "$PRECOMPACT_HOOK" "pre-compact hook"
chmod +x "$CLAUDE_HOME/hooks/pre-compact.sh" 2>/dev/null || true

# API Key Helper Script
API_KEY_HELPER='#!/bin/bash
# Enhanced API Key Helper - Generate or retrieve Anthropic API key
# Based on official documentation patterns

set -euo pipefail

# Check if API key is already set in environment
if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    echo "$ANTHROPIC_API_KEY"
    exit 0
fi

# Check for key in standard locations
KEY_LOCATIONS=(
    "$HOME/.anthropic/api_key"
    "$HOME/.config/anthropic/api_key"
    "$HOME/.claude/api_key"
    "$HOME/.env"
)

for location in "${KEY_LOCATIONS[@]}"; do
    if [[ -f "$location" && -r "$location" ]]; then
        # For .env files, extract the key
        if [[ "$location" == *.env ]]; then
            KEY=$(grep "^ANTHROPIC_API_KEY=" "$location" | cut -d= -f2- | tr -d "\"'")
            if [[ -n "$KEY" ]]; then
                echo "$KEY"
                exit 0
            fi
        else
            # For dedicated key files
            KEY=$(cat "$location" | tr -d "[:space:]")
            if [[ -n "$KEY" ]]; then
                echo "$KEY"
                exit 0
            fi
        fi
    fi
done

# Check system keychain (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if KEY=$(security find-generic-password -a "$USER" -s "anthropic_api_key" -w 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

# Check common secret managers
if command -v op &> /dev/null; then
    # 1Password CLI
    if KEY=$(op item get "Anthropic API Key" --fields password 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

if command -v pass &> /dev/null; then
    # pass (the standard unix password manager)
    if KEY=$(pass show anthropic/api_key 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

# If no key found, provide helpful error
echo "No Anthropic API key found. Please set ANTHROPIC_API_KEY environment variable or:" >&2
echo "1. Create file: ~/.anthropic/api_key" >&2
echo "2. Get key from: https://console.anthropic.com/settings/keys" >&2
echo "3. Or store in your password manager" >&2
exit 1'

handle_file_conflict "$CLAUDE_HOME/scripts/get-api-key.sh" "$API_KEY_HELPER" "enhanced API key helper script"
chmod +x "$CLAUDE_HOME/scripts/get-api-key.sh" 2>/dev/null || true

# Step 2: Create Comprehensive Slash Commands (keeping all from original)
echo -e "\n${YELLOW}Step 2: Creating Comprehensive Slash Commands...${NC}"

# Built-in Commands Documentation
BUILTIN_HELP_CMD='---
description: "Reference for Claude Code built-in slash commands"
tools: []
---

# Claude Code Built-in Slash Commands

This is a reference for the built-in slash commands that are always available in Claude Code.

## Configuration & Settings
- `/config` - Open Claude Code configuration menu
- `/terminal-setup` - Configure terminal for Shift+Enter support

## Session Management  
- `/clear` - Clear the current conversation
- `/reset` - Reset the conversation completely
- `/resume` - Resume a previous conversation
- `/save` - Save the current conversation

## Display & Interface
- `/fullscreen` - Toggle fullscreen mode
- `/vim` - Toggle vim mode for input
- `/compact` - Enter compact mode (less verbose responses)

## Help & Information
- `/help` - Show general help information
- `/commands` - List all available slash commands
- `/shortcuts` - Show keyboard shortcuts

## MCP (Model Context Protocol)
- `/mcp` - Manage MCP servers
- `/mcp list` - List configured MCP servers
- `/mcp add` - Add a new MCP server
- `/mcp remove` - Remove an MCP server

## IDE Integration
- `/ide` - Connect to IDE for enhanced integration

## Advanced Features
- `/memory` - Manage conversation memory
- `/tools` - List available tools
- `/debug` - Enable debug mode

Note: Custom slash commands (like the ones in this setup) extend these built-in commands.'

handle_file_conflict "$CLAUDE_HOME/commands/common/builtin-help.md" "$BUILTIN_HELP_CMD" "built-in commands reference"

# Common Commands

# Quick fix command
QUICKFIX_CMD='---
description: "Quick fix for common issues"
tools: ["Read", "Grep", "Edit", "Bash"]
---

Quick fix for: {{ISSUE_DESCRIPTION|describe the issue you need fixed}}.

Instructions:
1. Identify the problem location
2. Apply the most appropriate fix
3. Verify the fix works
4. Clean up any temporary changes

Focus on speed and correctness. If the issue is complex, provide step-by-step fixes.'

handle_file_conflict "$CLAUDE_HOME/commands/common/quickfix.md" "$QUICKFIX_CMD" "quickfix command"

# Explain command
EXPLAIN_CMD='---
description: "Explain code, errors, or concepts clearly"
tools: ["Read", "Grep"]
---

Explain: {{TOPIC|what you want explained}}.

<requirements>
- Use clear, simple language
- Provide examples when helpful
- Break complex topics into steps
- Include relevant context
- Highlight key takeaways
</requirements>

If explaining code, show how it works step-by-step.
If explaining an error, provide the likely cause and solution.'

handle_file_conflict "$CLAUDE_HOME/commands/common/explain.md" "$EXPLAIN_CMD" "explain command"

# Development Commands

# Component creation command
COMPONENT_CMD='---
description: "Create a new component with tests and documentation"
tools: ["Write", "Read", "Grep"]
argument-hint: "ComponentName"
---

Create a new {{TYPE|React/Vue/Angular}} component named {{ARGUMENTS}}.

<requirements>
- Follow project component patterns
- Include TypeScript types/interfaces
- Add comprehensive props documentation
- Create unit tests
- Include usage examples
- Follow naming conventions
- Add necessary imports
</requirements>

<structure>
1. Main component file
2. Type definitions
3. Test file
4. Storybook story (if applicable)
5. Style file (if needed)
6. Index export
</structure>'

handle_file_conflict "$CLAUDE_HOME/commands/development/component.md" "$COMPONENT_CMD" "component command"

# API endpoint command
ENDPOINT_CMD='---
description: "Create a new API endpoint with validation and tests"
tools: ["Write", "Read", "Edit"]
argument-hint: "endpoint-path"
---

Create a new {{METHOD|GET/POST/PUT/DELETE}} API endpoint at {{ARGUMENTS}}.

<requirements>
- Input validation
- Error handling
- Authentication/authorization checks
- Request/response documentation
- Unit and integration tests
- Rate limiting considerations
- Logging
</requirements>

Follow the existing API patterns in the codebase.'

handle_file_conflict "$CLAUDE_HOME/commands/development/endpoint.md" "$ENDPOINT_CMD" "endpoint command"

# Database migration command
MIGRATION_CMD='---
description: "Create database migration"
tools: ["Write", "Read", "Bash"]
argument-hint: "migration-name"
---

Create a database migration for: {{ARGUMENTS}}.

<tasks>
1. Generate migration file with timestamp
2. Write up migration (schema changes)
3. Write down migration (rollback)
4. Add data migration if needed
5. Document changes
6. Create/update related models
7. Update TypeScript types
</tasks>

Ensure migration is reversible and includes proper error handling.'

handle_file_conflict "$CLAUDE_HOME/commands/development/migration.md" "$MIGRATION_CMD" "migration command"

# Performance optimization command
PERFORMANCE_CMD='---
description: "Analyze and optimize code performance"
tools: ["Read", "Grep", "Edit", "Bash"]
---

Analyze performance for: {{TARGET_CODE|the current codebase}}.

<thinking>
Consider:
- Time complexity
- Space complexity
- Database query optimization
- Caching opportunities
- Async/parallel processing
- Memory usage
- Bundle size (for frontend)
</thinking>

<tasks>
1. Profile current performance
2. Identify bottlenecks
3. Propose optimizations
4. Implement improvements
5. Measure impact
</tasks>

Provide before/after metrics when possible.'

handle_file_conflict "$CLAUDE_HOME/commands/analysis/performance.md" "$PERFORMANCE_CMD" "performance analysis command"

# Security audit command
SECURITY_AUDIT_CMD='---
description: "Comprehensive security audit"
tools: ["Grep", "Read", "Glob"]
---

Perform security audit on: {{TARGET_PATH|the entire codebase}}.

<checklist>
Security Issues to Check:
- [ ] Hardcoded secrets/API keys
- [ ] SQL injection vulnerabilities
- [ ] XSS vulnerabilities
- [ ] CSRF protection
- [ ] Authentication/authorization flaws
- [ ] Input validation
- [ ] Dependency vulnerabilities
- [ ] Insecure data storage
- [ ] Logging sensitive data
- [ ] CORS configuration
- [ ] Rate limiting
- [ ] File upload vulnerabilities
</checklist>

<output>
For each finding provide:
1. Severity (Critical/High/Medium/Low)
2. Location
3. Description
4. Remediation steps
5. Example fix
</output>'

handle_file_conflict "$CLAUDE_HOME/commands/analysis/security-audit.md" "$SECURITY_AUDIT_CMD" "security audit command"

# Architecture review command
ARCHITECTURE_CMD='---
description: "System architecture analysis and recommendations"
tools: ["Read", "Grep", "Glob"]
---

Analyze architecture for: {{SYSTEM_SCOPE|the current project}}.

<framework>
Architecture evaluation framework:
1. Current state analysis
2. Quality attributes assessment
3. Design patterns identification
4. Scalability considerations
5. Improvement recommendations
</framework>

<analysis_areas>
- **Structure**: Layering, modularity, boundaries
- **Data Flow**: How data moves through the system
- **Dependencies**: Internal and external dependencies
- **Scalability**: Horizontal/vertical scaling capability
- **Reliability**: Fault tolerance, error recovery
- **Security**: Defense in depth, principle of least privilege
- **Performance**: Bottlenecks, optimization opportunities
- **Maintainability**: Code organization, documentation
- **Testability**: Test coverage, test pyramid
- **Deployment**: CI/CD, environments, rollback
</analysis_areas>

<deliverables>
1. Architecture diagram (as text/ascii)
2. Component interaction map
3. Data flow diagram
4. Identified risks and technical debt
5. Prioritized recommendations
6. Migration/improvement roadmap
</deliverables>'

handle_file_conflict "$CLAUDE_HOME/commands/analysis/architecture.md" "$ARCHITECTURE_CMD" "architecture analysis command"

# Test coverage command
COVERAGE_CMD='---
description: "Analyze and improve test coverage"
tools: ["Read", "Grep", "Bash", "Write"]
---

Analyze test coverage for: {{TARGET_PATH|the current project}}.

<tasks>
1. Run coverage analysis
2. Identify untested code paths
3. Find critical business logic lacking tests
4. Generate comprehensive test cases
5. Implement high-value tests
6. Improve existing test quality
</tasks>

<focus_areas>
- Edge cases
- Error handling paths
- Integration points
- State management
- Async operations
- User interactions
</focus_areas>

Use project test framework and follow existing patterns.'

handle_file_conflict "$CLAUDE_HOME/commands/analysis/coverage.md" "$COVERAGE_CMD" "test coverage command"

# Creative Commands

# User story command
USERSTORY_CMD='---
description: "Create detailed user stories"
tools: ["Write"]
argument-hint: "feature-name"
---

Create user stories for: {{ARGUMENTS}}.

<format>
As a [type of user]
I want [goal/desire]
So that [benefit/value]

Acceptance Criteria:
- [ ] Specific measurable outcome
- [ ] Edge cases handled
- [ ] Performance requirements met
- [ ] Accessibility standards followed

Technical Notes:
- Implementation considerations
- Dependencies
- Potential challenges
</format>

Generate 3-5 related user stories with increasing complexity.'

handle_file_conflict "$CLAUDE_HOME/commands/creative/userstory.md" "$USERSTORY_CMD" "user story command"

# Documentation generator
DOCS_CMD='---
description: "Generate comprehensive documentation"
tools: ["Read", "Write", "Grep", "Glob"]
---

Generate documentation for: {{TARGET|the specified code or system}}.

<documentation_types>
- **API Documentation**: Endpoints, parameters, responses
- **Code Documentation**: Classes, methods, functions  
- **Architecture Documentation**: System design, patterns
- **User Documentation**: Guides, tutorials
- **Deployment Documentation**: Setup, configuration
</documentation_types>

<requirements>
- Clear and concise
- Include examples
- Cover edge cases
- Provide context
- Use appropriate format (Markdown/JSDoc/etc)
- Include diagrams where helpful
</requirements>

Match the project documentation style.'

handle_file_conflict "$CLAUDE_HOME/commands/creative/docs.md" "$DOCS_CMD" "documentation generator command"

# Productivity Commands

# Todo extraction command
TODO_CMD='---
description: "Extract and organize TODOs from codebase"
tools: ["Grep", "Read", "Write"]
---

Extract all TODO/FIXME/HACK comments from the codebase.

<tasks>
1. Search for todo markers
2. Categorize by type and priority
3. Group by file/component
4. Create actionable task list
5. Estimate effort levels
6. Suggest implementation order
</tasks>

<output_format>
## High Priority
- [ ] Task description (file:line)
  - Context
  - Suggested approach
  
## Medium Priority
...

## Low Priority
...

## Technical Debt
...
</output_format>'

handle_file_conflict "$CLAUDE_HOME/commands/productivity/todos.md" "$TODO_CMD" "todo extraction command"

# PR preparation command
PR_CMD='---
description: "Prepare comprehensive pull request"
tools: ["Bash", "Read", "Write"]
---

Prepare pull request for current changes.

<tasks>
1. Analyze all changes
2. Group related changes
3. Generate descriptive title
4. Write detailed description
5. Create testing checklist
6. Document breaking changes
7. Add migration notes
8. Include screenshots (describe what they should show)
</tasks>

<pr_template>
## Description
Brief summary of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Detailed list of changes
- Technical decisions and rationale

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots
(If applicable)

## Breaking Changes
(If applicable)

## Migration Guide
(If applicable)
</pr_template>'

handle_file_conflict "$CLAUDE_HOME/commands/productivity/pr.md" "$PR_CMD" "PR preparation command"

# Research Commands

# Dependency analysis command
DEPS_CMD='---
description: "Analyze project dependencies"
tools: ["Read", "Grep", "Bash"]
---

Analyze dependencies for the current project.

<analysis>
1. List all dependencies
2. Check for outdated packages
3. Identify security vulnerabilities
4. Find unused dependencies
5. Detect duplicate dependencies
6. Analyze bundle size impact
7. Check license compatibility
</analysis>

<recommendations>
- Updates needed (with breaking change notes)
- Dependencies to remove
- Dependencies to add
- Security fixes required
- Performance optimizations
</recommendations>'

handle_file_conflict "$CLAUDE_HOME/commands/research/dependencies.md" "$DEPS_CMD" "dependency analysis command"

# Code archaeology command
ARCHAEOLOGY_CMD='---
description: "Understand code history and evolution"
tools: ["Bash", "Read", "Grep"]
argument-hint: "file-or-feature"
---

Research the history and evolution of: {{ARGUMENTS}}.

<investigation>
1. Git history analysis
2. Find original implementation
3. Track major changes
4. Identify contributors
5. Understand design decisions
6. Find related issues/PRs
7. Document evolution
</investigation>

<output>
## Timeline
- Date: Change description (author)

## Major Decisions
- Why was it implemented this way?
- What alternatives were considered?

## Current State
- Technical debt accumulated
- Improvement opportunities
</output>'

handle_file_conflict "$CLAUDE_HOME/commands/research/archaeology.md" "$ARCHAEOLOGY_CMD" "code archaeology command"

# Advanced debugging command
DEBUG_CMD='---
description: "Advanced debugging assistance"
tools: ["Read", "Grep", "Bash", "Edit"]
---

Debug issue: {{ISSUE_DESCRIPTION|describe the problem}}.

<thinking>
Systematic debugging approach:
1. Understand expected vs actual behavior
2. Gather relevant information
3. Form hypotheses
4. Test systematically
5. Implement fix
6. Verify solution
</thinking>

<debugging_toolkit>
- **Logging**: Add strategic debug output
- **Breakpoints**: Identify key inspection points
- **State Analysis**: Track variable values
- **Flow Tracing**: Follow execution path
- **Binary Search**: Isolate problem area
- **Regression Test**: Ensure fix doesn not break anything
</debugging_toolkit>

<process>
1. Reproduce the issue
2. Isolate the problem
3. Understand root cause
4. Implement fix
5. Add tests to prevent regression
6. Document the solution
</process>'

handle_file_conflict "$CLAUDE_HOME/commands/debug.md" "$DEBUG_CMD" "advanced debugging command"

# Code review command (renamed to avoid conflict with built-in /review)
CODE_REVIEW_CMD='---
description: "Comprehensive code review"
tools: ["Read", "Grep", "Glob"]
---

Review code: {{TARGET_CODE|current changes or specified files}}.

<analysis>
Review comprehensive criteria:
1. Code quality and readability
2. Performance implications
3. Security considerations
4. Error handling
5. Test coverage
6. Documentation
7. Best practices adherence
</analysis>

<review_checklist>
## Code Quality
- [ ] Clear naming
- [ ] Appropriate abstraction levels
- [ ] DRY principle followed
- [ ] SOLID principles applied
- [ ] No code smells

## Functionality
- [ ] Requirements met
- [ ] Edge cases handled
- [ ] Error scenarios covered
- [ ] Performance acceptable
- [ ] Security considered

## Maintainability
- [ ] Well documented
- [ ] Testable design
- [ ] Consistent style
- [ ] Clear structure

## Testing
- [ ] Adequate test coverage
- [ ] Tests are meaningful
- [ ] Edge cases tested
- [ ] Integration tests present
</review_checklist>

<output_format>
## Summary
Overall assessment

## Strengths
What is done well

## Issues Found
### Critical
Must fix before merge

### Important
Should address

### Minor
Nice to have

## Suggestions
Improvement recommendations
</output_format>'

handle_file_conflict "$CLAUDE_HOME/commands/code-review.md" "$CODE_REVIEW_CMD" "comprehensive code review command"

# Refactoring command
REFACTOR_CMD='---
description: "Guided code refactoring"
tools: ["Read", "Edit", "Grep", "Bash"]
---

Refactor: {{TARGET_CODE|specified code}} with goal: {{REFACTOR_GOAL|improve quality}}.

<approach>
1. Understand current implementation
2. Identify improvement opportunities
3. Plan refactoring steps
4. Implement changes incrementally
5. Verify functionality preserved
</approach>

<refactoring_patterns>
- **Extract Method**: Break down large functions
- **Extract Class**: Separate responsibilities
- **Move Method**: Relocate to appropriate class
- **Rename**: Improve naming clarity
- **Replace Magic Numbers**: Use constants
- **Simplify Conditionals**: Reduce complexity
- **Remove Duplication**: Apply DRY
- **Introduce Parameter Object**: Group related params
</refactoring_patterns>

<process>
1. Ensure tests exist (write if needed)
2. Make incremental changes
3. Run tests after each change
4. Update documentation
5. Commit with clear messages
</process>

Focus on improving maintainability while preserving behavior.'

handle_file_conflict "$CLAUDE_HOME/commands/refactor.md" "$REFACTOR_CMD" "refactoring command"

# Step 3: Create comprehensive settings.json with all features (no performance hook)
echo -e "\n${YELLOW}Step 3: Creating comprehensive settings.json...${NC}"

# Use absolute paths in JSON to avoid tilde expansion issues
SETTINGS_JSON=$(cat <<EOF
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/security-check.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/pre-backup.sh"
          }
        ]
      },
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/tool-usage.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/post-lint.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/prompt-logger.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/session-cleanup.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission|error|warning|success",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/notify.sh"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/subagent-stop.sh"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "MultiEdit",
      "Grep",
      "Glob",
      "Bash",
      "Task",
      "WebFetch",
      "WebSearch",
      "NotebookRead",
      "NotebookEdit",
      "TodoWrite",
      "ListMcpResourcesTool",
      "ReadMcpResourceTool"
    ],
    "deny": [],
    "additionalDirectories": [
      "~/.dotfiles",
      "~/Workspace/Cursorts",
      "~/Workspace/Cursorts/Clawed",
      "~/Workspace/Cursorts/CutoverSmokeTest",
      "~/Workspace/awaytravel-theme"
    ]
  },
  "env": {
    "CLAUDE_EXPERT": "true",
    "EDITOR": "\${EDITOR:-code}",
    "CLAUDE_MAX_TURNS": "20",
    "CLAUDE_THEME": "dark",
    "CLAUDE_HOME": "$HOME_ABSOLUTE/.claude"
  },
  "apiKeyHelper": "$HOME_ABSOLUTE/.claude/scripts/get-api-key.sh",
  "cleanupPeriodDays": 30,
  "includeCoAuthoredBy": false,
  "autoUpdates": true,
  "preferredNotifChannel": "system",
  "model": "claude-opus-4-20250514"
}
EOF
)

handle_file_conflict "$CLAUDE_HOME/settings.json" "$SETTINGS_JSON" "comprehensive settings.json"

# Step 4: Create enhanced MCP configuration (same as original)
echo -e "\n${YELLOW}Step 4: Creating enhanced MCP configuration...${NC}"

MCP_CONFIG='{
  "servers": {
    "filesystem": {
      "comment": "Enhanced file system operations - reading, writing, and managing files",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp", "$HOME/projects"],
      "env": {
        "FILESYSTEM_READ_ONLY": "false"
      }
    },
    "github": {
      "comment": "GitHub repository access and operations with enhanced features",
      "transport": "stdio", 
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN:-your_github_token_here}",
        "GITHUB_ENTERPRISE_URL": "${GITHUB_ENTERPRISE_URL:-}"
      }
    },
    "postgres": {
      "comment": "PostgreSQL database access and operations", 
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL:-postgresql://user:password@localhost:5432/database}"
      }
    },
    "sqlite": {
      "comment": "SQLite database access and operations",
      "transport": "stdio",
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "${SQLITE_DB_PATH:-/path/to/database.db}"]
    },
    "atlassian": {
      "comment": "Official Atlassian MCP - Jira and Confluence integration",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-atlassian"],
      "env": {
        "ATLASSIAN_INSTANCE_URL": "${ATLASSIAN_URL:-https://your-instance.atlassian.net}",
        "ATLASSIAN_USERNAME": "${ATLASSIAN_EMAIL:-your-email@example.com}",
        "ATLASSIAN_API_TOKEN": "${ATLASSIAN_TOKEN:-your_api_token_here}"
      }
    },
    "git": {
      "comment": "Advanced Git operations beyond basic commands",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"],
      "env": {
        "GIT_USER_NAME": "${GIT_AUTHOR_NAME:-}",
        "GIT_USER_EMAIL": "${GIT_AUTHOR_EMAIL:-}"
      }
    },
    "shell": {
      "comment": "Enhanced shell command execution with safety checks",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-shell"],
      "env": {
        "SHELL_SAFE_MODE": "true",
        "SHELL_ALLOWED_COMMANDS": "ls,cat,grep,find,echo,pwd"
      }
    },
    "web-browser": {
      "comment": "Web browsing and content extraction",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-web-browser"]
    },
    "slack": {
      "comment": "Slack integration for notifications and messaging",
      "disabled": true,
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN:-xoxb-your-token}",
        "SLACK_APP_TOKEN": "${SLACK_APP_TOKEN:-xapp-your-token}"
      }
    },
    "google-drive": {
      "comment": "Google Drive file access and management",
      "disabled": true,
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-google-drive"],
      "env": {
        "GOOGLE_DRIVE_CREDENTIALS": "${GOOGLE_DRIVE_CREDENTIALS:-/path/to/credentials.json}"
      }
    }
  }
}'

handle_file_conflict "$CLAUDE_HOME/mcp.json" "$MCP_CONFIG" "enhanced MCP configuration"

# Step 5: Create comprehensive CLAUDE.md (no analytics mentions)
echo -e "\n${YELLOW}Step 5: Creating comprehensive CLAUDE.md...${NC}"

CLAUDE_MD='# Claude Code Expert Configuration - No Analytics Edition

This is my comprehensive Claude Code configuration based on the complete official documentation.

## Development Philosophy

### Core Principles
- **Clarity First**: Write code that is immediately understandable
- **Security Always**: Never compromise on security best practices
- **Performance Matters**: Consider performance implications in all decisions
- **Test Everything**: Comprehensive testing is non-negotiable
- **Document Thoughtfully**: Documentation should be helpful, not redundant

### Communication Style
- Be direct and actionable in responses
- Provide context for decisions
- Suggest alternatives when appropriate
- Highlight potential issues proactively
- Use examples to clarify complex concepts

## Enabled Features

### System-wide Hooks
- ✅ **Pre-backup**: Automatic file backups before ALL file modifications
- ✅ **Post-lint**: Auto-formatting for multiple languages after changes
- ✅ **Security validation**: Comprehensive command and file safety checks
- ✅ **Tool usage logging**: Simple audit trail of tool usage
- ✅ **Prompt logging**: Basic prompt tracking
- ✅ **Session cleanup**: Periodic cleanup of old files
- ✅ **Smart notifications**: Context-aware cross-platform alerts
- ✅ **Agent tracking**: SubagentStop and PreCompact hooks

### Slash Commands

#### Built-in Commands (Always Available)
- `/help` - Show general help information  
- `/config` - Open configuration menu
- `/mcp` - Manage MCP servers
- `/vim` - Toggle vim mode
- `/compact` - Enter compact mode
- **See `/builtin-help` for complete list**

#### Custom Commands (This Setup)

##### Common Workflows
- `/quickfix` - Quick fixes for common issues
- `/explain` - Clear explanations of code, errors, or concepts
- `/builtin-help` - Reference for all built-in commands

##### Development
- `/component` - Create new components with tests
- `/endpoint` - Create API endpoints with validation
- `/migration` - Database migrations with rollback

##### Analysis
- `/performance` - Performance analysis and optimization
- `/security-audit` - Comprehensive security review
- `/architecture` - System architecture analysis
- `/coverage` - Test coverage analysis and improvement

##### Creative
- `/userstory` - Generate detailed user stories
- `/docs` - Generate comprehensive documentation

##### Productivity
- `/todos` - Extract and organize TODOs
- `/pr` - Prepare comprehensive pull requests

##### Research
- `/dependencies` - Analyze project dependencies
- `/archaeology` - Understand code history

##### Advanced
- `/debug` - Advanced debugging assistance
- `/code-review` - Comprehensive code review
- `/refactor` - Guided code refactoring

### MCP Integrations
- 🗄️ **Databases**: PostgreSQL, SQLite
- 🐙 **Version Control**: GitHub, Git advanced operations
- 📁 **File Systems**: Enhanced file operations
- 🎫 **Project Management**: Jira, Confluence (Atlassian)
- 🌐 **Web**: Browser automation, content extraction
- 💬 **Communication**: Slack (when enabled)
- 📊 **Cloud Storage**: Google Drive (when enabled)

## Project Guidelines

### Code Quality Standards
1. **Architecture**: Follow clean architecture principles
2. **Patterns**: Use appropriate design patterns
3. **SOLID**: Apply SOLID principles thoughtfully
4. **DRY**: Eliminate duplication, but not at the cost of clarity
5. **KISS**: Keep solutions as simple as possible

### Security Requirements
1. Never hardcode secrets or credentials
2. Validate all inputs
3. Use parameterized queries
4. Implement proper authentication/authorization
5. Follow OWASP guidelines
6. Regular dependency updates

### Testing Standards
1. **Unit Tests**: Test individual components in isolation
2. **Integration Tests**: Test component interactions
3. **E2E Tests**: Test critical user flows
4. **Performance Tests**: Monitor performance regressions
5. **Security Tests**: Automated security scanning

### Documentation Requirements
1. **Code Comments**: Explain WHY, not WHAT
2. **API Documentation**: Complete with examples
3. **Architecture Docs**: Keep diagrams updated
4. **README**: Clear setup and usage instructions
5. **Changelog**: Track all significant changes

## Workflow Patterns

### Extended Thinking
For complex problems, I will:
1. Break down the problem systematically
2. Consider multiple approaches
3. Evaluate trade-offs
4. Implement incrementally
5. Verify each step

### Image Analysis
I can analyze:
- UI mockups to implement interfaces
- Architecture diagrams to understand systems
- Error screenshots for debugging
- Whiteboard photos for design discussions

### Git Workflows
- Use conventional commits
- Create focused, atomic commits
- Write descriptive PR descriptions
- Keep branch history clean
- Tag releases appropriately

## Memory Management

### Project Memory
Project-specific patterns and conventions are maintained in:
- `.claude/CLAUDE.md` - Local project overrides
- `CLAUDE.md` - Project root configuration

### Imports
@'"$HOME_ABSOLUTE"'/.claude/workflows/development-patterns.md
@'"$HOME_ABSOLUTE"'/.claude/workflows/debugging-strategies.md
@'"$HOME_ABSOLUTE"'/.claude/templates/code-templates.md

## Performance Optimizations

### For Large Codebases
1. Use focused grep/glob patterns
2. Leverage the Task tool for complex searches
3. Read specific sections rather than entire files
4. Cache frequently accessed information

### For Complex Tasks
1. Break into smaller, manageable subtasks
2. Use TodoWrite to track progress
3. Validate incrementally
4. Commit progress regularly

## Keyboard Shortcuts Reference

### General
- `Ctrl+C` - Cancel current operation
- `Ctrl+L` - Clear screen
- `Tab` - Autocomplete paths

### Multiline Input
- `\` + `Enter` - Continue on next line
- `Shift+Enter` - New line (after setup)

### Vim Mode
- `/vim` - Toggle vim mode
- Standard vim navigation when enabled

## Tool-Specific Guidelines

### When Using Bash
- Always quote variables
- Use absolute paths when possible
- Check command success/failure
- Clean up temporary files

### When Using Git
- Fetch before operations
- Use verbose commit messages
- Verify branch before pushing
- Check for uncommitted changes

### When Modifying Files
- Verify file exists first
- Preserve file permissions
- Maintain consistent formatting
- Update related files together

## Error Handling

When errors occur:
1. Provide clear error description
2. Show relevant context
3. Suggest potential fixes
4. Offer to implement solution
5. Add tests to prevent recurrence

## Remember
- Always run linting and type checking after code changes
- Commit early and often with clear messages
- Ask for clarification when requirements are ambiguous
- Proactively suggest improvements
- Keep security in mind always

## Easter Eggs
- Use "think harder" for complex analysis
- Ask me to explain like a specific persona
- Request ASCII art diagrams
- Challenge me with edge cases'

handle_file_conflict "$CLAUDE_HOME/CLAUDE.md" "$CLAUDE_MD" "comprehensive CLAUDE.md"

# Step 6: Create workflow pattern files (same as original)
echo -e "\n${YELLOW}Step 6: Creating workflow patterns and templates...${NC}"

# Development patterns
DEV_PATTERNS='# Development Patterns

## Component Development Pattern
1. Understand requirements and user stories
2. Design component interface (props/events)
3. Create type definitions first
4. Implement with minimal functionality
5. Add styling and interactions
6. Write comprehensive tests
7. Create usage documentation
8. Add to component library/storybook

## API Development Pattern
1. Define endpoint contract (OpenAPI/Swagger)
2. Implement input validation
3. Create business logic layer
4. Add data access layer
5. Implement error handling
6. Add authentication/authorization
7. Write integration tests
8. Document with examples

## Feature Development Pattern
1. Break down into small, deployable chunks
2. Create feature flag (if applicable)
3. Implement backend first
4. Add frontend components
5. Integrate and test end-to-end
6. Add monitoring/analytics
7. Create rollback plan
8. Document user-facing changes

## Database Change Pattern
1. Design schema changes
2. Consider backwards compatibility
3. Create migration scripts
4. Test rollback procedures
5. Update ORM models
6. Update API contracts
7. Plan data migration
8. Schedule maintenance window

## Performance Optimization Pattern
1. Measure current performance
2. Identify bottlenecks with profiling
3. Set performance targets
4. Implement optimizations incrementally
5. Measure after each change
6. Document performance gains
7. Add performance regression tests
8. Monitor in production'

handle_file_conflict "$CLAUDE_HOME/workflows/development-patterns.md" "$DEV_PATTERNS" "development patterns"

# Debugging strategies
DEBUG_STRATEGIES='# Debugging Strategies

## Systematic Debugging Approach
1. **Reproduce**: Ensure consistent reproduction
2. **Isolate**: Narrow down the problem area
3. **Hypothesize**: Form theories about the cause
4. **Test**: Verify hypotheses systematically
5. **Fix**: Implement minimal solution
6. **Verify**: Ensure fix works and no regressions

## Debugging Techniques

### Binary Search Debugging
- Comment out half the code
- See if problem persists
- Narrow down recursively
- Identify exact problem line

### Time Travel Debugging
- Use git bisect to find breaking commit
- Review commit changes
- Understand what changed
- Apply fix with context

### Rubber Duck Debugging
- Explain problem aloud
- Walk through code step-by-step
- Often reveals overlooked issues
- Document findings

### Print Debugging
- Strategic console.log/print statements
- Log variable states
- Track execution flow
- Remove when done

### Debugger Usage
- Set breakpoints at key locations
- Step through execution
- Inspect variable values
- Watch expressions

## Common Bug Categories

### Race Conditions
- Add proper synchronization
- Use locks/mutexes appropriately
- Consider async/await patterns
- Test with delays

### Memory Leaks
- Profile memory usage
- Look for unclosed resources
- Check event listener cleanup
- Review object retention

### Off-by-One Errors
- Check loop boundaries
- Verify array indices
- Test edge cases
- Add boundary assertions

### Null/Undefined Issues
- Add null checks
- Use optional chaining
- Provide default values
- Add type safety

### Integration Issues
- Verify API contracts
- Check data formats
- Test error responses
- Monitor timeouts'

handle_file_conflict "$CLAUDE_HOME/workflows/debugging-strategies.md" "$DEBUG_STRATEGIES" "debugging strategies"

# Code templates
CODE_TEMPLATES='# Code Templates

## React Component Template
```typescript
import React, { FC, useState, useEffect } from "react";
import { ComponentProps } from "./types";
import styles from "./Component.module.css";

export interface ComponentNameProps {
  // Define props here
}

export const ComponentName: FC<ComponentNameProps> = ({
  // Destructure props
}) => {
  // State and hooks
  const [state, setState] = useState<string>("");

  // Effects
  useEffect(() => {
    // Effect logic
  }, []);

  // Handlers
  const handleClick = () => {
    // Handler logic
  };

  // Render
  return (
    <div className={styles.container}>
      {/* Component content */}
    </div>
  );
};
```

## Express Endpoint Template
```typescript
import { Request, Response, NextFunction } from "express";
import { body, validationResult } from "express-validator";

// Validation middleware
export const validateEndpoint = [
  body("field").notEmpty().withMessage("Field is required"),
  body("email").isEmail().withMessage("Invalid email"),
];

// Handler
export const endpointHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    // Check validation
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    // Business logic
    const result = await processRequest(req.body);

    // Response
    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    next(error);
  }
};
```

## Test Template
```typescript
import { describe, it, expect, beforeEach, jest } from "@jest/globals";

describe("ComponentName", () => {
  let mockDependency: jest.Mock;

  beforeEach(() => {
    mockDependency = jest.fn();
    jest.clearAllMocks();
  });

  describe("feature", () => {
    it("should handle normal case", () => {
      // Arrange
      const input = "test";
      const expected = "TEST";

      // Act
      const result = functionUnderTest(input);

      // Assert
      expect(result).toBe(expected);
    });

    it("should handle edge case", () => {
      // Test edge cases
    });

    it("should handle error case", () => {
      // Test error scenarios
    });
  });
});
```

## Error Handler Template
```typescript
export class CustomError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code: string = "INTERNAL_ERROR"
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (err instanceof CustomError) {
    return res.status(err.statusCode).json({
      error: {
        message: err.message,
        code: err.code,
      },
    });
  }

  // Log unexpected errors
  console.error("Unexpected error:", err);

  res.status(500).json({
    error: {
      message: "Internal server error",
      code: "INTERNAL_ERROR",
    },
  });
};
```'

handle_file_conflict "$CLAUDE_HOME/templates/code-templates.md" "$CODE_TEMPLATES" "code templates"

# Step 7: Create IDE integration helpers (same as original)
echo -e "\n${YELLOW}Step 7: Creating IDE integration helpers...${NC}"

# VS Code integration guide
VSCODE_INTEGRATION='# VS Code Integration Guide

## Quick Setup
1. Install Claude Code globally: `npm install -g @anthropic-ai/claude-code`
2. Open VS Code integrated terminal
3. Run `claude` - extension auto-installs

## Keyboard Shortcuts
- `Cmd+Esc` (Mac) / `Ctrl+Esc` (Windows/Linux) - Launch Claude Code
- `Cmd+Option+K` (Mac) / `Alt+Ctrl+K` (Windows/Linux) - Insert file reference
- `Tab` - Autocomplete file paths

## Features
- ✅ Interactive diff viewing
- ✅ Automatic selection/tab context sharing
- ✅ File reference shortcuts
- ✅ Automatic diagnostic error sharing

## Configuration
1. Set `diffTool` to `auto` in Claude Code settings
2. Extension respects VS Code themes
3. Works with all VS Code forks (Cursor, Windsurf, VSCodium)

## Tips
- Keep Claude Code terminal visible for context
- Use split terminal for simultaneous coding
- Leverage file path autocomplete
- Let Claude Code see your selection for context'

handle_file_conflict "$CLAUDE_HOME/ide-integration/vscode.md" "$VSCODE_INTEGRATION" "VS Code integration guide"

# JetBrains integration guide
JETBRAINS_INTEGRATION='# JetBrains IDE Integration Guide

## Setup
1. Open JetBrains IDE (IntelliJ, PyCharm, WebStorm, etc.)
2. Install Claude Code plugin from marketplace
3. Restart IDE completely

## Usage
- Run from integrated terminal
- Use `/ide` command to connect external terminals
- Start from project root directory

## Features
- ✅ Full terminal integration
- ✅ Project context awareness
- ✅ Debugging integration
- ✅ Run configuration support

## Troubleshooting
- Always restart IDE after plugin install
- Run from project root
- Ensure plugin is enabled
- For remote dev, install on remote host'

handle_file_conflict "$CLAUDE_HOME/ide-integration/jetbrains.md" "$JETBRAINS_INTEGRATION" "JetBrains integration guide"

# Keyboard shortcuts reference
SHORTCUTS_REF='# Keyboard Shortcuts Reference

## Global Shortcuts
| Shortcut | Action | Platform |
|----------|--------|----------|
| `Ctrl+C` | Cancel current operation | All |
| `Ctrl+D` | Exit Claude Code | All |
| `Ctrl+L` | Clear screen | All |
| `Tab` | Autocomplete paths | All |
| `Up/Down` | Navigate history | All |

## Multiline Input
| Method | Shortcut | Notes |
|--------|----------|-------|
| Escape | `\` + `Enter` | Works everywhere |
| macOS | `Option+Enter` | Default on Mac |
| Custom | `Shift+Enter` | After `/terminal-setup` |

## IDE Integration
| IDE | Launch | Context |
|-----|--------|---------|
| VS Code | `Cmd/Ctrl+Esc` | Auto-shares selection |
| JetBrains | Terminal | Project aware |

## Vim Mode
| Mode | Key | Action |
|------|-----|--------|
| Normal | `i` | Insert mode |
| Normal | `hjkl` | Navigate |
| Insert | `Esc` | Normal mode |
| Normal | `dd` | Delete line |

## Quick Commands
| Shortcut | Action |
|----------|--------|
| `/` | Slash command |
| `#` | Add to memory |
| `@` | MCP resource reference |'

handle_file_conflict "$CLAUDE_HOME/ide-integration/shortcuts.md" "$SHORTCUTS_REF" "keyboard shortcuts reference"

# Step 8: Create terminal setup helper (same as original)
echo -e "\n${YELLOW}Step 8: Creating enhanced terminal setup script...${NC}"

TERMINAL_SETUP='#!/bin/bash
# Enhanced Terminal Setup for Claude Code
# Based on official documentation

echo "Claude Code Terminal Setup - Enhanced Edition"
echo "============================================"
echo ""
echo "This script configures your terminal for optimal Claude Code usage."
echo ""

# Detect terminal
TERM_NAME="Unknown"
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    TERM_NAME="VS Code Terminal"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    TERM_NAME="iTerm2"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    TERM_NAME="macOS Terminal"
elif [[ -n "$GNOME_TERMINAL_SERVICE" ]]; then
    TERM_NAME="GNOME Terminal"
elif [[ "$TERM" == "xterm-kitty" ]]; then
    TERM_NAME="Kitty"
elif [[ -n "$ALACRITTY_SOCKET" ]]; then
    TERM_NAME="Alacritty"
else
    TERM_NAME="$TERM"
fi

echo "Detected Terminal: $TERM_NAME"
echo ""

# Terminal-specific setup
case "$TERM_NAME" in
    "VS Code Terminal")
        echo "For Shift+Enter support in VS Code:"
        echo "1. Open VS Code Settings (Cmd+, or Ctrl+,)"
        echo "2. Search for '\''terminal.integrated.commandsToSkipShell'\''"
        echo "3. Add: \"workbench.action.quickOpen\""
        echo ""
        echo "For better color support:"
        echo "Add to settings.json:"
        echo "\"terminal.integrated.minimumContrastRatio\": 1"
        ;;
        
    "iTerm2")
        echo "Configuring iTerm2 for Shift+Enter..."
        # Check if iTerm2 is running
        if pgrep -x "iTerm2" > /dev/null; then
            # Create the key mapping
            defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x0d-0x20000" "[13;2u"
            echo "✓ Shift+Enter configured for iTerm2"
            echo ""
            echo "Additional iTerm2 optimizations:"
            echo "1. Enable: Preferences → Profiles → Terminal → '\''Silence bell'\''"
            echo "2. Enable: Preferences → Profiles → Terminal → '\''Send escape sequence generated alerts'\''"
            echo "3. Set: Preferences → Profiles → Keys → Left/Right Option → '\''Esc+'\''"
        else
            echo "iTerm2 is not running. Please:"
            echo "1. Open iTerm2"
            echo "2. Go to Preferences → Keys"
            echo "3. Add new key mapping:"
            echo "   - Keyboard shortcut: Shift+Enter"
            echo "   - Action: Send Escape Sequence"
            echo "   - Esc+: [13;2u"
        fi
        ;;
        
    "macOS Terminal")
        echo "For Option+Enter support in Terminal.app:"
        echo "1. Open Terminal → Settings → Profiles → Keyboard"
        echo "2. Check '\''Use Option as Meta key'\''"
        echo ""
        echo "For better colors:"
        echo "Use a theme like '\''Pro'\'' or '\''Homebrew'\''"
        ;;
        
    "GNOME Terminal")
        echo "For Shift+Enter support in GNOME Terminal:"
        echo "1. Edit → Preferences → Shortcuts"
        echo "2. Disable conflicting Shift+Enter shortcut"
        echo ""
        echo "For notifications:"
        echo "Ensure libnotify is installed: sudo apt-get install libnotify-bin"
        ;;
        
    "Kitty")
        echo "For Shift+Enter support in Kitty:"
        echo "Add to ~/.config/kitty/kitty.conf:"
        echo "map shift+enter send_text all \\x1b[13;2u"
        ;;
        
    "Alacritty")
        echo "For Shift+Enter support in Alacritty:"
        echo "Add to ~/.config/alacritty/alacritty.yml:"
        echo "key_bindings:"
        echo "  - { key: Return, mods: Shift, chars: \"\\x1b[13;2u\" }"
        ;;
        
    *)
        echo "Generic terminal detected."
        echo "For multiline input, use \\ followed by Enter"
        ;;
esac

echo ""
echo "General Claude Code Terminal Tips:"
echo "=================================="
echo "1. Multiline input:"
echo "   - Use \\ + Enter (works everywhere)"
echo "   - Configure Shift+Enter (terminal-specific)"
echo ""
echo "2. File path completion:"
echo "   - Type partial path and press Tab"
echo ""
echo "3. Command history:"
echo "   - Use Up/Down arrows"
echo ""
echo "4. Clear screen:"
echo "   - Ctrl+L"
echo ""
echo "5. For notifications:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   - Grant Terminal notification permissions in System Settings"
else
    echo "   - Install notification daemon (notify-send)"
fi
echo ""
echo "6. Color themes:"
echo "   - Claude Code adapts to your terminal theme"
echo "   - Use /config in Claude to adjust if needed"
echo ""

# Test notification system
echo "Testing notification system..."
"'"$HOME"'/.claude/hooks/notify.sh" <<< '\''{"message": "Terminal setup complete!", "type": "success", "title": "Claude Code"}'\''

echo ""
echo "Setup complete! Start Claude Code with: claude"'

handle_file_conflict "$CLAUDE_HOME/terminal-setup.sh" "$TERMINAL_SETUP" "enhanced terminal setup script"
chmod +x "$CLAUDE_HOME/terminal-setup.sh" 2>/dev/null || true

# Step 9: Create verification script (updated to reflect no analytics)
echo -e "\n${YELLOW}Step 9: Creating comprehensive verification script...${NC}"

VERIFY_SCRIPT='#!/bin/bash
# Verify Claude Expert No Analytics Setup

echo "🔍 Claude Expert No Analytics Setup Verification"
echo "==============================================="

# Colors
GREEN='\''\\033[0;32m'\''
RED='\''\\033[0;31m'\''
YELLOW='\''\\033[1;33m'\''
BLUE='\''\\033[0;34m'\''
NC='\''\\033[0m'\''

errors=0
warnings=0
features=0

# Function to check feature
check_feature() {
    if [[ $1 -eq 0 ]]; then
        echo -e "  ${GREEN}✓${NC} $2"
        ((features++))
    else
        echo -e "  ${RED}✗${NC} $2"
        ((errors++))
    fi
}

# Check directories
echo -e "\n${YELLOW}Checking directory structure...${NC}"
for dir in ~/.claude/{hooks,commands,backups,scripts,logs,templates,memory,workflows,ide-integration}; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check hooks
echo -e "\n${YELLOW}Checking comprehensive hooks...${NC}"
hooks=(
    "pre-backup.sh"
    "post-lint.sh"
    "security-check.sh"
    "tool-usage.sh"
    "prompt-logger.sh"
    "session-cleanup.sh"
    "notify.sh"
    "subagent-stop.sh"
    "pre-compact.sh"
)
for hook in "${hooks[@]}"; do
    if [[ -x "$HOME/.claude/hooks/$hook" ]]; then
        echo -e "  ${GREEN}✓${NC} $hook (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $hook"
        ((errors++))
    fi
done

# Count slash commands
echo -e "\n${YELLOW}Checking slash commands...${NC}"
total_commands=$(find "$HOME/.claude/commands" -name "*.md" -type f | wc -l)
if [[ $total_commands -ge 15 ]]; then
    echo -e "  ${GREEN}✓${NC} Found $total_commands slash commands"
    ((features++))
else
    echo -e "  ${YELLOW}⚠${NC}  Only $total_commands slash commands (expected 15+)"
    ((warnings++))
fi

# List command categories
for category in common development analysis creative productivity research; do
    count=$(find "$HOME/.claude/commands/$category" -name "*.md" -type f 2>/dev/null | wc -l)
    if [[ $count -gt 0 ]]; then
        echo -e "    ${GREEN}✓${NC} $category: $count commands"
    fi
done

# Check configuration files
echo -e "\n${YELLOW}Checking configuration files...${NC}"
configs=(
    "settings.json"
    "mcp.json"
    "CLAUDE.md"
)
for config in "${configs[@]}"; do
    if [[ -f "$HOME/.claude/$config" ]]; then
        echo -e "  ${GREEN}✓${NC} $config"
        
        # Validate JSON files
        if [[ "$config" =~ \\.json$ ]] && command -v jq &> /dev/null; then
            if jq empty "$HOME/.claude/$config" 2>/dev/null; then
                echo -e "    ${GREEN}✓${NC} Valid JSON"
            else
                echo -e "    ${RED}✗${NC} Invalid JSON"
                ((errors++))
            fi
        fi
    else
        echo -e "  ${RED}✗${NC} Missing: $config"
        ((errors++))
    fi
done

# Check workflow files
echo -e "\n${YELLOW}Checking workflow documentation...${NC}"
workflows=(
    "workflows/development-patterns.md"
    "workflows/debugging-strategies.md"
    "templates/code-templates.md"
)
for workflow in "${workflows[@]}"; do
    if [[ -f "$HOME/.claude/$workflow" ]]; then
        echo -e "  ${GREEN}✓${NC} $workflow"
    else
        echo -e "  ${YELLOW}⚠${NC}  Missing: $workflow"
        ((warnings++))
    fi
done

# Check IDE integration
echo -e "\n${YELLOW}Checking IDE integration...${NC}"
ide_files=(
    "ide-integration/vscode.md"
    "ide-integration/jetbrains.md"
    "ide-integration/shortcuts.md"
)
for ide_file in "${ide_files[@]}"; do
    if [[ -f "$HOME/.claude/$ide_file" ]]; then
        echo -e "  ${GREEN}✓${NC} $ide_file"
    else
        echo -e "  ${YELLOW}⚠${NC}  Missing: $ide_file"
        ((warnings++))
    fi
done

# Check scripts
echo -e "\n${YELLOW}Checking helper scripts...${NC}"
scripts=(
    "scripts/get-api-key.sh"
    "terminal-setup.sh"
    "verify.sh"
)
for script in "${scripts[@]}"; do
    if [[ -x "$HOME/.claude/$script" ]]; then
        echo -e "  ${GREEN}✓${NC} $script (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $script"
        ((errors++))
    fi
done

# Check MCP servers configuration
echo -e "\n${YELLOW}Checking MCP configuration...${NC}"
if [[ -f "$HOME/.claude/mcp.json" ]]; then
    server_count=$(jq -r '\''.servers | length'\'' "$HOME/.claude/mcp.json" 2>/dev/null || echo 0)
    if [[ $server_count -ge 5 ]]; then
        echo -e "  ${GREEN}✓${NC} $server_count MCP servers configured"
        ((features++))
    else
        echo -e "  ${YELLOW}⚠${NC}  Only $server_count MCP servers"
        ((warnings++))
    fi
fi

# Feature summary
echo -e "\n${YELLOW}Feature Summary${NC}"
echo "==============="
check_feature $([[ -f "$HOME/.claude/hooks/tool-usage.sh" ]] && echo 0 || echo 1) "Simple audit logging"
check_feature $([[ -d "$HOME/.claude/workflows" ]] && echo 0 || echo 1) "Workflow patterns"
check_feature $([[ -d "$HOME/.claude/templates" ]] && echo 0 || echo 1) "Code templates"
check_feature $([[ -d "$HOME/.claude/ide-integration" ]] && echo 0 || echo 1) "IDE integration guides"
echo -e "  ${GREEN}✓${NC} NO analytics or metrics collection"

# Summary
echo -e "\n${YELLOW}Verification Summary${NC}"
echo "===================="
if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ All checks passed! Expert system fully configured without analytics.${NC}"
        echo -e "${GREEN}   Total features enabled: $features${NC}"
    else
        echo -e "${GREEN}✅ Setup complete with $warnings warnings.${NC}"
        echo -e "${GREEN}   Total features enabled: $features${NC}"
    fi
else
    echo -e "${RED}❌ Found $errors errors. Please review and fix.${NC}"
fi

echo -e "\n${YELLOW}Quick Start Commands:${NC}"
echo "1. Run '\''claude'\'' to start Claude Code"
echo "2. Use '\''claude mcp list'\'' to see configured MCP servers"
echo "3. Try '\''/<tab>'\'' in Claude to see all slash commands"
echo "4. Run '\''~/.claude/terminal-setup.sh'\'' for terminal config"
echo "5. Check '\''~/.claude/ide-integration/'\'' for IDE setup guides"
echo ""
echo "All features enabled except analytics/metrics!"'

handle_file_conflict "$CLAUDE_HOME/verify.sh" "$VERIFY_SCRIPT" "comprehensive verification script"
chmod +x "$CLAUDE_HOME/verify.sh" 2>/dev/null || true

# Create a quick reference card
QUICK_REFERENCE='# Claude Code Expert - Quick Reference (No Analytics Edition)

## Essential Commands
- `claude` - Start interactive session
- `claude -c` - Continue last conversation
- `claude -p "prompt"` - Non-interactive execution
- `claude mcp list` - List MCP servers
- `claude update` - Update Claude Code

## Slash Commands (Highlights)
- `/quickfix` - Quick fixes
- `/explain` - Clear explanations
- `/component` - Create components
- `/endpoint` - Create API endpoints
- `/performance` - Performance analysis
- `/security-audit` - Security review
- `/debug` - Advanced debugging
- `/code-review` - Code review
- `/refactor` - Guided refactoring
- `/pr` - Prepare pull requests

## Keyboard Shortcuts
- `Ctrl+C` - Cancel operation
- `Ctrl+L` - Clear screen
- `\` + `Enter` - Multiline input
- `Tab` - Path completion
- `/` + `Tab` - Command completion

## Pro Tips
1. Use "think harder" for complex analysis
2. Drag & drop images for UI implementation
3. Use @mentions for MCP resources
4. Add # prefix to save to memory
5. Combine tools for powerful workflows

## File Locations
- Settings: `~/.claude/settings.json`
- Commands: `~/.claude/commands/`
- Logs: `~/.claude/logs/`
- Backups: `~/.claude/backups/`
- Memory: `~/.claude/CLAUDE.md`

## What'\''s Different
This setup includes ALL features from the official docs EXCEPT:
- ❌ No performance metrics tracking
- ❌ No tool usage statistics
- ❌ No prompt categorization analytics
- ❌ No session duration tracking
- ✅ Simple audit logging only
- ✅ All other features remain!'

handle_file_conflict "$CLAUDE_HOME/QUICK_REFERENCE.md" "$QUICK_REFERENCE" "quick reference card"

# Final summary
echo -e "\n${GREEN}✅ Claude Expert No Analytics Setup Complete!${NC}"
echo -e "\n${YELLOW}What's been configured:${NC}"
echo "- 🔒 Comprehensive security validation for all tools"
echo "- 💾 Automatic backups for all file modifications"
echo "- 🧹 Enhanced auto-formatting for many languages"
echo "- 📝 Simple audit logging (NO analytics/metrics)"
echo "- 🚀 15+ slash commands covering all workflows"
echo "- 🔧 All 7 hook types for complete control"
echo "- 📁 10+ MCP server configurations"
echo "- 📝 Comprehensive CLAUDE.md with all features"
echo "- 🖥️  IDE integration guides and shortcuts"
echo "- 📚 Workflow patterns and code templates"

echo -e "\n${YELLOW}Analytics/Metrics Removed:${NC}"
echo "- ❌ Tool usage statistics (tool-stats.json)"
echo "- ❌ Prompt categorization (prompt-categories.json)"
echo "- ❌ Session duration tracking"
echo "- ❌ Agent performance metrics (agent-metrics.json)"
echo "- ❌ Performance timing calculations"
echo "- ❌ Session statistics (session-stats.json)"
echo "- ✅ Kept simple logging for audit trail"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Run ${GREEN}~/.claude/verify.sh${NC} to verify installation"
echo "2. Run ${GREEN}~/.claude/terminal-setup.sh${NC} for terminal config"
echo "3. Explore ${GREEN}~/.claude/commands/${NC} for all slash commands"
echo "4. Check ${GREEN}~/.claude/QUICK_REFERENCE.md${NC} for quick help"
echo "5. Configure MCP servers with ${GREEN}claude mcp add${NC}"
echo "6. Start using Claude Code with ${GREEN}claude${NC}"

echo -e "\n${BLUE}This setup includes ALL features from the official documentation${NC}"
echo -e "${BLUE}except analytics and metrics collection!${NC}"
echo -e "${BLUE}Documentation: https://docs.anthropic.com/en/docs/claude-code${NC}"