# Claude Expert V2 - Global Installation

## Overview

This is a **GLOBAL** Claude Expert System that gets installed to `~/.claude/` and provides enhanced capabilities across ALL your projects. Once installed, these features are available everywhere without any per-project configuration.

## What This Does

The setup script (`claude-expert-v2-setup-improved.sh`) installs:

1. **Global Claude Configuration** (`~/.claude/`)
   - Enhanced CLAUDE.md with expert-level instructions
   - Multi-agent commands available in all projects
   - Pattern learning system that improves over time
   - Team knowledge base for shared patterns

2. **Smart Hooks** (`~/.claude/hooks/`)
   - Automatic pattern capture from successful operations
   - Learns from your coding patterns across all projects
   - Builds a personal knowledge base

3. **Multi-Agent Commands** (`~/.claude/commands/`)
   - `/architect-multi` - Design new projects from scratch
   - `/debug-multi` - Complex debugging with parallel agents
   - `/refactor-multi` - Code quality improvements
   - `/team-share` - Share patterns locally
   - `/team-sync` - Sync patterns (prepared but disabled)

## Installation

```bash
cd ~/.dotfiles
./claude-expert-v2-setup-improved.sh
```

The script is idempotent and handles conflicts gracefully. You can run it multiple times safely.

### Conflict Resolution Modes

```bash
# Interactive mode (default) - prompts for each conflict
./claude-expert-v2-setup-improved.sh

# Overwrite mode - replaces existing files
CLAUDE_SETUP_MODE=overwrite ./claude-expert-v2-setup-improved.sh

# Skip mode - preserves existing files
CLAUDE_SETUP_MODE=skip ./claude-expert-v2-setup-improved.sh

# Merge mode - appends to existing files
CLAUDE_SETUP_MODE=merge ./claude-expert-v2-setup-improved.sh
```

## Directory Structure

After installation, you'll have:

```
~/.claude/                      # Global Claude configuration
├── settings.json              # User-level settings with hooks
├── CLAUDE.md                  # Global expert instructions
├── commands/                  # Multi-agent commands
│   ├── architect-multi.md
│   ├── debug-multi.md
│   ├── refactor-multi.md
│   ├── team-share.md
│   └── team-sync.md
├── hooks/                     # Event hooks
│   └── capture-success.sh     # Pattern learning hook
├── patterns/                  # Learned patterns
│   ├── learned.json          # Auto-captured patterns
│   └── common-patterns.md    # Manual patterns
├── team-knowledge/           # Shared team patterns
│   └── shared-patterns.md
├── templates/                # Reusable templates
├── knowledge/                # Domain knowledge
└── verify-setup.sh           # Installation verification
```

## Usage

### Multi-Agent Commands

Available in ANY project after installation:

```bash
# Design a new project
/architect-multi "REST API with authentication and PostgreSQL"

# Debug complex issues
/debug-multi "Memory leak in production environment"

# Refactor code with quality analysis
/refactor-multi "User service module needs optimization"

# Share a pattern with your team
/team-share "Efficient error handling pattern for async operations"
```

### Pattern Learning

The system automatically learns from successful operations:
- Captures patterns from tool usage
- Identifies successful vs failed operations
- Builds a knowledge base over time
- Appends to global CLAUDE.md every 5 patterns

### Verification

Check your installation:

```bash
~/.claude/verify-setup.sh
```

## Important Notes

1. **Global Scope**: This is NOT project-specific. All commands and patterns are available system-wide.

2. **Learning Across Projects**: The pattern learning system captures successful patterns from ALL your projects, building a comprehensive personal knowledge base.

3. **No Project Setup Required**: Unlike project-specific `.claude/` directories, this global installation requires no per-project configuration.

4. **Complements Project Config**: This global setup works alongside any project-specific `.claude/` directories you may have.

## Troubleshooting

### Commands Not Working
- Restart Claude Code after installation
- Check `~/.claude/settings.json` exists
- Verify with `~/.claude/verify-setup.sh`

### Patterns Not Being Captured
- Check hook is executable: `ls -la ~/.claude/hooks/`
- Look for errors in Claude Code output
- Verify `~/.claude/patterns/learned.json` exists

### Conflicts with Project Settings
- Global settings are loaded first
- Project-specific settings override global ones
- Commands are merged (both available)

## Future Enhancements

Currently disabled but prepared:
- Cloud synchronization for team patterns
- Git-based pattern sharing
- Cross-team knowledge bases

## Support

This expert system enhances the official Claude Code features. For issues:
- Check official docs: https://docs.anthropic.com/en/docs/claude-code
- Review this setup: `~/.dotfiles/claude-expert/`
- Run verification: `~/.claude/verify-setup.sh`