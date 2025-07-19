# Claude Expert Quick-Start Guide 🚀

> Get up and running with Claude Expert Training System in 10 minutes

## 🎯 Immediate Actions (3 minutes)

### 1. Run the Setup Script
```bash
cd ~/.dotfiles
./claude-expert-setup.sh
```
This installs:
- 8 custom commands (review, refactor, debug, check, ultrathink, implement, validate-dotfiles, shell-audit)
- Smart safety hooks with language detection
- Log rotation and backup systems

### 2. Test Your Setup
```bash
# Verify installation
claude --version

# Test a custom command
claude review "Check if Claude Expert is properly configured"

# Try deep thinking
claude -p "think deeply about optimizing this dotfiles setup"
```

### 3. Initialize Your First Project
```bash
cd your-project
claude /init  # Creates CLAUDE.md with intelligent defaults
```

## 🔥 Power User Commands (2 minutes to learn, lifetime to master)

### Essential CLI Shortcuts
```bash
# Continue last session
claude --continue

# Ultra-thinking mode
claude -p "ultrathink through this architecture"

# Skip permissions (use carefully!)
claude -p "fix all linting issues" --dangerously-skip-permissions

# Session management
/project:session-start "Feature X"
/project:session-end
```

### MCP Quick Setup
```bash
# Add to ~/.config/claude/config.json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/workspace"]
    }
  }
}
```

## 📚 Essential Reading Order (5 minutes)

1. **Start Here**: `~/.dotfiles/claude-expert/core/SUMMARY.md`
   - Overview of the entire system
   
2. **CLI Mastery**: `~/.dotfiles/claude-expert/core/CLI_GUIDE.md`
   - Just read sections: Hidden Commands, Quick Reference Card
   
3. **Your Level**: Pick one from `~/.dotfiles/claude-expert/core/CLAUDE_EXPERT.md`
   - Bronze: Basic competency
   - Silver: Productive developer
   - Gold: Team lead level
   - Diamond: Architect level
   - Elite: Claude whisperer

## 🎪 Cheat Sheet

### Hotkeys That Matter
```
Ctrl+C      - Interrupt Claude
Ctrl+L      - Clear screen (keeps context)
Ctrl+R      - Search command history
Alt+Enter   - Multi-line input
```

### Commands You'll Use Daily
```
/help       - Show all commands
/status     - Check token usage
/compact    - Compress conversation
/diff       - Show what changed
/undo       - Revert last change
```

### The Sacred Workflow
```
1. Research:  "Analyze the codebase for X"
2. Plan:      "Create a plan for implementing X"
3. Implement: "Execute the plan"
```

## 🚨 Emergency Commands

```bash
# Hook bypass (when hooks block you)
CLAUDE_SKIP_HOOKS=1 claude

# Session recovery
claude --continue
"What were we working on?"

# Token limit approaching
/compact focus on current task
/clear
```

## 🎯 Next Steps

1. **Install MCP Servers** (optional but powerful)
   ```bash
   npm install -g @modelcontextprotocol/server-filesystem
   npm install -g @modelcontextprotocol/server-github
   ```

2. **Read ONE Deep Dive** based on your needs:
   - MCP Power User? → `core/MCP_MASTERY.md`
   - Session Management? → `core/ADVANCED_PATTERNS.md` (Session section)
   - Troubleshooting? → `core/TROUBLESHOOTING.md`

3. **Join the Elite**
   - Run: `claude ultrathink "How can I best utilize Claude Expert for my workflow?"`
   - Let Claude analyze your specific needs

## 💡 Pro Tips

1. **Start every day with**: `claude --continue` then `/status`
2. **End every session with**: `/project:session-end`
3. **When stuck**: `/compact` → `/clear` → start fresh
4. **For complex tasks**: Always use "think deeply" or "ultrathink"
5. **Save tokens**: Use `/compact focus on X` regularly

---

Ready to dive deeper? Continue to the [Full Day Study Plan](./FULL_DAY_STUDY_PLAN.md)