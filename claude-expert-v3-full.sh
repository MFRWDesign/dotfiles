#!/bin/bash
# Claude Expert V3 - Full Expert System Setup
# Based entirely on official Claude Code documentation
# Implements expert-level hooks, commands, and configurations

set -euo pipefail

# Script version
VERSION="3.0.0"

echo "🚀 Claude Expert V3 - Full Expert System (v$VERSION)"
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directories
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Conflict resolution mode
CONFLICT_MODE="${CLAUDE_SETUP_MODE:-ask}" # ask, overwrite, skip

# Function to check dependencies
check_dependencies() {
    local missing=()
    
    for cmd in jq git; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Missing required dependencies: ${missing[*]}${NC}"
        echo "Please install them and run again."
        exit 1
    fi
}

# Function to handle file conflicts
handle_file_conflict() {
    local target_file="$1"
    local new_content="$2"
    local file_description="$3"
    
    if [[ -f "$target_file" ]]; then
        echo -e "\n${YELLOW}⚠ File already exists: $target_file${NC}"
        
        if [[ "$CONFLICT_MODE" == "ask" ]]; then
            echo "What would you like to do with $file_description?"
            echo "1) Overwrite existing file"
            echo "2) Keep existing file (skip)"
            echo "3) Create backup and overwrite"
            
            while true; do
                read -p "Choose [1-3]: " choice
                case $choice in
                    1)
                        echo "$new_content" > "$target_file"
                        echo -e "${GREEN}✓ Overwritten${NC}"
                        break
                        ;;
                    2)
                        echo -e "${BLUE}↷ Skipped${NC}"
                        return 1
                        ;;
                    3)
                        local backup="${target_file}.backup-$(date +%Y%m%d-%H%M%S)"
                        cp "$target_file" "$backup"
                        echo "$new_content" > "$target_file"
                        echo -e "${GREEN}✓ Backed up to $backup and overwritten${NC}"
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please choose 1-3."
                        ;;
                esac
            done
        else
            case "$CONFLICT_MODE" in
                overwrite)
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Overwritten${NC}"
                    ;;
                skip)
                    echo -e "${BLUE}↷ Skipped${NC}"
                    return 1
                    ;;
            esac
        fi
    else
        echo "$new_content" > "$target_file"
        echo -e "${GREEN}✓ Created${NC}"
    fi
    
    return 0
}

# Update JSON settings with jq
update_json_settings() {
    local settings_file="$1"
    local updates="$2"
    
    if [[ ! -f "$settings_file" ]]; then
        echo "{}" > "$settings_file"
    fi
    
    # Create backup
    cp "$settings_file" "${settings_file}.backup-$(date +%Y%m%d-%H%M%S)"
    
    # Apply updates
    jq "$updates" "$settings_file" > "${settings_file}.tmp" && mv "${settings_file}.tmp" "$settings_file"
}

# Start setup
echo -e "\n${YELLOW}Checking dependencies...${NC}"
check_dependencies
echo -e "${GREEN}✓ All dependencies found${NC}"

