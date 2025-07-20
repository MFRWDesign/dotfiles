# Claude Expert System V3

A comprehensive expert-level enhancement system for Claude Code, built entirely on features documented in the official Claude Code and prompt engineering documentation.

## Overview

This setup transforms Claude Code into an expert development assistant by leveraging all the powerful features from the official documentation:

- **Smart Hooks** - Automated git commits, linting, security checks, and backups
- **Expert Commands** - Specialized slash commands for common development tasks
- **Optimized Settings** - Carefully configured permissions and environment
- **Enhanced Templates** - Professional CLAUDE.md templates for projects

## What's New in V3

V3 is a complete rewrite that:
- ✅ Uses ONLY features documented in official Claude Code docs
- ✅ Removes all experimental/unsupported features from V2
- ✅ Adds comprehensive hooks for automation
- ✅ Implements proper security controls
- ✅ Provides genuinely useful slash commands

## Installation

```bash
# Clone or download the setup script
./claude-expert-v3-full.sh

# Follow the prompts (or use CLAUDE_SETUP_MODE=overwrite to auto-overwrite)
```

## Features

### 🔄 Automated Git Operations
- **Auto-commit**: Automatically commits changes after file modifications
- **Conventional commits**: Uses proper commit message format
- **Co-authored commits**: Includes Claude as co-author
- **Smart staging**: Only stages relevant files

### 🧹 Automatic Code Quality
- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: Black + isort  
- **Go**: gofmt
- **Rust**: rustfmt
- Runs automatically after any file edit

### 🔒 Security Safeguards
- Blocks dangerous commands (rm -rf /, etc.)
- Prevents writes to sensitive directories
- Detects potential secrets in code
- Validates all Bash operations

### 💾 Automatic Backups
- Creates timestamped backups before any file modification
- Maintains last 100 backups per file
- Organized by date in ~/.claude/backups/

### 🔔 Smart Notifications
- Detects long-running operations (npm install, builds, etc.)
- Sends system notifications on start and completion
- Indicates success/failure status
- Works on macOS (native) and Linux (notify-send)

### 🚀 Expert Slash Commands

#### `/performance`
Analyzes code performance, identifies bottlenecks, and suggests optimizations.

#### `/security-audit`
Comprehensive security review checking for OWASP Top 10 vulnerabilities.

#### `/git-workflow`
Handles advanced git operations like worktrees, interactive rebasing, and more.

#### `/think`
Triggers extended thinking mode for complex architectural decisions.

#### `/coverage`
Analyzes test coverage and generates meaningful tests for uncovered code.

## Configuration

### Settings Structure
```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...]
  },
  "permissions": {
    "allow": [...],
    "deny": [...]
  },
  "env": {
    "CLAUDE_EXPERT": "true"
  }
}
```

### Hook System

All hooks follow the official Claude Code pattern:
- Exit 0: Success, continue
- Exit 2: Block operation
- Other: Log but continue

### Permission System

Configured to allow:
- ✅ All standard file operations
- ✅ Git commands
- ✅ Package managers (npm, yarn, pip, cargo)
- ✅ Build tools
- ❌ Sudo operations
- ❌ Destructive operations

## Project Setup

1. Copy the project template to your repository:
   ```bash
   cp ~/.dotfiles/claude-expert/PROJECT_CLAUDE_TEMPLATE.md ./CLAUDE.md
   ```

2. Fill in the template variables:
   - `{{PROJECT_DESCRIPTION}}`
   - `{{PRIMARY_LANGUAGE}}`
   - `{{TEST_FRAMEWORK}}`
   - etc.

3. Claude will now understand your project's specific requirements

## Verification

Run the verification script to ensure everything is properly installed:

```bash
~/.claude/verify-setup.sh
```

This checks:
- All directories exist
- Hooks are executable
- Commands are installed
- Settings are configured
- Optional tools are available

## How It Works

### File Modification Flow
1. You ask Claude to edit a file
2. **Pre-hook**: Backup is created
3. **Pre-hook**: Security check runs
4. File is modified
5. **Post-hook**: Linting runs
6. **Post-hook**: Changes are committed

### Bash Command Flow (Long-Running)
1. You ask Claude to run a command (e.g., `npm install`)
2. **Pre-hook**: Security check validates command
3. **Pre-hook**: Notification sent if long-running detected
4. Command executes
5. **Post-hook**: Completion notification sent with status

### Command Flow
1. You run a slash command (e.g., `/performance`)
2. Claude receives the command with any arguments
3. Command template is filled with your parameters
4. Claude executes according to the command instructions

## Customization

### Adding New Hooks
Create a new script in `~/.claude/hooks/` and add it to `settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "YourMatcher",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/your-hook.sh"
        }]
      }
    ]
  }
}
```

### Adding New Commands
Create a markdown file in `~/.claude/commands/`:

```markdown
---
description: "Your command description"
tools: ["Read", "Write", "Edit"]
---

Your command instructions here with {{VARIABLES}}.
```

## Troubleshooting

### Hooks Not Running
- Check `~/.claude/settings.json` exists
- Verify hooks are executable: `chmod +x ~/.claude/hooks/*.sh`
- Run verification script

### Commands Not Found
- Restart Claude Code after installation
- Check files exist in `~/.claude/commands/`

### Linting Not Working
- Install the appropriate linters:
  ```bash
  npm install -g eslint prettier
  pip install black isort
  ```

## Based On Official Documentation

Every feature in this system is based on official Claude Code documentation:
- Hooks: [Claude Code Hooks Reference](https://docs.anthropic.com/en/docs/claude-code/hooks)
- Commands: [Slash Commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)
- Settings: [Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- Memory: [Managing Claude's Memory](https://docs.anthropic.com/en/docs/claude-code/memory)

## Key Differences from V2

| Feature | V2 (Old) | V3 (New) |
|---------|----------|----------|
| Learning System | Custom pattern capture | Removed - not in official docs |
| Multi-agent | Complex parallel agents | Simple, focused commands |
| Directories | Many custom dirs | Only official directories |
| Hooks | Pattern learning | Git, linting, security, backups |
| Commands | Complex multi-agent | Practical, documented patterns |

## Philosophy

This expert system enhances Claude Code without reimagining it. We use only documented features to create a more powerful, automated, and secure development experience while maintaining full compatibility with standard Claude Code operations.

## License

This setup script and configuration is provided as-is for the Claude Code community.