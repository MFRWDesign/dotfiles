#!/bin/bash
# Claude Code Expert Environment Setup Script
# Run this to configure your system with all expert-level automations

set -e

CLAUDE_HOME="$HOME/.claude"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up Claude Code Expert Environment..."

# Check for recommended tools
echo "🔍 Checking for recommended tools..."
MISSING_TOOLS=()

# Python tools
for tool in black isort mypy flake8 pytest; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS+=("Python: $tool")
    fi
done

# JavaScript tools
for tool in prettier eslint; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS+=("JavaScript: $tool")
    fi
done

# Shell tools
if ! command -v shellcheck &> /dev/null; then
    MISSING_TOOLS+=("Shell: shellcheck")
fi

# Docker for YOLO mode
if ! command -v docker &> /dev/null; then
    MISSING_TOOLS+=("Docker (for YOLO mode)")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "⚠️  Optional tools not found (hooks may have reduced functionality):"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "   - $tool"
    done
    echo ""
    echo "💡 You can install these later for full functionality."
    echo "   Python tools: pip install black isort mypy flake8 pytest bandit"
    echo "   JavaScript tools: npm install -g prettier eslint typescript"
    echo "   Shell tools: brew install shellcheck"
    echo "   Docker: https://www.docker.com/products/docker-desktop/"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled. Install tools and try again."
        exit 1
    fi
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$CLAUDE_HOME"/{commands,hooks,scripts,templates,memories,logs,cache,backups}

# Install global preferences if not exists
if [ ! -f "$CLAUDE_HOME/CLAUDE.md" ]; then
    echo "📝 Creating personal CLAUDE.md..."
    cat > "$CLAUDE_HOME/CLAUDE.md" << 'EOF'
# Personal Claude Code Preferences

## 🎯 Core Principles
- Always write tests for new code
- Prefer functional programming patterns
- Use descriptive variable names
- Document complex logic
- Think about edge cases

## 🛡️ Safety Rules
- Never process files with secrets
- Always backup before major changes
- Run tests after modifications
- Review AI suggestions critically

## 🚀 Performance Guidelines
- Use Grep before Read for searches
- Batch operations when possible
- Compress context regularly
- Cache repetitive operations

## 📋 Workflow Preferences
- Commit early and often
- Use conventional commits
- Create PRs with comprehensive descriptions
- Update documentation with code changes

@~/.claude/memories/languages.md
@~/.claude/memories/frameworks.md
@~/.claude/memories/patterns.md
EOF
fi

# Create memory modules
echo "🧠 Setting up memory modules..."
cat > "$CLAUDE_HOME/memories/languages.md" << 'EOF'
# Language-Specific Guidelines

## Python
- Follow PEP 8 style guide
- Use type hints for function signatures
- Prefer f-strings for formatting
- Use dataclasses for data structures

## JavaScript/TypeScript
- Use ES6+ features
- Prefer const over let
- Use async/await over promises
- Add JSDoc comments

## Go
- Follow effective Go guidelines
- Keep functions small and focused
- Handle errors explicitly
- Use meaningful package names
EOF

# Install essential custom commands
echo "⚡ Installing custom commands..."

# Code review command - ELITE VERSION
cat > "$CLAUDE_HOME/commands/review.md" << 'EOF'
---
description: "Review and FIX all issues - NOT just report!"
tools: ["Read", "Edit", "MultiEdit", "Grep", "Bash"]
---
⚠️ This is NOT a reporting task - this is a FIXING task!

Review the code at $ARGUMENTS and:
1. Identify ALL issues
2. FIX every single one immediately
3. Verify everything is GREEN
4. Do NOT stop until perfect

Check for:
- Security vulnerabilities → PATCH THEM
- Performance issues → OPTIMIZE THEM
- Code quality problems → REFACTOR THEM
- Missing tests → WRITE THEM
- Documentation gaps → FILL THEM

Use multiple agents if needed for parallel fixes.

FORBIDDEN responses:
❌ "Here are the issues I found"
❌ "The code has these problems"
❌ "Consider fixing..."

REQUIRED: Fix EVERYTHING until 100% production-ready!
EOF