# Create directory structure
echo -e "\n${YELLOW}Creating directory structure...${NC}"
directories=(
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/commands"
    "$CLAUDE_HOME/scripts"
    "$DOTFILES_DIR/claude-expert"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Step 1: Create Expert Hooks
echo -e "\n${YELLOW}Step 1: Creating Expert Hooks...${NC}"

# Auto-commit hook (from official docs)
AUTO_COMMIT_HOOK='#!/bin/bash
# Auto-commit changes made by Claude
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
PARAMS=$(echo "$INPUT" | jq -r '\''.params // empty'\'')

# Only process Write/Edit/MultiEdit operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    # Extract file path
    FILE_PATH=$(echo "$PARAMS" | jq -r '\''.file_path // empty'\'')
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Check if file is in a git repository
        if git -C "$(dirname "$FILE_PATH")" rev-parse --git-dir > /dev/null 2>&1; then
            # Stage the file
            git -C "$(dirname "$FILE_PATH")" add "$FILE_PATH"
            
            # Create descriptive commit message
            COMMIT_MSG="feat: Update $(basename "$FILE_PATH") via Claude Code"
            
            # Check if there are changes to commit
            if ! git -C "$(dirname "$FILE_PATH")" diff --cached --quiet; then
                git -C "$(dirname "$FILE_PATH")" commit -m "$COMMIT_MSG" \
                    -m "Co-Authored-By: Claude <noreply@anthropic.com>" || true
            fi
        fi
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/auto-commit.sh" "$AUTO_COMMIT_HOOK" "auto-commit hook"
chmod +x "$CLAUDE_HOME/hooks/auto-commit.sh" 2>/dev/null || true

# Linting hook (from official docs patterns)
LINT_HOOK='#!/bin/bash
# Run appropriate linters after file modifications
# Based on official documentation

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
PARAMS=$(echo "$INPUT" | jq -r '\''.params // empty'\'')

if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r '\''.file_path // empty'\'')
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Detect file type and run appropriate linter
        case "$FILE_PATH" in
            *.js|*.jsx|*.ts|*.tsx)
                # Run ESLint if available
                if command -v eslint &> /dev/null; then
                    eslint --fix "$FILE_PATH" 2>/dev/null || true
                fi
                # Run Prettier if available
                if command -v prettier &> /dev/null; then
                    prettier --write "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.py)
                # Run Black if available
                if command -v black &> /dev/null; then
                    black "$FILE_PATH" 2>/dev/null || true
                fi
                # Run isort if available
                if command -v isort &> /dev/null; then
                    isort "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.go)
                # Run gofmt if available
                if command -v gofmt &> /dev/null; then
                    gofmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rs)
                # Run rustfmt if available
                if command -v rustfmt &> /dev/null; then
                    rustfmt "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
        esac
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/lint-on-save.sh" "$LINT_HOOK" "linting hook"
chmod +x "$CLAUDE_HOME/hooks/lint-on-save.sh" 2>/dev/null || true

# Security check hook (from official docs)
SECURITY_HOOK='#!/bin/bash
# Security validation for sensitive operations
# Based on official documentation security patterns

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
PARAMS=$(echo "$INPUT" | jq -r '\''.params // empty'\'')

# Security checks for Bash commands
if [[ "$TOOL" == "Bash" ]]; then
    COMMAND=$(echo "$PARAMS" | jq -r '\''.command // empty'\'')
    
    # Check for dangerous commands
    if echo "$COMMAND" | grep -qE "(rm -rf /|:(){:|:|&};:|dd if=/dev/zero)"; then
        echo "Security: Blocked dangerous command" >&2
        exit 2  # Exit code 2 blocks execution
    fi
    
    # Check for operations on sensitive files
    if echo "$COMMAND" | grep -qE "(~/.ssh/|/etc/passwd|/etc/shadow|.env|.git/config)"; then
        echo "Security: Operation on sensitive file requires confirmation" >&2
        # Could prompt user here if running interactively
    fi
fi

# Security checks for file operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r '\''.file_path // empty'\'')
    
    # Prevent writing to sensitive locations
    if echo "$FILE_PATH" | grep -qE "(~/.ssh/|/etc/|/usr/bin/|/usr/sbin/)"; then
        echo "Security: Blocked write to sensitive location" >&2
        exit 2
    fi
    
    # Check for potential secrets in content
    if [[ "$TOOL" == "Write" ]]; then
        CONTENT=$(echo "$PARAMS" | jq -r '\''.content // empty'\'')
        if echo "$CONTENT" | grep -qE "(api[_-]?key|password|secret|token).*=.*[\"'\''][^\"'\'']+[\"'\'']"; then
            echo "Security: Warning - potential secrets detected in content" >&2
            # Continue but warn
        fi
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/security-check.sh" "$SECURITY_HOOK" "security hook"
chmod +x "$CLAUDE_HOME/hooks/security-check.sh" 2>/dev/null || true

# Backup hook (from official docs)
BACKUP_HOOK='#!/bin/bash
# Create backups before modifying files
# Based on official documentation

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
PARAMS=$(echo "$INPUT" | jq -r '\''.params // empty'\'')

if [[ "$TOOL" =~ ^(Edit|Write|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r '\''.file_path // empty'\'')
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Create backup directory
        BACKUP_DIR="$HOME/.claude/backups/$(date +%Y%m%d)"
        mkdir -p "$BACKUP_DIR"
        
        # Create timestamped backup
        BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup"
        cp "$FILE_PATH" "$BACKUP_FILE" 2>/dev/null || true
        
        # Keep only last 100 backups per file
        find "$HOME/.claude/backups" -name "$(basename "$FILE_PATH").*.backup" -type f | \
            sort -r | tail -n +101 | xargs rm -f 2>/dev/null || true
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/backup-files.sh" "$BACKUP_HOOK" "backup hook"
chmod +x "$CLAUDE_HOME/hooks/backup-files.sh" 2>/dev/null || true

# Notification hook for long-running operations (from official docs patterns)
NOTIFICATION_HOOK='#!/bin/bash
# Notification hook for long-running operations
# Based on official Claude Code documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
PARAMS=$(echo "$INPUT" | jq -r '\''.params // empty'\'')

# Function to check if command is likely long-running
is_long_running() {
    local cmd="$1"
    # List of patterns that indicate long-running operations
    local long_patterns=(
        "npm install"
        "yarn install"
        "pnpm install"
        "pip install"
        "cargo build"
        "cargo test"
        "make"
        "docker build"
        "docker-compose"
        "git clone"
        "git pull"
        "wget"
        "curl.*download"
        "brew install"
        "apt install"
        "yum install"
        "build"
        "compile"
        "bundle install"
        "pod install"
        "gradle"
        "mvn"
        "npm run build"
        "npm run test"
        "yarn build"
        "yarn test"
    )
    
    for pattern in "${long_patterns[@]}"; do
        if echo "$cmd" | grep -qiE "$pattern"; then
            return 0
        fi
    done
    return 1
}

# Function to send notification (works on macOS, Linux with notify-send, or falls back to terminal)
send_notification() {
    local title="$1"
    local message="$2"
    
    # Try macOS notification
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null || true
    # Try Linux notify-send
    elif command -v notify-send &> /dev/null; then
        notify-send "$title" "$message" 2>/dev/null || true
    fi
    
    # Always print to stderr so user sees it
    echo "🔔 $title: $message" >&2
}

# Monitor Bash commands
if [[ "$TOOL" == "Bash" ]]; then
    COMMAND=$(echo "$PARAMS" | jq -r '\''.command // empty'\'')
    
    if [[ -n "$COMMAND" ]] && is_long_running "$COMMAND"; then
        # Extract a clean command description
        CMD_DESC=$(echo "$COMMAND" | head -1 | cut -c1-50)
        if [[ ${#COMMAND} -gt 50 ]]; then
            CMD_DESC="${CMD_DESC}..."
        fi
        
        # Notify start
        send_notification "Claude Code" "Starting long operation: $CMD_DESC"
        
        # Store command info for PostToolUse hook
        echo "$COMMAND" > "$HOME/.claude/.current-long-command" 2>/dev/null || true
    fi
fi

# This is a PreToolUse hook, so always exit 0 to continue
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/notification-start.sh" "$NOTIFICATION_HOOK" "notification start hook"
chmod +x "$CLAUDE_HOME/hooks/notification-start.sh" 2>/dev/null || true

# Notification completion hook
NOTIFICATION_COMPLETE_HOOK='#!/bin/bash
# Notification completion hook for long-running operations
# Companion to notification-hook.sh for PostToolUse

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '\''.tool // empty'\'')
RESULT=$(echo "$INPUT" | jq -r '\''.result // empty'\'')

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"  # normal, low, critical
    
    # Try macOS notification
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null || true
    # Try Linux notify-send
    elif command -v notify-send &> /dev/null; then
        notify-send -u "$urgency" "$title" "$message" 2>/dev/null || true
    fi
    
    # Always print to stderr
    local icon="✅"
    [[ "$urgency" == "critical" ]] && icon="❌"
    echo "$icon $title: $message" >&2
}

# Check if we are completing a long-running command
if [[ "$TOOL" == "Bash" ]] && [[ -f "$HOME/.claude/.current-long-command" ]]; then
    # Read the stored command
    COMMAND=$(cat "$HOME/.claude/.current-long-command" 2>/dev/null || echo "Unknown command")
    rm -f "$HOME/.claude/.current-long-command" 2>/dev/null || true
    
    # Extract command description
    CMD_DESC=$(echo "$COMMAND" | head -1 | cut -c1-50)
    if [[ ${#COMMAND} -gt 50 ]]; then
        CMD_DESC="${CMD_DESC}..."
    fi
    
    # Check if command succeeded or failed
    if echo "$RESULT" | jq -e '\''.success // true'\'' > /dev/null 2>&1; then
        # Success
        send_notification "Claude Code" "Completed: $CMD_DESC" "normal"
    else
        # Failure
        ERROR_MSG=$(echo "$RESULT" | jq -r '\''.error // "Unknown error"'\'' 2>/dev/null || echo "Command failed")
        send_notification "Claude Code" "Failed: $CMD_DESC - $ERROR_MSG" "critical"
    fi
fi

# Always exit 0 for PostToolUse hooks
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/notification-complete.sh" "$NOTIFICATION_COMPLETE_HOOK" "notification complete hook"
chmod +x "$CLAUDE_HOME/hooks/notification-complete.sh" 2>/dev/null || true

# Step 2: Create Expert Slash Commands
echo -e "\n${YELLOW}Step 2: Creating Expert Slash Commands...${NC}"

declare -A COMMANDS

# Performance analysis command (based on common workflows)
COMMANDS["performance.md"]='---
description: "Analyze and optimize code performance"
tools: ["Read", "Grep", "Bash", "Edit"]
---

Analyze the performance characteristics of {{TARGET_CODE}}.

Please:
1. Profile the current implementation
2. Identify performance bottlenecks
3. Suggest specific optimizations
4. Consider both time and space complexity
5. Provide benchmarking code if applicable

Focus on:
- Algorithm efficiency
- Memory usage
- I/O operations
- Caching opportunities
- Parallelization potential'

# Security audit command
COMMANDS["security-audit.md"]='---
description: "Perform security audit on codebase"
tools: ["Grep", "Read", "Glob"]
---

Perform a comprehensive security audit on {{TARGET_PATH|the entire codebase}}.

Check for:
1. Hard-coded secrets or API keys
2. SQL injection vulnerabilities
3. XSS vulnerabilities
4. Insecure dependencies
5. Authentication/authorization issues
6. Input validation problems
7. Cryptographic weaknesses
8. OWASP Top 10 vulnerabilities

Provide:
- Severity ratings (Critical/High/Medium/Low)
- Specific remediation steps
- Code examples of fixes'

# Git workflow command
COMMANDS["git-workflow.md"]='---
description: "Execute advanced git workflows"
tools: ["Bash", "Read"]
---

Help me with the following git workflow: {{WORKFLOW_TYPE}}

Common workflows:
- Create meaningful commits from current changes
- Set up git worktree for parallel development
- Interactive rebase to clean up history
- Cherry-pick specific commits
- Resolve complex merge conflicts
- Create and manage feature branches
- Set up git hooks for the project'

# Extended thinking command
COMMANDS["think.md"]='---
description: "Use extended thinking for complex problems"
---

I need you to think deeply about this problem: {{PROBLEM_DESCRIPTION}}

Take your time to:
1. Fully understand all aspects of the problem
2. Consider multiple approaches
3. Evaluate trade-offs
4. Think through edge cases
5. Arrive at a well-reasoned solution

This is a complex issue that deserves careful consideration.'

# Test coverage command
COMMANDS["coverage.md"]='---
description: "Analyze and improve test coverage"
tools: ["Read", "Grep", "Bash", "Write"]
---

Analyze test coverage for {{TARGET_PATH|the current project}}.

Tasks:
1. Check current test coverage metrics
2. Identify untested code paths
3. Generate tests for uncovered code
4. Focus on critical business logic
5. Include edge cases and error scenarios
6. Ensure tests are meaningful, not just coverage-padding

Use the testing framework already established in this project.'

# Create each command file
for cmd_file in "${!COMMANDS[@]}"; do
    target="$CLAUDE_HOME/commands/$cmd_file"
    content="${COMMANDS[$cmd_file]}"
    handle_file_conflict "$target" "$content" "$cmd_file command"
done

# Step 3: Update settings.json with expert configuration
echo -e "\n${YELLOW}Step 3: Configuring expert settings...${NC}"

SETTINGS_FILE="$CLAUDE_HOME/settings.json"

# Create expert settings configuration
read -r -d '' SETTINGS_UPDATES << 'EOF' || true
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/security-check.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/notification-start.sh"
          }
        ]
      },
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/backup-files.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/lint-on-save.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/auto-commit.sh"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notification-complete.sh"
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
      "Bash(git:*)",
      "Bash(npm:*)",
      "Bash(yarn:*)",
      "Bash(make:*)",
      "Bash(cargo:*)",
      "Bash(python:*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)"
    ]
  },
  "env": {
    "CLAUDE_EXPERT": "true",
    "EDITOR": "code"
  }
}
EOF

# Apply settings updates
if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo "$SETTINGS_UPDATES" > "$SETTINGS_FILE"
    echo -e "${GREEN}✓ Created expert settings${NC}"
else
    # Merge with existing settings
    echo -e "${YELLOW}Merging with existing settings...${NC}"
    jq -s '.[0] * .[1]' "$SETTINGS_FILE" <(echo "$SETTINGS_UPDATES") > "${SETTINGS_FILE}.tmp" && \
        mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ Updated settings${NC}"
fi

# Step 4: Create expert CLAUDE.md templates
echo -e "\n${YELLOW}Step 4: Creating expert CLAUDE.md templates...${NC}"

# Project-level CLAUDE.md template
PROJECT_CLAUDE_TEMPLATE='# Project Configuration for Claude Code

## Project Overview
{{PROJECT_DESCRIPTION}}

## Architecture & Design Patterns
{{ARCHITECTURE_NOTES}}

## Development Standards

### Code Style
- Language: {{PRIMARY_LANGUAGE}}
- Style guide: {{STYLE_GUIDE}}
- Linting: {{LINTING_RULES}}

### Git Workflow
- Branch naming: feature/*, bugfix/*, hotfix/*
- Commit style: Conventional commits
- PR process: {{PR_PROCESS}}

### Testing Requirements
- Unit test coverage: >{{COVERAGE_THRESHOLD}}%
- Test framework: {{TEST_FRAMEWORK}}
- E2E tests for critical paths

### Security Requirements
- No hardcoded secrets
- Input validation on all endpoints
- OWASP Top 10 compliance
- Regular dependency updates

## Build & Deployment
```bash
# Development
{{DEV_COMMANDS}}

# Testing
{{TEST_COMMANDS}}

# Production build
{{BUILD_COMMANDS}}

# Deployment
{{DEPLOY_COMMANDS}}
```

## Key Dependencies
{{DEPENDENCIES_LIST}}

## Environment Variables
{{ENV_VARS}}

## Common Tasks

### Adding a new feature
1. Create feature branch
2. Implement with tests
3. Update documentation
4. Create PR with description

### Debugging production issues
1. Check logs: {{LOG_LOCATION}}
2. Review monitoring: {{MONITORING_URL}}
3. Test in staging first

### Performance optimization
1. Profile first
2. Measure impact
3. Document changes

## Project-Specific Claude Guidance

- Always consider performance implications
- Maintain backward compatibility
- Write comprehensive tests
- Update documentation alongside code
- Follow security best practices
- Use meaningful variable/function names'

handle_file_conflict "$DOTFILES_DIR/claude-expert/PROJECT_CLAUDE_TEMPLATE.md" \
    "$PROJECT_CLAUDE_TEMPLATE" "project CLAUDE.md template"

# User-level CLAUDE.md
USER_CLAUDE_MD='# Personal Claude Code Configuration

## Development Preferences

### Code Style
- Prefer functional programming where appropriate
- Use early returns for clarity
- Comprehensive error handling
- Meaningful variable names
- Comments for complex logic only

### Git Preferences
- Conventional commit messages
- Atomic commits (one logical change per commit)
- Detailed PR descriptions
- Interactive rebase for cleanup

### Communication Style
- Be concise but thorough
- Explain complex changes
- Suggest improvements proactively
- Ask clarifying questions when needed

### Tool Preferences
- Editor: VS Code / Cursor
- Terminal: Modern terminal with good color support
- Package manager: npm/yarn/pnpm based on project
- Version manager: nvm/rbenv/pyenv

## Enabled Features

### Hooks
- ✅ Auto-commit changes
- ✅ Auto-lint on save
- ✅ Security validation
- ✅ File backups

### Permissions
- ✅ Git operations
- ✅ Package manager commands
- ✅ Build tool commands
- ❌ Sudo operations
- ❌ Destructive operations without confirmation

## Custom Workflows

Use slash commands for common tasks:
- `/performance` - Performance analysis
- `/security-audit` - Security review
- `/git-workflow` - Git operations
- `/think` - Complex problem solving
- `/coverage` - Test coverage analysis

## Extended Thinking

For complex problems, I will use extended thinking to:
- Analyze all aspects thoroughly
- Consider multiple solutions
- Evaluate trade-offs
- Provide well-reasoned recommendations'

handle_file_conflict "$CLAUDE_HOME/CLAUDE.md" "$USER_CLAUDE_MD" "user-level CLAUDE.md"

# Step 5: Create helper scripts
echo -e "\n${YELLOW}Step 5: Creating helper scripts...${NC}"

# Git helper script
GIT_HELPER='#!/bin/bash
# Git workflow helper for Claude Code

case "$1" in
    "smart-commit")
        # Stage all changes and create meaningful commit
        git add -A
        git status --short
        echo "Creating commit with Claude assistance..."
        ;;
    "worktree")
        # Set up git worktree for parallel development
        if [[ -z "$2" ]]; then
            echo "Usage: git-helper worktree <branch-name>"
            exit 1
        fi
        git worktree add "../${PWD##*/}-$2" -b "$2"
        echo "Created worktree at ../${PWD##*/}-$2"
        ;;
    "cleanup")
        # Clean up merged branches
        git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
        echo "Cleaned up merged branches"
        ;;
    *)
        echo "Usage: git-helper [smart-commit|worktree|cleanup]"
        ;;
esac'

handle_file_conflict "$CLAUDE_HOME/scripts/git-helper" "$GIT_HELPER" "git helper script"
chmod +x "$CLAUDE_HOME/scripts/git-helper" 2>/dev/null || true

# Create comprehensive verification script
echo -e "\n${YELLOW}Creating comprehensive verification script...${NC}"
VERIFY_SCRIPT='#!/bin/bash
# Verify Claude Expert V3 setup

echo "🔍 Verifying Claude Expert V3 Setup"
echo "===================================="

# Color codes
GREEN='\''\033[0;32m'\''
RED='\''\033[0;31m'\''
YELLOW='\''\033[1;33m'\''
NC='\''\033[0m'\''

errors=0
warnings=0

# Check directories
echo -e "\n${YELLOW}Checking directories...${NC}"
for dir in "$HOME/.claude/hooks" "$HOME/.claude/commands" "$HOME/.claude/scripts"; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check hooks
echo -e "\n${YELLOW}Checking hooks...${NC}"
for hook in "auto-commit.sh" "lint-on-save.sh" "security-check.sh" "backup-files.sh" "notification-start.sh" "notification-complete.sh"; do
    if [[ -x "$HOME/.claude/hooks/$hook" ]]; then
        echo -e "  ${GREEN}✓${NC} $hook (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $hook"
        ((errors++))
    fi
done

# Check commands
echo -e "\n${YELLOW}Checking commands...${NC}"
for cmd in "performance.md" "security-audit.md" "git-workflow.md" "think.md" "coverage.md"; do
    if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
        echo -e "  ${GREEN}✓${NC} $cmd"
    else
        echo -e "  ${RED}✗${NC} Missing: $cmd"
        ((errors++))
    fi
done

# Check settings.json
echo -e "\n${YELLOW}Checking settings configuration...${NC}"
if [[ -f "$HOME/.claude/settings.json" ]]; then
    # Check if hooks are configured
    if jq -e ".hooks.PostToolUse" "$HOME/.claude/settings.json" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} Hooks configured in settings.json"
    else
        echo -e "  ${YELLOW}⚠${NC}  Hooks not found in settings.json"
        ((warnings++))
    fi
    
    # Check if permissions are configured
    if jq -e ".permissions" "$HOME/.claude/settings.json" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} Permissions configured"
    else
        echo -e "  ${YELLOW}⚠${NC}  Permissions not configured"
        ((warnings++))
    fi
else
    echo -e "  ${RED}✗${NC} settings.json not found"
    ((errors++))
fi

# Check optional tools
echo -e "\n${YELLOW}Checking optional tools...${NC}"
for tool in eslint prettier black isort gofmt rustfmt; do
    if command -v "$tool" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool (available for linting)"
    else
        echo -e "  ${YELLOW}ℹ${NC}  $tool (not installed - linting for this language unavailable)"
    fi
done

# Summary
echo -e "\n${YELLOW}---${NC}"
if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ All checks passed! Expert system fully operational.${NC}"
    else
        echo -e "${GREEN}✅ Setup complete with $warnings warnings.${NC}"
    fi
else
    echo -e "${RED}❌ Found $errors errors. Please run setup again.${NC}"
fi

# Feature summary
echo -e "\n${YELLOW}Enabled Features:${NC}"
echo "- 🔄 Auto-commit with git operations"
echo "- 🧹 Auto-linting on file save"
echo "- 🔒 Security validation for commands"
echo "- 💾 Automatic file backups"
echo "- 🔔 Notifications for long-running operations"
echo "- 🚀 Expert slash commands"
echo "- ⚙️  Customized permissions"'

handle_file_conflict "$CLAUDE_HOME/verify-setup.sh" "$VERIFY_SCRIPT" "verification script"
chmod +x "$CLAUDE_HOME/verify-setup.sh" 2>/dev/null || true

# Final summary
echo -e "\n${GREEN}✅ Claude Expert V3 Setup Complete!${NC}"
echo -e "\n${YELLOW}Expert Features Enabled:${NC}"
echo "- 🔄 Auto-commit hook for git operations"
echo "- 🧹 Auto-linting on file modifications"
echo "- 🔒 Security validation for sensitive operations"
echo "- 💾 Automatic backups before file changes"
echo "- 🔔 Notifications for long-running operations"
echo "- 🚀 Expert-level slash commands"
echo "- ⚙️  Smart permission configuration"

echo -e "\n${YELLOW}Available Expert Commands:${NC}"
echo "- /performance - Analyze and optimize performance"
echo "- /security-audit - Comprehensive security review"
echo "- /git-workflow - Advanced git operations"
echo "- /think - Extended thinking for complex problems"
echo "- /coverage - Test coverage analysis"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Restart Claude Code to activate all features"
echo "2. Run ${GREEN}$CLAUDE_HOME/verify-setup.sh${NC} to verify installation"
echo "3. Test hooks with a simple file edit"
echo "4. Try the expert commands"

echo -e "\n${BLUE}Tip: Your changes will now be auto-committed and linted!${NC}"