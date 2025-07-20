# Critical Location Fixes Needed

## Current Issues

Our setup script is creating a confusing mix of user-level and project-level configurations:

### 1. Commands Location Issue
- **Currently**: Creating commands in `~/.claude/commands/` (user-level)
- **But**: We want these to be project-specific for the expert system
- **Fix**: Should be in `~/.dotfiles/.claude/commands/`

### 2. Hooks Location Issue  
- **Currently**: Creating hooks in `~/.claude/hooks/` (user-level)
- **But**: The capture-success.sh hook is project-specific
- **Fix**: Should be in `~/.dotfiles/.claude/hooks/`

### 3. Settings.json Update Issue
- **Currently**: Updating `~/.dotfiles/.claude/settings.json` (correct)
- **But**: The hook path references `~/.claude/hooks/capture-success.sh`
- **Fix**: Path should be `.claude/hooks/capture-success.sh` (relative)

### 4. Patterns Storage Issue
- **Currently**: Storing in `~/.claude/patterns/` (user-level)
- **Problem**: These patterns are specific to the dotfiles expert system
- **Fix**: Should be in `~/.dotfiles/.claude/patterns/`

## Recommended Approach

### Option 1: Project-Specific Expert System (Recommended)
Keep everything within the dotfiles project:
- Commands: `~/.dotfiles/.claude/commands/`
- Hooks: `~/.dotfiles/.claude/hooks/`
- Patterns: `~/.dotfiles/.claude/patterns/`
- Settings: `~/.dotfiles/.claude/settings.json`
- Team knowledge: `~/.dotfiles/.claude/team-knowledge/`

Benefits:
- Self-contained expert system
- Easy to version control
- Can be shared/replicated
- No pollution of global Claude config

### Option 2: User-Level Expert System
Install globally for use in all projects:
- Commands: `~/.claude/commands/`
- Hooks: `~/.claude/hooks/`
- Patterns: `~/.claude/patterns/`
- Settings: `~/.claude/settings.json`
- CLAUDE.md: `~/.claude/CLAUDE.md`

Benefits:
- Available in all projects
- Single source of truth
- Patterns learned across all projects

## Impact on CLAUDE.md

The CLAUDE.md in the dotfiles root is correctly placed. But the capture-success.sh hook currently writes to:
- `$HOME/.dotfiles/claude-expert/CLAUDE.md`

This should be:
- `$HOME/.dotfiles/CLAUDE.md` (if project-specific)
- OR create patterns file that gets imported

## Settings.json Hook Path

The hook configuration should use relative paths when in project settings:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/capture-success.sh"
      }]
    }]
  }
}
```

Note: The `.claude/` prefix (with dot) makes it relative to the project.