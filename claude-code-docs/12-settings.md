# Claude Code Settings

## Overview

Claude Code offers extensive configuration options through `settings.json` files, which can be set at multiple levels:

1. **User settings** (`~/.claude/settings.json`): Apply globally
2. **Project settings**:
   - `.claude/settings.json`: Shared with team
   - `.claude/settings.local.json`: Personal preferences
3. **Enterprise managed policy settings**: System-wide configurations

## Key Configuration Methods

- Use `/config` command in interactive REPL
- Modify `settings.json` files
- Use `claude config` CLI commands:
  - `claude config list`
  - `claude config get <key>`
  - `claude config set <key> <value>`

## Available Settings

### Core Configuration Options

| Setting | Description | Example |
|---------|-------------|---------|
| `apiKeyHelper` | Custom script to generate authentication value | `/bin/generate_temp_api_key.sh` |
| `cleanupPeriodDays` | Retention period for chat transcripts | `20` |
| `env` | Environment variables for sessions | `{"FOO": "bar"}` |
| `includeCoAuthoredBy` | Include "co-authored-by Claude" in commits | `false` |
| `permissions` | Define allowed/denied tool usage | See permission settings |
| `hooks` | Custom commands before/after tool execution | `{"PreToolUse": {"Bash": "echo 'Running command...'"}}`|
| `model` | Override default Claude model | `"claude-3-5-sonnet-20241022"` |

### Permission Settings

| Key | Description | Example |
|-----|-------------|---------|
| `allow` | Permitted tool usage rules | `[ "Bash(git diff:*)" ]` |
| `deny` | Denied tool usage rules | `[ "WebFetch", "Bash(curl:*)" ]` |
| `additionalDirectories` | Extra accessible directories | `[ "../docs/" ]` |

### Global Configuration Options

| Setting | Description | Options |
|---------|-------------|---------|
| `autoUpdates` | Automatic update behavior | Enable/disable auto-updates |