# Refactor command
cat > "$CLAUDE_HOME/commands/refactor.md" << 'EOF'
---
description: "Intelligent refactoring assistant"
tools: ["Read", "Edit", "Grep"]
---
Refactor the code at $ARGUMENTS following these steps:

1. Analyze current structure
2. Identify improvement opportunities
3. Present refactoring plan for approval
4. Implement approved changes
5. Ensure tests still pass

Focus on:
- Extracting repeated code
- Improving naming
- Reducing complexity
- Adding type safety
EOF

# Debug command
cat > "$CLAUDE_HOME/commands/debug.md" << 'EOF'
---
description: "Smart debugging assistant"
tools: ["Read", "Edit", "Bash", "Grep"]
---
Debug the issue: $ARGUMENTS

think harder about edge cases

1. Reproduce the issue
2. Analyze error messages and logs
3. Check recent changes (git log)
4. Identify root cause
5. Implement and test fix
6. Add regression test
EOF

# Elite check command
cat > "$CLAUDE_HOME/commands/check.md" << 'EOF'
---
description: "Check and FIX everything until GREEN"
tools: ["Read", "Edit", "MultiEdit", "Bash", "Grep"]
---
⚠️ CRITICAL: This is a FIXING task, not reporting!

Check $ARGUMENTS for ALL issues and FIX them:
- Lint violations → FIX THEM
- Test failures → RESOLVE THEM  
- Security issues → PATCH THEM
- Type errors → CORRECT THEM
- Dead code → REMOVE IT

DO NOT STOP until you see:
✅ All checks passed!
✅ 100% GREEN
✅ Ready for production

Use multiple agents for parallel fixes if needed.
EOF

# Ultrathink command
cat > "$CLAUDE_HOME/commands/ultrathink.md" << 'EOF'
---
description: "Deepest architectural analysis"
---
ULTRATHINK MODE ACTIVATED for: $ARGUMENTS

Perform the deepest level of analysis considering:
- System-wide implications
- Long-term consequences
- Security ramifications
- Performance impacts
- Maintenance burden
- Team velocity effects
- Technical debt implications

Think from multiple perspectives:
- Current developer
- Future maintainer
- System architect
- Security auditor
- DevOps engineer
- End user

Generate comprehensive analysis with trade-offs.
EOF

# Sacred workflow command
cat > "$CLAUDE_HOME/commands/implement.md" << 'EOF'
---
description: "Enforce the sacred workflow"
---
⚠️ SACRED WORKFLOW CHECK for: $ARGUMENTS

Have you completed:
1. ✓ RESEARCH phase? (understand codebase)
2. ✓ PLAN phase? (detailed implementation plan)
3. ✓ APPROVAL? (plan reviewed and approved)

If NO → Start with: "Research the codebase for implementing $ARGUMENTS"
If YES → Proceed with implementation including:
- Reality checkpoints after each major step
- Immediate fixes for any issues
- Zero tolerance for errors
EOF

# Install safety hooks
echo "🛡️ Installing safety hooks..."

# Pre-tool-use hook for dangerous command protection
cat > "$CLAUDE_HOME/hooks/preToolUse.sh" << 'EOF'
#!/bin/bash
# Zero-tolerance safety hook

# Check for dangerous patterns
if [[ "$TOOL_NAME" == "Bash" ]]; then
    DANGEROUS_PATTERNS=(
        "rm -rf /"
        "rm -rf ~"
        "rm -rf \$HOME"
        ":(){ :|:& };:"
        "dd if=/dev/random"
        "dd of=/dev/[sh]d"
        "mkfs"
        "DROP DATABASE"
        "DROP TABLE"
        "DELETE FROM.*WHERE 1"
        "git push.*--force.*\(master\|main\)"
        "git push.*\(master\|main\).*--force"
        "sudo rm"
        "chmod 777"
        "chmod.*-R.*777"
        "> */dev/[sh]d"
        "fork bomb"
        ":(){ :|"
    )
    
    for pattern in "${DANGEROUS_PATTERNS[@]}"; do
        if [[ "$TOOL_INPUT" =~ $pattern ]]; then
            echo "❌ BLOCKED: Dangerous command pattern detected: $pattern"
            echo "🚨 This operation could cause irreversible damage!"
            exit 1
        fi
    done
    
    # Production operations require explicit confirmation
    if [[ "$TOOL_INPUT" =~ production|prod ]] && [[ ! "$TOOL_INPUT" =~ "--dry-run" ]]; then
        echo "⚠️  BLOCKED: Production operation requires --dry-run first"
        echo "📋 After dry-run verification, use --production-confirmed flag"
        exit 1
    fi
