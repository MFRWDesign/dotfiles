# Claude Code Expert - Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### "Permission denied" when running setup script
```bash
# Make sure script is executable
chmod +x claude-expert-setup.sh

# If still fails, check ownership
ls -la claude-expert-setup.sh
```

#### Setup script fails with "command not found"
- Ensure you're in the correct directory
- Check that bash is available: `which bash`
- Try running with explicit bash: `bash claude-expert-setup.sh`

### Hook Issues

#### Hooks blocking all operations
```bash
# Temporarily disable hooks
export CLAUDE_SKIP_HOOKS=1

# Run Claude
claude

# Re-enable hooks
unset CLAUDE_SKIP_HOOKS
```

#### "Exit code 2" confusion
- This is our convention, not a Claude feature
- Used to distinguish quality issues from other failures
- Claude doesn't automatically fix based on exit codes

#### Hooks not running at all
```bash
# Check permissions
ls -la ~/.claude/hooks/

# All .sh files should be executable
chmod +x ~/.claude/hooks/*.sh

# Check if hooks directory exists
ls -la ~/.claude/
```

#### Specific tool not found in hooks
```bash
# Example: shellcheck not found
# Check if installed
which shellcheck

# Install if missing
brew install shellcheck  # macOS
sudo apt-get install shellcheck  # Ubuntu
```

### Command Issues

#### Custom commands not showing in /help
```bash
# Check command files exist
ls ~/.claude/commands/

# Verify file format (must have .md extension)
# Verify YAML frontmatter is valid
```

#### "/check" command just reports, doesn't fix
- This is the intended behavior initially
- You need to explicitly ask Claude to fix the issues
- The command sets the expectation, but Claude still needs direction

### Alias Issues

#### Aliases not working
```bash
# Check if aliases file was sourced
grep "claude/aliases.sh" ~/.zshrc

# Manually source
source ~/.claude/aliases.sh

# Verify alias exists
alias | grep cc
```

#### cc-yolo fails to find container
```bash
# Check container location
ls -la ~/.dotfiles/claude-code-isolated-container/

# If missing, clone it
cd ~/.dotfiles
git clone https://github.com/anthropics/claude-code.git claude-code-isolated-container
cd claude-code-isolated-container
cp -r .devcontainer/* .
```

### Performance Issues

#### Token limit reached quickly
```bash
# Check current usage
claude /status

# Compress context
claude /compact focus on current task

# Clear visual clutter
claude /clear
```

#### Hooks making everything slow
```bash
# Profile which hooks are slow
time ~/.claude/hooks/postToolUse.sh

# Temporarily disable slow hooks
# Edit ~/.claude/settings.json to comment out slow hooks

# Or use CLAUDE_SKIP_HOOKS=1 for specific operations
```

### YOLO Mode Issues

#### Docker not installed
- Install Docker Desktop: https://www.docker.com/products/docker-desktop/
- Ensure Docker daemon is running
- Verify: `docker --version`

#### Container won't start
```bash
# Check Docker is running
docker ps

# Check for errors
docker-compose logs

# Rebuild container
docker-compose down -v
docker-compose up --build
```

#### Network isolation not working
```bash
# Inside container, test isolation
curl https://example.com  # Should fail
curl https://api.github.com  # Should work

# Check firewall rules
docker exec claude-code-isolated sudo iptables -L -n
```

### Log Issues

#### Logs growing too large
```bash
# Run log rotation manually
~/.claude/scripts/rotate-logs.sh

# Set up automatic rotation
crontab -e
# Add: 0 0 * * * ~/.claude/scripts/rotate-logs.sh
```

#### Can't find activity in logs
```bash
# Check log location
ls -la ~/.claude/logs/

# Search logs
grep -r "filename" ~/.claude/logs/

# Tail recent activity
tail -f ~/.claude/logs/tools.log
```

### Memory Issues

#### Claude not remembering project rules
```bash
# Check if CLAUDE.md exists
ls -la ./CLAUDE.md
ls -la ~/.claude/CLAUDE.md

# Verify Claude is reading them
claude -p "What project rules do you know about?"
```

#### Import chains not working
- Maximum 5 recursive imports
- Check for circular dependencies
- Use absolute paths in imports

## Quick Fixes

### Reset Everything
```bash
# Complete reset (preserves your work)
rm -rf ~/.claude
./claude-expert-setup.sh
```

### Disable All Enhancements
```bash
# Temporary disable
export CLAUDE_SKIP_HOOKS=1

# Remove all customizations
rm -rf ~/.claude/commands
rm -rf ~/.claude/hooks
rm ~/.claude/settings.json
```

### Emergency Recovery
```bash
# If Claude modified critical files
# Check backups
ls -la ~/.claude/backups/$(date +%Y%m%d)/

# Restore from backup
cp ~/.claude/backups/20240710/important-file.bak ./important-file

# Use git to recover
git status
git checkout -- filename
```

## Debug Mode

Create a debug script:
```bash
#!/bin/bash
# ~/.claude/debug.sh

echo "Claude Code Expert Debug Info"
echo "============================"

echo -e "\nEnvironment:"
echo "ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:+SET}"
echo "CLAUDE_SKIP_HOOKS: $CLAUDE_SKIP_HOOKS"
echo "Shell: $SHELL"

echo -e "\nClaude Installation:"
which claude
claude --version 2>/dev/null || echo "Claude not found!"

echo -e "\nDirectory Structure:"
ls -la ~/.claude/

echo -e "\nHook Permissions:"
ls -la ~/.claude/hooks/*.sh 2>/dev/null || echo "No hooks found!"

echo -e "\nCommands Available:"
ls -la ~/.claude/commands/*.md 2>/dev/null || echo "No commands found!"

echo -e "\nAlias Status:"
alias | grep -E "^cc" || echo "No cc aliases found!"

echo -e "\nRecent Logs:"
tail -5 ~/.claude/logs/tools.log 2>/dev/null || echo "No logs found!"
```

## Getting Help

1. **Check the documentation**:
   - This troubleshooting guide
   - Prerequisites guide
   - CLI reference guide

2. **Debug with verbose mode**:
   ```bash
   # Add to your commands for more info
   set -x  # Enable bash debug mode
   ```

3. **Community resources**:
   - Claude Code documentation: https://docs.anthropic.com/en/docs/claude-code
   - GitHub issues: https://github.com/anthropics/claude-code/issues

4. **Reset and try again**:
   - Sometimes a clean install fixes mysterious issues
   - Always backup your work first

## Prevention Tips

1. **Regular maintenance**:
   - Run log rotation weekly
   - Check disk space regularly
   - Update tools periodically

2. **Safe practices**:
   - Always use YOLO mode in container
   - Review changes before committing
   - Keep backups of important files

3. **Monitor resources**:
   - Watch token usage with `cc-monitor`
   - Check log sizes periodically
   - Profile slow operations

Remember: Most issues have simple solutions. Start with the basics before assuming complex problems.