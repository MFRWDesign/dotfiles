# TODO: Remaining Fixes for Claude Expert Setup

## ✅ Completed in Cleaned Version
- [x] Removed learning system (capture-success.sh hook)
- [x] Removed learned.json initialization
- [x] Removed patterns/ directory
- [x] Removed team-knowledge/ directory
- [x] Removed logs/ directory
- [x] Removed mcp-servers/ directory (MCP should be configured via `claude mcp` command)
- [x] Removed templates/ directory
- [x] Removed knowledge/ directory
- [x] Rewrote all slash commands to match official format
- [x] Removed complex multi-agent concepts
- [x] Removed non-standard frontmatter fields (argument-hint)
- [x] Simplified CLAUDE.md templates
- [x] Removed @import syntax references
- [x] Removed all hooks (no hooks in cleaned version)

## 🔧 Still Needs Attention

### 1. **Settings.json Updates**
- [ ] The original script tried to update settings.json with hooks
- [ ] Consider if any settings.json modifications are needed
- [ ] If yes, ensure they follow official format from docs

### 2. **Command Improvements**
- [ ] Add more useful commands based on common workflows from docs
- [ ] Consider adding /help command that lists available commands
- [ ] Add /init command (mentioned in official docs)
- [ ] Make commands more template-friendly with {{VARIABLES}}

### 3. **Documentation**
- [ ] Create a proper README.md explaining:
  - What this setup does
  - How to use the commands
  - How to customize for your needs
  - Differences from default Claude Code setup

### 4. **Installation Experience**
- [ ] Consider making script more interactive
- [ ] Add option to install only specific components
- [ ] Better explain what each part does during installation

### 5. **Project vs User Level Clarity**
- [ ] Make it clearer when to use project-level CLAUDE.md
- [ ] Make it clearer when to use user-level CLAUDE.md
- [ ] Add examples of good content for each

### 6. **Validation and Testing**
- [ ] Expand verify-setup.sh to actually test commands work
- [ ] Add checks for Claude Code installation
- [ ] Verify commands are accessible in Claude

## 💡 Potential Enhancements (Based on Official Docs)

### From Common Workflows
- [ ] Add command for extended thinking prompts
- [ ] Add command for image analysis workflows
- [ ] Add command for resuming work (git worktree setup)

### From CLI Reference
- [ ] Document how to use with --allowedTools flag
- [ ] Create examples using non-interactive mode

### From Settings Documentation
- [ ] Create example settings.json configurations
- [ ] Document useful permission settings
- [ ] Show how to set up allowed/denied tools

### From MCP Documentation
- [ ] Create guide for setting up useful MCP servers
- [ ] Document how to integrate with commands

## 📝 Notes

The cleaned version is now much more aligned with official Claude Code functionality. It:
- Only creates officially documented directories
- Uses proper slash command format
- Removes all experimental features
- Focuses on enhancing Claude Code rather than reimagining it

The main value now is in providing:
1. Useful pre-made slash commands
2. Good CLAUDE.md templates
3. Clear documentation on how to use these features