fi

# Log all operations with context
LOG_ENTRY="$(date +%Y-%m-%d\ %H:%M:%S)|$TOOL_NAME|$FILE_PATH|$TOOL_INPUT|$PWD"
echo "$LOG_ENTRY" >> "$HOME/.claude/logs/tools.log"

# Backup tracking for recovery
if [[ "$TOOL_NAME" == "Edit" ]] || [[ "$TOOL_NAME" == "Write" ]]; then
    echo "$LOG_ENTRY|BACKUP_PENDING" >> "$HOME/.claude/logs/backup-queue.log"
fi
EOF

# Post-tool-use hook for ZERO-TOLERANCE quality enforcement
cat > "$CLAUDE_HOME/hooks/postToolUse.sh" << 'EOF'
#!/bin/bash
# Zero-tolerance quality enforcement hook

ISSUES_FOUND=0
ISSUE_REPORT=""

# Helper function to add issues
add_issue() {
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    ISSUE_REPORT="${ISSUE_REPORT}\n❌ $1"
}

# Only check files that were edited
if [[ "$TOOL_NAME" == "Edit" ]] || [[ "$TOOL_NAME" == "Write" ]]; then
    echo "🔍 Zero-tolerance quality check for $FILE_PATH"
    
    # Create backup FIRST
    BACKUP_DIR="$HOME/.claude/backups/$(date +%Y%m%d)"
    mkdir -p "$BACKUP_DIR"
    cp "$FILE_PATH" "$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%s).bak"
    
    # Check based on file type
    case "$FILE_PATH" in
        *.py)
            echo "🐍 Python quality checks..."
            # Formatting
            if ! black --check "$FILE_PATH" 2>/dev/null; then
                black "$FILE_PATH"
                add_issue "Python formatting (auto-fixed with black)"
            fi
            if ! isort --check "$FILE_PATH" 2>/dev/null; then
                isort "$FILE_PATH"
                add_issue "Import sorting (auto-fixed with isort)"
            fi
            # Type checking
            mypy "$FILE_PATH" 2>/dev/null || add_issue "Type errors detected by mypy"
            # Linting
            flake8 "$FILE_PATH" 2>/dev/null || add_issue "Linting errors from flake8"
            # Security
            bandit -q "$FILE_PATH" 2>/dev/null || add_issue "Security issues found by bandit"
            # Tests
            TEST_FILE="${FILE_PATH%.py}_test.py"
            if [ -f "$TEST_FILE" ]; then
                pytest "$TEST_FILE" -v 2>/dev/null || add_issue "Tests failing"
            else
                add_issue "No test file found for $FILE_PATH"
            fi
            ;;
            
        *.js|*.ts|*.jsx|*.tsx)
            echo "📦 JavaScript/TypeScript quality checks..."
            # Formatting
            if ! prettier --check "$FILE_PATH" 2>/dev/null; then
                prettier --write "$FILE_PATH"
                add_issue "Formatting (auto-fixed with prettier)"
            fi
            # Linting
            eslint "$FILE_PATH" 2>/dev/null || add_issue "ESLint violations"
            # Type checking for TS
            if [[ "$FILE_PATH" == *.ts ]] || [[ "$FILE_PATH" == *.tsx ]]; then
                tsc --noEmit "$FILE_PATH" 2>/dev/null || add_issue "TypeScript errors"
            fi
            ;;
            
        *.go)
            echo "🐹 Go quality checks..."
            # Formatting
            if gofmt -l "$FILE_PATH" | grep -q .; then
                gofmt -w "$FILE_PATH"
                add_issue "Formatting (auto-fixed with gofmt)"
            fi
            # Linting
            golint "$FILE_PATH" 2>/dev/null || add_issue "Golint issues"
            go vet "$FILE_PATH" 2>/dev/null || add_issue "Go vet issues"
            # Forbidden patterns
            grep -n "interface{}" "$FILE_PATH" && add_issue "Forbidden: interface{} used"
            grep -n "time.Sleep" "$FILE_PATH" && add_issue "Forbidden: time.Sleep used"
            ;;
            
        *.sh)
            echo "🐚 Shell script quality checks..."
            shellcheck "$FILE_PATH" || add_issue "ShellCheck violations"
            # Check for common issues
            grep -n "rm -rf" "$FILE_PATH" && add_issue "Dangerous: rm -rf detected"
            ;;
    esac
    
    # Check for common issues across all file types
    # No TODOs in production code
    grep -n "TODO" "$FILE_PATH" && add_issue "TODO comments found - resolve them"
    # No commented out code
    # No console.logs in JS/TS
    if [[ "$FILE_PATH" == *.js ]] || [[ "$FILE_PATH" == *.ts ]]; then
        grep -n "console.log" "$FILE_PATH" && add_issue "console.log found in production code"
    fi
