# Claude Code Expert - Quick Start Guide 🚀

## Installation Steps

### 0. Check prerequisites
```bash
# Ensure Claude Code is installed
claude --version

# Check API key
echo $ANTHROPIC_API_KEY
```
See [CLAUDE_EXPERT_PREREQUISITES.md](./CLAUDE_EXPERT_PREREQUISITES.md) for full requirements.

### 1. Make the setup script executable (✅ DONE)
```bash
chmod +x ./claude-expert-setup.sh
```

### 2. Run the automated setup
```bash
./claude-expert-setup.sh
```

This will:
- Create ~/.claude/ directory structure
- Install custom commands and hooks
- Set up safety guardrails
- Create shell aliases
- Configure logging and backups

### 3. Reload your shell configuration
```bash
# For Zsh (default on macOS)
source ~/.zshrc

# For Bash
source ~/.bashrc
```

### 4. Verify installation
```bash
# Check if aliases are loaded
cc-status

# Or manually
claude /status
```

## What Gets Installed

### Directory Structure
```
~/.claude/
├── CLAUDE.md           # Your personal preferences
├── commands/           # Custom slash commands
│   ├── review.md       # FIX don't report
│   ├── refactor.md
│   ├── debug.md
│   ├── check.md        # Zero-tolerance checker
│   ├── ultrathink.md   # Deep analysis
│   └── implement.md    # Sacred workflow
├── hooks/              # Automation hooks
│   ├── preToolUse.sh   # Safety checks
│   ├── postToolUse.sh  # Zero-tolerance enforcement
│   └── dotfiles-check.sh
├── scripts/            # Utility scripts
│   ├── monitor-context.sh
│   ├── session-manager.sh
│   └── profile-performance.py
├── settings.json       # Advanced hook configuration
├── memories/           # Modular memory files
├── logs/              # Activity logs
├── cache/             # Performance cache
└── backups/           # Automatic backups
```

### YOLO Mode Container (Optional but Recommended)
For safe unrestricted operations:
```bash
# One-time setup
cd ~/.dotfiles
git clone https://github.com/anthropics/claude-code.git claude-code-isolated-container
cd claude-code-isolated-container
cp -r .devcontainer/* .

# Usage
cc-yolo  # Launches isolated Docker container
```

### New Commands Available
- `cc` - Continue last session
- `ccp` - Claude with prompt
- `ccr` - Run code review
- `ccd` - Debug assistant
- `ccf` - Refactor code
- `cc-status` - Check token usage
- `cc-monitor` - Live token monitoring
- `ccj()` - Extract JSON results

## First Session Checklist

### Immediate Actions
1. [ ] Run setup script
2. [ ] Source shell config
3. [ ] Test with `cc-status`

### First Hour Practice
1. [ ] Read the CLI guide: `less CLAUDE_EXPERT_CLI_GUIDE.md`
2. [ ] Try basic commands:
   ```bash
   claude
   /help
   /status
   /init
   ```
3. [ ] Create your first memory:
   ```
   /memory add Prefer TypeScript for new files
   ```
4. [ ] Test a custom command:
   ```
   /review <any-file>
   ```

### First Day Goals
1. [ ] Complete "Your First Power Hour" from CLAUDE_EXPERT.md
2. [ ] Set up project-specific CLAUDE.md
3. [ ] Practice 5 slash commands
4. [ ] Create 1 custom command
5. [ ] Use context compression

## Safety Features Included

### Pre-configured Protections
- ❌ Blocks `rm -rf /` and similar
- ❌ Prevents force-push to main/master
- ⚠️  Warns on production operations
- 💾 Auto-backups before edits
- 🔍 Logs all tool usage

### Quality Gates
- Python: black, isort, mypy, flake8
- JavaScript: prettier, eslint
- Automatic test runs after edits

## Learning Resources

1. **Start Here**: CLAUDE_EXPERT_CLI_GUIDE.md
   - Master the interface first
   - Learn all hotkeys and commands

2. **Then Progress**: CLAUDE_EXPERT.md
   - Follow the weekly curriculum
   - Complete skill level projects

3. **Reference**: CLAUDE_EXPERT_SUMMARY.md
   - Quick overview of everything
   - Links to all resources

## Troubleshooting

### If aliases don't work:
```bash
# Check if aliases file exists
ls -la ~/.claude/aliases.sh

# Manually source it
source ~/.claude/aliases.sh

# Check current shell
echo $SHELL
```

### If commands aren't found:
```bash
# Check command directory
ls ~/.claude/commands/

# Verify from within Claude
claude
/help
```

### If hooks aren't running:
```bash
# Check permissions
ls -la ~/.claude/hooks/
# All .sh files should be executable

# Test manually
chmod +x ~/.claude/hooks/*.sh
```

## Next Steps After Setup

1. **Hour 1**: Master the CLI interface
2. **Day 1**: Set up your first project with Claude
3. **Week 1**: Complete Bronze level training
4. **Month 1**: Achieve Silver level automation

Remember: The setup script is idempotent - you can run it multiple times safely!

---

Ready to become a Claude Code expert? Run the setup and start your journey! 🎯