# Claude Code CLI Mastery Guide 🎮

> Master the Claude Code interactive interface with this comprehensive guide to hotkeys, slash commands, and CLI navigation.

## Table of Contents
1. [Essential Hotkeys](#hotkeys)
2. [Complete Slash Commands Reference](#slash-commands)
3. [CLI Navigation Patterns](#navigation)
4. [Advanced CLI Techniques](#advanced-cli)
5. [Productivity Shortcuts](#productivity)
6. [Session Management](#session-management)
7. [Output Control](#output-control)
8. [Quick Reference Card](#quick-reference)

---

## Essential Hotkeys {#hotkeys}

### Basic Navigation
| Hotkey | Action | When to Use |
|--------|--------|-------------|
| `Ctrl+C` | Cancel current operation | Stop Claude mid-response or exit |
| `Ctrl+D` | Exit Claude Code | Clean session exit |
| `Ctrl+L` | Clear screen | Clean up visual clutter (keeps context) |
| `Ctrl+R` | Search command history | Find previous prompts |
| `Ctrl+A` | Move to start of line | Quick cursor positioning |
| `Ctrl+E` | Move to end of line | Quick cursor positioning |
| `Ctrl+K` | Clear from cursor to end | Remove unwanted text |
| `Ctrl+U` | Clear from cursor to start | Remove unwanted text |
| `Tab` | Autocomplete | Complete file paths and commands |

### Advanced Editing (Vim Mode)
```
/vim  # Enable vim mode for power users
```

| Mode | Key | Action |
|------|-----|--------|
| Normal | `i` | Enter insert mode |
| Normal | `esc` | Return to normal mode |
| Normal | `dd` | Delete line |
| Normal | `yy` | Yank (copy) line |
| Normal | `p` | Paste |
| Normal | `/` | Search forward |
| Normal | `n` | Next search result |
| Normal | `u` | Undo |

### Multi-line Input
| Hotkey | Action | Example Use Case |
|--------|--------|------------------|
| `Alt+Enter` | New line without sending | Writing multi-line code |
| `Shift+Enter` | New line without sending | Alternative method |
| `Ctrl+V` then `Enter` | Literal newline | Embedding newlines in strings |

---

## Complete Slash Commands Reference {#slash-commands}

### Core Commands

#### `/help`
Show all available commands
```
/help
# Displays complete command list with descriptions
```

#### `/clear`
Clear conversation history while maintaining session
```
/clear
# Clears visual history but keeps context
# Use when screen gets cluttered
```

#### `/reset`
Complete session reset
```
/reset
# Starts fresh - clears all context and memory
# Use when switching to completely different task
```

#### `/exit` or `/quit`
Exit Claude Code
```
/exit
# Cleanly exits the session
# Alternative to Ctrl+D
```

### Context Management

#### `/compact [instruction]`
Compress conversation history
```
/compact
# Basic compression

/compact focus on the API implementation
# Compression with specific focus

/compact keep only test-related discussion
# Targeted compression
```

**Pro Tips:**
- Use before hitting token limits
- Include focus instructions for better results
- Removes redundant information while preserving key context

#### `/status`
Check session state and token usage
```
/status
# Shows:
# - Current token count
# - Session ID
# - Active working directory
# - Available tools
# - Memory files loaded
```

### Memory Management

#### `/init`
Initialize project-specific CLAUDE.md
```
/init
# Creates ./CLAUDE.md with intelligent defaults
# Analyzes project to suggest appropriate rules
```

#### `/memory add <content>`
Add memory inline
```
/memory add Always use TypeScript for new files
/memory add Prefer functional components in React
```

#### `/memory list`
Show all active memories
```
/memory list
# Displays:
# - Project memories (./CLAUDE.md)
# - User memories (~/.claude/CLAUDE.md)
# - Imported memories
```

### Tool Control

#### `/permissions`
Manage tool permissions interactively
```
/permissions
# Opens interactive menu to:
# - Enable/disable specific tools
# - Set permission levels
# - Configure safety settings
```

#### `/tools`
List available tools and their status
```
/tools
# Shows all tools with:
# - Enabled/disabled status
# - Usage statistics
# - Recent errors
```

### MCP (Model Context Protocol)

#### `/mcp`
Manage MCP servers
```
/mcp
# List connected servers

/mcp connect database
# Connect to configured server

/mcp disconnect database
# Disconnect server

/mcp refresh
# Reload server configurations
```

#### `/mcp__<server>__<prompt>`
Direct MCP server commands
```
/mcp__database__show tables
/mcp__kubernetes__get pods
/mcp__git__recent commits
```

### Advanced Features

#### `/vim`
Toggle vim mode
```
/vim
# Enables vim keybindings
# Great for power users
# Toggle off with /vim again
```

#### `/diff`
Show recent changes
```
/diff
# Shows all file modifications in current session
# Useful before committing
```

#### `/undo`
Undo last file modification
```
/undo
# Reverts most recent file change
# Can be used multiple times
```

#### `/add-dir <path>`
Add directory to context
```
/add-dir ../shared-utils
# Allows Claude to access files from additional directories
# Useful for monorepos or related projects
```

### Custom Commands

#### `/command-name [arguments]`
Execute custom commands from ~/.claude/commands/
```
/review src/api.py
# Runs custom review command

/deploy staging
# Runs custom deployment command
```

### Hidden & Undocumented Commands 🔐

#### Thinking Tiers (Undocumented)
Activate different levels of Claude's reasoning:
```bash
# Tier 1: Standard (default)
claude -p "solve this problem"

# Tier 2: Deep thinking
claude -p "think deeply about this architectural challenge"

# Tier 3: Ultra thinking (maximum reasoning)
claude -p "ultrathink through this complex system design"
```

**When to use:**
- **Standard**: Quick tasks, simple code changes
- **Deep thinking**: Architecture decisions, complex debugging
- **Ultrathink**: System design, critical problem solving

#### Secret CLI Flags
```bash
# Skip all permission prompts (use with caution!)
claude -p "task" --dangerously-skip-permissions

# Add custom MCP tool for dynamic permissions
claude -p "task" --permission-prompt-tool "mcp__security__validator"

# Append to system prompt (advanced customization)
claude -p "task" --append-system-prompt "Always consider security implications"

# Set custom output format
claude -p "generate code" --output-format json | jq -r '.result'

# Limit Claude's autonomy
claude -p "complex task" --max-turns 3

# Continue most recent session
claude --continue

# Resume specific session
claude --resume "session-123abc"
```

#### Hidden Session Commands
```bash
# Project session tracking (from claude-sessions)
/project:session-start    # Begin tracked development session
/project:session-update   # Auto-summarize progress
/project:session-end      # Generate comprehensive summary

# Advanced context management
/context:save <name>      # Save current context state
/context:load <name>      # Load saved context
/context:merge <name>     # Merge contexts

# Memory persistence
/memory:snapshot          # Create memory checkpoint
/memory:restore <id>      # Restore from checkpoint
```

#### Undocumented Productivity Commands
```bash
# Fast commit with auto-message
/commit-fast              # Uses first suggestion immediately

# Advanced analysis
/five                     # Five Whys root cause analysis
/tech-debt-hunt          # Find technical debt patterns
/security-audit          # Security vulnerability scan

# Diagram generation
/mermaid <type>          # Generate any Mermaid diagram
/architecture            # Auto-generate architecture diagrams

# Browser automation
/safari-automation       # Control Safari for testing
```

#### Performance & Analytics
```bash
# Token usage tracking
/token:usage             # Current session token count
/token:forecast          # Predict token usage
/token:optimize          # Suggest token reduction

# Performance monitoring  
/perf:start             # Start performance tracking
/perf:stop              # Stop and show metrics
/perf:report            # Detailed performance analysis
```

---

## CLI Navigation Patterns {#navigation}

### Efficient Prompt Construction

#### 1. Direct Task Assignment
```
❌ Verbose:
"Hey Claude, I was wondering if you could help me with refactoring 
this function to be more efficient..."

✅ Efficient:
"Refactor user.py:45-67 for performance"
```

#### 2. Chained Operations
```
# Using && for sequential tasks
Review auth.py && Fix any security issues found && Run tests

# Using ; for independent tasks
Check test coverage; Update documentation; Format code
```

#### 3. Contextual References
```
# Reference previous outputs
Based on the analysis above, implement option 2

# Reference specific files/lines
Apply the same pattern to all functions in api.py

# Reference external context
Following our team standards in CLAUDE.md, review this PR
```

### Working with Long Outputs

#### 1. Interrupt and Refocus
```
[Claude generating long response...]
Ctrl+C
"Just show me the main function"
```

#### 2. Request Summaries
```
# Instead of full implementation
"Show me the structure/outline first"

# Instead of full file read
"What are the main functions in user.py?"
```

#### 3. Progressive Refinement
```
"Create a user authentication system"
# Review outline
"Now implement just the login function"
# Review implementation  
"Add error handling to login"
```

---

## Advanced CLI Techniques {#advanced-cli}

### Prompt Engineering for CLI

#### 1. Structured Prompts
```
Task: Refactor payment processing
Context: High-traffic e-commerce site
Requirements:
- Maintain backward compatibility
- Improve error handling
- Add comprehensive logging
Constraints:
- No external dependencies
- Must pass existing tests
```

#### 2. Think Modes
```
# Standard thinking
"think about the best approach for caching"

# Deeper analysis
"think harder about potential race conditions"

# Extended consideration
"think more about the security implications"
```

#### 3. Output Control
```
# Concise outputs
"List the functions in api.py (just names)"

# Detailed analysis
"Explain each function in api.py with examples"

# Specific format
"Show the class structure as a tree"
```

### Workflow Optimization

#### 1. Session Aliases
```bash
# In your shell config
alias claude-work='claude --session work --allowedTools "all"'
alias claude-safe='claude --session safe --allowedTools "Read,Grep"'
alias claude-review='claude --session review -p "Review mode: focus on code quality"'
```

#### 2. Template Prompts
```bash
# Create prompt templates
cat > ~/.claude/prompts/debug.txt << 'EOF'
Debug the issue: $1
1. Reproduce the problem
2. Identify root cause  
3. Propose fix with tests
4. Verify no regressions
EOF

# Use with:
claude -p "$(cat ~/.claude/prompts/debug.txt | sed 's/$1/login error/')"
```

#### 3. Context Preloading
```bash
# Preload common context
claude --session daily << 'EOF'
/add-dir ~/work/frontend
/add-dir ~/work/backend  
/memory add Use our standard error handling pattern
/memory add All new endpoints need tests
Today's focus: API v2 migration
EOF
```

## GitHub Actions Integration {#github-actions}

### Automated Claude Code in CI/CD

#### Basic GitHub Action Setup
```yaml
name: Claude Code Review
on: [pull_request]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Claude Code Review
        uses: anthropics/claude-code-action@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Review this PR for bugs, security issues, and best practices"
```

#### Advanced Workflows

##### Automated Code Generation
```yaml
- name: Generate Missing Tests
  uses: anthropics/claude-code-action@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Generate comprehensive unit tests for all untested functions"
    commit-message: "test: add missing unit tests"
    create-pr: true
```

##### Documentation Updates
```yaml
- name: Update Documentation
  uses: anthropics/claude-code-action@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Update README and API docs based on code changes"
    files: "README.md,docs/api.md"
    commit-message: "docs: update documentation"
```

##### Security Scanning
```yaml
- name: Security Audit
  uses: anthropics/claude-code-action@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Perform security audit and fix vulnerabilities"
    model: claude-sonnet-4
    max-turns: 5
```

#### CLI Commands for GitHub Integration
```bash
# Generate GitHub Action workflow
claude -p "Create GitHub Action for automated testing"

# Review PR from CLI
claude -p "Review PR #123" --allowedTools "mcp__github__*"

# Generate release notes
git log --oneline v1.0..HEAD | claude -p "Generate release notes"
```

#### Best Practices
1. **Use specific models**: claude-sonnet-4 for complex tasks
2. **Limit scope**: Target specific files or directories
3. **Set max-turns**: Prevent runaway operations
4. **Use environment secrets**: Never hardcode API keys
5. **Create PRs**: Don't push directly to main

---

## Productivity Shortcuts {#productivity}

### Quick Patterns

#### 1. Rapid File Navigation
```
# Instead of multiple reads
"Show all Python files with 'user' in the name"

# Quick content search
"Find all TODO comments in the codebase"

# Smart jumping
"Go to the authentication logic"
```

#### 2. Batch Operations
```
# Multiple file analysis
"Compare the error handling in all API endpoints"

# Bulk updates
"Add logging to all database queries"

# Pattern application
"Apply the repository pattern to all services"
```

#### 3. Smart Completions
```
# Use partial prompts
"impl user auth"  # Claude infers "implement user authentication"

# Use abbreviations
"ref calc_price fn"  # "refactor calculate_price function"

# Context-aware shortcuts
"fix"  # Claude uses recent error context
"continue"  # Claude continues previous task
```

### CLI Power Combos

#### 1. The Quick Fix
```
Ctrl+R  # Search for previous error
Enter   # Re-run command that caused error
"fix"   # Claude fixes based on error context
```

#### 2. The Clean Slate
```
/compact focus current bug
/clear
"Let's tackle this systematically"
```

#### 3. The Review Loop
```
/diff
/review changes
"Address the review comments"
/diff
```

---

## Session Management {#session-management}

### Effective Session Strategies

#### 1. Named Sessions for Context
```bash
# Project-specific sessions
claude --session frontend-auth
claude --session backend-api
claude --session devops-ci

# Task-specific sessions  
claude --session bug-fix-142
claude --session feature-payments
```

#### 2. Session Switching Workflow
```
# In session 1
"Save progress on auth implementation"
/status  # Note session ID
Ctrl+D

# Start session 2
claude --session different-task

# Return to session 1
claude --continue
# or
claude --resume [session-id]
```

#### 3. Parallel Sessions
```bash
# Terminal 1: Frontend
claude --session frontend

# Terminal 2: Backend
claude --session backend  

# Terminal 3: Integration
claude --session integration
```

### Session Best Practices

1. **Name Meaningfully**: Use descriptive session names
2. **Clean Regularly**: Use `/compact` to manage token usage
3. **Document Switches**: Note why you switched sessions
4. **Resume Promptly**: Don't let sessions get stale

---

## Output Control {#output-control}

### Managing Claude's Responses

#### 1. Conciseness Control
```
# Ultra-concise
"Fix syntax error in api.py (just show the fix)"

# Balanced
"Explain and fix the syntax error in api.py"

# Detailed
"Analyze the syntax error in api.py, explain why it occurred, show the fix, and suggest preventions"
```

#### 2. Format Specifications
```
# List format
"Show all functions (as a bullet list)"

# Table format
"Compare the three approaches (as a table)"

# Code-only
"Implement user auth (code only, no explanation)"
```

#### 3. Progressive Detail
```
# Start high-level
"Outline the refactoring approach"

# Drill down
"Detail step 3 about database changes"

# Zoom in
"Show the exact SQL migration for user table"
```

---

## Quick Reference Card {#quick-reference}

### Essential Hotkeys
```
Ctrl+C      - Interrupt Claude
Ctrl+D      - Exit session
Ctrl+L      - Clear screen
Ctrl+R      - Search history
Tab         - Autocomplete
Alt+Enter   - Multi-line input
```

### Most Used Slash Commands
```
/help       - Show all commands
/clear      - Clear screen (keep context)
/compact    - Compress conversation
/status     - Check tokens & state
/init       - Create CLAUDE.md
/vim        - Toggle vim mode
/diff       - Show changes
/undo       - Undo last change
```

### Power User Combos
```
think harder            - Deep analysis
/compact focus X       - Smart compression
/add-dir path          - Multi-project work
/mcp                   - External integrations
```

### Efficiency Patterns
```
# Quick review
/review file.py

# Fast fix
Ctrl+R → "fix"

# Clean context
/compact → /clear

# Session switch
Ctrl+D → claude --continue
```

### Common Workflows
```
# Start of day
claude --continue
/status
"What were we working on?"

# Before big task
/compact
/clear
"Let's plan this feature"

# End of day
"Summarize today's progress"
/status
Ctrl+D
```

---

## Pro Tips

1. **Learn 5 commands per day**: Focus on muscle memory
2. **Use `/status` frequently**: Monitor token usage
3. **Name sessions meaningfully**: Easier to resume
4. **Create command aliases**: Speed up common tasks
5. **Think in contexts**: Use `/compact` strategically
6. **Interrupt freely**: Ctrl+C to refocus Claude
7. **Experiment with prompts**: Find your style
8. **Use vim mode**: If you're already comfortable
9. **Chain operations**: Use && and ; effectively
10. **Stay organized**: Clear regularly, compact smartly

Remember: The CLI is designed for speed. The more you use keyboard shortcuts and slash commands, the more productive you'll become. Practice these patterns daily and they'll become second nature!