fi

# Report results
if [ $ISSUES_FOUND -gt 0 ]; then
    echo "❌ ZERO-TOLERANCE VIOLATION: $ISSUES_FOUND issues found!"
    echo -e "$ISSUE_REPORT"
    echo ""
    echo "🔧 ALL issues MUST be fixed before proceeding!"
    echo "Some issues were auto-fixed. Review and re-run checks."
    
    # Exit code 2 for critical issues (helps distinguish from other failures)
    # Note: This is our convention, not a Claude feature
    exit 2
else
    echo "✅ All quality checks passed! Production-ready code."
fi
EOF

# Make hooks executable
chmod +x "$CLAUDE_HOME/hooks"/*.sh

# Create advanced settings.json
echo "⚙️ Creating advanced settings configuration..."
cat > "$CLAUDE_HOME/settings.json" << 'EOF'
{
  "model": "opus",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/preToolUse.sh"}
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/postToolUse.sh"}
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/summary-generator.sh"},
          {"type": "command", "command": "~/.claude/hooks/notification.sh"}
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/agent-report.sh"}
        ]
      }
    ]
  }
}
EOF

# Create summary generator hook
cat > "$CLAUDE_HOME/hooks/summary-generator.sh" << 'EOF'
#!/bin/bash
# Generate session summary on stop

LOG_FILE="$HOME/.claude/logs/session-summaries.log"
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Count activities from this session
EDITS=$(grep -c "Edit|$SESSION_ID" "$HOME/.claude/logs/tools.log" 2>/dev/null || echo 0)
COMMANDS=$(grep -c "Bash|$SESSION_ID" "$HOME/.claude/logs/tools.log" 2>/dev/null || echo 0)

echo "[$TIMESTAMP] Session $SESSION_ID - Edits: $EDITS, Commands: $COMMANDS" >> "$LOG_FILE"
EOF

# Create notification hook
cat > "$CLAUDE_HOME/hooks/notification.sh" << 'EOF'
#!/bin/bash
# Send notification on task completion

# Check if terminal-notifier is available (macOS)
if command -v terminal-notifier &> /dev/null; then
    terminal-notifier -title "Claude Code" -message "Task completed" -sound default
# Check if notify-send is available (Linux)
elif command -v notify-send &> /dev/null; then
    notify-send "Claude Code" "Task completed"
fi

# Play a sound if available
if command -v afplay &> /dev/null; then
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null || true
elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || true
fi
EOF

# Create agent report hook
cat > "$CLAUDE_HOME/hooks/agent-report.sh" << 'EOF'
#!/bin/bash
# Report on subagent completion

echo "🤖 Subagent completed task"
echo "Check logs for details: ~/.claude/logs/tools.log"
EOF

chmod +x "$CLAUDE_HOME/hooks"/*.sh

# Install utility scripts
echo "🔧 Installing utility scripts..."

# Context monitor
cat > "$CLAUDE_HOME/scripts/monitor-context.sh" << 'EOF'
#!/bin/bash
# Monitor Claude context usage and auto-compress when needed

TOKEN_WARNING=150000
TOKEN_CRITICAL=180000

check_context() {
    STATUS=$(claude /status --output-format json 2>/dev/null || echo '{"tokens": 0}')
    TOKENS=$(echo "$STATUS" | jq -r '.tokens // 0')
    
    if [ "$TOKENS" -gt "$TOKEN_CRITICAL" ]; then
        echo "🚨 Critical token usage: $TOKENS"
        claude /compact focus on current task
    elif [ "$TOKENS" -gt "$TOKEN_WARNING" ]; then
        echo "⚠️  High token usage: $TOKENS"
    else
        echo "✅ Token usage OK: $TOKENS"
    fi
}

# Run in watch mode if requested
if [ "$1" = "watch" ]; then
    while true; do
        clear
        check_context
        sleep 30
    done
else
    check_context
fi
EOF

# Session manager
cat > "$CLAUDE_HOME/scripts/session-manager.sh" << 'EOF'
#!/bin/bash
# Manage multiple Claude sessions efficiently

case "$1" in
    list)
        echo "Active Claude sessions:"
        ps aux | grep "[c]laude" | awk '{print $2, $11, $12}'
        ;;
    
    new)
        SESSION_NAME="${2:-default}"
        echo "Starting new session: $SESSION_NAME"
        claude --session "$SESSION_NAME"
        ;;
    
    switch)
        SESSION_NAME="$2"
        echo "Switching to session: $SESSION_NAME"
        claude --resume "$SESSION_NAME"
        ;;
    
    save)
        SESSION_NAME="${2:-current}"
        OUTPUT_FILE="$HOME/.claude/sessions/${SESSION_NAME}-$(date +%Y%m%d-%H%M%S).json"
        mkdir -p "$(dirname "$OUTPUT_FILE")"
        echo "Saving session to: $OUTPUT_FILE"
        # Note: This would need actual implementation based on Claude's session format
        ;;
    
    *)
        echo "Usage: session-manager.sh {list|new|switch|save} [session-name]"
        ;;
esac
EOF

# Performance profiler
cat > "$CLAUDE_HOME/scripts/profile-performance.py" << 'EOF'
#!/usr/bin/env python3
"""Profile Claude Code performance and generate optimization suggestions"""

import json
import sys
import os
from collections import defaultdict
from datetime import datetime

def analyze_log(log_file):
    """Analyze Claude tool usage logs"""
    tool_stats = defaultdict(lambda: {"count": 0, "files": set()})
    
    try:
        with open(log_file) as f:
            for line in f:
                parts = line.strip().split("|")
                if len(parts) >= 4:
                    timestamp, tool, file_path, _ = parts[:4]
                    tool_stats[tool]["count"] += 1
                    if file_path:
                        tool_stats[tool]["files"].add(file_path)
    except FileNotFoundError:
        print(f"❌ Log file not found: {log_file}")
        print("💡 Run some Claude commands first to generate logs.")
        return
    
    print("📊 Claude Code Performance Analysis")
    print("=" * 50)
    
    if not tool_stats:
        print("No tool usage found in logs.")
        return
    
    for tool, stats in sorted(tool_stats.items(), key=lambda x: x[1]["count"], reverse=True):
        print(f"\n{tool}:")
        print(f"  Uses: {stats['count']}")
        print(f"  Unique files: {len(stats['files'])}")
        
        if stats['count'] > 100:
            print(f"  ⚠️  High usage detected. Consider caching or batching.")

if __name__ == "__main__":
    log_file = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/.claude/logs/tools.log")
    analyze_log(log_file)
EOF

# Make scripts executable
chmod +x "$CLAUDE_HOME/scripts"/*.sh
chmod +x "$CLAUDE_HOME/scripts"/*.py

# Create log rotation script
echo "📊 Setting up log rotation..."
cat > "$CLAUDE_HOME/scripts/rotate-logs.sh" << 'EOF'
#!/bin/bash
# Rotate Claude logs to prevent unlimited growth

LOG_DIR="$HOME/.claude/logs"
BACKUP_DIR="$HOME/.claude/backups"
MAX_AGE_DAYS=7

# Rotate logs
for log in "$LOG_DIR"/*.log; do
    if [ -f "$log" ]; then
        # Rotate if larger than 10MB
        if [ $(stat -f%z "$log" 2>/dev/null || stat -c%s "$log" 2>/dev/null) -gt 10485760 ]; then
            mv "$log" "$log.$(date +%Y%m%d-%H%M%S)"
            touch "$log"
            echo "Rotated: $log"
        fi
    fi
done

# Clean old logs
find "$LOG_DIR" -name "*.log.*" -mtime +$MAX_AGE_DAYS -delete 2>/dev/null

# Clean old backups
find "$BACKUP_DIR" -name "*.bak" -mtime +$MAX_AGE_DAYS -delete 2>/dev/null

echo "✅ Log rotation complete"
EOF

chmod +x "$CLAUDE_HOME/scripts/rotate-logs.sh"

# Add log rotation to crontab (optional)
echo "💡 To enable automatic log rotation, add this to your crontab:"
echo "   0 0 * * * $CLAUDE_HOME/scripts/rotate-logs.sh"

# Create helpful aliases
echo "✨ Creating shell aliases..."
cat > "$CLAUDE_HOME/aliases.sh" << 'EOF'
# Claude Code Expert Aliases

# Quick commands
alias cc='claude --continue'
alias ccp='claude -p'
alias ccr='claude /review'
alias ccd='claude /debug'
alias ccf='claude /refactor'

# Session management
alias cc-new='~/.claude/scripts/session-manager.sh new'
alias cc-list='~/.claude/scripts/session-manager.sh list'
alias cc-switch='~/.claude/scripts/session-manager.sh switch'

# Monitoring
alias cc-status='claude /status'
alias cc-monitor='~/.claude/scripts/monitor-context.sh watch'
alias cc-profile='python ~/.claude/scripts/profile-performance.py'

# Safety shortcuts
alias cc-safe='claude --allowedTools "Read,Grep"'
alias cc-readonly='claude --allowedTools "Read,Grep,Bash" -p "Use only read operations"'

# YOLO mode (ONLY in container!)
# Note: Update path if container is in different location
alias cc-yolo='echo "⚠️  Launching isolated YOLO container..." && cd ~/.dotfiles/claude-code-isolated-container && ./run-claude-yolo.sh'

# Quick JSON extraction
ccj() {
    claude -p "$1" --output-format json | jq -r '.result'
}

# Quick PR creation
cc-pr() {
    local feature="$1"
    ~/.claude/scripts/perfect-pr.sh "$feature"
}
EOF

# Add to shell configuration
echo "🔗 Linking to shell configuration..."
if [[ -f "$HOME/.zshrc" ]]; then
    if ! grep -q "claude/aliases.sh" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# Claude Code Expert Environment" >> "$HOME/.zshrc"
        echo "[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh" >> "$HOME/.zshrc"
    fi
elif [[ -f "$HOME/.bashrc" ]]; then
    if ! grep -q "claude/aliases.sh" "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# Claude Code Expert Environment" >> "$HOME/.bashrc"
        echo "[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh" >> "$HOME/.bashrc"
    fi
fi

# Add dotfiles-specific commands
echo "📁 Installing dotfiles-specific commands..."

# Validate dotfiles command
cat > "$CLAUDE_HOME/commands/validate-dotfiles.md" << 'EOF'
---
description: "Complete dotfiles health check and FIX issues"
tools: ["Read", "Edit", "Bash", "Grep"]
---
DOTFILES VALIDATION - Fix ALL issues found!

Check and FIX:
1. **Symlink Integrity**
   - All symlinks valid → FIX broken ones
   - No circular links → REMOVE them
   - Target files exist → CREATE missing

2. **Shell Scripts**
   - All pass shellcheck → FIX violations
   - Executable permissions → SET them
   - No hardcoded paths → MAKE portable

3. **Security Scan**
   - No API keys → REMOVE them
   - No passwords → DELETE them
   - No tokens → CLEAN them

4. **Brewfile Validation**
   - Valid syntax → FIX errors
   - All formulas exist → REMOVE invalid
   - No duplicates → DEDUPE

5. **Git Configuration**
   - All aliases work → FIX broken ones
   - Valid email/name → ENSURE set

DO NOT STOP until everything is ✅ GREEN!
EOF

# Shell audit command
cat > "$CLAUDE_HOME/commands/shell-audit.md" << 'EOF'
---
description: "Comprehensive shell script analysis and fixes"
tools: ["Read", "Edit", "Bash", "Grep"]
---
SHELL SCRIPT AUDIT for $ARGUMENTS

Run comprehensive checks and FIX ALL:
- ShellCheck violations → RESOLVE
- POSIX compatibility → ENSURE
- Error handling → ADD if missing
- Quoting issues → FIX
- Undefined variables → DEFINE
- Exit codes → HANDLE properly

Make scripts production-grade!
EOF

# Create dotfiles-specific hook
cat > "$CLAUDE_HOME/hooks/dotfiles-check.sh" << 'EOF'
#!/bin/bash
# Dotfiles-specific quality checks

ISSUES=0

# Check if we're in a dotfiles repo
if [[ ! -f "./script/setup" ]] && [[ ! -d "./dot" ]]; then
    exit 0  # Not a dotfiles repo, skip
fi

# For shell scripts in dotfiles
if [[ "$FILE_PATH" == *.sh ]] || [[ "$FILE_PATH" == */bin/* ]]; then
    echo "🔍 Dotfiles shell script validation..."
    
    # Must pass shellcheck
    if ! shellcheck "$FILE_PATH"; then
        echo "❌ ShellCheck violations found!"
        ((ISSUES++))
    fi
    
    # Must be executable if in bin/
    if [[ "$FILE_PATH" == */bin/* ]] && [[ ! -x "$FILE_PATH" ]]; then
        chmod +x "$FILE_PATH"
        echo "⚠️ Made script executable: $FILE_PATH"
        ((ISSUES++))
    fi
    
    # No hardcoded home paths
    if grep -E "/Users/[^/]+|/home/[^/]+" "$FILE_PATH" | grep -v '[$]'; then
        echo "❌ Hardcoded paths found - use \$HOME instead"
        ((ISSUES++))
    fi
fi

# For Brewfile
if [[ "$FILE_PATH" == *Brewfile* ]]; then
    echo "🍺 Validating Brewfile..."
    if ! brew bundle check --file="$FILE_PATH" &>/dev/null; then
        echo "❌ Brewfile validation failed"
        ((ISSUES++))
    fi
fi

# Exit with appropriate code
if [ $ISSUES -gt 0 ]; then
    echo "❌ $ISSUES dotfiles issues found - FIX THEM!"
    exit 2
fi
EOF

chmod +x "$CLAUDE_HOME/hooks/dotfiles-check.sh"

# Add to PostToolUse hooks in settings
echo "📝 Updating settings for dotfiles support..."
# Note: This would need proper JSON manipulation in production

# Create initial .claudeignore
echo "🚫 Setting up .claudeignore template..."
cat > "$DOTFILES_DIR/.claudeignore.template" << 'EOF'
# Claude Code Ignore File Template
# Copy this to your project root and customize

# Secrets and credentials
.env
.env.*
**/secrets/
**/credentials/
*.pem
*.key
*.cert

# Large files
*.zip
*.tar.gz
*.rar
*.iso
*.dmg

# Build artifacts
**/node_modules/
**/dist/
**/build/
**/.next/
**/target/
**/__pycache__/
*.pyc

# IDEs
.idea/
.vscode/settings.json
*.swp
*.swo

# Logs and databases
*.log
*.sqlite
*.db

# OS files
.DS_Store
Thumbs.db

# Custom excludes for your project
# Add project-specific patterns here
EOF

echo "✅ Expert environment setup complete!"
echo ""
echo "🎉 Next steps:"
echo "1. Reload your shell: source ~/.zshrc (or ~/.bashrc)"
echo "2. Test the setup: cc-status"
echo "3. Read the expert guide: less $DOTFILES_DIR/CLAUDE_EXPERT.md"
echo "4. Start with a tutorial: claude -p 'Show me the quick start from CLAUDE_EXPERT.md'"
echo ""
echo "💡 Pro tip: Run 'cc-monitor' in a separate terminal to track token usage!"