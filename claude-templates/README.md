# Claude Code Templates

This directory contains template files for Claude Code configuration.

## Structure

```
claude-templates/
├── hooks/           # Hook scripts for various Claude Code events
├── scripts/         # Helper scripts (e.g., API key helper)
├── commands/        # Slash command templates (optional)
├── settings.json    # Main configuration file
└── README.md        # This file
```

## Usage

Run the setup script from your dotfiles directory:

```bash
./claude-setup-from-templates.sh
```

This will:
1. Create the necessary directory structure in `~/.claude/`
2. Copy all templates to their appropriate locations
3. Make scripts executable
4. Handle conflicts with existing files

## Customization

- Edit `settings.json` to customize hook configurations
- Add new hooks to the `hooks/` directory
- Add new scripts to the `scripts/` directory
- Add slash commands as `.md` files in `commands/` subdirectories

## Hook Templates

- `pre-backup.sh` - Creates backups before file modifications
- `post-lint.sh` - Auto-formats code after changes
- `security-check.sh` - Validates commands for security
- `tool-usage.sh` - Simple audit logging
- `prompt-logger.sh` - Logs user prompts
- `session-cleanup.sh` - Cleans up old files
- `notify.sh` - Cross-platform notifications
- `subagent-stop.sh` - Tracks agent completions
- `pre-compact.sh` - Prepares for session compaction

## Adding New Templates

1. Create the template file in the appropriate directory
2. Run the setup script again (it will handle conflicts)
3. Or manually copy to `~/.claude/` and update `settings.json`